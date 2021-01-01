# Data Lakes

## Tools


| Tool              | Image                              | Ports           |
| ----------------- | ---------------------------------- | --------------- |
| namenode-hadoop | bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8 | 50070 |
| data-hadoop | bde2020/hadoop-datanode:2.0.0-hadoop2.7.4-java8 | 50075 |
| hive-server | bde2020/hive:2.3.2 | 10000 |
| spark-master | bde2020/spark-master:2.4.0-hadoop2.7 | 8080,7077 |
| spark-worker | bde2020/spark-worker:2.4.0-hadoop2.7 | 8081 |
| zeppelin | openkbs/docker-spark-bde2020-zeppelin | 19090 |
| hue | gethue/hue:20191107-135001 | ??? |
| mysql | mysql:5.7 | 33061 |
| zookeeper | wurstmeister/zookeeper:3.4.6 | 2181 |
| kafka | wurstmeister/kafka:2.12-2.3.0 | 9092 |
| elasticsearch | docker.elastic.co/elasticsearch/elasticsearch:7.10.1 | 9200,9300 |
| kibana | docker.elastic.co/kibana/kibana:7.10.1 | 5601  |

## Installation

```shell
docker-compose down

docker container prune
docker volume prune
docker network prune

sudo rm -fR ws/
```

```shell
mkdir -p ws/hadoop/logs/
chmod 777 -fR ws/hadoop/logs/
mkdir -p ws/hadoop/data/
chmod 777 -fR ws/hadoop/data/
mkdir -p ws/nifi/logs/
chmod 777 -fR ws/nifi/logs/
mkdir -p ws/zeppelin/logs/
chmod 777 -fR ws/zeppelin/logs/
mkdir -p ws/elasticsearch/logs/
chmod 777 -fR ws/elasticsearch/logs/
mkdir -p ws/kafka/logs/
chmod 777 -fR ws/kafka/logs/
mkdir -p ws/zookeeper/logs/
chmod 777 -fR ws/zookeeper/logs/
mkdir -p ws/shared
chmod 777 -fR ws/shared


mkdir -p ws/zeppelin/notebooks/
chmod 777 -fR ws/zeppelin/notebooks/
cd ws/zeppelin/notebooks/
git init

cd ../../..
mkdir -p ws/zeppelin/conf/
cat > ws/zeppelin/conf/log4j.properties <<- EOF
log4j.rootLogger = INFO, FILE
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%5p [%d] ({%t} %F[%M]:%L) - %m%n
log4j.appender.FILE.DatePattern=.yyyy-MM-dd
log4j.appender.FILE.DEBUG = INFO
log4j.appender.FILE = org.apache.log4j.DailyRollingFileAppender
log4j.appender.FILE.File = /zeppelin/logs/local.log
log4j.appender.FILE.layout = org.apache.log4j.PatternLayout
log4j.appender.FILE.layout.ConversionPattern=%5p [%d] ({%t} %F[%M]:%L) - %m%n
log4j.logger.org.apache.zeppelin.python=DEBUG
log4j.logger.org.apache.zeppelin.spark=DEBUG
EOF
chmod 777 -fR ws/zeppelin/conf/

docker-compose up -d
```

## URLs

| Tool              | URL                         | Credentials    |
| ----------------- | --------------------------- | -------------- |
| zeppelin          | http://localhost:8080/      | - |
| nifi              | http://localhost:8081/nifi/ | - |
| spark             | bitnami/spark:3.0.1                | 7077           | shared-workspace |
| kibana            | kibana/kibana:7.10.1               | 5601           | - |


