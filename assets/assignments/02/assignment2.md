---
layout: default 
---


# Assignment 02

In this assignment, we will conduct a collaborative project testing certain theoretical hypotheses
in Deep Learning. In particular, each of you will build your own SLURM cluster on Google Compute Engine (GCE)
and then run massive computational experiments. We then collect and analyse all the results you will generate.
Please follow the following step to setup your cluster and run experiments. This documents only contains the detail of setting up your cluster and testing that it works. Once this step is completed, you should conduct your experiments as assigned to you on Canvas. The details of the experiment will **only** be available via Stanford Canvas website. 

## Part-1: Google Cloud

* Claim your $50 Google Compute Credit
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

## Part-2: Install Docker



[Go back to home](./)
