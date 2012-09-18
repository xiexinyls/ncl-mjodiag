#!/bin/bash

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi

ncl -n $MJO_CODE/mjo-pltcrsspec.ncl
