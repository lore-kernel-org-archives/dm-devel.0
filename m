Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2BC378805
	for <dm-devel@lists.linux.dev>; Tue,  7 Apr 2026 06:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775543115; cv=none; b=o7KxHneoESk5z4RLt8YUFja4sR3Q3Jt4ntweJBQ03v+edGgZZJP8CAbecx6bHBt1WERF8yCxD2dw7+vfnfEaC8xdo7Fb+bmT7g6UbxlvO7xce3+YB716hMWJ0g7/k+tg21cmm1Awx6nw0ZmCbLvGIvYpIb2O41rGaCxOiYRTNpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775543115; c=relaxed/simple;
	bh=orVkirP12pE/ABJ9SSy9C1B8zRj7D9II8M7h57as99c=;
	h=Date:In-Reply-To:To:References:Subject:Message-Id:Mime-Version:
	 Content-Type:Cc:From; b=Ke0xl+7hdiwLwDZ/oaKfM160eveEiUnmxAmWgbw8k3L8NabCXbQsY2HUYxlkaA7PmT3w2Aqj0p3trVOKsqep7tm3FYEtRfuqsxBr2rRZ3YGchOSrwtDASivrvFsGX7syZ3IC0zTlj6c+zOV8EAv0KOPREwCNTcADM9/Nw/jAlrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=wK0keBRD; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="wK0keBRD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775543099;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=a2nTOKsycmq1bc9UHxRQEShd0F7ENVRKaKZmTGaTqss=;
 b=wK0keBRDZnqd5UyqzwLWffSnYXRsUH92K0MJei/NJtozzFFMimzKa8vG5vNQDg+7Yc9fWb
 py0+gD8S43jQUwbu+tGNJEUPSrKeyvP7KAnyvoV3h7fgB6aVSQyhYobIouhdtW3Ka2f/h2
 f7arKKyHdZnBV3pkaSOw9KYH1eBAxvVPYlHGG9KBscn5ikI68OMZUlXDkU/LcCLYBXsxVx
 L8+LfJz3etA2wTVTx7j62fOC/F5eEOqo2PaT1rEKu3a4qOZanujd/VVNaNXSayVCJm4+Ca
 6rr9vNfAo1/ST7c/T8cCNoL6/BqGATs9t3wZliSHiQiFZkG3JgdDvX6VcWzxEw==
Date: Tue, 7 Apr 2026 14:24:53 +0800
In-Reply-To: <CALTww29gvZBft7-WGwY_-hZCnrxbAK3AAZf-AmGKn7M1t0-0rw@mail.gmail.com>
To: "Xiao Ni" <xni@redhat.com>, "Benjamin Marzinski" <bmarzins@redhat.com>
References: <20260323225836.1037060-1-bmarzins@redhat.com> <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com> <acrMIhAjB-HKszbs@redhat.com> <CALTww2-SE6b7bQ93ZbJ3N_Xxgrm4b8rv6Sukjt5cUVNHScPFRg@mail.gmail.com> <acv4A6WayrNbQEax@redhat.com> <CALTww29gvZBft7-WGwY_-hZCnrxbAK3AAZf-AmGKn7M1t0-0rw@mail.gmail.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
Message-Id: <f510f801-ae2c-4fe1-b3c2-0346d4237a9c@fnnas.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Cc: "Yu Kuai" <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	"Song Liu" <song@kernel.org>, "Li Nan" <linan122@huawei.com>, 
	<linux-raid@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	"Nigel Croxon" <ncroxon@redhat.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269d4a339+7d3150+lists.linux.dev+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 14:24:56 +0800

Hi,

