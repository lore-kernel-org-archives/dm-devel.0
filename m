Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A73382CD
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 09:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781689556; cv=none; b=mpP3bYLV0RgmUPrlT5drwByQYZJWzHyzHPZSAenmsJQcaWLWuJUE1k/NfFlkwW6n56YEE7eFi/ilDfBBFoqaGiTdYUUtm8D0UzQklC7D+1kqpt+mFjqOMs/94PFJafU5096Y1YHUyHq/b7i4lpXg4ymeChXjjSdRIyNBYk/UkVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781689556; c=relaxed/simple;
	bh=L980BIwHHXojlq8hhqxw1N+VxOhOODtB6rxBQd0sJOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=MqW6ABjYxTIEyUH2I4VZMRGh8Oa++j2fPahbknjdWfpkXTVYK9r01fNIJCSJLkwjt/befnlMaVQD5yNlDoxbRAZl8JX9WI4k4kX1EdadFB1k4SB/YZUlGkXTCZHkJnIueUsHFrZK4cWAC5dAsHpXsSrZv6RVb2XzrRamtcK75+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HCxCs9Lp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HCxCs9Lp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781689553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L3+9s1/nOGraCi2l4bI5+oosDAck//XgaELcLiJZQdE=;
	b=HCxCs9Lpfesq2C9vRsqBKwVXXqt41pnjB2+x4xn49Y4Kdr4kiQlIHLWY5cILO4JtXNXtH+
	jB6rBtgCf2/0+tMo6/DWWhvXV+lGFhsDPfC5tUbYqNynRYeDOYaP6FyRwrmHvwUg7SCt10
	k2mBmzTZ4fhOlJ3RU1hksMF/Y6YH0yE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-J7O3o9mENOGMdIrtFwmURQ-1; Wed, 17 Jun 2026 05:45:51 -0400
X-MC-Unique: J7O3o9mENOGMdIrtFwmURQ-1
X-Mimecast-MFC-AGG-ID: J7O3o9mENOGMdIrtFwmURQ_1781689550
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5ad4acfca01so149878e87.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 02:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781689550; x=1782294350;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L3+9s1/nOGraCi2l4bI5+oosDAck//XgaELcLiJZQdE=;
        b=CjUlA/lUJ80TuldEjJyMTEaP+lXA6WGs0nDkyO2pzbc77Q9b1RLPKyZRfFwiV1zBhw
         eLT7TXwoeUlI2SOJ6eGe04916pa7ccLpneb9UH/9b6wMcJDglVxCkvdMxBIdIl5fVeip
         1JC4QOEBmmkWEL7K6d0NfjyIxj7889Au6KZVjyuX7UqzRh1byHfadezAJRbxxociM+NS
         rYjPfxM1B5aMVOLNttk6qDUStaJUlHNamAd5sDD71W39cIV6dez5ySNqOHZ4Y4J9Tg1T
         zMTWxStU+7hrbGYXWwxc+jU7pmphD/AjU5D2Ob+BQLnjQdZ4DoRS1Mpe87Jt1gawLMJo
         6YCA==
X-Forwarded-Encrypted: i=1; AFNElJ8ir/yHuQzXWUQYs4XAZI52NmnEgzj4HYryc1nWS1Q9zRSJDCYaAhi9gowkRkmzsHUcDG5swba4sw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy39537SF+5MDZU4/SyRew69CAwxy7z/k7juRZmA5cophHs08z
	cNEGK2pk22eW/wl37Hqa/MYoi7T648VEjVxBtwDrVy4M5VvvdJRhE9Xax6gEKifd4Ccd0mt2zR4
	W5DDTB18ie0fKZ1otWWlJF43waOnJVV9qaq4dFeJNvzgJGcM590hO/ZxEKmPuO5+70RVzk/m3+o
	BXl500400xX0sGDMDfrKQr5zlFkdoOU5PcQg==
