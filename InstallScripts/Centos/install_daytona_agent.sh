#!/bin/bash

source config.sh

# echo -e "Updating Linux...\n"
# update & upgrade #
# sudo yum update -y

# Set up the ExecScripts directory
cp -r ../../ExecScripts /tmp

# Setup Daytona sarmonitor
cp -r ../../Scheduler+Agent/daytona_sarmonitor /tmp

# Install sysstat for sar and iostat
sudo yum install sysstat -y

# Install Strace
sudo yum install strace -y

if ! [ -d "$daytona_install_dir/Scheduler+Agent" ]; then
    mkdir -p $daytona_install_dir
    cp -r ../../Scheduler+Agent $daytona_install_dir
fi

cd $daytona_install_dir/Scheduler+Agent

# Setup config file
rm -rf config.ini
printf "[DH]\ndh_root:"$daytona_data_dir"\nport:52222\nmysql-user:"$db_user"\nmysql-db:"$db_name"\nmysql-host:"$db_host"\nmysql-password:"$db_password"\n" >> config.ini
printf "email-user:"$email_user"\nemail-server:"$email_domain"\nsmtp-server:"$smtp_server"\nsmtp-port:"$smtp_port"\n\n" >> config.ini
printf "[AGENT]\nagent-root:/tmp/daytona_root/test_data_AGENT/\nmon-path:/tmp/daytona_sarmonitor/bin/\nport:52223" >> config.ini

# Start Agent
sudo nohup python ./agent.py > agent_nohup.out 2>&1 &

cd -
