# ADACS Tutorials 
# Version 1.1
FROM ubuntu:16.04

LABEL Description="This image is used for ADACS Training" Vendor="Swinburne University of Technology" Version="1.1"

MAINTAINER Amr Hassan <ahassan@swin.edu.au>

#RUN sed -i 's/archive.ubuntu.com/ftp.swin.edu.au/' /etc/apt/sources.list
RUN echo 'mysql-server mysql-server/root_password password some_pass' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password some_pass' | debconf-set-selections
RUN apt-get -y update \
	&& apt-get -y install \
	mysql-server-5.7 \
	emacs \
	wget \
	git \
	bzip2 \
	openmpi-bin \
	apparmor \
	&& rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive \
	&& sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf \
	&& update-rc.d mysql defaults \


RUN mkdir /docker_init


COPY install_db.sh /docker_init/install_db.sh
RUN git clone https://github.com/datacharmer/test_db.git test_db && \
    cd test_db && \
    /docker_init/install_db.sh && \
    rm -R /test_db


RUN wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b && \
    rm ~/anaconda.sh
# install anaconda?????
RUN echo 'export PATH="/root/anaconda2/bin:$PATH"' >> ~/.bashrc
RUN /root/anaconda2/bin/conda install --yes mpi4py=2.0.0


COPY init.sh /docker_init/init.sh
ENTRYPOINT ["/docker_init/init.sh"]

EXPOSE 3306
EXPOSE 8888

CMD ["/bin/bash"]


