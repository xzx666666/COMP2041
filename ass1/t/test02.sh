#!/bin/bash

rm -rf .legit
result=$(./legit.pl init)
if test "$result" != "Initialized empty legit repository in .legit"
then
    echo "initializ failed"  
fi
echo line 1 >a
echo hello world >b
echo line 1 >c
echo hello world >d
echo line 1 >e
echo hello world >f

./legit.pl add a b c d e f

result=$(./legit.pl commit -m "first commit")
if test "$result" != "Committed as commit 0"
then
    echo "commit test1 failed"  
fi

echo line 2 >>a
echo line 3 >>b
echo line 4 >>c
echo line 5 >>d
echo line 6 >>e
./legit.pl add a b c d e 

result=$(./legit.pl commit -m "second commit")
if test "$result" != "Committed as commit 1"
then
    echo "commit test2 failed"  
fi

./legit.pl rm --cached a


result=$(./legit.pl commit -m "three commit")
if test "$result" != "Committed as commit 2"
then
    echo "commit test3 failed"  
fi

result=$(./legit.pl commit -m " fourth commit")
if test "$result" != "nothing to commit"
then
    echo " commit test4 failed"  
fi
./legit.pl add a

result=$(./legit.pl commit -m " fourth commit")
if test "$result" != "Committed as commit 3"
then
    echo " commit test4 failed"  
fi

rm -rf .legit a b c d e f

