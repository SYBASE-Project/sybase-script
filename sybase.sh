#!/bin/bash
if [ $(id -u) != "0" ]; then
    echo "You must be the superuser to run this script" >&2
    exit 1
fi
#function start here
function crontab
{
export CRON="/opt/*/ASE*"
cd $CRON
if [ ! -d "crontab" ]; then
exec mkdir -p crontab
echo "#####################################"
echo "crontab directory created..!" 
echo "#####################################"
else
echo "#####################################"
echo "crontab directory already exits"
echo "#####################################"
fi
sleep 04
export CRONTAB="$CRON/crontab"
cd $CRONTAB
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo " please enter your server name and password and database name for which dump has to be done"
echo "********************************************************************************************"
echo "server name"
read serv
echo "password"
read pwd
echo "database name"
read dbname
touch dump.sh
echo "#!/bin/bash
isql64 -Usa -S$serv -P$pwd << EOF
dump database $dbname to opt/*/ASE-16_0/crontab/dump.dat
go
EOF
echo "!!"
" >> dump.sh
echo "crontab scheduled .."
echo "press s to main menu q to quit"
}

#while case start here
echo  "enter ct to start server, q to quit"

while [ num != "q" ]
do
read choice
#case
case $choice in
#s) start_server ;;
q) exit ;;
[Cc]t | C[tT]) crontab ;;
* ) echo "enter "s" or "q" "
esac
done 
