## studenti
To host the Dockefile for a container with ROOT, compiler, emacs, ...

The code on GitHub (https://github.com/arossi83/studenti) is then connected to DockerHub (https://github.com/arossi83/studenti) and the build is automatical at every push. The idea is to take the Docker image and run directly from DockerHub without looking at the GitHub code.

The Docker will be built starting from the ufficial ROOT Docker: https://hub.docker.com/r/rootproject/root and the README of that DockerHub image is quite helpful (part of it is replicated here).

### Supported tags
* latest

### Supported C++ standards
Tag 'latest' (the default tag) comes with ROOT compiled with C++11 support.

### To build (if taking the image from DockerHub you **don't need** to do this):
```
$ docker build --tag arossi83/studenti:latest .
```

### To run the container:
[adapted from https://hub.docker.com/r/rootproject/root]

In order to run containers, you must have Docker installed and, once, you need to execute
```
docker pull arossi83/studenti
```
Then you can start a container by running the following command in your terminal which will start the latest stable release of ROOT:
```
docker run --rm -it arossi83/studenti:latest
```
Note that the `--rm` flag tells Docker to remove the container, together with its data, once it is shut down. In order to persist data, it is recommended to mount a directory on the container. The idea is to have a "working dir" where to work and, in particular, run the container. This directory can contain all the files you need when you'll be inside the container and then will host few small (hidden) files to have the persistence of the bash and ROOT history and any "output" file you create inside the container and you want to keep afterwards.

On Linux and Mac, run:
```
docker run --rm -it -v `pwd`:/home/studente/current_dir arossi83/studenti:latest
```
On Windows, you have to specify the full path to your user directory, e.g.:
```
docker run --rm -it -v C:\\Users\\<where you are>:/home/studente/current_dir arossi83/studenti:latest
```
The `-v` option tells Docker to mount the home directory (`~`) to `/userhome` in the container. ~~`--user $(id -u)` signs us in with the same userid as in the host in order to allow reading/writing to the mounted directory. This is not necessary on Windows. Mac and Windows users does however have to mark the drives or areas they want to mount as shared in the Docker application under settings.~~

[Configuring Docker for Windows Shared Drives / Volume Mounting with AD](https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes/)
[More about mounting host directories in the container.](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume)

### Enabling graphics

##### Linux
To use graphics, make sure you are in an X11 session and run the following command:

```
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --rm -it --user $(id -u) arossi83/studenti:latest
```

On some platforms (e.g., Arch Linux) connections to the X server must be allowed explicitly by executing `xhost local:root` or an equivalent command (see e.g. [this page](https://wiki.archlinux.org/index.php/Xhost) for more information on `xhost` and its possible security implications).

##### OSX
To use graphics on OSX, make sure [XQuarz](https://www.xquartz.org/) is installed. After installing, open XQuartz, and go to XQuartz, Preferences, select the Security tab, and tick the box "Allow connections from network clients". Then exit XQuarz. Afterwards, open a terminal and run the following commands: `ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`
This will grab your IP address on the local network. Run `echo $ip` to make sure it was successfull. If nothing is displayed, replace `en0` with `en1` or a higher number in the command.
Then is enough to run `xhost + $ip` and this will start XQuartz and whitelist your local IP address. Finally, you can start up ROOT with the following command:
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$ip:0 arossi83/studenti:latest
```

##### Windows
To enable graphics, you must have [vcxsrv](https://sourceforge.net/projects/vcxsrv/) installed. Make sure Xming is whitelisted in the Windows firewall when prompted. After installing vcxsrv, start XLaunch leave all settings as they are but add the thick on "Disable access control" (on third page), after this launch the docker:
```
docker run --rm -it -e DISPLAY=<your-ip>:0.0 arossi83/studenti:latest
```

## Examples (OSX as "host")
##### Bash session:
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/studente/current_dir -e DISPLAY=$ip:0 arossi83/studenti:latest /bin/bash
```
will
  - export the display;
  - export the current dir (i.e. `pwd`) to the container 'current_dir' inside the user (i.e. 'studente') home. This is quite usefull and makes the bash and ROOT history persistent;
  - open a bash session.
  
##### ROOT CINT (batch mode, no graphics):
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/studente/current_dir -e DISPLAY=$ip:0 arossi83/studenti:latest
```
will
  - export the display;
  - export the current dir (i.e. `pwd`) to the container 'current_dir' inside the user (i.e. 'studente') home. This is quite usefull and makes the bash and ROOT history persistent;
  - open ROOT CINT in batch mode (i.e. `root -b`).

##### ROOT CINT (graphics enabled)
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/studente/current_dir -e DISPLAY=$ip:0 arossi83/studenti:latest root
```
will
  - export the display;
  - export the current dir (i.e. `pwd`) to the container 'current_dir' inside the user (i.e. 'studente') home. This is quite usefull and makes the bash and ROOT history persistent;
  - open ROOT CINT (graphics enabled, i.e. `root` command)

## Instructions for Windows 10 as Host:
#### Preliminary
- Install [Docker Desktop](https://www.docker.com/products/docker-desktop).
- Install [vcxsrv](https://sourceforge.net/projects/vcxsrv/).
- Download a starting script from here [link](https://istnazfisnucl-my.sharepoint.com/:u:/g/personal/alrossi_infn_it/EZ5BR1_oqWtAuCzylXTr4lABmXrUPg9tO8nzagR5ZPQ4xA?e=Lecc5J). I suggest to create a directory inside your home (i.e. C:\Users\<your-user-name>\Scripts) and move the script there. After this you can add this directory to your PATH in order to be able to execute this script from everywhere inside the machine. To do this you need to open a Powershell as Administrator and type the following commands:
```
Set-ExecutionPolicy RemoteSigned
setx /M PATH "$($env:path);C:\Users\<your-user-name>\Scripts"
```
First command enable the use of costum script while the second add the dir which contains the script to your PATH.

#### Start the Docker
- Start XLaunch: a GUI menu will be shown, leave all settings as they are by default but on third page add a thick mark on ```Disable access controll```. Continue and end the configuration, X server will start. ([Example](https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde))
- Open a Powershell (as normal user), navigate on the directory where you want to work and run ```StartDocker.ps1```. At this point the docker will start and if everything is fine you will be logged into a Linux machine as "studente" and inside the "current_dir" directory. This directory is the same one you have in the host and represent the way to share data between host and docker. You can launch ROOT simply giving ```root``` command. Graphics interface should be correctly enabled.



## Examples of different containers
[See GitHub for example Dockerfiles.](https://github.com/root-project/docker-examples)
