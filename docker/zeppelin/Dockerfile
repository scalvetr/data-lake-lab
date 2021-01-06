FROM ubuntu:18.04

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

RUN echo "$LOG_TAG update and install basic packages" && \
    apt-get -y update && \
    apt-get install -y locales && \
    locale-gen $LANG && \
    apt-get install -y software-properties-common && \
    apt -y autoclean && \
    apt -y dist-upgrade && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    build-essential wget curl grep sed dpkg net-tools tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN echo "$LOG_TAG install tini" && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
    apt-get -y update && apt-get install -y \
    openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*


RUN echo "$LOG_TAG Install python related packages" && \
    apt-get -y update && apt-get install -y \
    python3-dev python3-pip python3-tk python3-pycodestyle \
    python3-numpy python3-pandas python3-scipy python3-pandas \
    python3-protobuf python3-ipython python3-matplotlib python3-ipykernel cython3 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "$LOG_TAG Install other python related packages 1" && \
    pip3 install --no-cache-dir -q \
    grpcio==1.19.0 bkzep==0.6.1 hvplot==0.5.2 pandasql==0.7.3 bokeh==1.3.4 panel==0.6.0 holoviews==1.12.3 \
    altair==3.2.0 mizani==0.6.0 plotnine==0.6.0 textblob==0.15.3

#RUN echo "$LOG_TAG Install other python related packages 2" && \
#    pip3 install --no-cache-dir -q \
#    intake==0.5.3 intake-parquet==0.2.2


RUN echo "$LOG_TAG Install scala" && \
    apt-get -y update && apt-get install -y \
    scala \
    && rm -rf /var/lib/apt/lists/*

ENV Z_VERSION="0.9.0"
ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" \
    Z_HOME="/zeppelin" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ZEPPELIN_ADDR="0.0.0.0"

RUN echo "$LOG_TAG Download Zeppelin binary" && \
    wget --quiet -O /tmp/zeppelin-${Z_VERSION}-bin-all.tgz http://archive.apache.org/dist/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-all.tgz && \
    tar -zxvf /tmp/zeppelin-${Z_VERSION}-bin-all.tgz && \
    rm -rf /tmp/zeppelin-${Z_VERSION}-bin-all.tgz && \
    mkdir -p ${Z_HOME} && \
    mv /zeppelin-${Z_VERSION}-bin-all/* ${Z_HOME}/ && \
    chown -R root:root ${Z_HOME} && \
    mkdir -p ${Z_HOME}/logs ${Z_HOME}/run ${Z_HOME}/webapps && \
    # Allow process to edit /etc/passwd, to create a user entry for zeppelin
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    # Give access to some specific folders
    chmod -R 775 "${Z_HOME}/logs" "${Z_HOME}/run" "${Z_HOME}/notebook" "${Z_HOME}/conf" && \
    # Allow process to create new folders (e.g. webapps)
    chmod 775 ${Z_HOME}

COPY log4j.properties ${Z_HOME}/conf/
COPY log4j_docker.properties ${Z_HOME}/conf/


RUN wget -O spark.tgz https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \
    tar -xvzf spark.tgz && \
    mv spark-* /opt/spark && \
    rm -fR spark.tgz

ENV SPARK_HOME=/opt/spark
ENV PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"
ENV PYSPARK_PYTHON=/usr/bin/python3

RUN wget -O hadoop.tgz https://archive.apache.org/dist/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz && \
    tar -xvzf hadoop.tgz && \
    rm -fR hadoop.tgz && \
    mv hadoop-* /opt/hadoop

ENV HADOOP_HOME=/opt/hadoop
ENV PATH="${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}"

RUN wget -O sqoop.tgz https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz && \
    tar -xvzf sqoop.tgz && \
    rm -fR sqoop.tgz && \
    mv sqoop-* /opt/sqoop

ENV SQOOP_HOME=/opt/sqoop
ENV PATH="${SQOOP_HOME}/bin:${PATH}"

RUN wget -O hbase.tgz https://archive.apache.org/dist/hbase/2.3.3/hbase-2.3.3-bin.tar.gz && \
    tar -xvzf hbase.tgz && \
    rm -fR hbase.tgz && \
    mv hbase-* /opt/hbase

ENV HBASE_HOME=/opt/hbase
ENV PATH="${HBASE_HOME}/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER 1000

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR ${Z_HOME}
CMD ["bin/zeppelin.sh"]
