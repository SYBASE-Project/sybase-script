#!/bin/bash
#function pd
#{
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
function loopi
{
echo "****************************"
echo "1.Pubs installation"
echo "2.DBCCDB installation"
echo "3.Quit to main menu"
echo "****************************"
echo
echo  "select your choice"
read choice
if [ $choice == "1" ]; then
pubs
elif [ $choice == "2" ]; then
dbccdb
else
echo "enter a valid choice"
fi
}
loopi
