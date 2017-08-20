#!/bin/bash

DOCKER_USER=brunneis
ARCHS=(armhf arm64)
UBUNTU_VERSIONS=(14.04.5 16.04.3 17.04)
UBUNTU_NAMES=(trusty xenial zesty)

function build_image () {
  current_dir=$(pwd)
  cd $1
  docker build -t $DOCKER_USER/ubuntu-$2:$3 .
  cd $current_dir
}

function download_rootfs () {
  current_dir=$(pwd)
  UBUNTU_ROOTFS_TARBALL=ubuntu-base-$1-base-$2.tar.gz
  UBUNTU_BASE_LINK=http://cdimage.ubuntu.com/ubuntu-base/releases/$1/release
  UBUNTU_ROOTFS_LINK=$UBUNTU_BASE_LINK/$UBUNTU_ROOTFS_TARBALL
  UBUNTU_SHA1SUMS_LINK=$UBUNTU_BASE_LINK/SHA1SUMS
  cd $3
  wget $UBUNTU_ROOTFS_LINK -O ubuntu-$1-$2.tar.gz \
  && wget $UBUNTU_SHA1SUMS_LINK -O SHA1SUMS \
  && cat SHA1SUMS | grep $UBUNTU_ROOTFS_TARBALL | awk '{print $1}' > ubuntu-$1-$2.tar.gz.sha1 \
  && truncate -s $(($(stat -c '%s' ubuntu-$1-$2.tar.gz.sha1)-1)) ubuntu-$1-$2.tar.gz.sha1 \
  && echo " "ubuntu-$1-$2.tar.gz >> ubuntu-$1-$2.tar.gz.sha1 \
  && sha1sum -c ubuntu-$1-$2.tar.gz.sha1 \
  && rm -f SHA1SUMS
  cd $current_dir
}

function generate_dockerfile () {
  cat <<EOF > $3/Dockerfile
# Ubuntu $1 for $2
# Copyright (C) 2017 Rodrigo Martínez <dev@brunneis.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM scratch
MAINTAINER "Rodrigo Martínez" <dev@brunneis.com>

################################################
# UBUNTU $1
################################################

ADD ubuntu-$1-$2.tar.gz /

RUN \
    TERM=xterm \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get clean

CMD ["/bin/bash"]
EOF
}

function build_arch () {
  for i in $(seq 0 $((${#UBUNTU_NAMES[@]} - 1)))
    do
      dir=./"${UBUNTU_NAMES[$i]}"/$1
      mkdir -p $dir
      generate_dockerfile "${UBUNTU_VERSIONS[$i]}" $1 $dir
      download_rootfs "${UBUNTU_VERSIONS[$i]}" $1 $dir
      build_image $dir $1 "${UBUNTU_NAMES[$i]}"
    done
}

for arch in "${ARCHS[@]}"
  do
    build_arch $arch
  done
