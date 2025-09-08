#!/bin/bash

cd
cd eadn/
cd postgres/
docker stack deploy -c postgres-stack.yml postgres
cd ..
cd gitea/ 
docker stack deploy -c gitea-stack.yml gitea
cd ..
cd app/
docker stack deploy -c app-stack.yml app
cd ..
cd haproxy/ 
docker stack deploy -c haproxy-stack.yml haproxy
cd ..
cd jenkins/
docker stack deploy -c jenkins-stack.yml jenkins
cd ..
cd nexus/
docker stack deploy -c nexus-stack.yml nexus
cd ..
echo "done"
docker service ls 

