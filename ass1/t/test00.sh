#!/bin/bash

rm -rf .legit
for i in 1 2 3 4 5 6
do
    touch $i
    echo "line$i" > $i
    
done

echo "legit.pl init"
echo `./legit.pl init`
echo "legit add 1 2 3"
echo `./legit.pl add 1 2 3`
echo "legit.pl commit -m commit0 "
echo `./legit.pl commit -m commit0`
echo "legit.pl commit -m commit1"
echo `./legit.pl commit -m commit1`
echo "legit.pl log"
echo `./legit.pl log`

for i in 1 2 3
do
    echo "legit.pl show 0:$i"
    echo `./legit.pl show 0:$i`
    echo "legit.pl show :$i"
    echo `./legit.pl show :$i`
    
done



for i in `ls`
do
   if [[ $i =~ ^[0-9]$ ]]
    then
        rm $i
        
   fi
done
rm -rf .legit

