#!/bin/bash

year=$MODELYEARST
yearend=$MODELYEAREND

SOURCEDIR=$WORKDIR/$TEST.raw
OUTDIR=$WORKDIR/$TEST.raw.ext

if [ ! -d $SOURCEDIR ]; then
  echo "Source data $SOURCEDIR does not exist! exit..."
  exit
fi

if [ ! -d $OUTDIR ]; then
  echo "Output data $OUTDIR does not exist! create one..."
  mkdir -p $OUTDIR
fi

while [ $year -le $yearend ]
do
  echo Combining $year ...
  cdo mergetime $SOURCEDIR/*h1*$year* $OUTDIR/$TEST.byyear.$year.nc 1> /dev/null 2>&1
  year=$(($year+1))
done

