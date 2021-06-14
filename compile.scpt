-- To run in VS Code press shift+alt+R


-- set paths
set source_path to POSIX path of ((path to me as text) & "::") & "source"
set current_time to do shell script ("date +%Y%m%d-%H-%M-%S" as text)
set build_path to POSIX path of ((path to me as text) & "::") & "build/" & current_time
set current_build_path to POSIX path of ((path to me as text) & "::") & "build/current"

-- copy top level files
try
	do shell script "mkdir " & build_path
	do shell script "cp " & source_path & "/* " & build_path
end try

-- concat & minify css
try
	set css_source_path to source_path & "/css"
	set css_build_path to build_path & "/css"
	set temp_css_file to build_path & "/css/temp_css_file.css"
	set min_css_file to build_path & "/css/style.min.css"
	do shell script "mkdir " & css_build_path
	do shell script "find " & css_source_path & " -name '*.css' -exec cat {} + > " & temp_css_file
	do shell script "minify -o " & min_css_file & " " & temp_css_file
	do shell script "rm " & temp_css_file
end try

-- copy other folders
try
	set php_source_path to source_path & "/php"
	set en_source_path to source_path & "/en"
	set images_source_path to source_path & "/images"
	
	do shell script "cp -r " & php_source_path & " " & build_path
	do shell script "cp -r " & en_source_path & " " & build_path
	do shell script "cp -r " & images_source_path & " " & build_path
end try

-- copy files to current build folder
try
	do shell script "rm -rf " & current_build_path
	do shell script "mkdir -p " & current_build_path
	do shell script "cp -r " & build_path & "/* " & current_build_path
end try

return temp_css_file