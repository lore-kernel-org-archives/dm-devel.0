Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A465422A7E9
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 06:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303779; cv=none; b=sfPuf4H60ARED9Lx64MEEPEnblwD6scDglbXUKE4x3PFMpPl2au5Q7OPupFXwjgH5PxihCB7CfjTZ8bXuP8NDsbXii0w4xnYyk41p2p9s+azoDz8CZbd70Qz3MC9MGdwK6hhd1dsbmPZnRgAOj9+CG9Co7VOcwbRUsF+lhTsCcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303779; c=relaxed/simple;
	bh=HOCJIP6MfuBcbEYwlShFo6R8XO6wPX7NytrYcTaLe/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQO9l6mcTB0fskH6DVxQsKmG44X1JBXzz0zdjo8gxVqlt4xXCjh9ZH0dI3+fWP6sNM249gpTkCZLnnOkbpSevvj/tttFqVKvAPF6Vr4VtnjxyADBjHzIJEHhfyxBl7iFyneFAYpqaRbM6UebuwIkqVgP8FnJ7ShgyBZ8Fg6fXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Db1GEMCv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Db1GEMCv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745303775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jrIWyO/DUdPSXiNycEKxPuw75tcdlf8kCKE7QHwl16c=;
	b=Db1GEMCvI+9g9xxbgzzv1Ayz2IvR721BXTJAvoin2ZGZ6t5CsUcLO+vvYCf/vpRLwJivwr
	qwV+gtkyNnwUCNK+wdSO8tw1g+KSiPuozKisoVfzwuiz/UNQD2fGk5whuNZ/+iE/BFScCy
	1Ly6PzQQyjqCuu4e+Cv8IdKAhV5PsyU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-dwPX30oVN0Cd61ZGqVk0hw-1; Tue, 22 Apr 2025 02:36:13 -0400
X-MC-Unique: dwPX30oVN0Cd61ZGqVk0hw-1
X-Mimecast-MFC-AGG-ID: dwPX30oVN0Cd61ZGqVk0hw_1745303772
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-54989998f1bso1873299e87.0
        for <dm-devel@lists.linux.dev>; Mon, 21 Apr 2025 23:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745303772; x=1745908572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrIWyO/DUdPSXiNycEKxPuw75tcdlf8kCKE7QHwl16c=;
        b=LQqqtTzR1tKc2PtI+fTvPL7Uh5jTCsWftO3NQBQQQkaenmM3WOIK1EjtGPukr2qzD1
         rfpEn8XGvFcspovIyyc7wcjYDt6hFAFmknwqgEEOc/F7dIa9ouVaM0Lm9T/8E0xtr7h4
         QPc7NBdk+8slze/EEq0TrQyZCORWexoi7epXE7K4h2d/ajhnpExnQVM7EBrNj52UJLyR
         OhDQMtDv5X+F5vnqVyCoejlgaF2XR0gfkhu0sppmk5h06GLZBpzGvkUJT71fAKl+zK/p
         1MDuoHRJWPYjzchjrtglZgJowUYb8/pc6PKZAEKZWnOPrrDP5gnznRZkZliZBkt9KT5/
         EMWw==
X-Forwarded-Encrypted: i=1; AJvYcCWlkZtaVhmWkfYjWJmopKeHUSF1S0ECZ4iHQouR144BRlegzfnatALeNLioUmPQgTDEaPnTBAAeDw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyJQimUkxCRWsQWYf7pE61QlYotw+KUK/GhJY2DiDtHLP0L0OD2
	otav5RTEMU2QnnGjZX2JeK9sLsR0GI16+o8PsSy0rKJiVlk53YjAJ4gVtHtZHHNso0x/RYQiiBR
	sfOOLQuy93haXaN5q9SRyV6S3tWnri5A0a+O8NXZsRfWEveoN970KYzo0HY5CWO3A4H5M5eIuMa
	qPv5SXQpC5RKTTBWJfyHBDtdh0b1uhV4c=
