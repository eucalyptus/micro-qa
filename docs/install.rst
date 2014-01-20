How to install micro-qa?
========================
You can install micro qa in few different ways. The easiest option would be to install it on your laptop using VirtualBox.

Install using VirtualBox
------------------------
* First install `VirtualBox <https://www.virtualbox.org/>`_, if you are on Fedora then you can install it from rpmfusion repo.

::
	
	# yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	# yum install VirtualBox

 
* Then install `Vagrant <http://www.vagrantup.com/>`_. You can do it with the following command.

::
  
  # yum install https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.3_x86_64.rpm


* Fork the `MicroQA project <https://github.com/eucalyptus/micro-qa>`_. To learn more about forking a project you can read `this link <http://help.github.com/fork-a-repo/>`_.
* Clone your forked repo.

::

	$ git clone https://github.com/your-username/micro-qa.git


* Go inside the git repo and run the following command.

::

	$ vagrant up

This will download a virtual machine, boot it and install micro-qa inside that vm. The download need to happen only once, from next time it will reuse the downloaded files.

* After the above command you can access the micro-qa install by visiting: `http://localhost:8080 <http://localhost:8080>`_.

.. note::  At the end of **vagrant up** command, it will show you the IP of the VM with *ifconfig eth1* command. You can use that IP too in your browser.