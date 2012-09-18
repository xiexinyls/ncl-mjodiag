
load "$MJO_CODE/utils/load.ncl"

begin

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")

infile = addfile(TARGETDIR+"/"+TEST+".plot.crsspec.nc", "r")

stc = infile->stc

opt = True
opt@txString = "Coherence squared(colors) and phase lag(vectors) ("+TEST+")"
mjo_cross_plot(stc, PLOTDIR, "pdf", TEST+"-crsspec", opt)

opt@pltProb = 0.925
np = ind( stc@prob .eq. opt@pltProb)
opt@txString = "prob="+opt@pltProb+" ==> "+stc@prob_coh2(np)
mjo_cross_plot( stc, PLOTDIR, "pdf", TEST+"-crsspec.prob", opt)
delete(opt@pltProb)

;opt@pltPhase = False
;opt@txString = "No Phases Plotted"
;mjo_cross_plot( stc, PLOTDIR, "pdf", TEST+"-crsspec.nophase", opt)

end

