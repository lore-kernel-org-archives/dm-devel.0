From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Wed, 18 Feb 2009 17:55:46 -0800
Message-ID: <1235008546.15552.60.camel@chandra-ubuntu>
References: <200902171917.38252.knikanth@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902171917.38252.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Nikanth,

Thanks for the patch.

Please see my comment below.

chandra
On Tue, 2009-02-17 at 19:17 +0530, Nikanth Karthikesan wrote:
> Delay retry to activate_path if it returns SCSI_DH_RETRY.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 095f77b..af54632 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -65,12 +65,14 @@ struct multipath {
>  	spinlock_t lock;
> 
>  	const char *hw_handler_name;
> -	struct work_struct activate_path;
> +	struct delayed_work activate_path;
>  	struct pgpath *pgpath_to_activate;
>  	unsigned nr_priority_groups;
>  	struct list_head priority_groups;
>  	unsigned pg_init_required;	/* pg_init needs calling? */
>  	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
> +	unsigned long pg_init_jiffy;	/* To delay retry if SCSI_DH_RETRY */
> +#define SCSI_DH_RETRY_DELAY ((HZ * 2))
> 
>  	unsigned nr_valid_paths;	/* Total number of usable paths */
>  	struct pgpath *current_pgpath;
> @@ -203,7 +205,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
>  		m->queue_io = 1;
>  		INIT_WORK(&m->process_queued_ios, process_queued_ios);
>  		INIT_WORK(&m->trigger_event, trigger_event);
> -		INIT_WORK(&m->activate_path, activate_path);
> +		INIT_DELAYED_WORK(&m->activate_path, activate_path);
>  		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
>  		if (!m->mpio_pool) {
>  			kfree(m);
> @@ -431,6 +433,8 @@ static void process_queued_ios(struct work_struct *work)
>  	struct pgpath *pgpath = NULL;
>  	unsigned init_required = 0, must_queue = 1;
>  	unsigned long flags;
> +	unsigned long delay = 0;
> +	unsigned long now;
> 
>  	spin_lock_irqsave(&m->lock, flags);
> 
> @@ -452,13 +456,20 @@ static void process_queued_ios(struct work_struct *work)
>  		m->pg_init_required = 0;
>  		m->pg_init_in_progress = 1;
>  		init_required = 1;
> +		/* Delay retry due to SCSI_DH_RETRY */
> +		if (m->pg_init_jiffy) {
> +			now = jiffies;
> +			if (time_after(now, m->pg_init_jiffy))
> +				delay = now - m->pg_init_jiffy;

I think the logic is reversed. Acc to linux/jiffies.h, "time_after(a,b)
returns true if time a is after time b",

We want it other way around, don't we ?

IMO, we need _not_ be so critical of the time. We could just set a flag
in pg_init_done and use 2 seconds in queue_delayed_work().

> +			m->pg_init_jiffy = 0;
> +		}
>  	}
> 
>  out:
>  	spin_unlock_irqrestore(&m->lock, flags);
> 
>  	if (init_required)
> -		queue_work(kmpath_handlerd, &m->activate_path);
> +		queue_delayed_work(kmpath_handlerd, &m->activate_path, delay);
> 
>  	if (!must_queue)
>  		dispatch_queued_ios(m);
> @@ -1060,6 +1071,7 @@ static void pg_init_done(struct dm_path *path, int errors)
>  	struct priority_group *pg = pgpath->pg;
>  	struct multipath *m = pg->m;
>  	unsigned long flags;
> +	bool delay = false;
> 
>  	/* device or driver problems */
>  	switch (errors) {
> @@ -1084,8 +1096,11 @@ static void pg_init_done(struct dm_path *path, int errors)
>  		 */
>  		bypass_pg(m, pg, 1);
>  		break;
> -	/* TODO: For SCSI_DH_RETRY we should wait a couple seconds */
> +	/*
> +	 * For SCSI_DH_RETRY we wait for a couple seconds.
> +	 */
>  	case SCSI_DH_RETRY:
> +		delay = true;
>  	case SCSI_DH_IMM_RETRY:
>  	case SCSI_DH_RES_TEMP_UNAVAIL:
>  		if (pg_init_limit_reached(m, pgpath))
> @@ -1112,6 +1127,10 @@ static void pg_init_done(struct dm_path *path, int errors)
>  	}
> 
>  	m->pg_init_in_progress = 0;
> +	if  (delay)
> +		m->pg_init_jiffy = jiffies + SCSI_DH_RETRY_DELAY;
> +	else
> +		m->pg_init_jiffy = 0;
>  	queue_work(kmultipathd, &m->process_queued_ios);
>  	spin_unlock_irqrestore(&m->lock, flags);
>  }
> @@ -1120,7 +1139,7 @@ static void activate_path(struct work_struct *work)
>  {
>  	int ret;
>  	struct multipath *m =
> -		container_of(work, struct multipath, activate_path);
> +		container_of(work, struct multipath, activate_path.work);
>  	struct dm_path *path;
>  	unsigned long flags;
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
