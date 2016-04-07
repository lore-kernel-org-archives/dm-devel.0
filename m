From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: dm-cache performance behaviour
Date: Thu, 7 Apr 2016 01:24:04 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604070115070.12121@mail.ewheeler.net>
References: <20160405071253.GB27444@suselix.suse.de> <20160405133109.GF27444@suselix.suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160405133109.GF27444@suselix.suse.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 5 Apr 2016, Andreas Herrmann wrote:
> test system, software:
> - Intel(R) Core(TM) i7-3770S CPU @ 3.10GHz
> - 32 GB DDR3 (1333 MHz) RAM
> - Ubuntu 14.04 LTS
> - Linux kernel 4.5.0
> - Backing device: SAMSUNG HD155UI (1.5 TB), entire disk used
> - Caching device: SAMSUNG SSD 830 (128 GB), entire disk used
>   (in case of dm-cache used for both metadata cache data)
> - fio (flexible I/O tester) as of 2.2.9-37-g0e1c4
> - ext4 file system on compound cache device
> - CFQ I/O scheduler for caching and backing device
> 
> dmcache:
> - writeback cache mode
> - SMQ cache policy
> - cache block size: 512 sectors, resulting in cache blocks of size
>   256KB

You might consider tweaking {read,write}_promote_adjustment with 
	dmsetup message /dev/mapper/foo 0 read_promote_adjustment X 
or at initial table creation time to shorten cache heat time.

You could use this with LVM tools:
  lvchange --cachesettings 'read_promote_adjustment = 1' vg/cachedvol

See descriptions here:
  
https://www.kernel.org/doc/Documentation/device-mapper/cache-policies.txt

When we used dm-cache I would set the promote values to 1 (or 0?) to heat 
up the cache and then increment them after the cache filled.

> bcache:
> - writeback cache mode
> - LRU cache policy

bcache defaults to 512k bucket size iirc, you'll want to specify -b 256k 
on your make-bcache call for an apples-to-apples comparison.  FWIW, I like 
the 64k size best for our workload.

--
Eric Wheeler


