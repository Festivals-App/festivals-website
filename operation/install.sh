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

echo -e "\n👤  Web server user detected: \e[1;34m$WEB_USER\e[0m"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📦 Install NGINX
# ─────────────────────────────────────────────────────────────────────────────
echo -e "\n\n\n🚀  Installing NGINX ..."
apt-get install nginx -y > /dev/null 2>&1
echo -e "\n✅  NGINX installed.\n"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📁 Setup Website Working Directory
# ─────────────────────────────────────────────────────────────────────────────
WORK_DIR="/usr/local/festivals-website/install"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR" || { echo -e "\n\033[1;31m❌  ERROR: Failed to create/access working directory!\033[0m\n"; exit 1; }

echo -e "\n📂  Working directory set to \e[1;34m$WORK_DIR\e[0m\n"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🌐 Download and Deploy Festivals Website
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\n\n📥  Downloading latest Festivals Website release..."
sleep 1

file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website.tar.gz"
curl --progress-bar -L "$file_url" -o festivals-website.tar.gz

echo -e "\n📦  Extracting website files..."
tar -xzf festivals-website.tar.gz && rm -f festivals-website.tar.gz
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# ⚙️  Configure Nginx
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n🛠️  Installing Nginx configuration..."
mkdir -p /etc/nginx/sites-available || { echo -e "\n🚨  ERROR: Failed to create /etc/nginx/sites-available directory. Exiting."; exit 1; }

mv nginx-config /etc/nginx/sites-available/festivalsapp.org
ln -sf /etc/nginx/sites-available/festivalsapp.org /etc/nginx/sites-enabled/

echo -e "\n✅  Successfully installed Nginx configuration for FestivalsApp.org."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 Prepare Remote Website Update Workflow
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\n\n⚙️  Preparing remote website update workflow..."
sleep 1

mv update_website.sh /usr/local/festivals-website/update.sh
chmod +x /usr/local/festivals-website/update.sh

cp /etc/sudoers /tmp/sudoers.bak
echo "$WEB_USER ALL = (ALL) NOPASSWD: /usr/local/festivals-website/update.sh" >> /tmp/sudoers.bak

# Validate and replace sudoers file if syntax is correct
if visudo -cf /tmp/sudoers.bak &>/dev/null; then
    sudo cp /tmp/sudoers.bak /etc/sudoers
    echo -e "\n✅  Updated sudoers file successfully."
else
    echo -e "\n🚨  ERROR: Could not modify /etc/sudoers file. Please do this manually. Exiting.\n"
    exit 1
fi
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📂 Install Website Files
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n📂  Moving website files to '/var/www/festivalsapp.org/'..."
sleep 1

mkdir -p /var/www/festivalsapp.org
cp -a ./. /var/www/festivalsapp.org/

echo -e "\n✅  Website files successfully moved."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📁 Setup Sidecar Working Directory
# ─────────────────────────────────────────────────────────────────────────────
WORK_DIR="/usr/local/festivals-website-node/install"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR" || { echo -e "\n\033[1;31m❌  ERROR: Failed to create/access working directory!\033[0m\n"; exit 1; }

echo -e "\n📂  Working directory set to \e[1;34m$WORK_DIR\e[0m\n"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🖥  Detect System OS and Architecture
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\n\n🔍  Detecting system OS and architecture..."
sleep 1

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

echo -e "\n✅  Detected OS: \e[1;34m$os\e[0m, Architecture: \e[1;34m$arch\e[0m."
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📦 Install FestivalsApp Website Node
# ─────────────────────────────────────────────────────────────────────────────

file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website-node-$os-$arch.tar.gz"

echo -e "\n📥  Downloading latest FestivalsApp Website Node binary..."
curl --progress-bar -L "$file_url" -o festivals-website-node.tar.gz

echo -e "\n📦  Extracting binary..."
tar -xf festivals-website-node.tar.gz

mv festivals-website-node /usr/local/bin/festivals-website-node || {
    echo -e "\n🚨  ERROR: Failed to install FestivalsApp Website Node binary. Exiting.\n"
    exit 1
}

echo -e "\n✅  Installed FestivalsApp Website Node to \e[1;34m/usr/local/bin/festivals-website-node\e[0m.\n"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🛠  Install Server Configuration File
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\n\n📂  Moving default configuration file..."
mv config_template.toml /etc/festivals-website-node.conf

if [ -f "/etc/festivals-website-node.conf" ]; then
    echo -e "\n✅  Configuration file moved to \e[1;34m/etc/festivals-website-node.conf\e[0m.\n"
else
    echo -e "\n🚨  ERROR: Failed to move configuration file. Exiting.\n"
    exit 1
fi
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 📂  Prepare Log Directory
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\n\n📁  Creating log directory..."
mkdir -p /var/log/festivals-website-node || {
    echo -e "\n🚨  ERROR: Failed to create log directory. Exiting.\n"
    exit 1
}

echo -e "\n✅  Log directory created at \e[1;34m/var/log/festivals-website-node\e[0m.\n"
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 Prepare Remote Update Workflow
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\n\n⚙️  Preparing remote update workflow..."
sleep 1

mv update_node.sh /usr/local/festivals-website-node/update.sh
chmod +x /usr/local/festivals-website-node/update.sh

cp /etc/sudoers /tmp/sudoers.bak
echo "$WEB_USER ALL = (ALL) NOPASSWD: /usr/local/festivals-website-node/update.sh" >> /tmp/sudoers.bak

# Validate and replace sudoers file if syntax is correct
if visudo -cf /tmp/sudoers.bak &>/dev/null; then
    sudo cp /tmp/sudoers.bak /etc/sudoers
    echo -e "\n✅  Updated sudoers file successfully."
else
    echo -e "\n🚨  ERROR: Could not modify /etc/sudoers file. Please do this manually. Exiting.\n"
    exit 1
fi
sleep 1

# ─────────────────────────────────────────────────────────────────────────────
# 🔥 Enable and Configure Firewall
# ─────────────────────────────────────────────────────────────────────────────

if command -v ufw > /dev/null; then
    echo -e "\n\n\n🚀  Configuring UFW firewall..."
    mv ufw_app_profile /etc/ufw/applications.d/festivals-website-node
    ufw allow festivals-website-node > /dev/null
    echo -e "\n✅  Added festivals-website-node to UFW with port 48155."
    sleep 1
    ufw allow 'Nginx Full' > /dev/null
    echo -e "\n✅  Added NGINX to UFW with standard ports 80/443."
    sleep 1
elif ! [ "$(uname -s)" = "Darwin" ]; then
    echo -e "\n🚨  ERROR: No firewall detected and not on macOS. Exiting.\n"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# ⚙️  Install Systemd Service
# ─────────────────────────────────────────────────────────────────────────────

if command -v service > /dev/null; then
    echo -e "\n\n\n🚀  Configuring systemd service..."
    if ! [ -f "/etc/systemd/system/festivals-website-node.service" ]; then
        mv service_template.service /etc/systemd/system/festivals-website-node.service
        echo -e "\n✅  Created systemd service configuration."
        sleep 1
    fi
    systemctl enable festivals-website-node > /dev/null
    echo -e "\n✅  Enabled systemd service for FestivalsApp Website Node."
    sleep 1
    systemctl enable nginx > /dev/null
    echo -e "\n✅  Enabled systemd service for NGINX."
    sleep 1
elif ! [ "$(uname -s)" = "Darwin" ]; then
    echo -e "\n🚨  ERROR: Systemd is missing and not on macOS. Exiting.\n"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 🔑 Set Appropriate Permissions
# ─────────────────────────────────────────────────────────────────────────────

echo -e "\n\n\n🔑  Setting appropriate permissions..."
sleep 1

chown -R "$WEB_USER":"$WEB_USER" /var/www/festivalsapp.org
chown -R "$WEB_USER":"$WEB_USER" /usr/local/festivals-website
chmod -R 755 /var/www/festivalsapp.org

chown -R "$WEB_USER":"$WEB_USER" /usr/local/festivals-website-node
chown -R "$WEB_USER":"$WEB_USER" /var/log/festivals-website-node
chown "$WEB_USER":"$WEB_USER" /etc/festivals-website-node.conf

echo -e "\n✅  Set Appropriate Permissions.\n"
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

echo -e "\n\n\n\n\033[1;32m══════════════════════════════════════════════════════════════════════════\033[0m"
echo -e "\033[1;32m✅  INSTALLATION COMPLETE! 🚀\033[0m"
echo -e "\033[1;32m══════════════════════════════════════════════════════════════════════════\033[0m"

echo -e "\n🔹 \033[1;34mTo start the server manually, run:\033[0m"
echo -e "\n   \033[1;32msudo systemctl start festivals-website-node\033[0m"
echo -e "\n   \033[1;32msudo systemctl start nginx\033[0m"

echo -e "\n📂 \033[1;34mBefore starting, update the configuration file at:\033[0m"
echo -e "\n   \033[1;34m/etc/festivals-website-node.conf\033[0m"

echo -e "\n\033[1;32m══════════════════════════════════════════════════════════════════════════\033[0m\n"
sleep 1
 