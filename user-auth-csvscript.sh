#!/bin/bash
#Upload file into CloudShell

#Make script executable: 	chmod +x tf-user-csvscript.sh

#RUN The Script:		./tf-user-csvscript.sh

#If you get an Error try: 	chmod 755 tf-user-csvscript.sh		(Then Run again.)



#!/bin/bash
CSV_FILE="/home/cloudshell-user/(YOUR FILENAME GOES HERE).csv"  

# Update filename AND path if needed

ACCESS_KEY=$(awk -F',' 'NR==2 {print $1}' "$CSV_FILE")

SECRET_KEY=$(awk -F',' 'NR==2 {print $2}' "$CSV_FILE")



aws configure set aws_access_key_id "$ACCESS_KEY"

aws configure set aws_secret_access_key "$SECRET_KEY"

aws configure set region "us-east-2"

aws configure set output "json"

#VERIFY CONFIGURATION
aws sts get-caller-identity

#Ensure that #!/bin/bash stays on the very first line of this script.
