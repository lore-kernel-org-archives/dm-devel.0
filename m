Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D694E1E515
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 09:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745917986; cv=none; b=OXQrhK0+re+b3s6RkRavV7PpWt7P3k97CZ9xFm/xP7W9pSRLa3ayCpVnMyNi4edROShM31Cdl8N9QBl3aDPgYPhP3RbU6tbmbp9fBYRX16sqAZKFYogtt6VZlEWFm4SLUH3cT+iKhDPYpJym4roUqdX9A8A9lvoV51IU0kf6910=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745917986; c=relaxed/simple;
	bh=TToLi+NNUzFTq8OE2ajeTnGQDfDJfhPouDBmNVbabtk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JOugDAnNiBvlOR+2lbR5lz/exhsvqw9S5IisfDQ3JQ9QL1Y/YB7ObUe+ZHhj4kQAHdWjzlp4D0muu8Zov03bR8s10FyNg+lKnMuKNCGm7NbN0AOTQO7Ar7mgN6REkD/3pbLlI6snm8eImx14IYRs7lx4Wl0+/y0zag5nqq2VbtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4Zmvjm5NJrzYQtrR
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 17:13:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 387C01A01A4
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 17:13:00 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8amBBolN6gKw--.63706S3;
	Tue, 29 Apr 2025 17:12:59 +0800 (CST)
Subject: Re: [PATCH v2 8/9] md: fix is_mddev_idle()
To: Xiao Ni <xni@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, cl@linux.com, nadav.amit@gmail.com,
 ubizjak@gmail.com, akpm@linux-foundation.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-9-yukuai1@huaweicloud.com>
 <fefeda56-6b28-45b8-bc35-75f537613142@molgen.mpg.de>
 <2e517b58-3a7b-4212-8b91-defd8345b2bb@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3f87ffd7-80e1-396a-d8c4-56e1f4bb4367@huaweicloud.com>
Date: Tue, 29 Apr 2025 17:12:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2e517b58-3a7b-4212-8b91-defd8345b2bb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl8amBBolN6gKw--.63706S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWUtw17Jr1rZw13KF4xCrg_yoWfGr1fpF
	WkJFy5trW5Xr1fJr1Utr1UXFy5tryxJw4DJr1UXF1UXr47Ar1qgF4UWr1q9r1UJr4kXF1U
	Jw1UJrsrZFy5JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB214x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjTRRBT5DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/29 13:45, Xiao Ni 写道:
