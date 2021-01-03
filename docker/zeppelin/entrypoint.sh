#!/bin/bash

if test -f "/zeppelin/conf/interpreter-override.json"; then
    cat /zeppelin/conf/interpreter-override.json > /zeppelin/conf/interpreter.json
fi

exec $@
