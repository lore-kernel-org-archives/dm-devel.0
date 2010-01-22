From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath splitting IOs in 4k blocks
Date: Fri, 22 Jan 2010 14:14:56 -0500
Message-ID: <20100122191455.GA30971@redhat.com>
References: <20100122164109.GA15636@marmite.ath.cx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100122164109.GA15636@marmite.ath.cx>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Fri, Jan 22 2010 at 11:41am -0500,
Bob <M8R-0t7cpu@mailinator.com> wrote:

> Hello,
> 
> I have a question about dm-multipath. As you can see below, it seems that
> multipath splits any IO incoming to the device in 4k blocks, and then
> reassembles it when doing the actual read from the SAN. If the device is opened
> in direct IO mode, this behavior is not experienced. It is not experienced
> either if the IO is sent directly to a single path (eg /dev/sdef in this
> example).
> 
> My question is : what causes this behavior, and is there any way to change that ?

direct-io will cause DM to accumulate pages into larger bios (via
bio_add_page calls to dm_merge_bvec).  This is why you see larger
requests with iflag=direct.

Buffered IO writes (from the page-cache) will always be in one-page
units.  It is the IO scheduler that will merge these requests.

Buffered IO reads _should_ have larger requests.  So it is curious that
you're seeing single-page read requests.  I can't reproduce that on a
recent kernel.org kernel.  Will need time to test on RHEL 5.3.

NOTE: all DM devices should behave like I explained above (you just
happen to be focusing on dm-multipath).  Testing against normal "linear"
DM devices would also be valid.

> Some quick dd tests would tend to show that the device is quite faster if
> multipath doesn't split the IOs.

The testing output you provided doesn't reflect that (nor would I expect
it to for sequential IO if readahead is configured)...

Mike

> [root@test-bis ~]# dd if=/dev/dm-5 of=/dev/null bs=16384
> 
> Meanwhile...
> 
> [root@test-bis ~]# iostat -kx /dev/dm-5 /dev/sdef /dev/sdfh /dev/sdgi /dev/sdgw 5
> ...
> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdef           4187.82     0.00 289.42  0.00 17932.14     0.00   123.92     0.45    1.56   1.01  29.34
> sdfh           4196.41     0.00 293.81  0.00 17985.63     0.00   122.43     0.41    1.39   0.90  26.37
> sdgi           4209.98     0.00 286.43  0.00 17964.07     0.00   125.44     0.69    2.38   1.43  40.98
> sdgw           4188.62     0.00 289.22  0.00 17885.03     0.00   123.68     0.54    1.87   1.16  33.59
> dm-5              0.00     0.00 17922.55  0.00 71690.22     0.00     8.00    47.14    2.63   0.05  98.28
> 
> => avgrq-sz is 4kB (8.00 blocks) on the mpath device
> --------
> [root@test-bis ~]# dd if=/dev/dm-5 iflag=direct of=/dev/null bs=16384
> 
> iostat now gives :
> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdef              0.00     0.00 640.00  0.00 10240.00     0.00    32.00     0.31    0.48   0.48  30.86
> sdfh              0.00     0.00 644.40  0.00 10310.40     0.00    32.00     0.22    0.34   0.34  22.10
> sdgi              0.00     0.00 663.80  0.00 10620.80     0.00    32.00     0.24    0.36   0.36  24.20
> sdgw              0.00     0.00 640.00  0.00 10240.00     0.00    32.00     0.20    0.32   0.32  20.28
> dm-5              0.00     0.00 2587.00  0.00 41392.00     0.00    32.00     0.97    0.38   0.38  97.20
> 
> => avgrq-sz is now 16kB (32.00 blocks) on the mpath device
