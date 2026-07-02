Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8166A431E5B
	for <dm-devel@lists.linux.dev>; Thu,  2 Jul 2026 00:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782952015; cv=pass; b=YK5v/4jWe23qSQBSUhhPEbci6HC2bXFE/KAQ4/4oUVDYzYMUd6alK5y17ltlCpH6s5RqdZDaIE2J64sB4QdGBx1wm9cVQj0AKvhJbJhrUfMPy/Ak4UVW9uOcTnBCW5YJ+PIQ+ilScGAe1yjhrz60agT4jsl+ffzD9TZajwh9FIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782952015; c=relaxed/simple;
	bh=otnv/dgxBWhR15kl7rH469jlHc6F/Ktp9ndcr5PSUis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=breGKrVUZD3B0aYOJB7IVa01rOOfj7gYdtxDsbuqximodkofF6Uojhiqp4J0upibKa/PShNnF9Y67WuvPtfLYRF/eUGyZNju/dp+R7jG7TraMjJExylUxiokUmqJcQl0GtRClnCD8XOm8Q3lxgsLl3kQ9MeIJojXBxWfqqgZeeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=kWc10vqw; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="kWc10vqw"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39b14a7e53aso13928721fa.2
        for <dm-devel@lists.linux.dev>; Wed, 01 Jul 2026 17:26:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782952012; cv=none;
        d=google.com; s=arc-20260327;
        b=Dy7bDxBR6agOr414+YLLztRQwjuao1A6S8emOmnWWETshaq5JH52ofb94TU7v+bx1t
         qE8jr1f5s9CrgSo61lFFIKAleKs8cutIYw5RGrClxEnm1xT/Xn1Xc578ShcT+ga6Jzfs
         8HH3mbyf7FwN/zjhPk+EbdUqo70uPp6teUiyNeYz5pJfSZ5gCkYltnCxh7w3QsM7kbD0
         PoCxmcKrEDMnv/QL6zSUcaCVw+Js9Oc5RDvMdGdUuUuCQzXmRv0LJ1Zq+fGRVaoKaI59
         WhX0HuTNBkmHHhG2HZi351Va6uMgXM1JOhcTk9x7I0KXfX5Xu/AZUVDLD7ieqLrW1VZF
         lUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SvfZw1WcjCrexRPAL+5bGbF2as2B/cHOK9t3XDA3DWk=;
        fh=+0Kgjkk3V0GUIRANHS4kO50WRmzYdr1bl4rLk3yRjZc=;
        b=ql5potbi0HU8UYxo5AqVffSB4haNTJUvST3H26hwB36JdWUkECyd4d4HjEHDIiNIX5
         Oemn5z3ZJcC4zxJyRc91BHvkP6qieYtA8k2Gk6C3NHduJM7HoIrE1eWLtCApu50Lg5If
         lSVSYo+8ACHogcfI4Hmr3gfAbCY5G92nJe6/bEWZdm7KRfWuoCl8fYNG5rAjxPcXRybJ
         7lYgDzBp0Q/vZerxEDPJKTMtzXhMxRxIyyZRqoJefK4GxROaOjyZCCAjMdftvZbeQbau
         KEe6tBoXIsIPJnkYbqukdDrnAtYonDby6rmhz/6pByVofowGloQN+GFh0CKCpFawIiNJ
         VALQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1782952012; x=1783556812; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvfZw1WcjCrexRPAL+5bGbF2as2B/cHOK9t3XDA3DWk=;
        b=kWc10vqwRTCx7VSVxG2HPexouOK/MRXkPr6bMufad8p7cUV4BvCIXYqigkl79uuViN
         DBnWlc/PdoHfgaiQK0n/ceQ4GL/ubytwATPjlCfvFuZW6YikY1J/H064/5hjxgkxPfwy
         XyhstuZEj5ZKyFWhi+MvVbnqDI5IB+2jVzXnNFovh04LnV50i3vWG3/8lwuuTlY2pqWU
         euZuhyUP2grCccf6ueiBAKmZ62nNLdsPnsZ2PdKs2957kR3jS4d6EyMSr9frua7jrRho
         9WGo/pth4jvD64E8+pyqfz/0K0fG8QvEFTVdKjnxDBXJIQ5yt3HrAZZ1q44slogiJlTW
         B+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782952012; x=1783556812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SvfZw1WcjCrexRPAL+5bGbF2as2B/cHOK9t3XDA3DWk=;
        b=rI3QNfypaSmZ5TrDm1N3pdVWeRz/A4va6zjnB3Ijxghvh7dE8E5Rd1p7YfNM5G9hz/
         c62hqTKUdjtZuluWKkmS+iRqezY7lOVKRTcp8bLC4860De4nNObRY1YiRjx7CIBp/5SS
         NI3dY00cZ1kkzmzKZH/TNaxZLZeuBoCGaT5aVS2hiAV9n7YZLxrNGMcQRo6LuZ9iXNh7
         GggDNq7G8B7PQhXXfIXIELOK9VQhhT8ThhFFU7fvNiYi2uofuww1XjZPEgafCLSb5ULk
         NZG2y6MKSUfTRVPvfHDw4nuGcmsWw0ZNJJM/R3oAFcu/yIeuBgTU9oZ+ftg8AAq7l78A
         tOwg==
X-Gm-Message-State: AOJu0YzUPE+eZ2mKs9koFsrHc4F16NDFxgGOEIy4YmpIow68fUQSe/cH
	2oKVAW88obr+wKjW2YSBPLTJ2Z91MVJUNISIisqbELtKbEQ+pY92yEf/aa70WJEEgk9o+mdhzKn
	PawaZP5GzxFe3eJUmIRrRpo7kN5D/BZ5TQlkPNQkpzQ==
