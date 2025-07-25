Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3B4137750
	for <dm-devel@lists.linux.dev>; Fri, 25 Jul 2025 02:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753411772; cv=none; b=AEadghuA35X039HhJtsANbP4UGbYEkhfbe7AFC6CU71kXEplO3LZ8eSD0Wer0boZITEMlf+RUgYUgkH3gq2ROk7IQ3JAhXTrViIqHPagXVuD+JHKUpqs27rrxhT5jKrS/uE9dkNSX+TzeUZ92yza97VGA4p8ZpYbYXQagl4UHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753411772; c=relaxed/simple;
	bh=vxtCP6QkbOBgrlQQ7Wh/a0P73x8NHPDiucr6P6dbIFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Iz+8WpoLfXHF6ByPW+D0BbskGPg5i11n/GnsbNyf2ll+ZH3ev1WjkWbbxljRP7QbwoZ8FfBp7rQAJe0nqA9mqUuP6MYiZySzFndDmajte7eUkBVGV+q9mPIarvIXTht1IImRVlTxU8qYD7EAXtUrVq/dJMMwZQTTBlCnu2tdZlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chhSYBS2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chhSYBS2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753411769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fZ0lgYFYfJK224S3zXbRX1LGwYZBTG3nIJjbcFvGSV8=;
	b=chhSYBS21JF0NaZDxcU9pPJ87KsZX/12B7hWynN1Ssplyyc2z+5VpQJ87eMVWGJ/5tBCfN
	cmRGd3dIRhhbg7WjUuVpQuHIJp5B8KPNWlJ2/DS07ObYI2Hw11wM7u5j6UPLeynR3ju2sc
	E1lHY4WjRwTK1dLhRvciuVhV+6gElmA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-YKtetkVsO92tZQSp0xXghw-1; Thu, 24 Jul 2025 22:49:27 -0400
X-MC-Unique: YKtetkVsO92tZQSp0xXghw-1
X-Mimecast-MFC-AGG-ID: YKtetkVsO92tZQSp0xXghw_1753411766
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-32b3ba8088fso6794841fa.1
        for <dm-devel@lists.linux.dev>; Thu, 24 Jul 2025 19:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753411766; x=1754016566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZ0lgYFYfJK224S3zXbRX1LGwYZBTG3nIJjbcFvGSV8=;
        b=XbRwTqlthgJlgXubP9K8WSZx2wbYuj1SgDqLa5kAejpTd4726Eo12g+9gH9iEWRNou
         A877uR8/ShCos3aIhbkFiqxcvjbcxjG7Sx3k6GbuED96pslM9HQoOvHANw93fq7RKny6
         UkjlLJsgA9rGb/hw5FmdvTo2pkjfhQsY8an/b3nSkJj2pMvWCdPLg9pqnS0tsBUdMzos
         TeRRVmkH+xnMI8rC8OqIZWetHyo3ZADGynHQGKp5OMCnf12o8TGcZtzkPNVDkuwOlMgO
         xUADR1kx6uPbPglX9LCk7yovZNejyHRqhV5Zxu0et7F+dLllBDJMkG1eSbvOgo64+IH8
         LpuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsqy7VLtc35E4Wedayq/JkuP3koWWLXPjz2LMWv0Ug0jgdd6QxaAuxvzoMJSg929CHYWfhc0aIwA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwZKstahC9oEjRuuGBDnVZIRqY7m6J9TNtAsSAnGQUmqi/82gzb
	nOGfDBkbGmn7T7KRU7lVvxDYKDlqaRMKuoq87wy7IJ6zmKX7KK89kZ7Hi5p1PoUUCoRhzqCVARQ
	k7AGgctFRFuT3Bby0vkzkmgKX46hhLViMk7PdGZ7Okm3dL1oZz/9grtcQElAkzYMuM8zTa9blb8
	/v2iYC11x4uIXvzje+kGUW0XH9qdoqibiJWxc=
X-Gm-Gg: ASbGncssd1AfdN8Gi97KAo7Gx8g0uK07JnZIEGzDpEBmPAgDvy0lELcc2X55foG6Odx
	NsfWme/xqmUzT609c9LLfG7UG17OMDu9MNBtq0UjYDucgnwV2Lh0WCJsyliGXZYswTjBG/uQ7cF
	cbm44DjZMQ30fI+TAOyvJMEA==
X-Received: by 2002:a05:651c:1a0b:b0:30b:d156:9e7e with SMTP id 38308e7fff4ca-331ee6e824dmr885881fa.2.1753411765679;
        Thu, 24 Jul 2025 19:49:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQRwU+fBO2gJ0Klw8iv1V53UE1zsTUdTisZNk79KClcJnexOygytGSzsHpUABT2h4sm5PWtSw35+l2O9Pau2o=
X-Received: by 2002:a05:651c:1a0b:b0:30b:d156:9e7e with SMTP id
 38308e7fff4ca-331ee6e824dmr885821fa.2.1753411765224; Thu, 24 Jul 2025
 19:49:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250707012711.376844-1-yukuai1@huaweicloud.com> <20250707012711.376844-4-yukuai1@huaweicloud.com>
