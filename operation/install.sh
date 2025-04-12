#!/bin/bash
#
# install.sh - FestivalsApp Website Install Script
# 
# (c)2020-2025 Simon Gaus
#

# ─────────────────────────────────────────────────────────────────────────────
# 🔍 Detect Web Server User
# ─────────────────────────────────────────────────────────────────────────────
WEB_USER="www-data"
if ! id -u "$WEB_USER" &>/dev/null; then
    WEB_USER="www"
    if ! id -u "$WEB_USER" &>/dev/null; then
        echo -e "\n\033[1;31m❌  ERROR: Web server user not found! Exiting.\033[0m\n"
        exit 1
    fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📁 Setup Website Working Directory
# ─────────────────────────────────────────────────────────────────────────────
WORK_DIR="/usr/local/festivals-website/install"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR" || { echo -e "\n\033[1;31m❌  ERROR: Failed to create/access working directory!\033[0m\n"; exit 1; }
echo -e "\n📂  Working directory set to \e[1;34m$WORK_DIR\e[0m"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🌐 Download and Deploy Festivals Website
# ─────────────────────────────────────────────────────────────────────────────
echo -e "\n📥  Downloading latest Festivals Website release..."
file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website.tar.gz"
curl --progress-bar -L "$file_url" -o festivals-website.tar.gz
echo -e "📦  Extracting website files..."
tar -xzf festivals-website.tar.gz && rm -f festivals-website.tar.gz

# ─────────────────────────────────────────────────────────────────────────────
# 📦 Install NGINX
# ─────────────────────────────────────────────────────────────────────────────
echo -e "\n🚀  Installing NGINX ..."
apt-get install nginx -y > /dev/null 2>&1
echo -e "✅  NGINX installed."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# ⚙️  Configure Nginx
# ─────────────────────────────────────────────────────────────────────────────
mkdir -p /etc/nginx/sites-available || { echo -e "\n🚨  ERROR: Failed to create /etc/nginx/sites-available directory. Exiting."; exit 1; }
mv nginx-config /etc/nginx/sites-available/festivalsapp.org
ln -sf /etc/nginx/sites-available/festivalsapp.org /etc/nginx/sites-enabled/
echo -e "✅  Successfully installed NGINX configuration for festivalsapp.org."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 Prepare Remote Website Update Workflow
# ─────────────────────────────────────────────────────────────────────────────
mv update_website.sh /usr/local/festivals-website/update.sh
chmod +x /usr/local/festivals-website/update.sh
cp /etc/sudoers /tmp/sudoers.bak
echo "$WEB_USER ALL = (ALL) NOPASSWD: /usr/local/festivals-website/update.sh" >> /tmp/sudoers.bak

# Validate and replace sudoers file if syntax is correct
if visudo -cf /tmp/sudoers.bak &>/dev/null; then
    sudo cp /tmp/sudoers.bak /etc/sudoers
    echo -e "✅  Prepared remote website update workflow."
else
    echo -e "\n🚨  ERROR: Could not modify /etc/sudoers file. Please do this manually. Exiting.\n"
    exit 1
fi
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📂 Install Website Files
# ─────────────────────────────────────────────────────────────────────────────
mkdir -p /var/www/festivalsapp.org
cp -a ./. /var/www/festivalsapp.org/
echo -e "✅  Successfully moved website files to '/var/www/festivalsapp.org/'."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📁 Setup Sidecar Working Directory
# ─────────────────────────────────────────────────────────────────────────────
WORK_DIR="/usr/local/festivals-website-node/install"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR" || { echo -e "\n\033[1;31m❌  ERROR: Failed to create/access working directory!\033[0m\n"; exit 1; }
echo -e "\n📂  Working directory set to \e[1;34m$WORK_DIR\e[0m"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🖥  Detect System OS and Architecture
# ─────────────────────────────────────────────────────────────────────────────
if [ "$(uname -s)" = "Darwin" ]; then
    os="darwin"
elif [ "$(uname -s)" = "Linux" ]; then
    os="linux"
else
    echo -e "\n🚨  ERROR: Unsupported OS. Exiting.\n"
    exit 1
fi
if [ "$(uname -m)" = "x86_64" ]; then
    arch="amd64"
elif [ "$(uname -m)" = "arm64" ]; then
    arch="arm64"
else
    echo -e "\n🚨  ERROR: Unsupported CPU architecture. Exiting.\n"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 📦 Install FestivalsApp Website Node
# ─────────────────────────────────────────────────────────────────────────────
file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website-node-$os-$arch.tar.gz"

echo -e "\n📥  Downloading latest FestivalsApp Website Node release..."
curl --progress-bar -L "$file_url" -o festivals-website-node.tar.gz
echo -e "📦  Extracting binary..."
tar -xf festivals-website-node.tar.gz
mv festivals-website-node /usr/local/bin/festivals-website-node || {
    echo -e "\n🚨  ERROR: Failed to install FestivalsApp Website Node binary. Exiting.\n"
    exit 1
}
echo -e "✅  Installed FestivalsApp Website Node to \e[1;34m/usr/local/bin/festivals-website-node\e[0m."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🛠  Install Server Configuration File
# ─────────────────────────────────────────────────────────────────────────────
mv config_template.toml /etc/festivals-website-node.conf
if [ -f "/etc/festivals-website-node.conf" ]; then
    echo -e "✅  Configuration file moved to \e[1;34m/etc/festivals-website-node.conf\e[0m."
else
    echo -e "\n🚨  ERROR: Failed to move configuration file. Exiting.\n"
    exit 1
fi
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📂  Prepare Log Directory
# ─────────────────────────────────────────────────────────────────────────────
mkdir -p /var/log/festivals-website-node || {
    echo -e "\n🚨  ERROR: Failed to create log directory. Exiting.\n"
    exit 1
}
echo -e "✅  Log directory created at \e[1;34m/var/log/festivals-website-node\e[0m."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 Prepare Remote Update Workflow
# ─────────────────────────────────────────────────────────────────────────────
mv update_node.sh /usr/local/festivals-website-node/update.sh
chmod +x /usr/local/festivals-website-node/update.sh
cp /etc/sudoers /tmp/sudoers.bak
echo "$WEB_USER ALL = (ALL) NOPASSWD: /usr/local/festivals-website-node/update.sh" >> /tmp/sudoers.bak
# Validate and replace sudoers file if syntax is correct
if visudo -cf /tmp/sudoers.bak &>/dev/null; then
    sudo cp /tmp/sudoers.bak /etc/sudoers
    echo -e "✅  Prepared remote update workflow."
else
    echo -e "\n🚨  ERROR: Could not modify /etc/sudoers file. Please do this manually. Exiting.\n"
    exit 1
fi
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🔥 Enable and Configure Firewall
# ─────────────────────────────────────────────────────────────────────────────

if command -v ufw > /dev/null; then
    echo -e "\n🔥  Configuring UFW firewall..."
    mv ufw_app_profile /etc/ufw/applications.d/festivals-website-node
    ufw allow festivals-website-node > /dev/null
    echo -e "✅  Added festivals-website-node to UFW with port 48155."
    sleep 1
    ufw allow 'Nginx Full' > /dev/null
    echo -e "✅  Added NGINX to UFW with standard ports 80/443."
    sleep 1
elif ! [ "$(uname -s)" = "Darwin" ]; then
    echo -e "\n🚨  ERROR: No firewall detected and not on macOS. Exiting.\n"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# ⚙️  Install Systemd Service
# ─────────────────────────────────────────────────────────────────────────────

if command -v service > /dev/null; then
    echo -e "\n🚀  Configuring systemd service..."
    if ! [ -f "/etc/systemd/system/festivals-website-node.service" ]; then
        mv service_template.service /etc/systemd/system/festivals-website-node.service
        echo -e "✅  Created systemd service configuration."
        sleep 1
    fi
    systemctl enable festivals-website-node > /dev/null
    echo -e "✅  Enabled systemd service for FestivalsApp Website Node."
    sleep 1
    systemctl enable nginx > /dev/null
    echo -e "✅  Enabled systemd service for NGINX."
    sleep 1
elif ! [ "$(uname -s)" = "Darwin" ]; then
    echo -e "\n🚨  ERROR: Systemd is missing and not on macOS. Exiting.\n"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 🔑 Set Appropriate Permissions
# ─────────────────────────────────────────────────────────────────────────────
chown -R "$WEB_USER":"$WEB_USER" /var/www/festivalsapp.org
chown -R "$WEB_USER":"$WEB_USER" /usr/local/festivals-website
chmod -R 755 /var/www/festivalsapp.org
chown -R "$WEB_USER":"$WEB_USER" /usr/local/festivals-website-node
chown -R "$WEB_USER":"$WEB_USER" /var/log/festivals-website-node
chown "$WEB_USER":"$WEB_USER" /etc/festivals-website-node.conf
echo -e "\n🔐  Set Appropriate Permissions."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🧹 Cleanup Installation Files
# ─────────────────────────────────────────────────────────────────────────────
echo -e "\n🧹  Cleaning up installation files..."
cd /usr/local/festivals-website || exit
rm -rf cd /usr/local/festivals-website/install
rm -rf cd /usr/local/festivals-website-node/install
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🎉 Final Message
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\033[1;32m══════════════════════════════════════════════════════════════════════════\033[0m"
echo -e "\033[1;32m✅  INSTALLATION COMPLETE! 🚀\033[0m"
echo -e "\033[1;32m══════════════════════════════════════════════════════════════════════════\033[0m"
echo -e "\n📂 \033[1;34mBefore starting, you need to:\033[0m"
echo -e "\n   \033[1;34m1. Configure the mTLS certificates.\033[0m"
echo -e "   \033[1;34m2. Update the configuration file at:\033[0m"
echo -e "\n   \033[1;32m    /etc/festivals-website-node.conf\033[0m"
echo -e "   \033[1;34m3. Update the website configuration file at:\033[0m"
echo -e "\n   \033[1;32m    /etc/nginx/sites-available/festivalsapp.org\033[0m"
echo -e "   \033[1;34m4. Configure certbot to automatically manage website certificates.\033[0m"
echo -e "\n🔹 \033[1;34mThen start the server manually:\033[0m"
echo -e "\n   \033[1;32m    sudo systemctl start festivals-website-node\033[0m"
echo -e "\n   \033[1;32m    sudo systemctl start nginx\033[0m"
echo -e "\n\033[1;32m══════════════════════════════════════════════════════════════════════════\033[0m\n"
sleep 1
 