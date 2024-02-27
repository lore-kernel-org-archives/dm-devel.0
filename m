Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9B553813
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 07:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709018199; cv=none; b=dihIdD5Y4ywAQrgvOgbTtq6zk4/fnXYdQN9MW8VwXDIyb6+fpPAoWxdnDtW1e6KNDgeUafvauQ1/0IYbdzvtTId73IWb/5FsXUnxJitRuPGVuX60ni+iPmFnaUZ0X3ZAubhIfQQSV/yohoLqVAcFwzIrE4UL6xXLfBVh11mPJ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709018199; c=relaxed/simple;
	bh=tSYqBQ5rDUOpF4gZsrBdeKe1e2vFJyx2bF9dRCF74/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXoSi8dxcgLJfGQO7DKJp/xpF+BCh7zDxX0kqykg4LOF44vzc1JUoEK+kDxpDlcgiN5WSR1s4As7rxHtqru0J4j6oiT7YOhvN5mrcmBYbAmcUFBqiaT/W+nTTfEvzr27LN5IUxz8tvaj/iWatAP7dpetqJDY1J3PNeL+MHiDtyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RLFuw2RW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLFuw2RW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709018196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=REGcb14ZFO3w6ORcYPKceemmN1xLnVtT0z9zccBb/yk=;
	b=RLFuw2RWUunqtNBNZDv552+nlghbabZArveEwwRGaTwiLtQQ3Z60eMsqLaJ8+Ef/+0NMZZ
	Zc7pfX+6n2y0IH1gDkqhAKzEkvONs4D52g/FABZ7g8g/tjWiHgrx3p6XiQWsFg6vVTlGNs
	RpY7qLtpFJj5ucFg9V9/Wu4riUeHQlE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-ICgYnQt8PdCfP03lLwARVg-1; Tue, 27 Feb 2024 02:16:35 -0500
X-MC-Unique: ICgYnQt8PdCfP03lLwARVg-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5c6245bc7caso3285984a12.3
        for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 23:16:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709018194; x=1709622994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REGcb14ZFO3w6ORcYPKceemmN1xLnVtT0z9zccBb/yk=;
        b=jEZhtnDsvXNvp8qvYdMVbQCJ0n7s7hELSRyX/1oyXs1cyNBrzXCRuvjzozWNvld2Ep
         KrzD6k9stbyTUDFwzIGzj0vhbDhKfLw5XXSwhYEwLxUgTT4yH+0hpKpkyMKozysej8mm
         lwVGFeB2GS3rh/ZWbHx9WHZHzyNzHf4exH+NbZXOXXKQb2BR5QPbRvMnA4X5ueObCO0j
         XPGMB2GTAhecf/h8iR1T7jjRVgImrE69kPg+r5k/LzcRnYPI7kKKOU4w0XfEKgObb2ap
         wsUhTsm4dlv7rTf781JOaMt/QJYN/H/huixYia6s/i01i/upPE3fYyRde/pMRsRFKTW0
         PCuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBq3LgTUKNsqWnxucVE/thtGC1xvFI7fMPDdW/yYwbW8OZos3xrMbfzeQ7nk5q7smibedScDR4N8T3vG6q3+NK7Hj1zjDIhyc=
X-Gm-Message-State: AOJu0YyP4sSIZb/sNjZMbmC7qQJuBKtxVpcQy6y8KKgUv7wrpwVrqR9z
	2kuwH/fM6oZIvw7TtUkaBy6EnW/UFT8Cm17xjlSqnpzb28EF8lhESgpNk+N5+6Fos6aP9C0U3O7
	kVxBHhqKcvjSVdFYft2oEvVY6BlKAVyXs4SKfKr7oEe4n2CsM32RuearK/ySeejbJXsigX66x29
	JXcnMgR+Rohzi778njigfUs6nR8ZzeDUk=
X-Received: by 2002:a05:6a21:9183:b0:1a0:f5d7:5f49 with SMTP id tp3-20020a056a21918300b001a0f5d75f49mr1706233pzb.32.1709018194021;
        Mon, 26 Feb 2024 23:16:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmqcJEZ69jBQjti4vUpyjMavgeU57f2GPd1cEQc8V58TWmFFgZgbVH0ZHe8pyscQ8R2j9fQTSQQ7/+ahxbtp0=
