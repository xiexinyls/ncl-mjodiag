
  if [ -f $TARGETDIR/$TEST.$var.nc ]; then
    echo -n "$TEST.$var.nc exists! override it?(y/n)"
    read OPT
    if [[ $OPT == "n" ]]; then
      continue
    fi
    rm -f $TARGETDIR/$TEST.$var.nc
  fi


