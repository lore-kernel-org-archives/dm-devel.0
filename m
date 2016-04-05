From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: dm-cache performance behaviour
Date: Tue, 5 Apr 2016 16:16:59 +0200
Message-ID: <20160405141659.GH27444@suselix.suse.de>
References: <20160405071253.GB27444@suselix.suse.de>
 <20160405133109.GF27444@suselix.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160405133109.GF27444@suselix.suse.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 05, 2016 at 03:31:09PM +0200, Andreas Herrmann wrote:

-8<-

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

-8<-

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


Potential issue 1:

It's hard to get data replaced (slow promotion/demotion) in the cache.
Illustrated by comparing results for tests A+B with what happened for
tests C+D. Same action, creating a bunch of test files, then doing
random read accesses and run a subsequent test with same set of data
files. But once it was done with an empty cache (tests A+B) and one
time with an already fully utilized cache (tests C+D). And even doing
a third round with the second data set (test E) doesn't substantially
improve performance.

Potential issue 2:

The very last test on the list -- test I -- showed performance that
was significantly below performance of the backing device.



Regards,

Andreas
