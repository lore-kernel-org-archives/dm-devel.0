Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FAE7E78B
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 13:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708694457; cv=none; b=X4UD9iyXmdRl+jJYh1bLwCqWuo7XYuGyUqIfDP18gC0z3eZiyjmxgZUqz1bPMdcD+jIpT20D51ik41NwlVKFopj9HGq5FkZZprs41xpFN8ZF9ZWc3UbKjhRkS/VLe4Bk08Md02P3TcyW0nBZIce8uxPPL3I9ZhRsSOEATZbU1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708694457; c=relaxed/simple;
	bh=gWuRgZKbISrsOUxx4DI0wL7M/qTJ8zP6W3B6ttagXW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uon+jbhGK2IQTGqwkgEOnKic9mbWwEPVWsqopyaSViXcOPU3nB7xSZmeqyT4aCQyTKUSOcGFQdKb/WvltgVeTePxPe2HIz9MOum4PdVoRUO5N2Y/o0WNHJPxU+ha8rZiL3sjiIdmhBtfKvzT0Q2Y9Vm9Am1BHm03g8xyxbTyPlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIEOmgzr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIEOmgzr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708694453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tWiyGY1k8fErfSxXaJlrYF3F4fWiFw8cllnBWF7U1zQ=;
	b=NIEOmgzrnRsCX8O4c3aXoVRc/jfqnTJX3BOOeSLeuTBHznfDS4jZk/WqAMS8RhguTtSseA
	km74OpSASJsBSO8pWJil3DT6ghUUc7MgFnItiLWoDerRSochBfwum31rCFapooL2sS5u20
	aOwC7HfY40pEzbqGyS+/fh1nRk0gP2o=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-KvVyFLMoM2eXf9yxfHJw5Q-1; Fri, 23 Feb 2024 08:20:52 -0500
X-MC-Unique: KvVyFLMoM2eXf9yxfHJw5Q-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6e48d81109eso603932b3a.1
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 05:20:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708694451; x=1709299251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWiyGY1k8fErfSxXaJlrYF3F4fWiFw8cllnBWF7U1zQ=;
        b=GBvy+7rbUkQQimF8DQNq07o/gLXXhYTZFLmhVVj3cIgwcVYCu24wnvNrEGt/dCe4eH
         m5QVwhsxFiAA24Kn1NR9FFtclQPM3J5kgzIaFlFtZo1Se+7P9Ubcdjyb7eO4He1DJ8lC
         d2Jv3WSAQ9pr9IFBGmaF1DdOhaRQnH4uA/OCck/3cXEnWHB2HepjJEXkIV5v9EBzRkYy
         Rh4zBIMUleFqJW2l4bQLFmKglB32VrHLTLxv8xfB7d6S1ILq7potrir9+i6nV9tAzAac
         2aDVXg3cBBaXZbKiZe23Y1prNdaWhqHQqNoR05IiCu2qHKh9VdTysSbF+YyG9UXt2l/t
         fRCA==
X-Forwarded-Encrypted: i=1; AJvYcCW4YwjMTzeb9FMA9XtS7Lw2aCAw5yYd3vVr5TRcwbIE8EbvJDbBVod4AdRBxwze30bx4GdBxbiNLITUccJHwHjp3DDtHgOjGTs=
X-Gm-Message-State: AOJu0YwzR2wTvglwFu6Die3srF4O4t068ric7sF9tohBmZxPsLaBuosE
	o1xtfnms0ZM6cHTvnRxdJ7jBjqCgwNxG1x5W225FtJKb0x+5BevakjjuOb2nKjrUcm+3qKsGND8
	W7/XYHgys5pp/7bODCBhqMl1sSdpiF6MfI0C35WnPXTEYvFV/EF127GzwpqWIZb7+fAd4Lji5QO
	/AuWTgM8n+riLdiNKV2pcuCTdnAseEmU4=
