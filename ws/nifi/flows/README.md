{
    "sensor":"7005",
    "load":0,
    "occupation":0,
    "intensity":0,
    "event_id":"7005-e9f008f9-4fbb-11eb-85f8-005056a43242",
    "event_ts":"2021-01-06T01:04:00Z",
    "location":{"lon":"-3.8231807143523855","lat":"43.466409799959756"}
}
drop table sensors_traffic;
CREATE EXTERNAL TABLE sensors_traffic (event_id string, load int, occupation int, intensity int, event_ts string, sensor string, location struct<lon:string, lat:string>)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
LOCATION 'hdfs://hdfs-namenode:8020/data/santander/sensor_traffic_raw'