In-Reply-To: <20250707012711.376844-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 25 Jul 2025 10:49:13 +0800
X-Gm-Features: Ac12FXwrBo6_nZg5lsK-OJiB6DGQ8ksgwpwTq6q9oUVHeDEhmJPbXv8MqQjZQmU
Message-ID: <CALTww2-wL0AyuoZTveOEBaVvFdAGYiD+=hgrMPD_kupGf1y4+g@mail.gmail.com>
Subject: Re: [PATCH v5 03/15] md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai3@huawei.com, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sTxDv2jHV-QoiQO4VB7tmgK0NBrtqARw3SV0ZeXwqQo_1753411766
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 7, 2025 at 9:36=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> It's set to 'false' for all callers, hence it's useless and can be
> removed.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/dm-raid.c    | 2 +-
>  drivers/md/md-bitmap.c  | 5 ++---
>  drivers/md/md-bitmap.h  | 3 +--
>  drivers/md/md-cluster.c | 2 +-
>  drivers/md/raid1.c      | 2 +-
>  drivers/md/raid10.c     | 8 ++++----
>  drivers/md/raid5.c      | 2 +-
>  7 files changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index d296770478b2..9757c32ea1f5 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -4068,7 +4068,7 @@ static int raid_preresume(struct dm_target *ti)
>                 int chunksize =3D to_bytes(rs->requested_bitmap_chunk_sec=
tors) ?: mddev->bitmap_info.chunksize;
>
>                 r =3D mddev->bitmap_ops->resize(mddev, mddev->dev_sectors=
,
> -                                             chunksize, false);
> +                                             chunksize);
>                 if (r)
>                         DMERR("Failed to resize bitmap");
>         }
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bd694910b01b..fc7282304b00 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2594,15 +2594,14 @@ static int __bitmap_resize(struct bitmap *bitmap,=
 sector_t blocks,
>         return ret;
>  }
>
> -static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunk=
size,
> -                        bool init)
> +static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunk=
size)
>  {
>         struct bitmap *bitmap =3D mddev->bitmap;
>
>         if (!bitmap)
>                 return 0;
>
> -       return __bitmap_resize(bitmap, blocks, chunksize, init);
> +       return __bitmap_resize(bitmap, blocks, chunksize, false);
>  }
>
>  static ssize_t
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 59e9dd45cfde..28c1f1c1cc83 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -64,8 +64,7 @@ struct md_bitmap_stats {
>  struct bitmap_operations {
>         bool (*enabled)(struct mddev *mddev);
>         int (*create)(struct mddev *mddev);
> -       int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize=
,
> -                     bool init);
> +       int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize=
);
>
>         int (*load)(struct mddev *mddev);
>         void (*destroy)(struct mddev *mddev);
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 94221d964d4f..db6bbc8eebbc 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -630,7 +630,7 @@ static int process_recvd_msg(struct mddev *mddev, str=
uct cluster_msg *msg)
>                 if (le64_to_cpu(msg->high) !=3D mddev->pers->size(mddev, =
0, 0))
>                         ret =3D mddev->bitmap_ops->resize(mddev,
>                                                         le64_to_cpu(msg->=
high),
> -                                                       0, false);
> +                                                       0);
>                 break;
>         default:
>                 ret =3D -1;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 3a31e230727c..39ebe0fadacd 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3329,7 +3329,7 @@ static int raid1_resize(struct mddev *mddev, sector=
_t sectors)
>             mddev->array_sectors > newsize)
>                 return -EINVAL;
>
> -       ret =3D mddev->bitmap_ops->resize(mddev, newsize, 0, false);
> +       ret =3D mddev->bitmap_ops->resize(mddev, newsize, 0);
>         if (ret)
>                 return ret;
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b74780af4c22..d2ef96be0150 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4233,7 +4233,7 @@ static int raid10_resize(struct mddev *mddev, secto=
r_t sectors)
>             mddev->array_sectors > size)
>                 return -EINVAL;
>
> -       ret =3D mddev->bitmap_ops->resize(mddev, size, 0, false);
> +       ret =3D mddev->bitmap_ops->resize(mddev, size, 0);
>         if (ret)
>                 return ret;
>
> @@ -4502,7 +4502,7 @@ static int raid10_start_reshape(struct mddev *mddev=
)
>                 newsize =3D raid10_size(mddev, 0, conf->geo.raid_disks);
>
>                 if (!mddev_is_clustered(mddev)) {
> -                       ret =3D mddev->bitmap_ops->resize(mddev, newsize,=
 0, false);
> +                       ret =3D mddev->bitmap_ops->resize(mddev, newsize,=
 0);
>                         if (ret)
>                                 goto abort;
>                         else
> @@ -4524,13 +4524,13 @@ static int raid10_start_reshape(struct mddev *mdd=
ev)
>                             MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize =3D=
=3D newsize))
>                         goto out;
>
> -               ret =3D mddev->bitmap_ops->resize(mddev, newsize, 0, fals=
e);
> +               ret =3D mddev->bitmap_ops->resize(mddev, newsize, 0);
>                 if (ret)
>                         goto abort;
>
>                 ret =3D mddev->cluster_ops->resize_bitmaps(mddev, newsize=
, oldsize);
>                 if (ret) {
> -                       mddev->bitmap_ops->resize(mddev, oldsize, 0, fals=
e);
> +                       mddev->bitmap_ops->resize(mddev, oldsize, 0);
>                         goto abort;
>                 }
>         }
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7ec61ee7b218..999752ec636e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8322,7 +8322,7 @@ static int raid5_resize(struct mddev *mddev, sector=
_t sectors)
>             mddev->array_sectors > newsize)
>                 return -EINVAL;
>
> -       ret =3D mddev->bitmap_ops->resize(mddev, sectors, 0, false);
> +       ret =3D mddev->bitmap_ops->resize(mddev, sectors, 0);
>         if (ret)
>                 return ret;
>
> --
> 2.39.2
>
>

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

