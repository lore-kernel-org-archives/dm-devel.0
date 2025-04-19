Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A28A101C8
	for <dm-devel@lists.linux.dev>; Sat, 19 Apr 2025 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745028027; cv=none; b=ciMV6NqjdVWV/luzjCypRoELAuqJ1dJADKyq1s7RpC0lMBwZt8XhfgHbdBfOQdks15ifnxdIxxAXyG0syZmbIK4hTP6Z/A3BKq2JAhgXGlf4fMdMo5bpHfKA/ET2zIN/8BD8LHINgB1tNdRtQzLopBt91nSb+AZZQRAb2RHwGrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745028027; c=relaxed/simple;
	bh=Lc8RrCtRgBKviLEHvyYUpfft9HiJOg++t4SII0Z8Um0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=e/Idi/tT5R+Mos8g8jT/DK4dgkciFqeAkC5axlrl8Ylb6qwi/uEdEvAXWbOT5GvTuVA96UzJoMknry2DyBeWj8Sr2FHY2vszkzst5QMwnmLenS1QFFuRyZUZa4IbXgNqN6MDlkTZaJn5MSy7SR8h8OGE8fzeN36ykL9P2DCUTRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZfZZg3lZ6z4f3kFP
	for <dm-devel@lists.linux.dev>; Sat, 19 Apr 2025 09:59:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 516871A058E
	for <dm-devel@lists.linux.dev>; Sat, 19 Apr 2025 10:00:19 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+xAwNosGGcJw--.25822S3;
	Sat, 19 Apr 2025 10:00:19 +0800 (CST)
Subject: Re: [PATCH v2 4/5] md: fix is_mddev_idle()
To: Su Yue <l@damenly.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, xni@redhat.com, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, viro@zeniv.linux.org.uk,
 akpm@linux-foundation.org, nadav.amit@gmail.com, ubizjak@gmail.com,
 cl@linux.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
 <20250418010941.667138-5-yukuai1@huaweicloud.com> <v7r19baz.fsf@damenly.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e5ec218e-dcab-ff8c-f455-d8fc6943a6e7@huaweicloud.com>
Date: Sat, 19 Apr 2025 10:00:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <v7r19baz.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+xAwNosGGcJw--.25822S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF18Gr47GF17WF15XF1rtFb_yoW3Gw43pF
	WkJFy5tryUJr1fJr1UJryUJFy5Jry8Jw4Dtr18XF1UXr17Ar1jgF1UWr1qgr1UJr48XF1U
	Jw1UJrsruFyUJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/19 9:42, Su Yue 写道:
