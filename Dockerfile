FROM ubuntu:16.04
MAINTAINER Benjamin Henrion <zoobab@gmail.com>

RUN apt update
RUN apt install -yy build-essential subversion git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl mercurial bzr ecj cvs unzip wget sudo


ENV user lede
RUN useradd -d /home/$user -m -s /bin/bash $user
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
RUN chmod 0440 /etc/sudoers.d/$user

USER $user
WORKDIR /home/$user
RUN mkdir -pv /home/$user/src

ADD . /home/$user/src

WORKDIR /home/$user/src
RUN ./scripts/feeds update -a
RUN ./scripts/feeds install -a
RUN echo CONFIG_TARGET_ar71xx=y > .config
RUN make defconfig
RUN make prereq
RUN make tools/install
RUN make toolchain/install
RUN make -j4
