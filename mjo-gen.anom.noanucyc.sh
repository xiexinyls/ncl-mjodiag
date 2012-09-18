#!/bin/bash

if [ $TEST = "obs" ]; then
  VARS=$OBSVARS
fi

TARGETDIR=$WORKDIR/$TEST.raw.ext

for VAR in $VARS
do
  echo
  echo "computing anomaly for $VAR..."

  if [ -f $TARGETDIR/$TEST.$VAR.anom.noanucyc.nc ]; then
    echo -n "$TARGETDIR/$TEST.$VAR.anom.noanucyc.nc exists! override it(y/n)?"
    read OPT
    if [[ $OPT == "n" ]]; then
      continue
    fi
    rm -f $TARGETDIR/$TEST.$VAR.anom.noanucyc.nc
  fi

  ncl -n var=\"$VAR\" $MJO_CODE/mjo-gen.anom.noanucyc.ncl

done
