This container is based on ubuntu:16.04 and contains the following:
* MySQL Server
* emacs
* wget
* git
* bzip2
* OpenMPI

To start this container please use the following command:
docker run -p 3306:3306 -p 8888:8888 -it caseresearch/adacs-training

Then use:
/docker_init/init.sh

to install Anaconda and the MySQL sample data. 

