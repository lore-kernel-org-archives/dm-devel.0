Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DDA4F1F5
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266701; cv=none; b=Tntl5XiY0EfihxnkuHMwHWHcpQH+v2ttm2skMPZyZQvbwKWksY5ppJL31BV1yAIOxW2TJ+80PWXG1lm99f+qOc/ElEPF7bkrfo/K19AqSaKOEnsx169xZ13I67DbqSqsdfICnnCDsikgJRT4An0JFLQq+KxqLKN8MSFJ180oCb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266701; c=relaxed/simple;
	bh=Mdk/QI9tBC3Eoldt62sYl1aOkGpE7n9DbytHxQIYOB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tj6yVo2OVIWWRuyZGnXUH2ZAr3fng4MbX/OSqZxLTQfRZJ35WXjK7UhCGvpnR9/t3ySatN47pWx68/RAwjkedD8oDxlsODa6UtkbB3hiB8dGheXbyK2XvMiFc6ad90hG+1n4MOX6hxz0HV7x9HZnMeKiNos0/tcR5XMR2Rn+nAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZH8ylcGx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZH8ylcGx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=akc0sxDgRM1fxGlxxGLtxgIQ+d6BcAfp3Zh5U5+vkAw=;
	b=ZH8ylcGxvitBsxvYGrWRTgvMF26/ucNd+HspXYA9ANdt3xiZ1H/mcwaBNold2i7tFs8tML
	mZ3DItyviJKfiHVuEyemLpqJspuYsgN8wkXk0/e17Z47rZ1SwfHb4+BrTIg4dTCvOmRcSk
	b0CvoQ0k1e+gsEeiUUtEPlPJfFMjLzo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-GI24uyqJN1Cff64934AR6w-1; Thu, 29 Feb 2024 23:18:06 -0500
X-MC-Unique: GI24uyqJN1Cff64934AR6w-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1dc7392a883so17750585ad.2
        for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 20:18:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709266685; x=1709871485;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=akc0sxDgRM1fxGlxxGLtxgIQ+d6BcAfp3Zh5U5+vkAw=;
        b=j+YMKUrjaNw1zjMJPE0uwo8Q2r0Bxu1sHf3QPHYUxvyKWv0T4h93Mn7Lmwqvsrqq+z
         /UzrJLTDlb92xAp20GDcjIdLl7+Pci+S5YDDueSR2xQG9QLZuKLUX7P4oOgi6lUkDfn+
         VWUSkjROrKIf+aFoaxstQOaj5wOetLgtxnkHN4/ZSkfkoEMLJOWzv2OjukdIVEnFLkX5
         /uF3DotcQo8NuK1SKeyOSONHOHAFyAPu9HtSlHX1R1XRNflTlaMLsyEne6Jj+z4Z22aJ
         NX9J1ph5/8gVrMNFHzt3uIHU9mAVwPPzOeZQkp6rb6zruaI9jXyaJhau43b031lWNrO7
         28Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVAJ+KyceVhRPL9dVkwbwEipL89SEX5VDINqlFOL82qXQ7BDkMxFQqsXjCJKF8inqAdykK2x2Tw8eSzQ2lh3bYj6SxlB75ZpmQ=
X-Gm-Message-State: AOJu0Yyh24k1Fau7giyyRyxWOBaEUUs3+RjVqIiGKVSDZNojvWsrG9cJ
	jDba5CIgwL723pZMLePAyqFQz36i3n0vYKiB5DFWNzvYwbeRXGubpDvXcmcpE4ZYci7NgZLuoV8
	KD2W81EH1LlFrjwKh8CK7lhBQwWFOf1m/bGGW6IYakXTAxiAb8Hm6AxEA
X-Received: by 2002:a17:903:41c8:b0:1dc:a5fd:6dd3 with SMTP id u8-20020a17090341c800b001dca5fd6dd3mr804702ple.29.1709266685221;
        Thu, 29 Feb 2024 20:18:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPc1O2eMeAjOQppqFxxAmhOFAtJ8ZA42PfHXLj3f8c+fWt0WK5FaJOugeMt+XO66WBQk+BAA==
X-Received: by 2002:a17:903:41c8:b0:1dc:a5fd:6dd3 with SMTP id u8-20020a17090341c800b001dca5fd6dd3mr804686ple.29.1709266684825;
        Thu, 29 Feb 2024 20:18:04 -0800 (PST)
Received: from [10.72.120.8] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902684400b001dc2d1bd4dasm2378770pln.80.2024.02.29.20.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 20:18:04 -0800 (PST)
Message-ID: <2e7c9c1f-5ea1-48fd-b371-934deea4808c@redhat.com>
Date: Fri, 1 Mar 2024 12:18:00 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/4] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping
 dmraid
