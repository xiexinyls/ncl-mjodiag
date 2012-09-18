#!/bin/bash

TARGETDIR=$WORKDIR/$TEST.raw.ext
vars="PRECT PMID FLUT U850 U200 V850 V200"

if [ ! -d $TARGETDIR ]; then
  echo "Source data $TARGETDIR does not exist! exit..."
  exit
fi

if [ ! -f $TARGETDIR/$TEST.MJO.$MODELYEARST-$MODELYEAREND.nc ]; then
  echo "generating $TEST.MJO.$MODELYEARST-$MODELYEAREND.nc..."
  cdo mergetime $TARGETDIR/*byyear* $TARGETDIR/$TEST.MJO.$MODELYEARST-${MODELYEAREND}_tmp.nc
  cdo sellonlatbox,0,360,-35,35 $TARGETDIR/$TEST.MJO.$MODELYEARST-${MODELYEAREND}_tmp.nc $TARGETDIR/$TEST.MJO.$MODELYEARST-${MODELYEAREND}.nc
else
  echo "$TEST.MJO.$MODELYEARST-$MODELYEAREND.nc exists! skipping..."
fi


for var in $vars
do

  if [ -f $TARGETDIR/$TEST.$var.nc ]; then
    echo -n "$TEST.$var.nc exists! override it?(y/n)"
    read OPT
    if [[ $OPT == "n" ]]; then
      continue
    fi
    rm -f $TARGETDIR/$TEST.$var.nc
  fi

  echo "generating $TEST.$var.nc..."
  cdo selname,$var $TARGETDIR/$TEST.MJO.$MODELYEARST-$MODELYEAREND.nc $TARGETDIR/$TEST.$var.nc

  if [ $var = "PRECT" -a $TEST != "obs" ]; then
    cdo mulc,86400000 $TARGETDIR/$TEST.$var.nc $TARGETDIR/temp_$var.nc
    ncatted -a units,$var,o,c,"mm/day" $TARGETDIR/temp_$var.nc
    mv $TARGETDIR/temp_$var.nc $TARGETDIR/$TEST.$var.nc
  fi

  if [ $var = "FLUT" ]; then
    ncrename -v FLUT,OLR $TARGETDIR/$TEST.$var.nc $TARGETDIR/$TEST.OLR.nc
    rm -f $TARGETDIR/$TEST.$var.nc
  fi

done

#echo "Deleting byyear files..."
#rm $TARGETDIR/*byyear*

