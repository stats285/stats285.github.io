# ElastiCluster and Clusterjob Tutorial
Painless computing requires one to find tools to help with the job at hand. This class starts with two older but stable tools used in statistics research today -- [Elasticluster](https://elasticluster.readthedocs.io/en/latest/) and [ClusterJob](https://clusterjob.org). The other pattern we will observe is that painless computing depends upon running many virtual operating system images. In this class we will mostly use the 2018 LTS version of Ubuntu Linux. (LTS means it has Long Term Support. In other words, there should be few to no surprises for the unwary scientist. This is a Good Thing™.) Ubuntu Linux is one of several options that are widely deployed on most clouds. We do not believe that there is much to be gained from exposing you to pointless variation in OS choice. Hence, we will always launch our jobs from a virtual image on your laptop/desktop computer. This allows you to experiment without potentially misconfiguring your host machine. Stanford recommends that you use [VirtualBox from Oracle Systems](https://www.virtualbox.org). Because "… a foolish consistency is the hobgoblin of little minds …" applies with a fearsome regularity to computer systems, we recommend that you use the server version of the [Ubuntu OS](https://releases.ubuntu.com/18.04/). It allows you to become familiar with the computing environment upon which your experiments will run. 
## The "Big Picture"
Your experiment will run on a cluster of computers defined by you, either on the Stanford Sherlock Cluster or on the Google Compute Engine. Our initial experiment is based upon a simple research problem created by Mahsa Lofti to calculate a phase transition. It will use four standard sized machines to do the experimental calculation and a frontend/coordination system. In future work, we can start to require access to high performance GPUs or other hardware. As you add specialized hardware, the cost and competition for access increases.

One piece of advice, you should read through this tutorial once before trying the commands yourself. Like any construction process, knowing where you're going and how you're going to get there really helps you along the way. 

This tutorial is broken up into several phases:
- Install Ubuntu on VirtualBox
- Install Google Compute Engine and Sherlock credentials.
- Install Elasticluster
- Create a small memory cluster and establish communication to each node.
- Destroy the cluster.
- Install ClusterJob.
- Create a high memory cluster and use Clusterjob to start the phase transition code.
	- Wait approximately 3 hours for the job to complete
	- Use CJ status commands to see the state of the calculation.
	- SSH into the compute nodes to see how much CPU is being used.
- Gather all of the computed results and share them with your instructors.

### Install Ubuntu on VirtualBox
- Download both VirtualBox and Ubuntu 18.04 LTS.
- Install VirtualBox in the standard way.
- Create a new Virtual Machine.
	- As the image on your host doesn't actually do much work, it doesn't need many resources. For example, if your laptop has 16 GB of RAM, your Ubuntu probably doesn't need more than one quarter of that, say 4 GB. It's disk image doesn't need to be much larger than 4 GB either, stay on the safe side with 8 GB.
	- It helps to set the networking style to bridged. This allows you to easily ssh into the running Ubuntu OS.
	- The Ubuntu installer is straightforward enough, but it is still Linux. Don't freak out if you don't know the answer to a question. Typically, the default choice is good enough. The Google search engine remains your "friend." Your classmates can also help. 
	- You should choose the same username that you use on your host system. You will also use this username in the cluster. It makes your life a bit easier when remotely logging in.
	- You will be asked about extra libraries to install. You want to select both the Google Cloud Tools and the Docker tools.
	- It takes a modest amount of time for the image to finish initializing multiple parameters, such as random keys. Patience is a virtue.

Login to your new Ubuntu system and execute the following:
```
sudo apt update
sudo apt upgrade -y
```
Your system is now ready for the cluster management tools.
### Install Google Compute Engine credentials.
Any unique email address can get a [$300 credit toward Google Compute Engine time](https://cloud.google.com/free). Google provides a good overview of their system for technical computing [here](https://cloud.google.com/solutions/using-clusters-for-large-scale-technical-computing). This part of the tutorial has been cribbed from the Google authored tutorial to run "[R at Scale](https://cloud.google.com/solutions/running-r-at-scale)". Basically, you are going to create an project and credentials using the Google Compute Engine dashboard. Those credentials will be used by Elasticluster to instantiate the cluster. Because the Stanford cluster, Sherlock, uses SLURM to configure the nodes, we will use SLURM on GCE too. We are going to follow the modernized instructions from the "[R at Scale](https://cloud.google.com/solutions/running-r-at-scale)" page.
- Sign up for a [free Google Cloud account](https://cloud.google.com/free).
- Start at [GCP Dashboard](https://console.cloud.google.com/)
- Create a project from "IAM & Admin" menu choose "Create a Project".
	- This project name is typically a combination of two random words and a number, e.g. "`superb-garden-303018`".
- Make sure that billing is [configured for your account](https://cloud.google.com/billing/docs/how-to/modify-project).
- Enable Compute Engine API in "[APIs & Services](https://console.cloud.google.com/apis)"
- Enable Project Credentials in the [Credentials menu](https://console.cloud.google.com/apis/credentials) on the "[APIs & Services](https://console.cloud.google.com/apis)" dashboard.
	- Select your Google Cloud project.
	- Click Create credentials.
		- Click "OAuth client ID".
		- In the "Create client ID" page, for Application type, select "`Desktop`".
		- Copy the "Client ID" and "Client Secret". These will be required later for Elasticluster to create the cluster. As these credentials control access to your account, treat them with care; your budget may be at risk. (You can get them again if you lose them. Do not share them with classmates.)
			- Sample Client ID: "`308342824695-eimtr7e8bqo7lotqlumj5mfmta1co8o4.apps.googleusercontent.com`"
			- Sample Client Secret: "`_IdXWkmrunCuSLmPhL0ouaeV`"

Now that Google is ready, you need to create some SSH keys for secure communication with their servers. Execute the following on your Ubuntu OS:
```
gcloud init
gcloud compute config-ssh
```
### Install Elasticluster
We are going to upgrade the compiler on this OS and install Python 3 developer tools. Then we will create a special configuration of Python to run Elasticluster. Finally, we will install Elasticluster.
```
# Get tools.
sudo apt install gcc g++ git libc6-dev libffi-dev libssl-dev
sudo apt install python3-dev virtualenv

# Create elasticluster virtual environment.
virtualenv --python=python3 elasticluster
. elasticluster/bin/activate
pip3 install --upgrade 'pip>=9.0.0'
cd elasticluster/

# Install elasticluster.
git clone https://github.com/gc3-uzh-ch/elasticluster.git src
cd src
pip install -e .
```
Elasticluster needs a configuration file. We define a standard 3 node cluster, "`gce`" and a High Memory 3 node cluster, "`gce-high-mem`". They will be instantiated in the "`us-central1-a`" zone. You could choose a different zone from [this list](https://cloud.google.com/compute/docs/regions-zones). Copy the below to "`~/.elasticluster/config`".
```
[cloud/google]
provider=google
gce_client_id=<REPLACE_WITH_YOUR_GCE_CLIENT_ID>
gce_client_secret=<REPLACE_WITH_YOUR_GCE_CLIENT_SECRET>
gce_project_id=<REPLACE_WITH_YOUR_GCE_PROJECT_ID>
noauth_local_webserver=True
zone=us-central1-a

[login/google]
image_user=<REPLACE_WITH_YOUR_USERNAME>
image_user_sudo=root
image_sudo=True
user_key_name=elasticluster
user_key_private=~/.ssh/google_compute_engine
user_key_public=~/.ssh/google_compute_engine.pub

[setup/ansible]
ansible_forks=20
ansible_timeout=200

[setup/ansible-slurm]
provider=ansible
frontend_groups=slurm_master
compute_groups=slurm_worker

# allow restart of compute nodes
compute_var_allow_reboot=yes
global_var_slurm_taskplugin=task/cgroup
global_var_slurm_proctracktype=proctrack/cgroup
global_var_slurm_jobacctgathertype=jobacct_gather/cgroup

[cluster/gce]
cloud=google
login=google
setup=ansible-slurm
security_group=default
image_id=ubuntu-1804-bionic-v20210315a
flavor=n1-standard-4
frontend_nodes=1
compute_nodes=4
ssh_to=frontend
boot_disk_type=pd-ssd
boot_disk_size=50

[cluster/gce/frontend]
boot_disk_size=100

##########

[cluster/gce-high-mem]
cloud=google
login=google
setup=ansible-slurm
security_group=default
image_id=ubuntu-1804-bionic-v20210315a
flavor=n1-standard-4
frontend_nodes=1
compute_nodes=2
ssh_to=frontend
boot_disk_type=pd-standard
boot_disk_size=100

[cluster/gce-high-mem/compute]
flavor=n2-highmem-4
boot_disk_size=50
```
Four items above need to be replaced with the custom configuration. Search for "`<REPLACE_WITH_YOUR_`" and replace with the appropriate information, angle brackets included.
### Create a small memory cluster and establish communication to each node.
One creates a cluster, unsurprisingly, with a "`start`" command:
```
elasticluster start gce
```
The `start` command provisions the nodes using Compute Engine and will take between 20-30 minutes. It configures the nodes by using the Ansible playbooks included in the Elasticluster source. Setup can take some time, depending on configuration. You will know when configuration is done when the output stops and you see the ending banner containing: "`Your cluster is ready!`" It is required practice that you update your `gcloud` keys after bringing up a new cluster using:
```
gcloud compute config-ssh
```
You can then login to the frontend node using:
```
elasticluster ssh gce
```
Or any of the nodes using:
```
ssh gce-frontend001.us-central1-a.superb-garden-303018
ssh gce-compute001.us-central1-a.superb-garden-303018
ssh gce-compute002.us-central1-a.superb-garden-303018
ssh gce-compute003.us-central1-a.superb-garden-303018
ssh gce-compute004.us-central1-a.superb-garden-303018
```
These node names are important and they are created from information in your config file. Each node name contains your cluster, role, and number, e.g. "`gce-frontend001`" or "`gce-high-mem-compute002`". Followed by a zone/region designator, e.g. "`us-central1-a`". Finally, your project ID, "`superb-garden-303018`" is concatenated to make a fully qualified node name. The node name of the frontend will be needed for ClusterJob.
### Destroy the cluster.
One destroys a cluster, equally unsurprisingly, with a "`stop`" command:
```
elasticluster stop gce
```
### Install ClusterJob.
Now that we have a compute cluster, it is time to perform a calculation using it. We use a research tool created here at Stanford called [ClusterJob](https://clusterjob.org). Like almost every research tool you will ever use, it is cranky but effective. It was written by experts to perform their specific task. It has plenty of sharp edges but also provides significant amount of computational "leverage". We use it in this class because we believe that the key to painless scientific computing is through a disciplined and automated experimental process. Each group you join will have its own way of managing its research processes; ClusterJob is one such experimental/research management system. This tutorial will install the comparatively ancient perl programming environment, some specialized libraries, and ClusterJob itself. Modern data science experiment management systems would likely use Python. Later in the class, we will show you some alternatives to CLusterJob. For the nonce though, we will use ClusterJob. Current research papers are being published from ClusterJob managed calculations. You can use it too.

Like all research software, ClusterJob has [basic documentation](https://clusterjob.org/documentation/). This is augmented by a draft chapter of a [Data Science book by Hatef Monajemi](https://monajemi.github.io/datascience/pages/elasticluster-clusterjob-model). This tutorial is a distillation of these other works in the very pragmatic context of running a simple example for this class. Most users borrow an existing set of configuration files and call it a day. We've provided a basic set of configuration files below. As we expand a cluster's hardware to include GPUs, the configuration files will evolve. Those extensions will be discussed in class.

Lets get started installing ClusterJob.

```
# Install perl package management prerequisites.
sudo apt install build-essential
sudo cpan install CPAN

# Install ClusterJob prerequisites.
sudo cpan -i DateTime Time::Local Time::Piece
sudo cpan -i JSON JSON::XS JSON::PP
sudo cpan -i Data::Dumper Data::UUID
sudo cpan -i FindBin File::chdir File::Basename File::Spec
sudo cpan -i Net::SSLeay IO::Socket::INET IO::Socket::SSL
sudo cpan -i Getopt::Declare Term::ReadLine Digest::SHA
sudo cpan -i Moo HTTP::Thin HTTP::Request::Common URI

# Install ClusterJob
git clone https://github.com/adonoho/clusterjob.git ~/CJ_install
alias cj='perl ~/CJ_install/src/CJ.pl';
```
We are not yet done. We need to create two configuration files. For the first, we need to get a tracking token from the ClusterJob servers. All this token is used for is to allow the ClusterJob creators to brag about how many jobs have been run using ClusterJob. Your tutorial author does not believe any other data is collected but those of you interested in privacy issues should ask questions during class. One registers for a [ClusterJob account here](https://clusterjob.org/register.php). And you will edit your information into the file "`~/CJ_install/cj_config`". Here's a sample:
```
CJID	moosh
CJKEY	eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhZG1pbiI6MCwiZCI6eyJ1aWQiOiJtb29zaCIsImNqcGFzc2NvZGUiOiIwN2Q3MDMwNmE3ODA1YzUyOWIxZTljYjE0ZTZmNWZhYSJ9fQ.vY1HodLgrW1V_yNWiLzB1O8eDWsWxA6NVJllWuXGFFoFfAbM9PQkYcYJbn9JtQenwlkJMpMwucPGy68sSQqdZCBXwNnsERY1e7X067uTtg_7NY_qlcFI0WDtNxib81DF3w02Ate0_m-xZVu2JUztrjWAMaIBAXHkG2Ja284RkZmj4QymXtb2cMSexP79WFsqSfiglp0HUaHyAJZwRYJUy3LittaS5jqSyEFcMy4mirTGpcueNuO8WJzqBlk-f3lzAt5VE8jBeQHGFX49lR5binYotS4TqJccqJfHAE_BDnwRp1kUrqKT_brS4FN8Zk2Osz3tLhUR0HlCKQt7gPu25A
SYNC_TYPE	manual	
SYNC_INTERVAL	300
```
Replace the "`CJID`" "`moosh`" with your ID. And replace the "`CJKEY`" string beginning with "`eyJ0`" with your key.

The second config file, "`~/CJ_install/ssh_config`" connects ClusterJob to the Elasticluster you built above. It is important to copy the details exactly between the two computational systems. You now know the drill, replace the strings beginning with "`<REPLACE_WITH_YOUR_`" with the appropriate string from your ElastiCluster configuration.
```
[gce]
host	gce-frontend001.us-central1-a.<REPLACE_WITH_YOUR_GCE_PROJECT_ID>
user	<REPLACE_WITH_YOUR_USERNAME>
Bqs	SLURM
Repo	/home/<REPLACE_WITH_YOUR_USERNAME>/CJRepo_Remote
MAT     	matlab/R2019a
MATlib		~/cvx:~/mosek/9.2/toolbox/r2015a:~/yalmip:/share/software/modules/math/gurobi
Python		python/3.8.8
Pythonlib	IPython:pandas:numpy:libgcc:scipy:matplotlib:cvxpy:-c conda-forge
Alloc		--time UNLIMITED
[gce]

[gce-high-mem]
host	gce-high-mem-frontend001.us-central1-a.<REPLACE_WITH_YOUR_GCE_PROJECT_ID>
user	<REPLACE_WITH_YOUR_USERNAME>
Bqs	SLURM
Repo	/home/<REPLACE_WITH_YOUR_USERNAME>/CJRepo_Remote
MAT     	matlab/R2019a
MATlib		~/cvx:~/mosek/9.2/toolbox/r2015a:~/yalmip:/share/software/modules/math/gurobi
Python		python/3.8.8
Pythonlib	IPython:pandas:numpy:libgcc:scipy:matplotlib:cvxpy:-c conda-forge
Alloc		--time UNLIMITED
[gce-high-mem]
```
Now we need to start basic testing by running simple things. Try the following:
```
cj init
cj who
cj update
```
The output should have been obviously correct or you have a problem. Research software can be cranky; we're here to help.

Now let us start a high memory cluster and run some trivial Python on it. Then we will move on to the phase transition code.
```
elasticluster start gce
# After the cluster is ready.
gcloud compute config-ssh

# Run simpleExample.py
cd ~/CJ_install/example/Python/
# When you run the next line, CJ will ask you to install miniconda, say yes.
cj run simpleExample.py gce -m "Python."
cj state
```
### Use Clusterjob to Start the Phase Transition Code.
Whew, that doesn't seem so painless now does it? Yes, it frequently seems that you have to invest too much time in arbitrary tools when you are looking at simple problems. Yet, we want to run 1 million CPU hours before you graduate. If you do the arithmetic, you need to get over a hundred CPUs running your jobs for over a year, 1**6/8,760 hours => 114 CPUs running every hour of every day. We just spun up two CPUs. Coordinating those CPUs/tasks is a huge amount of bookkeeping. Also, your dissertation committee wants you to extract science too? 

Now we are going to calculate a phase transition code. Mahsa Lotfi will describe the details of the code and what it is calculating in class. This tutorial will show you how to run it. First, get the code:
```
cd ~
git clone https://github.com/stats285/ExamplePhaseTransition ~/ExamplePhaseTransition
cd ~/ExamplePhaseTransition/
```
Now we are going to execute this task in parallel on the gce cluster and include the dependent code.
```
cj parrun main_func.py gce -dep Dependents -m "Phase Transition"
```
Now that it is running, you can check the state of the code utilizing:
```
cj state
```
When the job has completed, after about 3 hours, you will then need to get your results from the cluster by first `reducing` them and then `getting` them onto your local Ubuntu image. Because you may have many different jobs running, you will need to tell CJ which job to reduce and get. the `cj state` command also tells you the `PID`, process identifier, to allow you to reduce the right data. In the below example, `ff1cf89ab2f4c51800a900704dda041f637ca620` is a sample `PID`; yours will be different.
```
cj reduce final_results.txt ff1cf89ab2f4c51800a900704dda041f637ca620
cj get ff1cf89ab2f4c51800a900704dda041f637ca620
```
Now you get the scientific joy of determining what you just calculated and what it all means. Mazeltov. Dr. Lotfi will reveal all. Please copy your shell results to Stanford's Canvas system to get credit for performing this tutorial.
