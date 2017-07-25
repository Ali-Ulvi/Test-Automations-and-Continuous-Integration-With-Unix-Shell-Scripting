#! /usr/bin/bash

rm slim2
for i in $(cat no)

do

sed "/11880/s|11880|0$i|" slim > tmp

cat tmp >> slim2

done