> 
> 在 2025/4/27 下午5:51, Paul Menzel 写道:
>> Dear Kuai,
>>
>>
>> Thank you for your patch.
>>
>>
>> Am 27.04.25 um 10:29 schrieb Yu Kuai:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> If sync_speed is above speed_min, then is_mddev_idle() will be called
>>> for each sync IO to check if the array is idle, and inflihgt sync_io
>>
>> infli*gh*t
>>
>>> will be limited if the array is not idle.
>>>
>>> However, while mkfs.ext4 for a large raid5 array while recovery is in
>>> progress, it's found that sync_speed is already above speed_min while
>>> lots of stripes are used for sync IO, causing long delay for mkfs.ext4.
>>>
>>> Root cause is the following checking from is_mddev_idle():
>>>
>>> t1: submit sync IO: events1 = completed IO - issued sync IO
>>> t2: submit next sync IO: events2  = completed IO - issued sync IO
>>> if (events2 - events1 > 64)
>>>
>>> For consequence, the more sync IO issued, the less likely checking will
>>> pass. And when completed normal IO is more than issued sync IO, the
>>> condition will finally pass and is_mddev_idle() will return false,
>>> however, last_events will be updated hence is_mddev_idle() can only
>>> return false once in a while.
>>>
>>> Fix this problem by changing the checking as following:
>>>
>>> 1) mddev doesn't have normal IO completed;
>>> 2) mddev doesn't have normal IO inflight;
>>> 3) if any member disks is partition, and all other partitions doesn't
>>>     have IO completed.
>>
>> Do you have benchmarks of mkfs.ext4 before and after your patch? It’d 
>> be great if you added those.
>>
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> ---
>>>   drivers/md/md.c | 84 +++++++++++++++++++++++++++----------------------
>>>   drivers/md/md.h |  3 +-
>>>   2 files changed, 48 insertions(+), 39 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 541151bcfe81..955efe0b40c6 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -8625,50 +8625,58 @@ void md_cluster_stop(struct mddev *mddev)
>>>       put_cluster_ops(mddev);
>>>   }
>>>   -static int is_mddev_idle(struct mddev *mddev, int init)
>>> +static bool is_rdev_holder_idle(struct md_rdev *rdev, bool init)
>>>   {
>>> +    unsigned long last_events = rdev->last_events;
>>> +
>>> +    if (!bdev_is_partition(rdev->bdev))
>>> +        return true;
>>
>> Will the compiler generate code, that the assignment happens after 
>> this condition?

Usually compiler won't. And this is fine because resync is not hot path.

>>
>>> +
>>> +    /*
>>> +     * If rdev is partition, and user doesn't issue IO to the array, 
>>> the
>>> +     * array is still not idle if user issues IO to other partitions.
>>> +     */
>>> +    rdev->last_events = 
>>> part_stat_read_accum(rdev->bdev->bd_disk->part0,
>>> +                         sectors) -
>>> +                part_stat_read_accum(rdev->bdev, sectors);
>>> +
>>> +    if (!init && rdev->last_events > last_events)
>>> +        return false;
>>> +
>>> +    return true;
>>
>> Could be one return statement, couldn’t it?
>>
>>     return init || rdev->last_events <= last_events;

Yes, this is simpiler.
> 
> 
> For me, I prefer the way of this patch. It's easy to understand. One 
> return statement is harder to understand than the two return statements.
> 
>>
>>> +}
>>> +
>>> +/*
>>> + * mddev is idle if following conditions are match since last check:
>>
>> … *the* following condition are match*ed* …
>>
>> (or are met)
>>
>>> + * 1) mddev doesn't have normal IO completed;
>>> + * 2) mddev doesn't have inflight normal IO;
>>> + * 3) if any member disk is partition, and other partitions doesn't 
>>> have IO
>>
>> don’t
>>
>>> + *    completed;
>>> + *
>>> + * Noted this checking rely on IO accounting is enabled.
>>> + */
>>> +static bool is_mddev_idle(struct mddev *mddev, int init)
>>> +{
>>> +    unsigned long last_events = mddev->normal_IO_events;
>>> +    struct gendisk *disk;
>>>       struct md_rdev *rdev;
>>> -    int idle;
>>> -    int curr_events;
>>> +    bool idle = true;
>>>   -    idle = 1;
>>> -    rcu_read_lock();
>>> -    rdev_for_each_rcu(rdev, mddev) {
>>> -        struct gendisk *disk = rdev->bdev->bd_disk;
>>> +    disk = mddev_is_dm(mddev) ? mddev->dm_gendisk : mddev->gendisk;
>>> +    if (!disk)
>>> +        return true;
>>>   -        if (!init && !blk_queue_io_stat(disk->queue))
>>> -            continue;
>>> +    mddev->normal_IO_events = part_stat_read_accum(disk->part0, 
>>> sectors);
>>> +    if (!init && (mddev->normal_IO_events > last_events ||
>>> +              bdev_count_inflight(disk->part0)))
>>> +        idle = false;
>>>   -        curr_events = (int)part_stat_read_accum(disk->part0, 
>>> sectors) -
>>> -                  atomic_read(&disk->sync_io);
>>> -        /* sync IO will cause sync_io to increase before the disk_stats
>>> -         * as sync_io is counted when a request starts, and
>>> -         * disk_stats is counted when it completes.
>>> -         * So resync activity will cause curr_events to be smaller than
>>> -         * when there was no such activity.
>>> -         * non-sync IO will cause disk_stat to increase without
>>> -         * increasing sync_io so curr_events will (eventually)
>>> -         * be larger than it was before.  Once it becomes
>>> -         * substantially larger, the test below will cause
>>> -         * the array to appear non-idle, and resync will slow
>>> -         * down.
>>> -         * If there is a lot of outstanding resync activity when
>>> -         * we set last_event to curr_events, then all that activity
>>> -         * completing might cause the array to appear non-idle
>>> -         * and resync will be slowed down even though there might
>>> -         * not have been non-resync activity.  This will only
>>> -         * happen once though.  'last_events' will soon reflect
>>> -         * the state where there is little or no outstanding
>>> -         * resync requests, and further resync activity will
>>> -         * always make curr_events less than last_events.
>>> -         *
>>> -         */
>>> -        if (init || curr_events - rdev->last_events > 64) {
>>> -            rdev->last_events = curr_events;
>>> -            idle = 0;
>>> -        }
>>> -    }
>>> +    rcu_read_lock();
>>> +    rdev_for_each_rcu(rdev, mddev)
>>> +        if (!is_rdev_holder_idle(rdev, init))
>>> +            idle = false;
>>>       rcu_read_unlock();
>>> +
>>>       return idle;
>>>   }
>>>   diff --git a/drivers/md/md.h b/drivers/md/md.h
>>> index b57842188f18..da3fd514d20c 100644
>>> --- a/drivers/md/md.h
>>> +++ b/drivers/md/md.h
>>> @@ -132,7 +132,7 @@ struct md_rdev {
>>>         sector_t sectors;        /* Device size (in 512bytes sectors) */
>>>       struct mddev *mddev;        /* RAID array if running */
>>> -    int last_events;        /* IO event timestamp */
>>> +    unsigned long last_events;    /* IO event timestamp */
>>
>> Please mention in the commit message, why the type is changed.

I thought this is straightforward, not need for type casting.
>>
>>>         /*
>>>        * If meta_bdev is non-NULL, it means that a separate device is
>>> @@ -520,6 +520,7 @@ struct mddev {
>>>                                * adding a spare
>>>                                */
>>>   +    unsigned long            normal_IO_events; /* IO event 
>>> timestamp */
>>
>> Make everything lower case?
> 
> 
> agree+

ok

Thanks,
Kuai

> Regards
> 
> Xiao
> 
>>
>>>       atomic_t            recovery_active; /* blocks scheduled, but 
>>> not written */
>>>       wait_queue_head_t        recovery_wait;
>>>       sector_t            recovery_cp;
>>
>>
>> Kind regards,
>>
>> Paul
>>
> 
> 
> .
> 

