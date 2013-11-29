#!/bin/sh
VDI=`xe vbd-list vm-uuid=<UUID> |grep vdi-uuid |cut -d\: -f2`
echo $VDI