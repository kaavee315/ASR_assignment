#!/bin/bash
. ./path.sh  || die "path.sh expected";

nj=1

rm -rf alignments split1 utterance.ctm cmvn.scp feats.scp text word0* log mfcc

mv $1 ./utt.wav
echo -n "utt " >text
cat $2 >>text

./steps/make_mfcc.sh --nj $nj --cmd "run.pl" . log mfcc
./steps/compute_cmvn_stats.sh . log mfcc

./steps/align_si.sh --nj $nj --cmd "run.pl" \
     ./ ./data/lang ./exp/mono ./alignments

$KALDI_ROOT/src/bin/ali-to-phones --ctm-output ./alignments/final.mdl ark:"gunzip -c alignments/ali.*.gz|" utterance.ctm

./phone-to-wav.sh ./utt.wav utterance.ctm ./data/lang/phones/word_boundary.int	