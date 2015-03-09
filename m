From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH 6/8] dm: don't start current request if it
 would've merged with the previous
Date: Mon, 9 Mar 2015 16:10:03 +0000
Message-ID: <6e1381e2553a40c491db7912357f0461@hioexcmbx01-prd.hq.netapp.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
	<1425430031-78140-7-git-send-email-snitzer@redhat.com>
	<54FCF1B2.8030007@ce.jp.nec.com>
	<230f5fbd7d6c403ab81327a69a52361f@hioexcmbx01-prd.hq.netapp.com>
	<54FD3934.5060700@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54FD3934.5060700@ce.jp.nec.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



> -----Original Message-----
> From: Junichi Nomura [mailto:j-nomura@ce.jp.nec.com]
> Sent: Monday, March 09, 2015 1:10 AM
> To: Merla, ShivaKrishna
> Cc: device-mapper development; Mike Snitzer; axboe@kernel.dk;
> jmoyer@redhat.com; Hannes Reinecke
> Subject: Re: [dm-devel] [PATCH 6/8] dm: don't start current request if it
> would've merged with the previous
> 
> On 03/09/15 12:30, Merla, ShivaKrishna wrote:
> >> Secondly, for this comment from Merla ShivaKrishna:
> >>
> >>> Yes, Indeed this the exact issue we saw at NetApp. While running
> sequential
> >>> 4K write I/O with large thread count, 2 paths yield better performance
> than
> >>> 4 paths and performance drastically drops with 4 paths. The device
> queue_depth
> >>> as 32 and with blktrace we could see better I/O merging happening and
> average
> >>> request size was > 8K through iostat. With 4 paths none of the I/O gets
> merged and
> >>> always average request size is 4K. Scheduler used was noop as we are
> using SSD
> >>> based storage. We could get I/O merging to happen even with 4 paths
> but with lower
> >>> device queue_depth of 16. Even then the performance was lacking
> compared to 2 paths.
> >>
> >> Have you tried increasing nr_requests of the dm device?
> >> E.g. setting nr_requests to 256.
> >>
> >> 4 paths with each queue depth 32 means that it can have 128 I/Os in flight.
> >> With the default value of nr_requests 128, the request queue is almost
> >> always empty and I/O merge could not happen.
> >> Increasing nr_requests of the dm device allows some more requests
> >> queued,
> >> thus the chance of merging may increase.
> >> Reducing the lower device queue depth could be another solution. But if
> >> the depth is too low, you might not be able to keep the optimal speed.
> >>
> > Yes, we have tried this as well but didn't help. Indeed, we have tested with
> queue_depth
> > of 16 on each path as well with 64 I/O's in flight and resulted in same issue.
> We did try
> > reducing the queue_depth with 4 paths, but couldn't achieve comparable
> performance
> > as of 2 paths. With Mike's patch, we see tremendous improvement with
> just a small delay
> > of ~20us with 4 paths. This might vary with different configurations but sure
> have proved
> > that a tunable to delay dispatches with sequential workloads has helped a
> lot.
> 
> Hi,
> 
> did you try increasing nr_requests of dm request queue?
> If so, what was the increased value of nr_requests in the case of
> device queue_depth 32?
> 
Yes, we tried increasing it to 256, the average merge count
certainly increased a little bit but not comparable as to Mike's change.


03/09/2015 11:07:54 AM
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdak              0.00     0.00    0.00 21737.00     0.00 101064.00     9.30    11.93    0.55    0.00    0.55   0.04  93.00
sdu               0.00     0.00    0.00 21759.00     0.00 101728.00     9.35    11.55    0.53    0.00    0.53   0.04  93.60
sdm               0.00     0.00    0.00 21669.00     0.00 101168.00     9.34    11.76    0.54    0.00    0.54   0.04  94.00
sdac              0.00     0.00    0.00 21812.00     0.00 101540.00     9.31    11.74    0.54    0.00    0.54   0.04  92.50
dm-6              0.00 14266.00    0.00 86980.00     0.00 405496.00     9.32    48.44    0.56    0.00    0.56   0.01  98.70

With tunable delay of 20us here are the results.

03/09/2015 11:08:43 AM
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdak              0.00     0.00    0.00 11740.00     0.00 135344.00    23.06     4.42    0.38    0.00    0.38   0.05  62.60
sdu               0.00     0.00    0.00 11781.00     0.00 140800.00    23.90     3.23    0.27    0.00    0.27   0.05  62.80
sdm               0.00     0.00    0.00 11770.00     0.00 137592.00    23.38     4.53    0.39    0.00    0.39   0.06  65.60
sdac              0.00     0.00    0.00 11664.00     0.00 137976.00    23.66     3.36    0.29    0.00    0.29   0.05  60.80
dm-6              0.00 88446.00    0.00 46937.00     0.00 551684.00    23.51    17.88    0.38    0.00    0.38   0.02  99.30

> --
> Jun'ichi Nomura, NEC Corporation
