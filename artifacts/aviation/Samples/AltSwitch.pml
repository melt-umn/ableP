 mtype = { Unknown,Above,Below };
 mtype = { High,Med,Low };
 chan startup = [ 0 ] of  { int, int } ;
 chan monitor = [ 0 ] of  { mtype, mtype } ;
 int trouble_t = -1;
 int above_t = -1;
 proctype monitorStatus () 
{
     
};
active proctype determineStatus () 
{
         int altitude;
         int threshold;
         int hyst;
         mtype altQuality;
         mtype altStatus = Unknown;
    startup?threshold , hyst;
    run monitorStatus();
    check:    if
    ::    altitude=1000
    ::    altitude=1100
    ::    altitude=1200
    ::    altitude=1300
    ::    altitude=1400
    ::    altitude=1500
    ::    altitude=1600
    ::    altitude=1700
    ::    altitude=1800
    ::    altitude=1900
    ::    altitude=2000
    ::    altitude=2100
    ::    altitude=2200
    ::    altitude=2300
    ::    altitude=2400
    ::    altitude=2500
    ::    altitude=2600
    ::    altitude=2700
    ::    altitude=2800
    ::    altitude=2900
    ::    altitude=3000
    ::    altitude=3100
    ::    altitude=3200
    ::    altitude=3300
    ::    altitude=3400
    ::    altitude=3500
    ::    altitude=3600
    ::    altitude=3700
    ::    altitude=3800
    ::    altitude=3900
    ::    altitude=4000
    ::    altitude=4100
    ::    altitude=4200
    ::    altitude=4300
    ::    altitude=4400
    ::    altitude=4500
    ::    altitude=4600
    ::    altitude=4700
    ::    altitude=4800
    ::    altitude=4900
    ::    altitude=5000
    ::    altitude=5100
    ::    altitude=5200
    ::    altitude=5300
    ::    altitude=5400
    ::    altitude=5500
    ::    altitude=5600
    ::    altitude=5700
    ::    altitude=5800
    ::    altitude=5900
    ::    altitude=6000
    ::    altitude=6100
    ::    altitude=6200
    ::    altitude=6300
    ::    altitude=6400
    ::    altitude=6500
    ::    altitude=6600
    ::    altitude=6700
    ::    altitude=6800
    ::    altitude=6900
    ::    altitude=7000
    ::    altitude=7100
    ::    altitude=7200
    ::    altitude=7300
    ::    altitude=7400
    ::    altitude=7500
    ::    altitude=7600
    ::    altitude=7700
    ::    altitude=7800
    ::    altitude=7900
    ::    altitude=8000
    ::    altitude=8100
    ::    altitude=8200
    ::    altitude=8300
    ::    altitude=8400
    ::    altitude=8500
    ::    altitude=8600
    ::    altitude=8700
    ::    altitude=8800
    ::    altitude=8900
    ::    altitude=9000
    ::    altitude=9100
    ::    altitude=9200
    ::    altitude=9300
    ::    altitude=9400
    ::    altitude=9500
    ::    altitude=9600
    ::    altitude=9700
    ::    altitude=9800
    ::    altitude=9900
    ::    altitude=10000
    ::    1
    fi; ;
    if
    ::    altQuality=High
    ::    altQuality=Med
    ::    altQuality=Low
    fi; ;
    if
    ::    (((altStatus == Unknown) && ((altQuality == High) && ((altitude > threshold) && true))) || (true && ((altQuality == High) && ((altitude > threshold) && (altitude > (threshold + hyst))))));
    altStatus=Above
    ::    ((altQuality == High) && (!(altitude > threshold)));
    altStatus=Below
    ::    else; ;
    altStatus=((altQuality == High)->Unknown:altStatus)
    fi; ;
    if
    ::    (altStatus == Above);
    goto above;
    ::    ((altStatus == Below) || (altStatus == Unknown));
    goto trouble;
    fi; ;
    above:    above_t=1;
    (above_t == 0);
    goto check; ;
    trouble:    monitor!altStatus , altitude;
    trouble_t=1;
    (trouble_t == 0);
    goto check; 
};
 proctype Timers () 
{
    do
    ::    timeout;
    atomic
{
     if
    ::    (trouble_t >= 0);
    trouble_t=(trouble_t - 1)
    ::    else;
    fi; ;
    if
    ::    (above_t >= 0);
    above_t=(above_t - 1)
    ::    else;
    fi; ;
    1 
}
    od; 
};