=E5=9C=A8 2026/4/1 8:22, Xiao Ni =E5=86=99=E9=81=93:
> On Wed, Apr 1, 2026 at 12:36=E2=80=AFAM Benjamin Marzinski <bmarzins@redh=
at.com> wrote:
>> On Tue, Mar 31, 2026 at 10:24:48AM +0800, Xiao Ni wrote:
>>> On Tue, Mar 31, 2026 at 3:16=E2=80=AFAM Benjamin Marzinski <bmarzins@re=
dhat.com> wrote:
>>>> On Mon, Mar 30, 2026 at 11:44:54PM +0800, Xiao Ni wrote:
>>>>> On Tue, Mar 24, 2026 at 6:58=E2=80=AFAM Benjamin Marzinski <bmarzins@=
redhat.com> wrote:
>>>>>> If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
>>>>>> raid5_make_request() will free the cloned bio. But raid5_make_reques=
t()
>>>>>> can call make_stripe_request() multiple times, writing to the variou=
s
>>>>>> stripes. If that bio got added to the toread or towrite lists of a
>>>>>> stripe disk in an earlier call to make_stripe_request(), then it's n=
ot
>>>>>> safe to just free the bio if a later part of it is found to cross th=
e
>>>>>> reshape position. Doing so can lead to a UAF error, when bio_endio()
>>>>>> is called on the bio for the earlier stripes.
>>>>>>
>>>>>> Instead, raid5_make_request() needs to wait until all parts of the b=
io
>>>>>> have called bio_endio(). To do this, bios that cross the reshape
>>>>>> position while the reshape can't make progress are flagged as needin=
g a
>>>>>> retry, and mddev tracks the number of bios needing a retry which hav=
e
>>>>>> not yet completed. When raid5_make_request() has a bio that failed
>>>>>> make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
>>>>>> counter to reach zero. When the bio_endio() is called for the last t=
ime
>>>>>> on a bio needing a retry, it decrements mddev's count of outstanding
>>>>>> bios needing a retry. This guarantees that raid5_make_request() does=
n't
>>>>>> return until the cloned bio needing a retry for io across the reshap=
e
>>>>>> boundary is safely cleaned up.
>>>>>>
>>>>>> There is a simple reproducer available at [1]. Compile the kernel wi=
th
>>>>>> KASAN for more useful reporting when the error is triggered (this is=
 not
>>>>>> necessary to see the bug).
>>>>>>
>>>>>> [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa=
5
>>>>>>
>>>>>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>>>>>> ---
>>>>>>
>>>>>> I've tested this for regressions with the lvm2-testsuite raid tests.=
 I
>>>>>> have not run any md-specific tests on it.
>>>>>>
>>>>>>
>>>>>>   drivers/md/md.c    | 30 +++++++++---------------------
>>>>>>   drivers/md/md.h    |  5 ++++-
>>>>>>   drivers/md/raid5.c |  8 +++++++-
>>>>>>   3 files changed, 20 insertions(+), 23 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>>> index 3ce6f9e9d38e..5ec116b9da32 100644
>>>>>> --- a/drivers/md/md.c
>>>>>> +++ b/drivers/md/md.c
>>>>>> @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
>>>>>>          atomic_set(&mddev->active, 1);
>>>>>>          atomic_set(&mddev->openers, 0);
>>>>>>          atomic_set(&mddev->sync_seq, 0);
>>>>>> +       atomic_set(&mddev->pending_retry_bios, 0);
>>>>>>          spin_lock_init(&mddev->lock);
>>>>>>          init_waitqueue_head(&mddev->sb_wait);
>>>>>>          init_waitqueue_head(&mddev->recovery_wait);
>>>>>> +       init_waitqueue_head(&mddev->retry_bios_wait);
>>>>>>          mddev->reshape_position =3D MaxSector;
>>>>>>          mddev->reshape_backwards =3D 0;
>>>>>>          mddev->last_sync_action =3D ACTION_IDLE;
>>>>>> @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio)
>>>>>>          struct md_io_clone *md_io_clone =3D bio->bi_private;
>>>>>>          struct bio *orig_bio =3D md_io_clone->orig_bio;
>>>>>>          struct mddev *mddev =3D md_io_clone->mddev;
>>>>>> +       unsigned int must_retry =3D md_io_clone->must_retry;
>>>>>>
>>>>>>          if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enable=
d(mddev, false))
>>>>>>                  md_bitmap_end(mddev, md_io_clone);
>>>>>> @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bio)
>>>>>>                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
>>>>>>
>>>>>>          bio_put(bio);
>>>>>> -       bio_endio(orig_bio);
>>>>>> +       if (unlikely(must_retry)) {
>>>>>> +               if (atomic_dec_and_test(&mddev->pending_retry_bios))
>>>>>> +                       wake_up(&mddev->retry_bios_wait);
>>>>>> +       } else
>>>>>> +               bio_endio(orig_bio);
>>>>>>          percpu_ref_put(&mddev->active_io);
>>>>>>   }
>>>>>>
>>>>>> @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mddev, =
struct bio **bio)
>>>>>>          md_io_clone =3D container_of(clone, struct md_io_clone, bio=
_clone);
>>>>>>          md_io_clone->orig_bio =3D *bio;
>>>>>>          md_io_clone->mddev =3D mddev;
>>>>>> +       md_io_clone->must_retry =3D 0;
>>>>>>          if (blk_queue_io_stat(bdev->bd_disk->queue))
>>>>>>                  md_io_clone->start_time =3D bio_start_io_acct(*bio)=
;
>>>>>>
>>>>>> @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, stru=
ct bio **bio)
>>>>>>   }
>>>>>>   EXPORT_SYMBOL_GPL(md_account_bio);
>>>>>>
>>>>>> -void md_free_cloned_bio(struct bio *bio)
>>>>>> -{
>>>>>> -       struct md_io_clone *md_io_clone =3D bio->bi_private;
>>>>>> -       struct bio *orig_bio =3D md_io_clone->orig_bio;
>>>>>> -       struct mddev *mddev =3D md_io_clone->mddev;
>>>>>> -
>>>>>> -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled=
(mddev, false))
>>>>>> -               md_bitmap_end(mddev, md_io_clone);
>>>>>> -
>>>>>> -       if (bio->bi_status && !orig_bio->bi_status)
>>>>>> -               orig_bio->bi_status =3D bio->bi_status;
>>>>>> -
>>>>>> -       if (md_io_clone->start_time)
>>>>>> -               bio_end_io_acct(orig_bio, md_io_clone->start_time);
>>>>>> -
>>>>>> -       bio_put(bio);
>>>>>> -       percpu_ref_put(&mddev->active_io);
>>>>>> -}
>>>>>> -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
>>>>>> -
>>>>>>   /* md_allow_write(mddev)
>>>>>>    * Calling this ensures that the array is marked 'active' so that =
writes
>>>>>>    * may proceed without blocking.  It is important to call this bef=
ore
>>>>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>>>>>> index ac84289664cd..49a231f11676 100644
>>>>>> --- a/drivers/md/md.h
>>>>>> +++ b/drivers/md/md.h
>>>>>> @@ -626,6 +626,9 @@ struct mddev {
>>>>>>
>>>>>>          /* The sequence number for sync thread */
>>>>>>          atomic_t sync_seq;
>>>>>> +
>>>>>> +       wait_queue_head_t               retry_bios_wait;
>>>>>> +       atomic_t                        pending_retry_bios;
>>>>>>   };
>>>>>>
>>>>>>   enum recovery_flags {
>>>>>> @@ -877,6 +880,7 @@ struct md_io_clone {
>>>>>>          sector_t        offset;
>>>>>>          unsigned long   sectors;
>>>>>>          enum stat_group rw;
>>>>>> +       unsigned int    must_retry;
>>>>>>          struct bio      bio_clone;
>>>>>>   };
>>>>>>
>>>>>> @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *mdde=
v);
>>>>>>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rd=
ev,
>>>>>>                          struct bio *bio, sector_t start, sector_t s=
ize);
>>>>>>   void md_account_bio(struct mddev *mddev, struct bio **bio);
>>>>>> -void md_free_cloned_bio(struct bio *bio);
>>>>>>
>>>>>>   extern bool __must_check md_flush_request(struct mddev *mddev, str=
uct bio *bio);
>>>>>>   void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
>>>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>>>> index a8e8d431071b..fb78a757f2fd 100644
>>>>>> --- a/drivers/md/raid5.c
>>>>>> +++ b/drivers/md/raid5.c
>>>>>> @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mddev *=
mddev, struct bio * bi)
>>>>>>
>>>>>>          mempool_free(ctx, conf->ctx_pool);
>>>>>>          if (res =3D=3D STRIPE_WAIT_RESHAPE) {
>>>>>> -               md_free_cloned_bio(bi);
>>>>>> +               struct md_io_clone *md_io_clone =3D bi->bi_private;
>>>>>> +
>>>>>> +               md_io_clone->must_retry =3D 1;
>>>>>> +               atomic_inc(&mddev->pending_retry_bios);
>>>>>> +               bio_endio(bi);
>>>>>> +               wait_event(mddev->retry_bios_wait,
>>>>>> +                          atomic_read(&mddev->pending_retry_bios)=
=3D=3D0);
>>>>> Hi Ben
>>>>>
>>>>> There is a problem here. The new counter pending_retry_bios above
>>>>> doesn't represent the bios which have been added to stripes. So uaf
>>>>> still can happen.
>>>> I don't think it can. That counter won't be zero until there are no bi=
os
>>>> that need to get retried. So we way end up waiting too long, but we
>>>> shouldn't ever end up not waiting long enough.
>>> Ah, yes, you're right. I thought wrongly. The counter tracks multiple
>>> threads that encounter BLK_STS_RESOURCE. For each thread,
>>> md_end_clone_bio is called only when all bios return. But why do
>>> different threads need to sync at raid5_make_request?
>>>
>>>
>>>>> Do we need to add a new counter?
>>>> I did it that way because I wanted to avoid growing md_io_clone
>>>> ("must_retry" fit nicely in a hole in the structure, so it didn't take
>>>> up any extra space). But if you are fine with adding the extra
>>> Nice design.
>>>
>>>> reshape_completion pointer to md_io_clone, then your way avoids the
>>>> chance that we might wait when we don't need to.
>>> If you mention the threads sync here, yes.
>> I can certainly add comments explaining why I left off the READ_ONCE(),
>> WRITE_ONCE() (actually, there's no real reason not to keep the
>> WRITE_ONCE, since that's not in the fast path) if you think it makes
>> sense to leave them off.
>>
>> I'm fine with either my or your code for to deal with the waiting,
>> whichever you think makes more sense. Since this is a very hard bug to
>> hit, and the fix involves adding extra data to every bio and extra code
>> in the end_io function that all the raid bios call, I wanted to make the
>> impact as small as possible. But md_io_clone is still 8 bytes away from
>> filling up 3 cachelines (at 64 bytes a cacheline), so there's space to
>> add the reshape_completion pointer without increaseing the number of
>> cachelines, which means that your solution for waiting is probably the
>> way to go, unless you think something else might end up needing that
>> space.

I think it's not good to add a global counter in mddev, and I agree it's
not good to increase md_io_clone for this corner case.

How about we remove the use of bi_private filed, and replace it with
container_of() to get md_clone_io from md_end_clone_io. And then we can use
this field to record the completion without adding new field.

> Thanks. After thinking, as you said, this is a corner case. So both
> ways are fine with me also. Let's wait for Kuai's decision.
>
> Regards
> Xiao
>> -Ben
>>
>>>>> Because
>>>>> md_end_clone_io is only called when all bios return. How about
>>>>> something like:
>>>>>
>>>>> md_end_clone_io
>>>>> +       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
>>>>> +               complete(md_io_clone->reshape_completion);
>>>>> +       } else {
>>>>> +               bio_endio(orig_bio);
>>>>> +       }
>>>>>
>>>>> raid5_make_request:
>>>>>
>>>>>          if (res =3D=3D STRIPE_WAIT_RESHAPE) {
>>>>> -               md_free_cloned_bio(bi);
>>>>> +               struct md_io_clone *md_io_clone =3D bi->bi_private;
>>>>> +               struct completion done;
>>>>> +
>>>>> +               init_completion(&done);
>>>>> +               md_io_clone->reshape_completion =3D &done;
>>>>> +               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
>>>>> +
>>>>> +               bio_endio(bi);
>>>>> +
>>>>> +               wait_for_completion(&done);
>>>> This looks fine.
>>>>
>>>> I'm pretty sure that the READ_ONCE() and WRITE_ONCE() are unnecessary.
>>>> First, theres no chance that these operations will ever happen at the
>>>> same time and we're just writing a 1, so there's no chance of tearing.
>>> For the first point, I have a question. They can't happen
>>> simultaneously. But the cache of different CPUs may contain different
>>> values.
>>>
>>>> The compiler can't reorder setting md_io_clone->waiting_reshape to afe=
r
>>>> bio_endio(), since bio_endio can free md_io_clone. Also the compiler
>>>> can't reorder reading it to before calling md_end_clone_io() from
>>>> bio_endio(), obviously.
>>> Thanks very much for pointing this out.
>>>
>>>> If the bio was never chained, then there can't be a race, since only
>>>> raid5_make_request() will be calling bio_endio(). waiting_reshape will
>>>> be read by the same process that sets it.
>>>>
>>>> If the bio was chained, then like you said, md_end_clone_io() will onl=
y
>>>> get called by the final caller of bio_endio(). This is determined by
>>>> bio_remaining_done(), which guarantees a full memory barrier for
>>>> atomic_dec_and_test(&bio->__bi_remaining).
>>> Nice analysis! Thanks.
>>>
>>>> Since we know the compiler will keep these instructions on the proper
>>>> size of a full memory barrier, I'm pretty sure that this is concurrenc=
y
>>>> race free, even without the READ_ONCE() and WRITE_ONCE(). Like with
>>>> trying to avoid growing md_io_clone, I was trying to keep
>>>> md_end_clone_io() as fast as possible (at least on architectures where
>>>> READ_ONCE can have more of a performance impact) Again, if I'm
>>>> overthinking this (or if my concurrency argument is flawed) feel free =
to
>>>> ignore me.
>>> Thanks for your patience in explaining the concurrency problem. I
>>> agree with you. And it's better to add comments that describe the
>>> reason and it will help people understand it better.
>>>
>>> By the way, the md raid maintainer's email has changed. I fixed the
>>> email address in to list.
>>>
>>> Regards
>>> Xiao
>>>
>>>> -Ben
>>>>
>>>>> Best Regards
>>>>> Xiao
>>>>>
>>>>>
>>>>>>                  return false;
>>>>>>          }
>>>>>> --
>>>>>> 2.53.0
>>>>>>
>
--=20
Thansk,
Kuai
