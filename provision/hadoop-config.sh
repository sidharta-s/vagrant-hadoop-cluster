set -e

export JDK_DEVEL_PKG_VER=java-1.7.0-openjdk-devel-1.7.0.65-2.5.2.5.fc20
export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/
export HADOOP_INSTALL_DIR=/home/vagrant/hadoop/install
export HADOOP_ARCHIVE_DIR=hadoop

#To use a custom archive: copy the archive (with extension .tar.gz) into the HADOOP_ARCHIVE_DIR and change this line
export HADOOP_ARCHIVE=${HADOOP_ARCHIVE_DIR}/hadoop-2.6.0.tar.gz

export HADOOP_ARCHIVE_FALLBACK=http://mirror.reverse.net/pub/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
export HADOOP_ARCHIVE_FALLBACK_FILE=hadoop/hadoop-2.6.0.tar.gz
export MR_SCRIPT=test-pi-yarn.sh

if [ ! -f "${HADOOP_ARCHIVE}" ]; then
  echo "hadoop archive not found: ${HADOOP_ARCHIVE}"

  if [ ! -f "${HADOOP_ARCHIVE_FALLBACK_FILE}" ]; then
    echo "fallback archive not found: ${HADOOP_ARCHIVE_FALLBACK_FILE}"
    echo "downloading ${HADOOP_ARCHIVE_FALLBACK}"  
    curl ${HADOOP_ARCHIVE_FALLBACK} -o ${HADOOP_ARCHIVE_FALLBACK_FILE}
  fi
  
  export HADOOP_ARCHIVE=${HADOOP_ARCHIVE_FALLBACK_FILE}
fi  

#HACK/TODO : for now, extension MUST be .tar.gz
export HADOOP_HOME=${HADOOP_INSTALL_DIR}/$(basename ${HADOOP_ARCHIVE} .tar.gz)
export YARN_SITE=${HADOOP_HOME}/etc/hadoop/yarn-site.xml
export CORE_SITE=${HADOOP_HOME}/etc/hadoop/core-site.xml
export MAPRED_SITE=${HADOOP_HOME}/etc/hadoop/mapred-site.xml
export SLAVES=${HADOOP_HOME}/etc/hadoop/slaves
export ENV_CONFIG=${HADOOP_HOME}/env.sh
