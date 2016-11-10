#!/bin/bash

set -e

SERVICE_NAME="hello-world"
SERVER_USER="ubuntu"

echo "Deploying ${SERVICE_NAME} to ${SERVER_IP}"

scp build/libs/*.jar ${SERVER_USER}@${SERVER_IP}:/home/ubuntu/${SERVICE_NAME}.jar

echo "Deployment finished"

echo "Killing old application"
ssh ${SERVER_USER}@${SERVER_IP} "pkill -f ${SERVICE_NAME}.jar"

echo "Starting application"
ssh ${SERVER_USER}@${SERVER_IP} "nohup java -jar /home/ubuntu/${SERVICE_NAME}.jar &> ${SERVICE_NAME}.log &"