X-Gm-Gg: ASbGncvERcvSpoVAj/DeJTe0YqR5/JBl7Rzgi0bQr8VR7br6oLQJRoEUciXqlQ9lz+h
	6go82hEBkT/Bow79OmabvIJULG2CObaqW94MzXRTW+1qaCNqOTJgTWozEgrOYZIS5RUAA+g==
X-Received: by 2002:a05:6512:3ca1:b0:542:28b4:23ad with SMTP id 2adb3069b0e04-54d6e62773amr3723518e87.16.1745303771725;
        Mon, 21 Apr 2025 23:36:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrWDkSSdbmMshxE2ULkXdtov++cbLYyqfNTXxJtqEM4WFkORqqRIhlDPVrYpFRbsuwY92DsN/TmYU+2QyeHe0=
X-Received: by 2002:a05:6512:3ca1:b0:542:28b4:23ad with SMTP id
 2adb3069b0e04-54d6e62773amr3723505e87.16.1745303771324; Mon, 21 Apr 2025
 23:36:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250418010941.667138-1-yukuai1@huaweicloud.com> <20250418010941.667138-5-yukuai1@huaweicloud.com>
In-Reply-To: <20250418010941.667138-5-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 14:35:59 +0800
X-Gm-Features: ATxdqUEVb2RGoAb5zjQK6sahRUDwea7fbNAnPxgCG5MAo5fJDLunHFKcf0Unk0U
Message-ID: <CALTww29aehPQcbcy0j+V69r+RVgzNPwNhpAQ-7wWMdD-VPfNgQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] md: fix is_mddev_idle()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, yukuai3@huawei.com, viro@zeniv.linux.org.uk, 
	akpm@linux-foundation.org, nadav.amit@gmail.com, ubizjak@gmail.com, 
	cl@linux.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wpWaEDcTaACok3TLHsj7ufFFR0yBwqnxUmidOsktIkQ_1745303772
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025 at 9:17=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> If sync_speed is above speed_min, then is_mddev_idle() will be called
> for each sync IO to check if the array is idle, and inflihgt sync_io
> will be limited if the array is not idle.
>
> However, while mkfs.ext4 for a large raid5 array while recovery is in
> progress, it's found that sync_speed is already above speed_min while
> lots of stripes are used for sync IO, causing long delay for mkfs.ext4.
>
> Root cause is the following checking from is_mddev_idle():
>
> t1: submit sync IO: events1 =3D completed IO - issued sync IO
> t2: submit next sync IO: events2  =3D completed IO - issued sync IO
> if (events2 - events1 > 64)
>
> For consequence, the more sync IO issued, the less likely checking will
> pass. And when completed normal IO is more than issued sync IO, the
> condition will finally pass and is_mddev_idle() will return false,
> however, last_events will be updated hence is_mddev_idle() can only
> return false once in a while.
>
> Fix this problem by changing the checking as following:
>
> 1) mddev doesn't have normal IO completed;
> 2) mddev doesn't have normal IO inflight;
> 3) if any member disks is partition, and all other partitions doesn't
>    have IO completed.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 84 +++++++++++++++++++++++++++----------------------
>  drivers/md/md.h |  3 +-
>  2 files changed, 48 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 52cadfce7e8d..dfd85a5d6112 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8625,50 +8625,58 @@ void md_cluster_stop(struct mddev *mddev)
>         put_cluster_ops(mddev);
>  }
>
> -static int is_mddev_idle(struct mddev *mddev, int init)
> +static bool is_rdev_holder_idle(struct md_rdev *rdev, bool init)
>  {
> +       unsigned long last_events =3D rdev->last_events;
> +
> +       if (!bdev_is_partition(rdev->bdev))
> +               return true;
> +
> +       /*
> +        * If rdev is partition, and user doesn't issue IO to the array, =
the
> +        * array is still not idle if user issues IO to other partitions.
> +        */
> +       rdev->last_events =3D part_stat_read_accum(rdev->bdev->bd_disk->p=
art0,
> +                                                sectors) -
> +                           part_stat_read_accum(rdev->bdev, sectors);
> +
> +       if (!init && rdev->last_events > last_events)
> +               return false;
> +
> +       return true;
> +}
> +
> +/*
> + * mddev is idle if following conditions are match since last check:
> + * 1) mddev doesn't have normal IO completed;
> + * 2) mddev doesn't have inflight normal IO;
> + * 3) if any member disk is partition, and other partitions doesn't have=
 IO
> + *    completed;
> + *
> + * Noted this checking rely on IO accounting is enabled.
> + */
> +static bool is_mddev_idle(struct mddev *mddev, int init)
> +{
> +       unsigned long last_events =3D mddev->last_events;
> +       struct gendisk *disk;
>         struct md_rdev *rdev;
> -       int idle;
> -       int curr_events;
> +       bool idle =3D true;
>
> -       idle =3D 1;
> -       rcu_read_lock();
> -       rdev_for_each_rcu(rdev, mddev) {
> -               struct gendisk *disk =3D rdev->bdev->bd_disk;
> +       disk =3D mddev_is_dm(mddev) ? mddev->dm_gendisk : mddev->gendisk;
> +       if (!disk)
> +               return true;
>
> -               if (!init && !blk_queue_io_stat(disk->queue))
> -                       continue;
> +       mddev->last_events =3D part_stat_read_accum(disk->part0, sectors)=
;
> +       if (!init && (mddev->last_events > last_events ||
> +                     bdev_count_inflight(disk->part0)))
> +               idle =3D false;
>
> -               curr_events =3D (int)part_stat_read_accum(disk->part0, se=
ctors) -
> -                             atomic_read(&disk->sync_io);
> -               /* sync IO will cause sync_io to increase before the disk=
_stats
> -                * as sync_io is counted when a request starts, and
> -                * disk_stats is counted when it completes.
> -                * So resync activity will cause curr_events to be smalle=
r than
> -                * when there was no such activity.
> -                * non-sync IO will cause disk_stat to increase without
> -                * increasing sync_io so curr_events will (eventually)
> -                * be larger than it was before.  Once it becomes
> -                * substantially larger, the test below will cause
> -                * the array to appear non-idle, and resync will slow
> -                * down.
> -                * If there is a lot of outstanding resync activity when
> -                * we set last_event to curr_events, then all that activi=
ty
> -                * completing might cause the array to appear non-idle
> -                * and resync will be slowed down even though there might
> -                * not have been non-resync activity.  This will only
> -                * happen once though.  'last_events' will soon reflect
> -                * the state where there is little or no outstanding
> -                * resync requests, and further resync activity will
> -                * always make curr_events less than last_events.
> -                *
> -                */
> -               if (init || curr_events - rdev->last_events > 64) {
> -                       rdev->last_events =3D curr_events;
> -                       idle =3D 0;
> -               }
> -       }
> +       rcu_read_lock();
> +       rdev_for_each_rcu(rdev, mddev)
> +               if (!is_rdev_holder_idle(rdev, init))
> +                       idle =3D false;
>         rcu_read_unlock();
> +
>         return idle;
>  }
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b57842188f18..1d51c2405d3d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -132,7 +132,7 @@ struct md_rdev {
>
>         sector_t sectors;               /* Device size (in 512bytes secto=
rs) */
>         struct mddev *mddev;            /* RAID array if running */
> -       int last_events;                /* IO event timestamp */
> +       unsigned long last_events;      /* IO event timestamp */
>
>         /*
>          * If meta_bdev is non-NULL, it means that a separate device is
> @@ -520,6 +520,7 @@ struct mddev {
>                                                          * adding a spare
>                                                          */
>
> +       unsigned long                   last_events;    /* IO event times=
tamp */

Can we use another name? Because mddev has events counter. This name
can easily be confused with that counter.

Regards
Xiao

>         atomic_t                        recovery_active; /* blocks schedu=
led, but not written */
>         wait_queue_head_t               recovery_wait;
>         sector_t                        recovery_cp;
> --
> 2.39.2
>

