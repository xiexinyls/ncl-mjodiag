#!/bin/bash

if [ ! -d $PLOTDIR ]; then
  mkdir -p $PLOTDIR
fi
ncl $MJO_CODE/mjo-pltvar.ncl
