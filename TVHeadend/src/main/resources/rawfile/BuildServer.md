#  安装后端
###  1.Linux
####  在Linux中TVHeadend提供了多种的安装方法，例如：源码编译、Snap、自动脚本
#####  对于 Debian、Raspberry Pi OS 和 Ubuntu（以及其他使用 .deb 的发行版）
```shell
curl -1sLf 'https://dl.cloudsmith.io/public/tvheadend/tvheadend/setup.deb.sh' | sudo -E bash
```
####  对于 Fedora 和 RedHat（以及其他使用 .rpm 的发行版）
```shell
curl -1sLf 'https://dl.cloudsmith.io/public/tvheadend/tvheadend/setup.rpm.sh' | sudo -E bash
```
###  2.Windows/MacOS
##### TVHeandend 没有提供Windows和MacOS的原生安装方法，可以使用Docker搭建
####  DockerCompose代码
```
services:
  tvheadend:
    image: lscr.io/linuxserver/tvheadend:latest
    container_name: tvheadend
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - RUN_OPTS= #optional
    volumes:
      - /path/to/tvheadend/data:/config
      - /path/to/recordings:/recordings
    ports:
      - 9981:9981
      - 9982:9982
    devices:
      - /dev/dri:/dev/dri #optional
      - /dev/dvb:/dev/dvb #optional
    restart: unless-stopped
```