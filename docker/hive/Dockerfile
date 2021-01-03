FROM ubuntu:20.04

RUN echo "$LOG_TAG update and install basic packages" && \
    apt-get -y update && \
    apt-get install -y locales && \
    locale-gen $LANG && \
    apt-get install -y software-properties-common && \
    apt -y autoclean && \
    apt -y dist-upgrade && \
    apt-get install -y build-essential

RUN echo "$LOG_TAG install tini related packages" && \
    apt-get install -y wget curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb


RUN echo "$LOG_TAG Install net-tools" && \
    apt-get -y update && \
    apt-get install -y net-tools && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
    apt-get -y update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME /opt/hive
ENV DERBY_HOME /opt/derby

# Install hadoop
RUN wget -O hadoop.tgz https://archive.apache.org/dist/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz
RUN tar -xvzf hadoop.tgz
RUN rm -fR hadoop.tgz
RUN mv hadoop-* /opt/hadoop
ENV PATH="${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}"

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
RUN wget https://archive.apache.org/dist/db/derby/db-derby-10.14.2.0/db-derby-10.14.2.0-bin.tar.gz && \
	tar -xzvf db-derby-10.14.2.0-bin.tar.gz && \
	mv db-derby-10.14.2.0-bin derby && \
	rm db-derby-10.14.2.0-bin.tar.gz

RUN wget https://archive.apache.org/dist/hive/hive-2.3.7/apache-hive-2.3.7-bin.tar.gz && \
	tar -xzvf apache-hive-2.3.7-bin.tar.gz && \
	mv apache-hive-2.3.7-bin hive && \
	rm apache-hive-2.3.7-bin.tar.gz

RUN ls ${DERBY_HOME}
RUN ls ${DERBY_HOME}/lib
RUN cp ${DERBY_HOME}/lib/derbyclient.jar ${HIVE_HOME}/lib/

ENV PATH $HIVE_HOME/bin:$PATH


COPY conf/core-site.xml /etc/hadoop/core-site.xml
COPY conf/hdfs-site.xml /etc/hadoop/hdfs-site.xml
COPY conf/hive-site.xml /opt/hive/conf/hive-site.xml

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir /opt/derby-data

# Derby
EXPOSE 1527
# Metastore
EXPOSE 9083
# hive.server2.thrift.port
EXPOSE 10000
# hive.server2.thrift.http.port
EXPOSE 10001
# hive.server2.webui.port
EXPOSE 10002

ENTRYPOINT ["entrypoint.sh"]
CMD startup.sh
