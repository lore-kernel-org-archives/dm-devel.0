From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: open-iscsi + dm-multipath
Date: Wed, 23 Mar 2005 17:39:41 +0100
Message-ID: <20050323163941.GC19794@averon.dyndns.org>
References: <1110657791.16560.11.camel@mylaptop>
	<1110926912.10694.41.camel@zezette>
	<1110930664.3584.32.camel@mylaptop>
	<20050323163416.GB19794@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050323163416.GB19794@averon.dyndns.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

iostat figured may be flawed : dd just finished and the figure don't match ...

10485760000 bytes transferred in 344,857286 seconds (30406085 bytes/sec)
10485760000 bytes transferred in 343,683139 seconds (30509963 bytes/sec)

[1]-  Done                    dd if=/dev/20b90557202796769 of=/dev/null bs=1M count=10000
[2]+  Done                    dd if=/dev/2b1c15ceb02796769 of=/dev/null bs=1M count=10000

Anyway, it is still good.

> Tested, it works perfectly :
> 
> 2 streaming reads, 1 on each of these iSCSI LU (36GB 10Krpm JBODs):
> 
> 2b1c15ceb02796769
> [size=33 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active][first]
>   \_ 1:0:0:0 sdb  8:16    [ready ][active]
>   \_ 2:0:0:0 sde  8:64    [ready ][active]
>   \_ 3:0:0:0 sdh  8:112   [ready ][active]
>   \_ 4:0:0:0 sdk  8:160   [ready ][active]
>   \_ 5:0:0:1 sdp  8:240   [ready ][active]
>   \_ 6:0:0:0 sdq  65:0    [ready ][active]
>   \_ 7:0:0:0 sdt  65:48   [ready ][active]
>   \_ 8:0:0:0 sdw  65:96   [ready ][active]
>   \_ 9:0:0:0 sdz  65:144  [ready ][active]
> 
> 26353900f02796769
> [size=100 MB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active][first]
>   \_ 9:0:0:2 sdaa 65:160  [ready ][active]
>   \_ 1:0:0:2 sdc  8:32    [ready ][active]
>   \_ 2:0:0:2 sdf  8:80    [ready ][active]
>   \_ 3:0:0:2 sdi  8:128   [ready ][active]
>   \_ 4:0:0:2 sdl  8:176   [ready ][active]
>   \_ 5:0:0:2 sdo  8:224   [ready ][active]
>   \_ 6:0:0:2 sdr  65:16   [ready ][active]
>   \_ 7:0:0:2 sdu  65:64   [ready ][active]
>   \_ 8:0:0:2 sdx  65:112  [ready ][active]
> 
> ... gives this multipathed io profile :
> 
> Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdb        708,67   0,00 26,67  0,00 5877,33    0,00  2938,67     0,00   220,40     0,21    7,75   6,45  17,20
> sdc          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdd        772,33   0,00 27,67  0,00 6400,00    0,00  3200,00     0,00   231,33     0,22    7,94   6,10  16,87
> sde        707,33   0,00 26,00  0,00 5866,67    0,00  2933,33     0,00   225,64     0,23    8,92   6,22  16,17
> sdf          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdg        771,33   0,00 28,67  0,00 6400,00    0,00  3200,00     0,00   223,26     0,22    7,53   5,72  16,40
> sdh        707,67   0,00 25,67  0,00 5866,67    0,00  2933,33     0,00   228,57     0,24    9,51   6,55  16,80
> sdi          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdj        772,67   0,00 27,33  0,00 6400,00    0,00  3200,00     0,00   234,15     0,23    8,30   5,99  16,37
> sdk        707,67   0,00 25,67  0,00 5866,67    0,00  2933,33     0,00   228,57     0,23    8,83   6,81  17,47
> sdl          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdm        761,00   0,00 27,00  0,00 6301,33    0,00  3150,67     0,00   233,38     0,18    6,68   5,48  14,80
> sdn        742,67   0,00 27,00  0,00 6157,33    0,00  3078,67     0,00   228,05     0,21    7,85   5,86  15,83
> sdo          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdp        723,67   0,00 26,33  0,00 6005,33    0,00  3002,67     0,00   228,05     0,24    8,89   6,51  17,13
> sdq        741,00   0,00 25,67  0,00 6133,33    0,00  3066,67     0,00   238,96     0,24    9,19   7,08  18,17
> sdr          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sds        772,00   0,00 27,67  0,00 6400,00    0,00  3200,00     0,00   231,33     0,23    8,20   6,36  17,60
> sdt        739,67   0,00 27,00  0,00 6133,33    0,00  3066,67     0,00   227,16     0,25    9,35   7,31  19,73
> sdu          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdv        771,00   0,00 29,00  0,00 6400,00    0,00  3200,00     0,00   220,69     0,26    8,92   7,13  20,67
> sdw        741,00   0,00 25,67  0,00 6133,33    0,00  3066,67     0,00   238,96     0,24    9,18   7,12  18,27
> sdx          0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdy        772,33   0,00 27,67  0,00 6400,00    0,00  3200,00     0,00   231,33     0,24    8,82   6,71  18,57
> sdz        739,67   0,00 27,00  0,00 6133,33    0,00  3066,67     0,00   227,16     0,25    9,19   6,48  17,50
> sdaa         0,00   0,00  0,00  0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00   0,00   0,00
> sdab       770,33   0,00 29,67  0,00 6400,00    0,00  3200,00     0,00   215,73     0,23    7,84   5,67  16,83
> 
> ... which give around 110 MB/s
> 
> IET is the target implementation, running on a dual Xeon 2.8Ghz
> Initiator is a dual Opteron 248
> NICs are tg3 on both side, connected to a 3com low cost switch without Jumbo Frames.
> 
> Hope it helps ...
> 
> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
