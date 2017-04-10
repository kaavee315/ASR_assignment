#!/bin/bash

# first arguement is wav file
# second arguement is ctm file
# third arguement is word_boundary.int 

wav=$1
ctm=$2
wbound=$3

uttid="${wav##*/}"
uttid="${uttid%%.*}"
echo "uttid is $uttid"
cat "$ctm" | grep "$uttid" | awk '{print $3,$4,$5}' > tmp
python break_word.py "$wbound" tmp > tmp2

wordNum=0
while read line
do
	start=$(echo $line | awk '{print $1}')
	end=$(echo $line | awk '{print $2}')
	wordNum=$((wordNum+1))
	printf -v filenum "%03d" $wordNum
	sox "$wav" word"$filenum".wav trim "$start" "$end"
done < tmp2

rm tmp tmp2