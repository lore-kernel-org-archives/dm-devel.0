Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D992D8375
	for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 11:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765366969; cv=none; b=otx9VQKJe1B3QeQ2sQ3CpjAqMd29VjV7wSJeK3I0dUiRJU1h30XRheWglc+QmRj0kx011rUKauz8AgTo0ApXHUhPBXL9/yi+/vvwUzqxRweqqd0C+QRtRMaSjB9ESg3fMAZb0K4hRjRCxy5aN1kSsoMa9Q8AoJ3k07tUTfR5tQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765366969; c=relaxed/simple;
	bh=Qeb0rDwNAyrZnvXsCeKlkXQ5ll1deAIL3mbFVfL6vlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VsbnK+zOzl3nBrXhgAI/qRsRBdMp3CUZWCtVEFeM4dyYkbfZidolktsUz2hYPV5MlLN60YaLymcYguC/IG5E2LYEnna9SPg/oBhPX2PqOADDpsp1sHel2eLkljBnb6kN53HUg2dmlkK3DjsQAm0EXZ1K5JeCyXebclchXwBJ2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ra5CbvWx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ra5CbvWx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765366966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/wrrTS/2sJFEBORcbIGIvzUcRA4mbZ1YH/oiUdSU4wU=;
	b=Ra5CbvWx2a+B1tsMfThu0mrJdNgBPQnNkVTMGzfZbF5BA4qgLrF9cVlTx95JI6/G1+JPzD
	0j5We5x+kcQ4TPRItc90vDdIlEiILEoanKvAcybuFDmNsCbbmP1khDY7lyz6uLYNUDom3g
	w1h4wkDssa995EEc+JAQwo9wkjiCgAM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-aaEUYE9DMvCVRuMYX3Trfg-1; Wed, 10 Dec 2025 06:42:45 -0500
X-MC-Unique: aaEUYE9DMvCVRuMYX3Trfg-1
X-Mimecast-MFC-AGG-ID: aaEUYE9DMvCVRuMYX3Trfg_1765366964
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-37e6840a09bso23042141fa.3
        for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 03:42:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765366963; x=1765971763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/wrrTS/2sJFEBORcbIGIvzUcRA4mbZ1YH/oiUdSU4wU=;
        b=mjH1eS7W2OzhrzMOOuE1EDLTV0nqottUvfmQDVzFfYh1ifvUzJcFaTnBIN1abJNFRB
         fMhU6OiOiQqTQz6yN9xITlyQ751UfVAKVL+D1KwKnres1jOVM+9uUjGlGhImyaovJTQ9
         7BkPvjxSnxxDf+HLr5xQWSPOb9tVh53AtnFe9z3dKc4epgtykfckQ+EraUko/eVz0LAh
         s6dMJQERcx8ZLbCXHq1kYfpd1mYlq/jIf1378cH/KQfoVEILQ5akfkSi0o0XxytiT7pa
         gdJTazof809w6Z4iogCyuor25IF3AE1CdQXmCG1T7nyWUQ7tlP1GGDWRfVVwCYoGK/7K
         uqCA==
X-Forwarded-Encrypted: i=1; AJvYcCXEwcxR6A6bIbHkT//YAp1OZ+W5PQZ1ESeDw9LDFXLTsXhuAMT7qe14sqQoLqJ1WVnLZh7pz284fA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwmqOVkhsrwxOl9HBHroXCEx+nKgku4zNoDBsz9SaZvAsxzJaAW
	ZnKZg605dtS2UTtcLq/EniwKBN46KF6nn6/H9oB0uQjHBU/9CjH55HSoEzS3VLWIO3mFgQ1tTyk
	PmM/ndYvlxxN8+a/1jq6g1x9ncHbFkxRo0vVy2TXqs+yZMd16zXbzxQhDsphA2oCrttJPZSyQHe
	yL9z8CKDhp8AUuoF44O3sUr7uvWupwL7P3Vg==
X-Gm-Gg: AY/fxX4KBNLP+utHmTbNKVYU60ov1dCo0qYDIIkPCXOqNLB8XKqls71mBm6GO3zR/Ac
	amVQW0A+NSyFCNKpMfmvflLXsPqN8IwP9yA6SydRZqplb1ogi7M0i9sAzWpZGVQIHi/LQDp5J2m
	3r4sVSFepBd0snSgnfGnnPrRAf8UzYsqyD2ehUQaIGntEFtistl8IrQyPG5ddVDdnw
X-Received: by 2002:a05:651c:3242:b0:37b:9d1e:b196 with SMTP id 38308e7fff4ca-37fb2036d3amr7057171fa.3.1765366963558;
        Wed, 10 Dec 2025 03:42:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGF6ABaJMCtEgEXl8xMGwtq92GZ3/5FIP2NeZ6tiO2utSiLrtZs6hZetA6pBbn8F5YDWEVlspOpsSIposbCUQY=
X-Received: by 2002:a05:651c:3242:b0:37b:9d1e:b196 with SMTP id
 38308e7fff4ca-37fb2036d3amr7057001fa.3.1765366963147; Wed, 10 Dec 2025
 03:42:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210031757.66037-1-me@linux.beauty>
In-Reply-To: <20251210031757.66037-1-me@linux.beauty>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 10 Dec 2025 19:42:31 +0800
X-Gm-Features: AQt7F2oOwJf-_03NvunYdSuQ0L_1xqRpjcX6Fe7cRKL4Kne6NLs08VW4DuuZ5os
Message-ID: <CALjSBEuEd70qy2DZUT4gMPJp4bALzZitu+JOr6TBHCXRkTrw+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] dm cache: drop redundant origin size check
To: Li Chen <me@linux.beauty>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pwhXJM_41R7qZg9CPlkwfggNAC5-GkERwNOha4y5Gn4_1765366964
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 11:25=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
>
> The cache target already exposes the origin device through
> cache_iterate_devices(), which allows dm-table to call
> device_area_is_invalid() and verify that the mapping fits inside the
> underlying block device.
>
> The explicit ti->len > origin_sectors test in parse_origin_dev() is
> therefore redundant. Drop this check and rely on the core device
> validation instead. This changes the user-visible error string when the
> origin is too small, but preserves the failure behaviour.
>
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>  drivers/md/dm-cache-target.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index a10d75a562db..350a0aa53365 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2099,7 +2099,6 @@ static int parse_cache_dev(struct cache_args *ca, s=
truct dm_arg_set *as,
>  static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as=
,
>                             char **error)
>  {
> -       sector_t origin_sectors;
>         int r;
>
>         if (!at_least_one_arg(as, error))
> @@ -2112,12 +2111,6 @@ static int parse_origin_dev(struct cache_args *ca,=
 struct dm_arg_set *as,
>                 return r;
>         }
>
> -       origin_sectors =3D get_dev_size(ca->origin_dev);
> -       if (ca->ti->len > origin_sectors) {
> -               *error =3D "Device size larger than cached device";
> -               return -EINVAL;
> -       }
> -
>         return 0;
>  }
>
> --
> 2.51.0
>
>

The size check in parse_origin_dev() provides early validation during
table creation. Removing it delays the size check until the resume
phase when reloading an existing device, which leaves the device
suspended if the new table size is invalid. This changes user
expectations and could affect volume managers like LVM and Stratis.


Ming-Hung Tsai

