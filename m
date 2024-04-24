Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC09715B151
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 13:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713964168; cv=none; b=MOBU+GrVqhH6FHbKDaxBU/99BmE+iLljb/sHLBa8KnmQmH4qlKTTuHnCnDx6OMs3/sbpmgI3ugROsN5HCLqeMkL8Wjd2RShcIBWTqtL5QgeMkj8L5DARHi0sUJ96p88/Z3hU1p7oo+pw26sRPwvmXqxJKsT+98jZpl1GnN+CuBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713964168; c=relaxed/simple;
	bh=75R0hi6xxQzQP7J3rpFLOI9RJeymEoKu056YrXuz308=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=omwHvG6Xh429XuPdHS/5PPmqGCy1W/HxLyQpZogA+dsNo30P+mfrrJovtDKEj6M8jEMo/x/r0dvABoDtNniBmz///aI6JVhWWuOLF2o5XBhLJWFr3Lh4ODaDF7Z0xPwAn1Z9jtO1xVvWVgL5x0O7o0j6cCSN/xmLH2pwh6j8hp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-61ab31d63edso7857107b3.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 06:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713964165; x=1714568965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xxwNYEWxxeYtCAyvMedqQ43RfWohIK85VVdJWkk9A8=;
        b=iajvHq09zUsLZfuCacBrBYZhit+iCorbakz97OKkD6tV9Av5mzJ58oy/I2XL9Z4rpM
         ZneWRNd4Y9oSqOvJDBkVxeB6QT74mUlCvGU5yjiaVyGGyJKvccsdYNKq3ygNVceLQ+K9
         jLe3+hgDgDBkngTUTCx89/j/Uo3EfMm88WfrlSTa3+3zLdRuxIT5bWBefMz5sChgY4CM
         uz/q4gM3W1Khd0cmMdtSA981PFu21+0FbFnFzagF5EDox3bCkg/z9bKUB9bDkmiyV5Ge
         D23gWnhSDxixK32ijoXIKm47K9vTrmahA1yvgWpHUH6mw2hbeX4RSkTfQwzIgN/G7b5a
         jf3A==
X-Forwarded-Encrypted: i=1; AJvYcCV18+dK7KJG5oUvjHcb3z2/aBtvoMNmNPYa1aJFlKb2C+HC9ubhkbOdF1hOCBvdyrvaQ66KRemrsZndH4SyJ8XeddXTibu2UK0=
X-Gm-Message-State: AOJu0Ywygi5/8gJ0Z7Aet7ZXn3qVlkJucmUE1/702BUszeKce7WWQBz5
	zLdYtRkhG00+hPH68Ukei2b24R96iKxFe0YH+Vc4TQfEaw9ekjxn+a+grMh5
X-Google-Smtp-Source: AGHT+IFEkqzjxz46gALogx4I7Y/NtkgkPDrKxyjPHcYxrwFBhWqin3Sdec2ckDakghx15fafEMaoyA==
X-Received: by 2002:a0d:d0c2:0:b0:618:498f:9dbe with SMTP id s185-20020a0dd0c2000000b00618498f9dbemr4848545ywd.10.1713964165222;
        Wed, 24 Apr 2024 06:09:25 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id a131-20020a0dd889000000b0061129ac87fcsm3014319ywe.113.2024.04.24.06.09.24
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 06:09:24 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dc6cbe1ac75so713148276.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 06:09:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXHmVAWOdWyZhnSQqFTgGTB/CKcD1Qxc8piI7wKfiDa9wBM4cvlt01ZclEtJsd/P+vtS0n24x3k83AQ87SxF8K4xCUyxr/9YAo=
X-Received: by 2002:a05:6902:72f:b0:de5:4b29:22e6 with SMTP id
 l15-20020a056902072f00b00de54b2922e6mr2273181ybt.1.1713964164555; Wed, 24 Apr
 2024 06:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240407131931.4055231-1-ming.lei@redhat.com> <7e38b67c-9372-a42d-41eb-abdce33d3372@linux-m68k.org>
 <Zij97qGQY1MRrEb8@fedora>
In-Reply-To: <Zij97qGQY1MRrEb8@fedora>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 24 Apr 2024 15:09:13 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVrx8M62ETfuX44UZ_y8ab-JwTNA28V6WObg_kFXP+HyA@mail.gmail.com>
Message-ID: <CAMuHMdVrx8M62ETfuX44UZ_y8ab-JwTNA28V6WObg_kFXP+HyA@mail.gmail.com>
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask and
 max segment size
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	janpieter.sollie@edpnet.be, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@kernel.org>, 
	dm-devel@lists.linux.dev, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ming,

On Wed, Apr 24, 2024 at 2:41=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
> On Wed, Apr 24, 2024 at 12:26:26PM +0200, Geert Uytterhoeven wrote:
> > On Sun, 7 Apr 2024, Ming Lei wrote:
> > > When one stacking device is over one device with virt_boundary_mask a=
nd
> > > another one with max segment size, the stacking device have both limi=
ts
> > > set. This way is allowed before d690cb8ae14b ("block: add an API to
> > > atomically update queue limits").
> > >
> > > Relax the limit so that we won't break such kind of stacking setting.
> > >
> > > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D218687
> > > Reported-by: janpieter.sollie@edpnet.be
> > > Fixes: d690cb8ae14b ("block: add an API to atomically update queue li=
mits")
> > > Link: https://lore.kernel.org/linux-block/ZfGl8HzUpiOxCLm3@fedora/
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Mike Snitzer <snitzer@kernel.org>
> > > Cc: dm-devel@lists.linux.dev
> > > Cc: Song Liu <song@kernel.org>
> > > Cc: linux-raid@vger.kernel.org
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >
> > Thanks for your patch, which is now commit b561ea56a26415bf ("block:
> > allow device to have both virt_boundary_mask and max segment size") in
> > v6.9-rc4.
> >
> > With CONFIG_DMA_API_DEBUG_SG=3Dy and IOMMU support enabled, this causes=
 a
> > warning on R-Car Gen3/Gen4 platforms:
> >
> >     DMA-API: renesas_sdhi_internal_dmac ee160000.mmc: mapping sg segmen=
t longer than device claims to support [len=3D86016] [max=3D65536]
> >     WARNING: CPU: 1 PID: 281 at kernel/dma/debug.c:1178 debug_dma_map_s=
g+0x2ac/0x330
> >
> > Reverting this commit, or disabling IOMMU support fixes the issue.
>
> Can you test the following patch?
>
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 8e1d7ed52fef..ebba05a2bc7f 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -188,7 +188,10 @@ static int blk_validate_limits(struct queue_limits *=
lim)
>          * bvec and lower layer bio splitting is supposed to handle the t=
wo
>          * correctly.
>          */
> -       if (!lim->virt_boundary_mask) {
> +       if (lim->virt_boundary_mask) {
> +               if (!lim->max_segment_size)
> +                       lim->max_segment_size =3D UINT_MAX;
> +       } else {
>                 /*
>                  * The maximum segment size has an odd historic 64k defau=
lt that
>                  * drivers probably should override.  Just like the I/O s=
ize we

Thanks, that works for me (both with/without IOMMU support)!
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
