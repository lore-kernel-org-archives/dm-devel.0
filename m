From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH RFC] dm-raid1: keep writing after leg failure
Date: Wed, 08 Apr 2015 14:27:40 +0200
Message-ID: <55251EBC.3060101@redhat.com>
References: <1428033061-5625-1-git-send-email-lzhong@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1428033061-5625-1-git-send-email-lzhong@suse.com>
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
Cc: Lidong Zhong <lzhong@suse.com>
List-Id: dm-devel.ids

Lidong,

please see the patch series of 3 in response with $Subject.

Heinz

On 04/03/2015 05:51 AM, Lidong Zhong wrote:
> Currently if there is a leg failure, the bio will be put into the hold
> list until userspace replace/remove the leg. Here we are trying to make
> dm-raid1 ignore the failure and keep the following bios going on.
> This is because there maybe a temporary path failure in clvmd
> which leads to cluster raid1 remove/replace the fake device failure. And
> it takes a long time to do the full sync if we readd the device back.
> ---
>   drivers/md/dm-raid1.c | 30 ++++++++++++++++++++++++++----
>   1 file changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> index 9584443..e237c42 100644
> --- a/drivers/md/dm-raid1.c
> +++ b/drivers/md/dm-raid1.c
> @@ -24,7 +24,9 @@
>   #define MAX_RECOVERY 1	/* Maximum number of regions recovered in parallel. */
>   
>   #define DM_RAID1_HANDLE_ERRORS 0x01
> +#define DM_RAID1_KEEP_LOG      0x02
>   #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
> +#define keep_log(p)	        ((p)->features & DM_RAID1_KEEP_LOG)
>   
>   static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
>   
> @@ -750,7 +752,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
>   		dm_rh_delay(ms->rh, bio);
>   
>   	while ((bio = bio_list_pop(&nosync))) {
> -		if (unlikely(ms->leg_failure) && errors_handled(ms)) {
> +		if (unlikely(ms->leg_failure) && errors_handled(ms) && !keep_log(ms)) {
>   			spin_lock_irq(&ms->lock);
>   			bio_list_add(&ms->failures, bio);
>   			spin_unlock_irq(&ms->lock);
> @@ -800,9 +802,19 @@ static void do_failures(struct mirror_set *ms, struct bio_list *failures)
>   		 * be wrong if the failed leg returned after reboot and
>   		 * got replicated back to the good legs.)
>   		 */
> -		if (!get_valid_mirror(ms))
> +
> +		/*
> +		 * we return EIO when the log device is failed if keep_log is set
> +		 */
> +		if (!get_valid_mirror(ms) || (keep_log(ms) && !ms->log_failure))
>   			bio_endio(bio, -EIO);
> -		else if (errors_handled(ms))
> +		/*
> +		 * After the userspace get noticed that the leg has failed,
> +		 * we just pretend that the bio has suceeded since the region
> +		 * has already been marked nosync. It's OK do the recovery after
> +		 * the device comes back
> +		 */
> +		else if (errors_handled(ms) && !keep_log(ms))
>   			hold_bio(ms, bio);
>   		else
>   			bio_endio(bio, 0);
> @@ -1005,8 +1017,15 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
>   		return -EINVAL;
>   	}
>   
> +	argc--;
> +	argv++;
>   	(*args_used)++;
>   
> +	if (!strcmp("keep_log", argv[0])) {
> +		ms->features |= DM_RAID1_KEEP_LOG;
> +		(*args_used)++;
> +	}
> +
>   	return 0;
>   }
>   
> @@ -1382,8 +1401,11 @@ static void mirror_status(struct dm_target *ti, status_type_t type,
>   			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
>   			       (unsigned long long)ms->mirror[m].offset);
>   
> -		if (ms->features & DM_RAID1_HANDLE_ERRORS)
> +		if (errors_handled(ms) && keep_log(ms))
> +			DMEMIT(" 2 handle_errors keep_log");
> +		else if (errors_handled(ms))
>   			DMEMIT(" 1 handle_errors");
> +
>   	}
>   }
>   
