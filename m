From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH v2 2/2 "v9"] dm: only initialize full
 request_queue for request-based device
Date: Tue, 25 May 2010 20:18:50 +0900
Message-ID: <4BFBB21A.3030105@ct.jp.nec.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
	<1274744795-9825-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274744795-9825-3-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

On 05/25/2010 08:46 AM +0900, Mike Snitzer wrote:
> Index: linux-2.6/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-ioctl.c
> +++ linux-2.6/drivers/md/dm-ioctl.c
> @@ -1201,6 +1203,15 @@ static int table_load(struct dm_ioctl *p
>  		goto out;
>  	}
>  
> +	/* setup md->queue to reflect md's and table's type (may block) */
> +	r = dm_setup_md_queue(md);
> +	if (r) {
> +		DMWARN("unable to setup device queue for this table.");
> +		dm_table_destroy(t);
> +		dm_unlock_md_type(md);
> +		goto out;
> +	}
> +

dm_setup_md_queue() should be put just after dm_set_md_type() of patch#1.
Then, you can make sure that dm_setup_md_queue() is called only once
and dm_setup_md_queue() should be much simpler.


> +/*
> + * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
> + */
> +static int dm_init_request_based_queue(struct mapped_device *md)
> +{
> +	struct request_queue *q = NULL;
> +
> +	/* Avoid re-initializing the queue if already fully initialized */
> +	if (!md->queue->elevator) {
> +		/* Fully initialize the queue */
> +		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> +		if (!q)
> +			return 0;

When blk_init_allocated_queue() fails, the block-layer seems not to
guarantee that the queue is still available.
You should create appropriate block-layer interfaces and/or take proper
recovery action here.
However, if the failure is not realistic, rather than complicating this
patch, you can just put a big comment and WARN_ON() for now, and fix it
in a separate patch-set.


> +static void dm_clear_request_based_queue(struct mapped_device *md)
> +{
> +	if (dm_bio_based_md_queue(md))
> +		return; /* queue already bio-based */
> +
> +	/* Unregister elevator from sysfs and clear ->request_fn */
> +	elv_unregister_queue(md->queue);
> +	md->queue->request_fn = NULL;
> +}
> +
> +/*
> + * Setup the DM device's queue based on md's type
> + */
> +int dm_setup_md_queue(struct mapped_device *md)
> +{
> +	BUG_ON(!mutex_is_locked(&md->type_lock));
> +	BUG_ON(dm_unknown_md_type(md));
> +
> +	if (dm_request_based_md_type(md)) {
> +		if (!dm_init_request_based_queue(md)) {
> +			DMWARN("Cannot initialize queue for Request-based dm");
> +			return -EINVAL;
> +		}
> +	} else if (dm_bio_based_md_type(md))
> +		dm_clear_request_based_queue(md);
> +
> +	return 0;
> +}

These unregister/clear works shouldn't be needed if dm_setup_md_queue()
is called only once as I mentioned above.

Thanks,
Kiyoshi Ueda
