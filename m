From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [for-4.16 PATCH v3 1/3] block: only bdi_unregister() in
 del_gendisk() if !GENHD_FL_HIDDEN
Date: Thu, 11 Jan 2018 10:48:20 +0800
Message-ID: <20180111024819.GC7290@ming.t460p>
References: <20180111021256.37490-1-snitzer@redhat.com>
 <20180111021256.37490-2-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111021256.37490-2-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Ming Lei <tom.leiming@gmail.com>, hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jan 10, 2018 at 09:12:54PM -0500, Mike Snitzer wrote:
> device_add_disk() will only call bdi_register_owner() if
> !GENHD_FL_HIDDEN, so it follows that del_gendisk() should only call
> bdi_unregister() if !GENHD_FL_HIDDEN.
> 
> Found with code inspection.  bdi_unregister() won't do any harm if
> bdi_register_owner() wasn't used but best to avoid the unnecessary
> call to bdi_unregister().
> 
> Fixes: 8ddcd65325 ("block: introduce GENHD_FL_HIDDEN")
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/genhd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 96a66f671720..00620e01e043 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -725,7 +725,8 @@ void del_gendisk(struct gendisk *disk)
>  		 * Unregister bdi before releasing device numbers (as they can
>  		 * get reused and we'd get clashes in sysfs).
>  		 */
> -		bdi_unregister(disk->queue->backing_dev_info);
> +		if (!(disk->flags & GENHD_FL_HIDDEN))
> +			bdi_unregister(disk->queue->backing_dev_info);
>  		blk_unregister_queue(disk);
>  	} else {
>  		WARN_ON(1);
> -- 
> 2.15.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming
