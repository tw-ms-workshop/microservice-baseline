#!/bin/bash

echo "Working directory is: "
pwd

echo "Files in directory:" 
ls -alR build/libs/

SERVER_USER="ec2-user"
BUILD_NUMBER=$SNAP_PIPELINE_COUNTER

echo "Killing old application"
ssh ${SERVER_USER}@${SERVER_IP} "pkill -9 -f .jar"

echo "Archive old versions"
ssh ${SERVER_USER}@${SERVER_IP} "mkdir archive"
ssh ${SERVER_USER}@${SERVER_IP} "mv *.jar archive/"

echo "Deploying ${SERVICE_NAME} to ${SERVER_IP}"
scp build/libs/*.jar ${SERVER_USER}@${SERVER_IP}:/home/${SERVER_USER}/

echo "Starting new application"
ssh ${SERVER_USER}@${SERVER_IP} "nohup java -jar /home/${SERVER_USER}/*.jar &> hello_world.log &"