X-Received: by 2002:a05:6a21:9183:b0:1a0:f5d7:5f49 with SMTP id
 tp3-20020a056a21918300b001a0f5d75f49mr1706220pzb.32.1709018193652; Mon, 26
 Feb 2024 23:16:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-2-xni@redhat.com>
 <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com> <CALTww2-3WgtGMDpeDphcfkdCxORf5bTSFZATSZ=m3S4VbPv26w@mail.gmail.com>
 <15439a9b-1170-09a3-caf0-e1020e78b713@huaweicloud.com> <CALTww29H7+kau-V-wx9kPM4Beu9niUaYcDt+DvXGrQdUNP_Aag@mail.gmail.com>
 <380b448c-32f9-4bf3-8626-4f8086047fca@huaweicloud.com>
In-Reply-To: <380b448c-32f9-4bf3-8626-4f8086047fca@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 27 Feb 2024 15:16:22 +0800
Message-ID: <CALTww2_WwNstUWM4QwNFfKXiyp9+KH5Wsk40ZS=1xuLEttaOhg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 5:36=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/26 13:12, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, Feb 26, 2024 at 9:31=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/02/23 21:20, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Fri, Feb 23, 2024 at 11:32=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud=
.com> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> >>>>> MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patc=
h
> >>>>> commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")=
.
> >>>>> Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
> >>>>> dmraid stopped sync thread directy by calling md_reap_sync_thread.
> >>>>> After this patch dmraid stops sync thread asynchronously as md does=
.
> >>>>> This is right. Now the dmraid stop process is like this:
> >>>>>
> >>>>> 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_th=
read.
> >>>>> stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_R=
UNNING
> >>>>> is cleared
> >>>>> 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is th=
e
> >>>>> root cause for this deadlock. We hope md_do_sync can set MD_RECOVER=
Y_DONE)
> >>>>> 3. md thread calls md_check_recovery (This is the place to reap syn=
c
> >>>>> thread. Because MD_RECOVERY_DONE is not set. md thread can't reap s=
ync
> >>>>> thread)
> >>>>> 4. raid_dtr stops/free struct mddev and release dmraid related reso=
urces
> >>>>>
> >>>>> dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to=
 clear
> >>>>> this bit when stopping the dmraid before stopping sync thread.
> >>>>>
> >>>>> But the deadlock still can happen sometimes even MD_RECOVERY_WAIT i=
s
> >>>>> cleared before stopping sync thread. It's the reason stop_sync_thre=
ad only
> >>>>> wakes up task. If the task isn't running, it still needs to wake up=
 sync
> >>>>> thread too.
> >>>>>
> >>>>> This deadlock can be reproduced 100% by these commands:
> >>>>> modprobe brd rd_size=3D34816 rd_nr=3D5
> >>>>> while [ 1 ]; do
> >>>>> vgcreate test_vg /dev/ram*
> >>>>> lvcreate --type raid5 -L 16M -n test_lv test_vg
> >>>>> lvconvert -y --stripes 4 /dev/test_vg/test_lv
> >>>>> vgremove test_vg -ff
> >>>>> sleep 1
> >>>>> done
> >>>>>
> >>>>> Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
> >>>>> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> >>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>>>
> >>>> I'm not sure about this change, I think MD_RECOVERY_WAIT is hacky an=
d
> >>>> really breaks how sync_thread is working, it should just go away soo=
n,
> >>>> once we make sure sync_thread can't be registered before pers->start=
()
> >>>> is done.
> >>>
> >>> Hi Kuai
> >>>
> >>> I just want to get to a stable state without changing any existing
> >>> logic. After fixing these regressions, we can consider other changes.
> >>> (e.g. remove MD_RECOVERY_WAIT. allow sync thread start/stop when arra=
y
> >>> is suspend. )  I talked with Heinz yesterday, for dm-raid, it can't
> >>> allow any io to happen including sync thread when array is suspended.
> >>
> >
> > Hi Kuai
> >
> >> So, are you still thinking that my patchset will allow this for dm-rai=
d?
> >>
> >> I already explain a lot why patch 1 from my set is okay, and why the s=
et
> >> doesn't introduce any behaviour change like you said in this patch 0:
> >
> >
> > I'll read all your patches to understand you well.
> >
> > But as I mentioned many times too, we're fixing regression problems.
> > It's better for us to fix them with the smallest change. As you can
> > see, in my patch set, we can fix these regression problems with small
> > changes (Sorry I didn't notice your patch set has some changes which
> > are the same with mine).  So why don't we need such a big change to
> > fix the regression problems? Now with my patch set I can reproduce a
> > problem by lvm2 test suit which happens in 6.6 too. It means with this
> > patch set we can back to a state same with 6.6.

Hi Kuai

