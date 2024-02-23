Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E567F7CC
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 13:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708695646; cv=none; b=CqcBipG1Tm5nSHkh6EKlCbCEEk7V11cw43iAM9i/2BysHnkNcEz/WkrVUIAmpXlW/lCdI9VsBdKqixUrWZo+KBwo2fSMheIITdcEX12gF3XUFH6nA+jsi1YZMYlLhnOggYFFzlVJdTG8mJ5f9f8PaBbURqbQEPRRNqKgFw2+ZwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708695646; c=relaxed/simple;
	bh=1ou7BhyvNlU3XvogfIYPfZodfgPLE2RBYZF3lttgIos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qVHFcR0BcekCzj9se/Zp4nYgVhEDqoPLH6psQCFPRW5qxdo8yJJsDce7RXsRDDRdM0dM+RfYwkafQDzWbp/BnSuh9ftmZ5iQj8bumCXnbpY7ZQhgW1XwF6VygwQ6+W2/k2CS7uIq5pBBSwvvOuhIRfoQ/BtvZ6SHkn4pgcvmuu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XMMBXoic; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XMMBXoic"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708695643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G0j/O6Ew6fqh8G6KJcM/Z5pMwANBcroeKujeolrgUNY=;
	b=XMMBXoic4WmRPsJH+BREMYkRBnkLgCgMWHKS6EE1AzspbM9SLa92Ofch0oWYEGwiVc/xso
	cQkBWLi1RspWWrLTV6qea0iu/VDEi/YegeKZvHPyhKTzZLDSZLA/qFn+L+ibhHJ67hBpcj
	xzyTpyd//buO8fTMgObf15H/N5vwAFM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-JU5GKAYbO42Dq-naXRiE7w-1; Fri, 23 Feb 2024 08:40:42 -0500
X-MC-Unique: JU5GKAYbO42Dq-naXRiE7w-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6da57e2d2b9so677365b3a.2
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 05:40:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708695642; x=1709300442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0j/O6Ew6fqh8G6KJcM/Z5pMwANBcroeKujeolrgUNY=;
        b=qszuQpppx+dVzgskqwc2fV+pj/fb6CVh/QXTkRT+dixtIZUtUB6EhJGfWWDfjIwwHf
         uN2y4hWdasd36NJFJjf/Xk87JvwFGguWXHA8V2uFe9mq0prp1iEz5iNcwfLuYz2WowrG
         nf3Tap4uEImgQx+XX/xqH0y6ifuH8cot3LzQVusYJ/jUIHBlJS25PrRizpsekd6eVbcr
         E4sKJ9mAY0/KLZKue8liSWZ8GY118No9EzTE/TIKe9tmobNQbvFnOc0+JhtjXJtZ+/kG
         E0NtzJWwcZxejfzzmVChMJvV1Vw9PAA98ssrzPjhnIF8bvcv5m5voM6NY5rOU+HkjIqq
         Em5A==
X-Forwarded-Encrypted: i=1; AJvYcCUJk5X3PoQDhnzMftIpvGZvQUpalXUbzAN3yvRTvwxdQuaxjLguh4oCPPpizktUHWKPtNqVhwHxu9jlNSgINK6iKrxsihlncZw=
X-Gm-Message-State: AOJu0YzkKhMV9nPHVNUfe44Gthu0AUtE5QDSLLJTcWAijyRIr/NlczsP
	MH/ngecrYinBnQOKhArYIdKgmpLFnwpHApU6HZMIldkBb+vSb3yZTqPHxo369B+3UnKP8xivuIh
	7gB7lcZXv8+SYnp9leXJ6XVhQ2lKJIBg+NoR8olWcho2N9X5SMVbfpoWta4PBPMBvwuW0qdOnKJ
	AGDkGe+Wc556WneJqQJaLC7Gs13T2WhVU=
X-Received: by 2002:a05:6a20:2a05:b0:1a0:708a:4f6e with SMTP id e5-20020a056a202a0500b001a0708a4f6emr1504304pzh.41.1708695641771;
        Fri, 23 Feb 2024 05:40:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXWwDm3g9FQSEqhJkyVdAyr4rC/jfSQoPzodrg7crjOZiI4IINTTVuiKepxVJuyPmDEoUxw8ej7RxpQzmHPWI=
X-Received: by 2002:a05:6a20:2a05:b0:1a0:708a:4f6e with SMTP id
 e5-20020a056a202a0500b001a0708a4f6emr1504288pzh.41.1708695641466; Fri, 23 Feb
 2024 05:40:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-2-xni@redhat.com>
 <6e5a98ae-1e7d-ea1f-521d-893d9207a132@huaweicloud.com>
In-Reply-To: <6e5a98ae-1e7d-ea1f-521d-893d9207a132@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 23 Feb 2024 21:40:30 +0800
Message-ID: <CALTww298cV9JbwjO9a4U=06ET1KWHx6ot9aGiZuVqeTRLLybaQ@mail.gmail.com>
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

On Fri, Feb 23, 2024 at 6:31=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
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
>
> Notice that 'MD_RECOVERY_WAIT' will never be cleared, hence sync_thread
> will never make progress until table reload for dm-raid.

Hi Kuai

After this patch, it indeed fix the problem mentioned in this patch.
So it can be cleared before stopping sync thread. I don't know why you
say it never be cleared.
>
> And other than stopping dm-raid, raid_postsuspend() call also be called
> by ioctl to suspend dm-raid, hence this change is wrong.

From code review, raid_postsuspend is used to stop sync thread and
suspend array. Maybe I don't understand right. If I'm right, it needs
to clear MD_RECOVERY_WAIT before stopping sync thread.

>
> I think we can never clear 'MD_RECOVERY_FROZEN' in this case so that
> 'MD_RECOVERY_WAIT' can be removed, or use '!MD_RECOVERY_WAIT' as a
> condition to register new sync_thread.

I don't understand you here.  From debug, there are three reloads
during dmraidd reshape. In the second reload, it doesn't want to start
sync thread. It's the reason that it sets MD_RECOVERY_WAIT because
dmraid is still not ready. In the third reload, it stops the mddev
which is created in the second reload and create a new mddev. During
this process, MD_RECOVERY_WAIT always works until suspend mddev which
is created in the second mddev. It has no relationship with
MD_RECOVERY_FROZEN.

Regards
Xiao
>
> Thanks,
> Kuai
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

