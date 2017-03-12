#!/bin/bash

# $1 = datapath
# $2 = size
# #3 = count

if [[ -z ${stripsize+x} ]]; then
   stripsize=8
   fi

if [ $# -eq 0 ]; then
   echo "pvcreatelun datapath size count"
   echo "    hostdirectory - used for the pv"
   echo "    size - example 1G"
   echo "    count - Optional - Number of luns to create"
   echo " $OSEUSERNAME should be set to the Openshift User Name"
   exit 0
   fi
# Call ourselves recursively to do repeats
if [ $# -eq 3 ]; then
   for ((i=0;i < $3;i++))
       do
      ./createpv.sh $1 $2
      done
    exit 0
   fi

LUNFILE=~/.oseluncount.cnt
DEVFILE=~/.osedevcount.cnt
TAG=$0

if [ -e ${LUNFILE} ]; then
    count=$(cat ${LUNFILE})
else
    touch "$LUNFILE"
    count=0
fi

if [ -e ${DEVFILE} ]; then
    dcount=$(cat ${DEVFILE})
else
    touch "$DEVFILE"
    dcount=1
   echo ${dcount} > ${DEVFILE}
fi

lunid=${count}
((count++))

echo ${count} > ${LUNFILE}

printf -v padcnt "%03d" $count
export padcnt
export volname="ose${dcount}n${padcnt}x$2"

minishift ssh "sudo mkdir -p /data/$volname"
minishift ssh "sudo chmod 777 /data/$volname"

cat <<EOF > $volname.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: appdata${dcount}x${padcnt}
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: ${2}Gi
  hostPath:
    path: /data/$volname
EOF
oc create -f $volname.yml
rm -f $volname.yml
if [ ${count} -eq 100 ]; then
   ((dcount++))
   count=0
   echo ${count} > ${LUNFILE}
   echo ${dcount} > ${DEVFILE}
fi

