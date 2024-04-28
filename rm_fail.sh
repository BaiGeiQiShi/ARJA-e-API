#!/bin/bash -x

while read line
do 
	status=${line##*": "}
	bugid=${line%%:*}

	if [[ $status == pass ]];then
		echo "pass"
	else
		rm -rf $bugid
	fi
done<result.txt
