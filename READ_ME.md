rHere we are deploying a VPC Infrastructure to AWS using Terraform and AWS CloudShell.
We will also be working inside of a custom docker image for almost the whole project in order to keep our local machine clean. (CloudShell for this instance.)



**1. Open Cloud Shell.**
- Navigate to https://console.aws.amazon.com/ 
- Sign into your AWS account. (This tutorial assumes account and user creation have been established already.)
- Click the CloudShell Icon in the top right corner of the AWS Console Home Page.



**2. Configure the Cloud Shell Session With Your AWS Credentials.**
- NOTE: You will need access to your AWS “Access Key ID”, “Secret Access Key”, Region of Choice, and a preferred output format.
  Run     aws configure
- Paste your credentials as prompted.
- (If you obtain your keys through a .CSV file, you can use the shell script (will be added soon) called "user-auth-csvscript.sh" to authenticate to cloud shell. Ensure you open the script and change the name and file path to   one that references YOUR CSV file.)


**2.A. Using the Script: Optional**
- Upload file into CloudShell
- Make script executable:

      chmod +x user-auth-csvscript.sh
  
- RUN The Script

      ./user-auth-csvscript.sh

- If you get an Error try:

      chmod 755 tf-user-csvscript.sh
- (Then Run again.)

Successful Expected Output Should be:


 {
 "UserId": "(your user ID)",
 "Account": "(your AWS account ID)",
 "Arn": "arn:aws:iam::(your account ID):user/terraform-user"
 }

  
**3. Upload docker_aws_terraform_tfenv.dockerfile to CloudShell.**


   
**4. Upload main.tf and provider.tf to the same directory.**



**5. Build your Docker Image in CloudShell.**
In the Current Directory, run:

      docker build -t docker_awscli_terraform_tfenv -f docker_awscli_terraform_tfenv.dockerfile .


-  (Include the period at the end too)
-  (-t tags the name. -f Uses the specific following file name as the docker file)



**6. Create a Container From the Image.**
In that Same Directory, run:

      docker run -it --rm -v ${PWD}:/work docker_awscli_terraform_tfenv


                      _This command does the following_
- `-it`: Runs in interactive mode with a terminal.
- `--rm`: Deletes the container when it stops.
- `-v ${PWD}:/work`: Mounts the current directory to '/work' inside the container.
- The container should be ready in a minute or so.



**7. Verify Terraform is Installed**
Inside the running container, check the Terraform version:
   
   terraform --version


**8. Initializing Terraform - Downloading AWS Provider Plugins and Preparing Terraform’s State**
Inside the running container, run:
   
    terraform init



**9. Create a Terraform “Plan”**
Inside the running container, run:

    terraform plan -out=myplan.tfplan 


- Shows Potential Changes Before They’re Applied. 
- The –out flag saves the plan to a file. (example.tfplan)


**10. Deploying/Applying The Terraform Plan**
Inside the running container, run:

    terraform apply myplan.tfplan

    
- Respond to the prompt w/ "yes" if there are no errors.
- This cant take more than 10 minutes.
- Resources Have Now Been Created!



**11. Verify Resource Creation Inside AWS Console.**


**12. Destroy Everything. If You’re Done w/The Resources.**
Inside the running container, run:
      
      terraform destroy
      
- Destroys Everything You Made in that session.
- Be sure to confirm on Console that it was Destroyed.


