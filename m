Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D7D7F1
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 00:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eifm4jkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A27C433C7
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 00:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701129639;
	bh=MFEYzA5mRp7AN8cKcjjH0SZ29aaBIB6cSEEMifvx+zw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Eifm4jkYBFRMkBOPOuob5rBVQ7w5SXk6nIyLpDUpZLLrIUNuI+qpRwDJD2/GbeTnz
	 tONKnd+oiwb+AMT8veEAYETnAt85sducm8I3E9Yr/MzzADjwSaLrdKPYANbkrVcwyX
	 8XdylOxWFR5FF6pb7qIs47BJkrNaW8y8Nj2395n5Ps0zGHd3eiMgf5JY6UAgXL+Eu9
	 alXjK8+ZQuijh4/CjFcseJD2PXMg5BWhJSul8uN7bgZclS73FMMQHeco3e8NaxNjte
	 At5doBMqxOUGU0M6mBAF1n9W+T/5NR8xRQ8uI7rG0+BHtvl6Xg2OLT/ASXYql4CPyi
	 +HKlSojyUuVtA==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-50abb83866bso6576357e87.3
        for <dm-devel@lists.linux.dev>; Mon, 27 Nov 2023 16:00:39 -0800 (PST)
X-Gm-Message-State: AOJu0Yz6V1koeReeCkBQijYC5X+m1K5q+DvWKfL9mk5D2yzXKL8ugFjm
	P5XLcEisBWRj1s6vJkD9Ygsfb0m6mdJMSi6J81s=
X-Google-Smtp-Source: AGHT+IEyxhwV57xREqVEVRtoPCW8vyDy/j2VuC8DuuHZeidKON0ZGwnmElAZKaE5wzBJzzYqQMbpK2tDy+55ue8AU+8=
X-Received: by 2002:ac2:5973:0:b0:504:30eb:f2ac with SMTP id
 h19-20020ac25973000000b0050430ebf2acmr7821132lfp.68.1701129637794; Mon, 27
 Nov 2023 16:00:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231124075953.1932764-1-yukuai1@huaweicloud.com> <20231124075953.1932764-7-yukuai1@huaweicloud.com>
In-Reply-To: <20231124075953.1932764-7-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Mon, 27 Nov 2023 16:00:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5jDzOo=2NVHO17jfjmpR0LV9+Q1a9FkBA8NBshX9t=ig@mail.gmail.com>
Message-ID: <CAPhsuW5jDzOo=2NVHO17jfjmpR0LV9+Q1a9FkBA8NBshX9t=ig@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] dm-raid: delay flushing event_work() after
 reconfig_mutex is released
To: Yu Kuai <yukuai1@huaweicloud.com>, dm-devel@lists.linux.dev
Cc: yukuai3@huawei.com, xni@redhat.com, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+ dm-devel@lists.linux.dev

On Fri, Nov 24, 2023 at 12:00=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> After commit db5e653d7c9f ("md: delay choosing sync action to
> md_start_sync()"), md_start_sync() will hold 'reconfig_mutex', however,
> in order to make sure event_work is done, __md_stop() will flush
> workqueue with reconfig_mutex grabbed, hence if sync_work is still
> pending, deadlock will be triggered.
>
> Fortunately, former pacthes to fix stopping sync_thread already make sure
> all sync_work is done already, hence such deadlock is not possible
> anymore. However, in order not to cause confusions for people by this
> implicit dependency, delay flushing event_work to dm-raid where
> 'reconfig_mutex' is not held, and add some comments to emphasize that
> the workqueue can't be flushed with 'reconfig_mutex'.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/dm-raid.c |  3 +++
>  drivers/md/md.c      | 11 ++++++++---
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index a4692f8f98ee..51f15c20f621 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3317,6 +3317,9 @@ static void raid_dtr(struct dm_target *ti)
>         mddev_lock_nointr(&rs->md);
>         md_stop(&rs->md);
>         mddev_unlock(&rs->md);
> +
> +       if (work_pending(&rs->md.event_work))
> +               flush_work(&rs->md.event_work);
>         raid_set_free(rs);
>  }
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index fb8a7d1eebee..86efc9c2ae56 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -82,6 +82,14 @@ static struct module *md_cluster_mod;
>
>  static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
>  static struct workqueue_struct *md_wq;
> +
> +/*
> + * This workqueue is used for sync_work to register new sync_thread, and=
 for
> + * del_work to remove rdev, and for event_work that is only set by dm-ra=
id.
> + *
> + * Noted that sync_work will grab reconfig_mutex, hence never flush this
> + * workqueue whith reconfig_mutex grabbed.
> + */
>  static struct workqueue_struct *md_misc_wq;
>  struct workqueue_struct *md_bitmap_wq;
>
> @@ -6328,9 +6336,6 @@ static void __md_stop(struct mddev *mddev)
>         struct md_personality *pers =3D mddev->pers;
>         md_bitmap_destroy(mddev);
>         mddev_detach(mddev);
> -       /* Ensure ->event_work is done */
> -       if (mddev->event_work.func)
> -               flush_workqueue(md_misc_wq);
>         spin_lock(&mddev->lock);
>         mddev->pers =3D NULL;
>         spin_unlock(&mddev->lock);
> --
> 2.39.2
>
