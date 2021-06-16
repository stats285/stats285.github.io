# ElastiCluster and Clusterjob Tutorial
Painless computing requires one to find tools to help with the job at hand. This class starts with two older but stable tools used in statistics research today -- [Elasticluster](https://elasticluster.readthedocs.io/en/latest/) and [ClusterJob](https://clusterjob.org). The other pattern we will observe is that painless computing depends upon running many virtual operating system images. In this class we will mostly use the 2018 LTS version of Ubuntu Linux. (LTS means it has Long Term Support. In other words, there should be few to no surprises for the unwary scientist. This is a Good Thing™.) Ubuntu Linux is one of several options that are widely deployed on most clouds. We do not believe that there is much to be gained from exposing you to pointless variation in OS choice. Hence, we will always launch our jobs from a virtual image on your laptop/desktop computer. This allows you to experiment without potentially misconfiguring your host machine. Stanford recommends that you use [VirtualBox from Oracle Systems](https://www.virtualbox.org). Because "… a foolish consistency is the hobgoblin of little minds …" applies with a fearsome regularity to computer systems, we recommend that you use the server version of the [Ubuntu OS](https://releases.ubuntu.com/18.04/). It allows you to become familiar with the computing environment upon which your experiments will run.

## The "Big Picture"
Your experiment will run on a cluster of computers defined by you, either on the Stanford Sherlock Cluster or on the Google Compute Engine. Our initial experiment is based upon a simple research problem created by Mahsa Lofti to calculate a phase transition. It will use four standard sized machines to do the experimental calculation and a frontend/coordination system. In future work, we can start to require access to high performance GPUs or other hardware. As you add specialized hardware, the cost and competition for access increases.

One piece of advice, you should read through this tutorial once before trying the commands yourself. Like any construction process, knowing where you're going and how you're going to get there really helps you along the way.

This tutorial is broken up into several steps:
- Step 0: Sign up for Google Cloud and ClusterJob
- Step 1: Install VirtualBox and create a blank VM
- Step 2: Install Ubuntu 18.04 LTS on the VM
- Step 3: Enable SSH on your Ubuntu VM
- Step 4: Install elasticluster and clusterjob
- Step 5: Test elasticluster
- Step 6: Test clusterjob
- Step 7: Create a high memory cluster and use Clusterjob to start the phase transition code.
	- Wait approximately 3 hours for the job to complete
	- Use CJ status commands to see the state of the calculation.
	- SSH into the compute nodes to see how much CPU is being used.
- Step 8: Gather all of the computed results and share them with your instructors.

# Step 0: Sign up for Google Cloud and ClusterJob

## Step 0.a: Set up Google Cloud credentials.
Any unique email address can get a [$300 credit toward Google Compute Engine time](https://cloud.google.com/free). Google provides a good overview of their system for technical computing [here](https://cloud.google.com/solutions/using-clusters-for-large-scale-technical-computing). This part of the tutorial has been cribbed from the Google authored tutorial to run "[R at Scale](https://cloud.google.com/solutions/running-r-at-scale)". Basically, you are going to create an project and credentials using the Google Compute Engine dashboard. Those credentials will be used by Elasticluster to instantiate the cluster. Because the Stanford cluster, Sherlock, uses SLURM to configure the nodes, we will use SLURM on GCE too. We are going to follow the modernized instructions from the "[R at Scale](https://cloud.google.com/solutions/running-r-at-scale)" page.
- Sign up for a [free Google Cloud account](https://cloud.google.com/free).
- Start at [GCP Dashboard](https://console.cloud.google.com/)
- Select the 3 bars in the top left >> IAM & Admin >> Create a Project. Choose a project name and take note of it.
- Make sure that billing is [configured for your account](https://cloud.google.com/billing/docs/how-to/modify-project).
- In the search bar at the top, search for "Compute Engine API" and enable it. Similarly, enable "Cloud Storage for Firebase API"
- Navigate to the [APIs & Services](https://console.cloud.google.com/apis) dashboard and click "Credentials".
	- Ensure your Google Cloud project is selected at the top.
	- Click Create credentials.
		- Click "OAuth client ID".
		- If you need to configure the OAuth Consent Screen, choose "External", any App Name, and your email for "User Support Email" and Developer Contact Information.
		- In the "Create client ID" page, for Application type, select "`Desktop app`".
		- Take note of the "Client ID" and "Client Secret". These will be required later for Elasticluster to create the cluster. As these credentials control access to your account, treat them with care; your budget may be at risk. (You can get them again if you lose them. Do not share them with classmates.)
			- Example Client ID: "`308342824695-eimtr7e8bqo7lotqlumj5mfmta1co8o4.apps.googleusercontent.com`"
			- Example Client Secret: "`_IdXWkmrunCuSLmPhL0ouaeV`"
		- Choose a preferred server zone for Google Cloud from [this list](https://cloud.google.com/compute/docs/regions-zones).

At the end of this process, you should have taken note of five different variables: your Google Cloud username (typically your email address), your project's ID number, client ID, client secret, and preferred server zone.

## Step 0.b: Set up ClusterJob credentials

Sign up for a <a href="https://clusterjob.org/register.php">ClusterJob account here</a> using a .edu email address. Once you've verified your account and logged in, view your ClusterJob key. At the end of this process, you should have taken note of two more variables: your ClusterJob ID and key.

# Step 1: Install VirtualBox and create a blank VM

- Download and install VirtualBox >=6.1.22 from https://www.virtualbox.org/wiki/Downloads

First, we create a blank VM with no OS installed:
- Open VirtualBox >> Tools >> New
- Choose a name and folder for the VM, set Type: Linux and Version: Oracle (64-bit)
- Set Memory Size to 8192 MB
- Choose "Create a virtual hard disk now"
- Choose VDI (VirtualBox Disk Image)
- Choose Dynamically allocated
- Choose the file location and size (12 GB is sufficient)

# Step 2: Install Ubuntu 18.04 LTS on the VM

Now, we install Ubuntu on the blank VM:
- Download the Ubuntu 18.04.5 LTS (Bionic Beaver) Server install image from https://releases.ubuntu.com/18.04/
- Right click the new VM in VirtualBox and click "Settings"
- Click on "Storage", and next to "Controller: IDE" click on "Adds optical drive." (the blue circle with the green plus on it)
- Click "Add" again and choose the Ubuntu .iso downloaded above
- Press "OK" and Start the VM

The VM should begin booting up from the Ubuntu installation image and prompt you for installation choices. If you need to navigate away from the VM, press one of your modifier keys (command on Mac) to release the mouse from the VM.

When installing Ubuntu:
- Choose your language of choice
- Choose your keyboard configuration
- Choose the default network connections
- Leave proxy blank
- Choose default Ubuntu mirror
- Choose "Use an entire disk" and "Set up this disk as an LVM group". It is not necessary to encrypt the LVM group with LUKS.
- Choose the default storage configuration
- Press continue
- Set up your personal name, your server's name (machine name), your username on that machine, and the password for your username
- Check "Install OpenSSH server", do not import SSH identity

Afterwards, the Ubuntu installation should complete in 5-10 minutes. Then choose "Reboot" and press enter.

# Step 2.A: Miscellaneous Bugs on Ubuntu

- If you're running into issues with random characters (like newlines) being inserted in your shell session, start the VM and run the command `setterm -repeat off`
- If you're having trouble running `apt`, run the following command in your VM to set your nameserver in `/etc/resolv.conf`(some ISP's forwarding rules don't support DNS on your VM): `echo "sudo sed -i 's/nameserver.*/nameserver 8.8.8.8/g' /etc/resolv.conf" >> ~/.bashrc && source ~/.bashrc`

# Step 3: Enable SSH on your Ubuntu VM

Ubuntu Virtualboxes have known issues with clipboard sharing between host and guest. This makes it extremely difficult to do any development on the VM. As such, we need to enable SSH on our VM and we'll use that for development:

- Shut down the Ubuntu VM if it's running
- In VirtualBox, go to your VM's Settings >> Network >> Adapter 1 >> Advanced >> Port Forwarding
- Add a new port-forwarding rule with Name: SSH, Protocol: TCP, Host IP: 127.0.0.1, Host Port: 2222, Guest IP: blank, Guest Port: 22.

After starting the Ubuntu VM again, you should be able to ssh into it directly from your HOST machine (laptop) via `ssh YOUR_UBUNTU_USERNAME@127.0.0.1 -p 2222`

# Step 4: Install elasticluster and clusterjob

SSH into your your running VM from a terminal on your HOST (laptop), then run the following commands, replacing the necesesary Google and Clusterjob variables that were determined when you signed up for them:

```
echo "export GCE_USERNAME=<YOUR_GOOGLE_USERNAME_OR_EMAIL>" >> ~/.bashrc
echo "export GCE_ZONE=<YOUR_PREFERRED_GOOGLE_ZONE>" >> ~/.bashrc
echo "export GCE_PROJECT_ID=<YOUR_GOOGLE_PROJECT_ID>" >> ~/.bashrc
echo "export GCE_CLIENT_ID=<YOUR_GOOGLE_CLIENT_ID>" >> ~/.bashrc
echo "export GCE_CLIENT_SECRET=<YOUR_GOOGLE_CLIENT_SECRET>" >> ~/.bashrc

echo "export CJID=<YOUR_CJID>" >> ~/.bashrc
echo "export CJKEY=<YOUR_CJKEY>" >> ~/.bashrc

source ~/.bashrc

git clone https://github.com/motiwari/stats285.github.io.git
cd stats285.github.io/elasticluster_tutorial/
chmod +x setup.sh
./setup.sh
```

The script `setup.sh` will require initial user interaction to pass a Google authentication challenge; everything afterwards is automatic. It will take some time to complete (~20 minutes).

# Step 5: Test elasticluster

At this point, all the dependencies for elasticluster and clusterjob have been installed. To create a small memory cluster and establish communication to each node, run:
```elasticluster start gce```
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
ssh gce-frontend001.$GCE_ZONE.$GCE_PROJECT_ID
ssh gce-compute001.$GCE_ZONE.$GCE_PROJECT_ID
ssh gce-compute002.$GCE_ZONE.$GCE_PROJECT_ID
ssh gce-compute003.$GCE_ZONE.$GCE_PROJECT_ID
ssh gce-compute004.$GCE_ZONE.$GCE_PROJECT_ID
```

These node names are important and they are created from information in your config file. Each node name contains your cluster, role, and number, e.g. "`gce-frontend001`" or "`gce-high-mem-compute002`". Followed by a zone/region designator, e.g. "`us-central1-a`". Finally, your project ID, e.g. "`superb-garden-303018`" is concatenated to make a fully qualified node name. The node name of the frontend will be needed for ClusterJob.

One destroys a cluster, equally unsurprisingly, with a "`stop`" command:
```
elasticluster stop gce
```

# Step 6: Test clusterjob
Now that we have a compute cluster, it is time to perform a calculation using it using ClusterJob. Like all research software, ClusterJob has [basic documentation](https://clusterjob.org/documentation/). This is augmented by a draft chapter of a [Data Science book by Hatef Monajemi](https://monajemi.github.io/datascience/pages/elasticluster-clusterjob-model). This tutorial is a distillation of these other works in the very pragmatic context of running a simple example for this class. Most users borrow an existing set of configuration files and call it a day. As we expand a cluster's hardware to include GPUs, the configuration files will evolve. Those extensions will be discussed in class.

To test your ClusterJob installation:
```
elasticluster start gce
# After the cluster is ready.
gcloud compute config-ssh

# Run simpleExample.py
cd ~/CJ_install/example/Python/
cj run simpleExample.py gce -m "Python." | yes
cj state
```

# Step 7: Run Phase Transition Code
Now we are going to calculate a phase transition code. The course CAs will describe the details of the code and what it is calculating in class. This tutorial will show you how to run it. First, get the code:
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

# Step 8: Gather all of the computed results and share them with your instructors.
When the job has completed, after about 3 hours, you will then need to get your results from the cluster by first `reducing` them and then `getting` them onto your local Ubuntu image. Because you may have many different jobs running, you will need to tell CJ which job to reduce and get. the `cj state` command also tells you the `PID`, process identifier, to allow you to reduce the right data. In the below example, `ff1cf89ab2f4c51800a900704dda041f637ca620` is a sample `PID`; yours will be different.
```
cj reduce final_results.txt ff1cf89ab2f4c51800a900704dda041f637ca620
cj get ff1cf89ab2f4c51800a900704dda041f637ca620
```
Now you get the scientific joy of determining what you just calculated and what it all means. Mazeltov. The CA will reveal all. Please copy your shell results to Stanford's Canvas system to get credit for performing this tutorial.
