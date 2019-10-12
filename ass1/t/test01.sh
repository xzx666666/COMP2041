#!/bin/bash

rm -rf .legit
result=$(./legit.pl init)
if test "$result" != "Initialized empty legit repository in .legit"
then
    echo "initializ failed"  
fi
echo line 1 >a
echo hello world >b
./legit.pl add a b

result=$(./legit.pl commit -m "first commit")
if test "$result" != "Committed as commit 0"
then
    echo "commit test1 failed"  
fi

echo line 2 >>a
./legit.pl add a

result=$(./legit.pl commit -m "second commit")
if test "$result" != "Committed as commit 1"
then
    echo "$result commit test2 failed"  
fi

echo line 3 >>a
./legit.pl add a
echo line 4 >>a
result=$(./legit.pl show 0:a)
if test "$result" != "line 1"
then
    echo "show test1 failed"  
fi

result=$(./legit.pl show 0:b)
if test "$result" != "hello world"
then
    echo "show test2 failed"  
fi

result=$(./legit.pl show 1:b)
if test "$result" != "hello world"
then
    echo "show test3 failed"  
fi

rm -rf .legit a

