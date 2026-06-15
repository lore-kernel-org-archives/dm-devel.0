Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD0930D3F5
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 18:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547615; cv=none; b=Xj9J8dVX0hBcX12+XpnI8Mq4aHIqSlCc5RU08VeZ0AZwl30ntRyfh0FeAAI+s/6LrTKWC/RVZ7vdgU2OW/cOBYcp3QudotaNS9+43givrYj/f6aqbbLb9fQmVEUL3tJpj1Wt5t0ueh9HXTs8Zq8+MEo4WNyoFXL2IQ2Q5fUceLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547615; c=relaxed/simple;
	bh=c+ml8RSe6wp0pbTPqPbKBu0+VgRO0WacvQqiIPK5GOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ABE4FQ/KBFC6/fhc93aBtw51GJBJSF4H5z+AKmOOJKpBgXpQTiN+poXAcUSrtFEExB3IVUN9upPlp7KndoGywHR0XERt5/r2K9PRgJLdvZ2e/O+jf4hkkJqt7pg5kjaaQutEpSCTjMx6kO0R2sSF0rtw2IWDOyLHiKmFCpqNcps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMMJCvIP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMMJCvIP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781547613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmwnm42JYU+G9jaYgd9NUsf7KZ9Dxsc+uPSbITE9tPE=;
	b=VMMJCvIPuh5ba9Gc5V5T9JIeTFIqt/mI7Baq9EX3AdWeP5XZSx6V/Y117x35PK1yY/I9IA
	8i0eVQFnJOLcXIFsAzfIthpbN9lFz8xFY8GzWoBrIoW42n4upP01kOfjpQVPMDmYM2w0Z3
	DGg9jhbSkLrCC9znybvUoMWnt+Hjk08=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665--TYR1g23NLGHgOCyuz074Q-1; Mon, 15 Jun 2026 14:20:08 -0400
X-MC-Unique: -TYR1g23NLGHgOCyuz074Q-1
X-Mimecast-MFC-AGG-ID: -TYR1g23NLGHgOCyuz074Q_1781547607
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-396708fabd9so15698511fa.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 11:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781547607; x=1782152407;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gmwnm42JYU+G9jaYgd9NUsf7KZ9Dxsc+uPSbITE9tPE=;
        b=cO/As13n4ojD4n5ppBgXh8sLkcsGpcsog/CKIwbuqUf0k8lnzAOvL2utyfXUy/W5go
         Y8NxyELUAU0nlRgNoIqMTnEilbg6UnpnjTT3s4retUjdg6RafW/UpCpQy1BUJcTzK+Dp
         Z1vZT/CSQBxptx4SNFndkc3uRpNftkfIiN1Ou8HXvd+kmmcHOmwLM2OoMhak7zZCm6/7
         5yZWdXojVZTWzNbgqNIIWCKKGDgbNslJlRGlBVvZX9ZoPZAiZsasa6XPb6IW66y67voP
         0QQv4lly/27jj7Yee1KlGY0H3Da46/hCV5QTFqvyAOp1EzmkI4N4ji6ialeNnCaPx94e
         qnGg==
X-Forwarded-Encrypted: i=1; AFNElJ+eMyJB+DAPZZccJ22VbRx5mPDOVN8Gylfgqn/XtMqCX6saAYAvafWxVq8zDcrHuc/r4DLT9XXUWw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0H7H/d4AB46OUq+y5JpYXSqBkqp++ljNs9X3W3QF5FLrfCrhK
	TiBRT8clH6xJN/Q05I9UKmjOParxLXIfaoO9SM/TiW7ZyHJRzejTp7oezvLowAoNCN29V5pQOYi
	MGBS4WZm8k6CLEPvzYZjy50bH7VUJ+93I+fvUG6MIQzKlOPOyPCw6IuooaNe8zHC/RcER7kq+cB
	n3ct17/5ra5HrFvmkSUHJIeOcr8tudm33KYQ==
X-Gm-Gg: Acq92OFQEHeTpU1d9EVpidNf09x+ZLjPd3ScwgGoysz5H+oKMpX6eaN1GacqDaUUI/u
	yzlyN+oX12Qui5tRt+uZShXrjRZJHTPQjV0ptn4p1qO1TrvSPZA41mWO07OZvcx4ODb8oDph89v
	MEjsh/W4/6cblC/XJEvQtpoFFgHJsl3gOTz/6VhTC+Ej+ZZjysxfTBGvMrr8Vs8VmTum2/TwqnJ
	wCcAz8=
