#!/bin/bash

cd /opt/derby-data

echo "starting derby database"
nohup /opt/derby/bin/startNetworkServer &

cd /opt/hive

echo "initializing schema (will fail if is has been already initialized)"
./bin/schematool -initSchema -dbType derby

echo "Starting hive metastore"
nohup ./bin/hive --service metastore --hiveconf hive.server2.enable.doAs=false --hiveconf hive.log.file=hive-metastore.log &

METASTORE_PORT=${METASTORE_PORT:-"9083"}
echo "Witing until hive metastore is up on port ${METASTORE_PORT}"
/usr/local/bin/wait-fot-it.sh -t 120 -s localhost:${METASTORE_PORT} -- echo "hive metastore is up on port ${METASTORE_PORT}"

echo "Starting hiveserver2"
env SERVICE=hiveserver2;./bin/hive --service hiveserver2 --hiveconf hive.server2.enable.doAs=false

