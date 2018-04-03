#!/bin/bash


if [ $(id -u) != "0" ]; then
    echo "You must be the superuser to run this script" >&2
    exit 1
fi

#function start here
function server_build
{
#Enter '1'to build adaptive server
#acquiring needed datails
export srv="$SYBASE/ASE*/init/sample_resource_files"
cd $srv
clear
echo "Enter the name of the sever:"
read srv_name
clear
echo "Enter Password for the server($srv_name):"
read password
clear
echo "enter the host name(eg:localhost):"
read host_name
clear
echo "Enter a Port Number:"
read port_num
clear
#display server details
echo "Server Details"
echo "***************************************"
echo
echo "server_name:$srv_name"
echo "password:$password"
echo "Default host:$host_name"
echo "Port Number:$port_num"
echo "BackUp Server Name:$srv_name-bkup"
echo
echo "****************************************"
sleep 04


#create and configure server.rs file
#begin---------------------------------------------------------------------
export srv="$SYBASE/ASE*/init/sample_resource_files"
mkdir $HOME/$srv_name
cd $HOME
chmod 777 $srv_name
cd $HOME/$srv_name
echo "
sybinit.release_directory: USE_DEFAULT
sybinit.product: sqlsrv
sqlsrv.server_name: $srv_name
sqlsrv.sa_password: $password
sqlsrv.new_config: yes
sqlsrv.do_add_server: yes
sqlsrv.network_protocol_list: tcp
sqlsrv.network_hostname_list: $host_name
sqlsrv.network_port_list: $port_num
sqlsrv.application_type: USE_DEFAULT
sqlsrv.server_page_size: USE_DEFAULT
sqlsrv.force_buildmaster: no
sqlsrv.master_device_physical_name: "$HOME/$srv_name/MASTER.dat"
sqlsrv.master_device_size: USE_DEFAULT
sqlsrv.master_database_size: USE_DEFAULT
sqlsrv.errorlog: USE_DEFAULT
sqlsrv.do_upgrade: no
sqlsrv.sybsystemprocs_device_physical_name: "$HOME/$srv_name/SYBSYSTEMPROCS_DEVICE.dat"
sqlsrv.sybsystemprocs_device_size: USE_DEFAULT
sqlsrv.sybsystemprocs_database_size: USE_DEFAULT
sqlsrv.sybsystemdb_device_physical_name: "$HOME/$srv_name/SYBSYSTEMDB_DEVICE.dat"
sqlsrv.sybsystemdb_device_size: USE_DEFAULT
sqlsrv.sybsystemdb_database_size: USE_DEFAULT
sqlsrv.tempdb_device_physical_name: "$HOME/$srv_name/TEMPDB_DEVICE.dat"
sqlsrv.tempdb_device_size: USE_DEFAULT
sqlsrv.tempdb_database_size: USE_DEFAULT
sqlsrv.default_backup_server: $srv_name-bkup
#sqlsrv.addl_cmdline_parameters: PUT_ANY_ADDITIONAL_COMMAND_LINE_PARAMETERS_HERE
sqlsrv.do_configure_pci: no
sqlsrv.sybpcidb_device_physical_name: PUT_THE_PATH_OF_YOUR_SYBPCIDB_DATA_DEVICE_HERE
sqlsrv.sybpcidb_device_size: USE_DEFAULT
sqlsrv.sybpcidb_database_size: USE_DEFAULT
# If sqlsrv.do_optimize_config is set to yes, both sqlsrv.avail_physical_memory and sqlsrv.avail_cpu_num need to be set.
sqlsrv.do_optimize_config: no
sqlsrv.avail_physical_memory: PUT_THE_AVAILABLE_PHYSICAL_MEMORY_FOR_ASE_IN_OPTIMIZATION
sqlsrv.avail_cpu_num: PUT_THE_AVAILABLE_NUMBER_CPU_FOR_ASE_IN_OPTIMIZATION" | tee -a $srv_name.rs
#End-------------------------------------------------------------------------
clear
chmod 777 $srv_name.rs
echo
echo "SERVER IS READY TO BUILD.."
sleep 02
#build server main
cd $srv/$srv_name
srvbuildres -r $HOME/$srv_name/$srv_name.rs
echo
echo
echo
}

