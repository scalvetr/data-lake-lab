FROM ubuntu:20.04

ENV Z_VERSION="0.9.0-preview2"

ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" \
    Z_HOME="/zeppelin" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    ZEPPELIN_ADDR="0.0.0.0"

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

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
RUN echo "$LOG_TAG Install java11" && \
    apt-get -y update && \
    apt-get install -y openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*

# should install conda first before numpy, matploylib since pip and python will be installed by conda
RUN echo "$LOG_TAG Install miniconda3 related packages" && \
    apt-get -y update && \
    apt-get install -y bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN echo "$LOG_TAG Install python related packages" && \
    apt-get -y update && \
    apt-get install -y python3-dev python3-pip && \
    apt-get install -y python3-tk python3-pycodestyle && \
    apt-get install -y python3-numpy python3-pandas python3-scipy python3-pandas && \
    apt-get install -y python3-protobuf python3-ipython python3-matplotlib python3-ipykernel && \
    apt-get install -y python3-seaborn python3-patsy python3-jupyter-client && \
    apt-get install -y cython3
#    pip3 install -q mizani==0.6.0 plotnine==0.6.0 apache-beam==2.16.0 fastparquet==0.3.2 grpcio==1.26.0 bkzep==0.6.1 hvplot==0.5.2 pandasql3==0.7.3 bokeh==1.4.0 panel==0.7.0 holoviews==1.12.7 intake==0.5.4 intake-parquet==0.2.3 altair==3.3.0
RUN echo "$LOG_TAG Install other python related packages" && \
    pip3 install -q fastparquet grpcio bkzep hvplot pandasql3 bokeh panel holoviews intake intake-parquet altair cython
RUN echo "$LOG_TAG Install other python plotnine" && \
    pip3 install -q mizani==0.6.0 plotnine==0.6.0
#RUN echo "$LOG_TAG Install other python apache-beam" && \
#    pip3 install -q apache-beam==2.21.0


RUN echo "$LOG_TAG Cleanup" && \
    apt-get autoclean && \
    apt-get clean

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


RUN echo "$LOG_TAG Install scala" && \
    apt-get -y update && \
    apt-get install -y scala && \
    rm -rf /var/lib/apt/lists/*


RUN wget -O spark.tgz https://downloads.apache.org/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz
RUN wget -O hadoop.tgz https://downloads.apache.org/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz


RUN tar -xvzf spark.tgz
RUN rm -fR spark.tgz
RUN mv spark-* /opt/spark

RUN tar -xvzf hadoop.tgz
RUN rm -fR hadoop.tgz
RUN mv hadoop-* /opt/hadoop

ENV HADOOP_HOME=/opt/hadoop
ENV PATH="${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}"

ENV SPARK_HOME=/opt/spark
ENV PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"
ENV PYSPARK_PYTHON=/usr/bin/python3


USER 1000

EXPOSE 8080

ENTRYPOINT [ "/usr/bin/tini", "--" ]
WORKDIR ${Z_HOME}
CMD ["bin/zeppelin.sh"]
