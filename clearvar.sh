#!/bin/bash

for VAR in $VARS
do

if [ ! $TEST = "obs" ]; then
  echo "$VAR for model case, deleting..."
  rm $TARGETDIR/$TEST.$VAR.nc
else
  echo "$VAR for obs case, no deleting..."
fi

done
