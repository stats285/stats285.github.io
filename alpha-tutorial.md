# Using the Alpha Pattern, Machine Learning, and Clusterjob Tutorial
Current research projects use the Alpha pattern described by Vardan Papyan in Lecture 03, [Prevalence of neural collapse during the terminal phase of deep learning training](https://www.pnas.org/content/117/40/24652). We will use a simplified version of that pattern in this tutorial. 
### Overview:
We are going to do the following:
- Download a sample project.
- Update the definition of an Elasticluster cluster to run it.
- Update the ClusterJob definition to run it.
- Run the job.
It will be helpful to review [Google's documentation on using a VM with a GPU.](https://cloud.google.com/compute/docs/gpus/create-vm-with-gpus)
### Download:
Start by cloning the [Alpha Github project](https://github.com/stats285/Alpha) to your local machine. If you are still using the virtual machine we created in the first tutorial, here is the command:
```
git clone https://github.com/stats285/Alpha
```
We recommend that you confirm for yourself that the project runs properly by reducing the epoch count to 2 from 20, on line 61 in `train.py`. This will force you to deal with the oddities of research software. For example, PyTorch, a major ML tool, seems to have trouble on Mac when you are using a modern Python, >v3.7. We recommend that you use version 3.8 or 3.9 on the cluster. (It is very alluring to a researcher to indulge in version lag. All that means is that no one will be willing to help you on downlevel problems. If you want help from the community, you must keep up to version parity.) By running with the small epoch count, you will also become exposed to the challenge of dynamically downloading data. Sometimes it works, sometimes it doesn't. (`MNIST` and `SVHN` seem to be giving us problems as this is being written.) Hence, you will learn that you need to make local to your cluster copies of data to have reliable computation.

### Elasticluster for CPU and ML:
First, our friends at Google restrict access to GPUs to free accounts. You have to [request a quota expansion.](https://cloud.google.com/compute/quotas) You also should read a bit about [how GPUs work at GCE](https://cloud.google.com/compute/docs/gpus) and [how to create VMs with attached GPUs.](https://cloud.google.com/compute/docs/gpus/create-vm-with-gpus) Because this is more complex, we want to start with a simple problem and then move up the complexity ladder. Hence, we'll start by running Alpha on just the CPU and then we'll modify the configurations to run on the GPU. Because these are image manipulation tasks, we need a large amount of memory. We will use the GPU capable `n1-highmem-4` machine with 4 cores and 6.5GB/core. We will be able to attach a GPU later.
```
[cluster/gce-gpu]
cloud=google
login=google
setup=ansible-slurm
security_group=default
image_id=ubuntu-1804-bionic-v20210315a
flavor=n1-standard-2
frontend_nodes=1
compute_nodes=2
ssh_to=frontend
boot_disk_type=pd-standard
boot_disk_size=100

[cluster/gce-gpu/compute]
flavor=n1-highmem-4
boot_disk_size=50
```
After creating the cluster, do no forget to capture the current SSH keys with `gcloud compute config-ssh` command.

### ClusterJob for CPU and ML:
Because we are going to use a GPU, CJ will need to find the new configuration and also update the software stack to use PyTorch and the GPU. Add the following to your `~/CJ_install/ssh_config` file. Please remember to replace the below strings, `<REPLACE_WITH_YOUR_GCE_PROJECT_ID>` and `<REPLACE_WITH_YOUR_USERNAME>` with the appropriate data from your other configurations. Because some systems, such as Stanford's Sherlock, have size limits per node, we have also adjusted the amount of software installed to just the amount necessary to run the experiment, Pandas, PyTorch, and TorchVision. If, as is likely, you change zones to find the right cost GPU, it is important to set the host name properly. For example, `us-central1-a` became, in practice, `us-central1-c`.
```
[gce-gpu]
host	gce-gpu-frontend001.us-central1-a.<REPLACE_WITH_YOUR_GCE_PROJECT_ID>
user	<REPLACE_WITH_YOUR_USERNAME>
Bqs	SLURM
Repo	/home/<REPLACE_WITH_YOUR_USERNAME>/CJRepo_Remote
MAT     	matlab/R2019a
MATlib		~/cvx:~/mosek/9.2/toolbox/r2015a:~/yalmip:/share/software/modules/math/gurobi
Python		python/3.8.8
Pythonlib	pandas:requests:pytorch:torchvision:matplotlib
R	        R
Rlib	    ggplot2  
Alloc		--time UNLIMITED
[gce-gpu]
```
Firing up the cluster uses this command:
```
cj parrun train.py gce-gpu -dep . -m "Training"
```
When the task is done, we'll reduce the data and then get it:
```
cj state
cj reduce
cj get
```
