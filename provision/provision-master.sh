MASTER_IP=$1
NUM_SLAVES=$2
SLAVE_IPS=$3
SCRIPT_DIR=$4


MASTER_NAME=hadoop-master

if [ $NUM_SLAVES -gt 0 ]; then
  SLAVE_NAMES=($(eval echo hadoop-slave-{1..${NUM_SLAVES}}))

  slave_ip_array=(${SLAVE_IPS//,/ })
  for (( i=0; i<${#SLAVE_NAMES[@]}; i++)); do
    slave=${SLAVE_NAMES[$i]}
    ip=${slave_ip_array[$i]}
    if [ ! "$(cat /etc/hosts | grep $slave)" ]; then
      echo "Adding $slave to hosts file"
      echo "$ip $slave" >> /etc/hosts
    fi
  done
else
  echo "number of slaves = 0. creating a single node cluster.. "
fi

echo "Installing hadoop ..."
pushd $SCRIPT_DIR
source ./hadoop-config.sh
./provision-hadoop.sh $MASTER_IP $NUM_SLAVES $SLAVE_IPS
./restart-hadoop-master-daemons.sh

if [ $NUM_SLAVES -eq 0 ]; then
  ./restart-hadoop-slave-daemons.sh
fi

popd
