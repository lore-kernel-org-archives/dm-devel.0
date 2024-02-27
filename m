Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208BF56444
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 07:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019615; cv=none; b=l3luhyPE9fYh7U+ZQYL4Z6/ehTfwOSyzU9BO1aBUB2taDog9mGiF2D5WtEWKiaXwH8vUpYfbaK2zV01727DIRVl/huqzNq3LUsVrrowFZTdvssfjl2TCBc+x2E3xqkFJmXxpYNfiVS8Q2QqLbXsWyd9kwRQziQngDKPCffbg8l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019615; c=relaxed/simple;
	bh=0vHWBblny6UIDLIEtzKSbbmjSAJPo2u63SsVuNVohMc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=a+dB9WJA4O7cKDLvkBwQ2jSv5NVXheOQyp7yuM3PN8uL9G/aA+NcorXUDT5DZ6qdexeeiPGn9X9b7nLzoXfuzfGcByJYe0po35j/iCGg2w9uI2nL4Ku50Ki96UCchSOqwHJBf2AAAiwqDIfVsYcQZNoU8BTEHuD4I0NG9ZeWQ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TkTsS5sKKz4f3jsK
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 15:39:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 08C991A0232
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 15:40:02 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g7Qkd1lQOItFQ--.44077S3;
	Tue, 27 Feb 2024 15:40:01 +0800 (CST)
Subject: Re: [PATCH RFC 1/4] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping
 dmraid
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240220153059.11233-1-xni@redhat.com>
 <20240220153059.11233-2-xni@redhat.com>
 <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com>
 <CALTww2-3WgtGMDpeDphcfkdCxORf5bTSFZATSZ=m3S4VbPv26w@mail.gmail.com>
 <15439a9b-1170-09a3-caf0-e1020e78b713@huaweicloud.com>
 <CALTww29H7+kau-V-wx9kPM4Beu9niUaYcDt+DvXGrQdUNP_Aag@mail.gmail.com>
 <380b448c-32f9-4bf3-8626-4f8086047fca@huaweicloud.com>
 <CALTww2_WwNstUWM4QwNFfKXiyp9+KH5Wsk40ZS=1xuLEttaOhg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8a823207-55d3-0a37-82c4-f4d6c3354489@huaweicloud.com>
Date: Tue, 27 Feb 2024 15:39:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww2_WwNstUWM4QwNFfKXiyp9+KH5Wsk40ZS=1xuLEttaOhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g7Qkd1lQOItFQ--.44077S3
X-Coremail-Antispam: 1UD129KBjvAXoW3CFWrtFyrKF48GF4UCr45ZFb_yoW8GFy8Zo
	Z3Gr13Xw18Jr15AFyYy3srta43X34DJw1rtay5ZrsxXr1qga1j9r4fGw4xJF4fta42kw17
	J3Z7Xrn2vFy3Kw4fn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYy7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j
	6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/02/27 15:16, Xiao Ni 写道:
