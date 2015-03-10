From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 6/8] dm: don't start current request if it
 would've merged with the previous
Date: Tue, 10 Mar 2015 01:05:37 +0000
Message-ID: <54FE4361.50102@ce.jp.nec.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
	<1425430031-78140-7-git-send-email-snitzer@redhat.com>
	<54FCF1B2.8030007@ce.jp.nec.com>
	<230f5fbd7d6c403ab81327a69a52361f@hioexcmbx01-prd.hq.netapp.com>
	<54FD3934.5060700@ce.jp.nec.com>
	<6e1381e2553a40c491db7912357f0461@hioexcmbx01-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6e1381e2553a40c491db7912357f0461@hioexcmbx01-prd.hq.netapp.com>
Content-Language: ja-JP
Content-ID: <33A78947559E5544AD0276CF720B89AD@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 03/10/15 01:10, Merla, ShivaKrishna wrote:
>> did you try increasing nr_requests of dm request queue?
>> If so, what was the increased value of nr_requests in the case of
>> device queue_depth 32?
>>
> Yes, we tried increasing it to 256, the average merge count
> certainly increased a little bit but not comparable as to Mike's change.
> 
> 
> 03/09/2015 11:07:54 AM
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdak              0.00     0.00    0.00 21737.00     0.00 101064.00     9.30    11.93    0.55    0.00    0.55   0.04  93.00
> sdu               0.00     0.00    0.00 21759.00     0.00 101728.00     9.35    11.55    0.53    0.00    0.53   0.04  93.60
> sdm               0.00     0.00    0.00 21669.00     0.00 101168.00     9.34    11.76    0.54    0.00    0.54   0.04  94.00
> sdac              0.00     0.00    0.00 21812.00     0.00 101540.00     9.31    11.74    0.54    0.00    0.54   0.04  92.50
> dm-6              0.00 14266.00    0.00 86980.00     0.00 405496.00     9.32    48.44    0.56    0.00    0.56   0.01  98.70
> 
> With tunable delay of 20us here are the results.
> 
> 03/09/2015 11:08:43 AM
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdak              0.00     0.00    0.00 11740.00     0.00 135344.00    23.06     4.42    0.38    0.00    0.38   0.05  62.60
> sdu               0.00     0.00    0.00 11781.00     0.00 140800.00    23.90     3.23    0.27    0.00    0.27   0.05  62.80
> sdm               0.00     0.00    0.00 11770.00     0.00 137592.00    23.38     4.53    0.39    0.00    0.39   0.06  65.60
> sdac              0.00     0.00    0.00 11664.00     0.00 137976.00    23.66     3.36    0.29    0.00    0.29   0.05  60.80
> dm-6              0.00 88446.00    0.00 46937.00     0.00 551684.00    23.51    17.88    0.38    0.00    0.38   0.02  99.30

Oh I see. Thank you.
So it's not that requests weren't queued for merging but that CPUs
could not pile the requests fast enough...

If possible, it would be interesting to see the results with much
lower device queue_depth like 4 or 2.

-- 
Jun'ichi Nomura, NEC Corporation
