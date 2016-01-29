# build-script-unix

<img src="https://travis-ci.org/SpikeShape/build-script-unix.svg?branch=master" alt="master branch build process passes" />

A simple bash script to install all the tools you need to build a project built with the the OpenSource Workflow:

It will install:

* RVM
* ruby
* bundler
* node

If they are not pre-installed you will be asked if you want to install their newest versions; if not the building process will be aborted. So you can install all these tools to your liking.

After that it will install ruby gems using bundler and install node modules according to the ones specified in the package.json.

You will find the compiled project in the ./build folder
