Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E03238D52
	for <dm-devel@lists.linux.dev>; Fri, 25 Jul 2025 03:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414987; cv=none; b=OUKYrfsbHlwSzY4QJnS0Xy0J9S7bh6rrhIRWqmFkbiozVFydVRxpi67fCrLDZeJcRrJzYzTRuyGh1JmUrVgFYPnBFnuc6BlpO9rzyyHQV3h91QPBnqDH28j1Vl0GzehZIbHaBj4QBgoLNESVB5VAAi9Imw9Rix2AhAG389wbfyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414987; c=relaxed/simple;
	bh=EYW/y1fwu5T+yqts+Bpy6dphKw7A/rXhOamx61AqAGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qpt/fRio++Qh0TvbfEp37LvV3KSuybAc9V4gcO1JRo/bPEXsCkEzU7k+wKEhp3vK1rTpN4T3eQDrpVQtHnkcU8RLgghugxngYqCS6a2umksrKtMwwkDOCNNNCl4Y3r47fkA/zDv991yKc7CGTJP1k7WXg73ySsTDOvgJuLEq3Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+tTsJaE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+tTsJaE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753414984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JmT/ORzg0P1lBg635/k0jST+Uw1Ny6cPps1AZuQQysQ=;
	b=S+tTsJaEX6tMY2NRNi6NULU96QcVWamleFQWZfK9GG+MqgH4kDEnxLaFKLr0C+eaRf6gxt
	iXHLF3WUScJYvc4UuUpwR65IdZ3tWvW6ktbAxNucN3lSWbONpwy3Mwe508hpMdbFbFE1+Z
	9sniNGsCn/kBOJdWnNLOZPDLsJMcVo0=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-ut0byFwQPLS8e3AVmd45_A-1; Thu, 24 Jul 2025 23:43:00 -0400
X-MC-Unique: ut0byFwQPLS8e3AVmd45_A-1
X-Mimecast-MFC-AGG-ID: ut0byFwQPLS8e3AVmd45_A_1753414979
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-32b378371b1so7279811fa.2
        for <dm-devel@lists.linux.dev>; Thu, 24 Jul 2025 20:43:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753414979; x=1754019779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JmT/ORzg0P1lBg635/k0jST+Uw1Ny6cPps1AZuQQysQ=;
        b=mABxv9Mtroa6OmxfaXjXy2dUAya8vtpLRWuqapXC2wfDUs3ycV0QVfUYoPOeIhA/9Z
         EmghEB0zLOSbO1tStGbhWmY7DNNH7voVcw5HnmQ8RQo0b6Y4WJ6kOnOnftkC2EH/4r7p
         SqzJM1s9BKANS/8Sw7nSu9r410fmeG4Mw1s6+8mcVvJyaDdMZhcpXkgUEettgOhdf90V
         wlNR4mfOMZoRZPFtlwDxalah2ZFMfPrRoWQZqcM6W3AvvauBOYJ0mVPmzZcWBnrlPZ27
         1ZBq2a57wHezPMcz/iZQg0pT4vWtHn7pxfu2CON307DFGjs0JM8HNUDFNMBkdyawB0Lo
         0Dag==
X-Forwarded-Encrypted: i=1; AJvYcCWWJPN4dROzYfq47oYrHfUevzXgZ8VhNxpRhqZouDzE4zCZc0kZGA94tmbhNPmDduFQoTZy1jkpnA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzae1oomDcz/PnmL7DGt4e8QTtbgStQWPbILqGcgf9dP5Kjgx8k
	rW0IYAsmCfp6XABWQMW5CSGA77qN+pg1sQVeIA/1Zx/AfvxYvHLGRfen/A/0FJJ2VFjDuLyKLC2
	+KHTE3/lQUR9/zuDKZOygtzugC546gaiMfOHWUDrpfz9ztU+/IA+dswQu1NK21TMTehqfRwaY6I
	UlP1BTDzL9ol8cK5w7GE7yyG8+mR2KyXKLQk8=
X-Gm-Gg: ASbGncsm6HXBmHSlwE35st1yr6KfUdvQpuqydoRS+yzX7puo5GQBLvbDtf8H7WejXKy
	3dBGT5yRSK5r6VumdbzXTLzSspxiQbj5QbJxxRD5tCRCqKOq3DShgMXAHBl7kKAIJ69M3QPAm2f
	njhx+kIyUiH2t2scXluoUdVw==
