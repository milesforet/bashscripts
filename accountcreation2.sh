#!/bin/bash

for line in $(cat names2.csv | tail -n +2)
do
	first=$(echo $line | awk '{print substr($line,1,1)}')
	lastname=$(echo $line | awk -F, '{print $2}')
	lastfive=$(echo $lastname | awk '{print substr($lastname,1,5)}')
	user=$(echo $first$lastfive)
	userid=$(echo $user | awk '{print tolower($0)}')
	group=$(echo $line | awk -F, '{print $3}')
	fieldnum=$(echo $group | awk -F: '{print NF}')

	password=$(openssl rand -base64 16 | colrm 17)
	sudo adduser --disabled-login --gecos $userid --quiet $userid
	echo "$userid:$password" | sudo chpasswd
	echo "$userid,$password" >> new-users-2.dat

	i=1
	while [ $i -le $fieldnum ]
	do
		field=$(echo $group | awk -v i="$i" -F: '{print $i}')
  		if grep -q $group /etc/group
   		then
    			echo "group exists"
   		else
   			sudo addgroup $field
  		fi
	sudo adduser $userid $field
	((i++))
	done
done
