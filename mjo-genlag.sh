#!/bin/bash

if [ -f $TARGETDIR/$TEST.plot.lag.nc ]; then
  echo -n "$TARGETDIR/$TEST.plot.lag.nc exists! override it(y/n)?"
  read OPT
  if [[ $OPT == "n" ]]; then
    exit
  fi
    rm -f $TARGETDIR/$TEST.plot.lag.nc
fi

ncl -n $MJO_CODE/mjo-genlag.ncl
