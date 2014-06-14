git_dir=
log_dir=/apps/log

sudo mkdir ~/tmp
sudo cp -rf $git_dir/etc/nagios/files/* ~/tmp
sudo yum -y install wget php gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel perl-rrdtool perl-GD

cd ~/tmp/
sudo tar -xzf nagios-4.0.7.tar.gz 
sudo tar -xzf nagios-plugins-2.0.2.tar.gz 
sudo tar -xzf nagiosgraph-1.5.1.tar.gz
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


# nagios Graph
sudo cpan Nagios::Config

cd ~/tmp/nagiosgraph-1.5.1
sudo mkdir /etc/nagiosgraph
sudo cp etc/* /etc/nagiosgraph
sudo cp $git_dir/etc/nagios/nagiosgraph/nagiosgraph.conf /etc/nagiosgraph

sudo mkdir -p $log_dir/nagiosgraph/
sudo mkdir $log_dir/nagiosgraph/base/
sudo mkdir $log_dir/nagiosgraph/rrd/

sudo chown nagios:nagios -R $log_dir/nagiosgraph/base/
sudo chown nagios:nagios -R $log_dir/nagiosgraph/rrd/
sudo chmod 755 -R $log_dir/nagiosgraph/base/
sudo chmod 755 -R $log_dir/nagiosgraph/rrd

sudo touch $log_dir/nagiosgraph/base/nagiosgraph.log
sudo chown nagios:nagios $log_dir/nagiosgraph/base/nagiosgraph.log
sudo chmod 644 $log_dir/nagiosgraph/base/nagiosgraph.log

sudo touch $log_dir/nagiosgraph/base/nagiosgraph-cgi.log
sudo chown apache:apache $log_dir/nagiosgraph/base/nagiosgraph-cgi.log
sudo chmod 644 $log_dir/nagiosgraph/base/nagiosgraph-cgi.log

sudo cp -rf $git_dir/etc/nagios/etc/* /usr/local/nagios/etc/
sudo cp -rf $git_dir/etc/nagios/libexec/* /usr/local/nagios/libexec/
sudo cp -rf $git_dir/etc/nagios/share/* /usr/local/nagios/share/
sudo cp -rf $git_dir/etc/nagios/sbin/* /usr/local/nagios/sbin/
sudo chmod +x /usr/local/nagios/libexec/check_mem.pl
sudo chmod +x /usr/local/nagios/libexec/insert.pl
sudo chown nagios:nagios /usr/local/nagios/sbin/show*
sudo chown -R nagios:nagios /usr/local/nagios/etc/*
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
sudo /etc/rc.d/init.d/nagios restart

sudo rm -rf ~/tmp

