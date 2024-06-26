# This Dockerfile is used to build an headles vnc image based on Ubuntu
FROM ubuntu:18.04

LABEL io.k8s.description="Headless VNC Container with Xfce window manager, firefox and chromium" \
      io.k8s.display-name="Headless VNC Container based on Ubuntu" \
      io.openshift.expose-services="6901:http,5901:xvnc" \
      io.openshift.tags="vnc, ubuntu, xfce" \
      io.openshift.non-scalable=true

## Connection ports for controlling the UI:
# VNC port:5901
ENV DISPLAY=:1 \
    VNC_PORT=5901
EXPOSE $VNC_PORT

### Envrionment config
ENV HOME=/home/testup \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
WORKDIR $INST_SCRIPTS

### Install some common tools
ADD src/install/common.sh .
RUN ./common.sh

ADD src/install/tools.sh .
RUN ./tools.sh

### Install xvnc-server - HTML5 based VNC viewer
ADD src/install/tigervnc.sh .
RUN ./tigervnc.sh

### Install xfce UI
ADD src/install/xfce_ui.sh .
RUN $INST_SCRIPTS/xfce_ui.sh

### Install user stuff
RUN apt install -y libreoffice

### Install firefox and chrome browser
ADD src/install/firefox.sh .
RUN $INST_SCRIPTS/firefox.sh

ADD src/install/chrome.sh .
RUN $INST_SCRIPTS/chrome.sh

### Setup user
RUN useradd -u 1000 -m -s /bin/bash -G sudo testup
ADD ./src/xfce/ /home/testup

ADD src/install/set_user_permission.sh .
RUN ./set_user_permission.sh -xxx

### configure startup
ADD src/scripts $STARTUPDIR

WORKDIR /home/testup
USER 1000

### User-level configuration for tigervnc
ADD src/install/tigervnc_user_conf.sh .
RUN ./tigervnc_user_conf.sh

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
