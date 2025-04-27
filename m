Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48B3D3B8
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 09:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745747567; cv=none; b=n0zlPBT6iq7zKUEft88E8qSAv71Tp8SvblQwfP/rKHNTPjJvKENu+XKj6Smgjf3cjPxIAOvF3EnoHMl8plAJ2CXz5P3DMdI+F8nmc0VkEViZcFZBGFfse0oSCoMzHTZ7QZQ5lCXwbXX/kaCRTq5kyPw+ct/addwCYlYIN/tncco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745747567; c=relaxed/simple;
	bh=l/dPRSbdeaoAEBtT40e/SJGVfPELqZTUCNpsYwno6gY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h094K2ZaR8WDtJcY3jCUoVX6Gp62t582m5dxTgh6rNWqiBQ3eRn9FYbdx0EQfN//zPPKNbg9SxBjmWZvJ69LJAUC1Ri36kc2NXUtAHdfUNBmWJRrHO3kbckY/t0HFzeIFLDSZBR+WgJKod/aeT3qxPvJn6k+cnLhmOTc2nHL3LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (ip5f5aecdf.dynamic.kabel-deutschland.de [95.90.236.223])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 27DCE61E647A7;
	Sun, 27 Apr 2025 11:51:33 +0200 (CEST)
Message-ID: <fefeda56-6b28-45b8-bc35-75f537613142@molgen.mpg.de>
Date: Sun, 27 Apr 2025 11:51:31 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] md: fix is_mddev_idle()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com, ubizjak@gmail.com,
 akpm@linux-foundation.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-9-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250427082928.131295-9-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Thank you for your patch.


Am 27.04.25 um 10:29 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> If sync_speed is above speed_min, then is_mddev_idle() will be called
> for each sync IO to check if the array is idle, and inflihgt sync_io

infli*gh*t

> will be limited if the array is not idle.
> 
> However, while mkfs.ext4 for a large raid5 array while recovery is in
> progress, it's found that sync_speed is already above speed_min while
> lots of stripes are used for sync IO, causing long delay for mkfs.ext4.
> 
> Root cause is the following checking from is_mddev_idle():
> 
> t1: submit sync IO: events1 = completed IO - issued sync IO
> t2: submit next sync IO: events2  = completed IO - issued sync IO
> if (events2 - events1 > 64)
> 
> For consequence, the more sync IO issued, the less likely checking will
> pass. And when completed normal IO is more than issued sync IO, the
> condition will finally pass and is_mddev_idle() will return false,
> however, last_events will be updated hence is_mddev_idle() can only
> return false once in a while.
> 
> Fix this problem by changing the checking as following:
> 
> 1) mddev doesn't have normal IO completed;
> 2) mddev doesn't have normal IO inflight;
> 3) if any member disks is partition, and all other partitions doesn't
>     have IO completed.

Do you have benchmarks of mkfs.ext4 before and after your patch? It’d be 
great if you added those.

> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 84 +++++++++++++++++++++++++++----------------------
>   drivers/md/md.h |  3 +-
>   2 files changed, 48 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 541151bcfe81..955efe0b40c6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8625,50 +8625,58 @@ void md_cluster_stop(struct mddev *mddev)
>   	put_cluster_ops(mddev);
>   }
>   
> -static int is_mddev_idle(struct mddev *mddev, int init)
> +static bool is_rdev_holder_idle(struct md_rdev *rdev, bool init)
>   {
> +	unsigned long last_events = rdev->last_events;
> +
> +	if (!bdev_is_partition(rdev->bdev))
> +		return true;

Will the compiler generate code, that the assignment happens after this 
condition?

> +
> +	/*
> +	 * If rdev is partition, and user doesn't issue IO to the array, the
> +	 * array is still not idle if user issues IO to other partitions.
> +	 */
> +	rdev->last_events = part_stat_read_accum(rdev->bdev->bd_disk->part0,
> +						 sectors) -
> +			    part_stat_read_accum(rdev->bdev, sectors);
> +
> +	if (!init && rdev->last_events > last_events)
> +		return false;
> +
> +	return true;

Could be one return statement, couldn’t it?

     return init || rdev->last_events <= last_events;

> +}
> +
> +/*
> + * mddev is idle if following conditions are match since last check:

… *the* following condition are match*ed* …

(or are met)

> + * 1) mddev doesn't have normal IO completed;
> + * 2) mddev doesn't have inflight normal IO;
> + * 3) if any member disk is partition, and other partitions doesn't have IO

don’t

> + *    completed;
> + *
> + * Noted this checking rely on IO accounting is enabled.
> + */
> +static bool is_mddev_idle(struct mddev *mddev, int init)
> +{
> +	unsigned long last_events = mddev->normal_IO_events;
> +	struct gendisk *disk;
>   	struct md_rdev *rdev;
> -	int idle;
> -	int curr_events;
> +	bool idle = true;
>   
> -	idle = 1;
> -	rcu_read_lock();
> -	rdev_for_each_rcu(rdev, mddev) {
> -		struct gendisk *disk = rdev->bdev->bd_disk;
> +	disk = mddev_is_dm(mddev) ? mddev->dm_gendisk : mddev->gendisk;
> +	if (!disk)
> +		return true;
>   
> -		if (!init && !blk_queue_io_stat(disk->queue))
> -			continue;
> +	mddev->normal_IO_events = part_stat_read_accum(disk->part0, sectors);
> +	if (!init && (mddev->normal_IO_events > last_events ||
> +		      bdev_count_inflight(disk->part0)))
> +		idle = false;
>   
> -		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
> -			      atomic_read(&disk->sync_io);
> -		/* sync IO will cause sync_io to increase before the disk_stats
> -		 * as sync_io is counted when a request starts, and
> -		 * disk_stats is counted when it completes.
> -		 * So resync activity will cause curr_events to be smaller than
> -		 * when there was no such activity.
> -		 * non-sync IO will cause disk_stat to increase without
> -		 * increasing sync_io so curr_events will (eventually)
> -		 * be larger than it was before.  Once it becomes
> -		 * substantially larger, the test below will cause
> -		 * the array to appear non-idle, and resync will slow
> -		 * down.
> -		 * If there is a lot of outstanding resync activity when
> -		 * we set last_event to curr_events, then all that activity
> -		 * completing might cause the array to appear non-idle
> -		 * and resync will be slowed down even though there might
> -		 * not have been non-resync activity.  This will only
> -		 * happen once though.  'last_events' will soon reflect
> -		 * the state where there is little or no outstanding
> -		 * resync requests, and further resync activity will
> -		 * always make curr_events less than last_events.
> -		 *
> -		 */
> -		if (init || curr_events - rdev->last_events > 64) {
> -			rdev->last_events = curr_events;
> -			idle = 0;
> -		}
> -	}
> +	rcu_read_lock();
> +	rdev_for_each_rcu(rdev, mddev)
> +		if (!is_rdev_holder_idle(rdev, init))
> +			idle = false;
>   	rcu_read_unlock();
> +
>   	return idle;
>   }
>   
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b57842188f18..da3fd514d20c 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -132,7 +132,7 @@ struct md_rdev {
>   
>   	sector_t sectors;		/* Device size (in 512bytes sectors) */
>   	struct mddev *mddev;		/* RAID array if running */
> -	int last_events;		/* IO event timestamp */
> +	unsigned long last_events;	/* IO event timestamp */

Please mention in the commit message, why the type is changed.

>   
>   	/*
>   	 * If meta_bdev is non-NULL, it means that a separate device is
> @@ -520,6 +520,7 @@ struct mddev {
>   							 * adding a spare
>   							 */
>   
> +	unsigned long			normal_IO_events; /* IO event timestamp */

Make everything lower case?

>   	atomic_t			recovery_active; /* blocks scheduled, but not written */
>   	wait_queue_head_t		recovery_wait;
>   	sector_t			recovery_cp;


Kind regards,

Paul
