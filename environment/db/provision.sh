#!/bin/bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# create files and version of mongodb ==> echo pulling whatever this return
# sudo tee ==> adding information from the source list to the etc/apt/sources file
sudo apt-get update -y
# update ==> update the machine
sudo apt-get upgrade -y
# upgrade the version og mongdb everytime we run vagrant up
sudo apt-get install mongodb-org=3.2.20 -y

sudo rm /etc/mongod.conf

sudo ln -s /home/ubuntu/environment/mongod.conf /etc/mongod.conf

# allow us to control mongodb
sudo systemctl start mongod
sudo systemctl enable mongod
