From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH 02/13] dm-mpath: Avoid that path removal can
 trigger an infinite loop
Date: Thu, 27 Apr 2017 07:46:00 +0200
Message-ID: <fabbb802-5743-1193-3d4e-841404db2372@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
 <20170426183728.10821-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170426183728.10821-3-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> If blk_get_request() fails check whether the failure is due to
> a path being removed. If that is the case fail the path by
> triggering a call to fail_path(). This patch avoids that the
> following scenario can be encountered while removing paths:
> * CPU usage of a kworker thread jumps to 100%.
> * Removing the dm device becomes impossible.
> 
> Delay requeueing if blk_get_request() returns -EBUSY or
> -EWOULDBLOCK because in these cases immediate requeuing is
> inappropriate.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/md/dm-mpath.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 909098e18643..6d4333fdddf5 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -490,6 +490,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
>  	struct pgpath *pgpath;
>  	struct block_device *bdev;
>  	struct dm_mpath_io *mpio = get_mpio(map_context);
> +	struct request_queue *q;
>  	struct request *clone;
>  
>  	/* Do we need to select a new pgpath? */
> @@ -512,13 +513,19 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
>  	mpio->nr_bytes = nr_bytes;
>  
>  	bdev = pgpath->path.dev->bdev;
> -
> -	clone = blk_get_request(bdev_get_queue(bdev),
> -			rq->cmd_flags | REQ_NOMERGE,
> -			GFP_ATOMIC);
> +	q = bdev_get_queue(bdev);
> +	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
>  	if (IS_ERR(clone)) {
>  		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
> -		return r;
> +		pr_debug("blk_get_request() returned %ld%s - requeuing\n",
> +			 PTR_ERR(clone), blk_queue_dying(q) ?
> +			 " (path offline)" : "");
> +		if (blk_queue_dying(q)) {
> +			atomic_inc(&m->pg_init_in_progress);
> +			activate_path(pgpath);
> +			return DM_MAPIO_REQUEUE;
> +		}
> +		return DM_MAPIO_DELAY_REQUEUE;
>  	}
>  	clone->bio = clone->biotail = NULL;
>  	clone->rq_disk = bdev->bd_disk;
> 
At the very least this does warrant some inline comments.
Why do we call activate_path() here, seeing that the queue is dying?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
