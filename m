Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377781A83FF
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 06:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745302578; cv=none; b=d/aYCNmovzYZx4mHdLvw2pek7x7ZyxJi1pRvD8xMbStY7bElz57wespZrYIWjqbmO25uvJhjdA/I46H7CCH7HtwTw4gqKQUTDOBHt/r4JJbf4Hyv5bpdq6nr9Qgt9fIT8i7KW5HUFK2Nm/d4qou+yLL/JxWyWG9vXLNB+0UMB2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745302578; c=relaxed/simple;
	bh=jZ0wNJE4sCAD2Wxg3QqyirSWVQF9ciu8w3HYSQANqx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DF2x5Q9lW/9CGFFmM1Yw0ky0nVfYulh74B7Oj5PMV/9qDW8FCGwUpwCQbNeGs6exfAXbADRxbzFwQsypWHuC84NXRMlA1d6LsL1GmvVs5bg0Xog6wpb8RJlj/KWgdnVPqI6Zs++jBuct2IKYd/QsTNNZlCMHdkYEw4c56s1tPe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dC3ayKDx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dC3ayKDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745302575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOfM+9BQZOzvEWdY0TkOTsLL5sU/pbh/yn6VnJiXCsc=;
	b=dC3ayKDxdgn1rW1GkMhBb1aGXF6nFfLYEPLkFqBTzmAQ0Crhp2FeUSZQi4XqkKFVHIXLv4
	pBOxX62Iu8/FON44aVUjiyLe3Rdtw5+6wwm/LsLF/bcs8EeNqkIAc3nsh1P9wn9WmDWY60
	P1t8memOX0FmM78w9osxAIRG9R4olCY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-yom1-aexNriiZAfdrjK_Mg-1; Tue, 22 Apr 2025 02:16:11 -0400
X-MC-Unique: yom1-aexNriiZAfdrjK_Mg-1
X-Mimecast-MFC-AGG-ID: yom1-aexNriiZAfdrjK_Mg_1745302570
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-30bf6bae757so16161771fa.0
        for <dm-devel@lists.linux.dev>; Mon, 21 Apr 2025 23:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745302570; x=1745907370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOfM+9BQZOzvEWdY0TkOTsLL5sU/pbh/yn6VnJiXCsc=;
        b=qjSxsrE7UeeUsiQ3by5D1UhlcSSPYhvqGItZCDie8qfKpzFr+iwM4NddsujptL2kuB
         EMo2dE1x7Opmh5Gpdib1DdyhXYEpCdC2vwCy4uQfN18GYQ2zGsHDemSSBCo7/xhsnJq/
         nDN8vPXGAwBUUlNKUS5Akp+/YmJHZuoEdYGsmPhq9zIqxow6+QnIHSHzZj9+T4Lc9sJF
         WEt0AjM7xVlRvm+iaY6IurHK/0Q/JeU3T0rhx4WGH5349N3lK+YyeXtPPXpVJ+k2Pxxo
         uWN22cGIQCOOZyv2GMTNG4KNihdL8prdMd4z27D1r11WkTX8qowXv47yiC1LVJTPltAA
         CFZA==
X-Forwarded-Encrypted: i=1; AJvYcCWP7vaR0+57nROSEXbvltgf10KO3ZBZQIToiAW6OQ7Tk+CpkVfIFBc8nH/X9yFVzuWo8STP7qQYKw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzlbDYW2XGB3vNpx1RhMB2rjvF2oHANZYT8kAPg+hRqurGzVQh6
	FeEf/nfQZcZX6rXg9UkBSDZa4Wx1yQc2vZ7RxrCysG4WQLbRg3c5QTh3RxOVFfHlYaKx2go4kTF
	n2ybmaqSPhNfg/goKnsDStDaK/OYpnkEniu5bnBH5SsWU5uIx6igeUN9teUe4IrddloHE1GoYn2
	0fObCciK7Dqxf/y1eTvMf7z8FYuqiD+OU=
X-Gm-Gg: ASbGncuFV8B4VtHegjLI+WKZbP8BfWjeEF6Fn4Bpk0XLD3MMOKYyqqfGyyi/G8fmKl1
	vRJSiJorfhiQFUBo/J9wYbEY5Z1Tapc1AyEUjY26Ch/9b2yZ17ZywyAaFRWPiySSZvIyarg==
X-Received: by 2002:a05:6512:3ba4:b0:549:7145:5d2f with SMTP id 2adb3069b0e04-54d6e638d0cmr3680175e87.33.1745302569749;
        Mon, 21 Apr 2025 23:16:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW4N/JuPGFeAu0EpKla93By/oSeFcB7iGfr/v0RLsztSrXlNeRJzg1bZJfh7bTTHAlED5kxv5pAmzghwhBFOU=
X-Received: by 2002:a05:6512:3ba4:b0:549:7145:5d2f with SMTP id
 2adb3069b0e04-54d6e638d0cmr3680155e87.33.1745302569284; Mon, 21 Apr 2025
 23:16:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250418010941.667138-1-yukuai1@huaweicloud.com> <20250418010941.667138-4-yukuai1@huaweicloud.com>
