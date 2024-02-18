Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0811368
	for <dm-devel@lists.linux.dev>; Sun, 18 Feb 2024 01:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708220035; cv=none; b=kP0LGtrjypvZtYzUT5Y1FL5GnhnM7fjDAxLM+yz3vBUjA24y25JaAaQjp26md5s8MGlMjUel3Lua+26GnWqYGWgx2tYs2PpXYszWlfznFqtyuaAGebZQs7vS3v3ki0SoMMCUjMvLJCrN0si3xqMWZEDtB6GKvW/ZgFn6vnbx2/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708220035; c=relaxed/simple;
	bh=sN27NeahzJVaG38gKCisWN3iwjTBOQ9bEfCLMhCKwyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hBorXk42xNLYjFXii2droAsLWydIeyaF6lm+tka/LIsNtbQ+6hFj7BTQo93szdXnXj9tKvmBG7PE357cQM64YaTkOqdc4ZpW6481gtqfJkX6wi0mMEaFqwSU0xmfPqDb+kuvmV7HCNstYUxaVLQmmJNtd70ZAjOnOsN5B+XnFCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f7zrhfkE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7zrhfkE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708220032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Arbd8TS6QkRLNnADRY4SzeJ5a3a+RPD5q4GAzUNO2hw=;
	b=f7zrhfkEXHUdYnzaABv7rZL6kKPyDFpr8TQu+QP33Hietdic/7ceNBn0j1a5EUNxQ2Fj+K
	nIrJUgcKHU6LhmYXxJsw1IrD4YmrVb5sOGNZvJOG1QiR6n1bfA3jrL6KRm9zbbIH/TnKW6
	7yuTkUch3gfRQYKpTixZyexm9PWy6FE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-MMWb3pwdPwCeuEI-jLr8Vw-1; Sat, 17 Feb 2024 20:33:51 -0500
X-MC-Unique: MMWb3pwdPwCeuEI-jLr8Vw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6e38b5bf1b1so287241b3a.0
        for <dm-devel@lists.linux.dev>; Sat, 17 Feb 2024 17:33:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708220030; x=1708824830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Arbd8TS6QkRLNnADRY4SzeJ5a3a+RPD5q4GAzUNO2hw=;
        b=Nl+E/ZEu73bDyEC5xPbjv15bw54zAYqWus1CLglsTOhtWdorqv3V7cEPBVb7X2JFrI
         1Oz4eoaJ55cjGZZNnTmHtjXCoAlS37RoarKhi49MFzRJneMSepaH4Ic/dp8INw5dVDKt
         AcWNP484iFen7uQiCxW+oU16tSBn4x7ZbQfP5l1UzleMnHacBaZ+KuDdnKsVmoIujFed
         PTxz4o8GmFM//m0tcbJ3jqQFSP1fW+/CvTcBsJglqWt1zJlqgZ04loQkP5T4hdX35uGE
         lZTIlcokAvWpWbF1vZWpKGV2BJ47OFLH+3NbhKcskDQOkCQSTDGcX3cWu+ubjF6DZTTF
         FH4w==
X-Forwarded-Encrypted: i=1; AJvYcCWv1JlhJa3CgbuazKWsJAXIPtows+CCtA/RBsp8aWOQSLi7OPqCNF1PH1TPZKLufcl0udtBlJjQ05JzJM28DRSi5VHmQpCmWC4=
X-Gm-Message-State: AOJu0YzK6Y0D4NVeI75r5qdHHUymD7K7MCs4nMBbQ5ri607fikU59RQS
	2NE9eb/Mc3AEXXx/YlD79q7+zHgvUonurvG57C5EdLsQJNtz+2J2RBs4CbRmPtZNeINcjZKSGRi
	Wcd/DmfwuDFBwvaml0YxyuL4pfI5UCLGcCuz0hBksmBz6pJ+iflRQws4chFNBXJsaPZOSQfuEPG
	Rs35SfbNUPa0CuFjLisL6mj85ithkwXGo=
X-Received: by 2002:a05:6a20:a999:b0:19e:c32f:35d6 with SMTP id cc25-20020a056a20a99900b0019ec32f35d6mr6651295pzb.19.1708220030105;
        Sat, 17 Feb 2024 17:33:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVY4QN7/oKxnNo7f5EakcYNGCnG1VzY8rjVnTYi43AJCatq8IplkuchfCq0nSxiF4It2ptVnAx2B8VkwEm7/c=
