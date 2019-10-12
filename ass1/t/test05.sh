#!/bin/bash

rm -rf .legit
result=$(./legit.pl init)
if test "$result" != "Initialized empty legit repository in .legit"
then
    echo "initializ failed"  
fi

echo 1 >a
echo 2 >b
./legit.pl add a b

result=$(./legit.pl commit -m "first commit")
if test "$result" != "Committed as commit 0"
then
    echo "commit test1 failed"  
fi

echo 3 >c
echo 4 >d

./legit.pl add c d
./legit.pl rm --cached  a c

result=$(./legit.pl commit -m "second commit")
if test "$result" != "Committed as commit 1"
then
    echo "commit test2 failed"  
fi

result=$(./legit.pl show 0:a)
if test "$result" != "1"
then
    echo "commit test2 failed"  
fi


result=$(./legit.pl show 1:a)
if test "$result" != "legit.pl: error: 'a' not found in commit 1"
then
    echo "commit test2 failed"  
fi
result=$(./legit.pl show :a)
if test "$result" != "legit.pl: error: 'a' not found in index"
then
    echo "commit test2 failed"  
fi


rm -rf .legit a b c d

