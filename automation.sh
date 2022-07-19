#! /bin/bash

myname="harishankar"
s3_bucket="upgrad-harishankar"
timestamp=$(date '+%d%m%Y-%H%M%S')

# Perform an update of the package details and the package list at the start of the script
echo "Updating package details and package list"
sudo apt update -y

# Install the apache2 package if it is not already installed
echo "Ensuring apache2  is installed"
if [ `dpkg -l apache2 | grep apache2 | wc -l` == 1 ]
then
	echo "Apache2 is installed"
else
	echo "Apache2 is not installed"
	echo "Installing apache2"
	sudo apt install apache2 -y 
fi

# Ensure that the apache2 service is running
echo "Ensuring apache2  is running"
if [ `systemctl status apache2 | grep running | wc -l` == 1 ]
then
	echo "Apache2 is running"
else
	echo "Apache2 is not running"
	echo "Starting apache2"
	systemctl start apache2 
fi

# Ensure that the apache2 service is enabled
echo "Ensuring apache2  is enabled"
if [ `systemctl status apache2 | grep enabled | wc -l` == 1 ]
then
	echo "Apache2 is enabled"
else
	echo "Apache2 is not enabled"
	echo "Enabilng apache2"
	systemctl enable apache2
fi

# Create a tar archive of apache2 access logs and error logs
echo "Creating a tape archive of the logs"

cd /var/log/apache2
tar -czvf /tmp/${myname}-httpd-logs-${timestamp}.tar *.log

# The script should run the AWS CLI command and copy the archive to the s3 bucket
echo "Copying log archive to S3 bucket"

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar




