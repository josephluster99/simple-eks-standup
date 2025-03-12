#starts building an image FROM amazon/aws-cli:22.22.35 as a base. Docker pulls this from Docker Hub if not Locally.
FROM amazon/aws-cli:2.22.35

#This updates our Linux packages and installs git and unzip. 'git' = cloning code from github. 'unzip' = often being used by terraform.
RUN yum update -y && \
    yum install -y git unzip

#Clones "tfenv"(pretty much the terraform installer/toolbox) from github. Puts it in /root/.tfenv. Makes it to where you can use terraform commands anywhere in the container. Downloads the latest terraform version and always uses it. LOTS going on in this one.)    
RUN git clone https://github.com/tfutils/tfenv.git /root/.tfenv && \
    ln -s /root/.tfenv/bin/* /usr/local/bin && \
    tfenv install latest && \
    tfenv use latest

    #Sets the containers default directory to work. Pretty much the same as doing:  cd /work 
WORKDIR /work

#Tells docker to run /bin/bash as the main process. Allows us to start in a bash shell upon starting the container.
ENTRYPOINT [ "/bin/bash" ]


#1.) Use this in the AWWS CLOUDSHELL Terminsl to build THIS Docker IMAGE. (Only run on your first time or if you modify your docker file!)(This will be stored locally after being ran once.)
#docker build -t docker_awscli_terraform_tfenv -f docker_awscli_terraform_tfenv.dockerfile .       (Include the period at the end too)(-t tags the name. -f Uses the specific following file name as the docker file)

#2.) Run this command for the container.
#docker run -it --rm -v ${PWD}:/work docker_awscli_terraform_tfenv

#3.Optional.) Manually DELETING THE IMAGE from your Machine.
#docker rmi docker_awscli_terraform_tfenv

#By Joseph Luster
