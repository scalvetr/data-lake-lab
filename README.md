# Data Lakes

## Tools


| Tool              | Image                              | Ports           | Volume           |
| ----------------- | ---------------------------------- | --------------- | ---------------- |
| zookeeper         | zookeeper:3.6.2                    | 2181            | zookeeper-data   |
| kafka             | wurstmeister/kafka:2.13-2.6.0      | 9092            | kafka-logs       |
| nifi              | apache/nifi:1.12.1                 | 8081,8444       | shared-workspace |
| spark             | bitnami/spark:3.0.1                | 7077            | shared-workspace |
| hadoop            | cybermaggedon/hadoop:2.10.0        | 9000,8020,50070 | shared-workspace |
| elasticsearch     | elasticsearch/elasticsearch:7.6.2  | 9200,9300       | - |
| kibana            | kibana/kibana:7.10.1               | 5601            | - |
| zeppelin          | apache/zeppelin:0.9.0              | 8080,8443,4040  | shared-workspace |

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