X-Received: by 2002:a05:651c:2108:b0:38a:2776:1484 with SMTP id 38308e7fff4ca-399357991dcmr34436691fa.28.1781547607116;
        Mon, 15 Jun 2026 11:20:07 -0700 (PDT)
X-Received: by 2002:a05:651c:2108:b0:38a:2776:1484 with SMTP id
 38308e7fff4ca-399357991dcmr34436601fa.28.1781547606589; Mon, 15 Jun 2026
 11:20:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260609002354.1236297.0535ba20b556.dm-era-target-offset-mapping@trailofbits.com>
In-Reply-To: <20260609002354.1236297.0535ba20b556.dm-era-target-offset-mapping@trailofbits.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Tue, 16 Jun 2026 02:19:54 +0800
X-Gm-Features: AVVi8Ce5SqzuJvUXYV5wt38mPdetkc-9qmV-CsS3SBfKTKj9YSKhJb0VkFE10yU
Message-ID: <CALjSBEs3y6cug0V0F-foOGy37JaRvDOqLsCT-bJ_LZfmF0AKug@mail.gmail.com>
Subject: Re: [PATCH] dm era: include the target offset when mapping writes
To: Samuel Moelius <sam.moelius@trailofbits.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2ZN02Zqf5g5OM1HlH0Zg-Z3cOPy6LypsTX89nwaqQP4_1781547607
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 8:36=E2=80=AFAM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> dm-era tracks writes in target-relative blocks, but the mapping path can
> ignore the target offset when translating bios.  Tables with a non-zero
> start sector can therefore map and account I/O against the wrong origin
> sectors.
>
> The result is inconsistent metadata for devices that are not mapped at
> sector zero.
>
> Apply the target offset consistently when mapping and tracking writes.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
>  drivers/md/dm-era-target.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index 05285c04ff2c..18aed0e2a508 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
> @@ -1229,6 +1229,7 @@ static dm_block_t get_block(struct era *era, struct=
 bio *bio)
>  static void remap_to_origin(struct era *era, struct bio *bio)
>  {
>         bio_set_dev(bio, era->origin_dev->bdev);
> +       bio->bi_iter.bi_sector =3D dm_target_offset(era->ti, bio->bi_iter=
.bi_sector);
>  }
>
>  /*
> @@ -1560,7 +1561,7 @@ static void era_dtr(struct dm_target *ti)
>  static int era_map(struct dm_target *ti, struct bio *bio)
>  {
>         struct era *era =3D ti->private;
> -       dm_block_t block =3D get_block(era, bio);
> +       dm_block_t block;
>
>         /*
>          * All bios get remapped to the origin device.  We do this now, b=
ut
> @@ -1568,6 +1569,7 @@ static int era_map(struct dm_target *ti, struct bio=
 *bio)
>          * block is marked in this era.
>          */
>         remap_to_origin(era, bio);
> +       block =3D get_block(era, bio);
>
>         /*
>          * REQ_PREFLUSH bios carry no data, so we're not interested in th=
em.
> --
> 2.43.0
>
>

Thanks for the patch. This is a general bug for any dm-era table with
a non-zero start sector, causing out-of-bounds memory access to the
bitset when calling writeset_marked. Here's the reproducer:

```
# era metadata
dmsetup create emeta --table "0 8192 linear /dev/ram0 0"
dd if=3D/dev/zero of=3D/dev/mapper/emeta bs=3D4k count=3D1

# era origin
dmsetup create eorig --table "0 8192 linear /dev/ram0 16384"

# create an era device of 64 blocks, plus 2mb (32 blocks) padding at the fr=
ont
dmsetup create era --table "0 4096 zero
4096 8192 era /dev/mapper/emeta /dev/mapper/eorig 128"

# write to the 64th block. it should be the 32nd era data block, but
being mapped to the 64th era data block (out-of-bounds)
dd if=3D/dev/zero of=3D/dev/mapper/era bs=3D64K count=3D1 seek=3D64
```

KASAN report:

BUG: KASAN: vmalloc-out-of-bounds in era_map+0x263/0x4a0
Read of size 8 at addr ffffc90000075008 by task dd/86

I'd suggest revising the commit message to emphasize the severity, e.g.,

dm era: fix out-of-bounds memory access for non-zero start sector

