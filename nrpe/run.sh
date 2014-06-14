sudo yum -y install xinetd openssl-devel gcc

sudo mkdir ~/tmp
sudo cp -rf /apps/apps/infra/etc/nagios/files/* ~/tmp
sudo yum -y install xinetd openssl-devel gcc
sudo useradd -d /usr/local/nagios/ -M nagios
sudo chown nagios:nagios /usr/local/nagios/

cd ~/tmp/
sudo tar -xzf nagios-4.0.7.tar.gz 
sudo tar -xzf nagios-plugins-2.0.2.tar.gz 
sudo tar -xzf nrpe-2.15.tar.gz

# nagios install
cd ~/tmp/nagios-4.0.7
sudo  ./configure --with-nagios-user=nagios --with-nagios-group=nagios -prefix /usr/local/nagios
sudo make all
sudo make install
sudo make install-init
sudo make install-config
sudo make install-commandmode
sudo make install-webconf
sudo cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
sudo chown -R nagios:nagios /usr/local/app/nagios/libexec/eventhandlers
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

#nagios plugin install
cd ~/tmp/
cd ~/tmp/nagios-plugins-2.0.2
sudo ./configure && sudo make
sudo make install

# nrpe install
cd ~/tmp/
tar -xzf nrpe-2.15.tar.gz 
cd ~/tmp/nrpe-2.15
sudo ./configure && sudo make && sudo make install

sudo cp -rf /apps/apps/infra/etc/nagios/libexec/check_mem.pl /usr/local/nagios/libexec/       
sudo chmod +x /usr/local/nagios/libexec/check_mem.pl 
sudo echo "nrpe 5666/tcp # NRPE" >> /etc/services
sudo cp /apps/apps/infra/etc/nrpe/nrpe.cfg /usr/local/app/nagios/etc/
sudo chown nagios:nagios /usr/local/nagios/etc/nrpe.cfg
sudo cp /apps/apps/infra/etc/nrpe/nrpe /etc/xinetd.d/nrpe
sudo /etc/rc.d/init.d/xinetd start

sudo rm -rf ~/tmp
