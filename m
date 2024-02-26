Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839801B7E1
	for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 05:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708924351; cv=none; b=olJjnwnIZ5hnxmvoFWH+T8rS8xCTzkwDo2Y3rcT2QdKFQBcSPV1Mpu6LqBCWB0rN2LfQLXrLBkOCvJzgCCs0qUO5ZktPU0AukZF/TZVniG8CpMGtGGiT82ME5r2qsPamrzgHOa8LTPjus26Jx7Q6O4v1jv7TAw+349X+cZEyZRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708924351; c=relaxed/simple;
	bh=KqlmOVtGoUefakZG/WqGvYeTGoB6+9PnZsPJmc5e/5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MxXRrlpITNCH8DFxyUh9UYjFSLaoJBHp6HQrsbtkmVehUlGBzJV02059DNiCrEdOIYJSuX8WUll4smC/dyv5h+RLKe4d39FiglkY4o1AVEvl2CKiPubCay0zBnd6F5XO94rZqNZV4movTNfonYw6+0RV4aFPqX8GSRAK1u+qI4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KMCDg/3q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KMCDg/3q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708924348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U1gtEf79F3Bw11he1ADUXNhmB6o0JZE9Su321zR0ac4=;
	b=KMCDg/3qmGmVO777NBW8ZJlA04pVQqJWoBYR2i1ck7mLWXsODQRBG8dcqBfduFpbtdJ2Y7
	z67cgWYZpzkdhJyMHdzsUcoBDqyB07luHCsODdvjDjMQOX1yMJR4iDO2+AN/INNNjZxhp9
	aiq8O1XYk3GT74NEQkre+agC4TTeYPk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-ONe46UICMqy9gqqTD8HUdg-1; Mon, 26 Feb 2024 00:12:24 -0500
X-MC-Unique: ONe46UICMqy9gqqTD8HUdg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-290a26e6482so2583357a91.0
        for <dm-devel@lists.linux.dev>; Sun, 25 Feb 2024 21:12:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708924344; x=1709529144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1gtEf79F3Bw11he1ADUXNhmB6o0JZE9Su321zR0ac4=;
        b=U4Rkvoxz+QeiFsQfuPMSgn3JPLRlAB/93qro0e0sr+7xgyeUx1QDpiLPCZ90Vckpqx
         33rPyTJDGCo6gfJPBNnUe0qA83BB/f0Ip9ElfRdRwiMIVBAOpa1Tp522CxvutF81jmHj
         8KeQtdcwbAoL2DBWtNjYTmwkfy94EOj2GgM+aWgucXnBFZ9T+qk82c/TaV+o1ibwsZvE
         39cSxec/gB3sXg8zdHcZim+1iYv3l90WicL4hyWwio6FxTEUJdFw7BFgadZ67/5G/moT
         DDB4e4KI5zm3jnb/l8zfHthHOKhZWRwC4kwD89DkuC8ZYVFu25095OfPOjcIy1VBx8ri
         Wm4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWw4Wg9sYfeRcfUQQVhyyzlAaDswhUwCN+A5s+8BgjUY04bL63L8W/0mI6PVxS4KUDyxkIrSbr5RXnKGAyL1ZWgn5Jyzgcp6B0=
X-Gm-Message-State: AOJu0YwDf3Cjp5q0r89A8EzHtIRtuk5B5/cOy1A4NGEwai6IW2XutvDs
	QlRf/Y/kvIUObpVWPCylL5dGeSJwZdiMGr5uu3jfCXO6GcUpUmkFF3EhTxKA1KQ04q3aQ6AT/jj
	wur7gA6dIdXbqDQe4yuSb1+qdeVGDC8tRrZWXt38UBiZqQVL4m6v2HW4aqNP4INbeEISX90ogKW
	qitfE2aUxHiH35sdsA06PCaaJ4eYe3Pf0=
X-Received: by 2002:a17:90a:f003:b0:29a:b73c:4978 with SMTP id bt3-20020a17090af00300b0029ab73c4978mr1558622pjb.33.1708924343763;
        Sun, 25 Feb 2024 21:12:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXjOzzRhOy4V6HeBmrUkV+HKKee71QXpOMJbGu9Se0ZlJnXoIaOkY9COcsh4wIHLCWbmk5r0n6djU7ATkgvps=
X-Received: by 2002:a17:90a:f003:b0:29a:b73c:4978 with SMTP id
 bt3-20020a17090af00300b0029ab73c4978mr1558612pjb.33.1708924343384; Sun, 25
 Feb 2024 21:12:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-2-xni@redhat.com>
 <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com> <CALTww2-3WgtGMDpeDphcfkdCxORf5bTSFZATSZ=m3S4VbPv26w@mail.gmail.com>
 <15439a9b-1170-09a3-caf0-e1020e78b713@huaweicloud.com>