#build backup server
function backup_server
{
clear
echo "BACKUP SERVER"
echo
echo
echo "Enter your new BACKUP SERVER name:"
read srvb_name
clear
echo "Enter Existing Adaptive Server Name:"
read srve_name
clear
echo "enter the host name(eg:localhost):"
read host_name
clear
echo "Enter a Port Number:"
read port_num
clear
#Details---
echo
echo "*********************************"
echo
echo "BackUp Server Name:$srvb_name"
echo "Existing server Name:$srve_name"
echo "Host Name: $hostname"
echo "Port No:$port_num"
echo
echo "*********************************"
sleep 06
#create a .rs file to build
echo "creating a build file for Backup Server"
sleep 01
cd $HOME
chmod 777 $HOME
#begin--------------------------------------------------------------------------
echo "
sybinit.release_directory: USE_DEFAULT
sybinit.product: bsrv
bsrv.server_name: $srvb_name
bsrv.new_config: yes
bsrv.do_add_backup_server: yes
bsrv.do_upgrade: no
bsrv.network_protocol_list: tcp
bsrv.network_hostname_list: $host_name
bsrv.network_port_list: $port_num
bsrv.allow_hosts_list: PUT_ALLOW_HOSTS_TO_USE_BACKUPSERVER_HERE
bsrv.language: USE_DEFAULT
bsrv.character_set: USE_DEFAULT
bsrv.tape_config_file: USE_DEFAULT
bsrv.errorlog: USE_DEFAULT
sqlsrv.related_sqlsrvr: $srve_name
sqlsrv.sa_login: sa
sqlsrv.sa_password: USE_DEFAULT
#bsrv.addl_cmdline_parameters: PUT_ANY_ADDITIONAL_COMMAND_LINE_PARAMETERS_HERE" | tee -a $srvb_name.rs
#End-----------------------------------------------------------------------------
clear
#Build backup server
cd $HOME
chmod 777 $srvb_name.rs
echo "Building BackUp Server Started..."
sleep 01
cd $HOME
srvbuildres -r $HOME/$srvb_name.rs
echo
echo
echo 
echo "Backup Server succesfully Created"
echo
echo " Do You Want To Save Details of the Backup Server"
echo "press (s)to save (q) to quit."
read alpha
case $alpha in 
s) cd $HOME/Desktop
echo "
*********************************
BackUp Server Name:$srvb_name
Existing server Name:$srve_name
Host Name: $hostname
Port No:$port_num
*********************************" | tee -a server_details.txt
chmod 777 server_details.txt
clear
echo "details saved"
sleep 01 ;;
q)
clear
echo "GOOD BYE"
 exit
exit ;;
esac
}



#DATBASE AND TABLE CHECK SCRIPT
function dbtb
{
clear
echo 
clear
echo "server name:"
read servname
echo
echo "login name:"
read loginame
echo
echo "password:"
read spassword
echo
clear
echo "**********************"
echo "1.database check"
echo "2.table check"
echo "3.exit to main menu"
echo "**********************"
read num
if [ $num == 1 ]; then
dbcheck
elif [ $num == 2 ]; then
tbcheck
elif [ $num == 3 ]; then 
loop
else
loopdbtb
fi
}
#function DBCHECK
function dbcheck
{
cd $HOME/Desktop
echo "enter the db name to check"
read db
clear
isql64 -U$loginame -S$servname -P$spassword <<eof
select name from sysdatabases
go > $HOME/Desktop/temp.txt
eof
echo
chmod 777 temp.txt
scan=$(cat temp.txt | grep -v wildcard | grep -o $db)
echo
if [ "$scan" == "$db" ]; then
echo "$db FOUND IN THE SERVER:$servname"
else 
echo "OOPS...$db NOT FOUND IN $servname"
sleep 03
clear
fi
loopdbtb
}
#function tbcheck
function tbcheck
{
clear
cd $HOME/Desktop
echo "enter the db name to check"
read db1
echo "enter the table name to search:"
read tb
clear
isql64 -U$loginame -S$servname -P$spassword -D$db1 <<eof
select name from sysobjects where type="U"
go > $HOME/Desktop/temp.txt
eof
echo 
chmod 777 temp.txt
scanf=$(cat temp.txt | grep -v wildcard | grep -o $tb) 
echo
if [ "$scanf" == "$tb" ]; then
echo "$tb FOUND IN :$db1"
else 
echo "OOPS...$tb NOT FOUND IN $db1"
sleep 03
clear
fi
loopdbtb
}

