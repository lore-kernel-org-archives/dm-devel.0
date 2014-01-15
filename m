From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-log-userspace: Allow mark requests to
	piggyback on flush requests
Date: Wed, 15 Jan 2014 15:45:30 -0600
Message-ID: <D089043F-A66D-481F-B24F-46310915EC0F@redhat.com>
References: <1389666600.12232.2.camel@f16>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1389666600.12232.2.camel@f16>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jbrassow@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: msnitzer@redhat.com, dmzhang@suse.de
List-Id: dm-devel.ids

I'm sending a 'v2' of this patch to include some off-line suggestions I received about better comments, etc.

 brassow


On Jan 13, 2014, at 8:30 PM, Jonathan Brassow wrote:

> dm-log-userspace: Allow mark requests to piggyback on flush requests
> 
> In the cluster evironment, cluster write has poor performance.
> Because userspace_flush has to contact userspace program(cmirrord)
> in clear/mark/flush request. But both mark and flush requests
> require cmirrord to circle message to all the cluster nodes in each
> flush call.  This behave is realy slow. So the idea is merging
> mark and flush request together to reduce the kernel-userspace-kernel
> time.  Allow a new directive, "integrated_flush" that can be used to
> instruct the kernel log code to combine flush and mark requests when
> directed by userspace.  Additionlly, flush requests are performed
> lazily when only clear requests exist.
> 
> Signed-off-by: dongmao zhang <dmzhang@suse.com>
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-upstream/drivers/md/dm-log-userspace-base.c
> ===================================================================
> --- linux-upstream.orig/drivers/md/dm-log-userspace-base.c
> +++ linux-upstream/drivers/md/dm-log-userspace-base.c
> @@ -11,9 +11,10 @@
> #include <linux/dm-log-userspace.h>
> #include <linux/module.h>
> 
> +#include <linux/workqueue.h>
> #include "dm-log-userspace-transfer.h"
> 
> -#define DM_LOG_USERSPACE_VSN "1.1.0"
> +#define DM_LOG_USERSPACE_VSN "1.2.0"
> 
> struct flush_entry {
> 	int type;
> @@ -58,6 +59,12 @@ struct log_c {
> 	spinlock_t flush_lock;
> 	struct list_head mark_list;
> 	struct list_head clear_list;
> +
> +	/* work queue for flush clear region */
> +	struct workqueue_struct *dmlog_wq;
> +	struct delayed_work flush_log_work;
> +	atomic_t sched_flush;
> +	uint32_t integrated_flush;
> };
> 
> static mempool_t *flush_entry_pool;
> @@ -141,6 +148,17 @@ static int build_constructor_string(stru
> 	return str_size;
> }
> 
> +static void do_flush(struct work_struct *work)
> +{
> +	int r;
> +	struct log_c *lc = container_of(work, struct log_c, flush_log_work.work);
> +	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
> +				 NULL, 0, NULL, NULL);
> +	atomic_set(&lc->sched_flush, 0);
> +	if (r)
> +		dm_table_event(lc->ti->table);
> +}
> +
> /*
>  * userspace_ctr
>  *
> @@ -199,6 +217,10 @@ static int userspace_ctr(struct dm_dirty
> 		return str_size;
> 	}
> 
> +	lc->integrated_flush = 0;
> +	if (strstr(ctr_str, "integrated_flush"))
> +		lc->integrated_flush = 1;
> +
> 	devices_rdata = kzalloc(devices_rdata_size, GFP_KERNEL);
> 	if (!devices_rdata) {
> 		DMERR("Failed to allocate memory for device information");
> @@ -246,6 +268,19 @@ static int userspace_ctr(struct dm_dirty
> 			DMERR("Failed to register %s with device-mapper",
> 			      devices_rdata);
> 	}
> +
> +	if (lc->integrated_flush) {
> +		lc->dmlog_wq = alloc_workqueue("dmlogd", WQ_MEM_RECLAIM, 0);
> +		if (!lc->dmlog_wq) {
> +			DMERR("couldn't start dmlogd");
> +			r = -ENOMEM;
> +			goto out;
> +		}
> +
> +		INIT_DELAYED_WORK(&lc->flush_log_work, do_flush);
> +		atomic_set(&lc->sched_flush, 0);
> +	}
> +
> out:
> 	kfree(devices_rdata);
> 	if (r) {
> @@ -264,6 +299,14 @@ static void userspace_dtr(struct dm_dirt
> {
> 	struct log_c *lc = log->context;
> 
> +	if (lc->integrated_flush) {
> +		/* flush workqueue */
> +		if (atomic_read(&lc->sched_flush))
> +			flush_delayed_work(&lc->flush_log_work);
> +
> +		destroy_workqueue(lc->dmlog_wq);
> +	}
> +
> 	(void) dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_DTR,
> 				 NULL, 0,
> 				 NULL, NULL);
> @@ -294,6 +337,10 @@ static int userspace_postsuspend(struct
> 	int r;
> 	struct log_c *lc = log->context;
> 
> +	/* run planned flush earlier */
> +	if (lc->integrated_flush && atomic_read(&lc->sched_flush))
> +		flush_delayed_work(&lc->flush_log_work);
> +
> 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_POSTSUSPEND,
> 				 NULL, 0,
> 				 NULL, NULL);
> @@ -405,7 +452,8 @@ static int flush_one_by_one(struct log_c
> 	return r;
> }
> 
> -static int flush_by_group(struct log_c *lc, struct list_head *flush_list)
> +static int flush_by_group(struct log_c *lc, struct list_head *flush_list,
> +			  int flush_with_payload)
> {
> 	int r = 0;
> 	int count;
> @@ -431,15 +479,25 @@ static int flush_by_group(struct log_c *
> 				break;
> 		}
> 
> -		r = userspace_do_request(lc, lc->uuid, type,
> -					 (char *)(group),
> -					 count * sizeof(uint64_t),
> -					 NULL, NULL);
> -		if (r) {
> -			/* Group send failed.  Attempt one-by-one. */
> -			list_splice_init(&tmp_list, flush_list);
> -			r = flush_one_by_one(lc, flush_list);
> -			break;
> +		if (flush_with_payload) {
> +			r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
> +						 (char *)(group),
> +						 count * sizeof(uint64_t),
> +						 NULL, NULL);
> +			/* integrated flush failed */
> +			if (r)
> +				break;
> +		} else {
> +			r = userspace_do_request(lc, lc->uuid, type,
> +						 (char *)(group),
> +						 count * sizeof(uint64_t),
> +						 NULL, NULL);
> +			if (r) {
> +				/* Group send failed.  Attempt one-by-one. */
> +				list_splice_init(&tmp_list, flush_list);
> +				r = flush_one_by_one(lc, flush_list);
> +				break;
> +			}
> 		}
> 	}
> 
> @@ -474,6 +532,8 @@ static int userspace_flush(struct dm_dir
> 	int r = 0;
> 	unsigned long flags;
> 	struct log_c *lc = log->context;
> +	int is_mark_list_empty;
> +	int is_clear_list_empty;
> 	LIST_HEAD(mark_list);
> 	LIST_HEAD(clear_list);
> 	struct flush_entry *fe, *tmp_fe;
> @@ -483,19 +543,46 @@ static int userspace_flush(struct dm_dir
> 	list_splice_init(&lc->clear_list, &clear_list);
> 	spin_unlock_irqrestore(&lc->flush_lock, flags);
> 
> -	if (list_empty(&mark_list) && list_empty(&clear_list))
> +	is_mark_list_empty = list_empty(&mark_list);
> +	is_clear_list_empty = list_empty(&clear_list);
> +
> +	if (is_mark_list_empty && is_clear_list_empty)
> 		return 0;
> 
> -	r = flush_by_group(lc, &mark_list);
> -	if (r)
> -		goto fail;
> +	r = flush_by_group(lc, &clear_list, 0);
> 
> -	r = flush_by_group(lc, &clear_list);
> 	if (r)
> 		goto fail;
> 
> -	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
> -				 NULL, 0, NULL, NULL);
> +	if (lc->integrated_flush) {
> +		/* send flush request with mark_list as payload*/
> +		r = flush_by_group(lc, &mark_list, 1);
> +		if (r)
> +			goto fail;
> +
> +		/*
> +		 * When there is only clear region requests,
> +		 * we plan a flush in the furture.
> +		 */
> +		if (is_mark_list_empty && !atomic_read(&lc->sched_flush)) {
> +			queue_delayed_work(lc->dmlog_wq,
> +					   &lc->flush_log_work, 3 * HZ);
> +			atomic_set(&lc->sched_flush, 1);
> +		} else {
> +			/*
> +			 * Cancel pending flush because we
> +			 * have already flushed in mark_region
> +			 */
> +			cancel_delayed_work(&lc->flush_log_work);
> +			atomic_set(&lc->sched_flush, 0);
> +		}
> +	} else {
> +		r = flush_by_group(lc, &mark_list, 0);
> +		if (r)
> +			goto fail;
> +		r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
> +					 NULL, 0, NULL, NULL);
> +	}
> 
> fail:
> 	/*
> Index: linux-upstream/include/uapi/linux/dm-log-userspace.h
> ===================================================================
> --- linux-upstream.orig/include/uapi/linux/dm-log-userspace.h
> +++ linux-upstream/include/uapi/linux/dm-log-userspace.h
> @@ -201,12 +201,12 @@
>  * int (*flush)(struct dm_dirty_log *log);
>  *
>  * Payload-to-userspace:
> - *	None.
> + *	if DM_INTEGRATED_FLUSH is set, payload is as same as DM_ULOG_MARK_REGION
> + *	uint64_t [] - region(s) to mark
> + *	else None
>  * Payload-to-kernel:
>  *	None.
>  *
> - * No incoming or outgoing payload.  Simply flush log state to disk.
> - *
>  * When the request has been processed, user-space must return the
>  * dm_ulog_request to the kernel - setting the 'error' field and clearing
>  * 'data_size' appropriately.
> @@ -385,8 +385,10 @@
>  *	version 2:  DM_ULOG_CTR allowed to return a string containing a
>  *	            device name that is to be registered with DM via
>  *	            'dm_get_device'.
> + *	version 3:  DM_ULOG_FLUSH is capable to carry payload for marking
> + *	            regions.
>  */
> -#define DM_ULOG_REQUEST_VERSION 2
> +#define DM_ULOG_REQUEST_VERSION 3
> 
> struct dm_ulog_request {
> 	/*
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
