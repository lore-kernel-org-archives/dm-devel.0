Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC1F4F5F2
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 11:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706182571; cv=none; b=dmt65xCjPoo6L60Q9fn541eKOkzFHuscUi7rmXLwdbzBUrReqXM9oMuC3jMsXhR8/75geiwGZw+BvQWnEk4T4mkowUbe01gFLJAgd1qHNRDZL7ozQxnnzRfpUE8qwcjcMXwlDF4fQr0ZhkALIzsHPF4ADCF2aP0WNruHkVJK4b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706182571; c=relaxed/simple;
	bh=rSZZ+121Id9exraW2ap4CNA3Q9zojf36UA0v6YWYSrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jopbhkfY0xyzmVBZalyyR8j8GJdvlgQHtVQMDxm6Fh1hrrVruaCVDeC1TjMX5cZW+mwgvqqtrVH+WQ+7Re2PfqEuUuU4Mb2fsxMXcUhbHLMIq7ABddX7P8Rz7TPReHHbeFk/QkkjYYbHUcQcNKSdFtuhhZEbslDlMnO9sBh91F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYLk69zg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYLk69zg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706182568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUB/oUuKqmGeoEi6m3WaYGxwlHU6PfpvbttetKqgWmA=;
	b=IYLk69zgslZnoiLEwN82gxMrgmQDlFNRYofvsD9mielrBDjf4i7CFZv6AUPIUFFIqtb+8y
	LPpUFS22FIG6n9IBGdM8XYmqS/ZYpON7xemB68PW++Coq+sACraRWBgtpU0IfhHpWf6aKe
	u2caqAZXqdAMsa2k3phC5UN/xQzrQdY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-ApRKMiwJM3WgsVWWlJfIXQ-1; Thu, 25 Jan 2024 06:36:07 -0500
X-MC-Unique: ApRKMiwJM3WgsVWWlJfIXQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5ce12b4c1c9so3849209a12.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 03:36:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706182566; x=1706787366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUB/oUuKqmGeoEi6m3WaYGxwlHU6PfpvbttetKqgWmA=;
        b=RsEMyOBPn/FF4xKGoXkM/4jf4AobLOibzBxHcxtJwBNVj7nY3K5CKKJ0hq6K/iPEM+
         9s9wsx6orsJKqgvn7r1WBBPbYkBC67R1PzZLUI77MWYFxO1WfPha4Kif+vUCHJDk62yR
         GfXJ+p4Pl3vi3Sev8cuM/3pBdbjFBdcPyH9XB0Z5Aepi/RDYTK3EpuM1wUDzZ/rCbRz2
         XGLO8mq8YFBS+POwA1AC5euPHolkoCwaLSztsLav5bMi/Dg7mB5OKdCMF6ZwBD39UlPq
         Sybglkji6fCDuCueItOPobijsJws3RzFJoG+K/cd+y+rXFZGoOeJlvwcBPwLIw3X5Id8
         WfdQ==
X-Gm-Message-State: AOJu0YzV2Kjmaa0LwM3wuh89ql0NIy6toMVFLyeZQLG4z/Bs7+kakGfG
	hgqKQrC16VVQVUAoveE3jxHdAWZilsPwrXYWbu+0pl+8ddw36esE8Rb1esfWaDBm8SpHhsBjdzP
	piAGtLZD0UNCNTanagQFTAvGCCjsg40ytr0yzdnNF/kRC2yw9Baz59tA7mja7+dGxXBAhogvi2L
	6RCwNZvTuX6G6cs3vIjPcOILAG69SkO80=
X-Received: by 2002:a05:6a20:8e02:b0:19c:5491:f4f7 with SMTP id y2-20020a056a208e0200b0019c5491f4f7mr837553pzj.45.1706182566094;
        Thu, 25 Jan 2024 03:36:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGG8V9lqIfdb+wLnigwfAaiAbM2ddgygoWd+RUIdAjz82NuASn1qniUQNabuk+VXao+g5reeZwDg4D9GpV5JOI=
X-Received: by 2002:a05:6a20:8e02:b0:19c:5491:f4f7 with SMTP id
 y2-20020a056a208e0200b0019c5491f4f7mr837529pzj.45.1706182565506; Thu, 25 Jan
 2024 03:36:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240124091421.1261579-1-yukuai3@huawei.com> <20240124091421.1261579-6-yukuai3@huawei.com>