#Function loopdbtb
function loopdbtb
{
clear
echo "****************************"
echo "1.Database check"
echo "2.Table check"
echo "3.Quit to main menu"
echo "****************************"
echo
echo  "select your choice"
read choice
case $choice in
1) dbcheck ;;
2) tbcheck ;;
3) loop;;
*) echo "wrong choice"
loopdbtb
esac
}



#START SERVER
#function start here
export SERVER="$SYBASE/ASE*/install"
function start_server
{
clear
cd $SERVER 
echo
echo "select a server to start:"
echo
echo "**********************************"
ls RUN_* --format single-column
echo "**********************************"
echo
echo "Input the name of the server to start or q to quit"
read NAME
if [ ! -f "$NAME" ] ; then
echo -e "${red}Server Not Found or Server Name Cannot be Empty"
echo -e "${nc}"
sleep 02
start_server
else
echo " $NAME server starting... "
sleep 03
startserver -f $NAME
fi
sleep 03
}
loop
#loop function for invalid choice
function loop
{
clear 
echo 
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
ltgray='\033[0;37m'
whi='\033[0;38m'
nc='\033[0m'

d=$(date +%H:%M:%S)
dd=$(date +%H)
name=$(whoami)
echo "$d"
if [ $dd -lt 12 ] ;
then

echo -e "${red}Good Morning $name"
elif [ $dd -ge 12 ] && [ $dd -lt 20 ] ;
then
echo -e "${red}Good Afternoon $name"
elif [ $dd -ge 20 ] && [ $dd -lt 24 ] ;
then
echo -e "${red}Good Night  $name"
else
echo -e "${red}Have a Nice Day $name"
fi
echo -e "${nc}"
echo 
echo "***************************"
echo "1.Build adaptive server"
echo "2.Build Back_Up server"
echo "3.Start Server"
echo "4.Crontab Schedule"
echo "5.Database and table check"
echo "6.Device operations"
echo "7.Install Sample DataBase (Pubs)"
echo "8.EXIT"
echo "***************************"
echo
echo -e "${green}Enter a Choice :"
echo -e "${nc}"
echo
read x
#case
case $x in
1) server_build ;;
2) backup_server ;;
3) start_server ;;
4) crontab ;;
5) dbtb ;;
6) xxx ;;
7) pubs ;;
8) echo -e "${red}Have a Nice Day "
echo -e "${red}GOOD BYE.... "
sleep 03
exit ;;
*) echo -e "${brown}Wait... What is That!! "
echo -e "${brown}Enter a Valid Choice!!" 
sleep 01
loop
esac
}
#CRONTAB
#function starts here
function crontab
{
export CRON="$SYBASE/ASE-16_0"
cd $CRON
if [ ! -d crontab ]; then
mkdir -p  crontab
echo "crontab directory created"
else
echo "crontab directory already exits"
echo "cron will start wait for 3 seconds.."
for (( i=3; i>0; i--)); do
  sleep 1 &
  printf "processing $i \r"
  wait
done
fi
#sleep 03
cd $CRON/crontab
touch dump.sh
chmod 755 dump.sh
echo "*****************************************************************************"
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
" > dump.sh
echo "-----------------------------------------------------------------------------------"
echo "use this script path to schedule crontab \"/opt/sybase/ASE-16_0/crontab/dump.sh\" "
echo " and enter scheluding \"time\"  * * * * *"
exec crontab -e
}
loop
#PUBS 2 INSTALL SCRIPT
#!/bin/bash
function pubs
{
clear
export scpath="$SYBASE/ASE-16_0/scripts"
cd $scpath
echo
echo "select a pub's database from below list:"
echo
echo "***************************************"
ls installpubs* | nl
echo "***************************************"
read pubname
clear
if [ ! -f $pubname ]; then
echo "********************************"
echo "the $pubname not found try again"
pubs
elif [ ! -f $pubname || -z $pubname ]; then
echo "!!!!!!!!!!!!!!!!!!!!!!!!"
echo "field cannot to be empty or invalid pubs name"
pubs
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
loop

#device operations----------------------------------------------------------------------
function xxx
{
clear
maindev
function maindev
{
clear
echo "enter server name:"
read dservname
echo
echo "login name:"
read dloginame
echo
echo "password:"
read dpassword
echo 
clear
devmenu
}
function devmenu
{
clear
echo "******************************"
echo "1.Create new device"
echo "2.create database on device"
echo "3.Resize device"
echo "4.drop device"
echo "5.Quit to main menu"
echo "******************************"
read devchoice
case $devchoice in
1) devnew ;;
2) dbase ;;
3) devresize ;;
4) dropdev ;;
5) mainmenuconnect ;;
*) echo -e "${red}Invalid choice"
echo -e "${nc}"
clear
devmenu
esac
}

