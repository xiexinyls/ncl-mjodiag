#!/bin/bash

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi

if [ -f $OBSDIR/$OBS.plot.meof.nc ]; then
  echo -n "$OBSDIR/$OBS.plot.meof.nc or $OBS.plot.meofts.nc exists! override them(y/n)?"
  read OPT
  if [[ $OPT == "n" ]]; then
    exit
  fi
  rm -f $OBSDIR/$OBS.plot.meof.nc
  rm -f $OBSDIR/$OBS.plot.meofts.nc
fi

ncl -n $MJO_CODE/mjo-genobsmeof.ncl
