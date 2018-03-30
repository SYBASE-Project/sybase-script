#!/bin/bash
function pubs
{
export scpath="/opt/sybase/ASE-16_0/scripts"
cd $scpath
echo "------------------------------------------"
echo "select a pub's database from below list "
ls installpubs* --format single-column
echo "------------------------------------------"
read pubname
if [ ! -f $pubname ]; then
echo "********************************"
echo "the $pubname not found try again"
elif [ $pubname = "" ]; then
echo "!!!!!!!!!!!!!!!!!!!!!!!!"
echo "field cannot to be empty"
else
echo "$pubname found and enter required information"
echo "##############################################"
fi
echo "enter server name"
read uname
echo "----------------------------------------------"
echo "enter password"
read pss
echo 
echo "server_name = $uname
login_name = sa
password = $pss"
echo 
xterm -hold -e "isql64 -Usa -S$uname -P$pss -i$pubname" 
sleep 02
return 0
}
pubs