> test procedure:
> - Create compound cache device
> - Test A: fio test using data set 1 (using empty cache
>   device, it includes creation of data set 1)
> - Test B: fio test using data set 1 for the second
>   successive time
> - Test C: fio test using data set 2 (it includes creation
>   of data set 2)
> - Test D: fio test using data set 2 for the second
>   successive time
> - Test E: fio test using data set 2 for the third
>   successive time
> - Test F: fio test using data set 3 (it includes creation
>   of data set 3)
> - Clear cache (remove and recreate caching device, re-attach it to
>   compound cache device)
> - Test G: fio test using data set 1 (using empty cache)
> - Copy data set 1 into temporary directory on test disk to clobber
>   cache
> - Test H: fio test using data set 1 (after cache was
>   clobbered with data from data set 1)
> - Test I: fio test using data set 2 (after cache was
>   clobbered and test H)
> 
> fio options and arguments:
> -directory=<test dir on cached device>
> -name=<file-name-prefix>
> -rw=randread 
> -size=50G
> -group_reporting
> -ioengine=libaio
> -direct=1
> -iodepth=1
> -runtime=40
> -numjobs=<1,2,3>
> 
> -> block size 4k
> -> each of above tests did 10 iterations for 1 job, 10 iterations for
>    2 jobs, 10 iterations fo 3 jobs using the same data set.
> -> one data set for one test consists of 3 data files (created by
>    fio), each having size 50G, thus all 3 files exceed size of caching
>    disk
> 
> Following 3 tables contain typical bandwidth measurements (in KB/s) of
> one run of above test procedure. As reference "native" (ie. w/o
> storage caching) performance for both SSD and HD are provided in all
> tables. This native performance was gathered with test A from the test
> procedure. In case of SSD --size parameter was set to 40G otherwise
> all 3 files would not have fit on the device.
> 
> First table shows results for test A, B, C for both dm-cache and
> bcache.  Remaining tests E-I are shown in second table for dm-cache
> and in third table for bcache.
> 
>     i = iteration, n = numjobs, shown is bandwidth in KB/s
> 
>        | native results|        dm-cache       |       bcache
>  i | n |1.5TB HD|  SSD | test A| test B| test C| test A| test B| test C 
> -----------------------------------------------------------------------
>  1 | 1 | 353.06 | 20568| 1154.7| 1819.6| 394.79|  351.6|  6111 |  377.2 
>  2 | 1 | 348.25 | 20571| 1265.2| 1896.6| 395.46|  701.9|  6393 |  748.8 
>  3 | 1 | 352.36 | 20573| 1298.2| 1917.1| 395.05| 1047.3|  6681 | 1120.4 
>  4 | 1 | 349.60 | 20542| 1494.5| 1919.2| 394.54| 1389.3|  6962 | 1483.4 
>  5 | 1 | 353.02 | 20554| 1703.6| 1921.1| 394.52| 1724.7|  7247 | 1841.7 
>  6 | 1 | 352.04 | 20564| 1745.1| 1938.2| 381.38| 2060.1|  7517 | 2200.2 
>  7 | 1 | 349.19 | 20585| 1929.5| 1957.6| 399.18| 2383.6|  7805 | 2556.5 
>  8 | 1 | 350.14 | 20584| 2047.6| 1935.6| 406.40| 2712.5|  8082 | 2908.5 
>  9 | 1 | 348.25 | 20573| 2231.3| 1951.2| 407.63| 3034.3|  8350 | 3260.5 
> 10 | 1 | 349.99 | 20579| 2336.2| 2001.7| 403.35| 3355.5|  8622 | 3612.2 
> 11 | 2 | 324.67 | 38590| 2904.6| 2643.1| 369.60| 3694.8| 10769 | 3991.5 
> 12 | 2 | 327.30 | 38466| 2865.3| 2601.1| 373.93| 4033.4| 11085 | 4369.1 
> 13 | 2 | 329.87 | 38550| 2882.2| 2594.9| 382.51| 4371.9| 11395 | 4743.9 
> 14 | 2 | 328.70 | 38459| 2893.3| 2614.1| 386.55| 4708.9| 11717 | 5118.6 
> 15 | 2 | 324.66 | 38468| 2918.2| 2641.8| 393.40| 5038.3| 12033 | 5491.8 
> 16 | 2 | 324.78 | 38514| 2907.8| 2605.4| 400.04| 5379.1| 12336 | 5861.2 
> 17 | 2 | 322.55 | 38519| 2923.5| 2684.6| 405.56| 5704.7| 12646 | 6227.9 
> 18 | 2 | 325.76 | 38519| 2927.1| 2689.4| 408.50| 6034.9| 12955 | 6585.4 
> 19 | 2 | 323.51 | 38482| 3005.5| 2662.3| 411.20| 6360.4| 13263 | 6942.3 
> 20 | 2 | 327.49 | 38509| 3016.3| 2714.3| 420.88| 6684.7| 13564 | 7306.2 
> 21 | 3 | 337.04 | 56139| 2549.8| 2512.5| 430.07| 5205.9| 12577 | 5659.6 
> 22 | 3 | 338.73 | 56210| 2462.2| 2459.1| 428.68| 5542.3| 12899 | 6040.3 
> 23 | 3 | 339.08 | 56020| 2442.8| 2519.6| 430.82| 5893.2| 13182 | 6417.4 
> 24 | 3 | 340.26 | 56142| 2360.3| 2526.4| 432.77| 6230.7| 13546 | 6796.2 
> 25 | 3 | 333.83 | 56081| 2303.1| 2508.4| 434.03| 6571.1| 13865 | 7170.2 
> 26 | 3 | 338.32 | 56195| 2344.8| 2508.5| 431.66| 6909.8| 14182 | 7540.5 
> 27 | 3 | 339.73 | 56165| 2351.4| 2540.4| 434.86| 7227.1| 14494 | 7915.4 
> 28 | 3 | 331.52 | 56216| 2354.5| 2489.7| 430.30| 7570.4| 14812 | 8279.1 
> 29 | 3 | 334.47 | 56083| 2339.9| 2490.4| 441.79| 7908.7| 15129 | 8640.6 
> 30 | 3 | 347.99 | 56089| 2418.5| 2490.3| 446.06| 8241.4| 15443 | 9008.8 
> 
>        | native results|                      dm-cache
>  i | n |1.5TB HD|  SSD | test D| test E| test F| test G| test H | test I 
> ------------------------------------------------------------------------
>  1 | 1 | 353.06 | 20568| 461.6 | 521.6 | 390.2 |  328.8| 1098.7 | 222.5
>  2 | 1 | 348.25 | 20571| 466.6 | 524.2 | 389.2 |  184.6| 1093.5 | 229.1
>  3 | 1 | 352.36 | 20573| 485.7 | 521.9 | 389.0 |  480.0| 1095.8 | 225.7
>  4 | 1 | 349.60 | 20542| 497.3 | 525.1 | 389.4 |  579.3| 1096.7 | 230.1
>  5 | 1 | 353.02 | 20554| 501.5 | 527.4 | 388.9 |  649.5| 1100.6 | 226.9
>  6 | 1 | 352.04 | 20564| 504.0 | 528.8 | 369.9 |  714.7| 1095.2 | 224.9
>  7 | 1 | 349.19 | 20585| 507.2 | 530.8 | 398.1 |  766.9| 1095.2 | 225.9
>  8 | 1 | 350.14 | 20584| 497.9 | 530.4 | 402.3 |  817.1| 1096.6 | 226.5
>  9 | 1 | 348.25 | 20573| 516.6 | 535.7 | 399.5 |  847.7| 1098.2 | 226.8
> 10 | 1 | 349.99 | 20579| 518.1 | 534.2 | 397.1 |  877.8| 1098.7 | 232.6
> 11 | 2 | 324.67 | 38590| 449.8 | 472.9 | 373.4 |  888.7| 1201.1 | 261.1
> 12 | 2 | 327.30 | 38466| 447.3 | 473.0 | 377.1 |  898.9| 1205.7 | 265.9
> 13 | 2 | 329.87 | 38550| 451.9 | 473.9 | 386.3 |  932.4| 1204.1 | 264.9
> 14 | 2 | 328.70 | 38459| 451.0 | 475.0 | 394.9 |  961.1| 1205.3 | 265.7
> 15 | 2 | 324.66 | 38468| 456.5 | 476.6 | 401.2 |  993.7| 1210.7 | 268.6
> 16 | 2 | 324.78 | 38514| 459.4 | 487.0 | 409.0 | 1034.9| 1206.2 | 269.7
> 17 | 2 | 322.55 | 38519| 456.1 | 498.9 | 411.7 | 1062.3| 1204.9 | 273.3
> 18 | 2 | 325.76 | 38519| 458.3 | 500.2 | 422.0 | 1081.6| 1204.6 | 280.5
> 19 | 2 | 323.51 | 38482| 457.1 | 498.3 | 430.5 | 1100.3| 1207.5 | 279.0
> 20 | 2 | 327.49 | 38509| 455.8 | 500.4 | 428.7 | 1106.8| 1203.6 | 285.7
> 21 | 3 | 337.04 | 56139| 462.6 | 481.5 | 439.0 | 1060.9| 1250.2 | 312.7
> 22 | 3 | 338.73 | 56210| 462.9 | 483.3 | 437.2 | 1095.7| 1253.9 | 306.8
> 23 | 3 | 339.08 | 56020| 469.5 | 489.1 | 437.8 | 1163.7| 1248.9 | 304.7
> 24 | 3 | 340.26 | 56142| 462.1 | 487.1 | 440.1 | 1189.9| 1252.1 | 303.0
> 25 | 3 | 333.83 | 56081| 465.1 | 490.8 | 436.9 | 1217.7| 1248.6 | 302.6
> 26 | 3 | 338.32 | 56195| 465.1 | 489.8 | 433.4 | 1234.8| 1248.7 | 308.3
> 27 | 3 | 339.73 | 56165| 464.6 | 490.7 | 437.0 | 1256.1| 1253.3 | 305.4
> 28 | 3 | 331.52 | 56216| 463.2 | 496.7 | 435.6 | 1281.8| 1250.5 | 307.1
> 29 | 3 | 334.47 | 56083| 469.4 | 493.3 | 434.6 | 1302.6| 1249.4 | 308.9
> 30 | 3 | 347.99 | 56089| 464.0 | 501.4 | 442.5 | 1321.5| 1250.9 | 305.4
> 
>        | native results|                      bcache
>  i | n |1.5TB HD|  SSD | test D| test E| test F| test G| test H| test I 
> -----------------------------------------------------------------------
>  1 | 1 | 353.06 | 20568|  6652 | 11905 |  390.3|  389.9|  6995 |  376.8
>  2 | 1 | 348.25 | 20571|  6964 | 12182 |  776.5|  779.3|  7339 |  750.3
>  3 | 1 | 352.36 | 20573|  7275 | 12451 | 1161.2| 1164.1|  7677 | 1120.2
>  4 | 1 | 349.60 | 20542|  7585 | 12723 | 1541.6| 1547.2|  8020 | 1487.1
>  5 | 1 | 353.02 | 20554|  7889 | 12989 | 1916.4| 1924.4|  8357 | 1850.7
>  6 | 1 | 352.04 | 20564|  8192 | 13255 | 2287.6| 2301.6|  8688 | 2210.6
>  7 | 1 | 349.19 | 20585|  8496 | 13520 | 2658.5| 2677.5|  9023 | 2568.8
>  8 | 1 | 350.14 | 20584|  8795 | 13783 | 3029.3| 3053.7|  9359 | 2922.7
>  9 | 1 | 348.25 | 20573|  9093 | 14045 | 3397.9| 3423.3|  9687 | 3278.7
> 10 | 1 | 349.99 | 20579|  9392 | 14305 | 3764.5| 3796.8| 10014 | 3632.8
> 11 | 2 | 324.67 | 38590| 11773 | 18720 | 4135.8| 4177.6| 12288 | 4015.5
> 12 | 2 | 327.30 | 38466| 12128 | 19046 | 4499.6| 4554.4| 12631 | 4394.3
> 13 | 2 | 329.87 | 38550| 12480 | 19369 | 4859.4| 4928.1| 12975 | 4770.4
> 14 | 2 | 328.70 | 38459| 12822 | 19696 | 5218.2| 5298.8| 13315 | 5142.5
> 15 | 2 | 324.66 | 38468| 13170 | 20014 | 5575.6| 5667.6| 13651 | 5510.6
> 16 | 2 | 324.78 | 38514| 13510 | 20333 | 5928.9| 6031.7| 13994 | 5876.4
> 17 | 2 | 322.55 | 38519| 13848 | 20650 | 6279.7| 6391.6| 14321 | 6239.1
> 18 | 2 | 325.76 | 38519| 14187 | 20960 | 6626.7| 6745.1| 14645 | 6595.5
> 19 | 2 | 323.51 | 38482| 14522 | 21271 | 6972.2| 7093.9| 14964 | 6954.6
> 20 | 2 | 327.49 | 38509| 14850 | 21575 | 7317.6| 7452.5| 15280 | 7305.4
> 21 | 3 | 337.04 | 56139| 13800 | 21069 | 5811.8| 5914.9| 14496 | 5732.5
> 22 | 3 | 338.73 | 56210| 14158 | 21402 | 6199.7| 6305.7| 14858 | 6113.1
> 23 | 3 | 339.08 | 56020| 14510 | 21727 | 6585.1| 6695.2| 15214 | 6494.2
> 24 | 3 | 340.26 | 56142| 14860 | 22053 | 6972.6| 7079.6| 15570 | 6870.9
> 25 | 3 | 333.83 | 56081| 15206 | 22373 | 7356.4| 7464.9| 15929 | 7244.4
> 26 | 3 | 338.32 | 56195| 15545 | 22691 | 7735.1| 7845.5| 16276 | 7616.8
> 27 | 3 | 339.73 | 56165| 15890 | 23017 | 8113.1| 8225.6| 16627 | 7988.6
> 28 | 3 | 331.52 | 56216| 16230 | 23323 | 8496.4| 8600.7| 16973 | 8353.7
> 29 | 3 | 334.47 | 56083| 16562 | 23636 | 8864.9| 8973.5| 17323 | 8722.5
> 30 | 3 | 347.99 | 56089| 16899 | 23945 | 9235.8| 9343.1| 17663 | 9081.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
