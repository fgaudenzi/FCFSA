#!/bin/bash
# Latest version
# Runs the Server and the Service

# Process IDs

SERVER_PID=""
SERVICE_PID=""
SPHERE=/Users/filippogaudenzi/Universita/Tesi/sourceFromG/sphere/

# Server Application

SERVER="/Users/filippogaudenzi/Universita/Tesi/sourceFromG/sphere/server/bin/ejabberdctl "

# Service application and configuration

SERVICE_CONF="/Users/filippogaudenzi/Universita/Tesi/sourceFromG/sphere/service/config/datacenter.conf "
SERVICE="java -classpath `cat $SPHERE/scripts/installation/classpath` net.bioclipse.xws.component.Component run "

# Get Process IDs

function get_service_pid {
   #SERVICE_PID=`ps ax | grep java | grep xws | grep datacenter |cut -d " " -f 2`
  for i in `ps ax | grep java | grep xws | grep datacenter | tr '.' '\n'`; do
   str=${str},${i}
   let n=$n+1
   var=`echo "var${n}"`
  if [ ${i} != "" ]
then
   SERVICE_PID=${i}
   break
fi
done
} 

function get_server_pid {
   SERVER_PID=`ps ax | grep epmd | grep daemon | cut -d " " -f 2`
   for i in `ps ax | grep epmd | grep daemon | tr '.' '\n'`; do
   str=${str},${i}
   let n=$n+1
   var=`echo "var${n}"`
  if [ ${i} != "" ]
then
   SERVER_PID=${i}
   break
fi
done
}

# Stop

function stop {
   get_service_pid
   get_server_pid

   if [ -z $SERVICE_PID ]; then
      echo "Sphere service is not running."
   else
      echo -n "Stopping Sphere Service"
      kill $SERVICE_PID
      sleep 1
      echo "... Done."
   fi
   if [ -z $SERVER_PID ]; then
      echo "Sphere server is not running."
      exit 1
   else
      echo -n "Stopping Sphere Server"
      kill $SERVER_PID
      sleep 3
      echo "... Done."
   fi
}

# Start

function start {
   get_service_pid
   get_server_pid

   if [ -z $SERVER_PID ]; then
      echo  "Starting Sphere Server"
      $SERVER start
      get_server_pid
      echo "Done. SERVER_PID=$SERVER_PID"
	  sleep 3
   else
      echo "Sphere Server is already running, SERVER_PID=$SERVER_PID"
   fi

   if [ -z $SERVICE_PID ]; then
      echo  "Starting Sphere Service"
      $SERVICE $SERVICE_CONF &
      get_service_pid
      echo "Done. SERVICE_PID=$SERVICE_PID"
   else
      echo "Sphere is already running, SERVICE_PID=$SERVICE_PID"
   fi
}

# Restart

function restart {
   echo  "Restarting Sphere..."
   get_server_pid
   get_service_pid

   if [ -z $SERVER_PID ]; then
	if [ -z $SERVICE_PID ]; then
 	     start
  	  else
    		  stop
    	 	 start
  	 fi	
   fi
}

function servicestart {
   get_service_pid

   if [ -z $SERVICE_PID ]; then
       echo  "Starting Sphere Service"
      $SERVICE $SERVICE_CONF &
      echo "... Done."
   else
      echo "Sphere service is already running, SERVICE_PID=$SERVICE_PID"
   fi
}

function servicerestart {
   get_service_pid

   if [ -z $SERVICE_PID ]; then
      echo "Sphere service is not running."
   else
      echo -n "Stopping Sphere Service"
      kill $SERVICE_PID
       echo  "Starting Sphere Service"
      $SERVICE $SERVICE_CONF &
      echo "... Done."
   fi
}

# Status

function status {
   echo "Status:"
   get_server_pid
   get_service_pid

   if [ -z  $SERVER_PID ]; then
      echo "Sphere Server is not running."
   else
      echo "Sphere Server is running, SERVER_PID=$SERVER_PID"
   fi

   if [ -z  $SERVICE_PID ]; then
      echo "Sphere Service is not running."
      exit 1
   else
      echo "Sphere Service is running, SERVICE_PID=$SERVICE_PID"
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
