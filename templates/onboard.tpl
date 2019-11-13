#!/bin/bash

# BIG-IPS ONBOARD SCRIPT

LOG_FILE=${onboard_log}

if [ ! -e $LOG_FILE ]
then
     touch $LOG_FILE
     exec &>>$LOG_FILE
else
    #if file exists, exit as only want to run once
    exit
fi

exec 1>$LOG_FILE 2>&1


# CHECK TO SEE NETWORK IS READY
CNT=0
while true
do
  STATUS=$(curl -s -k -I github.com | grep HTTP)
  if [[ $STATUS == *"301"* ]]; then
    echo "Got 301! VE is Ready!"
    break
  elif [ $CNT -le 6 ]; then
    echo "Status code: $STATUS  Not done yet..."
    CNT=$[$CNT+1]
  else
    echo "GIVE UP..."
    break
  fi
  sleep 10
done


### DOWNLOAD ONBOARDING PKGS
# Could be pre-packaged or hosted internally
admin_username='${uname}'
admin_password='${upassword}'
CREDS="$admin_username:$admin_password"
DO_URL='${DO_onboard_URL}'
DO_FN=$(basename "$DO_URL")
AS3_URL='${AS3_URL}'
AS3_FN=$(basename "$AS3_URL")
REST_PORT=${restPort}

mkdir -p ${libs_dir}

echo -e "\n"$(date) "Download Declarative Onboarding Pkg"
echo "Execute: curl -L -o ${libs_dir}/$DO_FN $DO_URL"
curl -L -o ${libs_dir}/$DO_FN $DO_URL

echo -e "\n"$(date) "Download AS3 Pkg"
echo "Execute: curl -L -o ${libs_dir}/$AS3_FN $AS3_URL"
curl -L -o ${libs_dir}/$AS3_FN $AS3_URL
echo "Sleep 20 Seconds"
sleep 20

# Check if the mcpd deamon is up and running
CNT=0
while true
do
  STATUS=$(bigstart status mcpd)
  if [[ $STATUS == *"run"* ]]; then
    echo "mcpd is running!"
    break
  elif [ $CNT -le 1800 ]; then
    echo "mcpd is not running yet...wait $CNT s"
    CNT=$[$CNT+30]
  else
    echo "GIVE UP..."
    break
  fi
  sleep 30
done

# SET USER PASSWORD
STATUS=$(tmsh list /auth user $admin_username)
if [[ $STATUS == "" ]]; then
  echo "User \"$admin_username\" not found. Create new user!"
  tmsh create /auth user $admin_username partition-access add { all-partitions { role admin } } description "Admin User" shell bash password $admin_password
else
  echo "Modify password of \"$admin_username\"."
  tmsh modify /auth user $admin_username password $admin_password
fi


# Copy the RPM Pkg to the file location
mkdir -p /var/config/rest/downloads/
cp ${libs_dir}/*.rpm /var/config/rest/downloads/

# Install Declarative Onboarding Pkg
DATA="{\"operation\":\"INSTALL\",\"packageFilePath\":\"/var/config/rest/downloads/$DO_FN\"}"
echo -e "\n"$(date) "Install DO Pkg"
curl -u $CREDS -X POST http://localhost:8100/mgmt/shared/iapp/package-management-tasks -d $DATA

# Install AS3 Pkg
DATA="{\"operation\":\"INSTALL\",\"packageFilePath\":\"/var/config/rest/downloads/$AS3_FN\"}"
echo -e "\n"$(date) "Install AS3 Pkg"
curl -u $CREDS -X POST http://localhost:8100/mgmt/shared/iapp/package-management-tasks -d $DATA

# Check DO Ready
CNT=0
while true
do
  STATUS=$(curl -u $CREDS -X GET -s -k -I https://localhost:$REST_PORT/mgmt/shared/declarative-onboarding | grep HTTP)
  if [[ $STATUS == *"200"* ]]; then
    echo "Got 200! Declarative Onboarding is Ready!"
    break
  elif [ $CNT -le 9 ]; then
    echo "Status code: $STATUS  DO Not done yet..."
    CNT=$[$CNT+1]
  else
    echo "GIVE UP..."
    break
  fi
  sleep 10
done

# Check AS3 Ready
CNT=0
while true
do
  STATUS=$(curl -u $CREDS -X GET -s -k -I https://localhost:$REST_PORT/mgmt/shared/appsvcs/info | grep HTTP)
  if [[ $STATUS == *"200"* ]]; then
    echo "Got 200! AS3 is Ready!"
    break
  elif [ $CNT -le 9 ]; then
    echo "Status code: $STATUS  AS3 Not done yet..."
    CNT=$[$CNT+1]
  else
    echo "GIVE UP..."
    break
  fi
  sleep 10
done


