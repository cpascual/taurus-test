FROM debian:stretch

# Update the repo info
RUN apt-get update

# install and configure supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# change installation dialogs policy to noninteractive
# otherwise debconf raises errors: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

# change policy for starting services while installing
# otherwise policy-rc.d denies execution of start
# http://askubuntu.com/questions/365911/why-the-services-do-not-start-at-installation
# finally the approach is to not start services when building image
# the database will be fead from file, instead of creating tables
# RUN echo "exit 0" > /usr/sbin/policy-rc.d

# install mysql server
RUN apt-get install -y default-mysql-server

#install tango-db
RUN apt-get install -y tango-db

#install tango-test DS
RUN apt-get install -y tango-test

# install pyqt4 dummy package to avoid dependency problem with python3-qwt 
ADD python3-pyqt4-dummy_1.0_all.deb /
RUN dpkg -i /python3-pyqt4-dummy_1.0_all.deb

# define preferred Qt for qtchooser
ENV QT_SELECT 5

# install taurus dependencies
RUN apt-get install -y python3-numpy \
                       python3-pyqt5 \
                       python3-pyqt5.qtopengl \
                       python3-h5py \
                       python3-lxml \
                       python3-pint \
                       python3-future \
                       python3-ply \
                       python3-pytango \
                       python3-spyderlib \
                       python3-pymca5 \
                       qttools5-dev-tools \
                       python3-sphinx-rtd-theme \
                       graphviz \
                       python3-pyqtgraph \
                       python3-guiqwt
                       
# install some utilities
RUN apt-get install -y git \
                       python3-pip \
                       vim \
                       ipython3 \
                       procps

# instal virtual monitor
RUN apt-get install -y xvfb

# configure virtual monitor env variable
ENV DISPLAY=:1.0

# configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/

# copy & untar mysql tango database and change owner to mysql user
ADD tangodb-tiny.tar /var/lib/mysql/
RUN chown -R mysql /var/lib/mysql/tango

# define tango host env var
ENV TANGO_HOST=taurus-test:10000

# add EPICS repo 
COPY epicsdebs /epicsdebs
COPY epics.list /etc/apt/sources.list.d/
RUN apt-get update

# install epics
RUN apt-get install -y epics-dev

# install pyepics
RUN pip3 install pyepics

# copy test epics IOC database
ADD testioc.db /

# add USER ENV (necessary for spyderlib in taurus.qt.qtgui.editor)
ENV USER=root

# Set python3 as the default version for the python executable
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 2

# start supervisor as deamon (force using python2, since supervisord <4 does not run on py3)
CMD ["/usr/bin/python2", "/usr/bin/supervisord"]
