#!/bin/bash
#script that creates accounts and groups
#skips the first line, which is the header that defines the fields(firstname,lastname,group)
#the userid is the first character of the first name concatenated with the first 5 characters of the last name.
#a random password is generated for the user
#the accounts are created and added to the groups according the the CSV file
#the username and passwords are saved in a file


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