X-Received: by 2002:a05:6a21:9808:b0:1a0:ddbb:76e with SMTP id ue8-20020a056a21980800b001a0ddbb076emr1349750pzb.33.1708694450925;
        Fri, 23 Feb 2024 05:20:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3u0rAdVy1do38iVNK3ps8vGftvxf5SQZOg5L4YtecFfe2FjBogYhZavwnrNzJkwAkcMA3TxixU4g7JwXZr1U=
X-Received: by 2002:a05:6a21:9808:b0:1a0:ddbb:76e with SMTP id
 ue8-20020a056a21980800b001a0ddbb076emr1349735pzb.33.1708694450643; Fri, 23
 Feb 2024 05:20:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-2-xni@redhat.com>
 <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com>
In-Reply-To: <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 23 Feb 2024 21:20:39 +0800
Message-ID: <CALTww2-3WgtGMDpeDphcfkdCxORf5bTSFZATSZ=m3S4VbPv26w@mail.gmail.com>
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

On Fri, Feb 23, 2024 at 11:32=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> > MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
> > commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
> > Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
> > dmraid stopped sync thread directy by calling md_reap_sync_thread.
> > After this patch dmraid stops sync thread asynchronously as md does.
> > This is right. Now the dmraid stop process is like this:
> >
> > 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thread=
.
> > stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_RUNNI=
NG
> > is cleared
> > 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
> > root cause for this deadlock. We hope md_do_sync can set MD_RECOVERY_DO=
NE)
> > 3. md thread calls md_check_recovery (This is the place to reap sync
> > thread. Because MD_RECOVERY_DONE is not set. md thread can't reap sync
> > thread)
> > 4. raid_dtr stops/free struct mddev and release dmraid related resource=
s
> >
> > dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to cle=
ar
> > this bit when stopping the dmraid before stopping sync thread.
> >
> > But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
> > cleared before stopping sync thread. It's the reason stop_sync_thread o=
nly
> > wakes up task. If the task isn't running, it still needs to wake up syn=
c
> > thread too.
> >
> > This deadlock can be reproduced 100% by these commands:
> > modprobe brd rd_size=3D34816 rd_nr=3D5
> > while [ 1 ]; do
> > vgcreate test_vg /dev/ram*
> > lvcreate --type raid5 -L 16M -n test_lv test_vg
> > lvconvert -y --stripes 4 /dev/test_vg/test_lv
> > vgremove test_vg -ff
> > sleep 1
> > done
> >
> > Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
> > Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
>
> I'm not sure about this change, I think MD_RECOVERY_WAIT is hacky and
> really breaks how sync_thread is working, it should just go away soon,
> once we make sure sync_thread can't be registered before pers->start()
> is done.

Hi Kuai

I just want to get to a stable state without changing any existing
logic. After fixing these regressions, we can consider other changes.
(e.g. remove MD_RECOVERY_WAIT. allow sync thread start/stop when array
is suspend. )  I talked with Heinz yesterday, for dm-raid, it can't
allow any io to happen including sync thread when array is suspended.

Regards
Xiao
>
> Thanks,
> Kuai
> > ---
> >   drivers/md/dm-raid.c | 2 ++
> >   drivers/md/md.c      | 1 +
> >   2 files changed, 3 insertions(+)
> >
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index eb009d6bb03a..325767c1140f 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target *ti=
)
> >       struct raid_set *rs =3D ti->private;
> >
> >       if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) =
{
> > +             if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
> > +                     clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);
> >               /* Writes have to be stopped before suspending to avoid d=
eadlocks. */
> >               if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
> >                       md_stop_writes(&rs->md);
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 2266358d8074..54790261254d 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked, bool check_seq)
> >        * never happen
> >        */
> >       md_wakeup_thread_directly(mddev->sync_thread);
> > +     md_wakeup_thread(mddev->sync_thread);
> >       if (work_pending(&mddev->sync_work))
> >               flush_work(&mddev->sync_work);
> >
> >
>

