---
layout: default 
---


# Assignment 01

In this assignment, you will be implementing the ElastiCluster-ClusterJob model of computing. 
Each of you will build **your own personal SLURM cluster** on Google Compute Engine (GCE) using [elasticluster](https://gc3-uzh-ch.github.io/elasticluster/)
and then run massive computational experiments using [clusterjob](http://clusterjob.org). 

Please follow the following steps to setup your cluster and run experiments. This documents only contains the detail of setting up your cluster and testing that it works properly with GPUs. Once these steps are completed, you should conduct your experiments as assigned to you on Canvas. The details of the experiment will **only** be available via Stanford Canvas website to students who are taking this course for credit.    

# Acknowledgements
* We would like to thank [Google Cloud Platform Education Grants](https://cloud.google.com/edu/) Team for their generosity and kindness in providing Stats285 course with cloud computing grant.
* We would like to thank [ElastiCluster](http://elasticluster.readthedocs.io/en/latest/) team especially [Dr. Riccardo Murri](https://www.gc3.uzh.ch/people/rm/) for their help and collaboration on this exercise.



# FAQ 
Please visit the [frequently asked questions](faq) before you submit a question on our [Google group](https://groups.google.com/forum/#!forum/clusterjob).



# ElastiCluster-ClusterJob model

1. [Install ClusterJob](#part-1-setup-clusterjob)
1. [Build Your own Cluster on Google Cloud Using ElastiCluster](#part-2-build-your-own-cluster-on-google-cloud)      
1. [Test your cluster with ClusterJob](#part-3-test-your-cluster-with-clusterjob)    
1. [Run your assigned experiments and upload CJ package to canvas](#part-4-run-your-assigned-experiments-and-upload-cj-package-to-canvas)


## Part-1: Setup ClusterJob
* Follow instructions given in [CJ Book](http://clusterjob.org/documentation/) to install CJ on your laptop and making sure that it works properly. You may test running example scripts on Stanford `rice` or `sherlock` cluster.  

## Part-2: Build Your Own Cluster on Google Cloud using ElastiCluster


* Claim your $300 Google Compute [Credit](https://canvas.stanford.edu/courses/89001/discussion_topics/277314). You will also get $300 free credit from Google Cloud as a first time user by setting up your [Billing Account](https://console.cloud.google.com/billing). However, these 300$ allows only very limited CPU-only computations. 
    > Please make sure to use your GMAIL account to claim the credit.

* Follow the instruction at [Painless Computing Models for Ambitious Data Science](https://monajemi.github.io/datascience/pages/painless-computing-models) to build your own clusters on Google Cloud.



## Part-3: Test your cluster with ClusterJob
After you have launched your cluster successfully, it is time to test it by running a small job
using **ClusterJob** on it. Follow the instructions below to test your cluster:

* add your cluster info to `~/CJ_install/ssh_config`. Here is an example:    

	```
	[gce]
	Host	        35.199.171.137
	User		hatefmonajemi
	Bqs		SLURM
	Repo		/home/hatefmonajemi/CJRepo_Remote
	MAT           ""
	MATlib	""
	Python	python3.4
	Pythonlib	pytorch:torchvision:cuda80:pandas:matplotlib:-c soumith
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
	

## Part-4: Run your assigned experiments and upload CJ package to canvas

If everything makes sense, move on to running your assigned Deep Learning experiments.



[Go back](../../../assignments)