X-Received: by 2002:a2e:b8d2:0:b0:32b:78ce:be8e with SMTP id 38308e7fff4ca-331ee7ff19cmr1287101fa.32.1753414978997;
        Thu, 24 Jul 2025 20:42:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4YEQa+EOQb1BXl05be8PP0uoJ9yTAnU5IBjXbn4Pml9bhqsvSe6/FSlvFTpOWnC363qchUy3SyM0LBktBwFM=
X-Received: by 2002:a2e:b8d2:0:b0:32b:78ce:be8e with SMTP id
 38308e7fff4ca-331ee7ff19cmr1286981fa.32.1753414978556; Thu, 24 Jul 2025
 20:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250707012711.376844-1-yukuai1@huaweicloud.com> <20250707012711.376844-5-yukuai1@huaweicloud.com>
In-Reply-To: <20250707012711.376844-5-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 25 Jul 2025 11:42:47 +0800
X-Gm-Features: Ac12FXyOOKyHA7wp5OFT5LnhP7iR9jh1hN7dKn8UFtQrbCgR_dwXzkwUJs2-acg
Message-ID: <CALTww2-71P6Z0zxOeWJhu3bJ5AkKNqP0K+6M1djmBG=mZg38_w@mail.gmail.com>
Subject: Re: [PATCH v5 04/15] md/md-bitmap: merge md_bitmap_group into bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai3@huawei.com, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S4ie_Wm-3-QfuTVyUnSt2_qq_8evyoTIzoV_3XxKtV4_1753414979
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 7, 2025 at 9:35=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Now that all bitmap implementations are internal, it doesn't make sense
> to export md_bitmap_group anymore.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c | 5 ++++-
>  drivers/md/md-bitmap.h | 2 ++
>  drivers/md/md.c        | 6 +++++-
>  drivers/md/md.h        | 1 -
>  4 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index fc7282304b00..0ba1da35aa84 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2990,7 +2990,8 @@ static struct attribute *md_bitmap_attrs[] =3D {
>         &max_backlog_used.attr,
>         NULL
>  };
> -const struct attribute_group md_bitmap_group =3D {
> +
> +static struct attribute_group md_bitmap_group =3D {
>         .name =3D "bitmap",
>         .attrs =3D md_bitmap_attrs,
>  };
> @@ -3026,6 +3027,8 @@ static struct bitmap_operations bitmap_ops =3D {
>         .copy_from_slot         =3D bitmap_copy_from_slot,
>         .set_pages              =3D bitmap_set_pages,
>         .free                   =3D md_bitmap_free,
> +
> +       .group                  =3D &md_bitmap_group,
>  };
>
>  void mddev_set_bitmap_ops(struct mddev *mddev)
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 28c1f1c1cc83..0ceb9e97d21f 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -100,6 +100,8 @@ struct bitmap_operations {
>                               sector_t *hi, bool clear_bits);
>         void (*set_pages)(void *data, unsigned long pages);
>         void (*free)(void *data);
> +
> +       struct attribute_group *group;
>  };
>
>  /* the bitmap API */
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index bda3ef814d97..7ed95e5e43fc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5749,7 +5749,6 @@ static const struct attribute_group md_redundancy_g=
roup =3D {
>
>  static const struct attribute_group *md_attr_groups[] =3D {
>         &md_default_group,
> -       &md_bitmap_group,
>         NULL,
>  };
>
> @@ -5996,6 +5995,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
>                 return ERR_PTR(error);
>         }
>
> +       if (mddev->bitmap_ops && mddev->bitmap_ops->group)
> +               if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->g=
roup))
> +                       pr_warn("md: cannot register extra bitmap attribu=
tes for %s\n",
> +                               mdname(mddev));
> +
>         kobject_uevent(&mddev->kobj, KOBJ_ADD);
>         mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "arr=
ay_state");
>         mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "lev=
el");
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 67b365621507..d6fba4240f97 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -796,7 +796,6 @@ struct md_sysfs_entry {
>         ssize_t (*show)(struct mddev *, char *);
>         ssize_t (*store)(struct mddev *, const char *, size_t);
>  };
> -extern const struct attribute_group md_bitmap_group;
>
>  static inline struct kernfs_node *sysfs_get_dirent_safe(struct kernfs_no=
de *sd, char *name)
>  {
> --
> 2.39.2
>
>

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

