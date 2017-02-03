From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: don't allow ioctls to targets that don't map to whole devices
Date: Fri, 3 Feb 2017 09:35:27 -0500
Message-ID: <20170203143526.GB28599@redhat.com>
References: <20170203100613.9023-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170203100613.9023-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, agk@redhat.com, pbonzini@redhat.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 03 2017 at  5:06am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> .. at least for unprivilegued users.  Before we called into the SCSI
> ioctl code to allow excemptions for a few SCSI passthrough ioctls,
> but this is pretty unsafe and except for this call dm knows nothing
> about SCSI ioctls.  As SCSI the SCSI ioctl code is made optionally
> now we really don't want to drag it in for DM, and the exception is
> not very useful anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Note: this should go into the block tree, as that's where
> scsi_verify_blk_ioctl becomes optional.
> 
> ---
>  drivers/md/dm.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 9e958bc94fed..adc9dcfd5e9c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -465,13 +465,16 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
>  
>  	if (r > 0) {
>  		/*
> -		 * Target determined this ioctl is being issued against
> -		 * a logical partition of the parent bdev; so extra
> -		 * validation is needed.
> +		 * Target determined this ioctl is being issued against a
> +		 * subset of the parent bdev; require extra privilegues.
>  		 */
> -		r = scsi_verify_blk_ioctl(NULL, cmd);
> -		if (r)
> +		if (!capable(CAP_SYS_RAWIO)) {
> +			printk_ratelimited(KERN_WARNING
> +				"%s: sending ioctl %x to DM device!\n",
> +				current->comm, cmd);
> +			r = -ENOIOCTLCMD;
>  			goto out;
> +		}
>  	}
>  
>  	r =  __blkdev_driver_ioctl(bdev, mode, cmd, arg);
> -- 
> 2.11.0
> 

Would prefer to see the use of DMERR_LIMIT() or DMWARN_LIMIT() as those
wrappers provide error message consistency across DM core and DM
targets.  Also, would make sense to say: "sending ioctl %x to DM device
without required privilege (CAP_SYS_RAWIO)."

(you have a couple s/privilegue/privilege typos)

And this patch will need Paolo's ack before being staged.

Otherwise, look good:

Acked-by: Mike Snitzer <snitzer@redhat.com>
