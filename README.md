# Sakthi (Sandy) Santhosh - Website Provisioning Scripts (Raspberry Pi)

This repository contains all the files required to get my website up and running on a Raspberry Pi locally and expose it to the Internet.

- **Author:** Sakthi Santhosh
- **Created on:** 19/11/2023

## Introduction

My dream has always been to build a server farm at home, deploy all my services in it and expose it to the public internet for my use. This is the very first step in accomplishing it. This repository contains all the necessary scripts to get my website and my services up and running on a Raspberry Pi. The architecture of the system is discussed below.

## Architecture

The [website](https://sakthisanthosh.in) is a single page application stylized using Bootstrap. Not a lot of effort has been put onto the front-end side, except for its responsiveness and consistency in design. Along with the website runs an Nextcloud AIO application on Docker. While the website is simply served by Nginx, the Nextcloud suite is reverse-proxied to a Apache server running on Docker that acts as the entrypoint to the Nextcloud suite.

On the internet side of things, the domain nameservers are from Cloudflare and the DNS records are hosted by them. My ISP is Airtel and they use CG-NAT (Carrier Grade Network Address Translation). This is a huge cost saving for my ISP as they can lease less IPv4 addresses but a pain in the tooth to expose local devices to the internet. I can use tools like VPN, VPS, Cloudflare Tunnel (a great tool, by the way) etc. to expose my local devices safely to the internet but it adds a whole new level of complexitiy to the system and comes with a lot of caveats. The most convinient option to overcome this is to get rid of IPv4 totally and use IPv6 only. The website runs only on IPv6 and while it is recommended to expose devices with IPv4 or dual-stack configuration, this is the trade-off I had to make for conveniance and simplicity.

## Important Instructions/Pre-requisites

1. Nextcloud AIO stores a lot of data onto the storage device and hence it is taxing to use a microSD card to store its data. I opted out for using an USB3 device of size 16 GB for now to store Nextcloud data alone.

2. You must have a domain name bought from a domain name registrar. I bought my domain name from GoDaddy and transferred the nameservers to Cloudflare as they provide a ton of cool features.

3. Create an `AAAA` DNS record for your website. Also, for the Nextcloud suite, create a `CNAME` record that points the `nextcloud` subdomain to the root domain name.

## Installation

The first step is to boot into the OS. This can be done via SSH. The process of burning the OS and configuring the boot partiton to SSH is a bit tedious, so I'll leave the details of it to you.

Once you've successfully logged-in into the RPi-4, the project can be cloned with the commands below. Ensure you're authenticated with GitHub before performing the action.

```bash
git clone git@github.com:sakthisanthosh010303/website-suite.git
cd ./website-suite/
git submodule update --init
```

Before running the installation script, we must make modifications to the Nginx configuration. Change the `server_name` directive to your website's FQDN. If you're planning to run Nginx on host, then edit the `/nginx/debian.conf` file, else edit the `/nginx/alpine.conf` file.

Now, run the installation script with the following command. This will install Nginx on the host. If you don't prefer it, edit the script and remove it's installation.

```bash
sudo ./scripts/install.sh
```

The instalation will take some time to complete. Once it is done, reboot your instance and return to the shell. We have two options now. It is to run Nginx either on Docker or on host. Let us look into both of them. The SSL certificates must be placed at `/etc/nginx/ssl/` on host for Nginx (host/container) before proceeding.

### Nginx on Host

To run Nginx on host, you don't have to do anything. The website is already set-up during the installation phase. You can skip to setting-up Nextcloud AIO.

### Nginx on Docker

To run Nginx on Docker, the Nginx service running on the host must be stopped and disabled first.

```bash
sudo systemctl stop nginx && sudo systemctl disable nginx
```

Add the following lines to the `/compose.yaml` file under the `services` section to create a Nginx container.

```yaml
nginx-proxy:
  build:
    context: ./
    dockerfile: ./docker/Dockerfile
  restart: always
  container_name: nginx-proxy
  volumes:
    - /etc/nginx/ssl/:/etc/nginx/ssl
  network_mode: host
  ports:
    - 80:80
    - 443:443
```

### Continuing with the Installation of Nextcloud AIO

Now, we can proceed with the set-up of the website. In case you would like to change the location where Nexcloud stores all your data, you can edit the `NEXTCLOUD_DATA_DIR` under the `environment` section of the `/compose.yaml` file.

If you're Nextcloud data directory is an external device, then mount it first. The entire system can be bought online with the following command.

```bash
docker compose --file ./docker/compose.yaml up --detach
```

If everything turns out successfully, you must be able to access the setup page of Nextcloud at `https://<private-ip>:8080`. Copy the password and log-in to the "Containers" page. Now, enter the domain name you want to associate with the Apache server. Ensure this is correct as the Apache server will match it against the `Host` header for each request and any request with mismatched values will be ignored.

Make sure to set the timezone before provisioning the containers. The settings to it can be found on the same page at the bottom. Complete the set-up by installing the containers. Once installed, you should be able to access the website and Nextcloud AIO from anywhere.

To make the system auto-mount the drive during boot, add the following line to `/etc/fstab` file.

```bash
UUID=<drive-uuid>   /mnt/usb   <filesystem-type>   defaults,user,auto   0   0
```

## System Information

- **Hardware**
  - **Name:** Raspberry Pi 4B
  - **Architecture**: aarch64
  - **Memory:** 4 GB
  - **Storage:** 64 GB Class-10 microSD
  - **Auxillary Storage (for Nextcloud only):** 16 GB USB3 with EXT4 File System
- **Software**
  - **Operating System:** Raspbian OS Headless Setup 64-bit
  - **Docker Version:** 24.0.7
  - **Kernel Version:** 6.1.0-rpi4-rpi-v8
  - **Nginx Version:** 1.25+

## Contributing

This is a personal project and I discourage public contributions. The repository has been kept public only for learning purpose.
