# Ubuntu 16.04.3 for arm64
# Copyright (C) 2017 Rodrigo Martínez <dev@brunneis.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM scratch
MAINTAINER "Rodrigo Martínez" <dev@brunneis.com>

################################################
# UBUNTU 16.04.3
################################################

ADD ubuntu-16.04.3-arm64.tar.gz /

RUN \
    TERM=xterm \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get clean

CMD ["/bin/bash"]
