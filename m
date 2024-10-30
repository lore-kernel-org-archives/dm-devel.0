Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE731CFEA7
	for <dm-devel@lists.linux.dev>; Wed, 30 Oct 2024 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730308219; cv=none; b=FcKIlFexr+vKLhchkXdLQ0OF/gX5oBrgUgsnHvcxTvM4VrcwqBPgLV8ATKvKxM7223JW0tHX0sgR0ijR31pAm69tH2akVeNCB/pnHEyorxAWrV/WC8nV3fziiSsP5sGgPMg8vlClIxyTGpqwKGAwV4enZ4hbq/OQikMCK35EJ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730308219; c=relaxed/simple;
	bh=+4Q4hemRS0ToOC53VZoDmplZqxEbtlcz0xsNgIyzLHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VDlrOncWNUamBpbTafTX/w0+yTtWNTESD/2IVnsIHdgil1/UJ1ZDY+Kheh7j3D4W2VYenmgqun1yajnVX10zQBh9LLsrWOJLFdCuYEyG33od7skWXsz39uVzq321JU1Oh9eSi3jjYJJLT35bO73tcKlehWA8eskEATNIegiH0iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hjxYWaB5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hjxYWaB5"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so15085e9.0
        for <dm-devel@lists.linux.dev>; Wed, 30 Oct 2024 10:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730308215; x=1730913015; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RjXe2VDg+r9zVYiRMdvo19/hgVeIZBaZUrCq0g7UQpQ=;
        b=hjxYWaB5i4ry1IzFQPw8cFVJtN9YcWg90RHvVHyrRN73/bKIPYcZdJU3z5ZlJox+fU
         gDzvs7FxuLV6xNZ/FKxGOOBBYlmgPRUMJAH23WM4YkiXC44jwNSzWsirFBE5bTylnggc
         QmL8P846L70ELCseuWWnbRxvMjrd2CJoXMa6bQwBjDGQbxUllgFHohMCfBtsohhluo3t
         9aQgUFQv4J881v6WhXrHNqX6HTuUBmn143IUgYoQjG1ddqSaMk0FUwTdx8674qamacmk
         7CuibHcJiVZU2ZojQS2V08/IbH1C+qzxnnEUUqjzlHV+ptVzd+87LCzdvfzbyAZiGVEP
         Vytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730308215; x=1730913015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RjXe2VDg+r9zVYiRMdvo19/hgVeIZBaZUrCq0g7UQpQ=;
        b=lyCATHFJlyP0/yMV4FX33IqUI4ZmJ5CA+vCVZW5ZxA8vGLdLK8zOnN0BuxT4nNTMVr
         Fg/jSlb7FxfqBHyC6WjZvPE0Hxy5ko+cOcibITPnjKru/C9NJlsOo7PBPaQ5+ykMgSYC
         GzpAr3ld3BlRSeebpFZaDgF1TAYNZ+nLCosCNalWGncw/fNS11zTXzXNu7MQAGyR7Avx
         Fnkae0RegC6WztZQRGSr795/vkvI2qW6X4NE9wBR63KFE+uhxJYm6/myGhNsfb1ytgSn
         ii3rXe/yEchCLQ5/Kp3F9HINTdNv7a9kTIIHGGTOi0VzJ0TEPP4C1qTjNMNVhlMxXPN2
         Mv9g==
X-Gm-Message-State: AOJu0YwSstMh3AJPG2Wj+wH07SUFfAQ9uLSsygNrJnENXQEIboCgT13Y
	XErPZ9/aIq7JyHPCa2CcHUXMmnzW5gXqRBI97Ln5vRWUICcafRogLM2r33nQTViEm49aNeoGcvO
	jJWwtburyZTHCaK3yz+j/GBN74dY3HsSGP0eX
X-Gm-Gg: ASbGncvRahybWWhBflOHIbzes+qYoo8A1QfSINfcoXZH2iIMPSz+2LTNH33FHV6BRx+
	HKqFWRrmMzF/Wwt+f+KKv+8PdlkYHwI+/iiPaiL44TUKcsQauTok0vNNaCQs=
