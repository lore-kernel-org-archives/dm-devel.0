From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 1/1] improve the performance of
	dm-log-userspace
Date: Tue, 29 Oct 2013 20:35:25 -0500
Message-ID: <D4C8E9BD-319B-4092-B04C-2A99C2142A66@redhat.com>
References: <yes> <cover.1382949020.git.dmzhang@suse.com>
	<c1067c46d7efaedb66aca13afe09708cbefaba88.1382949021.git.dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c1067c46d7efaedb66aca13afe09708cbefaba88.1382949021.git.dmzhang@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: dongmao zhang <dmzhang@suse.com>
List-Id: dm-devel.ids

Dongmao,

I like what's going on here.  I makes a lot more sense to me.  A few more tweaks and corrections and I'll ack it.

Please see the in-line comments I've made to the patch below.  Before getting to that though, I'd like to talk about how all this is going to work in terms of compatibility:

1) New kernel + New userspace
This obviously will work fine.  I think it can be simplified though.  DEFINITELY bump the version number of DM_ULOG_REQUEST_VERSION to 3.  However, I don't think you need much other complexity - like changing what the userspace CTR returns.  Userspace should send the extra parameter "integrated_flush" and the kernel should 'strstr' for that to turn it on in the kernel, but the kernel should then just pass on the CTR string to userspace and that should be the end of it.

2) Old kernel + New userspace
Userspace will attempt to pass down the "integrated_flush" parameter, but the kernel will not be checking for it.  Therefore, old kernels will obviously not turn on the feature and will pass along the CTR string without altering it.  The new userspace should be capable of handling flushes with and without a payload and can tell which is which by whether they have that payload or not.  So, userspace can handle both old and new kernels and this scenario should work just fine.

3) New kernel + Old userspace
Old userspace will never send down a "integrated_flush" parameter.  Therefore, it will never be turned on in the kernel and this scenario should work just fine.

I think we can simplify the patches quite a bit by understanding the compatibility issues and methods above.  Keep them in mind for this kernel patch and the upcoming userspace patches.

 brassow


On Oct 28, 2013, at 5:07 AM, dongmao zhang wrote:

> In the cluster evironment, cluster write has poor performance.
> Because userspace_flush has to contact userspace program(cmirrord)
> in clear/mark/flush request. But both mark and flush requests
> require cmirrord to circle message to all the cluster nodes in each
> flush call.  This behave is realy slow. So the idea is merging
> mark and flush request together to reduce the kernel-userspace-kernel
> time. Add a new flag DM_INTEGRATED_FLUSH to tell userspace application
> that kernel has a flush with mark_region data. Besides, when only sending
> clear request, the flush request could be delayed.
> Added a workqueue to run delayed flush request.
> 
> Signed-off-by: dongmao zhang <dmzhang@suse.com>
> ---
> drivers/md/dm-log-userspace-base.c    |  133 +++++++++++++++++++++++++++++----
> include/uapi/linux/dm-log-userspace.h |    6 +-
> 2 files changed, 121 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
> index 9429159..d22949f 100644
> --- a/drivers/md/dm-log-userspace-base.c
> +++ b/drivers/md/dm-log-userspace-base.c
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
> @@ -29,6 +30,8 @@ struct flush_entry {
>  */
> #define MAX_FLUSH_GROUP_COUNT 32
> 
> +#define DM_INTEGRATED_FLUSH "integrated_flush"
> +

Don't need this define, I don't think.

> struct log_c {
> 	struct dm_target *ti;
> 	struct dm_dev *log_dev;
> @@ -58,6 +61,12 @@ struct log_c {
> 	spinlock_t flush_lock;
> 	struct list_head mark_list;
> 	struct list_head clear_list;
> +
> +	/*work queue for flush clear region*/
> +	struct workqueue_struct *dmlog_wq;
> +	struct delayed_work flush_log_work;
> +	atomic_t sched_flush;
> +	uint32_t integrated_flush;
> };
> 
> static mempool_t *flush_entry_pool;
> @@ -141,6 +150,19 @@ static int build_constructor_string(struct dm_target *ti,
> 	return str_size;
> }
> 
> +static void do_flush(struct delayed_work *work)
> +{
> +	int r;
> +	struct log_c *lc = container_of(work, struct log_c, flush_log_work);
> +	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
> +						 NULL, 0, NULL, NULL);

bad indent.

> +	atomic_set(&lc->sched_flush, 0);
> +	if (r)
> +		dm_table_event(lc->ti->table);
> +}
> +
> +
> +

2 unnecessary newlines?  There are other places below that include unnecessary whitespace.  I will mark them as 'SP'.  In general, there is no need for 2 newlines in a row.  Don't over-add whitespace.

> /*
>  * userspace_ctr
>  *
> @@ -164,7 +186,11 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
> 	uint64_t rdata;
> 	size_t rdata_size = sizeof(rdata);
> 	char *devices_rdata = NULL;
> -	size_t devices_rdata_size = DM_NAME_LEN;
> +
> +	char *logdev = NULL;
> +	char *integrated_flush_string = NULL;

won't need these variables soon.

> +
> +	size_t devices_rdata_size = DM_NAME_LEN + sizeof(DM_INTEGRATED_FLUSH);

2xSP - don't need newlines between variable declarations/init.


> 
> 	if (argc < 3) {
> 		DMWARN("Too few arguments to userspace dirty log");
> @@ -234,18 +260,43 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
> 	lc->region_size = (uint32_t)rdata;
> 	lc->region_count = dm_sector_div_up(ti->len, lc->region_size);
> 
> +

SP

> +	lc->integrated_flush = 0;
> +
> 	if (devices_rdata_size) {
> 		if (devices_rdata[devices_rdata_size - 1] != '\0') {
> 			DMERR("DM_ULOG_CTR device return string not properly terminated");
> 			r = -EINVAL;
> 			goto out;
> 		}
> -		r = dm_get_device(ti, devices_rdata,
> +
> +		logdev = strsep(&devices_rdata, " ");
> +		integrated_flush_string = strsep(&devices_rdata, " ");

Don't make userspace return this.  Just check the CTR string for "integrated_flush" as it is being passed through to the log server.

> +
> +		if (integrated_flush_string &&
> +			!strcmp(integrated_flush_string, DM_INTEGRATED_FLUSH))

bad indent?

> +			lc->integrated_flush = 1;
> +
> +		r = dm_get_device(ti, logdev,
> 				  dm_table_get_mode(ti->table), &lc->log_dev);
> 		if (r)
> 			DMERR("Failed to register %s with device-mapper",
> -			      devices_rdata);
> +			      logdev);
> +	}
> +
> +	if (lc->integrated_flush) {
> +		lc->dmlog_wq =  alloc_workqueue("dmlogd",
> +				WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);

bad indent?

> +		if (!lc->dmlog_wq) {
> +			DMERR("couldn't start dmlogd");
> +			r = -ENOMEM;
> +			goto out;
> +		}
> +
> +		INIT_DELAYED_WORK(&lc->flush_log_work, do_flush);
> +		atomic_set(&lc->sched_flush, 0);
> 	}
> +
> out:
> 	kfree(devices_rdata);
> 	if (r) {
> @@ -264,6 +315,15 @@ static void userspace_dtr(struct dm_dirty_log *log)
> {
> 	struct log_c *lc = log->context;
> 
> +	if (lc->integrated_flush) {
> +		/*flush workqueue*/
> +		if (atomic_read(&lc->sched_flush))
> +			flush_delayed_work(&lc->flush_log_work);
> +
> +		flush_workqueue(lc->dmlog_wq);
> +		destroy_workqueue(lc->dmlog_wq);
> +	}
> +
> 	(void) dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_DTR,
> 				 NULL, 0,
> 				 NULL, NULL);
> @@ -294,6 +354,10 @@ static int userspace_postsuspend(struct dm_dirty_log *log)
> 	int r;
> 	struct log_c *lc = log->context;
> 
> +	/*run planed flush earlier*/

space between comment markers and words?  like, /* run ... earlier */

