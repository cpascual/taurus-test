# taurus-test (with debian buster)

[Docker](http://www.docker.com) image configuration for testing [Taurus](http://www.taurus-scada.org).

It is based on a [Debian](http://www.debian.org) buster and it provides the following infrastructure for installing and testing Taurus:

- xvfb, for headless GUI testing
- taurus dependencies and recommended packages (PyTango, PyQt, Qwt, guiqwt, spyder, ...)
- A Tango DB and TangoTest DS configured and running for testing taurus-tango
- A basic Epics system and a running SoftIoc for testing taurus-epics
 
The primary use of this Docker image is to use it in our [Continuous Integration workflow](https://travis-ci.org/taurus-org/taurus).

But you may also run it on your own machine:

~~~~
docker run -d --name=taurus-buster -h taurus-test cpascual/taurus-test:debian-buster
~~~~

... or, if you want to launch GUI apps from the container **and do not mind about X security**:

~~~~
xhost +local:
docker run -d --name=taurus-buster -h taurus-test -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix cpascual/taurus-test:debian-buster
~~~~

Then you can log into the container with:

~~~~
docker exec -it taurus-buster bash
~~~~

Note: this image does not contain taurus itself (since it is designed for installing development versions of taurus) but you can install it easilly using any of the following examples **from your container** (for more details, see http://www.taurus-scada.org/users/getting_started.html).:


- Example 1: installing taurus from the official debian repo.
  
  ~~~~
  apt-get update
  apt-get install python-taurus -y
  ~~~~

- Example 2: installing the latest versions of taurus and taurus_pyqtgraph
  from the git repos in editable mode.:
  
  ~~~~
  git clone -b develop https://github.com/taurus-org/taurus.git
  pip3 install -e ./taurus 

  git clone -b master https://github.com/taurus-org/taurus_pyqtgraph.git
  pip3 install -e ./taurus_pyqtgraph 
  ~~~~

- Example 3: using pip to do the same as in example 2:
 
  ~~~~
  pip3 install git+https://github.com/taurus-org/taurus.git@develop
  pip3 install git+https://github.com/taurus-org/taurus_pyqtgraph.git@master
  ~~~~
  


Thanks to [reszelaz](https://github.com/reszelaz) for providing the first version of this docker image