X-Google-Smtp-Source: AGHT+IE31ypjup31t8Bje/YTdqRgoIstDZrZhC8ySAh9uDrFDDRZSi2u5DW5NP+g+iCOruP5vSaFPJ0NSXA5Jh3tokM=
X-Received: by 2002:a05:600c:c16:b0:42b:a8fc:3937 with SMTP id
 5b1f17b1804b1-431b3cdeb36mr11522565e9.4.1730308215091; Wed, 30 Oct 2024
 10:10:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <5f7c2e37-fd4f-4371-3b0d-633b5a99743a@redhat.com>
In-Reply-To: <5f7c2e37-fd4f-4371-3b0d-633b5a99743a@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 30 Oct 2024 17:09:36 +0000
Message-ID: <CABCJKudysj2zNqftwocvSsCAn+4G5WyiLa5sPkRxfL2+YWwBnA@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: don't crash if panic_on_corruption is not selected
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Will Drewry <wad@chromium.org>, agk@redhat.com, 
	snitzer@kernel.org, Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Tue, Oct 29, 2024 at 11:17=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
> If the user sets panic_on_error and doesn't set panic_on_corruption,
> dm-verity should not panic on data mismatch. But, currently it panics,
> because it treats data mismatch as I/O error.
>
> This commit fixes the logic so that if there is data mismatch and
> panic_on_corruption or restart_on_corruption is not selected, the system
> won't restart or panic.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: f811b83879fb ("dm-verity: introduce the options restart_on_error a=
nd panic_on_error")
>
> ---
>  drivers/md/dm-verity-target.c |    9 ++++++---
>  drivers/md/dm-verity.h        |    1 +
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-verity-target.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-verity-target.c        2024-10-16 16:42:=
46.000000000 +0200
> +++ linux-2.6/drivers/md/dm-verity-target.c     2024-10-16 17:11:13.00000=
0000 +0200
> @@ -356,9 +356,9 @@ static int verity_verify_level(struct dm
>                 else if (verity_handle_err(v,
>                                            DM_VERITY_BLOCK_TYPE_METADATA,
>                                            hash_block)) {
> -                       struct bio *bio =3D
> -                               dm_bio_from_per_bio_data(io,
> -                                                        v->ti->per_io_da=
ta_size);
> +                       struct bio *bio;
> +                       io->had_mismatch =3D true;
> +                       bio =3D dm_bio_from_per_bio_data(io, v->ti->per_i=
o_data_size);
>                         dm_audit_log_bio(DM_MSG_PREFIX, "verify-metadata"=
, bio,
>                                          block, 0);
>                         r =3D -EIO;
> @@ -482,6 +482,7 @@ static int verity_handle_data_hash_misma
>                 return -EIO; /* Error correction failed; Just return erro=
r */
>
>         if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA, blkno)) {
> +               io->had_mismatch =3D true;
>                 dm_audit_log_bio(DM_MSG_PREFIX, "verify-data", bio, blkno=
, 0);
>                 return -EIO;
>         }
> @@ -606,6 +607,7 @@ static void verity_finish_io(struct dm_v
>
>         if (unlikely(status !=3D BLK_STS_OK) &&
>             unlikely(!(bio->bi_opf & REQ_RAHEAD)) &&
> +           !io->had_mismatch &&
>             !verity_is_system_shutting_down()) {
>                 if (v->error_mode =3D=3D DM_VERITY_MODE_PANIC) {
>                         panic("dm-verity device has I/O error");
> @@ -779,6 +781,7 @@ static int verity_map(struct dm_target *
>         io->orig_bi_end_io =3D bio->bi_end_io;
>         io->block =3D bio->bi_iter.bi_sector >> (v->data_dev_block_bits -=
 SECTOR_SHIFT);
>         io->n_blocks =3D bio->bi_iter.bi_size >> v->data_dev_block_bits;
> +       io->had_mismatch =3D false;
>
>         bio->bi_end_io =3D verity_end_io;
>         bio->bi_private =3D io;
> Index: linux-2.6/drivers/md/dm-verity.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-verity.h       2024-10-16 16:41:30.00000=
0000 +0200
> +++ linux-2.6/drivers/md/dm-verity.h    2024-10-16 17:06:37.000000000 +02=
00
> @@ -92,6 +92,7 @@ struct dm_verity_io {
>         sector_t block;
>         unsigned int n_blocks;
>         bool in_bh;
> +       bool had_mismatch;

This looks correct to me, although I assume wanting to panic only on
I/O errors is probably rare.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
