# vagrant-hadoop-cluster 
A simple mechanims to bring up a multi-VM hadoop cluster running YARN/HDFS.

## Bringing up the cluster

Please ensure you have Vagrant (at least 1.6.2), VirtualBox (at least 4.3.x) and git installed. 

```
$ git clone git@github.com:sidharta-s/vagrant-hadoop-cluster.git 
$ cd vagrant-hadoop-cluster 
$ export NUM_SLAVES=0 #brings up a single node cluster. defaults to 2 if not specified 
$ vagrant up 
```
Following these steps will bring up a multi-VM (depending on `NUM_SLAVES`) hadoop cluster running YARN and HDFS. Depending on your local hardware and available bandwidth, bringing the cluster up could take a while to complete.

### YARN Dashboard 
By default, the `master` has the ip `10.245.100.2`. The YARN Dashboard is running at `http://10.245.100.2:8088/`

### HDFS Dashbaord
The HDFS dashboard is running at `http://10.245.100.2:50070/`

## Using your own hadoop archive
If you want to provide your own archive, edit `provision/hadoop-config.sh` and modify `HADOOP_ARCHIVE`. 

## YMMV
This is a very basic setup. Secure clusters are not supported currently and some parts of the setup/configuration are clunky. I find this useful to create my dev/test environments. Please feel free to fork and make changes.
