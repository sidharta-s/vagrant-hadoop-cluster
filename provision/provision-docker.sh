#!/bin/sh 

echo "Install epel-release repo"
yum install -y epel-release
echo "Install docker"
yum install -y docker-io
echo "Start docker"
service docker start
echo "Pull sequenceiq docker image"
docker pull sequenceiq/hadoop-docker:2.6.0

usermod -G docker yarn
