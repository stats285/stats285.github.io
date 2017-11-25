---
layout: default 
---


# Assignment 02

In this assignment, we will conduct a collaborative project testing certain theoretical hypotheses
in Deep Learning. In particular, each of you will build **your own personal SLURM cluster** on Google Compute Engine (GCE) using [elasticluster](https://gc3-uzh-ch.github.io/elasticluster/)
and then run massive computational experiments using [clusterjob](http://clusterjob.org). We then collect and analyse all the results you will generate and document
our observations.
Please follow the following step to setup your cluster and run experiments. This documents only contains the detail of setting up your cluster and testing that it works properly with GPUs. Once these steps are completed, you should conduct your experiments as assigned to you on Canvas. The details of the experiment will **only** be available via Stanford Canvas website to students who are taking this course for credit.    

# Acknowledgements
* We would like to thank [Google Cloud Platform Education Grants](https://cloud.google.com/edu/) Team for their generosity and kindness in providing Stats285 course with cloud computing grant.
* We would like to thank [ElastiCluster](http://elasticluster.readthedocs.io/en/latest/) team especially [Dr. Riccardo Murri](https://www.gc3.uzh.ch/people/rm/) for their help and collaboration on this project.



# FAQ 
Please visit the [frequently asked questions](faq) before you submit a question on our [Google group](https://groups.google.com/forum/#!forum/clusterjob).



# Building your cluster on Google Cloud Platform

To create your own cluster on Google Compute Engine, you should take the following 4 steps:

1. [Setup Google Compute Engine](#part-1-setup-google-compute-engine)      
2. [Install Docker](#part-2-install-docker)   
3. [Create your cluster using dockerized ElastiCluster](#part-3-create-your-cluster-using-elasticluster)      
4. [Test your cluster with ClusterJob](#part-4-test-your-cluster-with-clusterjob)    



## Part-1: Setup Google Compute Engine

* Claim your $200 Google Compute [Credit](https://canvas.stanford.edu/courses/73102/discussion_topics/160558). Please note that you received two tickets ($50+$150) from Google Cloud. Please check the `comment` section of the [canvas link](https://canvas.stanford.edu/courses/73102/discussion_topics/160558) for the $150 ticket. You will also get $300 free credit from Google Cloud as a first time user by setting up your [Billing Account](https://console.cloud.google.com/billing). However, these 300$ allows only very limited CPU computations.
* <a id="proj-id"></a> Create a Google Project by Visiting [Manage resources](https://console.cloud.google.com/cloud-resource-manager?_ga=2.13784503.-1419916998.1496658742) (This may take some time, be patient). You may find your project ID here which will be needed later.

* <a id="gce-cred"></a>Visit [Google Credential page](https://console.cloud.google.com/project/_/apiui/credential), and creat your credentials `client_id`, `client_secret`
   1. select **Create credentials**
   2. select **OAuth client ID**
   3. select  **Configure conset screen**    
        * Choose your **project name** and **save**
   4. If prompted for **Application Type** choose **Other**    
        * choose a name for your application (say `elasticluster`)
   5. select **Create** 

        > Once successful, the interface will show your `client_id`  and `client_secret`.
        > These values appear at the Credentials tab and you may retrive them at a later time by clicking on your application name (step 4).

    6. **Enable** Google Compute for your project by visiting  [Enable Compute Engine](https://console.developers.google.com/apis/api/compute.googleapis.com)
    7. **Enable** Billing for your project by visiting [Enable Billing](https://console.developers.google.com/projectselector/billing/enable?redirect=https:%2F%2Fdevelopers.google.com%2Fplaces%2Fweb-service%2Fusage%3FdialogOnLoad%3Dbilling-enabled)
    8. Go to [Metadata](https://console.cloud.google.com/compute/metadata/sshKeys) and add your `~/.ssh/id_rsa.pub` contents to SSH Keys on Google.
    > If you fail to satisfy 6,7, and 8 above, your instances will not start and you get errors. Make sure you enable these.

    9. Go to [quota page](https://console.cloud.google.com/projectselector/iam-admin/quotas), choose your project, then **EDIT QUOTAS** and request 8 NVIDIA K80 GPUs at `us-west1` zone. You will need this to use GPU accelerators. The default GPU quota is zero. For “justification” write “stats285”.

    If you are unable to choose the GPU service, then the billing account associated with your project is incorrect. In this case, change the billing account to one of the STATS285 credits you have recived as shown in [FAQ item 4](faq).        
    <span style="color:red"> ** DO NOT REQUEST MORE THAN 8 **, otherwise you will have to pay $1500 deposit in advance. </span>

For more info on obtaining your Google credentials, you may visit [googlegenomics](http://googlegenomics.readthedocs.io/en/latest/use_cases/setup_gridengine_cluster_on_compute_engine/)     

## Part-2: Install Docker    
Docker containers provide an easy way for us to use elasticluster. In fact, we have already 
dockerized elasticluster for Stats285 and so we will use [this docker images](https://hub.docker.com/r/stats285/elasticluster/)
which comes with elasticluster installed. To use this image on your personal computer, follow the following steps:
 
* Visit [Docker Website](https://www.docker.com/community-edition#/download) and install it for your operating system
* Once docker installation is complete, Check your installation by searching docker repositories for `stats285`:    
    ```bash
    $ docker search stats285
    NAME                                DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
    stats285/elasticluster              Dockerized elasticluster for Stanford cour...   0                                       
    stats285/elasticluster-gpu          Dockerized elasticluster with GPU function...   0                                       [OK]
    ```
    we will be using `stats285/elasticluster-gpu`, which is the GPU-enabled version of elasticluster and can be found at [Docker Hub](https://hub.docker.com/r/stats285/elasticluster-gpu/)

* Go ahead and pull `stats285/elasticluster-gpu` image to your local machine (laptop), which we will be using in Part-3.

    ```bash
    $ docker image pull stats285/elasticluster-gpu
    ```

* You should now be able to see the image downloaded to your machine:

    ```
    $ docker images
    REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
    stats285/elasticluster-gpu   latest              39e63c2b22d2        8 minutes ago       551MB
    ```
* for more docker commands, visit [docker tutorial](../../../docker-tutorial/docker-tutorial)  
    
## Part-3: Create your cluster using ElastiCluster
In this part, you will make a container out of the image you pulled in Part 2. This container has in itself `elasticluster`
installed for easy use. Follow the following steps to launch your own cluster.   

* Create a  docker container from `stats285/elasticluster` image   
    ```bash
    docker run -v ~/.ssh:/root/.ssh -P -it stats285/elasticluster-gpu
    ```
* Change the contents of the elasticluster config file `~/.elasticluster/config` to reflect your own credentials and choice of resources. use `vim` or `nano`
(example: `vim ~/.elasticluster/config`)    

    1. retrive your `project_id` as explained [above](#gce-cred)
    1. retrive your `client_id` and `client_secret` as explained [above](#gce-cred)
    1. Update the contents of `~/.elasticluster/config`  
        * `<CLIENT>`
        * `<SECRET>`
        * `<PROJECT>`
        * `<GMAIL_ID>`   
            > Do not icnlude @gmail.com (e.g., email address `stats285@gmail.com` -> use `stats285`)     
    
    ```    
    # Elasticluster Configuration Template
    # ====================================
    # Author: Hatef Monajemi (July 18)
    # Stats285 Stanford 

    # Create a cloud provider (call it "google-cloud")
    [cloud/google]
    provider=google
    noauth_local_webserver=True
    gce_client_id=<CLIENT>
    gce_client_secret=<SECRET>
    gce_project_id=<PROJECT>
    zone=us-west1-b

    [login/google]
    # Do not include @gmail (example: monajemi@gmail.com -> monajemi)
    image_user=<GMAIL_ID>
    image_user_sudo=root
    image_sudo=True
    user_key_name=elasticluster
    user_key_private=~/.ssh/id_rsa
    user_key_public=~/.ssh/id_rsa.pub

    [setup/ansible-slurm]
    provider=ansible
    frontend_groups=slurm_master
    compute_groups=slurm_worker

    [cluster/gce]
    cloud=google
    login=google
    setup=ansible-slurm
    security_group=default
    image_id=ubuntu-1604-xenial-v20171107b
    frontend_nodes=1
    compute_nodes=2
    ssh_to=frontend
    # Ask for 500G of disk
    boot_disk_type=pd-standard
    boot_disk_size=500

    [cluster/gce/frontend]
    flavor=n1-standard-8

    # add 1x GPUs (NVidia Tesla K80) to the compute nodes
    # note that as of Nov. 2017, GPU-enabled VMs are available only in few zones
    # use `gcloud compute accelerator-types list` to see what is available

    [cluster/gce/compute]
    flavor=n1-standard-8
    accelerator_count=1
    accelerator_type=nvidia-tesla-k80
    ```         
    [See source on GitHub](https://github.com/stats285/docker-elasticluster-gpu/blob/master/elasticluster-feature-gpus-on-google-cloud/config-template-gce-gpu)

    > [`gcloud`](https://cloud.google.com/sdk/gcloud/) provides useful commands to see the available options, for example:   
    > `gcloud compute machine-types list --zones us-west1-a`    
    > lists all the machine types that are availbale in zone us-west1-a     
    > This infomation can be found online on [Google](https://cloud.google.com/compute/docs/machine-types)   
    > Also,  `gcloud compute images list` list all the available images.

* Start your cluster (This step takes 10-60 min depending on the number of nodes you request):    

    ```bash
    elasticluster -vvvv start gce
    ```   
	if you run into error, and asked to run the setup again, please do so using,       
    ```bash
    elasticluster -vvvv setup gce
    ```    

* You can also monitor the progress at [Google Cloud Consol](https://console.cloud.google.com/)   
	   
    **if everything goes well, you will see** `your cluster is ready!`. **This is perhaps the moment you should shout** *Yay!* **and congratulate yourself. You now have your own cluster!**
	

* Get the IP address of the `frontend` node using:
    ```
    elasticluster list-nodes gce
    ```    
	example: `35.199.171.137`

* Login to your cluster to test it   
    ```
	ssh <GMAIL_ID>@<FRONTEND_IP>
	```    
	example: `ssh hatefmonajemi@35.199.171.137`
	
* To destroy your cluster:
    ```bash
    elasticluster stop gce
    ```
<span style="color:red"> Note that this command will destroy your cluster and you lose all the data on it. Make sure you get your data to a safe storage place before you destroy your cluster. </span>  


[comment]: # ( You can shut-off your cluster and reinitiate at a later time by logging to your [consol](https://console.cloud.google.com/). Currently ElastiCluster does not have this capability. For more info please visit [stopping-or-deleting-an-instance](https://cloud.google.com/compute/docs/instances/stopping-or-deleting-an-instance) )

## Part-4: Test your cluster with ClusterJob
After you have launched your cluster successfully, it is time to test it by running a small job
using **ClusterJob** on it. Follow the instructions below to test your cluster:

* add your cluster info to `~/CJ_install/ssh_config`. Here is an example:    

	```
	[gce]
	Host	        35.199.171.137
	User		hatefmonajemi
	Bqs		SLURM
	Repo		/home/hatefmonajemi/CJRepo_Remote
	MAT          ""
	MATlib	""
	Python	python3.4
	Pythonlib	pytorch:torchvision:cuda80:scipy:matplotlib:-c soumith
	[gce]
	
	```
	> note that `Host` is the IP address of your frontend node (e.g., `35.199.171.137`)


* go to `~/CJ_install/example/Python` and run `simpleExample` on your cluster:      

	```
    # update cj
    cj update
	# install conda
	cj install miniconda gce
	# test CJ run
	cj run simpleExample.py gce -m "Python on CPU test"
	cj state
	cj ls
	```     
* go to `~/CJ_install/example/Python/pytorch/mnist` and run `mnist.py` on your cluster using GPU:   

    ```
     cj run mnist.py gce -alloc "--gres=gpu:1" -m "Pytorch on GPU test"
     cj state
     # get a summary of all jobs on your cluster
     cj summary gce
    ```
	
If everything makes sense, move on to running your assigned Deep Learning experiments.

[Go back](../../../assignments)
