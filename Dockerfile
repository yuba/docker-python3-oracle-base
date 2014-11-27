# Python3-oracle base image
#
# VERSION               0.0.3

FROM      ubuntu
MAINTAINER Joost Venema <joost.venema@kadaster.nl>

# Update APT repository
RUN apt-get -y update

# Install packages
RUN apt-get install -y libaio1 libaio-dev python3-pip alien python3-lxml python3-psycopg2 poppler-utils

# Get Oracle Client (this isn't the offical download location, but at least it works without logging in!)
RUN curl -O http://repo.dlt.psu.edu/RHEL5Workstation/x86_64/RPMS/oracle-instantclient12.1-basic-12.1.0.1.0-1.x86_64.rpm
RUN curl -O http://repo.dlt.psu.edu/RHEL5Workstation/x86_64/RPMS/oracle-instantclient12.1-devel-12.1.0.1.0-1.x86_64.rpm

# RPM to DEB
RUN alien -d *.rpm

# Install packages
RUN dpkg -i *.deb

# Setup Oracle environment
RUN echo "/usr/lib/oracle/12.1/client64/lib" > /etc/ld.so.conf.d/oracle.conf
ENV ORACLE_HOME /usr/lib/oracle/12.1/client64
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib
RUN ldconfig

# Install Python Packages
RUN pip3 install requests cx_oracle sqlalchemy bottle waitress websockets celery flower elasticsearch

# Needed to run Celery as root
ENV C_FORCE_ROOT true

VOLUME ["/data"]

WORKDIR /data

EXPOSE 5000 5555 10080 
