#!/bin/sh -x

sudo salt-call state.apply profiles.docker --local
        
# Check tools
docker-compose --version
docker --version
drone --version
