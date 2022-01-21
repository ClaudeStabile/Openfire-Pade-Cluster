#name of container: docker-pade
#versison of container: 6.0.2
FROM quantumobject/docker-baseimage:20.04
MAINTAINER Claude Stabile "claude@free-solutions.ch"

#Installation of needed packages...
#Java, mysql client, vim & TZ
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q openjdk-17-jdk && DEBIAN_FRONTEND=noninteractive apt-get install -y -q vim && DEBIAN_FRONTEND=noninteractive apt-get install -y -q mysql-client && DEBIAN_FRONTEND=noninteractive apt-get install -y -q tzdata\
                    && apt-get clean \
                    && apt-get autoremove \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*

##startup scripts  
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

##deamons
# add openfire start & run 
RUN mkdir /etc/service/openfire
COPY openfire.sh /etc/service/openfire/run
RUN chmod +x /etc/service/openfire/run 

COPY pre-conf.sh /sbin/pre-conf
RUN chmod +x /sbin/pre-conf; sync \
    && /bin/bash -c /sbin/pre-conf \
    && rm /sbin/pre-conf

#Expose port adjust to your need
EXPOSE 7443 9090 9091 5222 5269 5270 5271 5275 1935 5701 10000/udp

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
