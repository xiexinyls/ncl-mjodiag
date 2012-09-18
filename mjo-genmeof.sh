#!/bin/bash

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi

if [ -f $TARGETDIR/$TEST.plot.meof.nc ]; then
  echo -n "$TARGETDIR/$TEST.plot.meof.nc or $TEST.plot.meofts.nc exists! override them(y/n)?"
  read OPT
  if [[ $OPT == "n" ]]; then
    exit
  fi
  rm -f $TARGETDIR/$TEST.plot.meof.nc
  rm -f $TARGETDIR/$TEST.plot.meofts.nc
fi

ncl -n $MJO_CODE/mjo-genmeof.ncl
