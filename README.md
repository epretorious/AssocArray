# AssocArray
A simple shell script for working with flat database files. e.g., Using this template...

# Automation template
clear && declare -a Array=($(./AssocArray.sh -c3)) ; for ((n=0 ; n < ${#Array[@]} ; n+=2)) ; do echo -en "\n\e[33;1m${Array[$n+1]}\e[0m (\e[33;1m${Array[$n]}\e[0m): " ; ping -c 1 ${Array[$n]} &> /dev/null ; if [[ $? == 0 ]] ; then echo -e "\e[32mPASS\e[0m\n" ; # <<<INSERT COMMAND HERE>>> ; if [[ $? != 0 ]] ; then echo -e "\e[91;7mFAIL\e[0m" ; fi ; else echo -e "\e[31;1mFAIL\e[0m" ; fi ; done

...it becomes a simple affair to associate the IP address of the system with its System ID and to perform many simple configuration tasks.

# ssh-copy-id
ssh-copy-id -i .ssh/id_rsa UserName@${Array[$n]}

# sudoers
ssh -t UserName@${Array[$n]} "sudo sed -i 's/^# %wheel/%wheel/' /etc/sudoers"

# hostname
ssh -t UserName@${Array[$n]} "echo aia-UserName-spr-${Array[$n+1]} | sudo tee /etc/hostname"
ssh -t UserName@${Array[$n]} "cat /etc/hostname"

# hosts
ssh -t UserName@${Array[$n]} "sudo sed -i 's/XXXXX/${Array[$n+1]}/g' /etc/hosts"

# partitions
ssh -t UserName@${Array[$n]} "lsblk /dev/nvme[01]n1"
ssh -t UserName@${Array[$n]} "sudo fdisk -l /dev/nvme[01]n1"
ssh -t UserName@${Array[$n]} "sudo sfdisk --delete /dev/nvme0n1"