> On Fri 18 Apr 2025 at 09:09, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> If sync_speed is above speed_min, then is_mddev_idle() will be called
>> for each sync IO to check if the array is idle, and inflihgt sync_io
>> will be limited if the array is not idle.
>>
>> However, while mkfs.ext4 for a large raid5 array while recovery is in
>> progress, it's found that sync_speed is already above speed_min while
>> lots of stripes are used for sync IO, causing long delay for mkfs.ext4.
>>
>> Root cause is the following checking from is_mddev_idle():
>>
>> t1: submit sync IO: events1 = completed IO - issued sync IO
>> t2: submit next sync IO: events2  = completed IO - issued sync IO
>> if (events2 - events1 > 64)
>>
>> For consequence, the more sync IO issued, the less likely checking will
>> pass. And when completed normal IO is more than issued sync IO, the
>> condition will finally pass and is_mddev_idle() will return false,
>> however, last_events will be updated hence is_mddev_idle() can only
>> return false once in a while.
>>
>> Fix this problem by changing the checking as following:
>>
>> 1) mddev doesn't have normal IO completed;
>> 2) mddev doesn't have normal IO inflight;
>> 3) if any member disks is partition, and all other partitions doesn't
>>    have IO completed.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>  drivers/md/md.c | 84  +++++++++++++++++++++++++++----------------------
>>  drivers/md/md.h |  3 +-
>>  2 files changed, 48 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 52cadfce7e8d..dfd85a5d6112 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8625,50 +8625,58 @@ void md_cluster_stop(struct mddev *mddev)
>>      put_cluster_ops(mddev);
>>  }
>>
>> -static int is_mddev_idle(struct mddev *mddev, int init)
>> +static bool is_rdev_holder_idle(struct md_rdev *rdev, bool init)
>>  {
>> +    unsigned long last_events = rdev->last_events;
>> +
>> +    if (!bdev_is_partition(rdev->bdev))
>> +        return true;
>> +
>> +    /*
>> +     * If rdev is partition, and user doesn't issue IO to the array, the
>> +     * array is still not idle if user issues IO to other partitions.
>> +     */
>> +    rdev->last_events = part_stat_read_accum(rdev->bdev->bd_disk->part0,
>> +                         sectors) -
>> +                part_stat_read_accum(rdev->bdev, sectors);
>> +
>> +    if (!init && rdev->last_events > last_events)
>> +        return false;
>> +
>> +    return true;
>> +}
>> +
>> +/*
>> + * mddev is idle if following conditions are match since last check:
>> + * 1) mddev doesn't have normal IO completed;
>> + * 2) mddev doesn't have inflight normal IO;
>> + * 3) if any member disk is partition, and other partitions doesn't 
>> have IO
>> + *    completed;
>> + *
>> + * Noted this checking rely on IO accounting is enabled.
>> + */
>> +static bool is_mddev_idle(struct mddev *mddev, int init)
>> +{
>> +    unsigned long last_events = mddev->last_events;
>> +    struct gendisk *disk;
>>      struct md_rdev *rdev;
>> -    int idle;
>> -    int curr_events;
>> +    bool idle = true;
>>
>> -    idle = 1;
>> -    rcu_read_lock();
>> -    rdev_for_each_rcu(rdev, mddev) {
>> -        struct gendisk *disk = rdev->bdev->bd_disk;
>> +    disk = mddev_is_dm(mddev) ? mddev->dm_gendisk : mddev->gendisk;
>> +    if (!disk)
>> +        return true;
>>
>> -        if (!init && !blk_queue_io_stat(disk->queue))
>> -            continue;
>> +    mddev->last_events = part_stat_read_accum(disk->part0, sectors);
>> +    if (!init && (mddev->last_events > last_events ||
>> +              bdev_count_inflight(disk->part0)))
>> +        idle = false;
>>
> 
> Forgot return or goto here?

No, following still need to be executed to init or update
rdev->last_events.k

Thanks,
Kuai

> 
> -- 
> Su
> 
>> -        curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
>> -                  atomic_read(&disk->sync_io);
>> -        /* sync IO will cause sync_io to increase before the disk_stats
>> -         * as sync_io is counted when a request starts, and
>> -         * disk_stats is counted when it completes.
>> -         * So resync activity will cause curr_events to be smaller than
>> -         * when there was no such activity.
>> -         * non-sync IO will cause disk_stat to increase without
>> -         * increasing sync_io so curr_events will (eventually)
>> -         * be larger than it was before.  Once it becomes
>> -         * substantially larger, the test below will cause
>> -         * the array to appear non-idle, and resync will slow
>> -         * down.
>> -         * If there is a lot of outstanding resync activity when
>> -         * we set last_event to curr_events, then all that activity
>> -         * completing might cause the array to appear non-idle
>> -         * and resync will be slowed down even though there might
>> -         * not have been non-resync activity.  This will only
>> -         * happen once though.  'last_events' will soon reflect
>> -         * the state where there is little or no outstanding
>> -         * resync requests, and further resync activity will
>> -         * always make curr_events less than last_events.
>> -         *
>> -         */
>> -        if (init || curr_events - rdev->last_events > 64) {
>> -            rdev->last_events = curr_events;
>> -            idle = 0;
>> -        }
>> -    }
>> +    rcu_read_lock();
>> +    rdev_for_each_rcu(rdev, mddev)
>> +        if (!is_rdev_holder_idle(rdev, init))
>> +            idle = false;
>>      rcu_read_unlock();
>> +
>>      return idle;
>>  }
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index b57842188f18..1d51c2405d3d 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -132,7 +132,7 @@ struct md_rdev {
>>
>>      sector_t sectors;        /* Device size (in 512bytes sectors)  */
>>      struct mddev *mddev;        /* RAID array if running */
>> -    int last_events;        /* IO event timestamp */
>> +    unsigned long last_events;    /* IO event timestamp */
>>
>>      /*
>>       * If meta_bdev is non-NULL, it means that a separate device  is
>> @@ -520,6 +520,7 @@ struct mddev {
>>                               * adding a spare
>>                               */
>>
>> +    unsigned long            last_events;    /* IO event timestamp */
>>      atomic_t            recovery_active; /* blocks scheduled, but 
>>  not written */
>>      wait_queue_head_t        recovery_wait;
>>      sector_t            recovery_cp;
> .
> 

