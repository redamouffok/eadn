#!/bin/bash

cd
cd eadn/
cd postgres/
docker stack deploy -c postgres-stack.yml stack
cd ..
cd gitea/ 
docker stack deploy -c gitea-stack.yml stack
cd ..
cd app/
docker stack deploy -c app-stack.yml stack
cd ..
cd haproxy/ 
docker stack deploy -c haproxy-stack.yml stack
cd ..
cd jenkins/
docker stack deploy -c jenkins-stack.yml stack
cd ..
cd nexus/
docker stack deploy -c nexus-stack.yml stack
cd ..
echo "done"
docker service ls 

