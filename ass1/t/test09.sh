#!/bin/bash

rm -rf .legit
result=$(./legit.pl init)
if test "$result" != "Initialized empty legit repository in .legit"
then
    echo "initializ failed"  
fi


echo 1 >a

result=$(./legit.pl commit -m "first commit")
if test "$result" != "Committed as commit 0"
then
    echo "commit test1 failed"  
fi

touch a
./legit.pl add a
result=$(./legit.pl commit -m "nothing to commit")
if test "$result" != "Committed as commit 1"
then
    echo "commit test2 failed"  
fi

rm -rf .legit a 

