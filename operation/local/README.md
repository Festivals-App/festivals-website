# Running the webside node locally on you mac

This guide provides instructions for setting up and running the webside node on your macOS machine. Whether you're a new developer or setting up a fresh environment, you'll find everything needed to install dependencies, configure the project, and start development efficiently.  

Before proceeding, ensure you have the required tools installed and follow the steps below to get your local environment up and running smoothly.  

## Prerequisites

- You need to add the development root ca certifiate located at `operation/local/ca.crt` to your systems keychain.
  
    > sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/path-to-new-root-certificate.crt

- As all services communicate based on DNS names you need to add some entries to your `/etc/hosts` file.

```ini
# local development on this machine
127.0.0.1       website-0.festivalsapp.dev
127.0.0.1       identity.festivalsapp.dev
127.0.0.1       discovery.festivalsapp.dev
```

## Running the website node

This project uses Make to streamline local setup and execution. The Makefile includes commands for installing dependencies, configuring the environment, and running the application. Using make ensures a consistent workflow and simplifies common tasks.

1. First you need to build the binary for local development using the `build` command.

    ```bash
    make build
    ```

2. By invoking the `install` command Make will install the newly build binary and all files it needs to run properly. The default install path is a folder inside your users container folder at `~/Library/Containers/org.festivalsapp.project`, this is so you don't need to use `sudo` to install and run the website node.

    > make install
  
3. Now you can run the binary by issuing the `run` command. This will run the binary with the `--container="~/Library/Containers/org.festivalsapp.project"` option, telling the binary that the config file will be located at `~/Library/Containers/org.festivalsapp.project/usr/local/bin/festivals-website-node` instead of the default `/usr/local/bin/festivals-website-node`.

    ```bash
    make run
    ```

4. In order to function properly the website node needs to access the festivals identity service so it's a good idea to let that run at the same time, and as a bonus and to prevent anoying error messages you should run the gateway service too. You can do that with the `run-env` command. To stop the identity and gateway service you can call the `stop-env` command.

    ```bash
    make run-env
    make stop-env
    ```
