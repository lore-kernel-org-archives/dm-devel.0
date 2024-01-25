Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7033E13AC6
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 07:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706169087; cv=none; b=ThAodc8aeSevtlr/xVQ0dFqcA/exB21UQW5+JMQ9Rt0cfb18JTN/cGjp4obLRAWVV+NFke6HlUJa8f7zv0/oPS3GKM58h5Yc5hm2rdWoOUOTY7LhQtHztiJD04iCcljdH1Ic8dPlDxSfGonu/jVCUOo26XOBatB6tqpgq0WJtjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706169087; c=relaxed/simple;
	bh=IJk53f2ApOxRAEPTKIzDtiOaoN3YBA85NACNk6p/iB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TIodlzRvocQBG1M5Mb86eWmFcVRRp0xoIeDWxAuOhIEj2ECcmqrzPmtFTTgSRPZMHxheBxYNafsZPUAHoJFQXd5V0llBmh5VK5MmOQsRvGM3d8G8i8vjXmA20uQNGQBsfXlm1EJXbzYOGvoX5C2lfOuQl0zPNy90h9ZuKUR5d04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5LhltC9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5LhltC9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706169084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LyC31zzzcvBQLccO8yitrHL0CNB1m9jX4OQ2W97orWU=;
	b=L5LhltC9nJvghfojHODPh5zpHgiT2eranh5Row7r6fcYhMTEmovA/2wyPVHHBGt1C991Lf
	w2YPU435z4LHVc7si0mgq7fNU57rre6upPzC3OTEOF4UM/iRzexz4QgtXs5Ex9AWCwU78M
	Cjzh447biHYuQs0E1JgRwptpvqUomGw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-X-ZA1gJPM8mKkvuUd04UZA-1; Thu, 25 Jan 2024 02:51:21 -0500
X-MC-Unique: X-ZA1gJPM8mKkvuUd04UZA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6d9b266183eso6049871b3a.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 23:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706169080; x=1706773880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LyC31zzzcvBQLccO8yitrHL0CNB1m9jX4OQ2W97orWU=;
        b=sGhMXU2Dpg0jRfp5lxexbcIrMCTjCUwE3eOPZytlpAKpAJQD4+LgmJcJnaXpguTNK+
         rQBuP3r6jUDS8IEwWzq8kFRXjG9vfXEPEJtD8iO+wOvw8OaD7spoaD/CBxGwrfqlUiJ7
         SUBi/j/x/EgoZ1sSFGEQtKjqj6VnibRUf47DHIJLiTki9dhzj3ys1ffLoh2bDwgi2wjk
         zWwpASgSn1fQdwvwWxVa8nia4d4rHxC8L3K4DVQWHRg/orvKC+qEdQ7O3f5PVu2OhxVx
         ShLEd/8g1GJIoV588zBI7sGmwZjZzQIh0oRoaVT6YQedJ0Oa71MePOaZmSdER3t2OcrI
         QglQ==
X-Gm-Message-State: AOJu0YwgiX7Im8dVYTKJztleOoAY0LI+TuocuYnrn/BMUXwE+BX7+XEe
	LSX/6n4bmFPRnMQYdkeee1Qz90p1g6zqHlzst/MQ+5NnKjCMtapyl04einsP6DVtvkjcdmNUXg4
	+Zc9916Kw5dAlkqBlSrsyO91i8DZCe7Ec4Hga9M4fYEArwZlNn3aJ1ELJqqWK47ysGafajdNxW0
	y7Gi/AXmxaj/6sROYGa/psWsibfIlfGcE=
X-Received: by 2002:aa7:9819:0:b0:6dd:c379:28f7 with SMTP id e25-20020aa79819000000b006ddc37928f7mr252925pfl.21.1706169079987;
        Wed, 24 Jan 2024 23:51:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSlcVyOOUsGiV0wV1PdgkTikecKl6oWsCQDpmwLacZpUS4x9H+HIkFzdIbi1zrP/QBZOMNarTehuzV4tTCU7g=
X-Received: by 2002:aa7:9819:0:b0:6dd:c379:28f7 with SMTP id
 e25-20020aa79819000000b006ddc37928f7mr252918pfl.21.1706169079670; Wed, 24 Jan
 2024 23:51:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240124091421.1261579-1-yukuai3@huawei.com> <20240124091421.1261579-6-yukuai3@huawei.com>
In-Reply-To: <20240124091421.1261579-6-yukuai3@huawei.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 25 Jan 2024 15:51:08 +0800
Message-ID: <CALTww2_hG2_YL1v-d0=uv2=bVzJ2wwpSJyQdBBGMCBx79bot-Q@mail.gmail.com>
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

Hi Kuai

There is a building error. It should give a pointer to
lockdep_assert_held. And same with the other two places in this patch.

Regards
Xiao

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