To: Yu Kuai <yukuai1@huaweicloud.com>
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
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <380b448c-32f9-4bf3-8626-4f8086047fca@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/2/26 下午5:36, Yu Kuai 写道:
> Hi,
>
> 在 2024/02/26 13:12, Xiao Ni 写道:
>> On Mon, Feb 26, 2024 at 9:31 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>
>>> Hi,
>>>
>>> 在 2024/02/23 21:20, Xiao Ni 写道:
>>>> On Fri, Feb 23, 2024 at 11:32 AM Yu Kuai <yukuai1@huaweicloud.com> 
>>>> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> 在 2024/02/20 23:30, Xiao Ni 写道:
>>>>>> MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
>>>>>> commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
>>>>>> Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
>>>>>> dmraid stopped sync thread directy by calling md_reap_sync_thread.
>>>>>> After this patch dmraid stops sync thread asynchronously as md does.
>>>>>> This is right. Now the dmraid stop process is like this:
>>>>>>
>>>>>> 1. 
>>>>>> raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thread.
>>>>>> stop_sync_thread sets MD_RECOVERY_INTR and wait until 
>>>>>> MD_RECOVERY_RUNNING
>>>>>> is cleared
>>>>>> 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
>>>>>> root cause for this deadlock. We hope md_do_sync can set 
>>>>>> MD_RECOVERY_DONE)
>>>>>> 3. md thread calls md_check_recovery (This is the place to reap sync
>>>>>> thread. Because MD_RECOVERY_DONE is not set. md thread can't reap 
>>>>>> sync
>>>>>> thread)
>>>>>> 4. raid_dtr stops/free struct mddev and release dmraid related 
>>>>>> resources
>>>>>>
>>>>>> dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs 
>>>>>> to clear
>>>>>> this bit when stopping the dmraid before stopping sync thread.
>>>>>>
>>>>>> But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
>>>>>> cleared before stopping sync thread. It's the reason 
>>>>>> stop_sync_thread only
>>>>>> wakes up task. If the task isn't running, it still needs to wake 
>>>>>> up sync
>>>>>> thread too.
>>>>>>
>>>>>> This deadlock can be reproduced 100% by these commands:
>>>>>> modprobe brd rd_size=34816 rd_nr=5
>>>>>> while [ 1 ]; do
>>>>>> vgcreate test_vg /dev/ram*
>>>>>> lvcreate --type raid5 -L 16M -n test_lv test_vg
>>>>>> lvconvert -y --stripes 4 /dev/test_vg/test_lv
>>>>>> vgremove test_vg -ff
>>>>>> sleep 1
>>>>>> done
>>>>>>
>>>>>> Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
>>>>>> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
>>>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>>>>
>>>>> I'm not sure about this change, I think MD_RECOVERY_WAIT is hacky and
>>>>> really breaks how sync_thread is working, it should just go away 
>>>>> soon,
>>>>> once we make sure sync_thread can't be registered before 
>>>>> pers->start()
>>>>> is done.
>>>>
>>>> Hi Kuai
>>>>
>>>> I just want to get to a stable state without changing any existing
>>>> logic. After fixing these regressions, we can consider other changes.
>>>> (e.g. remove MD_RECOVERY_WAIT. allow sync thread start/stop when array
>>>> is suspend. )  I talked with Heinz yesterday, for dm-raid, it can't
>>>> allow any io to happen including sync thread when array is suspended.
>>>
>>
>> Hi Kuai
>>
>>> So, are you still thinking that my patchset will allow this for 
>>> dm-raid?
>>>
>>> I already explain a lot why patch 1 from my set is okay, and why the 
>>> set
>>> doesn't introduce any behaviour change like you said in this patch 0:
>>
>>
>> I'll read all your patches to understand you well.
>>
>> But as I mentioned many times too, we're fixing regression problems.
>> It's better for us to fix them with the smallest change. As you can
>> see, in my patch set, we can fix these regression problems with small
>> changes (Sorry I didn't notice your patch set has some changes which
>> are the same with mine).  So why don't we need such a big change to
>> fix the regression problems? Now with my patch set I can reproduce a
>> problem by lvm2 test suit which happens in 6.6 too. It means with this
>> patch set we can back to a state same with 6.6.
>
> For complexity, I agree that we can go back to the same state with v6.6,
> and then fix other problems on the top of that. I don't have preference
> for this, I'll post my patchset anyhow. But other than the test suite,
> you still need to make sure nothing is broken from the big picture.
>
> For example, in the following 3 cases, can MD_RECOVERY_WAIT be cleared
> as expected, and new sync_thread will not start after a reload?
>
> 1)
> ioctl suspend
> ioctl reload
> ioctl resume
>
> 2)
> ioctl reload
> ioctl resume
>
> 3)
> ioctl suspend
> // without a reload.
> ioctl resume