X-Gm-Gg: AfdE7cnyI5lgazCNg7IuWEcjbe/sBCMPSrOix0vAr2DhkiUjOePLnfMP3t2OD931qis
	7qHvB3WpxlpJClZf0BTFlMSQe48u5X5RqWjdxs1dlMyK/fUwA8EbHXEHS0wzNAgAFxWt4atPpBF
	Pl+9xVCZlCeDWhrCNreGfXM16gO5sUSinRQd847I/gtTlAGKhaT5oRfpq7byM6LB+EGA==
X-Received: by 2002:a05:6512:138c:b0:5aa:6ede:52 with SMTP id 2adb3069b0e04-5ad46fcba37mr878587e87.10.1781689549603;
        Wed, 17 Jun 2026 02:45:49 -0700 (PDT)
X-Received: by 2002:a05:6512:138c:b0:5aa:6ede:52 with SMTP id
 2adb3069b0e04-5ad46fcba37mr878578e87.10.1781689549002; Wed, 17 Jun 2026
 02:45:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260617021109.31595-1-ghuicao@163.com>
In-Reply-To: <20260617021109.31595-1-ghuicao@163.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 17 Jun 2026 17:45:37 +0800
X-Gm-Features: AVVi8Cfh4APoPyhJppWguq6R_V19pEY5OOJiWZ6_6eg7LsoxRauuMxdlAeIfhZI
Message-ID: <CALjSBEvEOFPJy37tFMYD2RJL8BStreT6G20WGVrTV84t1DDN3Q@mail.gmail.com>
Subject: Re: [PATCH] dm cache policy smq: fix promote level threshold clamp
To: ghuicao@163.com, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -nFH0UNcSyPwtHiNT2EY1F-jYTR1dzlqN0mrvdnYj-E_1781689550
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 10:23=E2=80=AFAM <ghuicao@163.com> wrote:
>
> From: Cao Guanghui <caoguanghui@kylinos.cn>
>
> In update_promote_levels(), the threshold_level is clamped against
> NR_HOTSPOT_LEVELS (64) using max().  This is wrong: threshold_level is
> later subtracted from NR_HOTSPOT_LEVELS to derive the actual promote
> level, so a smaller threshold_level means a higher promote level (more
> eager promotion).
>
> The comment above explicitly states that when the cache has unused
> entries, "we want to be really eager to promote".  default_promote_level(=
)
> returns values in the range 1..8 for this case, which would produce a
> promote level of 56..63 -- but max(threshold_level, 64) forces
> threshold_level to 64, making the promote level 0 regardless of the
> allocator state and defeating the eager-promotion logic entirely.

Currently the promote_level could be {0, 32, 48}, depending on hotspot
queue performance. Using min() instead would raise the promote_level
to {32, 48, 56} when the cache is not full, or {56..63} when full,
making the cache more conservative than the current setting in either
case.

I noticed this ambiguity for a long time. A proper cleanup to remove
default_promote_level() and simplify initialization is on my radar,
but it's not urgent since the current behavior works.


> Replace max() with min() so that threshold_level is properly capped at
> NR_HOTSPOT_LEVELS while still allowing small values to produce high
> promote levels as intended.
>
> Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-pri=
son-v2")
> Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
> ---
>  drivers/md/dm-cache-policy-smq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-polic=
y-smq.c
> index dd77a93fd68d..b3e5f7a12345 100644
> --- a/drivers/md/dm-cache-policy-smq.c
> +++ b/drivers/md/dm-cache-policy-smq.c
> @@ -1064,7 +1064,7 @@ static void update_promote_levels(struct smq_policy=
 *mq)
>         unsigned int threshold_level =3D allocator_empty(&mq->cache_alloc=
) ?
>                 default_promote_level(mq) : (NR_HOTSPOT_LEVELS / 2u);
>
> -       threshold_level =3D max(threshold_level, NR_HOTSPOT_LEVELS);
> +       threshold_level =3D min(threshold_level, NR_HOTSPOT_LEVELS);
>
>         /*
>          * If the hotspot queue is performing badly then we have little
> --
> 2.25.1
>
>

