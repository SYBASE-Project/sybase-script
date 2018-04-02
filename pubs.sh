#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root type: sudo ./installscript" 
   	exit 1
fi
function pd
{
export scpath="/opt/sybase/ASE-16_0/scripts"
#function pubs
function pubs ()
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
#dbccdb function
function dbccdb ()
{
echo " welcome to dbccdb instalation.."
cd $scpath
echo "----------------------------------------"
ls installdbccdb
if [ -f installdbccdb ]; then
echo "no dbccdb file found..!"
else 
echo "to install dbccdb please enter required information.."
fi
echo "##############################################"
echo "enter server name"
read dbccsrvname
echo "----------------------------------------------"
echo "enter password"
read dbccsrvpss
echo 
echo "server_name = $dbccsrvname
login_name = sa
password = $dbccsrvpss"
echo 
xterm -hold -e "isql64 -Usa -S$dbccsrvname -P$dbccsrvpss -iinstalldbccdb" 
sleep 02
#return 0
}
#}
#end of inner function

sudo apt-get install dialog
opn=(dialog --separate-output --checklist "please Select an Option:" 22 76 16)
options=(1 "pubs" off
2 "dbccdb" off)
choice=$("${opn[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

#read choice
for choice in $choice
do
case $choices in
1)echo "installings pubs"
 pubs ;;
2)echo "installing dbccdb"
 dbccdb ;;
esac
done

}
pd
