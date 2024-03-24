# Mint

Mint is a small and simple text editor made by StephenMortada.

___

## Building

Run the following commands to install the necessary dependenc(y/ies):

```bash
sudo apt-get update
sudo apt-get install liblua5.4-dev
luarocks install luastatic
```

_(Note: Replace `apt-get` with the appropriate package manager for your system if you're not on a Debian-based distribution.)_
_(P.S. You may skip the above step if you already have `luastatic` installed.)_

Then, in the root directory of the project, run `./build.sh`.
If all goes well, the files `mint` and `mintpkg` should appear in the `./bin/` directory.

___

## Usage

### Command Line Arguments

General syntax: `mint (options) (file name)`

#### Options

* `-h` or `--help`: Help menu
* `-o`: Load extension

### Editor

On launch, the program will be in ""

___

## The Mint Package System

Click [here](https://stephenmortada.github.io/MintPkg/).

___

## License

This program is licenced under the GNU GPL v3.0.
