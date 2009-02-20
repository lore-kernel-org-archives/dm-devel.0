From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Thu, 19 Feb 2009 16:45:29 -0800
Message-ID: <1235090729.9614.8.camel@chandra-ubuntu>
References: <200902171917.38252.knikanth@suse.de>
	<20090219021118.GA3962@agk.fab.redhat.com>
	<200902191240.22577.knikanth@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902191240.22577.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


On Thu, 2009-02-19 at 12:40 +0530, Nikanth Karthikesan wrote:

<snip>

> @@ -431,6 +432,7 @@ static void process_queued_ios(struct work_struct *work)
>  	struct pgpath *pgpath = NULL;
>  	unsigned init_required = 0, must_queue = 1;
>  	unsigned long flags;
> +	unsigned long delay = 0;

I do not see the reason for this variable, you can as well put the delay
in pg_init_delay and use it directly (and set it to zero after using
it) ?
> 
>  	spin_lock_irqsave(&m->lock, flags);
> 
> @@ -452,13 +454,15 @@ static void process_queued_ios(struct work_struct *work)
>  		m->pg_init_required = 0;
>  		m->pg_init_in_progress = 1;
>  		init_required = 1;
> +		if (m->pg_init_delay)
> +			delay = SCSI_DH_RETRY_DELAY;
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
> @@ -1060,6 +1064,7 @@ static void pg_init_done(struct dm_path *path, int errors)
>  	struct priority_group *pg = pgpath->pg;
>  	struct multipath *m = pg->m;
>  	unsigned long flags;
> +	unsigned delay = 0;

You can get rid of this variable also and set it directly under
SCSI_DH_RETRY.
> 
>  	/* device or driver problems */
>  	switch (errors) {
> @@ -1084,8 +1089,11 @@ static void pg_init_done(struct dm_path *path, int errors)
>  		 */
>  		bypass_pg(m, pg, 1);
>  		break;
> -	/* TODO: For SCSI_DH_RETRY we should wait a couple seconds */
> +	/*
> +	 * For SCSI_DH_RETRY we wait before retrying.
> +	 */
>  	case SCSI_DH_RETRY:
> +		delay = 1;
>  	case SCSI_DH_IMM_RETRY:
>  	case SCSI_DH_RES_TEMP_UNAVAIL:
>  		if (pg_init_limit_reached(m, pgpath))
> @@ -1112,6 +1120,7 @@ static void pg_init_done(struct dm_path *path, int errors)
>  	}
> 
>  	m->pg_init_in_progress = 0;
> +	m->pg_init_delay = delay;
>  	queue_work(kmultipathd, &m->process_queued_ios);
>  	spin_unlock_irqrestore(&m->lock, flags);
>  }
> @@ -1120,7 +1129,7 @@ static void activate_path(struct work_struct *work)
>  {
>  	int ret;
>  	struct multipath *m =
> -		container_of(work, struct multipath, activate_path);
> +		container_of(work, struct multipath, activate_path.work);
>  	struct dm_path *path;
>  	unsigned long flags;
> 
> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> index 33efce2..f099d86 100644
> --- a/include/scsi/scsi_dh.h
> +++ b/include/scsi/scsi_dh.h
> @@ -55,6 +55,10 @@ enum {
>  	SCSI_DH_NOSYS,
>  	SCSI_DH_DRIVER_MAX,
>  };
> +
> +/* Time to wait before retry in case of SCSI_DH_RETRY */
> +#define SCSI_DH_RETRY_DELAY ((HZ * 2))
> +
>  #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
>  extern int scsi_dh_activate(struct request_queue *);
>  extern int scsi_dh_handler_exist(const char *);
> 
