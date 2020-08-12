#!/bin/bash

## check for user input of IP address
if [ -z "$1" ]
then
        echo "Usage: ./recon.sh <IP>"
        exit 1
fi


## scan host with nmap
printf "\n----- NMAP -----\n\n" > results
echo "Running Nmap..."
nmap -sC -sV -p- $1 | tail -n +5 | head -n -3 >> results


## enumerate http
while read line
do
        if [[ $line == *open* ]] && [[ $line == *http* ]]
        then
                echo "Running Gobuster..."
                gobuster dir -w common-dirs.txt -qz -u $1 > temp1

        echo "Running WhatWeb..."
        whatweb $1 -v > temp2
        fi
done < results


## display results
if [ -e temp1 ]
then
        printf "\n----- DIRS -----\n\n" >> results
        cat temp1 >> results
        rm temp1
fi

if [ -e temp2 ]
then
    printf "\n----- WEB -----\n\n" >> results
        cat temp2 >> results
        rm temp2
fi

echo results
cat results > /home/taj702/auto-recon-data/results.txt




