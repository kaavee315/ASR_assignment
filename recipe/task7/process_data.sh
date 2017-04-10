#!/bin/bash

# the first arguement is the directory containing the wav files

present_dir=`pwd`

cd $1 || exit 1

rm -f wav.scp utt2spk spk2utt

for file in `ls *.wav`;
do 
	uttid="${file%%.*}"
	echo "$uttid" $PWD/$file >> wav.scp
	echo "$uttid" "$uttid" >> utt2spk 
	echo "$uttid" "$uttid" >> spk2utt 
done

cd $present_dir