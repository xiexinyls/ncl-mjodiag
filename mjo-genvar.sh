#!/bin/bash

#
#add in scripts that check if source data are available.
#

if [ -f $TARGETDIR/$TEST.plot.var.nc ]; then
  echo -n "$TARGETDIR/$TEST.plot.var.nc exists! override it(y/n)?"
  read OPT
  if [[ $OPT == "n" ]]; then
    exit
  fi
  rm -f $TARGETDIR/$TEST.plot.var.nc
fi

ncl -n $MJO_CODE/mjo-genvar.ncl
