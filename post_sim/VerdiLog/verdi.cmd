verdiDockWidgetDisplay -dock widgetDock_WelcomePage
verdiDockWidgetHide -dock widgetDock_WelcomePage
wvCreateWindow
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/home/u103/u103061136/ICLAB/lenetoneset/post_sim/post_sim.fsdb}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/test_top"
wvGetSignalSetScope -win $_nWave2 "/test_top/lenet0/conv_top"
wvSetPosition -win $_nWave2 {("G1" 9)}
wvSetPosition -win $_nWave2 {("G1" 9)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/test_top/lenet0/conv_top/sram_write_enable_b0} \
{/test_top/lenet0/conv_top/sram_write_enable_b1} \
{/test_top/lenet0/conv_top/sram_write_enable_b2} \
{/test_top/lenet0/conv_top/sram_write_enable_b3} \
{/test_top/lenet0/conv_top/sram_write_enable_b4} \
{/test_top/lenet0/conv_top/sram_write_enable_b5} \
{/test_top/lenet0/conv_top/sram_write_enable_b6} \
{/test_top/lenet0/conv_top/sram_write_enable_b7} \
{/test_top/lenet0/conv_top/sram_write_enable_b8} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave2 {("G1" 9)}
wvGetSignalClose -win $_nWave2
wvZoom -win $_nWave2 0.000000 834920.644891
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 14)}
wvSetPosition -win $_nWave2 {("G1" 14)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/test_top/lenet0/conv_top/sram_write_enable_b0} \
{/test_top/lenet0/conv_top/sram_write_enable_b1} \
{/test_top/lenet0/conv_top/sram_write_enable_b2} \
{/test_top/lenet0/conv_top/sram_write_enable_b3} \
{/test_top/lenet0/conv_top/sram_write_enable_b4} \
{/test_top/lenet0/conv_top/sram_write_enable_b5} \
{/test_top/lenet0/conv_top/sram_write_enable_b6} \
{/test_top/lenet0/conv_top/sram_write_enable_b7} \
{/test_top/lenet0/conv_top/sram_write_enable_b8} \
{/test_top/lenet0/conv_top/sram_write_enable_d0} \
{/test_top/lenet0/conv_top/sram_write_enable_d1} \
{/test_top/lenet0/conv_top/sram_write_enable_d2} \
{/test_top/lenet0/conv_top/sram_write_enable_d3} \
{/test_top/lenet0/conv_top/sram_write_enable_d4} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 10 11 12 13 14 )} 
wvSetPosition -win $_nWave2 {("G1" 14)}
wvGetSignalClose -win $_nWave2
wvZoom -win $_nWave2 56388610.388618 64981160.543074
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoom -win $_nWave2 26314684.848020 27869116.031741
wvZoomAll -win $_nWave2
wvZoom -win $_nWave2 0.000000 3005714.321608
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoomAll -win $_nWave2
wvZoom -win $_nWave2 54436826.046901 61784127.721943
wvZoomAll -win $_nWave2
wvZoom -win $_nWave2 57442540.368509 70133334.170854
