#!/bin/bash

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi

if [ -f $TARGETDIR/$TEST.plot.meofts-obs.nc ]; then
  echo -n "$TARGETDIR/$TEST.plot.meofts-obs.nc exists! override them(y/n)?"
  read OPT
  if [[ $OPT == "n" ]]; then
    exit
  fi
  rm -f $TARGETDIR/$TEST.plot.meofts-obs.nc
fi

ncl -n $MJO_CODE/mjo-genmeof-obs.ncl
