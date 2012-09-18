#!/bin/bash

SEASONS="allseason summer winter"

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi

if [ ! -f $TARGETDIR/$TEST.plot.lag.nc ]; then
  echo "$TARGETDIR/$TEST.plot.lag.nc does not exist!"
  echo "You need to run mjo-genlag.sh to generate it!"
  echo "exitting..."
  exit
fi

for SEASON in $SEASONS
do
  ncl -n season=\"$SEASON\" $MJO_CODE/mjo-pltlag.ncl
done
