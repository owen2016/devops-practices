#!/bin/bash#!/bin/bash
# SCRIPT:  fibo_iterative.sh
# USAGE:   fibo_iterative.sh [Number]
# PURPOSE: Generate Fibonacci sequence.
#                         \\\\ ////
#                         \\ - - //
#                            @ @
#                    ---oOOo-( )-oOOo---
#
#####################################################################
#                     Script Starts Here                            #
#####################################################################

if [ $# -eq 1 ]
then
    Num=$1
else
    echo -n "Enter a Number :"
    read Num
fi

f1=0
f2=1

echo "The Fibonacci sequences for the number $Num is : "

for (( i=0;i<=Num;i++ ))
do
     echo -n "$f1 "
     fn=$((f1+f2))
     f1=$f2
     f2=$fn
done

echo
