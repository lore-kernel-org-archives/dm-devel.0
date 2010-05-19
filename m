From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Questions regarding request based dm-multipath
	and	blk-layer/elevator
Date: Wed, 19 May 2010 14:31:47 -0400
Message-ID: <20100519183147.GA3394@redhat.com>
References: <201005191716.38617.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201005191716.38617.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 19, 2010 at 05:16:38PM +0530, Nikanth Karthikesan wrote:
> Hi
> 
> I have couple of questions regd request based dm.
> 
> 1. With request based multipath, we have 2 elevators in the path to the
> device. Doesn't 2 idling I/O schedulers affect performance? Is it better to
> use the noop elevator for the dm device? What is suggested?
> I can send a patch to set noop as default for rq based dm, if it would be
> better.
> 

IIUC, we don't use the ioscheduler of unerlying device and directly insert
the request in request queue of underlying device. So double idling should
not be an issue.

Look at blk_insert_cloned_request(), which uses __elv_add_request() with
option ELEVATOR_INSERT_BACK.

Thanks
Vivek

> 2. The blk-layer limit nr_requests is the maximum nr of requests per-queue.
> Currently we set it to the default maximum(128) and leave it.
> 
> Instead would it be better to set it to a higher number based on the number of
> paths(underlying devices) and their nr_requests? In bio-based dm-multipath, we
> were queueing upto the sum of all the underlying queue's nr_requests.
> 
> For example the attached patch would set it to the sum of nr_requests of all
> the targets. May be it is better to do it from the user-space daemon,
> multipathd? Or just 128 requests is enough as in the end, it is going to be a
> single LUN? Or should we simply use the nr_request from one of the underlying
> device? Or the maximum nr_request amoung the underlying devices?
> 
> Thanks
> Nikanth
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9fe174d..fc33c2d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -91,6 +91,44 @@ void blk_queue_congestion_threshold(struct request_queue *q)
>  	q->nr_congestion_off = nr;
>  }
>  
> +unsigned long
> +__blk_queue_set_nr_requests(struct request_queue *q, unsigned long nr)
> +{
> +	struct request_list *rl = &q->rq;
> +
> +	if (nr < BLKDEV_MIN_RQ)
> +		nr = BLKDEV_MIN_RQ;
> +
> +	q->nr_requests = nr;
> +	blk_queue_congestion_threshold(q);
> +
> +	if (rl->count[BLK_RW_SYNC] >= queue_congestion_on_threshold(q))
> +		blk_set_queue_congested(q, BLK_RW_SYNC);
> +	else if (rl->count[BLK_RW_SYNC] < queue_congestion_off_threshold(q))
> +		blk_clear_queue_congested(q, BLK_RW_SYNC);
> +
> +	if (rl->count[BLK_RW_ASYNC] >= queue_congestion_on_threshold(q))
> +		blk_set_queue_congested(q, BLK_RW_ASYNC);
> +	else if (rl->count[BLK_RW_ASYNC] < queue_congestion_off_threshold(q))
> +		blk_clear_queue_congested(q, BLK_RW_ASYNC);
> +
> +	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
> +		blk_set_queue_full(q, BLK_RW_SYNC);
> +	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
> +		blk_clear_queue_full(q, BLK_RW_SYNC);
> +		wake_up(&rl->wait[BLK_RW_SYNC]);
> +	}
> +
> +	if (rl->count[BLK_RW_ASYNC] >= q->nr_requests) {
> +		blk_set_queue_full(q, BLK_RW_ASYNC);
> +	} else if (rl->count[BLK_RW_ASYNC]+1 <= q->nr_requests) {
> +		blk_clear_queue_full(q, BLK_RW_ASYNC);
> +		wake_up(&rl->wait[BLK_RW_ASYNC]);
> +	}
> +	return nr;
> +}
> +EXPORT_SYMBOL(__blk_queue_set_nr_requests);
> +
>  /**
>   * blk_get_backing_dev_info - get the address of a queue's backing_dev_info
>   * @bdev:	device
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 306759b..615198c 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -39,7 +39,6 @@ static ssize_t queue_requests_show(struct request_queue *q, char *page)
>  static ssize_t
>  queue_requests_store(struct request_queue *q, const char *page, size_t count)
>  {
> -	struct request_list *rl = &q->rq;
>  	unsigned long nr;
>  	int ret;
>  
> @@ -47,37 +46,11 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
>  		return -EINVAL;
>  
>  	ret = queue_var_store(&nr, page, count);
> -	if (nr < BLKDEV_MIN_RQ)
> -		nr = BLKDEV_MIN_RQ;
>  
>  	spin_lock_irq(q->queue_lock);
> -	q->nr_requests = nr;
> -	blk_queue_congestion_threshold(q);
> -
> -	if (rl->count[BLK_RW_SYNC] >= queue_congestion_on_threshold(q))
> -		blk_set_queue_congested(q, BLK_RW_SYNC);
> -	else if (rl->count[BLK_RW_SYNC] < queue_congestion_off_threshold(q))
> -		blk_clear_queue_congested(q, BLK_RW_SYNC);
> -
> -	if (rl->count[BLK_RW_ASYNC] >= queue_congestion_on_threshold(q))
> -		blk_set_queue_congested(q, BLK_RW_ASYNC);
> -	else if (rl->count[BLK_RW_ASYNC] < queue_congestion_off_threshold(q))
> -		blk_clear_queue_congested(q, BLK_RW_ASYNC);
> -
> -	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
> -		blk_set_queue_full(q, BLK_RW_SYNC);
> -	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
> -		blk_clear_queue_full(q, BLK_RW_SYNC);
> -		wake_up(&rl->wait[BLK_RW_SYNC]);
> -	}
> -
> -	if (rl->count[BLK_RW_ASYNC] >= q->nr_requests) {
> -		blk_set_queue_full(q, BLK_RW_ASYNC);
> -	} else if (rl->count[BLK_RW_ASYNC]+1 <= q->nr_requests) {
> -		blk_clear_queue_full(q, BLK_RW_ASYNC);
> -		wake_up(&rl->wait[BLK_RW_ASYNC]);
> -	}
> +	__blk_queue_set_nr_requests(q, nr);
>  	spin_unlock_irq(q->queue_lock);
> +
>  	return ret;
>  }
>  
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 9924ea2..c6deff9 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -526,6 +526,18 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  }
>  EXPORT_SYMBOL_GPL(dm_set_device_limits);
>  
> +int dm_set_device_nr_requests(struct dm_target *ti, struct dm_dev *dev,
> +			 sector_t start, sector_t len, void *data)
> +{
> +	unsigned long *nr_requests = data;
> +	struct block_device *bdev = dev->bdev;
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	*nr_requests += q->nr_requests;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dm_set_device_nr_requests);
> +
>  int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  		  struct dm_dev **result)
>  {
> @@ -983,12 +995,13 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
>   * Establish the new table's queue_limits and validate them.
>   */
>  int dm_calculate_queue_limits(struct dm_table *table,
> -			      struct queue_limits *limits)
> +	      struct queue_limits *limits, unsigned long *nr_requests)
>  {
>  	struct dm_target *uninitialized_var(ti);
>  	struct queue_limits ti_limits;
>  	unsigned i = 0;
>  
> +	*nr_requests = 0;
>  	blk_set_default_limits(limits);
>  
>  	while (i < dm_table_get_num_targets(table)) {
> @@ -1005,6 +1018,13 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  		ti->type->iterate_devices(ti, dm_set_device_limits,
>  					  &ti_limits);
>  
> +		/*
> +		 * Combine queue nr_requests limit of all the devices this
> +		 * target uses.
> +		 */
> +		ti->type->iterate_devices(ti, dm_set_device_nr_requests,
> +					  nr_requests);
> +
>  		/* Set I/O hints portion of queue limits */
>  		if (ti->type->io_hints)
>  			ti->type->io_hints(ti, &ti_limits);
> @@ -1074,7 +1094,7 @@ no_integrity:
>  }
>  
>  void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> -			       struct queue_limits *limits)
> +	       struct queue_limits *limits, unsigned long nr_requests)
>  {
>  	/*
>  	 * Copy table's limits to the DM device's request_queue
> @@ -1098,8 +1118,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	 * Those bios are passed to request-based dm at the resume time.
>  	 */
>  	smp_mb();
> -	if (dm_table_request_based(t))
> +	if (dm_table_request_based(t)) {
>  		queue_flag_set_unlocked(QUEUE_FLAG_STACKABLE, q);
> +		__blk_queue_set_nr_requests(q, nr_requests);
> +	}
>  }
>  
>  unsigned int dm_table_get_num_targets(struct dm_table *t)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index d21e128..2d45689 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2052,7 +2052,7 @@ static void __set_size(struct mapped_device *md, sector_t size)
>   * Returns old map, which caller must destroy.
>   */
>  static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
> -			       struct queue_limits *limits)
> +		       struct queue_limits *limits, unsigned long nr_requests)
>  {
>  	struct dm_table *old_map;
>  	struct request_queue *q = md->queue;
> @@ -2083,11 +2083,13 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>  
>  	__bind_mempools(md, t);
>  
> -	write_lock_irqsave(&md->map_lock, flags);
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	write_lock(&md->map_lock);
>  	old_map = md->map;
>  	md->map = t;
> -	dm_table_set_restrictions(t, q, limits);
> -	write_unlock_irqrestore(&md->map_lock, flags);
> +	dm_table_set_restrictions(t, q, limits, nr_requests);
> +	write_unlock(&md->map_lock);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
>  
>  	return old_map;
>  }
> @@ -2390,6 +2392,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
>  	struct dm_table *map = ERR_PTR(-EINVAL);
>  	struct queue_limits limits;
>  	int r;
> +	unsigned long nr_requests;
>  
>  	mutex_lock(&md->suspend_lock);
>  
> @@ -2397,7 +2400,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
>  	if (!dm_suspended_md(md))
>  		goto out;
>  
> -	r = dm_calculate_queue_limits(table, &limits);
> +	r = dm_calculate_queue_limits(table, &limits, &nr_requests);
>  	if (r) {
>  		map = ERR_PTR(r);
>  		goto out;
> @@ -2410,7 +2413,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
>  		goto out;
>  	}
>  
> -	map = __bind(md, table, &limits);
> +	map = __bind(md, table, &limits, nr_requests);
>  
>  out:
>  	mutex_unlock(&md->suspend_lock);
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index bad1724..9e25c48 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -50,9 +50,9 @@ void dm_table_event_callback(struct dm_table *t,
>  struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
>  struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
>  int dm_calculate_queue_limits(struct dm_table *table,
> -			      struct queue_limits *limits);
> +		      struct queue_limits *limits, unsigned long *nr_requests);
>  void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> -			       struct queue_limits *limits);
> +		       struct queue_limits *limits, unsigned long nr_requests);
>  struct list_head *dm_table_get_devices(struct dm_table *t);
>  void dm_table_presuspend_targets(struct dm_table *t);
>  void dm_table_postsuspend_targets(struct dm_table *t);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6690e8b..366bba5 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -934,6 +934,9 @@ extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
>  extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
>  extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
>  extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
> +extern unsigned long __blk_queue_set_nr_requests(struct request_queue *q,
> +							unsigned long nr);
> +
>  extern void blk_set_default_limits(struct queue_limits *lim);
>  extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  			    sector_t offset);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 1381cd9..b0f9443 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -108,6 +108,11 @@ void dm_error(const char *message);
>   */
>  int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  			 sector_t start, sector_t len, void *data);
> +/*
> + * Combine device nr_requests.
> + */
> +int dm_set_device_nr_requests(struct dm_target *ti, struct dm_dev *dev,
> +			 sector_t start, sector_t len, void *data);
>  
>  struct dm_dev {
>  	struct block_device *bdev;
