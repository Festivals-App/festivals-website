
<h1 align="center">
    FestivalsApp: Website
</h1>

<p align="center">
    <a href="https://img.shields.io/mozilla-observatory/grade/simonsapps.de?publish" title="Latest Results"><img src="https://img.shields.io/mozilla-observatory/grade/festivalsapp.org?publish" alt="Mozilla HTTP Observatory Grade"></a>
    <a href="https://github.com/Festivals-App/festivals-website/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/Festivals-App/festivals-website?style=flat"></a>
   <a href="https://github.com/festivals-app/festivals-website/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/festivals-app/festivals-website?style=flat"></a>
   <a href="./LICENSE" title="License"><img src="https://img.shields.io/github/license/festivals-app/festivals-website.svg"></a>
</p>

<p align="center">
  <a href="#development">Development</a> •
  <a href="#deployment">Deployment</a> • 
  <a href="#documentation-architecture">Documentation & Architecture</a> •
  <a href="#Engage--feedback">Engage & Feedback</a> •
  <a href="#licensing">Licensing</a> •
  <a href="https://festivalsapp.org">Website</a>
</p>

This repository contains the source files of the official website for the FestivalsApp as it is available at [festivalsapp.org](https://festivalsapp.org/).

## Development

I have a rather custom development workflow for the FestvialsApp website. This is probably due to my dislike for website development: i can't bring myself to learn the conventional ways.
Though unconventional, it is quite straight forward as the website only uses html, css and a little bit of php for the contact form. 

All necessary files are in the [source](./source) folder waiting to get compiled by the compile script which is minifying and merging those files and is outputting the result to a folder called "build". This folder now contains a new folder with the current timestamp as its name and a folder called "current". The "current" folder will always contain the newest compiled files, and can be used to check the latest changes to the source files using a browser.

I use [Visual Studio Code](https://code.visualstudio.com/), as it is super easy to run the compile script with just a shortcut (Shift+Cmd+B) and i don't have any preferences when developing websites.

The key requirements for the website are: fast, easy to update, open source, accessible([*](https://github.com/Festivals-App/festivals-website/issues/1)) and secure.
 
### Requirements

- [Bash script](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) friendly environment
- [Visual Studio Code](https://code.visualstudio.com/download) 1.57.1+
    * Plugin recommendations for VSCode are managed via [workspace recommendations](https://code.visualstudio.com/docs/editor/extension-marketplace#_recommended-extensions).
- [minify](https://github.com/tdewolff/minify)
    * For installation on macOS via homebrew see [here](https://github.com/tdewolff/minify/issues/253).

### Setup

[Visual Studio Code](https://code.visualstudio.com/download) and [minify](https://github.com/tdewolff/minify) are open source projects which can be installed on almost any operating system, see the project websites for instructions. I don't have a special setup in [Visual Studio Code](https://code.visualstudio.com/download) and the provided [configuration files](./.vscode) should let you start right away.


## Deployment

I use [nginx](https://www.nginx.com/) to serve [festivalsapp.org](https://festivalsapp.org/), so the website needs to go to /var/www/festivalsapp.org

Installing
The install script will place all necessary files, but need some additional nginx and ssl setup.
```bash
curl -o install.sh https://raw.githubusercontent.com/Festivals-App/festivals-website/master/operation/install.sh
chmod +x install.sh
sudo ./install.sh
```

Updating
```bash
curl -o update.sh https://raw.githubusercontent.com/Festivals-App/festivals-server/master/operation/update.sh
chmod +x update.sh
sudo ./update.sh
```

Uninstalling
```bash
curl -o uninstall.sh https://raw.githubusercontent.com/Festivals-App/festivals-server/master/operation/uninstall.sh
chmod +x uninstall.sh
sudo ./uninstall.sh
```


# Documentation & Architecture

TBA

The general documentation for the Festivals App is in the [festivals-documentation](https://github.com/festivals-app/festivals-documentation) repository. The documentation repository contains architecture information, general deployment documentation, templates and other helpful documents.


# Engage & Feedback

I welcome every contribution, whether it is a pull request or a fixed typo.

The best place to discuss questions and suggestions regarding the website is the [issues](https://github.com/festivals-app/festivals-website/issues/) section on github. If this doesn't fit you proposal or reason to contact me, there are some more general purpose communication channels where you can reach me, listed in the following table.

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **General Discussion**   | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="General Discussion"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/question.svg?style=flat-square"></a> </a>   |
| **Other Requests**    | <a href="mailto:simon.cay.gaus@gmail.com" title="Email me"><img src="https://img.shields.io/badge/email-Simon-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |


## Licensing

Copyright (c) 2017-2021 Simon Gaus.

Licensed under the **GNU Lesser General Public License v3.0** (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at https://www.gnu.org/licenses/lgpl-3.0.html.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the [LICENSE](./LICENSE) for the specific language governing permissions and limitations under the License.
