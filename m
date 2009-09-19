From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Sun, 20 Sep 2009 00:22:54 +0900
Message-ID: <4AB4F74E.7000908@ce.jp.nec.com>
References: <4AB3B43D.9000802@ce.jp.nec.com>
	<yq1eiq46ohz.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1eiq46ohz.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Martin K. Petersen wrote:
>>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> +	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
> +		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> 
> I'm really not keen on perpetuating SAFE_MAX_SECTORS for something that
> was written in this millennium.
> 
> I'd much rather we just do this, then:
> 
> block: Set max_sectors correctly for stacking devices
> 
> The topology changes unintentionally caused SAFE_MAX_SECTORS to be set
> for stacking devices.  Set the default limit to BLK_DEF_MAX_SECTORS and
> provide SAFE_MAX_SECTORS in blk_queue_make_request() for legacy hw
> drivers that depend on the old behavior.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 83413ff..cd9b730 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -111,7 +111,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->max_hw_segments = MAX_HW_SEGMENTS;
>  	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
>  	lim->max_segment_size = MAX_SEGMENT_SIZE;
> -	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
> +	lim->max_sectors = lim->max_hw_sectors = BLK_DEF_MAX_SECTORS;

Umm, with this, BLK_DEF_MAX_SECTORS becomes upper bound of max_hw_sectors
and the values of underlying devices are not propagated to the stacking
devices.
Is it intended?

>  	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
>  	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
>  	lim->alignment_offset = 0;
> @@ -164,6 +164,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
>  	q->unplug_timer.data = (unsigned long)q;
>  
>  	blk_set_default_limits(&q->limits);
> +	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
>  
>  	/*
>  	 * If the caller didn't supply a lock, fall back to our embedded

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
