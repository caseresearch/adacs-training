# ADACS Tutorials 
FROM ubuntu:16.04

LABEL Description="This image is used for ADACS Training" Vendor="Swinburne University of Technology" Version="1.3"

MAINTAINER Amr Hassan <ahassan@swin.edu.au>


RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -y update \
	&& apt-get -y install \
	mysql-server-5.7 \
	emacs \
	wget \
	unzip \
	git \
	bzip2 \
	openmpi-bin \
	apparmor \
	&& rm -rf /var/lib/apt/lists/*

RUN  sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf \
	&& update-rc.d mysql defaults \


RUN mkdir /docker_init && mkdir /data && cd /data && \
	wget --quiet http://www.adacs.org.au/files/AstroInformatics_2017_day1_python_data.zip && \
	wget --quiet http://www.adacs.org.au/files/AstroInformatics_2017_day1_astropy_files.tar 
	
	 


COPY install_db.sh /docker_init/install_db.sh
RUN git clone https://github.com/datacharmer/test_db.git test_db && \
    cd test_db && \
    /docker_init/install_db.sh && \
    rm -R /test_db && \
    rm /docker_init/install_db.sh


RUN wget --quiet https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b && \
    rm ~/anaconda.sh
# install anaconda2 version 4.2
RUN echo 'export PATH="/root/anaconda2/bin:$PATH"' >> ~/.bashrc
RUN /root/anaconda2/bin/conda install --yes mpi4py=2.0.0 && \
	/root/anaconda2/bin/conda update --yes pandas


COPY init.sh /docker_init/init.sh
ENTRYPOINT ["/docker_init/init.sh"]

EXPOSE 3306
EXPOSE 8888

CMD ["/bin/bash"]


