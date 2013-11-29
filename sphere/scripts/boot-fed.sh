#!/bin/bash
# Runs the Server and the Service

# Process IDs

FEDSERVER_PID=""
FEDSERVICE_PID=""
SPHERE=/Users/filippogaudenzi/Universita/Tesi/sourceFromG/sphere/

# Server Application

FEDSERVER="/Users/filippogaudenzi/Universita/Tesi/sourceFromG/sphere/z__server_fed/bin/ejabberdctl "

# Service application and configuration

SERVICE_CONF="/Users/filippogaudenzi/Universita/Tesi/sourceFromG/sphere/service/config/federation.conf "
SERVICE="java -classpath `cat $SPHERE/scripts/installation/classpath` net.bioclipse.xws.component.Component run "

# Get Process IDs

function get_FEDSERVICE_PID {
  # FEDSERVICE_PID=`ps ax | grep java | grep xws | grep federation |cut -d " " -f 2`
 for i in `ps ax | grep java | grep xws | grep federation  | tr '.' '\n'`; do
   str=${str},${i}
   let n=$n+1
   var=`echo "var${n}"`
  if [ ${i} != "" ]
then
   FEDSERVICE_PID=${i}
   break
fi
echo $var is $i
#prendere la prima variabile di stampa;
done
} 

function get_FEDSERVER_PID {
   #FEDSERVER_PID=`ps ax | grep epmd | grep daemon | grep server_fed | cut -d " " -f 3`
   for i in `ps ax | grep epmd | grep daemon | grep server_fed | tr '.' '\n'`; do
   str=${str},${i}
   let n=$n+1
   var=`echo "var${n}"`
  if [ ${i} != "" ]
then
   FEDSERVER_PID=${i}
	break
fi
done
}

# Stop

function stop {
   get_FEDSERVICE_PID
   get_FEDSERVER_PID

   if [ -z $FEDSERVICE_PID ]; then
      echo "Sphere service is not running."
   else
      echo -n "Stopping Sphere Service"
      kill $FEDSERVICE_PID
      sleep 1
      echo "... Done."
   fi
   if [ -z $FEDSERVER_PID ]; then
      echo "Sphere server is not running."
      exit 1
   else
      echo -n "Stopping Sphere Server"
      kill $FEDSERVER_PID
      sleep 3
      echo "... Done."
   fi
}

# Start

function start {
   get_FEDSERVICE_PID
   get_FEDSERVER_PID

   if [ -z $FEDSERVER_PID ]; then
      echo  "Starting Sphere-Federation Server"
      #aggiunta
      echo $FEDSERVER
      #fine
      $FEDSERVER start
      get_FEDSERVER_PID
      echo "Done. FEDSERVER_PID=$FEDSERVER_PID"
	  sleep 3
   else
      echo "Sphere Server is already running, FEDSERVER_PID=$FEDSERVER_PID"
   fi

   if [ -z $FEDSERVICE_PID ]; then
      echo  "Starting Sphere Service"
      $SERVICE $SERVICE_CONF &
      get_FEDSERVICE_PID
      echo "Done. FEDSERVICE_PID=$FEDSERVICE_PID"
   else
      echo "Sphere is already running, FEDSERVICE_PID=$FEDSERVICE_PID"
   fi
}

# Restart

function restart {
   echo  "Restarting Sphere..."
   get_FEDSERVER_PID
   get_FEDSERVICE_PID

   if [ -z $FEDSERVER_PID ]; then
	if [ -z $FEDSERVICE_PID ]; then
 	     start
  	  else
    		  stop
    	 	 start
  	 fi	
   fi
}

function servicestart {
   get_FEDSERVICE_PID

   if [ -z $FEDSERVICE_PID ]; then
       echo  "Starting Sphere Service"
      $SERVICE $SERVICE_CONF &
      echo "... Done."
   else
      echo "Sphere service is already running, FEDSERVICE_PID=$FEDSERVICE_PID"
   fi
}

function servicerestart {
   get_FEDSERVICE_PID

   if [ -z $FEDSERVICE_PID ]; then
      echo "Sphere service is not running."
   else
      echo -n "Stopping Sphere Service"
      kill $FEDSERVICE_PID
       echo  "Starting Sphere Service"
      $SERVICE $SERVICE_CONF &
      echo "... Done."
   fi
}

# Status

function status {
   echo "Status:"
   get_FEDSERVER_PID
   get_FEDSERVICE_PID

   if [ -z  $FEDSERVER_PID ]; then
      echo "Sphere Server is not running."
   else
      echo "Sphere Server is running, FEDSERVER_PID=$FEDSERVER_PID"
   fi

   if [ -z  $FEDSERVICE_PID ]; then
      echo "Sphere Service is not running."
      exit 1
   else
      echo "Sphere Service is running, FEDSERVICE_PID=$FEDSERVICE_PID"
   fi

}

# argv[]s

case "$1" in
   start)
      start
   ;;
   stop)
      stop
   ;;
   restart)
      restart
   ;;
   status)
      status
   ;;
   servicerestart)
      servicerestart
   ;;
   servicestart)
      servicestart
   ;;

   *)
      echo "Usage: $0 {start|stop|restart|status|servicestart|servicerestart}"
esac 
