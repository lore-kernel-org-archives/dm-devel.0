From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH 6/8] dm: don't start current request if it
 would've merged with the previous
Date: Mon, 9 Mar 2015 03:30:03 +0000
Message-ID: <230f5fbd7d6c403ab81327a69a52361f@hioexcmbx01-prd.hq.netapp.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
	<1425430031-78140-7-git-send-email-snitzer@redhat.com>
	<54FCF1B2.8030007@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54FCF1B2.8030007@ce.jp.nec.com>
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
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "jmoyer@redhat.com" <jmoyer@redhat.com>
List-Id: dm-devel.ids



> -----Original Message-----
> From: Junichi Nomura [mailto:j-nomura@ce.jp.nec.com]
> Sent: Sunday, March 08, 2015 8:05 PM
> To: device-mapper development; Mike Snitzer
> Cc: axboe@kernel.dk; jmoyer@redhat.com; Hannes Reinecke; Merla,
> ShivaKrishna
> Subject: Re: [dm-devel] [PATCH 6/8] dm: don't start current request if it
> would've merged with the previous
> 
> On 03/04/15 09:47, Mike Snitzer wrote:
> > Request-based DM's dm_request_fn() is so fast to pull requests off the
> > queue that steps need to be taken to promote merging by avoiding
> request
> > processing if it makes sense.
> >
> > If the current request would've merged with previous request let the
> > current request stay on the queue longer.
> 
> Hi Mike,
> 
> Looking at this thread, I think there are 2 different problems mixed.
> 
> Firstly, "/dev/skd" is STEC S1120 block driver, which doesn't have
> lld_busy function. So back pressure doesn't propagate to request-based
> dm device and dm feeds as many request as possible to the lower driver.
> ("pulling too fast" situation)
> If you still have access to the device, can you try the patch like
> the attached one?
> 
> Secondly, for this comment from Merla ShivaKrishna:
> 
> > Yes, Indeed this the exact issue we saw at NetApp. While running
> sequential
> > 4K write I/O with large thread count, 2 paths yield better performance than
> > 4 paths and performance drastically drops with 4 paths. The device
> queue_depth
> > as 32 and with blktrace we could see better I/O merging happening and
> average
> > request size was > 8K through iostat. With 4 paths none of the I/O gets
> merged and
> > always average request size is 4K. Scheduler used was noop as we are using
> SSD
> > based storage. We could get I/O merging to happen even with 4 paths but
> with lower
> > device queue_depth of 16. Even then the performance was lacking
> compared to 2 paths.
> 
> Have you tried increasing nr_requests of the dm device?
> E.g. setting nr_requests to 256.
> 
> 4 paths with each queue depth 32 means that it can have 128 I/Os in flight.
> With the default value of nr_requests 128, the request queue is almost
> always empty and I/O merge could not happen.
> Increasing nr_requests of the dm device allows some more requests
> queued,
> thus the chance of merging may increase.
> Reducing the lower device queue depth could be another solution. But if
> the depth is too low, you might not be able to keep the optimal speed.
>
Yes, we have tried this as well but didn't help. Indeed, we have tested with queue_depth
of 16 on each path as well with 64 I/O's in flight and resulted in same issue. We did try
reducing the queue_depth with 4 paths, but couldn't achieve comparable performance
as of 2 paths. With Mike's patch, we see tremendous improvement with just a small delay 
of ~20us with 4 paths. This might vary with different configurations but sure have proved 
that a tunable to delay dispatches with sequential workloads has helped a lot.

 
> ----
> Jun'ichi Nomura, NEC Corporation
> 
> 
> [PATCH] skd: Add lld_busy function for request-based stacking driver
> 
> diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
> index 1e46eb2..0e8f466 100644
> --- a/drivers/block/skd_main.c
> +++ b/drivers/block/skd_main.c
> @@ -565,6 +565,16 @@ skd_prep_discard_cdb(struct skd_scsi_request
> *scsi_req,
>  	blk_add_request_payload(req, page, len);
>  }
> 
> +static int skd_lld_busy(struct request_queue *q)
> +{
> +	struct skd_device *skdev = q->queuedata;
> +
> +	if (skdev->in_flight >= skdev->cur_max_queue_depth)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static void skd_request_fn_not_online(struct request_queue *q);
> 
>  static void skd_request_fn(struct request_queue *q)
> @@ -4419,6 +4429,8 @@ static int skd_cons_disk(struct skd_device *skdev)
>  	/* set sysfs ptimal_io_size to 8K */
>  	blk_queue_io_opt(q, 8192);
> 
> +	/* register feed back function for stacking driver */
> +	blk_queue_lld_busy(q, skd_lld_busy);
> +
>  	/* DISCARD Flag initialization. */
>  	q->limits.discard_granularity = 8192;
>  	q->limits.discard_alignment = 0;