function devnew
{
echo "Enter device name:"
read devname
clear
echo "Enter size:"
read devsize
cd $HOME
mkdir $devname
chmod 777 $devname
cd $HOME/$devname
path=$(pwd)
clear
echo 
echo "*********************"
echo "device name:$devname"
echo "device size:$devsize"
echo "path:$path"
echo "*********************"
sleep 03
clear
echo "creating device..."
isql64 -Usa -Stest -Ptest123 -Dmaster <<eof
disk init
name="$devname",
size="$devsize",
physname="$path/$devname.dat",
directio="true"
go
eof
sleep 02
clear 
echo "device created successfully"
sleep 03
devmenu
}
function dbase
{
clear
echo "Enter database to create:"
read dbname
echo
echo "Enter the data device name :"
read datadevname
echo
echo "Enter log device name:"
read logdevname
echo
echo " size:"
read sizedb
echo
clear
isql64 -U$dloginame -S$dservname -P$dpassword -Dmaster <<eof
create database $dbname 
on $datadevname='$sizedb'
log on $logdevname='$sizedb'
go
eof
echo
echo "database $dbname successfully created"
sleep 03
devmenu
}
function devresize
{
clear
echo "enter the device name you want to resize:"
read ddevname
echo
echo "Enter the size(eg:10M):"
read ddevsize
echo
clear
isql64 -U$dloginame -S$dservname -P$dpassword -Dmaster <<eof
disk resize
name = "$ddevname",
size ="$ddevsize"
go
eof
echo
echo "disk resize complete"
sleep 09
clear
devmenu
}
function dropdev
{
clear
echo "enter the device name u want to drop:"
read devname
echo
isql64 -U$dloginame -S$dservname -P$dpassword -Dmaster <<eof
sp_dropdevice $devname
go
eof
echo
clear
echo "Droped Successfully.."
sleep 03
clear
devmenu
}
function mainmenuconnect
{
loop
}
}

#device operations-------------------------------------------------------------------

#wish
echo 
d=$(date +%H:%M:%S)
dd=$(date +%H)
name=$(whoami)
echo "$d"
if [ $dd -lt 12 ] ;
then
printf '\e[38;5;196m Good Morning $name \n'
elif [ $dd -ge 12 ] && [ $dd -lt 20 ] ;
then
printf '\e[38;5;196m Good Afternoon $name \n'
elif [ $dd -ge 20 ] && [ $dd -lt 24 ] ;
then
printf '\e[38;5;196m Good Night $name \n'
else
printf '\e[38;5;196m Have a Nice Day $name \n'
fi

echo "*********************************"
echo "1.Build adaptive server"
echo "2.Build Back_Up server"
echo "3.Start Server"
echo "4.Crontab Schedule"
echo "5.datbase and table check"
echo "6.Device operations"
echo "7.Install Sample DataBase (Pubs)"
echo "8.EXIT"
echo "**********************************"
echo
echo "Enter a choice : "
echo

read x
#case
case $x in
1) server_build ;;
2) backup_server ;;
3) start_server ;;
4) crontab ;;
5) dbtb ;;
6) xxx ;;
7) pubs ;;
8) exit ;;
*) echo "Enter a valid choice " 
loop
esac
