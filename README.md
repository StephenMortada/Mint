# Mint

___

## Overview

Mint is a small and simple text editor made by StephenM. Nothing more, nothing less. (yeah this is going to be changed soon)

___

## Installation

Run the following commands to install the necessary dependenc(y/ies):

    sudo apt-get update
    sudo apt-get install liblua5.4-dev
    luarocks install luastatic

_(Note: Replace `apt-get` with the appropriate package manager for your system if you're not on a Debian-based distribution.)_
_(P.S. You may skip the above step if you already have `luastatic` installed.)_

Then, in the root directory of the project, run `./build.sh`.
If all goes well, a file named `mint` should appear in the `./bin/` directory.

___

## Usage

### Command Line Arguments

General syntax: `mint (options) (file name)`

#### Options

* `-h` or `--help`	:	Help menu
* `-o`	:	Load extension
* `install`	:	Install extension name after the option, will exit after installation
* `remove`	:	Uninstall extension name after the option, will exit after uninstallation

### Editor

On launch, the program will be in ""

___

## License

This program is licenced under the GNU GPL v3.0 License.



