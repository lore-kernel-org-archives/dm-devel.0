Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4783FE3F
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709268093; cv=none; b=rKCm96P1B8j7vDcnZtgjahAFVK2erl3/+7wHHHHFlHsU/SujZQIKhVTTLyxLWG6bXndnksrL6Jos2ianDf1DzbsSev7j8qSJjCh6m8bMOCFhTbeRXFOmCSWfgrImC5BQQCiSFNhw1bx8Fta5aKKcM0UhZj3qzlYk4YBZRHC0UWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709268093; c=relaxed/simple;
	bh=WpiEPo1WMlRlTW7iT8noFZHcfa6uSDPumBBmg3sACrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KkCsCBeyg5XeeWIBKhckSEpIdAib8WyWt4TfEPpJbQ11z4XsgkxPPp3yMILxB+HRuFHXzmVn1irmLtO7lv8MWL1TjBnU72lOzS0B5KsYAgsmyQBh3Pp1QPBB3kfPdg6DWzuGB/RmhxGY7h53HXg/LLGHSBhATXl3s4DADD2+vZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ehWOMAG6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ehWOMAG6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709268090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ttITTuJPcaIMb6tnQpuKWHVWBP/QGSFAuswrAF5QQBY=;
	b=ehWOMAG6ZsaCMA+XkPcH4sNNs0Aw4zAeFJtp+cetEiWflFwuM2P8vLi4St0ayYHyC5vRKM
	pLJpKgNSqIHBYtMPPWYILaUfHgFFCqDKNgO+iHVJnymj60Pa1642dLUlXIkS4oL2DbEo2b
	lD6XIyAs703eHpkcg7niULC/FDbuHko=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-KxgOIRx8PgSmuCQ-RsVsLw-1; Thu, 29 Feb 2024 23:41:29 -0500
X-MC-Unique: KxgOIRx8PgSmuCQ-RsVsLw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c1a40c48aeso1638282b6e.2
        for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 20:41:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709268087; x=1709872887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttITTuJPcaIMb6tnQpuKWHVWBP/QGSFAuswrAF5QQBY=;
        b=iUP2De+G4uEfsPIknPZDE1LgvnlrTpE1PPzVH6y88E9QfYbOzUozOu48zaQtXGYoYS
         YfGdz3AfC9Zh2kNBGvv0u6rf2Z14hgqzV2/FaRBrLO0mxFpk2zvbwAh9Ytuz62filL9r
         /OxwusYxvVR7k+7bI2ifJ8tpIHIxrWoCRNVym+JKXXfM/X0AhUnC6mF4a5IW7DNQj0ny
         /AkL1lqC0vS856phDRRcViNSB3oRGkzgZqISyZnMWQLdf75o4e/M7knchZ+ucbS693ai
         3Tr4GIJDkdNfXRCRwF9GBp/jHR21X6DAss/RkRVhHxAvS001fs70HK7i8S4abljMBcHL
         bXFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVe/CrLa4OFe1dYzetpZtdR9eRJ2pFYwD/pTdN/8LhDPThxekQFWMxtd4AePMTJiv8Bq5bFz9puQsTba4BLBQmL/L+uQV3xM4c=
X-Gm-Message-State: AOJu0Yz0OJoJFdlKRI1ChEe8n2+22xDuyz7NxbKOPC2Td3Zy2rbx2cul
	B+FJysoTXkZMxbdrga3GvPGcnlOHhmyo1XS9+nPJREXVYcLQlNVPvTa5TiXCmLsGRFQwmOfxOzE
	Doqd/q4EPP4G7PTO3Im/1H74E4RHjg/7xxONtG1kUkrnDe6M9xq0IwOvhoDGY1SpfXclTL/pWEg
	+s7bMTVX3zAyLLEqaxp40fH+E6bm9OBgE=
X-Received: by 2002:a05:6808:d4c:b0:3c1:ad98:95f1 with SMTP id w12-20020a0568080d4c00b003c1ad9895f1mr763957oik.39.1709268087705;
        Thu, 29 Feb 2024 20:41:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2fuMSLBTyZqzJp+gzglXT0a2bnpHi7ZpTKxOqDuVpiFgwQHMyLAdbuNNp9zcMN1N+aIsAjENIRk+N+CkN1h0=
X-Received: by 2002:a05:6808:d4c:b0:3c1:ad98:95f1 with SMTP id
 w12-20020a0568080d4c00b003c1ad9895f1mr763945oik.39.1709268087455; Thu, 29 Feb
 2024 20:41:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229154941.99557-1-xni@redhat.com> <20240229154941.99557-2-xni@redhat.com>
 <042093c6-6deb-535c-918e-78160e7addc4@huaweicloud.com>
In-Reply-To: <042093c6-6deb-535c-918e-78160e7addc4@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 1 Mar 2024 12:41:16 +0800
Message-ID: <CALTww29xwFA83m6=PjJZwr6Y=p4A10LMMmkMS6ofstBJiQzfVw@mail.gmail.com>
Subject: Re: [PATCH 1/6] md: Revert "md: Don't register sync_thread for
 reshape directly"
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 10:38=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/29 23:49, Xiao Ni =E5=86=99=E9=81=93:
> > This reverts commit ad39c08186f8a0f221337985036ba86731d6aafe.
> >
> > Function stop_sync_thread only wakes up sync task. It also needs to
> > wake up sync thread. This problem will be fixed in the following
> > patch.
>
> I don't think so, unlike mddev->thread, sync_thread will only be
> executed once and must be executed each time it's registered, and caller
> must make sure to wake up registered sync_thread.

