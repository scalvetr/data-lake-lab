# Data Lakes

## Tools

| Tool              | Image                              | Ports            | Volume           |
| --------------- | ------------------------------------ | ---------------- | ---------------- |
| zookeeper       | zookeeper:3.6.2                      | 2181             | /logs   |
| kafka           | wurstmeister/kafka:2.13-2.6.0        | 9092             | /opt/workspace,/opt/kafka/logs |
| nifi            | apache/nifi:1.12.1                   | 9081             | /opt/workspace,/opt/nifi/nifi-current/logs |
| hadoop-namenode | bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8 | 50070 | /opt/workspace,/opt/hadoop-2.7.4/logs,/hadoop/dfs/name |
| hadoop-datanode | bde2020/hadoop-datanode:2.0.0-hadoop2.7.4-java8 | 50075 | /opt/workspace,/opt/hadoop-2.7.4/logs,/hadoop/dfs/data |
| spark-master    | bde2020/spark-master:2.4.0-hadoop2.7 | 8080 | /opt/workspace,/spark/logs |
| spark-worker    | bde2020/spark-worker:2.4.0-hadoop2.7 | 8081 | /opt/workspace,/spark/logs |
| hive            | local-image -> apache-hive-2.3.7    | 9083,10000,10001,10002 | /opt/workspace,/opt/derby-data,/opt/hive/logs |
| elasticsearch   | elasticsearch/elasticsearch:7.10.1   | 9200,9300        | /opt/workspace,/usr/share/elasticsearch/logs |
| kibana          | kibana/kibana:7.10.1                 | 5601             | /opt/workspace,/opt/kibana/logs |
| mysql           | mysql:8.0.22                         | 3306             | /var/log/mysql,/var/lib/mysql,/etc/mysql/conf.d |
| zeppelin        | local-image -> apache/zeppelin:0.9.0 | 9080             | /opt/workspace,/zeppelin/notebook,/zeppelin/logs |

## Installation

### Start
```shell
docker-compose up
```

### Reset
```shell
docker-compose down

docker container prune
docker volume prune
docker network prune
docker image prune -a

sudo rm -fR ws/elasticsearch/logs/*
sudo rm -fR ws/hadoop/datanode/logs/*
sudo rm -fR ws/hadoop/datanode/data/*
sudo rm -fR ws/hadoop/namenode/logs/*
sudo rm -fR ws/hadoop/namenode/name/*
sudo rm -fR ws/hive/logs/*
sudo rm -fR ws/kafka/logs/*
sudo rm -fR ws/kibana/logs/*
sudo rm -fR ws/spark/master/logs/*
sudo rm -fR ws/spark/worker/logs/*
sudo rm -fR ws/zepelin/logs/*
sudo rm -fR ws/zookeeper/logs/*
```

## Nifi Commands
```shell
docker exec big-data-lab-nifi tail -f /opt/nifi/nifi-current/logs/nifi-app.log
```

## Kafka Commands
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

## Elasticsearch Commands
```shell
curl http://localhost:9200/ | jq
curl http://localhost:9200/_cat/indices
curl http://localhost:9200/sensors-santander-traffic/?pretty | jq
curl http://localhost:9200/sensors-santander-traffic/_count | jq
curl http://localhost:9200/sensors-santander-traffic/_search | jq
curl -X DELETE "http://localhost:9200/sensors-santander-traffic"
```

## Zeppelin Commands
```shell
# execute every time there are changes in the interpreters
docker cp big-data-lab-zeppelin:/zeppelin/conf/interpreter.json ws/zeppelin/conf/interpreter.json
```

## Hive Commands
```shell
# enter hive server docker container
docker exec -it big-data-lab-hive /bin/bash
cd /opt/hive
./bin/hive -e "CREATE DATABASE SANTANDER_DATA"


./bin/hive -e "DROP TABLE sensors_traffic"
# for json data
./bin/hive -e "CREATE TABLE IF NOT EXISTS CREATE EXTERNAL TABLE sensors_traffic \
(event_id varchar(30), load int, occupation int, intensity int, event_ts varchar(30), sensor varchar(30), location struct<lon:varchar(30), lat:varchar(30)>) \
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' \
LOCATION 'hdfs://hdfs-namenode:8020/data/santander/sensor_traffic';"


./bin/hive -e "CREATE TABLE IF NOT EXISTS sensors_traffic_stream( \
event_id string, 
load int,
occupation int,
intensity int,
event_ts String,
sensor String, \
lon String, lat String) \
COMMENT 'Traffic Sensors' \
PARTITIONED BY (`loaded_ts` string) \
CLUSTERED BY (event_id) INTO 16 BUCKETS \
STORED AS ORC \
TBLPROPERTIES('transactional'='true');"


./bin/hive -e "SELECT * sensors_traffic"
```

## MySql Commands
```shell

# access mysql cli
docker exec -it big-data-lab-mysql /usr/bin/mysql -u big-data-user -p
use big-data-db
show tables;
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


