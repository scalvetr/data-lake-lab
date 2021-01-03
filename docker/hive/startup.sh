#!/bin/bash

cd /opt/derby-data

echo "starting derby database"
nohup /opt/derby/bin/startNetworkServer &

cd /opt/hive

echo "starting metastore"
nohup ./bin/hive --service metastore --hiveconf hive.server2.enable.doAs=false &

echo "starting hiveserver2"
./bin/hive --service hiveserver2 --hiveconf hive.server2.enable.doAs=false

