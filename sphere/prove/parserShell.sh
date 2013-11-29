#!/bin/bash
n=0
#a=$FEDCLOUDPATH/prove/text.tx
#a=`ps ax | grep java | grep xws | grep datacenter`
#for i in `cat ${a} | tr '.' '\n'` ; do
for i in `ps ax | grep java | grep xws | grep datacenter | tr '.' '\n'`; do
   str=${str},${i}
   let n=$n+1
   var=`echo "var${n}"`
  if [ ${n} = "1" ]
then
   result=${i}
else
    echo NO $var is ... ${i}
fi
done
echo SERVICE PID $result