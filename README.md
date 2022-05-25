# AssocArray
A simple shell script for working with flat database files. e.g., Using this template...

# Automation template
```clear && declare -a Array=($(./AssocArray.sh -c3)) ; for ((n=0 ; n < ${#Array[@]} ; n+=2)) ; do echo -en "\n\e[33;1m${Array[$n+1]}\e[0m (\e[33;1m${Array[$n]}\e[0m): " ; ping -c 1 ${Array[$n]} &> /dev/null ; if [[ $? == 0 ]] ; then echo -e "\e[32mPASS\e[0m\n" ; # <<<INSERT COMMAND HERE>>> ; if [[ $? != 0 ]] ; then echo -e "\e[91;7mFAIL\e[0m" ; fi ; else echo -e "\e[31;1mFAIL\e[0m" ; fi ; done```

...it becomes a simple affair to associate the IP address of the system with its System ID and to perform many simple configuration tasks.

# ssh-copy-id
```ssh-copy-id -i .ssh/id_rsa UserName@${Array[$n]}```

# sudoers
```ssh -t UserName@${Array[$n]} "sudo sed -i 's/^# %wheel/%wheel/' /etc/sudoers"```

# hostname
```ssh -t UserName@${Array[$n]} "echo aia-UserName-spr-${Array[$n+1]} | sudo tee /etc/hostname"```
```ssh -t UserName@${Array[$n]} "cat /etc/hostname"```

# hosts
```ssh -t UserName@${Array[$n]} "sudo sed -i 's/XXXXX/${Array[$n+1]}/g' /etc/hosts"```

# partitions
```ssh -t UserName@${Array[$n]} "lsblk /dev/nvme[01]n1"```
```ssh -t UserName@${Array[$n]} "sudo fdisk -l /dev/nvme[01]n1"```
```ssh -t UserName@${Array[$n]} "sudo sfdisk --delete /dev/nvme0n1"```

# Examples
# 0.  Generate a list of system IP addresses:
```ericprex@localhost:~$ ./AssocArray.sh -c 1 | sed 's/ /\n/g'
10.0.0.8
10.0.0.77
10.0.0.195
10.0.0.40
10.0.0.45
10.0.0.44
10.0.0.25
10.0.0.27
10.0.0.21
10.0.0.22
10.0.0.29
10.0.0.28
10.0.0.32
10.0.0.33
10.0.0.30
10.0.0.31
10.0.0.36
10.0.0.37
10.0.0.34
10.0.0.35
10.0.0.39
10.0.0.208```

# 1.  Generate a list of System ID's:
```ericprex@localhost:~$ ./AssocArray.sh -c 2 | sed 's/ /\n/g'
000866
000621
000622
000862
000864
000861
000849
000863
000625
000626
000857
000865
000851
000856
000854
000847
000853
000852
000855
000859
000850
000848```

# 2. Generate a list of System ID's along with the corresponding IP addresses:
```ericprex@localhost:~$ ./AssocArray.sh -c 3 | sed 's/ 10/\n10/g' | awk '{ print "System ID " $2 " has IP address " $1 }'
System ID 000866 has IP address 10.0.0.8
System ID 000621 has IP address 10.0.0.77
System ID 000622 has IP address 10.0.0.195
System ID 000862 has IP address 10.0.0.40
System ID 000864 has IP address 10.0.0.45
System ID 000861 has IP address 10.0.0.44
System ID 000849 has IP address 10.0.0.25
System ID 000863 has IP address 10.0.0.27
System ID 000625 has IP address 10.0.0.21
System ID 000626 has IP address 10.0.0.22
System ID 000857 has IP address 10.0.0.29
System ID 000865 has IP address 10.0.0.28
System ID 000851 has IP address 10.0.0.32
System ID 000856 has IP address 10.0.0.33
System ID 000854 has IP address 10.0.0.30
System ID 000847 has IP address 10.0.0.31
System ID 000853 has IP address 10.0.0.36
System ID 000852 has IP address 10.0.0.37
System ID 000855 has IP address 10.0.0.34
System ID 000859 has IP address 10.0.0.35
System ID 000850 has IP address 10.0.0.39
System ID 000848 has IP address 10.0.0.208```
