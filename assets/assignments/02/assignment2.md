---
layout: default 
---


# Assignment 02

In this assignment, we will conduct a collaborative project testing certain theoretical hypotheses
in Deep Learning. In particular, each of you will build your own SLURM cluster on Google Compute Engine (GCE)
and then run massive computational experiments. We then collect and analyse all the results you will generate and document
our observations.
Please follow the following step to setup your cluster and run experiments. This documents only contains the detail of setting up your cluster and testing that it works. Once this step is completed, you should conduct your experiments as assigned to you on Canvas. The details of the experiment will **only** be available via Stanford Canvas website to students who are taking this course as credit. 

## Part-1: Install Docker
* Visit [Docker Website](https://www.docker.com/community-edition#/download) and install it for your operating system
* Once docker installation is complete, Check your installation by searching docker repositories for `elasticluster`:    
    ```bash
    $ docker search elasticluster

    artifacts/elasticluster                Elasticluster with custom tools to fully m...   1                                       
    artifacts/elasticluster-config-tools                                                   0                                       
    stats285/elasticluster                 Dockerized elasticluster for Stanford cour...   0
    ```
    The image can also be found at [Docker Hub](https://hub.docker.com/r/stats285/elasticluster/)

* We will be using `stats285/elasticluster` image to build a container later in Part-3. So, go ahead and pull this image to your local machine (laptop).

    ```bash
    $ docker image pull stats285/elasticluster

    Using default tag: latest
    latest: Pulling from stats285/elasticluster
    d13d02fa248d: Pull complete 
    a2c103c31b60: Pull complete 
    33bfff8f2f5e: Pull complete 
    5b66f3cbc9f3: Pull complete 
    97f64282b4c0: Pull complete 
    5ca087b288c4: Pull complete 
    48ef25846431: Pull complete 
    62e22c801e94: Pull complete 
    d427e5f4c11a: Pull complete 
    Digest: sha256:552e1dd64f0c65a2430de6a517dc546f539c3fcddd48aea7d401fb3a6b810330
    Status: Downloaded newer image for stats285/elasticluster:latest
    ```

* You should now be able to see the image downloaded to your machine:

    ```
    $ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    stats285/elasticluster   latest              6e06d575a49e        15 minutes ago      555MB
    ```


## Part-2: Google Cloud

* Claim your $50 Google Compute [Credit](https://canvas.stanford.edu/courses/73102/discussion_topics/160558). You also get $300 free credit from Google Cloud as a first time user by setting up your [Billing Account](https://console.cloud.google.com/billing).
* <a id="proj-id"></a> Create a Google Project by Visiting [Manage resources](https://console.cloud.google.com/cloud-resource-manager?_ga=2.13784503.-1419916998.1496658742) (This may take some time, be patient). You may find your project ID here which will be needed later.

* <a id="gce-cred"></a>Visit [Google Credential page](https://console.cloud.google.com/project/_/apiui/credential), and creat your credentials `client_id`, `client_secret`
   1. select **Create credentials**
   2. select **OAuth client ID**
   3. selct  **Configure conset screen**    
        * Choose your **project name** and **save**
   4. If prompted for **Application Type** choose **Other**    
        * choose a name for your application (say `elasticluster`)
   5. select **Create** 

> Once successful, the interface will show your `client_id`  and `client_secret`.
> These values appear at the Credentials tab and you may retrive them at a later time by clicking on your application name (step 4).

For more info on obtaining your Google credentials, you may visit [googlegenomics](http://googlegenomics.readthedocs.io/en/latest/use_cases/setup_gridengine_cluster_on_compute_engine/)


## Part-3: Run ElastiCluster

* Create a  docker container from `stats285/elasticluster` image   
    ```bash
    docker run -v ~/.ssh:/root/.ssh -P -it stats285/elasticluster
    ```
* Change the contents of the elasticluster config file `~/.elasticluster/config` to reflect your own credentials and choice of resources.
    1. retrive your `project_id` as explained [above](#gce-cred)
    1. retrive your `client_id` and `client_secret` as explained [above](#gce-cred)
    1. Update the contents of `~/.elasticluster/config`    
   
    ```bash
    # Elasticluster Configuration Template
    # ====================================
    # Author: Hatef Monajemi (July 18)
    #

    [cloud/google]
    provider=google
    noauth_local_webserver=True
    gce_client_id=<CLIENT>
    gce_client_secret=<SECRET>
    gce_project_id=<PROJECT>
    zone=us-west1-a


    [login/google]
    image_user=<GMAIL_ID>   # DO NOT include @gmail.com 
    image_user_sudo=root
    image_sudo=True
    user_key_name=elasticluster
    user_key_private=~/.ssh/id_rsa
    user_key_public=~/.ssh/id_rsa.pub

    [setup/ansible-slurm]
    provider=ansible
    frontend_groups=slurm_master
    compute_groups=slurm_worker


    [cluster/gce-slurm]
    cloud=google
    login=google
    setup=ansible-slurm
    security_group=default
    image_id=debian-8-jessie-v20170717
    flavor=n1-standard-1     # use n1-standard-4 for nodes with 4vCPUs
    frontend_nodes=1
    compute_nodes=2
    image_userdata=
    ssh_to=frontend

    # Uncomment below to get more permanent disk. Default is 10G

    #[cluster/gce-slurm/compute]
    #boot_disk_type=pd-standard
    #boot_disk_size=100                     # 100G
    ```

> `gcloud` provides useful commands to see the available options, for example:   
> `gcloud compute machine-types list --zones us-west1-a`    
> lists all the machine types that are availbale in zone us-west1-a     
> This infomation can be found online on [Google](https://cloud.google.com/compute/docs/machine-types)   
> Also,  
> `gcloud compute images list`  
> list all the available images.    




[Go back](https://stats285.github.io/assignments)