X-Gm-Gg: AfdE7cmGc07n1wOTikhSHzYwXCsLxldQRY/R4P/d8OdfJfbjRtChZpydTurXWB+cSMe
	FGurG0tFCoTyaHu8w6mbOs/8Qp3fs7+GHZqnHYlOqp9hL9kG9RQlD0v2zXL88wLoRX8/eafZIiZ
	+hoFxqcWw3Qq4fY2FnEvT9Z3PitKyHIvvWV/hXC/J5bONSlJq0RSmYtJ7VKNwnVp0mRdkDyh6TO
	HO2Nc0zNG3GvMfG7v8YDUVHjdKBNH77eoOsqdq3oFLN5krL9EgsN1zWuBcqevX+3iron78=
X-Received: by 2002:a05:6512:8382:b0:5ae:b981:3390 with SMTP id
 2adb3069b0e04-5aec67a2b77mr557669e87.13.1782952011221; Wed, 01 Jul 2026
 17:26:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260609002354.1236297.0535ba20b556.dm-era-target-offset-mapping@trailofbits.com>
 <CALjSBEs3y6cug0V0F-foOGy37JaRvDOqLsCT-bJ_LZfmF0AKug@mail.gmail.com>
In-Reply-To: <CALjSBEs3y6cug0V0F-foOGy37JaRvDOqLsCT-bJ_LZfmF0AKug@mail.gmail.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Wed, 1 Jul 2026 20:26:37 -0400
X-Gm-Features: AVVi8Cduju3suCdHk1wauXsLOORK9ZBAXLt6gIHUZlwkRHzJsmVrYClpxaKlX84
Message-ID: <CAE+C+DbijFM7gzuiA2yuoPm6UOQ8XruG0z5JGr11tFWP7-pMjA@mail.gmail.com>
Subject: Re: [PATCH] dm era: include the target offset when mapping writes
To: Ming Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 2:20=E2=80=AFPM Ming Hung Tsai <mtsai@redhat.com> w=
rote:
>
> On Tue, Jun 9, 2026 at 8:36=E2=80=AFAM Samuel Moelius
> <sam.moelius@trailofbits.com> wrote:
> >
> > dm-era tracks writes in target-relative blocks, but the mapping path ca=
n
> > ignore the target offset when translating bios.  Tables with a non-zero
> > start sector can therefore map and account I/O against the wrong origin
> > sectors.
> >
> > The result is inconsistent metadata for devices that are not mapped at
> > sector zero.
> >
> > Apply the target offset consistently when mapping and tracking writes.
> >
> > Assisted-by: Codex:gpt-5.5-cyber-preview
> > Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> > ---
> >  drivers/md/dm-era-target.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> > index 05285c04ff2c..18aed0e2a508 100644
> > --- a/drivers/md/dm-era-target.c
> > +++ b/drivers/md/dm-era-target.c
> > @@ -1229,6 +1229,7 @@ static dm_block_t get_block(struct era *era, stru=
ct bio *bio)
> >  static void remap_to_origin(struct era *era, struct bio *bio)
> >  {
> >         bio_set_dev(bio, era->origin_dev->bdev);
> > +       bio->bi_iter.bi_sector =3D dm_target_offset(era->ti, bio->bi_it=
er.bi_sector);
> >  }
> >
> >  /*
> > @@ -1560,7 +1561,7 @@ static void era_dtr(struct dm_target *ti)
> >  static int era_map(struct dm_target *ti, struct bio *bio)
> >  {
> >         struct era *era =3D ti->private;
> > -       dm_block_t block =3D get_block(era, bio);
> > +       dm_block_t block;
> >
> >         /*
> >          * All bios get remapped to the origin device.  We do this now,=
 but
> > @@ -1568,6 +1569,7 @@ static int era_map(struct dm_target *ti, struct b=
io *bio)
> >          * block is marked in this era.
> >          */
> >         remap_to_origin(era, bio);
> > +       block =3D get_block(era, bio);
> >
> >         /*
> >          * REQ_PREFLUSH bios carry no data, so we're not interested in =
them.
> > --
> > 2.43.0
> >
> >
>
> Thanks for the patch. This is a general bug for any dm-era table with
> a non-zero start sector, causing out-of-bounds memory access to the
> bitset when calling writeset_marked. Here's the reproducer:
>
> ```
> # era metadata
> dmsetup create emeta --table "0 8192 linear /dev/ram0 0"
> dd if=3D/dev/zero of=3D/dev/mapper/emeta bs=3D4k count=3D1
>
> # era origin
> dmsetup create eorig --table "0 8192 linear /dev/ram0 16384"
>
> # create an era device of 64 blocks, plus 2mb (32 blocks) padding at the =
front
> dmsetup create era --table "0 4096 zero
> 4096 8192 era /dev/mapper/emeta /dev/mapper/eorig 128"
>
> # write to the 64th block. it should be the 32nd era data block, but
> being mapped to the 64th era data block (out-of-bounds)
> dd if=3D/dev/zero of=3D/dev/mapper/era bs=3D64K count=3D1 seek=3D64
> ```
>
> KASAN report:
>
> BUG: KASAN: vmalloc-out-of-bounds in era_map+0x263/0x4a0
> Read of size 8 at addr ffffc90000075008 by task dd/86
>
> I'd suggest revising the commit message to emphasize the severity, e.g.,
>
> dm era: fix out-of-bounds memory access for non-zero start sector

I will send a new patch with the subject line you've suggested.
