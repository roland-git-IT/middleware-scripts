#!/bin/bash

# Description: Install Sonarqube
# Author: Roland Udo-Akang
# Date: 2/22/2022

echo "SonarQube Installation begin..."
sleep 4
#--------------------------------------------------
echo "Updating system... This might take a while"
sleep 4
sudo yum update -y
#--------------------------------------------------
sleep 4
echo "Installing Java. Please wait..."
sudo yum install java-11-openjdk-devel -y
sleep 4
#--------------------------------------------------
cd /opt
echo "Checking for wget package..."
rpm -q wget
if [ $? -eq 0 ]
then
echo "Package already installed"
else
echo "Package not installed"
echo "Attempting to install package. Please Wait..."
sleep 4
sudo yum install wget -y
echo "Installation Complete!"
fi
#--------------------------------------------------
echo "Downloading SonarQube package. Please wait..."
sleep 4
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.3.0.51899.zip
echo "Download Complete!"
#--------------------------------------------------
echo "Extracting Package..."
sleep 4
rpm -q unzip
if [ $? -ne 0 ]
then
sudo yum install unzip -y
fi
sudo unzip /opt/sonarqube-9.3.0.51899.zip
echo "Extraction Complete"
#--------------------------------------------------
sleep 4
echo "Changing ownership to files..."
sudo chown -R $USER:$GROUP /opt/sonarqube-9.3.0.51899
sleep 4
echo "Starting Sonar service..."
cd /opt/sonarqube-9.3.0.51899/bin/linux-x86-64
./sonar.sh start
if [ $? -eq 0 ]
then
echo "SonarQube Installation Complete!"
sleep 2
else
echo "Installation Failed!"
fi
#--------------------------------------------------
echo "Checking Firewall state. Please Wait..."
sleep 4
ANSWER=non
sudo firewall-cmd --state
if [ $? -ne 0 ]
then
echo "Firewall is not running. Do you want to enable firewall? 'y or n'"     
while [ $ANSWER = non ]
do
read ANSWER
if [ $ANSWER = y ]
then
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=9000/tcp
sudo firewall-cmd --reload
elif [ $ANSWER != y || $ANSWER != n ]
then
echo "Invalid response. Type 'y or n'"
ANSWER=non
fi
done
fi
sudo firewall-cmd --state
if [ $? -eq 0 && $ANSWER != y ]
then
sudo firewall-cmd --permanent --add-port=9000/tcp
fi
#--------------------------------------------------
clear
echo "You're all set!!"
echo -e "Open your browser and type in your address bar as follows:\n$(hostname -I|awk '{print $2}'):9000"
echo -e "The default credentials are as follows:\nLogin: admin\nPassword: admin"
