#!/bin/bash

#first argument is the directory for wav files (./sounds)
. ./path.sh  || die "path.sh expected";
nj=1

rm -rf tri1/decode_dev mfcc out.txt $1/cmvn.scp $1/feats.scp $1/split1 $1/spk2utt $1/utt2spk $1/wav.scp log 

echo "File Reset Done"

./process_data.sh $1
echo "Data Process Done"

./make_mfcc.sh --nj $nj --cmd "run.pl" $1 log mfcc
./compute_cmvn_stats.sh $1 log mfcc

echo "compute_cmvn_stats done"

utils/mkgraph.sh lang_test tri1 tri1/graph

echo "graph made"

./decode.sh --skip-scoring true --nj $nj --config conf/decode.config --nj $nj --cmd "run.pl" \
    ./tri1/graph $1 ./tri1/decode_dev

echo "decoding done"

$KALDI_ROOT/src/latbin/lattice-best-path --word-symbol-table=./lang/words.txt --verbose=2 \
 "ark:gunzip -c tri1/decode_dev/lat.*.gz|" ark,t:- 2>/dev/null |  utils/int2sym.pl \
  -f 2- ./lang/words.txt >out.txt

echo "best path found"