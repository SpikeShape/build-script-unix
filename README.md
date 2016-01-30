# build-script-unix

[![Build Status](https://travis-ci.org/SpikeShape/build-script-unix.svg?branch=master)](https://travis-ci.org/SpikeShape/build-script-unix)

A simple bash script to install all the tools you need to build a project built with the [OpenSource Workflow Kickstart Generator](https://github.com/OpenSourceWorkflow/generator-kickstart).

It will install:

* RVM
* ruby
* bundler
* node

If they are not already installed you will be asked if you want to install their newest versions; if not the building process will be aborted. So you can install all these tools to your liking.

After that it will install ruby gems using bundler and install node modules according to the ones specified in the package.json.

Finally this dummy project will be compiled in order to check that everything is working as expected.

You will find the compiled project in the ./build folder