>
> For complexity, I agree that we can go back to the same state with v6.6,
> and then fix other problems on the top of that. I don't have preference
> for this, I'll post my patchset anyhow. But other than the test suite,
> you still need to make sure nothing is broken from the big picture.

Thanks very much for this. I'm glad that we can reach an agreement :)
What's the preference you mean? The branch with my patch set? I'll
send a formal patch set later.

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

Are they all dmsetup message commands? MD_RECOVERY_WAIT is used to
delay reshape to start. The sync thread (reshape) will start once
MD_RECOVERY_WAIT is cleared. I did tests with lvm commands. For the
three cases mentioned above, I need to check.
>
> >
> >
> >
> >>
> >> "Kuai's patch set breaks some rules".
> >>
> >> The only thing that will change is that for md/raid, sync_thrad can
> >> start for suspended array, however, I don't think this will be a probl=
em
> >> because sync_thread can be running for suspended array already, and
> >> 'MD_RECOVERY_FROZEN' is already used to prevent sync_thread to start.
> >
> > We can't allow sync thread happen for dmraid when it's suspended.
> > Because it needs to switch table when suspended. It's a base design.
> > If it can happen now. We should fix this.
>
> Yes, and my patchset also fix this, and other problems related to
> sync_thread by managing sync_thread the same as md/raid.
>
> BTW, on the top my patchset, I already made some change locally to
> expand MD_RECOVERY_FROZEN and remove MD_RECOVERY_WAIT, if you're going
> to review my patchset, you can take a look at following change later,
> I already tested the change.

We can work on this in the future to fix problems one by one. Please
try to make one patch set to resolve one problem. It's easy for
review.

Best Regards
Xiao