X-Received: by 2002:a05:6a20:a999:b0:19e:c32f:35d6 with SMTP id
 cc25-20020a056a20a99900b0019ec32f35d6mr6651280pzb.19.1708220029804; Sat, 17
 Feb 2024 17:33:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com>
 <20240201092559.910982-2-yukuai1@huaweicloud.com> <CALTww2-ZhRBJOD3jXs=xKFaD=iR=dtoC9h2rUQi5Stpi+tJ9Bw@mail.gmail.com>
 <64d27757-9387-09dc-48e8-a9eedd67f075@huaweicloud.com>
In-Reply-To: <64d27757-9387-09dc-48e8-a9eedd67f075@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 18 Feb 2024 09:33:38 +0800
Message-ID: <CALTww28E=k6fXJURG77KwHb7M2OByLrcE8g7GNkQDTtcOV48hQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] md: don't ignore suspended array in md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 18, 2024 at 9:15=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/16 14:58, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Feb 1, 2024 at 5:30=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> mddev_suspend() never stop sync_thread, hence it doesn't make sense to
> >> ignore suspended array in md_check_recovery(), which might cause
> >> sync_thread can't be unregistered.
> >>
> >> After commit f52f5c71f3d4 ("md: fix stopping sync thread"), following
> >> hang can be triggered by test shell/integrity-caching.sh:
> >
> > Hi Kuai
> >
> > After applying this patch, it's still stuck at mddev_suspend. Maybe
> > the deadlock can be fixed by other patches from the patch set. But
> > this patch can't fix this issue. If so, the comment is not right.
>
> This patch alone can't fix the problem that mddev_suspend() can stuck
> thoroughly, patches 1-4 will all be needed.
>
> Thanks,
> Kuai
>
> >
> >>
> >> 1) suspend the array:
> >> raid_postsuspend
> >>   mddev_suspend
> >>
> >> 2) stop the array:
> >> raid_dtr
> >>   md_stop
> >>    __md_stop_writes
> >>     stop_sync_thread
> >>      set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >>      md_wakeup_thread_directly(mddev->sync_thread);
> >>      wait_event(..., !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> >>
> >> 3) sync thread done:
> >> md_do_sync
> >>   set_bit(MD_RECOVERY_DONE, &mddev->recovery);
> >>   md_wakeup_thread(mddev->thread);
> >>
> >> 4) daemon thread can't unregister sync thread:
> >> md_check_recovery
> >>   if (mddev->suspended)
> >>     return; -> return directly
> >>   md_read_sync_thread
> >>   clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> >>   -> MD_RECOVERY_RUNNING can't be cleared, hence step 2 hang;
> >
> > I add some debug logs when stopping dmraid with lvremove command. The
> > step you mentioned are sequential but not async. The process is :
> > dev_remove->dm_destroy->__dm_destroy->dm_table_postsuspend_targets(raid=
_postsuspend)
> > -> dm_table_destroy(raid_dtr). It looks like mddev_suspend is waiting
> > for active_io to be zero.

The deadlock problem mentioned in this patch should not be right?

Regards
Xiao


> >
> > Best Regards
> > Xiao
> >
> >> This problem is not just related to dm-raid, fix it by ignoring
> >> suspended array in md_check_recovery(). And follow up patches will
> >> improve dm-raid better to frozen sync thread during suspend.
> >>
> >> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> >> Closes: https://lore.kernel.org/all/8fb335e-6d2c-dbb5-d7-ded8db5145a@r=
edhat.com/
> >> Fixes: 68866e425be2 ("MD: no sync IO while suspended")
> >> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/md.c | 3 ---
> >>   1 file changed, 3 deletions(-)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 2266358d8074..07b80278eaa5 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -9469,9 +9469,6 @@ static void md_start_sync(struct work_struct *ws=
)
> >>    */
> >>   void md_check_recovery(struct mddev *mddev)
> >>   {
> >> -       if (READ_ONCE(mddev->suspended))
> >> -               return;
> >> -
> >>          if (mddev->bitmap)
> >>                  md_bitmap_daemon_work(mddev);
> >>
> >> --
> >> 2.39.2
> >>
> >
> >
> > .
> >
>

