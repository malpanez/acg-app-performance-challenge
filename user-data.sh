#!/bin/bash

# Download and install necessary packages
yum update -y
yum install -y gcc
amazon-linux-extras install vim python3.8 postgresql11 postgresql-server postgresql-devel git -y

# Install PostgreSQL
/usr/bin/postgresql-setup --initdb
systemctl enable postgresql
systemctl start postgresql

# Download source code from GitHub
git clone https://github.com/ACloudGuru/elastic-cache-challenge.git

# Create Python Virtual Environment and install pre-requisites
pip3 install virtualenv
mkdir app
cd app
python3 -m virtualenv venv
. venv/bin/activate
pip3 install flask psycopg2-binary configparser redis