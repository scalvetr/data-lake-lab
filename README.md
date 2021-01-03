# Data Lakes

## Tools


| Tool              | Image                              | Ports           | Volume           |
| ----------------- | ---------------------------------- | --------------- | ---------------- |
| zookeeper         | zookeeper:3.6.2                    | 2181            | zookeeper-data   |
| kafka             | wurstmeister/kafka:2.13-2.6.0      | 9092            | kafka-logs       |
| nifi              | apache/nifi:1.12.1                 | 9081       | shared-workspace |
| spark-master      | bde2020/spark-master | 8080 | - |
| spark-worker      | bde2020/spark-worker | 8081 | - |
| hadoop-namenode   | bde2020/hadoop-namenode | 50070 | - |
| hadoop-datanode   | bde2020/hadoop-datanode | 50075 | - |
| elasticsearch     | elasticsearch/elasticsearch:7.6.2  | 9200,9300       | - |
| kibana            | kibana/kibana:7.10.1               | 5601            | - |
| zeppelin          | apache/zeppelin:0.9.0              | 9080  | shared-workspace |

## Installation

### Reset
```shell
docker-compose down

docker container prune
docker volume prune
docker network prune
docker image prune -a

sudo rm -fR ws/elasticsearch/logs/*
sudo rm -fR ws/hoadoop/datanode/logs/*
sudo rm -fR ws/hoadoop/datanode/data/*
sudo rm -fR ws/hoadoop/namenode/logs/*
sudo rm -fR ws/hoadoop/namenode/name/*
sudo rm -fR ws/hive/logs/*
sudo rm -fR ws/kafka/logs/*
sudo rm -fR ws/kibana/logs/*
sudo rm -fR ws/spark/master/logs/*
sudo rm -fR ws/spark/worker/logs/*
sudo rm -fR ws/zepelin/logs/*
sudo rm -fR ws/zookeeper/logs/*
```

```shell
mkdir -p ws
chmod a+rw -fR ws/

docker-compose build
docker-compose up -d

mkdir -p ws/zeppelin/notebooks/
chmod 777 -fR ws/zeppelin/notebooks/
cd ws/zeppelin/notebooks/
git init

```
## Debug Nifi
```shell
docker exec big-data-lab-nifi tail -f /opt/nifi/nifi-current/logs/nifi-app.log
```
## Debug Kafka
```shell
# enter kafka server docker container
docker exec -it big-data-lab-kafka /bin/bash
# list topics
kafka-topics.sh --bootstrap-server kafka:9092 --list
# describe topic santander-in-traffic-metrics
kafka-topics.sh --bootstrap-server kafka:9092 --topic santander-in-traffic-metrics --describe
# count messages in topic santander-in-traffic-metrics
kafka-run-class.sh kafka.tools.GetOffsetShell \
  --broker-list kafka:9092 \
  --topic santander-in-traffic-metrics --time -1 --offsets 1 \
  | awk -F  ":" '{sum += $3} END {print sum}'
# read messages in topic santander-in-traffic-metrics
kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic santander-in-traffic-metrics --group cmd-line --from-beginning

```

## Debug Elastiksearch
```shell
curl http://localhost:9200/ | jq
curl http://localhost:9200/_cat/indices
curl http://localhost:9200/sensors-santander-traffic/?pretty | jq
curl http://localhost:9200/sensors-santander-traffic/_count | jq
curl http://localhost:9200/sensors-santander-traffic/_search | jq


```

## Debug 
```shell
# enter kafka server docker container
docker exec -it big-data-lab-hive /bin/bash
schematool -initSchema -dbType derby

```

## URLs

| Tool              | URL                         | Credentials    |
| ----------------- | --------------------------- | -------------- |
| zeppelin          | http://localhost:9080/      | - |
| nifi              | http://localhost:9081/nifi/ | - |
| spark-master      | http://localhost:8080/ | - |
| spark-worker      | http://localhost:8081/ | - |
| hadoop-namenode   | http://localhost:50070/ | - |
| hadoop-datanode   | http://localhost:50075/ | - |


