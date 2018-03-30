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
export srv=/opt/*/ASE*/init/sample_resource_files
cd $srv
clear
echo "Enter the name of the sever:"
read srv_name
echo
echo "Enter Password for the server($srv_name):"
read password
echo
echo "enter the host name(eg:localhost):"
read host_name
echo
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
export srv=/opt/*/ASE*/init/sample_resource_files
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
echo
echo "Enter Existing Adaptive Server Name:"
read srve_name
echo
echo "enter the host name(eg:localhost):"
read host_name
echo
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


 
#function start here
export SERVER=/opt/*/ASE*/install
function start_server
{
cd $SERVER 
echo "select a server to start:"
ls RUN_* --format single-column
read NAME
if [ "$NAME" = " " ]; then
echo "server name cannot to be empty!! press s and re try"
return 1
else
echo " $NAME server starting... "
sleep 04
fi
 startserver -f $NAME
}

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
sleep 05
exec crontab -e
}

#menu
echo  
echo "***************************"
echo "1.Build adaptive server"
echo "2.Build Back_Up server"
echo "3.Start Server"
echo "4.Crontab Schedule"
echo "5.Database and Table check"
echo "6.Install Sample DataBase (Pubs)"
echo "press \"q\" to quit"
echo "***************************"
echo
echo "Enter a choice : "
echo

while [ x != "q" ]
do
read x
#case
case $x in
1) server_build ;;
2) backup_server ;;
3) start_server ;;
4) crontab ;;
q) exit ;;
* ) echo "enter "choice" or "q" "
esac
done 
