#!/bin/bash
#
# A bash script to run CircleCI node/test in parallel
#

NODE_INDEX=${CIRCLE_NODE_INDEX:-0}

set -e

if [ "$NODE_INDEX" = "1" ]; then
  echo "Running node $NODE_INDEX to test 'samples.circleci' defined in pom.xml ..."
  #cp CI/pom.xml.circleci pom.xml
  java -version
  mvn --quiet verify -Psamples.circleci
elif [ "$NODE_INDEX" = "2" ]; then
  echo "Running node $NODE_INDEX to test ensure-up-to-date"
  java -version
  #export GO_POST_PROCESS_FILE="/usr/local/bin/gofmt -w"
  # not formatting the code as different go versions may format the code a bit different
  ./bin/utils/ensure-up-to-date
elif [ "$NODE_INDEX" = "3" ]; then
  echo "Running node $NODE_INDEX to test php"
  php -v
  # install composer
  wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet
  mvn --quiet verify -Psamples.php
else
  echo "Running node $NODE_INDEX to test 'samples.circleci.jdk7' defined in pom.xml ..."
  sudo update-java-alternatives -s java-1.7.0-openjdk-amd64
  java -version
  #cp CI/pom.xml.circleci.java7 pom.xml
  mvn --quiet verify -Psamples.circleci.jdk7
fi


