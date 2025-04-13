# Development Deployment

This deployment guide explains how to deploy the FestivalsApp Website using certificates intended for development purposes.

## Prerequisites

This guide assumes you have already created a Virtual Machine (VM) following the [VM deployment guide](https://github.com/Festivals-App/festivals-documentation/tree/main/deployment/vm-deployment).

Before starting the installation, ensure you have:

- Created and configured your VM
- SSH access secured and logged in as the new admin user
- Your server's IP address (use `ip a` to check)
- A server name matching the Common Name (CN) for your server certificate (e.g., `website-0.festivalsapp.home` for a hostname `website-0`).
- The server name of the database server (For example: `website-0.festivalsapp.home`)

I use the development wildcard server certificate (`CN=*festivalsapp.home`) for this guide.

  > **DON'T USE THIS IN PRODUCTION, SEE [festivals-pki](https://github.com/Festivals-App/festivals-pki) FOR SECURITY BEST PRACTICES FOR PRODUCTION**

## 1. Installing the FestivalsApp Website

Run the following commands to download and install the FestivalsApp Website:

```bash
curl -o install.sh https://raw.githubusercontent.com/Festivals-App/festivals-website/master/operation/install.sh
chmod +x install.sh
sudo ./install.sh
```

The config file is located at:

  > `/etc/festivals-website-node.conf`.

You also need to provide certificates in the right format and location:

  > Root CA certificate                 `/usr/local/festivals-website-node/ca.crt`  
  > Server certificate is               `/usr/local/festivals-website-node/server.crt`  
  > Server key is                       `/usr/local/festivals-website-node/server.key`

Where the root CA certificate is required to validate incoming requests and the server certificate and key is requires to make outgoing connections.
For instructions on how to manage and create the certificates see the [festivals-pki](https://github.com/Festivals-App/festivals-pki) repository.

## 2. Copying mTLS and Database Client Certificates to the VM

Copy the server mTLS certificates from your development machine to the VM:

```bash
scp /opt/homebrew/etc/pki/ca.crt <user>@<ip-address>:.
scp /opt/homebrew/etc/pki/issued/server.crt <user>@<ip-address>:.
scp /opt/homebrew/etc/pki/private/server.key <user>@<ip-address>:.
```

Once copied, SSH into the VM and move them to the correct location:

```bash
sudo mv ca.crt /usr/local/festivals-website-node/ca.crt
sudo mv server.crt /usr/local/festivals-website-node/server.crt
sudo mv server.key /usr/local/festivals-website-node/server.key
```

Set the correct permissions:

```bash
# Change owner to web user
sudo chown www-data:www-data /usr/local/festivals-website-node/ca.crt
sudo chown www-data:www-data /usr/local/festivals-website-node/server.crt
sudo chown www-data:www-data /usr/local/festivals-website-node/server.key
# Set secure permissions
sudo chmod 640 /usr/local/festivals-website-node/ca.crt
sudo chmod 640 /usr/local/festivals-website-node/server.crt
sudo chmod 600 /usr/local/festivals-website-node/server.key
```

## 3. Configuring the FestivalsApp Website Node

Open the configuration file:

```bash
sudo nano /etc/festivals-website-node.conf
```

Set the server name, heartbeat endpoint and authentication endpoint:

```ini
[service]
bin-host = "<server name>"
# For example:
# bind-address = "website-0.festivalsapp.home"

[heartbeat]
endpoint = "<discovery endpoint>"
#For example: endpoint = "https://discovery.festivalsapp.home/loversear"

[authentication]
endpoint = "<authentication endpoint>"
# endpoint = "https://identity-0.festivalsapp.home:22580"
```

Let's start FestivalsApp Website Node

```bash
sudo systemctl start festivals-website-node
```

## 4. Configure the HTTPS Certificates for the Website

Let's install and run [certbot](https://certbot.eff.org/) to automate HTTPS certificate creation and renewal. We also need to start NGINX in order for certbot to work. We don't need to allow trafic on the port 8000 in ufw because the install script installed and linked a NGINX configuration that will forward traffic from port 80 to port 8000.

```bash
sudo apt install certbot
sudo systemctl start nginx
sudo certbot certonly  --standalone  --http-01-port 8000  --deploy-hook 'systemctl reload nginx'  --cert-name festivalsapp.org  -d festivalsapp.org,www.festivalsapp.org
```

Create the DH parameters with OpenSSL, this may take a few minutes

 ```bash
 sudo mkdir /etc/nginx/ssl
 sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096
 ```

Now we can link the NGINX configuration for the website to the enabled sites directory and restart NGINX:

```bash
sudo ln -s /etc/nginx/sites-available/festivalsapp.org /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## **🚀 The festivalsapp website and website node should now be running successfully. 🚀**

### Optional: Setting Up DNS Resolution  

For the services in the FestivalsApp backend to function correctly, proper DNS resolution is required.
This is because mTLS is configured to validate the client’s certificate identity based on its DNS hostname.  

If you don’t have a DNS server to manage DNS for your development VMs, you can manually configure DNS resolution
by adding the necessary entries to each server’s `/etc/hosts` file:  

```bash
sudo nano /etc/hosts
```

Add the following entries:  

```ini
<ip address> <server name>
<identity ip address> <heartbeat endpoint name>
<identity ip address> <auth endpoint name>
...

# Example:  
# 192.168.8.188 website-0.festivalsapp.home
# 192.168.8.186 discovery.festivalsapp.home
# 192.168.8.185 identity-0.festivalsapp.home
# 192.168.8.188 www.festivalsapp.home
# 192.168.8.188 festivalsapp.home
# ...
```

**Keep in mind that you will need to update each machine’s `hosts` file whenever you add a new VM or if any IP addresses change.**

## Testing

Lets login as the default admin user and get the server info:

```bash
curl -H "Api-Key: TEST_API_KEY_001" -u "admin@email.com:we4711" --cert /opt/homebrew/etc/pki/issued/api-client.crt --key /opt/homebrew/etc/pki/private/api-client.key --cacert /opt/homebrew/etc/pki/ca.crt https://identity-0.festivalsapp.home:22580/users/login
```

This should return a JWT Token `<Header.<Payload>.<Signatur>`

  > eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.
  > eyJVc2VySUQiOiIxIiwiVXNlclJvbGUiOjQyLCJVc2VyRmVzdGl2YWxzIjpbXSwiVXNlckFydGlzdHMiOltdLCJVc2VyTG9jYXRpb25zIjpbXSwiVXNlckV2ZW50cyI6W10sIlVzZXJMaW5rcyI6W10sIlVzZXJQbGFjZXMiOltdLCJVc2VySW1hZ2VzIjpbXSwiVXNlclRhZ3MiOltdLCJpc3MiOiJpZGVudGl0eS0wLmZlc3RpdmFsc2FwcC5ob21lIiwiZXhwIjoxNzQwMjMxMTQ4fQ.
  > geBq1pxEvqwjnKA5YTHQ8IjJc9mwkpsQIRy1kGc63oNXzyAhPrPJsepICXxr2yVmB0E8oDECXLn4Cy5V_p4UAduWXnc0r8S05ijV8NCfmsEcJg-RRO8POkGykiC2mrn-XR8Nf8OF0fLp7Mhsb0_aqBoTOLdtB9V7IV49-JjWwX5gHl3HuXGOOhe4n_epumc8w8yDxYakWeaBFtEtaRmhFXK_yttexYOLP6Z1BBTL005hBGhO58qVW0cfgf_t5VWBpUnz3zqdC-GFegItqJQbKZ2pmfmXNz_AoJf2JmPtCzpJ4lG6QeSslvdFuwaCdYpDQPOvnMSIORwrAq_FL2m7qw

Use this to make authorized calls to the festivals server:

```bash
curl -H "Api-Key: TEST_API_KEY_001" -H "Authorization: Bearer <JWT>" --cert /opt/homebrew/etc/pki/issued/api-client.crt --key /opt/homebrew/etc/pki/private/api-client.key --cacert /opt/homebrew/etc/pki/ca.crt https://website-0.festivalsapp.home:48155/info
```
