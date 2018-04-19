#!/bin/bash

cat .gitmodules | grep path | cut -f 2 -d "=" | while read line; do echo $line; cd $line; git checkout master; git pull;cd ..; done
