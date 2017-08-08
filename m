From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/9] md: Add nowait support to md
Date: Tue, 8 Aug 2017 13:34:12 -0700
Message-ID: <20170808203412.jqqqj73pcoeovbzd@kernel.org>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
 <20170726235806.12148-3-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170726235806.12148-3-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-block@vger.kernel.org, hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

On Wed, Jul 26, 2017 at 06:57:59PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Set queue flags to QUEUE_FLAG_NOWAIT to indicate REQ_NOWAIT
> will be handled.
> 
> If an I/O on the md will be delayed, it would bail by calling
> bio_wouldblock_error(). The conditions when this could happen are:
> 
>  + MD is suspended
>  + There is a change pending on the SB, and current I/O would
>    block until that is complete.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8cdca0296749..d96c27d16841 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -285,6 +285,13 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>  		bio_endio(bio);
>  		return BLK_QC_T_NONE;
>  	}
> +
> +	if (mddev->suspended && (bio->bi_opf & REQ_NOWAIT)) {
> +		bio_wouldblock_error(bio);
> +		rcu_read_unlock();

this unlock is not required.

> +		return BLK_QC_T_NONE;
> +	}
> +
>  check_suspended:
>  	rcu_read_lock();
>  	if (mddev->suspended) {
> @@ -5274,6 +5281,10 @@ static int md_alloc(dev_t dev, char *name)
>  		mddev->queue = NULL;
>  		goto abort;
>  	}
> +
> +	/* Set the NOWAIT flags to show support */
> +	queue_flag_set_unlocked(QUEUE_FLAG_NOWAIT, mddev->queue);
> +
>  	disk->major = MAJOR(mddev->unit);
>  	disk->first_minor = unit << shift;
>  	if (name)
> @@ -8010,8 +8021,20 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
>  	rcu_read_unlock();
>  	if (did_change)
>  		sysfs_notify_dirent_safe(mddev->sysfs_state);
> -	wait_event(mddev->sb_wait,
> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) && !mddev->suspended);
> +
> +	/* Don't wait for sb writes if marked with REQ_NOWAIT */
> +	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
> +			mddev->suspended) {
> +		if (bi->bi_opf & REQ_NOWAIT) {
> +			bio_wouldblock_error(bi);
> +			percpu_ref_put(&mddev->writes_pending);
> +			return false;
> +		}
> +
> +		wait_event(mddev->sb_wait,
> +				!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) && !mddev->suspended);
> +	}
> +
>  	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
>  		percpu_ref_put(&mddev->writes_pending);
>  		return false;
> -- 
> 2.12.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