Hi Kuai

I'll modify the comments. But it should be right to
wake_up(mddev->sync_thread) in function stop_sync_thread too? You gave
the same patch yesterday too. I know the caller should wake up sync
thread too.

"However, I think the one to register sync_thread is responsible to
wake it up." I put your comments here. If I understand correctly, we
can do something like this?
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7937,6 +7937,7 @@ static int raid5_run(struct mddev *mddev)
                set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
                rcu_assign_pointer(mddev->sync_thread,
                        md_register_thread(md_do_sync, mddev, "reshape"));
+               md_wakeup_thread(mddev->sync_thread);
                if (!mddev->sync_thread)
                        goto abort;
        }


And at first, I didn't revert
ad39c08186f8a0f221337985036ba86731d6aafe. But with my patch set, it
can cause failure in lvm2 test suit. And the patch you gave yesterday
is part of my patch01, so I revert it. Are you good if I change the
comments and with the modification (wake up sync thread after
registering reshape)?

Best Regards
Xiao

>
> Thanks,
> Kuai
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c     |  5 +----
> >   drivers/md/raid10.c | 16 ++++++++++++++--
> >   drivers/md/raid5.c  | 29 +++++++++++++++++++++++++++--
> >   3 files changed, 42 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 9e41a9aaba8b..db4743ba7f6c 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -9376,7 +9376,6 @@ static void md_start_sync(struct work_struct *ws)
> >       struct mddev *mddev =3D container_of(ws, struct mddev, sync_work)=
;
> >       int spares =3D 0;
> >       bool suspend =3D false;
> > -     char *name;
> >
> >       /*
> >        * If reshape is still in progress, spares won't be added or remo=
ved
> > @@ -9414,10 +9413,8 @@ static void md_start_sync(struct work_struct *ws=
)
> >       if (spares)
> >               md_bitmap_write_all(mddev->bitmap);
> >
> > -     name =3D test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
> > -                     "reshape" : "resync";
> >       rcu_assign_pointer(mddev->sync_thread,
> > -                        md_register_thread(md_do_sync, mddev, name));
> > +                        md_register_thread(md_do_sync, mddev, "resync"=
));
> >       if (!mddev->sync_thread) {
> >               pr_warn("%s: could not start resync thread...\n",
> >                       mdname(mddev));
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index a5f8419e2df1..7412066ea22c 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -4175,7 +4175,11 @@ static int raid10_run(struct mddev *mddev)
> >               clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> >               clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> >               set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> > -             set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > +             set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> > +             rcu_assign_pointer(mddev->sync_thread,
> > +                     md_register_thread(md_do_sync, mddev, "reshape"))=
;
> > +             if (!mddev->sync_thread)
> > +                     goto out_free_conf;
> >       }
> >
> >       return 0;
> > @@ -4569,8 +4573,16 @@ static int raid10_start_reshape(struct mddev *md=
dev)
> >       clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> >       clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
> >       set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> > -     set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > +     set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> > +
> > +     rcu_assign_pointer(mddev->sync_thread,
> > +                        md_register_thread(md_do_sync, mddev, "reshape=
"));
> > +     if (!mddev->sync_thread) {
> > +             ret =3D -EAGAIN;
> > +             goto abort;
> > +     }
> >       conf->reshape_checkpoint =3D jiffies;
> > +     md_wakeup_thread(mddev->sync_thread);
> >       md_new_event();
> >       return 0;
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 6a7a32f7fb91..8497880135ee 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -7936,7 +7936,11 @@ static int raid5_run(struct mddev *mddev)
> >               clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> >               clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> >               set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> > -             set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > +             set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> > +             rcu_assign_pointer(mddev->sync_thread,
> > +                     md_register_thread(md_do_sync, mddev, "reshape"))=
;
> > +             if (!mddev->sync_thread)
> > +                     goto abort;
> >       }
> >
> >       /* Ok, everything is just fine now */
> > @@ -8502,8 +8506,29 @@ static int raid5_start_reshape(struct mddev *mdd=
ev)
> >       clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> >       clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
> >       set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> > -     set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > +     set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> > +     rcu_assign_pointer(mddev->sync_thread,
> > +                        md_register_thread(md_do_sync, mddev, "reshape=
"));
> > +     if (!mddev->sync_thread) {
> > +             mddev->recovery =3D 0;
> > +             spin_lock_irq(&conf->device_lock);
> > +             write_seqcount_begin(&conf->gen_lock);
> > +             mddev->raid_disks =3D conf->raid_disks =3D conf->previous=
_raid_disks;
> > +             mddev->new_chunk_sectors =3D
> > +                     conf->chunk_sectors =3D conf->prev_chunk_sectors;
> > +             mddev->new_layout =3D conf->algorithm =3D conf->prev_algo=
;
> > +             rdev_for_each(rdev, mddev)
> > +                     rdev->new_data_offset =3D rdev->data_offset;
> > +             smp_wmb();
> > +             conf->generation--;
> > +             conf->reshape_progress =3D MaxSector;
> > +             mddev->reshape_position =3D MaxSector;
> > +             write_seqcount_end(&conf->gen_lock);
> > +             spin_unlock_irq(&conf->device_lock);
> > +             return -EAGAIN;
> > +     }
> >       conf->reshape_checkpoint =3D jiffies;
> > +     md_wakeup_thread(mddev->sync_thread);
> >       md_new_event();
> >       return 0;
> >   }
> >
>

