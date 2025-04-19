Received: from mail-108-mta78.mxroute.com (mail-108-mta78.mxroute.com [136.175.108.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7103D4690
	for <dm-devel@lists.linux.dev>; Sat, 19 Apr 2025 01:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745027287; cv=none; b=rvhSezGJRJOeU3inhYNZa4iY5AiCV1mLHrReT7k3Qy2pzbQxNjj8lPlNCeGn4oVqFWH+ePPMrgeFDSMNm8IOspOdhfP+YSUqADcq18LzpMEeYYN3sopUJfkxg8r8pBrBD04h6ztPzqLMxCSYDpfbKyNzbTtE2vzYnQyGdYoDBIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745027287; c=relaxed/simple;
	bh=E23HojiBCDQm668agyazD1CgtWX2wTfX548cbfwdXZo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=C1nc44S8/Y5zmgNG4XMcj+O97m29+j0rCH66PwmFIG0k6nNetUbcD1NhIlkf97zHKtrgUueoj6mb5J/GhiSxfKZw57u+qAqfQt/quXH+fy1C/W9pdheDDQw2rTe51ZA5jcbyzZlnEJnkwIx57tOCGs18mQd4SacB+DYxgztEXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=kkPtXH1u; arc=none smtp.client-ip=136.175.108.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="kkPtXH1u"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta78.mxroute.com (ZoneMTA) with ESMTPSA id 1964bb688540008631.00d
 for <dm-devel@lists.linux.dev>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 19 Apr 2025 01:42:55 +0000
X-Zone-Loop: 5225d0d0640128ce5a29deb79ded3d6fe16b208adbdd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:
	From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=z3vc92CKn5rDfM7OM+NMpirJC3kg2hsFe0C+DKaOL1I=; b=kkPtXH1upBLs
	R9uezvsc2q1aGzUfRiK3ttThGT/tniY0tO/xENFETvwNwEklMdtfssQAvo3TJjLWwaIw/n0Vz0alT
	PpSBu54QKver+M7is2NszhZLjIIZIQPLAqzNP689jps8DOmKp+GutZoS5SGjcRdjfZ7n2Xiyvj787
	ZQFAswrO8gCMqy2Mmy2XCmZtUkVV4ObfEmV/c9crnV5isSfKB1B07bXwnEAXvoCytXKzlkuhBnvhL
	gkqLM/K97YCYIdLSSwDKOyrtHgz2FMCrn5qJeAaot0pbP/+L748R9LqvOKrgVZwshc106khfzrW5V
	wSTu2LTLOzsRzNm6ADNR6Q==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk,  xni@redhat.com,  agk@redhat.com,  snitzer@kernel.org,
  mpatocka@redhat.com,  song@kernel.org,  yukuai3@huawei.com,
  viro@zeniv.linux.org.uk,  akpm@linux-foundation.org,
  nadav.amit@gmail.com,  ubizjak@gmail.com,  cl@linux.com,
  linux-block@vger.kernel.org,  linux-kernel@vger.kernel.org,
  dm-devel@lists.linux.dev,  linux-raid@vger.kernel.org,
  yi.zhang@huawei.com,  yangerkun@huawei.com,  johnny.chenyi@huawei.com
Subject: Re: [PATCH v2 4/5] md: fix is_mddev_idle()
In-Reply-To: <20250418010941.667138-5-yukuai1@huaweicloud.com> (Yu Kuai's
	message of "Fri, 18 Apr 2025 09:09:40 +0800")
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
	<20250418010941.667138-5-yukuai1@huaweicloud.com>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Sat, 19 Apr 2025 09:42:28 +0800
Message-ID: <v7r19baz.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Fri 18 Apr 2025 at 09:09, Yu Kuai <yukuai1@huaweicloud.com> 
wrote:

> From: Yu Kuai <yukuai3@huawei.com>
>
> If sync_speed is above speed_min, then is_mddev_idle() will be 
> called
> for each sync IO to check if the array is idle, and inflihgt 
> sync_io
> will be limited if the array is not idle.
>
> However, while mkfs.ext4 for a large raid5 array while recovery 
> is in
> progress, it's found that sync_speed is already above speed_min 
> while
> lots of stripes are used for sync IO, causing long delay for 
> mkfs.ext4.
>
> Root cause is the following checking from is_mddev_idle():
>
> t1: submit sync IO: events1 = completed IO - issued sync IO
> t2: submit next sync IO: events2  = completed IO - issued sync 
> IO
> if (events2 - events1 > 64)
>
> For consequence, the more sync IO issued, the less likely 
> checking will
> pass. And when completed normal IO is more than issued sync IO, 
> the
> condition will finally pass and is_mddev_idle() will return 
> false,
> however, last_events will be updated hence is_mddev_idle() can 
> only
> return false once in a while.
>
> Fix this problem by changing the checking as following:
>
> 1) mddev doesn't have normal IO completed;
> 2) mddev doesn't have normal IO inflight;
> 3) if any member disks is partition, and all other partitions 
> doesn't
>    have IO completed.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 84 
>  +++++++++++++++++++++++++++----------------------
>  drivers/md/md.h |  3 +-
>  2 files changed, 48 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 52cadfce7e8d..dfd85a5d6112 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8625,50 +8625,58 @@ void md_cluster_stop(struct mddev 
> *mddev)
>  	put_cluster_ops(mddev);
>  }
>
> -static int is_mddev_idle(struct mddev *mddev, int init)
> +static bool is_rdev_holder_idle(struct md_rdev *rdev, bool 
> init)
>  {
> +	unsigned long last_events = rdev->last_events;
> +
> +	if (!bdev_is_partition(rdev->bdev))
> +		return true;
> +
> +	/*
> +	 * If rdev is partition, and user doesn't issue IO to the 
> array, the
> +	 * array is still not idle if user issues IO to other 
> partitions.
> +	 */
> +	rdev->last_events = 
> part_stat_read_accum(rdev->bdev->bd_disk->part0,
> +						 sectors) -
> +			    part_stat_read_accum(rdev->bdev, sectors);
> +
> +	if (!init && rdev->last_events > last_events)
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * mddev is idle if following conditions are match since last 
> check:
> + * 1) mddev doesn't have normal IO completed;
> + * 2) mddev doesn't have inflight normal IO;
> + * 3) if any member disk is partition, and other partitions 
> doesn't have IO
> + *    completed;
> + *
> + * Noted this checking rely on IO accounting is enabled.
> + */
> +static bool is_mddev_idle(struct mddev *mddev, int init)
> +{
> +	unsigned long last_events = mddev->last_events;
> +	struct gendisk *disk;
>  	struct md_rdev *rdev;
> -	int idle;
> -	int curr_events;
> +	bool idle = true;
>
> -	idle = 1;
> -	rcu_read_lock();
> -	rdev_for_each_rcu(rdev, mddev) {
> -		struct gendisk *disk = rdev->bdev->bd_disk;
> +	disk = mddev_is_dm(mddev) ? mddev->dm_gendisk : 
> mddev->gendisk;
> +	if (!disk)
> +		return true;
>
> -		if (!init && !blk_queue_io_stat(disk->queue))
> -			continue;
> +	mddev->last_events = part_stat_read_accum(disk->part0, 
> sectors);
> +	if (!init && (mddev->last_events > last_events ||
> +		      bdev_count_inflight(disk->part0)))
> +		idle = false;
>

Forgot return or goto here?

--
Su

> -		curr_events = (int)part_stat_read_accum(disk->part0, 
> sectors) -
> -			      atomic_read(&disk->sync_io);
> -		/* sync IO will cause sync_io to increase before the 
> disk_stats
> -		 * as sync_io is counted when a request starts, and
> -		 * disk_stats is counted when it completes.
> -		 * So resync activity will cause curr_events to be smaller 
> than
> -		 * when there was no such activity.
> -		 * non-sync IO will cause disk_stat to increase without
> -		 * increasing sync_io so curr_events will (eventually)
> -		 * be larger than it was before.  Once it becomes
> -		 * substantially larger, the test below will cause
> -		 * the array to appear non-idle, and resync will slow
> -		 * down.
> -		 * If there is a lot of outstanding resync activity when
> -		 * we set last_event to curr_events, then all that 
> activity
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
>  	rcu_read_unlock();
> +
>  	return idle;
>  }
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b57842188f18..1d51c2405d3d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -132,7 +132,7 @@ struct md_rdev {
>
>  	sector_t sectors;		/* Device size (in 512bytes sectors) 
>  */
>  	struct mddev *mddev;		/* RAID array if running */
> -	int last_events;		/* IO event timestamp */
> +	unsigned long last_events;	/* IO event timestamp */
>
>  	/*
>  	 * If meta_bdev is non-NULL, it means that a separate device 
>  is
> @@ -520,6 +520,7 @@ struct mddev {
>  							 * adding a spare
>  							 */
>
> +	unsigned long			last_events;	/* IO event timestamp 
> */
>  	atomic_t			recovery_active; /* blocks scheduled, but 
>  not written */
>  	wait_queue_head_t		recovery_wait;
>  	sector_t			recovery_cp;
