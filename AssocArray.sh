#!/bin/bash
# Eric Pretorious <ericx.pretorious@intel.com> (May, 2022)
#
# Read an indexed array and convert it to an associative array in order to iterate over its values
#   https://stackoverflow.com/questions/25251353/bash4-read-file-into-associative-array/25251400#25251400
#
# Examples
#  To create a list of IP addresses for use in a CLI command:
#  declare -a Array=($(./AssocArray.sh -c1)) ; for IP in ${Array[@]} ; do echo "Do something with $IP" ; done
#
#  To create a list of System ID's for use in a CLI command:
#  declare -a Array=($(./AssocArray.sh -c2)) ; for SysID in ${Array[@]} ; do echo "Do something with $SysID" ; done
#
#  To create a list of IP addresses *with* assocated System ID's for use in a CLI command:
#  declare -a Array=($(./AssocArray.sh -c3)) ; for ((n=0 ; n < ${#Array[@]} ; n+=2)) ; do printf "System ID %-6s has IP address %-15s\n" ${Array[$n+1]} ${Array[$n]} ; done
#
#  To...
#   1) verify that a remote system is reachable /by IP address/;
#  ...and, if the remote system _is_ reachable:
#   2) perform an operation using remote-SSH command execution;
#   3) report if the operation failed...
#
#  declare -a Array=($(./AssocArray.sh -c3)) ; for ((n=0 ; n < ${#Array[@]} ; n+=2)) ; do echo -en "\e[33m${Array[$n+1]}\e[0m (\e[33m${Array[$n]}\e[0m): " ; ping -c 1 ${Array[$n]} &> /dev/null ; if [[ $? == 0 ]] ; then echo -e "\e[32mPASS\e[0m" ; ssh-copy-id -i .ssh/id_rsa  UserName@${Array[$n]} ; if [[ $? != 0 ]] ; then echo -e "\e[91;7mFAIL\e[0m" ; fi ; else echo -e "\e[31mFAIL\e[0m" ; fi ; done

if [[ $# == 0 ]] ; then exit ; fi ;

while getopts "c:vd" Options ; do
        case ${Options} in
                c) Column=${OPTARG} ;;
                v) Verbose=1 ;;
                d) Dump=1 ;;
        esac ;
done ;

declare -A Hash ;
declare -a Records ;

readarray -t Records < AssocArray.txt ;

if [[ $Dump ]] ; then
        echo -e "\e[4m System ID  IP Address   \e[0m" ;
        declare -a List=($(sed 's/=/ /' ./AssocArray.txt | grep -v ^$ )) ; for ((n=0 ; n < ${#List[@]} ; n+=2)) ; do printf "  %6s    %11s \n" ${List[$n+1]} ${List[$n]} ; done ;
        exit ;
fi;

if [[ ${Verbose} ]] ; then echo "Column: ${Column}" ; fi ;

for Record in "${Records[@]}" ; do
        if [[ ${Record} == '' ]] ; then continue ; fi ;
        key=${Record%%=*} ;
        value=${Record#*=} ;
        Hash[$key]=$value ;
done ;

for key in ${!Hash[@]} ; do
        if [[ ${Column} == 1 ]] ; then echo -n "${key} " ; fi ;
        if [[ ${Column} == 2 ]] ; then echo -n "${Hash[$key]} " ; fi ;
        if [[ ${Column} == 3 ]] ; then echo -n "$key ${Hash[$key]} " ; fi ;
done ;

echo ;
