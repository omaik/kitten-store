#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
yum install docker -y
service docker start
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
yum install git -y
cd /home/ec2-user
git clone https://github.com/omaik/kitten-store.git
cd kitten-store
echo "DATABASE_URL=${database_url}" >> ops/compose/dev.env
sh ops/scripts/up.sh
