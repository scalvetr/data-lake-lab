#!/bin/bash

cd /opt/derby-data

echo "starting derby database"
nohup /opt/derby/bin/startNetworkServer &

cd /opt/hive

echo "initializing schema (will fail if is has been already initialized)"
./bin/schematool -initSchema -dbType derby

echo "starting metastore"
nohup ./bin/hive --service metastore --hiveconf hive.server2.enable.doAs=false &

echo "starting hiveserver2"
./bin/hive --service hiveserver2 --hiveconf hive.server2.enable.doAs=false