> On Mon, Feb 26, 2024 at 5:36 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/02/26 13:12, Xiao Ni 写道:
>>> On Mon, Feb 26, 2024 at 9:31 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> 在 2024/02/23 21:20, Xiao Ni 写道:
>>>>> On Fri, Feb 23, 2024 at 11:32 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> 在 2024/02/20 23:30, Xiao Ni 写道:
>>>>>>> MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
>>>>>>> commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
>>>>>>> Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
>>>>>>> dmraid stopped sync thread directy by calling md_reap_sync_thread.
>>>>>>> After this patch dmraid stops sync thread asynchronously as md does.
>>>>>>> This is right. Now the dmraid stop process is like this:
>>>>>>>
>>>>>>> 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thread.
>>>>>>> stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_RUNNING
>>>>>>> is cleared
>>>>>>> 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
>>>>>>> root cause for this deadlock. We hope md_do_sync can set MD_RECOVERY_DONE)
>>>>>>> 3. md thread calls md_check_recovery (This is the place to reap sync
>>>>>>> thread. Because MD_RECOVERY_DONE is not set. md thread can't reap sync
>>>>>>> thread)
>>>>>>> 4. raid_dtr stops/free struct mddev and release dmraid related resources
>>>>>>>
>>>>>>> dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to clear
>>>>>>> this bit when stopping the dmraid before stopping sync thread.
>>>>>>>
>>>>>>> But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
>>>>>>> cleared before stopping sync thread. It's the reason stop_sync_thread only
>>>>>>> wakes up task. If the task isn't running, it still needs to wake up sync
>>>>>>> thread too.
>>>>>>>
>>>>>>> This deadlock can be reproduced 100% by these commands:
>>>>>>> modprobe brd rd_size=34816 rd_nr=5
>>>>>>> while [ 1 ]; do
>>>>>>> vgcreate test_vg /dev/ram*
>>>>>>> lvcreate --type raid5 -L 16M -n test_lv test_vg
>>>>>>> lvconvert -y --stripes 4 /dev/test_vg/test_lv
>>>>>>> vgremove test_vg -ff
>>>>>>> sleep 1
>>>>>>> done
>>>>>>>
>>>>>>> Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
>>>>>>> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
>>>>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>>>>>
>>>>>> I'm not sure about this change, I think MD_RECOVERY_WAIT is hacky and
>>>>>> really breaks how sync_thread is working, it should just go away soon,
>>>>>> once we make sure sync_thread can't be registered before pers->start()
>>>>>> is done.
>>>>>
>>>>> Hi Kuai
>>>>>
>>>>> I just want to get to a stable state without changing any existing
>>>>> logic. After fixing these regressions, we can consider other changes.
>>>>> (e.g. remove MD_RECOVERY_WAIT. allow sync thread start/stop when array
>>>>> is suspend. )  I talked with Heinz yesterday, for dm-raid, it can't
>>>>> allow any io to happen including sync thread when array is suspended.
>>>>
>>>
>>> Hi Kuai
>>>
>>>> So, are you still thinking that my patchset will allow this for dm-raid?
>>>>
>>>> I already explain a lot why patch 1 from my set is okay, and why the set
>>>> doesn't introduce any behaviour change like you said in this patch 0:
>>>
>>>
>>> I'll read all your patches to understand you well.
>>>
>>> But as I mentioned many times too, we're fixing regression problems.
>>> It's better for us to fix them with the smallest change. As you can
>>> see, in my patch set, we can fix these regression problems with small
>>> changes (Sorry I didn't notice your patch set has some changes which
>>> are the same with mine).  So why don't we need such a big change to
>>> fix the regression problems? Now with my patch set I can reproduce a
>>> problem by lvm2 test suit which happens in 6.6 too. It means with this
>>> patch set we can back to a state same with 6.6.
> 
> Hi Kuai
> 
>>
>> For complexity, I agree that we can go back to the same state with v6.6,
>> and then fix other problems on the top of that. I don't have preference
>> for this, I'll post my patchset anyhow. But other than the test suite,
>> you still need to make sure nothing is broken from the big picture.
> 
> Thanks very much for this. I'm glad that we can reach an agreement :)
> What's the preference you mean? The branch with my patch set? I'll
> send a formal patch set later.
> 

I don't have preference... That will depend on dm-raid maintainer and
Song.

>>
>> For example, in the following 3 cases, can MD_RECOVERY_WAIT be cleared
>> as expected, and new sync_thread will not start after a reload?
>>
>> 1)
>> ioctl suspend
>> ioctl reload
>> ioctl resume
>>
>> 2)
>> ioctl reload
>> ioctl resume
>>
>> 3)
>> ioctl suspend
>> // without a reload.
>> ioctl resume
> 
> Are they all dmsetup message commands? MD_RECOVERY_WAIT is used to
> delay reshape to start. The sync thread (reshape) will start once
> MD_RECOVERY_WAIT is cleared. I did tests with lvm commands. For the
> three cases mentioned above, I need to check.

They are dm ioctl, and you can use dmsetup suspend/reload/resume cmd as
well.

 From what I see(with some debug), once MD_RECOVERY_WAIT is set, dm-raid
will never clear it, it relies on a reload to allocate a new raid_set
without the flag, and later dm_swap_table() from resume will replace
this new raid_set with the old one.

That's why I think this patch can work for the above case 1) and 2),
however, in case 3), MD_RECOVERY_WAIT is cleared without a reload and
start reshape this way can corrupt data.

And by the way, for case 1) and 2) the race window between clear
MD_RECOVERY_WAIT and mddev_suspend(), reshape can still start
concurrently, so this still is not a complete fix.

