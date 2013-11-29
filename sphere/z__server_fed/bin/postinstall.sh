#!/bin/sh

echo
echo "       -=- ejabberd post installation script -=- "
echo "              (c) 2005-2010 ProcessOne "
echo 
echo "* Checking ejabberd installation"
echo 
echo "* Starting ejabberd instance"
cd /Applications/Dev/Jabber/server/bin
./ejabberdctl start
./ejabberdctl started
[ $? -eq 0 ] && {
  echo
  echo "* Creating administrator user"
  ./ejabberdctl register "$1" "$2" "$3"
  echo
  echo "* Stopping ejabberd instance"
  ./ejabberdctl stop
  ./ejabberdctl stopped
  echo "==> Setup finished"
} || {
  echo "* Error, ejabberd can not start"
  exit 1
}