>
> Thanks,
> Kuai
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index e1b3b1917627..a0c8a5b92aab 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -213,6 +213,7 @@ struct raid_dev {
>   #define RT_FLAG_RS_IN_SYNC             6
>   #define RT_FLAG_RS_RESYNCING           7
>   #define RT_FLAG_RS_GROW                        8
> +#define RT_FLAG_WAIT_RELOAD            9
>
>   /* Array elements of 64 bit needed for rebuild/failed disk bits */
>   #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 -
> 1)) / sizeof(uint64_t) / 8)
> @@ -3728,6 +3729,9 @@ static int raid_message(struct dm_target *ti,
> unsigned int argc, char **argv,
>          if (test_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
>                  return -EBUSY;
>
> +       if (test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags))
> +               return -EINVAL;
> +
>          if (!strcasecmp(argv[0], "frozen")) {
>                  ret =3D mddev_lock(mddev);
>                  if (ret)
> @@ -3809,21 +3813,25 @@ static void raid_presuspend(struct dm_target *ti)
>          struct raid_set *rs =3D ti->private;
>          struct mddev *mddev =3D &rs->md;
>
> -       mddev_lock_nointr(mddev);
> -       md_frozen_sync_thread(mddev);
> -       mddev_unlock(mddev);
> +       if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags)) {
> +               mddev_lock_nointr(mddev);
> +               md_frozen_sync_thread(mddev);
> +               mddev_unlock(mddev);
>
> -       if (mddev->pers && mddev->pers->prepare_suspend)
> -               mddev->pers->prepare_suspend(mddev);
> +               if (mddev->pers && mddev->pers->prepare_suspend)
> +                       mddev->pers->prepare_suspend(mddev);
> +       }
>   }
>
>   static void raid_presuspend_undo(struct dm_target *ti)
>   {
>          struct raid_set *rs =3D ti->private;
>
> -       mddev_lock_nointr(&rs->md);
> -       md_unfrozen_sync_thread(&rs->md);
> -       mddev_unlock(&rs->md);
> +       if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags)) {
> +               mddev_lock_nointr(&rs->md);
> +               md_unfrozen_sync_thread(&rs->md);
> +               mddev_unlock(&rs->md);
> +       }
>   }
>
>   static void raid_postsuspend(struct dm_target *ti)
> @@ -3958,9 +3966,6 @@ static int rs_start_reshape(struct raid_set *rs)
>          struct mddev *mddev =3D &rs->md;
>          struct md_personality *pers =3D mddev->pers;
>
> -       /* Don't allow the sync thread to work until the table gets
> reloaded. */
> -       set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
> -
>          r =3D rs_setup_reshape(rs);
>          if (r)
>                  return r;
> @@ -4055,6 +4060,7 @@ static int raid_preresume(struct dm_target *ti)
>                  /* Initiate a reshape. */
>                  rs_set_rdev_sectors(rs);
>                  mddev_lock_nointr(mddev);
> +               set_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags);
>                  r =3D rs_start_reshape(rs);
>                  mddev_unlock(mddev);
>                  if (r)
> @@ -4089,7 +4095,8 @@ static void raid_resume(struct dm_target *ti)
>                  mddev_lock_nointr(mddev);
>                  mddev->ro =3D 0;
>                  mddev->in_sync =3D 0;
> -               md_unfrozen_sync_thread(mddev);
> +               if (!test_bit(RT_FLAG_WAIT_RELOAD, &rs->runtime_flags))
> +                       md_unfrozen_sync_thread(mddev);
>                  mddev_unlock(mddev);
>          }
>   }
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 81e6f49a14fc..595b1fbdce20 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6064,7 +6064,8 @@ int md_run(struct mddev *mddev)
>                          pr_warn("True protection against single-disk
> failure might be compromised.\n");
>          }
>
> -       mddev->recovery =3D 0;
> +       /* dm-raid expect sync_thread to be frozen until resume */
> +       mddev->recovery &=3D BIT_ULL_MASK(MD_RECOVERY_FROZEN);
>          /* may be over-ridden by personality */
>          mddev->resync_max_sectors =3D mddev->dev_sectors;
>
> @@ -6237,10 +6238,8 @@ int md_start(struct mddev *mddev)
>          int ret =3D 0;
>
>          if (mddev->pers->start) {
> -               set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
>                  ret =3D mddev->pers->start(mddev);
> -               clear_bit(MD_RECOVERY_WAIT, &mddev->recovery);
> -               md_wakeup_thread(mddev->sync_thread);
> +               WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING,
> &mddev->recovery));
>          }
>          return ret;
>   }
> @@ -8827,8 +8825,7 @@ void md_do_sync(struct md_thread *thread)
>          if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>                  goto skip;
>
> -       if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
> -           !md_is_rdwr(mddev)) {/* never try to sync a read-only array *=
/
> +       if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array *=
/
>                  set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>                  goto skip;
>          }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index c17b7e68c533..eb00cdadc9c5 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -554,7 +554,6 @@ enum recovery_flags {
>          MD_RECOVERY_RESHAPE,    /* A reshape is happening */
>          MD_RECOVERY_FROZEN,     /* User request to abort, and not
> restart, any action */
>          MD_RECOVERY_ERROR,      /* sync-action interrupted because
> io-error */
> -       MD_RECOVERY_WAIT,       /* waiting for pers->start() to finish */
>          MD_RESYNCING_REMOTE,    /* remote node is running resync thread =
*/
>   };
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index acce2868e491..530a7f0b120b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5919,7 +5919,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
>   static bool reshape_disabled(struct mddev *mddev)
>   {
>          return !md_is_rdwr(mddev) ||
> -              test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
>                 test_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   }
>
> >
> > Best Regards
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>
> >>>
> >>> Regards
> >>> Xiao
> >>>>
> >>>> Thanks,
> >>>> Kuai
> >>>>> ---
> >>>>>     drivers/md/dm-raid.c | 2 ++
> >>>>>     drivers/md/md.c      | 1 +
> >>>>>     2 files changed, 3 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>>>> index eb009d6bb03a..325767c1140f 100644
> >>>>> --- a/drivers/md/dm-raid.c
> >>>>> +++ b/drivers/md/dm-raid.c
> >>>>> @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target=
 *ti)
> >>>>>         struct raid_set *rs =3D ti->private;
> >>>>>
> >>>>>         if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_fl=
ags)) {
> >>>>> +             if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
> >>>>> +                     clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery)=
;
> >>>>>                 /* Writes have to be stopped before suspending to a=
void deadlocks. */
> >>>>>                 if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery)=
)
> >>>>>                         md_stop_writes(&rs->md);
> >>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>>>> index 2266358d8074..54790261254d 100644
> >>>>> --- a/drivers/md/md.c
> >>>>> +++ b/drivers/md/md.c
> >>>>> @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *md=
dev, bool locked, bool check_seq)
> >>>>>          * never happen
> >>>>>          */
> >>>>>         md_wakeup_thread_directly(mddev->sync_thread);
> >>>>> +     md_wakeup_thread(mddev->sync_thread);
> >>>>>         if (work_pending(&mddev->sync_work))
> >>>>>                 flush_work(&mddev->sync_work);
> >>>>>
> >>>>>
> >>>>
> >>>
> >>> .
> >>>
> >>
> >
> > .
> >
>

