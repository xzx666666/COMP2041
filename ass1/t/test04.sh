#!/bin/bash

rm -rf .legit
result=$(./legit.pl init)
if test "$result" != "Initialized empty legit repository in .legit"
then
    echo "initializ failed"  
fi

echo 1 >a
echo 2 >b
echo 3 >c
./legit.pl add a b c
result=$(./legit.pl commit -m "first commit")
if test "$result" != "Committed as commit 0"
then
    echo "commit test1 failed"  
fi

echo 4 >>a
echo 5 >>b
echo 6 >>c
echo 7 >d
echo 8 >e


./legit.pl add b c d e
echo 9 >b
echo 0 >d
./legit.pl rm --cached a c
./legit.pl rm --force --cached b
./legit.pl rm --cached --force e
./legit.pl rm --force d


rm -rf .legit  

