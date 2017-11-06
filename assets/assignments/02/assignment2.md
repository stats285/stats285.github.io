---
layout: default 
---


# Assignment 02

In this assignment, we will conduct a collaborative project testing certain theoretical hypotheses
in Deep Learning. In particular, each of you will build your own SLURM cluster on Google Compute Engine (GCE)
and then run massive computational experiments. We then collect and analyse all the results you will generate.
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


We will be using `stats285/elasticluster` later in Part-3.


## Part-2: Google Cloud

* Claim your $50 Google Compute [Credit](https://canvas.stanford.edu/courses/73102/discussion_topics/160558)
* Create a Google Project by Visiting [Manage resources](https://console.cloud.google.com/cloud-resource-manager?_ga=2.13784503.-1419916998.1496658742) (This may take some time, be patient)

* Creat your credentials `client_id`, `client_secret`, and `project_id`
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




[Go back to home](./)
