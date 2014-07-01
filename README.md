micro-qa
========

Self Contained Automated Test Environment

## Setting up with Virtual Box
1.  Download and install [VirtualBox](https://www.virtualbox.org)

2.  Download and install [Vagrant >= 1.6.3](http://www.vagrantup.com/)

3.  Do a fork of MicroQA project (requires github account for information on how to set up a Github account, refer to the following URL: [http://help.github.com/set-up-git-redirect/](http://help.github.com/set-up-git-redirect/)).  On information on how to fork a project, refer to the following link: [http://help.github.com/fork-a-repo/](http://help.github.com/fork-a-repo/).

4. Clone your fork to your local machine.

5. Install the Vagrant plugins:
   ```
        vagrant plugin install vagrant-berkshelf --plugin-version '>= 2.0.1'
        vagrant plugin install vagrant-omnibus
   ```

6. Once inside the repository run "vagrant up". This will download a virtual machine, boot it, and install MicroQA.

7. Login to MicroQA on your browser by visiting: http://localhost:8080

## Setting up with AWS or Eucalyptus
1.  Download and install [Vagrant >= 1.6.3](http://www.vagrantup.com/)

2. Install the Vagrant plugins:
   ```
	      vagrant plugin install vagrant-aws
        vagrant plugin install vagrant-berkshelf --plugin-version '>= 2.0.1'
        vagrant plugin install vagrant-omnibus
   ```

3. Do a fork of MicroQA project (requires github account for information on how to set up a Github account, refer to the following URL: [http://help.github.com/set-up-git-redirect/](http://help.github.com/set-up-git-redirect/)).  On information on how to fork a project, refer to the following link: [http://help.github.com/fork-a-repo/](http://help.github.com/fork-a-repo/).

4. Clone your fork to your local machine.

5. Edit the following parameters in the Vagrantfile:
    ```
    aws.access_key_id = "XXXXXXXXXXXXXXXXXX"
    aws.secret_access_key = "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
    aws.instance_type = "m1.medium"
    ## This CentOS 6 EMI needs to have the following commented out of /etc/sudoers,
    ## Defaults    requiretty
    aws.ami = "emi-1873419A"
    aws.security_groups = ["default"]
    aws.region = "eucalyptus"
    aws.endpoint = "http://10.0.1.91:8773/services/Eucalyptus"
    aws.keypair_name = "vic"
    override.ssh.username ="root"
    override.ssh.private_key_path ="/Users/viglesias/.ssh/id_rsa"
    ```

6. Install a "dummy" vagrant box file to allow override of the box with the ami/emi:
   ```
   vagrant box add centos https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
   ```
6. Once inside the repository run "vagrant up --provider=aws". This will run a virtual machine, and install MicroQA in your cloud.

7. Login to MicroQA on your browser by visiting: http://\<instance-ip\>:8080

## Guidelines for Contributing to MicroQA
1. Create a test job from the MicroQA Jenkins instance (or edit an existing job)
  * Click the _New Job_ link.
  * Enter a descriptive job name and use the _Copy existing job_ option to pick a job that is similar to what you want to do (or a new empty job is there are no similar jobs).
  * After the job is created, then _Configure_ the job to do what you want it to do.
  * Add a description to the job by clicking _edit description_ on the job page. The description should be very clear about what the job does. Make sure that your job's use case is general enough to be useful to other people.

2. Test your job and ensure it's working like you want.

3. From your micro-qa directory login to the instance using the command: "vagrant ssh"

4. Run the command "jenkins-sync" inside the vagrant instance.

5. Exit the vagrant shell then commit your changes to the MicroQA repo.

6. Once your commit is available on GitHub submit a pull request to the upstream repository.

Make sure that each pull request you submit contains a single new job, or fixes to a single job. Try not to combine too many changes in a single pull request.
