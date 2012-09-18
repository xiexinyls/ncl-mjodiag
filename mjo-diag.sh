#!/bin/bash

#******************************************************
# The main script to drive MJO diagnostics.
# BY Xin XIE.
#******************************************************


#******************************************************
# setting the MJO diagnostics code path MJO_CODE here
# setting the working dir WORKDIR
# which should contain TEST.raw dir 
#******************************************************
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


echo "Preprocessing MJO data..."
. $MJO_CODE/mjo-raw2year.sh
. $MJO_CODE/mjo-year2var.sh

echo "Generating anomaly..."
. $MJO_CODE/mjo-gen.anom.noanucyc.sh
. $MJO_CODE/mjo-genbpf.sh

echo "Generating variability and plotting.."
. $MJO_CODE/mjo-genvar.sh
. $MJO_CODE/mjo-pltvar.sh

echo "Generating MJO propogating plots..."
. $MJO_CODE/mjo-genlag.sh
. $MJO_CODE/mjo-pltlag.sh

echo "Generating wave-number spectra plots..."
. $MJO_CODE/mjo-pltwavefreq.sh