> +	if (lc->integrated_flush && atomic_read(&lc->sched_flush))
> +		flush_delayed_work(&lc->flush_log_work);
> +
> 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_POSTSUSPEND,
> 				 NULL, 0,
> 				 NULL, NULL);
> @@ -405,7 +469,8 @@ static int flush_one_by_one(struct log_c *lc, struct list_head *flush_list)
> 	return r;
> }
> 
> -static int flush_by_group(struct log_c *lc, struct list_head *flush_list)
> +static int flush_by_group(struct log_c *lc, struct list_head *flush_list,
> +		int flush_with_payload)
> {
> 	int r = 0;
> 	int count;
> @@ -431,10 +496,21 @@ static int flush_by_group(struct log_c *lc, struct list_head *flush_list)
> 				break;
> 		}
> 
> -		r = userspace_do_request(lc, lc->uuid, type,
> -					 (char *)(group),
> -					 count * sizeof(uint64_t),
> -					 NULL, NULL);
> +		if (flush_with_payload) {
> +			r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
> +						 (char *)(group),
> +						 count * sizeof(uint64_t),
> +						 NULL, NULL);
> +			/* integrated flush failed */
> +			if (r)
> +				return r;
> +		}
> +		else
> +			r = userspace_do_request(lc, lc->uuid, type,
> +						 (char *)(group),
> +						 count * sizeof(uint64_t),
> +						 NULL, NULL);
> +
> 		if (r) {
> 			/* Group send failed.  Attempt one-by-one. */
> 			list_splice_init(&tmp_list, flush_list);

If group send fails, I don't think the fallback 'flush_one_by_one' will perform a flush - I think you need something in that function.


> @@ -452,6 +528,7 @@ static int flush_by_group(struct log_c *lc, struct list_head *flush_list)
> 	return r;
> }
> 
> +

SP

> /*
>  * userspace_flush
>  *
> @@ -474,6 +551,8 @@ static int userspace_flush(struct dm_dirty_log *log)
> 	int r = 0;
> 	unsigned long flags;
> 	struct log_c *lc = log->context;
> +	int is_mark_list_empty;
> +	int is_clear_list_empty;
> 	LIST_HEAD(mark_list);
> 	LIST_HEAD(clear_list);
> 	struct flush_entry *fe, *tmp_fe;
> @@ -483,19 +562,41 @@ static int userspace_flush(struct dm_dirty_log *log)
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
> +	} else {
> +		r = flush_by_group(lc, &mark_list, 0);
> +		if (r)
> +			goto fail;
> +		r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
> +					NULL, 0, NULL, NULL);

bad indent?

> +	}
> +
> +

Take the following block...
> +	/* when only has clear region,we plan a flush in the furture */
> +	if (!is_clear_list_empty && is_mark_list_empty
> +				 && !atomic_read(&lc->sched_flush)) {

'&&' goes on previous line and !atomic_read lines up with !is_clear_list_empty.

> +		queue_delayed_work(lc->dmlog_wq, &lc->flush_log_work , 3 * HZ);
> +		atomic_set(&lc->sched_flush, 1);
> +	/* cancel pending flush because we have already flushed in mark_region*/
> +	} else {
> +		cancel_delayed_work(&lc->flush_log_work);
> +		atomic_set(&lc->sched_flush, 0);
> +	}

... and push it into the (lc->integrated_flush) condition above, like you mentioned.

> +
> +

2xSP

> 
> fail:
> 	/*
> diff --git a/include/uapi/linux/dm-log-userspace.h b/include/uapi/linux/dm-log-userspace.h
> index 0678c2a..e91014e 100644
> --- a/include/uapi/linux/dm-log-userspace.h
> +++ b/include/uapi/linux/dm-log-userspace.h
> @@ -201,7 +201,9 @@
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

There are other things that must be adjusted in this comment block, like:
"No incoming or outgoing payload" - that is no longer true.

> @@ -386,7 +388,7 @@
>  *	            device name that is to be registered with DM via
>  *	            'dm_get_device'.
>  */
> -#define DM_ULOG_REQUEST_VERSION 2
> +#define DM_ULOG_REQUEST_VERSION 3

You should adjust the comment to show what 'version 3' supports - as was done for 1 and 2.