In-Reply-To: <15439a9b-1170-09a3-caf0-e1020e78b713@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Feb 2024 13:12:12 +0800
Message-ID: <CALTww29H7+kau-V-wx9kPM4Beu9niUaYcDt+DvXGrQdUNP_Aag@mail.gmail.com>
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

On Mon, Feb 26, 2024 at 9:31=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/23 21:20, Xiao Ni =E5=86=99=E9=81=93:
> > On Fri, Feb 23, 2024 at 11:32=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> >>> MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
> >>> commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
> >>> Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
> >>> dmraid stopped sync thread directy by calling md_reap_sync_thread.
> >>> After this patch dmraid stops sync thread asynchronously as md does.
> >>> This is right. Now the dmraid stop process is like this:
> >>>
> >>> 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thre=
ad.
> >>> stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_RUN=
NING
> >>> is cleared
> >>> 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
> >>> root cause for this deadlock. We hope md_do_sync can set MD_RECOVERY_=
DONE)
> >>> 3. md thread calls md_check_recovery (This is the place to reap sync
> >>> thread. Because MD_RECOVERY_DONE is not set. md thread can't reap syn=
c
> >>> thread)
> >>> 4. raid_dtr stops/free struct mddev and release dmraid related resour=
ces
> >>>
> >>> dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to c=
lear
> >>> this bit when stopping the dmraid before stopping sync thread.
> >>>
> >>> But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
> >>> cleared before stopping sync thread. It's the reason stop_sync_thread=
 only
> >>> wakes up task. If the task isn't running, it still needs to wake up s=
ync
> >>> thread too.
> >>>
> >>> This deadlock can be reproduced 100% by these commands:
> >>> modprobe brd rd_size=3D34816 rd_nr=3D5
> >>> while [ 1 ]; do
> >>> vgcreate test_vg /dev/ram*
> >>> lvcreate --type raid5 -L 16M -n test_lv test_vg
> >>> lvconvert -y --stripes 4 /dev/test_vg/test_lv
> >>> vgremove test_vg -ff
> >>> sleep 1
> >>> done
> >>>
> >>> Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
> >>> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>
> >> I'm not sure about this change, I think MD_RECOVERY_WAIT is hacky and
> >> really breaks how sync_thread is working, it should just go away soon,
> >> once we make sure sync_thread can't be registered before pers->start()
> >> is done.
> >
> > Hi Kuai
> >
> > I just want to get to a stable state without changing any existing
> > logic. After fixing these regressions, we can consider other changes.
> > (e.g. remove MD_RECOVERY_WAIT. allow sync thread start/stop when array
> > is suspend. )  I talked with Heinz yesterday, for dm-raid, it can't
> > allow any io to happen including sync thread when array is suspended.
>

Hi Kuai

> So, are you still thinking that my patchset will allow this for dm-raid?
>
> I already explain a lot why patch 1 from my set is okay, and why the set
> doesn't introduce any behaviour change like you said in this patch 0:


I'll read all your patches to understand you well.

But as I mentioned many times too, we're fixing regression problems.
It's better for us to fix them with the smallest change. As you can
see, in my patch set, we can fix these regression problems with small
changes (Sorry I didn't notice your patch set has some changes which
are the same with mine).  So why don't we need such a big change to
fix the regression problems? Now with my patch set I can reproduce a
problem by lvm2 test suit which happens in 6.6 too. It means with this
patch set we can back to a state same with 6.6.



>
> "Kuai's patch set breaks some rules".
>
> The only thing that will change is that for md/raid, sync_thrad can
> start for suspended array, however, I don't think this will be a problem
> because sync_thread can be running for suspended array already, and
> 'MD_RECOVERY_FROZEN' is already used to prevent sync_thread to start.

We can't allow sync thread happen for dmraid when it's suspended.
Because it needs to switch table when suspended. It's a base design.
If it can happen now. We should fix this.

Best Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Regards
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>> ---
> >>>    drivers/md/dm-raid.c | 2 ++
> >>>    drivers/md/md.c      | 1 +
> >>>    2 files changed, 3 insertions(+)
> >>>
> >>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>> index eb009d6bb03a..325767c1140f 100644
> >>> --- a/drivers/md/dm-raid.c
> >>> +++ b/drivers/md/dm-raid.c
> >>> @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target *=
ti)
> >>>        struct raid_set *rs =3D ti->private;
> >>>
> >>>        if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags=
)) {
> >>> +             if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
> >>> +                     clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);
> >>>                /* Writes have to be stopped before suspending to avoi=
d deadlocks. */
> >>>                if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
> >>>                        md_stop_writes(&rs->md);
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index 2266358d8074..54790261254d 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *mdde=
v, bool locked, bool check_seq)
> >>>         * never happen
> >>>         */
> >>>        md_wakeup_thread_directly(mddev->sync_thread);
> >>> +     md_wakeup_thread(mddev->sync_thread);
> >>>        if (work_pending(&mddev->sync_work))
> >>>                flush_work(&mddev->sync_work);
> >>>
> >>>
> >>
> >
> > .
> >
>

