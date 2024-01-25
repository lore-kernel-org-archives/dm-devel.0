Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6CE57868
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 13:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706189608; cv=none; b=d2r7Elle62WxrGPnY5mbz2JjIIrAV7xRPDx1xmsXfh9ET+8tMTrdT0pIrW4f3AVhU7W062Hz/Ka4os4yRvFEWFvIe8Iiclo5DixcqlWb2eqnb9M2XvehnvsPcyXuLH7vYUKJKqtO/Fh/VeqOku7ZI6m2LSHmQj9mpvqEcHQ6kfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706189608; c=relaxed/simple;
	bh=qf2ZCDjrZkyP+0qfzAF10h09CrmlVwgkwdHvKfLsaiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G5s8j308IsQq+RxhSZOyysLy8jyFvy/ig5IALDeWPfwMbGDiPP434AojRH7lcso8NEKqVhz8u7zGhZCtDSEDbJJ8OIvLE33zDvuoxoIehzwhdkThS7+3SgZVGPyOwAuL5W6TA+hTyay8Dlb/E3bjPKuTxOTV2olBGo75w6I65Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CrIRVZcq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CrIRVZcq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706189605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ij5uCHw47wggIWlE5l434hygV3inTJPDDA1gRj9q79s=;
	b=CrIRVZcqKN0/IRgrRY4OqO2YwEypdetSw7ceLJW9qtLgB+1mZ8Pqk12BU17LeEUJct546X
	fPAXUMe0E3TNQ3dZTlU/oDONpFFAzIV5Jy59imHe4iQJmfNGtHit8r0pQxNRsnEVJnkndC
	U6FoIeGVpTerEVr/zlyiajtqqtTJsmA=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-wwoS7ffvOHGtQHwjXVfmUQ-1; Thu, 25 Jan 2024 08:33:24 -0500
X-MC-Unique: wwoS7ffvOHGtQHwjXVfmUQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6ddc0c00548so1926093b3a.3
        for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 05:33:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706189603; x=1706794403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ij5uCHw47wggIWlE5l434hygV3inTJPDDA1gRj9q79s=;
        b=N2dTN+/s3Z2fCaN9iX+3FDZokcaXu+tB31WmK94HJL/WVvibdNIdPombLRuIGspUev
         NfdKGzmA65VJGWYAQrfh+UhhRoEFeUcPWDSDA7thQTNVc2hnKRwKOUrD5vatVabgYxbN
         xcqihvVsRIvBqAcYpwUDNrHzK4WrAwVYcksWE3RWV8GjkfdYrvMnnFNc80lGCq5s8gEM
         NyENUkUnhVFoH0WMOGaa1VElmckyX2YCdErYeiqbdwDvpTPs8Hr2vV1g8/ta+N8qXtLZ
         vYcosE2mTMTbYALyYScjN5jBXK4L0eIwZdpA/iIBcf3o/WugPiUeaQfopKeMa99CnPuJ
         jkjQ==
X-Gm-Message-State: AOJu0YwG/AcKlaRHnE49rOLyMsc3pMbV70vsSYEG//y+ha7bU9kbvg+M
	uT6TMNkBVQDsVe/AdrkF5aANf1rWH50lHowfdGyZJba9TKqZh/AqErW+qoNWT3qt20xNn/ur1+a
	b6q5Dhaevxf31fj2wt7eGIQLlum9oUWdo/51mL4CRhBWHUfg/KvzIQo8d/b+LYxyykoNb07FFjC
	jYtgK0gC/OruQaIYD+iFmgoSomQbVvvQA=
X-Received: by 2002:a05:6a00:854:b0:6dd:8010:9bf8 with SMTP id q20-20020a056a00085400b006dd80109bf8mr804475pfk.67.1706189603320;
        Thu, 25 Jan 2024 05:33:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6IG3M/vVDv3PlfK+L+PAk7Qwg7KlFbYwleei6mIKigDLyfqsmo2n9EuwBd5fqlbSLnhOwFOPW9mkGQV0YeOM=
X-Received: by 2002:a05:6a00:854:b0:6dd:8010:9bf8 with SMTP id
 q20-20020a056a00085400b006dd80109bf8mr804457pfk.67.1706189603015; Thu, 25 Jan
 2024 05:33:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240124091421.1261579-1-yukuai3@huawei.com> <20240124091421.1261579-6-yukuai3@huawei.com>
In-Reply-To: <20240124091421.1261579-6-yukuai3@huawei.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 25 Jan 2024 21:33:11 +0800
Message-ID: <CALTww291wiYYMWuqUdDf1t7cKkHFs9gGQSRw+iPhUCsNv-Y6yg@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] md: export helpers to stop sync_thread
To: Yu Kuai <yukuai3@huawei.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	dm-devel@lists.linux.dev, song@kernel.org, jbrassow@f14.redhat.com, 
	neilb@suse.de, heinzm@redhat.com, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

I build the kernel 6.7.0-rc8 with this patch set. The lvm2 regression
test result:
###       failed: [ndev-vanilla] shell/integrity.sh
###       failed: [ndev-vanilla] shell/lvchange-partial-raid10.sh
###       failed: [ndev-vanilla] shell/lvchange-raid-transient-failures.sh
###       failed: [ndev-vanilla] shell/lvchange-raid10.sh
###       failed: [ndev-vanilla] shell/lvchange-rebuild-raid.sh
###       failed: [ndev-vanilla] shell/lvconvert-cache-abort.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid-regionsize.sh
###       failed: [ndev-vanilla]
shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid-reshape.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid-takeover-alloc-failur=
e.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid-takeover-thin.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid-takeover.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid0-striped.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid0_to_raid10.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid10.sh
###       failed: [ndev-vanilla] shell/lvconvert-raid5_to_raid10.sh
###       failed: [ndev-vanilla] shell/lvconvert-repair-raid.sh
###       failed: [ndev-vanilla] shell/lvconvert-striped-raid0.sh
###       failed: [ndev-vanilla] shell/lvcreate-large-raid10.sh
###       failed: [ndev-vanilla] shell/lvcreate-raid-nosync.sh
###       failed: [ndev-vanilla] shell/lvcreate-raid10.sh
###       failed: [ndev-vanilla] shell/lvdisplay-raid.sh
###       failed: [ndev-vanilla] shell/lvextend-thin-raid.sh
###       failed: [ndev-vanilla] shell/lvresize-fs-crypt.sh
###       failed: [ndev-vanilla] shell/lvresize-raid.sh
###       failed: [ndev-vanilla] shell/lvresize-raid10.sh
###       failed: [ndev-vanilla] shell/pvck-dump.sh
###       failed: [ndev-vanilla] shell/pvmove-raid-segtypes.sh
###       failed: [ndev-vanilla] shell/select-report.sh

Regards
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

