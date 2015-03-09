From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 6/8] dm: don't start current request if it
 would've merged with the previous
Date: Mon, 9 Mar 2015 06:09:56 +0000
Message-ID: <54FD3934.5060700@ce.jp.nec.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
	<1425430031-78140-7-git-send-email-snitzer@redhat.com>
	<54FCF1B2.8030007@ce.jp.nec.com>
	<230f5fbd7d6c403ab81327a69a52361f@hioexcmbx01-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <230f5fbd7d6c403ab81327a69a52361f@hioexcmbx01-prd.hq.netapp.com>
Content-Language: ja-JP
Content-ID: <A4BC422CF23718408034252E1EFE7189@gisp.nec.co.jp>
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

On 03/09/15 12:30, Merla, ShivaKrishna wrote:
>> Secondly, for this comment from Merla ShivaKrishna:
>>
>>> Yes, Indeed this the exact issue we saw at NetApp. While running sequential
>>> 4K write I/O with large thread count, 2 paths yield better performance than
>>> 4 paths and performance drastically drops with 4 paths. The device queue_depth
>>> as 32 and with blktrace we could see better I/O merging happening and average
>>> request size was > 8K through iostat. With 4 paths none of the I/O gets merged and
>>> always average request size is 4K. Scheduler used was noop as we are using SSD
>>> based storage. We could get I/O merging to happen even with 4 paths but with lower
>>> device queue_depth of 16. Even then the performance was lacking compared to 2 paths.
>>
>> Have you tried increasing nr_requests of the dm device?
>> E.g. setting nr_requests to 256.
>>
>> 4 paths with each queue depth 32 means that it can have 128 I/Os in flight.
>> With the default value of nr_requests 128, the request queue is almost
>> always empty and I/O merge could not happen.
>> Increasing nr_requests of the dm device allows some more requests
>> queued,
>> thus the chance of merging may increase.
>> Reducing the lower device queue depth could be another solution. But if
>> the depth is too low, you might not be able to keep the optimal speed.
>>
> Yes, we have tried this as well but didn't help. Indeed, we have tested with queue_depth
> of 16 on each path as well with 64 I/O's in flight and resulted in same issue. We did try
> reducing the queue_depth with 4 paths, but couldn't achieve comparable performance
> as of 2 paths. With Mike's patch, we see tremendous improvement with just a small delay 
> of ~20us with 4 paths. This might vary with different configurations but sure have proved 
> that a tunable to delay dispatches with sequential workloads has helped a lot.

Hi,

did you try increasing nr_requests of dm request queue?
If so, what was the increased value of nr_requests in the case of
device queue_depth 32?

-- 
Jun'ichi Nomura, NEC Corporation
