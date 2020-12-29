# Features

 - AWS
 - Terraform
 - Ansible
 - Docker
 - Jenkins
 - GitHub

## GitHub

 1. Create a new repository eg: **jenkins-docker**
 2. Initialise git using `git init` in your local system
 3. Add the `Dockerfile` and `website files` to the git directory 
 4. Add the repository URL to local `git remote add <origin> <url>`
 5. Add the files to git locally using `git add ./`
 6. Commit the files `git commit -m "message" ./`
 7. Push the files to the `master` branch `git push origin master` and provide the login details
 8. Files will appear the GitHub repository

## Terraform

`jenkinsec2.tf` is used to create 3 Amazon linux instances
 - `jenkinsserver` is used to create an Jenkins instance using `jenkins.sh`
 - `jenkinsbuild` is used by the Jenkins server to build the website docker image and push it to the dockerhub
 - `jenkinstest` is where docker website container is running and use to access the website

`random.tf` is to randomly provide the subnet id to `jenkinsec2.tf` for creating instances

## Ansible

Copy files `deployment.yml` , `hosts`  to the Jenkins server

`deployment.yml`  on **jenkinsbuild** server created using Terraform:

 - `repo_url` URL of the git repository of `Dockerfile`
 - `repo_dest` clone destination in the Jenkins server
 - `image_name` name of the Docker image to create
 - install docker, git packages
 - clones the git repository from `repo_url` to `repo_dest`
 - Login to the Docker Hub
 - Build the image using `Dockerfile` at `repo_dest` and push it to your Docker Hub repository
 - Removes the image from the **build** server
---
`deployment.yml`  on **jenkinstest** server created using Terraform:

 - Installs docker package
 - Pulls the **image** and run on the server on port `80:80`

## Jenkins

Runs on port `8080` of **jenkinsserver** which can be accessed on browser using `http://<ip>:8080`

 - Provide the password from file `/var/lib/jenkins/secrets/initialAdminPassword`
 - Choose `install suggested plugins`
 - Create a **user** to access Jenkins portal and **password**
 - After setup "Manage Jenkins --> Manage plugins --> available --> Search for **Ansible** --> Install without restart"
 - Restart Jenkins service
 - Login to the Jenkins server and goto `/etc/ansible/ansible.cfg`
  Enable `host_key_checking = False`
  
 - Create new job
 - Choose a name and select "Freestyle project"
 - Under **Source Code Management** select `git`
 - Provide **Repository URL**
 - Under **Build Triggers** , select `GitHub hook trigger for GITScm polling`
 - Under **Build**, choose `Invoke Ansible Playbook` 
 
   `Playbook path`: path of `deployment.yml`
      eg: `/var/deployment/deployment.yml`

    `File or host list`: path of `hosts`
      eg: `/var/deployment/hosts`

     Add `Credentials`and choose `</ec2user/>`: 

> Kind: SSH username with private key
> ID: </ec2user/>
> Description: </ec2user/>
> Username: ec2-user
> Private Key: Enter directly --> Add Key--> Add

  Enable `Disable the host SSH key check` from `Advanced`

 - Save
 - Go to Dashboard
 - Select `Manage Jenkins`
 - Select `Global Tool Configuration`
 - Under **Ansible** : provide the ansible binary path eg: `/bin/` ( `which ansible` on Jenkins server )
 - Save
   
### Goto Github: 
 - Goto to the repository and select `settings`
 - Select **Webhooks**
 - Add payload URL eg : `http://<ip>:8080/github-webhook/`
 - Save the webhook

### Goto Jenkins:

 - Select the project and click `Build Now`


## Working

When any changes in the website is pushed into the GitHub repositor,  **Jenkins** detects the changes and executes the **Ansible** file for building docker images and container.
