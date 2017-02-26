# Pull base image 
FROM resin/rpi-raspbian:jessie
MAINTAINER Mitch Roote <mitch@r00t.ca>

# Update Repo
RUN apt-get -y update && apt-get -yV upgrade
RUN apt-get -y install wget logrotate

ENV KIBANA_CONFIG /elk/kibana/config/kibana.yml

# Create dir
WORKDIR /elk

# Download 
RUN wget https://download.elastic.co/kibana/kibana/kibana-4.1.0-linux-x64.tar.gz
RUN tar -xzvf kibana-4.1.0-linux-x64.tar.gz
RUN mv kibana-4.1.0-linux-x64 kibana

# Get ARM node.js binaries
RUN wget http://node-arm.herokuapp.com/node_latest_armhf.deb 
RUN dpkg -i node_latest_armhf.deb
RUN mv /elk/kibana/node/bin/npm /elk/kibana/node/bin/npm.orig
RUN mv /elk/kibana/node/bin/node /elk/kibana/node/bin/node.orig
RUN ln -s /usr/local/bin/node /elk/kibana/node/bin/node
RUN ln -s /usr/local/bin/npm /elk/kibana/node/bin/npm

EXPOSE 5601

VOLUME /data/kibana

ADD run.sh /elk/run.sh
RUN chmod 755 /elk/run.sh
CMD ["/elk/run.sh"]
