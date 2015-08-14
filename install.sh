#!/bin/bash

IGNITE_VERSION=1.1.0-incubating

git pull

mvn clean package -DskipTests \
  -Dignite.version=$IGNITE_VERSION