Thanks,
Kuai
>>
>>>
>>>
>>>
>>>>
>>>> "Kuai's patch set breaks some rules".
>>>>
>>>> The only thing that will change is that for md/raid, sync_thrad can
>>>> start for suspended array, however, I don't think this will be a problem
>>>> because sync_thread can be running for suspended array already, and
>>>> 'MD_RECOVERY_FROZEN' is already used to prevent sync_thread to start.
>>>
>>> We can't allow sync thread happen for dmraid when it's suspended.
>>> Because it needs to switch table when suspended. It's a base design.
>>> If it can happen now. We should fix this.
>>
>> Yes, and my patchset also fix this, and other problems related to
>> sync_thread by managing sync_thread the same as md/raid.
>>
>> BTW, on the top my patchset, I already made some change locally to
>> expand MD_RECOVERY_FROZEN and remove MD_RECOVERY_WAIT, if you're going
>> to review my patchset, you can take a look at following change later,
>> I already tested the change.
> 
> We can work on this in the future to fix problems one by one. Please
> try to make one patch set to resolve one problem. It's easy for
> review.
> 
> Best Regards
> Xiao
> 
>>
>> Thanks,
>> Kuai
>>
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index e1b3b1917627..a0c8a5b92aab 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -213,6 +213,7 @@ struct raid_dev {
>>    #define RT_FLAG_RS_IN_SYNC             6
>>    #define RT_FLAG_RS_RESYNCING           7
>>    #define RT_FLAG_RS_GROW                        8
>> +#define RT_FLAG_WAIT_RELOAD            9
>>
>>    /* Array elements of 64 bit needed for rebuild/failed disk bits */
>>    #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 -
>> 1)) / sizeof(uint64_t) / 8)
>> @@ -3728,6 +3729,9 @@ static int raid_message(struct dm_target *ti,
>> unsigned int argc, char **argv,
>>           if (test_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
>>                   return -EBUSY;
>>
>> +       if (test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags))
>> +               return -EINVAL;
>> +
>>           if (!strcasecmp(argv[0], "frozen")) {
>>                   ret = mddev_lock(mddev);
>>                   if (ret)
>> @@ -3809,21 +3813,25 @@ static void raid_presuspend(struct dm_target *ti)
>>           struct raid_set *rs = ti->private;
>>           struct mddev *mddev = &rs->md;
>>
>> -       mddev_lock_nointr(mddev);
>> -       md_frozen_sync_thread(mddev);
>> -       mddev_unlock(mddev);
>> +       if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags)) {
>> +               mddev_lock_nointr(mddev);
>> +               md_frozen_sync_thread(mddev);
>> +               mddev_unlock(mddev);
>>
>> -       if (mddev->pers && mddev->pers->prepare_suspend)
>> -               mddev->pers->prepare_suspend(mddev);
>> +               if (mddev->pers && mddev->pers->prepare_suspend)
>> +                       mddev->pers->prepare_suspend(mddev);
>> +       }
>>    }
>>
>>    static void raid_presuspend_undo(struct dm_target *ti)
>>    {
>>           struct raid_set *rs = ti->private;
>>
>> -       mddev_lock_nointr(&rs->md);
>> -       md_unfrozen_sync_thread(&rs->md);
>> -       mddev_unlock(&rs->md);
>> +       if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags)) {
>> +               mddev_lock_nointr(&rs->md);
>> +               md_unfrozen_sync_thread(&rs->md);
>> +               mddev_unlock(&rs->md);
>> +       }
>>    }
>>
>>    static void raid_postsuspend(struct dm_target *ti)
>> @@ -3958,9 +3966,6 @@ static int rs_start_reshape(struct raid_set *rs)
>>           struct mddev *mddev = &rs->md;
>>           struct md_personality *pers = mddev->pers;
>>
>> -       /* Don't allow the sync thread to work until the table gets
>> reloaded. */
>> -       set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
>> -
>>           r = rs_setup_reshape(rs);
>>           if (r)
>>                   return r;
>> @@ -4055,6 +4060,7 @@ static int raid_preresume(struct dm_target *ti)
>>                   /* Initiate a reshape. */
>>                   rs_set_rdev_sectors(rs);
>>                   mddev_lock_nointr(mddev);
>> +               set_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags);
>>                   r = rs_start_reshape(rs);
>>                   mddev_unlock(mddev);
>>                   if (r)
>> @@ -4089,7 +4095,8 @@ static void raid_resume(struct dm_target *ti)
>>                   mddev_lock_nointr(mddev);
>>                   mddev->ro = 0;
>>                   mddev->in_sync = 0;
>> -               md_unfrozen_sync_thread(mddev);
>> +               if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags))
>> +                       md_unfrozen_sync_thread(mddev);
>>                   mddev_unlock(mddev);
>>           }
>>    }
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 81e6f49a14fc..595b1fbdce20 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6064,7 +6064,8 @@ int md_run(struct mddev *mddev)
>>                           pr_warn("True protection against single-disk
>> failure might be compromised.\n");
>>           }
>>
>> -       mddev->recovery = 0;
>> +       /* dm-raid expect sync_thread to be frozen until resume */
>> +       mddev->recovery &= BIT_ULL_MASK(MD_RECOVERY_FROZEN);
>>           /* may be over-ridden by personality */
>>           mddev->resync_max_sectors = mddev->dev_sectors;
>>
>> @@ -6237,10 +6238,8 @@ int md_start(struct mddev *mddev)
>>           int ret = 0;
>>
>>           if (mddev->pers->start) {
>> -               set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
>>                   ret = mddev->pers->start(mddev);
>> -               clear_bit(MD_RECOVERY_WAIT, &mddev->recovery);
>> -               md_wakeup_thread(mddev->sync_thread);
>> +               WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING,
>> &mddev->recovery));
>>           }
>>           return ret;
>>    }
>> @@ -8827,8 +8825,7 @@ void md_do_sync(struct md_thread *thread)
>>           if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>>                   goto skip;
>>
>> -       if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
>> -           !md_is_rdwr(mddev)) {/* never try to sync a read-only array */
>> +       if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
>>                   set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>                   goto skip;
>>           }
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index c17b7e68c533..eb00cdadc9c5 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -554,7 +554,6 @@ enum recovery_flags {
>>           MD_RECOVERY_RESHAPE,    /* A reshape is happening */
>>           MD_RECOVERY_FROZEN,     /* User request to abort, and not
>> restart, any action */
>>           MD_RECOVERY_ERROR,      /* sync-action interrupted because
>> io-error */
>> -       MD_RECOVERY_WAIT,       /* waiting for pers->start() to finish */
>>           MD_RESYNCING_REMOTE,    /* remote node is running resync thread */
>>    };
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index acce2868e491..530a7f0b120b 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5919,7 +5919,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
>>    static bool reshape_disabled(struct mddev *mddev)
>>    {
>>           return !md_is_rdwr(mddev) ||
>> -              test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
>>                  test_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>    }
>>
>>>
>>> Best Regards
>>> Xiao
>>>>
>>>> Thanks,
>>>> Kuai
>>>>
>>>>>
>>>>> Regards
>>>>> Xiao
>>>>>>
>>>>>> Thanks,
>>>>>> Kuai
>>>>>>> ---
>>>>>>>      drivers/md/dm-raid.c | 2 ++
>>>>>>>      drivers/md/md.c      | 1 +
>>>>>>>      2 files changed, 3 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>>>>>> index eb009d6bb03a..325767c1140f 100644
>>>>>>> --- a/drivers/md/dm-raid.c
>>>>>>> +++ b/drivers/md/dm-raid.c
>>>>>>> @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target *ti)
>>>>>>>          struct raid_set *rs = ti->private;
>>>>>>>
>>>>>>>          if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
>>>>>>> +             if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
>>>>>>> +                     clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);
>>>>>>>                  /* Writes have to be stopped before suspending to avoid deadlocks. */
>>>>>>>                  if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
>>>>>>>                          md_stop_writes(&rs->md);
>>>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>>>> index 2266358d8074..54790261254d 100644
>>>>>>> --- a/drivers/md/md.c
>>>>>>> +++ b/drivers/md/md.c
>>>>>>> @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
>>>>>>>           * never happen
>>>>>>>           */
>>>>>>>          md_wakeup_thread_directly(mddev->sync_thread);
>>>>>>> +     md_wakeup_thread(mddev->sync_thread);
>>>>>>>          if (work_pending(&mddev->sync_work))
>>>>>>>                  flush_work(&mddev->sync_work);
>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>> .
>>>>>
>>>>
>>>
>>> .
>>>
>>
> 
> .
> 