In-Reply-To: <20240124091421.1261579-6-yukuai3@huawei.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 25 Jan 2024 19:35:54 +0800
Message-ID: <CALTww2_V6Cr4j7hMPnMMt-g2w_xfCHQvwBpwbyOk=5rGcap6YA@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] md: export helpers to stop sync_thread
To: Yu Kuai <yukuai3@huawei.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	dm-devel@lists.linux.dev, song@kernel.org, neilb@suse.de, heinzm@redhat.com, 
	shli@fb.com, akpm@osdl.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

This is the result of lvm2 tests:
make check
### 426 tests: 319 passed, 74 skipped, 0 timed out, 5 warned, 28
failed   in 56:04.914
make[1]: *** [Makefile:138: check] Error 1
make[1]: Leaving directory '/root/lvm2/test'
make: *** [Makefile:89: check] Error 2

Do you know where to check which cases fail?

Best Regards
Xiao

On Wed, Jan 24, 2024 at 5:19=E2=80=AFPM Yu Kuai <yukuai3@huawei.com> wrote:
>
> The new heleprs will be used in dm-raid in later patches to fix
> regressions and prevent calling md_reap_sync_thread() directly.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 41 +++++++++++++++++++++++++++++++++++++----
>  drivers/md/md.h |  3 +++
>  2 files changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c5d0a372927..90cf31b53804 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4915,30 +4915,63 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked, bool check_seq)
>                 mddev_lock_nointr(mddev);
>  }
>
> -static void idle_sync_thread(struct mddev *mddev)
> +void md_idle_sync_thread(struct mddev *mddev)
>  {
> +       lockdep_assert_held(mddev->reconfig_mutex);
> +
>         mutex_lock(&mddev->sync_mutex);
>         clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       stop_sync_thread(mddev, true, true);
> +       mutex_unlock(&mddev->sync_mutex);
> +}
> +EXPORT_SYMBOL_GPL(md_idle_sync_thread);
> +
> +void md_frozen_sync_thread(struct mddev *mddev)
> +{
> +       lockdep_assert_held(mddev->reconfig_mutex);
> +
> +       mutex_lock(&mddev->sync_mutex);
> +       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       stop_sync_thread(mddev, true, false);
> +       mutex_unlock(&mddev->sync_mutex);
> +}
> +EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
>
> +void md_unfrozen_sync_thread(struct mddev *mddev)
> +{
> +       lockdep_assert_held(mddev->reconfig_mutex);
> +
> +       mutex_lock(&mddev->sync_mutex);
> +       clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +       md_wakeup_thread(mddev->thread);
> +       sysfs_notify_dirent_safe(mddev->sysfs_action);
> +       mutex_unlock(&mddev->sync_mutex);
> +}
> +EXPORT_SYMBOL_GPL(md_unfrozen_sync_thread);
> +
> +static void idle_sync_thread(struct mddev *mddev)
> +{
>         if (mddev_lock(mddev)) {
>                 mutex_unlock(&mddev->sync_mutex);
>                 return;
>         }
>
> +       mutex_lock(&mddev->sync_mutex);
> +       clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>         stop_sync_thread(mddev, false, true);
>         mutex_unlock(&mddev->sync_mutex);
>  }
>
>  static void frozen_sync_thread(struct mddev *mddev)
>  {
> -       mutex_lock(&mddev->sync_mutex);
> -       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> -
>         if (mddev_lock(mddev)) {
>                 mutex_unlock(&mddev->sync_mutex);
>                 return;
>         }
>
> +       mutex_lock(&mddev->sync_mutex);
> +       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>         stop_sync_thread(mddev, false, false);
>         mutex_unlock(&mddev->sync_mutex);
>  }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 8d881cc59799..437ab70ce79b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -781,6 +781,9 @@ extern void md_rdev_clear(struct md_rdev *rdev);
>  extern void md_handle_request(struct mddev *mddev, struct bio *bio);
>  extern int mddev_suspend(struct mddev *mddev, bool interruptible);
>  extern void mddev_resume(struct mddev *mddev);
> +extern void md_idle_sync_thread(struct mddev *mddev);
> +extern void md_frozen_sync_thread(struct mddev *mddev);
> +extern void md_unfrozen_sync_thread(struct mddev *mddev);
>
>  extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>  extern void md_update_sb(struct mddev *mddev, int force);
> --
> 2.39.2
>

