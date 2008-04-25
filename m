From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] dm: raid1 block-on-error patch
Date: Fri, 25 Apr 2008 10:58:13 -0500
Message-ID: <D43DF1A9-ABF2-4530-BD13-36E7F02C5ED6@redhat.com>
References: <20080401233150.GA19821@us.ibm.com>
	<FD6EF7F6-5CA1-42F3-A0AA-CB558A731331@redhat.com>
	<20080420213405.GA16156@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080420213405.GA16156@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: andmike@us.ibm.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Looks good, but be sure to comment on the new 'U' character in the  
comments for device_status_char()

  brassow

On Apr 20, 2008, at 4:34 PM, malahal@us.ibm.com wrote:

> Removed uevent related changes. "block_on_error" feature implicitly  
> sets
> "handle_errors" feature.
>
> --Malahal.
>
> This patch generates an event on a device failure and does NOT process
> further writes until it receives 'unblock' message. LVM or other tools
> are expected to get the mirorset status upon receiving the above event
> and record the failed device in their metadata, and then send the
> 'unblock' message to the dm-raid1 target.
>
> This would help LVM select the right master device at mirror logical
> volume activation/load time.
>
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
>
> diff -r bfb50ef53671 drivers/md/dm-raid1.c
> --- a/drivers/md/dm-raid1.c	Mon Mar 31 10:13:13 2008 -0700
> +++ b/drivers/md/dm-raid1.c	Sun Apr 20 13:34:00 2008 -0700
> @@ -26,8 +26,10 @@
> #define DM_MSG_PREFIX "raid1"
> #define DM_IO_PAGES 64
>
> -#define DM_RAID1_HANDLE_ERRORS 0x01
> +#define DM_RAID1_HANDLE_ERRORS  0x01
> +#define DM_RAID1_BLOCK_ON_ERROR 0x02
> #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
> +#define block_on_error(p)	((p)->features & DM_RAID1_BLOCK_ON_ERROR)
>
> static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
>
> @@ -148,6 +150,7 @@ struct mirror_set {
> 	region_t nr_regions;
> 	int in_sync;
> 	int log_failure;
> +	int write_blocked;
> 	atomic_t suspend;
>
> 	atomic_t default_mirror;	/* Default mirror */
> @@ -706,6 +709,7 @@ static void fail_mirror(struct mirror *m
> {
> 	struct mirror_set *ms = m->ms;
> 	struct mirror *new;
> +	unsigned long flags;
>
> 	if (!errors_handled(ms))
> 		return;
> @@ -719,6 +723,18 @@ static void fail_mirror(struct mirror *m
>
> 	if (test_and_set_bit(error_type, &m->error_type))
> 		return;
> +
> +	/*
> +	 * Make sure that device failure is recorded in the metadata
> +	 * before allowing any new writes. Agent acting on the following
> +	 * event should query the status of the mirrorset, update
> +	 * metadata accordingly and then send the unblock message.
> +	 */
> +	if (block_on_error(ms)) {
> +		spin_lock_irqsave(&ms->lock, flags);
> +		ms->write_blocked = 1;
> +		spin_unlock_irqrestore(&ms->lock, flags);
> +	}
>
> 	if (m != get_default_mirror(ms))
> 		goto out;
> @@ -835,6 +851,7 @@ static void do_recovery(struct mirror_se
> 	int r;
> 	struct region *reg;
> 	struct dm_dirty_log *log = ms->rh.log;
> +	struct mirror *m;
>
> 	/*
> 	 * Start quiescing some regions.
> @@ -855,6 +872,10 @@ static void do_recovery(struct mirror_se
> 	 */
> 	if (!ms->in_sync &&
> 	    (log->type->get_sync_count(log) == ms->nr_regions)) {
> +		for (m = ms->mirror; m < ms->mirror + ms->nr_mirrors; m++) {
> +			atomic_set(&m->error_count, 0);
> +			m->error_type = 0;
> +		}
> 		/* the sync is complete */
> 		dm_table_event(ms->ti->table);
> 		ms->in_sync = 1;
> @@ -1140,6 +1161,13 @@ static void do_writes(struct mirror_set
> 	if (!writes->head)
> 		return;
>
> +	if (ms->write_blocked) {
> +		spin_lock_irq(&ms->lock);
> +		bio_list_merge(&ms->writes, writes);
> +		spin_unlock_irq(&ms->lock);
> +		return;
> +	}
> +
> 	/*
> 	 * Classify each write.
> 	 */
> @@ -1202,6 +1230,13 @@ static void do_failures(struct mirror_se
>
> 	if (!failures->head)
> 		return;
> +
> +	if (ms->write_blocked) {
> +		spin_lock_irq(&ms->lock);
> +		bio_list_merge(&ms->failures, failures);
> +		spin_unlock_irq(&ms->lock);
> +		return;
> +	}
>
> 	if (!ms->log_failure) {
> 		while ((bio = bio_list_pop(failures)))
> @@ -1327,6 +1362,7 @@ static struct mirror_set *alloc_context(
> 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
> 	ms->in_sync = 0;
> 	ms->log_failure = 0;
> +	ms->write_blocked = 0;
> 	atomic_set(&ms->suspend, 0);
> 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
>
> @@ -1448,6 +1484,7 @@ static int parse_features(struct mirror_
> {
> 	unsigned num_features;
> 	struct dm_target *ti = ms->ti;
> +	int i;
>
> 	*args_used = 0;
>
> @@ -1458,24 +1495,26 @@ static int parse_features(struct mirror_
> 		ti->error = "Invalid number of features";
> 		return -EINVAL;
> 	}
> +	argv++, argc--;
>
> -	argc--;
> -	argv++;
> -	(*args_used)++;
> -
> -	if (num_features > argc) {
> +	if (argc < num_features) {
> 		ti->error = "Not enough arguments to support feature count";
> 		return -EINVAL;
> 	}
>
> -	if (!strcmp("handle_errors", argv[0]))
> -		ms->features |= DM_RAID1_HANDLE_ERRORS;
> -	else {
> -		ti->error = "Unrecognised feature requested";
> -		return -EINVAL;
> +	for (i = 0; i < num_features; i++) {
> +		if (!strcmp("handle_errors", argv[i]))
> +			ms->features |= DM_RAID1_HANDLE_ERRORS;
> +		else if (!strcmp("block_on_error", argv[i])) {
> +			ms->features |= DM_RAID1_BLOCK_ON_ERROR;
> +			ms->features |= DM_RAID1_HANDLE_ERRORS;
> +		} else {
> +			ti->error = "Unrecognised feature requested";
> +			return -EINVAL;
> +		}
> 	}
>
> -	(*args_used)++;
> +	*args_used = 1 + num_features;
>
> 	return 0;
> }
> @@ -1798,8 +1837,14 @@ static void mirror_resume(struct dm_targ
>  */
> static char device_status_char(struct mirror *m)
> {
> -	if (!atomic_read(&(m->error_count)))
> -		return 'A';
> +	struct mirror_set *ms = m->ms;
> +
> +	if (atomic_read(&m->error_count) == 0) {
> +		if (ms->in_sync || get_default_mirror(ms) == m)
> +			return 'A';
> +		else
> +			return 'U';
> +	}
>
> 	return (test_bit(DM_RAID1_WRITE_ERROR, &(m->error_type))) ? 'D' :
> 		(test_bit(DM_RAID1_SYNC_ERROR, &(m->error_type))) ? 'S' :
> @@ -1840,10 +1885,74 @@ static int mirror_status(struct dm_targe
> 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
> 			       (unsigned long long)ms->mirror[m].offset);
>
> -		if (ms->features & DM_RAID1_HANDLE_ERRORS)
> +		/*
> +		 * 'handle_errors' is implicit with 'block_on_error', so
> +		 * check block_on_error first.
> +		 */
> +		if (block_on_error(ms))
> +			DMEMIT(" 1 block_on_error");
> +		else if (errors_handled(ms))
> 			DMEMIT(" 1 handle_errors");
> 	}
>
> +	return 0;
> +}
> +
> +/* unblock message handler
> + *
> + * This message has the mirror device recorded states. If they don't
> + * agree to the actual state in the target, we regenerate uvent. If  
> the
> + * recorded state and the actual state of each device is same, we
> + * unblock the mirrorset to allow writes.
> + */
> +static int mirror_message(struct dm_target *ti, unsigned argc, char  
> **argv)
> +{
> +	struct mirror_set *ms = (struct mirror_set *) ti->private;
> +	char device_status;
> +	char *name;	/* major:minor format */
> +	int i;
> +
> +	if (!block_on_error(ms))
> +		return -EINVAL;
> +	if (argc < 1 || strnicmp(argv[0], "unblock", sizeof("unblock")))
> +		return -EINVAL;
> +	argv++;
> +	argc--;
> +
> +	spin_lock_irq(&ms->lock);
> +	if (!ms->write_blocked)
> +		DMWARN("Received unblock message when not blocked!");
> +	if (argc != 2 * ms->nr_mirrors)
> +		goto error;
> +
> +	for (i = 0; i < ms->nr_mirrors; i++) {
> +		name = argv[2 * i];
> +		if (strncmp(name, ms->mirror[i].dev->name,
> +			   sizeof(ms->mirror[i].dev->name))) {
> +			DMWARN("name %s doesn't match name %s\n", name,
> +			       (ms->mirror[i].dev->name));
> +			goto error;
> +		}
> +		if (sscanf(argv[2 * i + 1], "%c", &device_status) != 1) {
> +			DMWARN("incorrect recorded state value");
> +			goto error;
> +		}
> +
> +		/* Re-generate event if the actual device state has
> +		 * changed since we last reported.
> +		 */
> +		if (device_status != device_status_char(&ms->mirror[i]))
> +			goto error;
> +	}
> +	ms->write_blocked = 0;
> +	spin_unlock_irq(&ms->lock);
> +	wake(ms);
> +	return 0;
> +
> +error:
> +	/* Regenerate the event */
> +	spin_unlock_irq(&ms->lock);
> +	schedule_work(&ms->trigger_event);
> 	return 0;
> }
>
> @@ -1859,6 +1968,7 @@ static struct target_type mirror_target
> 	.postsuspend = mirror_postsuspend,
> 	.resume	 = mirror_resume,
> 	.status	 = mirror_status,
> +	.message = mirror_message,
> };
>
> static int __init dm_mirror_init(void)
