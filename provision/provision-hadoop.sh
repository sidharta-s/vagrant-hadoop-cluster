#!/bin/bash

#this script must be run from inside the cluster/vagrant directory
NUM_SLAVES=$2

if [ $NUM_SLAVES -eq 0 ]; then
  #use localhost/127.0.0.1
  MASTER_IP="localhost"
  SLAVE_IPS="localhost"
else
  MASTER_IP=$1
  SLAVE_IPS=$3
fi

set -e

echo installing jdk ..
yum install java-1.7.0-openjdk-1.7.0.71-2.5.3.1.el6 java-1.7.0-openjdk-devel-1.7.0.71-2.5.3.1.el6 -y

if [ -d "${HADOOP_HOME}" ]
then
  echo "WARNING: hadoop home : ${HADOOP_HOME} already exists. deleting."
  rm -fr ${HADOOP_HOME}
fi

echo "creating hadoop install dir: ${HADOOP_INSTALL_DIR} "
mkdir -p ${HADOOP_INSTALL_DIR}

echo "extracting hadoop installation ... "
tar -zxvf ${HADOOP_ARCHIVE} -C ${HADOOP_INSTALL_DIR}

echo "creating hadoop environment script... "
cat <<EOF > ${ENV_CONFIG}
export JAVA_HOME=$JAVA_HOME
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop
EOF

#rm -fr ${HADOOP_HOME}/etc
#cp -r ${HADOOP_ARCHIVE_DIR}/etc ${HADOOP_HOME}

echo "setting up core-site.xml .. "
cp ${HADOOP_ARCHIVE_DIR}/core-site.xml ${CORE_SITE}
sed -i -e "s;__MASTER_IP__;${MASTER_IP};g" -e "s;__HADOOP_HOME__;${HADOOP_HOME};g" ${CORE_SITE}

echo "setting up yarn-site.xml .. "
cp ${HADOOP_ARCHIVE_DIR}/yarn-site.xml ${YARN_SITE}
sed -i "s;__MASTER_IP__;${MASTER_IP};g" ${YARN_SITE}

echo "setting up mapred-site.xml .. "
cp ${HADOOP_ARCHIVE_DIR}/mapred-site.xml ${MAPRED_SITE}

echo "setting up slaves file .. "
echo "slaves list : ${SLAVE_IPS}"
echo ${SLAVE_IPS} | sed "s/,/\n/g" > ${SLAVES}

echo "done installing hadoop environment"

echo "copying test map reduce script .. "
cp ${MR_SCRIPT} ${HADOOP_HOME}

#echo "changing owner for hadoop installation.. "
#echo "chown -R vagrant:vagrant ${HADOOP_INSTALL_DIR}
