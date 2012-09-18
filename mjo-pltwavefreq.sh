#!/bin/bash

VARS="OLR PRECT U200 U850"

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi

for VAR in $VARS
do

  if [ ! -f $TARGETDIR/$TEST.$VAR.anom.noanucyc.nc ]; then
    echo "$TARGETDIR/$TEST.$VAR.anom.noanucyc.nc does not exist!"
    echo "You need to run mjo-gen.anom.noanucyc.sh to generate it!"
    echo "exitting..."
    exit
  fi

  echo
  echo "plotting $VAR..."
  ncl -n var=\"$VAR\" $MJO_CODE/mjo-pltwavefreq.ncl

done
