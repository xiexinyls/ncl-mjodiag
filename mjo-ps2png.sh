#!/bin/bash

OLDDIR=$(pwd)

if [ ! -d $PLOTDIR/ps ]; then
  mkdir -p $PLOTDIR/ps
fi
if [ ! -d $PLOTDIR/png ]; then
  mkdir -p $PLOTDIR/png
fi
if [ ! -d $PLOTDIR/eps ]; then
  mkdir -p $PLOTDIR/eps
fi

rm -f $PLOTDIR/png/*
rm -f $PLOTDIR/eps/*

cd $PLOTDIR/ps
psfiles=$(ls *.ps)
cd $OLDDIR

for file in $psfiles
do

echo "converting $file to $file.eps..."
ps2epsi $PLOTDIR/ps/$file $PLOTDIR/eps/$file.eps
echo "converting $file.eps to $file.png..."
convert -trim -density 500 -geometry 500 $PLOTDIR/eps/$file.eps $PLOTDIR/png/$file.png

done
