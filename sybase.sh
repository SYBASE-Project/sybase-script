#!/bin/bash


if [ $(id -u) != "0" ]; then
    echo "You must be the superuser to run this script" >&2
    exit 1
fi
 
#function start here
export SERVER=/opt/*/ASE*/install
function start_server
{
#echo "press 's' to start server"
cd $SERVER 
echo "select a server to start:"
ls RUN_* --format single-columnn
read NAME
if [ $NAME = "" ]; then
echo "server name cannot to be empty!!"
elif [ $NAME != *,RUN_*,* ]; then
echo "please enter a valid server name"
else
echo " server found "
echo " $NAME server starting... "
pause 04
fi
startserver -f $NAME
}

echo  "enter s to start server, q to quit"

while [ num != "q" ]
do
read num
#case
case $num in
s) start_server ;;
q) exit ;;
#h) HELLO ;;
* ) echo "enter somerhing"
esac
done 
#TEMP
