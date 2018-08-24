# taurus-test (with debian stretch)

[Docker](http://www.docker.com) image configuration for testing [Taurus](http://www.taurus-scada.org).

It is based on a [Debian](http://www.debian.org) stretch and it provides the following infrastructure for installing and testing Taurus:

- xvfb, for headless GUI testing
- taurus dependencies and recommended packages (PyTango, PyQt, Qwt, guiqwt, spyder, ...)
- A Tango DB and TangoTest DS configured and running for testing taurus-tango
- A basic Epics system and a running SoftIoc for testing taurus-epics
 
The primary use of this Docker image is to use it in our [Continuous Integration workflow](https://travis-ci.org/taurus-org/taurus).

But you may also run it on your own machine:

~~~~
docker run -id --name=taurus-stretch -h taurus-test cpascual/taurus-test:debian-stretch
~~~~

... or, if you want to launch GUI apps from the container **and do not mind about X security**:

~~~~
xhost +local:
docker run -id --name=taurus-stretch -h taurus-test -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix cpascual/taurus-test:debian-stretch
~~~~

Then you can log into the container with:

~~~~
docker exec -it taurus-stretch bash
~~~~

Note: this image does not contain taurus itself (since it is designed for installing development versions of taurus) but you can install it easilly using any of the following examples **from your container** (for more details, see http://www.taurus-scada.org/users/getting_started.html).:


- Example 1: installing taurus from the official debian repo.
  
  ~~~~
  apt-get update
  apt-get install python-taurus -y
  ~~~~

- Example 2: installing the latest develop version from the git repo (you may use any other branch instead of develop):
  
  ~~~~
  git clone -b develop https://github.com/taurus-org/taurus.git
  cd taurus
  python setup.py install
  ~~~~

- Example 3: using pip to do the same as in example 2:
 
  ~~~~
  pip install git+https://github.com/taurus-org/taurus.git@develop
  ~~~~
  


Thanks to [reszelaz](https://github.com/reszelaz) for providing the first version of this docker image
