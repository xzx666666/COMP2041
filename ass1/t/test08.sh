#!/bin/bash

rm -rf .legit
result=$(./legit.pl init)
if test "$result" != "Initialized empty legit repository in .legit"
then
    echo "initializ failed"  
fi

touch a b
./legit.pl add a b

result=$(./legit.pl commit -m "first commit")
if test "$result" != "Committed as commit 0"
then
    echo "commit test1 failed"  
fi

rm a

result=$(./legit.pl commit -m "second commit")
if test "$result" != "nothing to commit"
then
    echo "commit test2 failed"  
fi


./legit.pl add a

result=$(./legit.pl commit -m "second commit")
if test "$result" != "Committed as commit 1"
then
    echo "commit test2 failed"  
fi


./legit.pl rm --cached b

result=$(./legit.pl commit -m "second commit")
if test "$result" != "Committed as commit 2"
then
    echo "commit test2 failed"  
fi


result=$(./legit.pl rm b)
if test "$result" != "legit.pl: error: 'b' is not in the legit repository"
then
    echo "commit test2 failed"  
fi


./legit.pl add b
result=$(./legit.pl rm b)
if test "$result" != "legit.pl: error: 'b' has changes staged in the index"
then
    echo "commit test2 failed"  
fi

result=$(./legit.pl commit -m "third commit")
if test "$result" != "Committed as commit 3"
then
    echo "commit test2 failed"  
fi

./legit.pl rm b

result=$(./legit.pl commit -m "fourth commit")
if test "$result" != "Committed as commit 4"
then
    echo "commit test2 failed"  
fi

rm -rf .legit a b

