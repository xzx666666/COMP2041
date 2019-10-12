#!/bin/bash

rm -rf .legit

result=$(./legit.pl init)
if test "$result" != "Initialized empty legit repository in .legit"
then
    echo "initializ failed"  
fi

echo line 1 >a

./legit.pl add a

result=$(./legit.pl commit -m "first commit")
if test "$result" != "Committed as commit 0"
then
    echo "commit test1 failed"  
fi
echo line 2 >>a
echo world >b
./legit.pl add b

result=$(./legit.pl commit -m "second commit")
if test "$result" != "Committed as commit 1"
then
    echo "commit test1 failed"  
fi

rm -rf .legit a b

