#!/bin/bash
#this script will add the permissions for a file(you specify the filename and all permissions you want to add or remove)
#the first parameter is who: u, g, o, or a
#the second argument is for removing or adding permissions
#the third argument is for permission(r,w,x)
#the fourth argument is the file name
if [[ -z $1 ]]
then
  echo "usage: $0 <u|g|o|a> <a|r> <r|w|x> <filename>"
  exit -1
fi

case "$1" in
 'u'|'g'|'o'|'a');;
 *) echo "first parameter has to be u, g, o, or a"; exit -1;;
esac

case "$2" in
 'a'|'r');;
 *) echo "second parameter has to be a or r"; exit -1;;
esac

case "$3" in
 'r'|'w'|'x'|'rwx'|'rw'|'rx'|'wx');;
 *) echo "third parameter has to be r, w, or x"; exit -1;;
esac

if [ -d $4 ]; then
 :
elif [ -f $4 ]; then
 :
else
 echo "fourth parameter has to be a valid file or directory."
 exit -1
fi

if test $# -ne 4
then
echo Need 4 parameters
exit -1
fi

if test $2 = "r"
then
command="chmod $1-$3 $4"
fi

if test $2 = "a"
then
command="chmod $1+$3 $4"
fi
echo changing permissions with the following command: $command
$command
