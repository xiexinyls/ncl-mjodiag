#!/bin/bash

export MJO_CODE=/disk3/xiexin/mjo_diag
export WORKDIR=/disk3/xiexin/h1

export MODELYEARST=1979
export MODELYEAREND=1985

export TEST=a
export OBS=obs
export OBSDIR=$WORKDIR/$OBS.raw.ext

export PLOTDIR=$WORKDIR/${TEST}_plot
export TARGETDIR=$WORKDIR/$TEST.raw.ext
#export VARS="OLR U850 U200"
export OBSVARS="OLR PRECT U850 U200 V850 V200"
export VARS="OLR PRECT U200 U850 V850 V200"

