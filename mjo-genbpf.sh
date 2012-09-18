#!/bin/bash

if [ $TEST = "obs" ]; then
  VARS=$OBSVARS
fi

echo "computing BPF for $VARS..."

for VAR in $VARS
do

  echo
  echo "generating BPF for $VAR..."

  if [ -f $TARGETDIR/$TEST.$VAR.anom.noanucyc.bpf.nc ]; then
    echo -n "$TARGETDIR/$TEST.$VAR.anom.noanucyc.bpf.nc exists! override it(y/n)?"
    read OPT
    if [[ $OPT == "n" ]]; then
      continue
    fi
    rm -f $TARGETDIR/$TEST.$VAR.anom.noanucyc.bpf.nc
  fi

  ncl -n var=\"$VAR\" $MJO_CODE/mjo-genbpf.ncl

done