Hi Kuai

Is it the place that you think clearing MD_RECOVERY_WAIT is not safe? 
For the above three cases, I didn't do tests with dmsetup commands. 
Because lvm2 tests use lv commands, so I only checked the logs which I 
use printk to follow the functions calling sequence. l can make sure 
MD_RECOVERY_WAIT can be cleared when running lvconvert command. I'm not 
familiar with dmsetup commands. Could you give some examples fot the 
three above cases? I can do test myself here.

Best Regards

Xiao

>
>>
>>
>>
>>>
>>> "Kuai's patch set breaks some rules".
>>>
>>> The only thing that will change is that for md/raid, sync_thrad can
>>> start for suspended array, however, I don't think this will be a 
>>> problem
>>> because sync_thread can be running for suspended array already, and
>>> 'MD_RECOVERY_FROZEN' is already used to prevent sync_thread to start.
>>
>> We can't allow sync thread happen for dmraid when it's suspended.
>> Because it needs to switch table when suspended. It's a base design.
>> If it can happen now. We should fix this.
>
> Yes, and my patchset also fix this, and other problems related to
> sync_thread by managing sync_thread the same as md/raid.
>
> BTW, on the top my patchset, I already made some change locally to
> expand MD_RECOVERY_FROZEN and remove MD_RECOVERY_WAIT, if you're going
> to review my patchset, you can take a look at following change later,
> I already tested the change.
>
> Thanks,
> Kuai
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index e1b3b1917627..a0c8a5b92aab 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -213,6 +213,7 @@ struct raid_dev {
>  #define RT_FLAG_RS_IN_SYNC             6
>  #define RT_FLAG_RS_RESYNCING           7
>  #define RT_FLAG_RS_GROW                        8
> +#define RT_FLAG_WAIT_RELOAD            9
>
>  /* Array elements of 64 bit needed for rebuild/failed disk bits */
>  #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 
> - 1)) / sizeof(uint64_t) / 8)
> @@ -3728,6 +3729,9 @@ static int raid_message(struct dm_target *ti, 
> unsigned int argc, char **argv,
>         if (test_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
>                 return -EBUSY;
>
> +       if (test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags))
> +               return -EINVAL;
> +
>         if (!strcasecmp(argv[0], "frozen")) {
>                 ret = mddev_lock(mddev);
>                 if (ret)
> @@ -3809,21 +3813,25 @@ static void raid_presuspend(struct dm_target *ti)
>         struct raid_set *rs = ti->private;
>         struct mddev *mddev = &rs->md;
>
> -       mddev_lock_nointr(mddev);
> -       md_frozen_sync_thread(mddev);
> -       mddev_unlock(mddev);
> +       if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags)) {
> +               mddev_lock_nointr(mddev);
> +               md_frozen_sync_thread(mddev);
> +               mddev_unlock(mddev);
>
> -       if (mddev->pers && mddev->pers->prepare_suspend)
> -               mddev->pers->prepare_suspend(mddev);
> +               if (mddev->pers && mddev->pers->prepare_suspend)
> +                       mddev->pers->prepare_suspend(mddev);
> +       }
>  }
>
>  static void raid_presuspend_undo(struct dm_target *ti)
>  {
>         struct raid_set *rs = ti->private;
>
> -       mddev_lock_nointr(&rs->md);
> -       md_unfrozen_sync_thread(&rs->md);
> -       mddev_unlock(&rs->md);
> +       if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags)) {
> +               mddev_lock_nointr(&rs->md);
> +               md_unfrozen_sync_thread(&rs->md);
> +               mddev_unlock(&rs->md);
> +       }
>  }
>
>  static void raid_postsuspend(struct dm_target *ti)
> @@ -3958,9 +3966,6 @@ static int rs_start_reshape(struct raid_set *rs)
>         struct mddev *mddev = &rs->md;
>         struct md_personality *pers = mddev->pers;
>
> -       /* Don't allow the sync thread to work until the table gets 
> reloaded. */
> -       set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
> -
>         r = rs_setup_reshape(rs);
>         if (r)
>                 return r;
> @@ -4055,6 +4060,7 @@ static int raid_preresume(struct dm_target *ti)
>                 /* Initiate a reshape. */
>                 rs_set_rdev_sectors(rs);
>                 mddev_lock_nointr(mddev);
> +               set_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags);
>                 r = rs_start_reshape(rs);
>                 mddev_unlock(mddev);
>                 if (r)
> @@ -4089,7 +4095,8 @@ static void raid_resume(struct dm_target *ti)
>                 mddev_lock_nointr(mddev);
>                 mddev->ro = 0;
>                 mddev->in_sync = 0;
> -               md_unfrozen_sync_thread(mddev);
> +               if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags))
> +                       md_unfrozen_sync_thread(mddev);
>                 mddev_unlock(mddev);
>         }
>  }
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 81e6f49a14fc..595b1fbdce20 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6064,7 +6064,8 @@ int md_run(struct mddev *mddev)
>                         pr_warn("True protection against single-disk 
> failure might be compromised.\n");
>         }
>
> -       mddev->recovery = 0;
> +       /* dm-raid expect sync_thread to be frozen until resume */
> +       mddev->recovery &= BIT_ULL_MASK(MD_RECOVERY_FROZEN);
>         /* may be over-ridden by personality */
>         mddev->resync_max_sectors = mddev->dev_sectors;
>
> @@ -6237,10 +6238,8 @@ int md_start(struct mddev *mddev)
>         int ret = 0;
>
>         if (mddev->pers->start) {
> -               set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
>                 ret = mddev->pers->start(mddev);
> -               clear_bit(MD_RECOVERY_WAIT, &mddev->recovery);
> -               md_wakeup_thread(mddev->sync_thread);
> +               WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, 
> &mddev->recovery));
>         }
>         return ret;
>  }
> @@ -8827,8 +8825,7 @@ void md_do_sync(struct md_thread *thread)
>         if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>                 goto skip;
>
> -       if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
> -           !md_is_rdwr(mddev)) {/* never try to sync a read-only 
> array */
> +       if (!md_is_rdwr(mddev)) {/* never try to sync a read-only 
> array */
>                 set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>                 goto skip;
>         }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index c17b7e68c533..eb00cdadc9c5 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -554,7 +554,6 @@ enum recovery_flags {
>         MD_RECOVERY_RESHAPE,    /* A reshape is happening */
>         MD_RECOVERY_FROZEN,     /* User request to abort, and not 
> restart, any action */
>         MD_RECOVERY_ERROR,      /* sync-action interrupted because 
> io-error */
> -       MD_RECOVERY_WAIT,       /* waiting for pers->start() to finish */
>         MD_RESYNCING_REMOTE,    /* remote node is running resync 
> thread */
>  };
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index acce2868e491..530a7f0b120b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5919,7 +5919,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
>  static bool reshape_disabled(struct mddev *mddev)
>  {
>         return !md_is_rdwr(mddev) ||
> -              test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
>                test_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>  }
>
>>
>> Best Regards
>> Xiao
>>>
>>> Thanks,
>>> Kuai
>>>
>>>>
>>>> Regards
>>>> Xiao
>>>>>
>>>>> Thanks,
>>>>> Kuai
>>>>>> ---
>>>>>>     drivers/md/dm-raid.c | 2 ++
>>>>>>     drivers/md/md.c      | 1 +
>>>>>>     2 files changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>>>>> index eb009d6bb03a..325767c1140f 100644
>>>>>> --- a/drivers/md/dm-raid.c
>>>>>> +++ b/drivers/md/dm-raid.c
>>>>>> @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct 
>>>>>> dm_target *ti)
>>>>>>         struct raid_set *rs = ti->private;
>>>>>>
>>>>>>         if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, 
>>>>>> &rs->runtime_flags)) {
>>>>>> +             if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
>>>>>> +                     clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);
>>>>>>                 /* Writes have to be stopped before suspending to 
>>>>>> avoid deadlocks. */
>>>>>>                 if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
>>>>>>                         md_stop_writes(&rs->md);
>>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>>> index 2266358d8074..54790261254d 100644
>>>>>> --- a/drivers/md/md.c
>>>>>> +++ b/drivers/md/md.c
>>>>>> @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev 
>>>>>> *mddev, bool locked, bool check_seq)
>>>>>>          * never happen
>>>>>>          */
>>>>>> md_wakeup_thread_directly(mddev->sync_thread);
>>>>>> +     md_wakeup_thread(mddev->sync_thread);
>>>>>>         if (work_pending(&mddev->sync_work))
>>>>>>                 flush_work(&mddev->sync_work);
>>>>>>
>>>>>>
>>>>>
>>>>
>>>> .
>>>>
>>>
>>
>> .
>>
>

