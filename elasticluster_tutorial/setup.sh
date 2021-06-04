sudo apt update
sudo apt upgrade -y
sudo apt install gcc g++ git libc6-dev libffi-dev libssl-dev python3-dev virtualenv | yes

# Initialize gcloud. This is the only part of the script that requires interaction.
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk | yes

gcloud init
gcloud compute config-ssh

# Create elasticluster virtual environment.
cd ~
virtualenv --python=python3 elasticluster
echo ". elasticluster/bin/activate" >> ~/.bashrc
source ~/.bashrc
pip3 install --upgrade 'pip>=9.0.0'
cd elasticluster/

# Install elasticluster.
git clone https://github.com/gc3-uzh-ch/elasticluster.git src
cd src
pip install -e .

##### Setup Elasticluster config
cd ~
mkdir .elasticluster
cp ~/stats285.github.io/elasticluster_tutorial/sample_elasticluster_config ~/.elasticluster/config
sed -i "s/<YOUR_GOOGLE_CLIENT_ID>/$GCE_CLIENT_ID/g" ~/.elasticluster/config
sed -i "s/<YOUR_GOOGLE_CLIENT_SECRET>/$GCE_CLIENT_SECRET/g" ~/.elasticluster/config
sed -i "s/<YOUR_GOOGLE_PROJECT_ID>/$GCE_PROJECT_ID/g" ~/.elasticluster/config
sed -i "s/<YOUR_PREFERRED_GOOGLE_ZONE>/$GCE_ZONE/g" ~/.elasticluster/config

# Install perl package management prerequisites.
sudo apt install build-essential | yes
sudo apt-get install libnet-ssleay-perl | yes # required for cpan -i Net::SSLeay
sudo apt-get install libcrypt-ssleay-perl | yes # required for cpan -i Net::SSLeay
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
cd ~
git clone https://github.com/adonoho/clusterjob.git ~/CJ_install
echo "alias cj='perl ~/CJ_install/src/CJ.pl'" >> ~/.bashrc
cd ~ && source ~/.bashrc

# Do CJ config and SSH #########################
cp ~/stats285.github.io/elasticluster_tutorial/sample_cj_config ~/CJ_install/cj_config
sed -i "s/<YOUR_CJID>/$CJID/g" ~/CJ_install/cj_config
sed -i "s/<YOUR_CJKEY>/$CJKEY/g" ~/CJ_install/cj_config

cp ~/stats285.github.io/elasticluster_tutorial/sample_cj_ssh_config ~/CJ_install/ssh_config
sed -i "s/<YOUR_GOOGLE_PROJECT_ID>/$GCE_PROJECT_ID/g" ~/CJ_install/ssh_config
sed -i "s/<YOUR_PREFERRED_GOOGLE_ZONE>/$GCE_ZONE/g" ~/CJ_install/ssh_config
sed -i "s/<YOUR_GOOGLE_USERNAME_OR_EMAIL>/$GCE_USERNAME/g" ~/CJ_install/ssh_config

# Initialize CJ
cj init
cj who
