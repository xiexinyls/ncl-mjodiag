#!/bin/bash

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi

if [ -f $TARGETDIR/$TEST.plot.crsspec.nc ]; then
  echo -n "$TARGETDIR/$TEST.plot.crsspec.nc exists! override it(y/n)?"
  read OPT
  if [[ $OPT == "n" ]]; then
    exit
  fi
  rm -f $TARGETDIR/$TEST.plot.crsspec.nc
fi

ncl -n $MJO_CODE/mjo-gencrsspec.ncl

