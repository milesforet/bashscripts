#!/bin/bash
#script that takes a CSV file of first and last names.
#skips the first line, which only says first and last name
#creates a userid from the first 6 characters of the last name concatenated with the first 2 characters of the first name
#Uadduser command creates the user
#a random password is generated and given to the user.
#the username and password is stored in a new file


for line in $(cat names.csv | tail -n +2)
do
	first=$(echo $line | awk '{print substr($line,1,2)}')
	lastname=$(echo $line | awk -F, '{print $2}')
	lastsix=$(echo $lastname | awk '{print substr($lastname,1,6)}')
	user=$(echo $first$lastsix)
	userid=$(echo $user | awk '{print tolower($0)}')
	password=$(openssl rand -base64 16 | colrm 17)
	sudo adduser --disabled-login --gecos $userid --quiet $userid
	echo "$userid:$password" | sudo chpasswd
	echo "$userid,$password" >> new-users.dat
done
