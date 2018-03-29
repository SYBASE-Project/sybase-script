#!/bin/bash
if [ $(id -u) != "0" ]; then
    echo "You must be the superuser to run this script" >&2
    exit 1
fi
#function starts here
function crontab
{
export CRON="/opt/*/ASE-16_0"
cd $CRON
if [ ! -d crontab ]; then
mkdir -p  crontab
echo "crontab directory created"
else
echo "crontab directory already exits"
fi
sleep 03
cd $CRON/crontab
touch dump.sh
chmod 755 dump.sh
echo "##############################################################################"
echo "please enter login type, server name, password, database name, path to dump"
echo "*****************************************************************************"
echo "enter login type (sa)"
read sa
echo "enter server name"
read serv
echo "enter password"
read psd 
echo "enter the databse name to dump"
read dbname
echo "enter the path to store $dbname dump"
read dpath
echo "
#!/bin/bash
isql64 -U$sa -S$serv -Ppsd << EOF
dump database $dbname to $dpath
go
EOF
echo "!!"
" >> dump.sh
echo "crontab scheduled sucessfully"

}
#case
echo  "enter c to start crontab, q to quit"
while [ num != "q" ]
do
read num
#case
case $num in
c) crontab ;;
q) exit ;;
#c) create_server ;;
* ) echo "enter "s" or "q" "
esac
done 
