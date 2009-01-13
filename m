From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] Log API addition for cluster-aware dirty log
Date: Tue, 13 Jan 2009 20:09:32 +0100
Message-ID: <1231873772.25734.33.camel@o>
References: <1231524865.24591.3.camel@hydrogen.msp.redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1231524865.24591.3.camel@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids


Good that there's no penalty for single node mirroring.

ACK

Heinz

Am Freitag, den 09.01.2009, 12:14 -0600 schrieb Jonathan Brassow:
> This patch is the same patch as posted in a previous e-mail.  I am
> reposting so that it gets into Patchwork.  The patch for "cluster-aware
> logging module" depends on this.
> 
>  brassow
> 
> The logging API needs an extra function to make cluster mirroring
> possible.  This new function allows us to check whether a mirror
> region is being recovered on another machine in the cluster.  This
> helps us prevent simultaneous recovery I/O and process I/O to the
> same locations on disk.
> 
> Cluster-aware log modules will implement this function.  Single
> machine log modules will not.  So, there is no performance
> penalty for single machine mirrors.
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-2.6/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-raid1.c
> +++ linux-2.6/drivers/md/dm-raid1.c
> @@ -586,6 +586,9 @@ static void do_writes(struct mirror_set 
>  	int state;
>  	struct bio *bio;
>  	struct bio_list sync, nosync, recover, *this_list = NULL;
> +	struct bio_list requeue;
> +	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
> +	region_t region;
>  
>  	if (!writes->head)
>  		return;
> @@ -596,10 +599,18 @@ static void do_writes(struct mirror_set 
>  	bio_list_init(&sync);
>  	bio_list_init(&nosync);
>  	bio_list_init(&recover);
> +	bio_list_init(&requeue);
>  
>  	while ((bio = bio_list_pop(writes))) {
> -		state = dm_rh_get_state(ms->rh,
> -					dm_rh_bio_to_region(ms->rh, bio), 1);
> +		region = dm_rh_bio_to_region(ms->rh, bio);
> +
> +		if (log->type->is_remote_recovering &&
> +		    log->type->is_remote_recovering(log, region)) {
> +			bio_list_add(&requeue, bio);
> +			continue;
> +		}
> +
> +		state = dm_rh_get_state(ms->rh, region, 1);
>  		switch (state) {
>  		case DM_RH_CLEAN:
>  		case DM_RH_DIRTY:
> @@ -619,6 +630,16 @@ static void do_writes(struct mirror_set 
>  	}
>  
>  	/*
> +	 * Add bios that are delayed due to remote recovery
> +	 * back on to the write queue
> +	 */
> +	if (unlikely(requeue.head)) {
> +		spin_lock_irq(&ms->lock);
> +		bio_list_merge(&ms->writes, &requeue);
> +		spin_unlock_irq(&ms->lock);
> +	}
> +
> +	/*
>  	 * Increment the pending counts for any regions that will
>  	 * be written to (writes to recover regions are going to
>  	 * be delayed).
> Index: linux-2.6/include/linux/dm-dirty-log.h
> ===================================================================
> --- linux-2.6.orig/include/linux/dm-dirty-log.h
> +++ linux-2.6/include/linux/dm-dirty-log.h
> @@ -113,6 +113,16 @@ struct dm_dirty_log_type {
>  	 */
>  	int (*status)(struct dm_dirty_log *log, status_type_t status_type,
>  		      char *result, unsigned maxlen);
> +
> +	/*
> +	 * is_remote_recovering is necessary for cluster mirroring. It provides
> +	 * a way to detect recovery on another node, so we aren't writing
> +	 * concurrently.  This function is likely to block (when a cluster log
> +	 * is used).
> +	 *
> +	 * Returns: 0, 1
> +	 */
> +	int (*is_remote_recovering)(struct dm_dirty_log *log, region_t region);
>  };
>  
>  int dm_dirty_log_type_register(struct dm_dirty_log_type *type);
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
