<p align="center">
    <a href="https://img.shields.io/mozilla-observatory/grade/festivalsapp.org?publish" title="Latest Results"><img src="https://img.shields.io/mozilla-observatory/grade/festivalsapp.org?publish" alt="Mozilla HTTP Observatory Grade"></a>
    <a href="https://github.com/Festivals-App/festivals-website/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/Festivals-App/festivals-website?style=flat"></a>
   <a href="https://github.com/festivals-app/festivals-website/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/festivals-app/festivals-website?style=flat"></a>
   <a href="./LICENSE" title="License"><img src="https://img.shields.io/github/license/festivals-app/festivals-website.svg"></a>
</p>

<h1 align="center">
    <br/><br/>
    FestivalsApp: Website
    <br/><br/>
</h1

This repository contains the source files of the official website for the FestivalsApp as it is available at [festivalsapp.org](https://festivalsapp.org/) 
and a lightweight go sidecar app, called festivals-website-node. The festivals-website-node will register with the festivals-gateway discovery service and exposes other
functions including updating the website.

![Figure 1: Architecture Overview Highlighted](https://github.com/Festivals-App/festivals-documentation/blob/main/images/architecture/overview_website.png "Figure 1: Architecture Overview Highlighted")

<hr/>
<p align="center">
  <a href="#development">Development</a> •
  <a href="#deployment">Deployment</a> • 
  <a href="#documentation-architecture">Documentation & Architecture</a> •
  <a href="#Engage--feedback">Engage & Feedback</a> •
  <a href="#licensing">Licensing</a> •
  <a href="https://festivalsapp.org">Website</a>
</p>
<hr/>

## Development

I have a rather custom development workflow for the FestvialsApp website. This is probably due to my dislike for website development: i can't bring myself to learn the right way.
Though unconventional, it is quite straight forward as the website only uses html, css and a little bit of php for the contact form. 

All necessary files are in the [source](./source) folder waiting to get compiled by the compile script which is minifying and merging those files and is outputting the result to a folder called "out". This folder now contains a new folder with the current timestamp as its name and a folder called "current". The "current" folder will always contain the newest compiled files, and can be used to check the latest changes to the source files using a browser.

I use [Visual Studio Code](https://code.visualstudio.com/), as it is super easy to run the compile script with just a shortcut (Shift+Cmd+B) and i don't have any preferences when developing websites.

The key requirements for the website are: fast, easy to update, open source, accessible([*](https://github.com/Festivals-App/festivals-website/issues/1)) and secure.
 
### Requirements

- [Bash script](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) friendly environment
- [Visual Studio Code](https://code.visualstudio.com/download) 1.84.0+
    * Plugin recommendations are managed via [workspace recommendations](https://code.visualstudio.com/docs/editor/extension-marketplace#_recommended-extensions).
- [minify](https://github.com/tdewolff/minify)
    * For installation on macOS via homebrew see [here](https://github.com/tdewolff/minify/issues/253).

### Setup

I don't have a special setup in [Visual Studio Code](https://code.visualstudio.com/download) and the provided [configuration files](./.vscode) should let you start right away.
You only need to install minify on your system to allow the compile script to run.

## Deployment

I use [nginx](https://www.nginx.com/) to serve festivalsapp.org, deployed in a small VM running Ubuntu at [digitalocean](https://www.digitalocean.com/). To deploy the website via the install script you have to do the [general VM setup](https://github.com/Festivals-App/festivals-documentation/tree/master/deployment/general-vm-setup) first. Otherwise the are no special requirements for serving this website, except the contact form needs some configuration to allow the system to send emails (TBA).

### Installing festivalsapp.org
```bash
curl -o install.sh https://raw.githubusercontent.com/Festivals-App/festivals-website/master/operation/install.sh
chmod +x install.sh
sudo ./install.sh
rm install.sh
```
After installing you still need to configure [HTTPS](https://dev.to/joelaberger/no-magic-letsencrypt-certbot-and-nginx-configuration-recipe-3a97).

### Updating festivalsapp.org
```bash
curl -o update_website.sh https://raw.githubusercontent.com/Festivals-App/festivals-website/master/operation/update_website.sh
chmod +x update_website.sh
sudo ./update_website.sh
rm update_website.sh
```

### Updating festivals-website-node
```bash
curl -o update_node.sh https://raw.githubusercontent.com/Festivals-App/festivals-website/master/operation/update_node.sh
chmod +x update_node.sh
sudo ./update_node.sh
rm update_node.sh
```

# Documentation & Architecture

There is not a lot that is custom about the website. The base locale of the website is german, localized versions of the website 
are stored inside a top level folder with a descriptive name, like 'EN' for the english localization. Images are all stored in a 
top level folder called images and need to be compressed and optimized by hand, as the compile script won't attempt any optimizations 
on the images.

The general documentation for the Festivals App is in the [festivals-documentation](https://github.com/festivals-app/festivals-documentation) repository. The documentation repository contains architecture information, general deployment documentation, templates and other helpful documents.

# Engage & Feedback

I welcome every contribution, whether it is a pull request or a fixed typo.

The best place to discuss questions and suggestions regarding the website is the [issues](https://github.com/festivals-app/festivals-website/issues/) section on github. If this doesn't fit you proposal or reason to contact me, there are some more general purpose communication channels where you can reach me, listed in the following table.

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **General Discussion**   | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="General Discussion"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/question.svg?style=flat-square"></a> </a>   |
| **Other Requests**    | <a href="mailto:simon.cay.gaus@gmail.com" title="Email me"><img src="https://img.shields.io/badge/email-Simon-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |


## Licensing

Copyright (c) 2017-2023 Simon Gaus.

Licensed under the **GNU Lesser General Public License v3.0** (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at https://www.gnu.org/licenses/lgpl-3.0.html.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the [LICENSE](./LICENSE) for the specific language governing permissions and limitations under the License.