Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487641A238C
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 06:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745301672; cv=none; b=r7yjIw3ODb1sO4tXIFwlVf3y7NpAyy6TXOSQikW7AYoHyrLqbN3XK/wsigDF9N6Zkh36jWuZTDK/c+CLlG6G7ugeLd0+f6tuyWr9IjP3DW2HnwuPom2oy7caXMOldlBfCB64swiN9pCrRI0hsxImol4MLYtp3650uAGck2WoCX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745301672; c=relaxed/simple;
	bh=ryrrb1y06tmN0kQiAjkDpAfgEs20dlNc0D51dW/4PXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bl46AswKusSuR/tq7qXxc55zD8j7s5U3bp/3fxUwjLO52uMQLzAtrRCpbhHJ1XfYC+lrHRcC16zCNdSdmAHI5aI5C3zwsOwaYSdn+SUOwgs3z4RY5vT4hFDij1D8Esz5P3VoxxTYFZoFuoJkfCugYcUOFkYTQc0MxbIZLVE3trM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ApbEmGaM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ApbEmGaM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745301666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmVaZQzLh9EzB5YtxGNfRajzM5T5KN9CVrb+5GDKEow=;
	b=ApbEmGaMeGZ9SliYfYHZv4pDeQ+DpjuRi3lvp16T3vtz59AVM7gaexxh+c+atz8njBffEs
	zTy+Uhg7C2BcL6BF13WaZBX6AsfTKNFerk/WVC5QqmYfo01RTudNZ1TzlO9s6m6Mo852zj
	vTujPscNpU2VcHiv6O9Fols60+Fmyhs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-2Dk6d8SkO62-blpde4x3Ww-1; Tue, 22 Apr 2025 02:01:01 -0400
X-MC-Unique: 2Dk6d8SkO62-blpde4x3Ww-1
X-Mimecast-MFC-AGG-ID: 2Dk6d8SkO62-blpde4x3Ww_1745301660
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30d6a0309f6so24748401fa.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Apr 2025 23:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745301660; x=1745906460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmVaZQzLh9EzB5YtxGNfRajzM5T5KN9CVrb+5GDKEow=;
        b=lLOKb11QJLEDGV3v7C8fqq4xgExHJvvwLAvCDP+yzk1g3v9Md0LQJ6uVT4eF39siKk
         kIeC+9go3Xf9znJh6u9ktidJ1JEWunCzoNVdy7HXtsgKEB72MJgnm9Cksgz8heUMwYJM
         pO2+8DvDqSM68ESXJan5LofmF7gzMCFH0mnkuggzaWAtvrBSjWyrIPIYJzEPVKQAvfoj
         9jphqHMIcf9Wwaj2UZ0Mp+bA8zo8/E1twZd+aJHm0yImDnaf3DuSPohL4J9va0BEHwhp
         AUBW8fTePqA15UTL1Omu1Uhd6x6kBH0MJplpuSKD3BmC0auZ00ZaNTlBto0yWEAaGwkk
         nPLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs1yGekNyGuG93DQZNjkwfYSrvftfB5ybhJW9Towm3bXDz9yt/8+ImVUhou6o9WPagyRnWUn879g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5pIiTESNcOiVEtxVI/ET7ofG06KHO+Mh6gTV6PIVuZGCE5Cwz
	l8WQg8CYAPbkWc2i3Svoh5JwUkGr7UpnBPlF/2iTF/H/TGhhTrVWTuo8jX69MCxJnxy0r+2nNAU
	cVvbVhxwEqAR+x4X0thN7gUIbjBxy3hEAc5zuUIkS09RZtqOik5JZKerD8w91TQNUznmiK5jOD0
	EN9lyM7lNmLRK61nV5pbeSo7cB9E+nRJc=
X-Gm-Gg: ASbGncsW9TE6+4tj0gMmTWAQ9jw92PM1c/jLRAMts8uvlZBWCQZ0k2RXirvEfEU9HOf
	RcUwxNgPA5Q+q9zXfzYov3AWKH40IZg0dQ4wT2vaRfMyXjTDBUe5twF5jYrHc6kj0EEZ/IA==
X-Received: by 2002:a05:651c:2225:b0:30b:b9e4:13b0 with SMTP id 38308e7fff4ca-310904dc746mr39170081fa.12.1745301659971;
        Mon, 21 Apr 2025 23:00:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqU1jpMVzklLc0LYUoiw2pX2+zQ+Ae1Qiw/Dlcjlmsl4WFlusGSEBhgoXOJ4AXz/ONZUVxLjoJd3VFiEjDhek=
X-Received: by 2002:a05:651c:2225:b0:30b:b9e4:13b0 with SMTP id
 38308e7fff4ca-310904dc746mr39170021fa.12.1745301659584; Mon, 21 Apr 2025
 23:00:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250418010941.667138-1-yukuai1@huaweicloud.com> <20250418010941.667138-3-yukuai1@huaweicloud.com>
In-Reply-To: <20250418010941.667138-3-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 14:00:47 +0800
X-Gm-Features: ATxdqUGoL_dvxnP97XF7H0NhlTFLX63ezZFe3gUv617gquhQtrDzo9ggZhcnrJM
Message-ID: <CALTww299yYNHAMeYy8TczxsUkuHyj53g6yErNAtkou2mG9z7tw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] md: record dm-raid gendisk in mddev
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, yukuai3@huawei.com, viro@zeniv.linux.org.uk, 
	akpm@linux-foundation.org, nadav.amit@gmail.com, ubizjak@gmail.com, 
	cl@linux.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mmYaD0T069lYugm1nlFVgtbYlSx5LXbMUAw48JS7Kng_1745301660
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025 at 9:17=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Following patch will use gendisk to check if there are normal IO
> completed or inflight, to fix a problem in mdraid that foreground IO
> can be starved by background sync IO in later patches.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/dm-raid.c | 3 +++
>  drivers/md/md.h      | 3 ++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 6adc55fd90d3..127138c61be5 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -14,6 +14,7 @@
>  #include "raid5.h"
>  #include "raid10.h"
>  #include "md-bitmap.h"
> +#include "dm-core.h"
>
>  #include <linux/device-mapper.h>
>
> @@ -3308,6 +3309,7 @@ static int raid_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)
>
>         /* Disable/enable discard support on raid set. */
>         configure_discard_support(rs);
> +       rs->md.dm_gendisk =3D ti->table->md->disk;
>
>         mddev_unlock(&rs->md);
>         return 0;
> @@ -3327,6 +3329,7 @@ static void raid_dtr(struct dm_target *ti)
>
>         mddev_lock_nointr(&rs->md);
>         md_stop(&rs->md);
> +       rs->md.dm_gendisk =3D NULL;
>         mddev_unlock(&rs->md);
>
>         if (work_pending(&rs->md.event_work))
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1cf00a04bcdd..9d55b4630077 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -404,7 +404,8 @@ struct mddev {
>                                                        * are happening, s=
o run/
>                                                        * takeover/stop ar=
e not safe
>                                                        */
> -       struct gendisk                  *gendisk;
> +       struct gendisk                  *gendisk;    /* mdraid gendisk */
> +       struct gendisk                  *dm_gendisk; /* dm-raid gendisk *=
/
>
>         struct kobject                  kobj;
>         int                             hold_active;
> --
> 2.39.2
>

Looks good to me, reviewed-by: Xiao Ni <xni@redhat.com>

