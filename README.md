<p align="center">
    <a href="https://img.shields.io/mozilla-observatory/grade/festivalsapp.org?publish" title="Latest Results"><img src="https://img.shields.io/mozilla-observatory/grade/festivalsapp.org?publish" alt="Mozilla HTTP Observatory Grade"></a>
    <a href="https://github.com/Festivals-App/festivals-website/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/Festivals-App/festivals-website?style=flat"></a>
   <a href="https://github.com/festivals-app/festivals-website/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/festivals-app/festivals-website?style=flat"></a>
   <a href="./LICENSE" title="License"><img src="https://img.shields.io/github/license/festivals-app/festivals-website.svg"></a>
</p>

<h1 align="center">
    <br/><br/>
    FestivalsApp Website
    <br/><br/>
</h1

This repository contains the source files of the official website for the FestivalsApp as it is available at [festivalsapp.org](https://festivalsapp.org/)
and a lightweight go sidecar app, called festivals-website-node. The festivals-website-node will register with the festivals-gateway discovery service and exposes other
functions including updating the website via a webhook.

![Figure 1: Architecture Overview Highlighted](https://github.com/Festivals-App/festivals-documentation/blob/main/images/architecture/export/architecture_overview_website.svg "Figure 1: Architecture Overview Highlighted")

<hr/>
<p align="center">
  <a href="#development">Development</a> •
  <a href="#deployment">Deployment</a> •
  <a href="#engage">Engage</a> •
  <a href="https://festivalsapp.org">Website</a>
</p>
<hr/>

## Development

I have a rather custom development workflow for the FestvialsApp website. This is probably due to my dislike for website development: i can't bring myself to learn the right way.
Though unconventional, it is quite straight forward as the website only uses html and css.

All website files are in the [source](./source) folder waiting to get compiled by the compile script which is minifying and merging those files
and is outputting the result to a folder called `out`. This folder now contains a new folder with the current timestamp as its name and a folder called `current`.
The `current` folder will always contain the newest compiled files, and can be used to check the latest changes to the source files using a browser.
The base locale of the website is german, localized versions of the website are stored inside a top level folder with a descriptive name,
like 'EN' for the english localization. Images are all stored in a top level folder called images and need to be compressed and optimized by hand,
as the compile script won't attempt any optimizations on the images.

The key requirements for the website are: fast, easy to update, open source, accessible([*](https://github.com/Festivals-App/festivals-website/issues/1)) and secure.

### Requirements

- [Golang](https://go.dev/) Version 1.24.1+
- [Visual Studio Code](https://code.visualstudio.com/download) 1.98.2+
  - Plugin recommendations are managed via [workspace recommendations](https://code.visualstudio.com/docs/editor/extension-marketplace#_recommended-extensions).
- [Bash script](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) friendly environment
- [minify](https://github.com/tdewolff/minify)
  - For installation on macOS via homebrew see [here](https://github.com/tdewolff/minify/issues/253).

### Setup

I use [Visual Studio Code](https://code.visualstudio.com/), as it is super easy to run the compile script with just a shortcut (Shift+Cmd+B) and i don't have any preferences when developing websites, the provided [configuration files](./.vscode) should let you start right away.
You only need to install minify on your system to allow the compile script to run.

## Deployment

I use [nginx](https://www.nginx.com/) to serve festivalsapp.org, deployed in a small VM running Ubuntu at [digitalocean](https://www.digitalocean.com/). To deploy just follow the [**deployment guide**](./operation/DEPLOYMENT.md) for deploying it inside a virtual machine or the [**local deployment guide**](./operation/local/README.md) for running it on your macOS developer machine.

# Engage

I welcome every contribution, whether it is a pull request or a fixed typo. The best place to discuss questions and suggestions regarding the festivals-website is the [issues](https://github.com/festivals-app/festivals-website/issues/) section. More general
information and a good starting point if you want to get involved is the [festival-documentation](https://github.com/Festivals-App/festivals-documentation) repository.

The following channels are available for discussions, feedback, and support requests:

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **General Discussion**   | <a href="https://github.com/festivals-app/festivals-documentation/issues/new/choose" title="General Discussion"><img src="https://img.shields.io/github/issues/festivals-app/festivals-documentation/question.svg?style=flat-square"></a> </a>   |
| **Other Requests**    | <a href="mailto:simon@festivalsapp.org" title="Email me"><img src="https://img.shields.io/badge/email-Simon-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |

## Licensing

Copyright (c) 2017-2025 Simon Gaus. Licensed under the [**GNU Lesser General Public License v3.0**](./LICENSE)