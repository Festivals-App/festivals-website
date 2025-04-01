# Operation

The `operation` directory contains all configuration templates and scripts to install and run the festvials-website.

* `certbot-config` (unused atm)
* `certbot-init.sh` (unused atm)
* `install.sh` script to install the festivals-website-node and website on a VM
* `nginx-config` nginx configuration template for the website
* `service_template.service` festivals-website-node unit file for `systemctl`
* `ufw_app_profile` firewall app profile file for `ufw`
* `update_node.sh` script to update the festivals-website-node
* `update_website.sh` script to update the website

## Deployment

Follow the [**deployment guide**](DEPLOYMENT.md) for deploying the festivals-fileserver inside a virtual machine or the [**local deployment guide**](./local/README.md) for running it on your macOS developer machine.
