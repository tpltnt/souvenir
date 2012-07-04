#!/usr/bin/env zsh

# wrapper script to read urls from a textfile line by line
while read urlstosave
do
    ./souvenir.sh $urltosave
done < $1