#!/bin/sh

echo
echo "       -=- ejabberd pre uninstallation script -=- "
echo "              (c) 2005-2010 ProcessOne "
echo 
echo "* Stopping ejabberd instance"
/Applications/Dev/Jabber/server/bin/ejabberdctl stop 
/Applications/Dev/Jabber/server/bin/ejabberdctl stopped
/Applications/Dev/Jabber/server/bin/epmd -names | grep -q name || {
  echo "* Stopping Erlang Portmapper Deamon"
  /Applications/Dev/Jabber/server/bin/epmd -kill
}
echo "* backup current config"
cp -r /Applications/Dev/Jabber/server/conf /Applications/Dev/Jabber/server/conf.$(date +%y%m%d)
echo 
echo "==> Pre uninstallation tasks finished"