In-Reply-To: <20250418010941.667138-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 14:15:57 +0800
X-Gm-Features: ATxdqUHrtlSkNDqa4JXDX3hYzDaUY94bOJQAo195qAV37KLheagYDY464qOKJXs
Message-ID: <CALTww2_JMiwp=QMuRTFDXQkuqMivR=k7yyw1CAMDxSrJX_WUvg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] md: add a new api sync_io_depth
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, yukuai3@huawei.com, viro@zeniv.linux.org.uk, 
	akpm@linux-foundation.org, nadav.amit@gmail.com, ubizjak@gmail.com, 
	cl@linux.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vmuUA_Jo45JtgW7j-ILgjIAeOxgRDzJsHRnJb2PQHbE_1745302570
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025 at 9:17=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Currently if sync speed is above speed_min and below speed_max,
> md_do_sync() will wait for all sync IOs to be done before issuing new
> sync IO, means sync IO depth is limited to just 1.
>
> This limit is too low, in order to prevent sync speed drop conspicuously
> after fixing is_mddev_idle() in the next patch, add a new api for
> limiting sync IO depth, the default value is 32.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 109 +++++++++++++++++++++++++++++++++++++++---------
>  drivers/md/md.h |   1 +
>  2 files changed, 91 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 438e71e45c16..52cadfce7e8d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -111,32 +111,48 @@ static void md_wakeup_thread_directly(struct md_thr=
ead __rcu *thread);
>  /* Default safemode delay: 200 msec */
>  #define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
>  /*
> - * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
> - * is 1000 KB/sec, so the extra system load does not show up that much.
> - * Increase it if you want to have more _guaranteed_ speed. Note that
> - * the RAID driver will use the maximum available bandwidth if the IO
> - * subsystem is idle. There is also an 'absolute maximum' reconstruction
> - * speed limit - in case reconstruction slows down your system despite
> - * idle IO detection.
> + * Current RAID-1,4,5,6,10 parallel reconstruction 'guaranteed speed lim=
it'
> + * is sysctl_speed_limit_min, 1000 KB/sec by default, so the extra syste=
m load
> + * does not show up that much. Increase it if you want to have more guar=
anteed
> + * speed. Note that the RAID driver will use the maximum bandwidth
> + * sysctl_speed_limit_max, 200 MB/sec by default, if the IO subsystem is=
 idle.
>   *
> - * you can change it via /proc/sys/dev/raid/speed_limit_min and _max.
> - * or /sys/block/mdX/md/sync_speed_{min,max}
> + * Background sync IO speed control:
> + *
> + * - below speed min:
> + *   no limit;
> + * - above speed min and below speed max:
> + *   a) if mddev is idle, then no limit;
> + *   b) if mddev is busy handling normal IO, then limit inflight sync IO
> + *   to sync_io_depth;
> + * - above speed max:
> + *   sync IO can't be issued;
> + *
> + * Following configurations can be changed via /proc/sys/dev/raid/ for s=
ystem
> + * or /sys/block/mdX/md/ for one array.
>   */
> -
>  static int sysctl_speed_limit_min =3D 1000;
>  static int sysctl_speed_limit_max =3D 200000;
> -static inline int speed_min(struct mddev *mddev)
> +static int sysctl_sync_io_depth =3D 32;
> +
> +static int speed_min(struct mddev *mddev)
>  {
>         return mddev->sync_speed_min ?
>                 mddev->sync_speed_min : sysctl_speed_limit_min;
>  }
>
> -static inline int speed_max(struct mddev *mddev)
> +static int speed_max(struct mddev *mddev)
>  {
>         return mddev->sync_speed_max ?
>                 mddev->sync_speed_max : sysctl_speed_limit_max;
>  }
>
> +static int sync_io_depth(struct mddev *mddev)
> +{
> +       return mddev->sync_io_depth ?
> +               mddev->sync_io_depth : sysctl_sync_io_depth;
> +}
> +
>  static void rdev_uninit_serial(struct md_rdev *rdev)
>  {
>         if (!test_and_clear_bit(CollisionCheck, &rdev->flags))
> @@ -293,14 +309,21 @@ static const struct ctl_table raid_table[] =3D {
>                 .procname       =3D "speed_limit_min",
>                 .data           =3D &sysctl_speed_limit_min,
>                 .maxlen         =3D sizeof(int),
> -               .mode           =3D S_IRUGO|S_IWUSR,
> +               .mode           =3D 0644,
>                 .proc_handler   =3D proc_dointvec,
>         },
>         {
>                 .procname       =3D "speed_limit_max",
>                 .data           =3D &sysctl_speed_limit_max,
>                 .maxlen         =3D sizeof(int),
> -               .mode           =3D S_IRUGO|S_IWUSR,
> +               .mode           =3D 0644,
> +               .proc_handler   =3D proc_dointvec,
> +       },
> +       {
> +               .procname       =3D "sync_io_depth",
> +               .data           =3D &sysctl_sync_io_depth,
> +               .maxlen         =3D sizeof(int),
> +               .mode           =3D 0644,
>                 .proc_handler   =3D proc_dointvec,
>         },
>  };
> @@ -5091,7 +5114,7 @@ static ssize_t
>  sync_min_show(struct mddev *mddev, char *page)
>  {
>         return sprintf(page, "%d (%s)\n", speed_min(mddev),
> -                      mddev->sync_speed_min ? "local": "system");
> +                      mddev->sync_speed_min ? "local" : "system");
>  }
>
>  static ssize_t
> @@ -5100,7 +5123,7 @@ sync_min_store(struct mddev *mddev, const char *buf=
, size_t len)
>         unsigned int min;
>         int rv;
>
> -       if (strncmp(buf, "system", 6)=3D=3D0) {
> +       if (strncmp(buf, "system", 6) =3D=3D 0) {
>                 min =3D 0;
>         } else {
>                 rv =3D kstrtouint(buf, 10, &min);
> @@ -5120,7 +5143,7 @@ static ssize_t
>  sync_max_show(struct mddev *mddev, char *page)
>  {
>         return sprintf(page, "%d (%s)\n", speed_max(mddev),
> -                      mddev->sync_speed_max ? "local": "system");
> +                      mddev->sync_speed_max ? "local" : "system");
>  }
>
>  static ssize_t
> @@ -5129,7 +5152,7 @@ sync_max_store(struct mddev *mddev, const char *buf=
, size_t len)
>         unsigned int max;
>         int rv;
>
> -       if (strncmp(buf, "system", 6)=3D=3D0) {
> +       if (strncmp(buf, "system", 6) =3D=3D 0) {
>                 max =3D 0;
>         } else {
>                 rv =3D kstrtouint(buf, 10, &max);
> @@ -5145,6 +5168,35 @@ sync_max_store(struct mddev *mddev, const char *bu=
f, size_t len)
>  static struct md_sysfs_entry md_sync_max =3D
>  __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
>
> +static ssize_t
> +sync_io_depth_show(struct mddev *mddev, char *page)
> +{
> +       return sprintf(page, "%d (%s)\n", sync_io_depth(mddev),
> +                      mddev->sync_io_depth ? "local" : "system");
> +}
> +
> +static ssize_t
> +sync_io_depth_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +       unsigned int max;
> +       int rv;
> +
> +       if (strncmp(buf, "system", 6) =3D=3D 0) {
> +               max =3D 0;
> +       } else {
> +               rv =3D kstrtouint(buf, 10, &max);
> +               if (rv < 0)
> +                       return rv;
> +               if (max =3D=3D 0)
> +                       return -EINVAL;
> +       }
> +       mddev->sync_io_depth =3D max;
> +       return len;
> +}
> +
> +static struct md_sysfs_entry md_sync_io_depth =3D
> +__ATTR_RW(sync_io_depth);
> +
>  static ssize_t
>  degraded_show(struct mddev *mddev, char *page)
>  {
> @@ -5671,6 +5723,7 @@ static struct attribute *md_redundancy_attrs[] =3D =
{
>         &md_mismatches.attr,
>         &md_sync_min.attr,
>         &md_sync_max.attr,
> +       &md_sync_io_depth.attr,
>         &md_sync_speed.attr,
>         &md_sync_force_parallel.attr,
>         &md_sync_completed.attr,
> @@ -8927,6 +8980,23 @@ static sector_t md_sync_position(struct mddev *mdd=
ev, enum sync_action action)
>         }
>  }
>
> +static bool sync_io_within_limit(struct mddev *mddev)
> +{
> +       int io_sectors;
> +
> +       /*
> +        * For raid456, sync IO is stripe(4k) per IO, for other levels, i=
t's
> +        * RESYNC_PAGES(64k) per IO.
> +        */
> +       if (mddev->level =3D=3D 4 || mddev->level =3D=3D 5 || mddev->leve=
l =3D=3D 6)
> +               io_sectors =3D 8;
> +       else
> +               io_sectors =3D 128;
> +
> +       return atomic_read(&mddev->recovery_active) <
> +               io_sectors * sync_io_depth(mddev);
> +}
> +
>  #define SYNC_MARKS     10
>  #define        SYNC_MARK_STEP  (3*HZ)
>  #define UPDATE_FREQUENCY (5*60*HZ)
> @@ -9195,7 +9265,8 @@ void md_do_sync(struct md_thread *thread)
>                                 msleep(500);
>                                 goto repeat;
>                         }
> -                       if (!is_mddev_idle(mddev, 0)) {
> +                       if (!sync_io_within_limit(mddev) &&
> +                           !is_mddev_idle(mddev, 0)) {
>                                 /*
>                                  * Give other IO more of a chance.
>                                  * The faster the devices, the less we wa=
it.
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 9d55b4630077..b57842188f18 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -484,6 +484,7 @@ struct mddev {
>         /* if zero, use the system-wide default */
>         int                             sync_speed_min;
>         int                             sync_speed_max;
> +       int                             sync_io_depth;
>
>         /* resync even though the same disks are shared among md-devices =
*/
>         int                             parallel_resync;
> --
> 2.39.2
>

Looks good to me, reviewed-by: Xiao Ni <xni@redhat.com>

