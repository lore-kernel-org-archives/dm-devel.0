Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1F41A6824
	for <dm-devel@lists.linux.dev>; Sun, 28 Jun 2026 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782659479; cv=pass; b=ly8WoqGSg1XqmFPTNJm1IGqbii7RBABhi3P9q3NWx4JEfvEaSemDTgIDXvTkD/PlqkyLunG9o07qI81jqSMtywDVv0gqhwsm36JIJQWgKDUKoL78ktfj4BNnj+/AJcic/hExxRTAd6lkI4ASaLabqvkR92qm7hBWSPUiVshCs0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782659479; c=relaxed/simple;
	bh=0IV7LSJfosOqXMZJCGZOIxws+EyFqvj4abMrmTC9JFY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2fNGE5l7ccrVtvc0YJsSftEBb9Ong9smeoUq2+c3Y860NpFdrhAs81Dzzh0AFWJYdL6oPtl2+kMLvHaQvWmXDyAjgFICWJy51fTQl69nAK1LKUl2LaOop4KeMmaxTGz7UiCBuEgqQHNRUeTIioDFDIKYR9AhjXjp9bsxEptbOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=KW/v9JOO; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="KW/v9JOO"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb36ed873so467093e87.0
        for <dm-devel@lists.linux.dev>; Sun, 28 Jun 2026 08:11:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782659476; cv=none;
        d=google.com; s=arc-20260327;
        b=LGLvmhGV7K1GxGmq1mxgd1kIqPbQXWueBVx0lj+BO10ggzfVl/O8aO7tsPJpoxpQ3V
         14qTyCOmM3+ygnFr685IE0/8YtfRthiMjNPVNUmPrXCujw8nEsDKO+p84oaA7QcIdl/W
         rLG55BrNQkbkJRLVZMItAIc7RtiZAG/KjI91bylQ7lY31BU86LSQB/4eCUyxoWoesFHR
         klMM5fC777MT4MK6+xfIuV0FwCu5KS6zagydKn/4VxqmcL72MFdts+3GIS/kcdcfo7L+
         p8V5L+398bF6K5DvXsoJrUz9hrhDwlKyDTDna+n97k9kuli9NGKzq+cbKRiHt02BQJBp
         ueNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7cnDcLnb1pEkgauzvXiAxzSnyVZf0BXRh008AuKkl2Q=;
        fh=+0Kgjkk3V0GUIRANHS4kO50WRmzYdr1bl4rLk3yRjZc=;
        b=ZD46Vd/LMYr4547GN9gEJxWK9wJbXWaJE83Tmge0HysAl71Q3ytHQEtMHYK2fk1ry7
         iF5kgYupd8btLxt7dkCGNgqU0jp9mBXJe4TNYY8fSlMEz2zLMKj366sXp2AIBI7AcdHS
         prLI/NfWbxwPLG7ord4i4w39kuKvfKdogEj6cULks8ZS4Qr8Z6BkTbw0RJ9Ar04d4Yui
         5o9tLLQq+/sC6OCSGaxmp5yJHt4Hb2T6fYVyKcHSv7As25zCd/pcuQdm9EEP4jsv+S13
         zMfaN81YFtvUU59SkuLnjeAJIqbEtBWMlvqxJN6MvgxrWWvUUxiaQ86SAHHMjb0LX6MQ
         L8jA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1782659476; x=1783264276; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cnDcLnb1pEkgauzvXiAxzSnyVZf0BXRh008AuKkl2Q=;
        b=KW/v9JOOAzc0CHX1DufQva/jbMv9BeZ3DV9cncRSMkjBiUZXvTj2JRrsaB3yxmxccz
         tGSBQVf4qUy/qgU6VI+W70+mFhsa1ekLpaWEIKIqeJaj6hspIJUOV5RP4i34GqMzRBlo
         SPb/1ZI8t23iS2GllmRTBHiNzVdeN5RwwS9cFljzTIjgJfwC8T6J2QtWNEL8K7NT6J3G
         ocyaMArvkY5ZNvEYQVt8i19jdPNlp8p4yChSSvwZmG2skM4cwQpL8MeT0xpnwBhW4qZY
         07KF9NIn+srhPZ9Y6eqJHzAmKA3f+FyAoJlzRKL1mTj8oq91Po3WZ2unOfKxBlRb7e1o
         HCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782659476; x=1783264276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7cnDcLnb1pEkgauzvXiAxzSnyVZf0BXRh008AuKkl2Q=;
        b=ezjDF7A/gej3lL6l9SiIoSSe7szEZGb7yuXxIfhvR0/2nAnQc48KQg6Dmqe/snTuKP
         CTP5Fv38jPRm0/waw+olXXBkDKxuVlYlobG8SZDr5o1srcK3Ooo3vkeoa0wk5wi7Xd7e
         BLJ6Sw+64sUokjekg5Mp4iX4ZE4zgEHqGGELocHSN/Obg98XH4G1WX6+JH27u99Y1PN6
         dfUz8IlXFDEOFPQBROu4v+3KCmJxzDsLVci2UAvg+m1tfwQ2ELUlhx6tfrf4Y7nwG/x+
         uvyjgwkCuRSH/VT5CR+Usl9FEPKENkdYG1jCKySXkADZXEo5JgYNi2gvjRPsxPip3J9p
         jHWw==
X-Gm-Message-State: AOJu0YwSpupuyJbelN1+zdhk5t1EZ7R0DWrzDgJVMaUrNIRBUIMNN/6A
	BF+9/CqwtYKb/MkpQ+/IxObn3RXk1g8IXR5M+ZUhHhZQQ5Zf9v6nw5kwo9dKRWrK8z66MjDawcc
	OjLx/Dw8KCwS+TODlDQ3Rah//QuxmXIqtywgBTe2dDw==
X-Gm-Gg: AfdE7cl4hRYFqpN5lexGA2yFhgeHs3urZZ8iwoZUGRl4ytF2IhC3lhuwjXr+EU8f+Z1
	59PyLVWH9XGrezMcDTGh9wDgFfL+JdhpprJuby9MiHHKPrb/ypsnIhLKI+jR/+npy2ZNdkxS9TU
	jRSP8D7FrsHZy32r4VtU+0/VIYk5tZiYZ6dspd0GplMKLLcp0T5OGBvbCz9QfiioJQeQTSS/z/C
	tiJ3w0UlnHCPnc9oXYMYWV7PekZZBj8zsHuZxw7BeaMXbBIHGRfTD2iC4MIQR1Z/aaiboY=
X-Received: by 2002:a05:6512:838d:b0:5ae:9c5f:1add with SMTP id
 2adb3069b0e04-5aea1f5f6bfmr2045673e87.27.1782659476007; Sun, 28 Jun 2026
 08:11:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260609001636.1235504.7288d2831f6d.dm-cache-invalidate-cblock-truncation@trailofbits.com>
 <CALjSBEvCkx9xPTOeYOGQs-hdTsMw1vOQ3bX95n9r-ep8tA4BgQ@mail.gmail.com>
In-Reply-To: <CALjSBEvCkx9xPTOeYOGQs-hdTsMw1vOQ3bX95n9r-ep8tA4BgQ@mail.gmail.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Sun, 28 Jun 2026 11:11:04 -0400
X-Gm-Features: AVVi8CdFSZqVTZwu6Gwk3KDJantHPO2j5gPqY8ezV7Jz-OkH-FrWm-xYHS-Tocw
Message-ID: <CAE+C+Db7v=Y0UhZo02MhEnokXfX02rFs=irQWyfaen2oO5zpfA@mail.gmail.com>
Subject: Re: [PATCH] dm cache: reject oversized invalidate_cblocks values
To: Ming Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 7:51=E2=80=AFAM Ming Hung Tsai <mtsai@redhat.com> w=
rote:
>
> On Tue, Jun 9, 2026 at 8:26=E2=80=AFAM Samuel Moelius
> <sam.moelius@trailofbits.com> wrote:
> >
> > invalidate_cblocks parses the cache block number into an unsigned long
> > long, but then stores it in a narrower cblock_t.  Values that do not fi=
t
> > in the target type are silently truncated before the cache block is
> > invalidated.
> >
> > That can make a request for one cache block invalidate a different
> > block.  It also makes the userspace-visible control file accept input
> > that cannot be represented by the mapping it is about to update.
> >
> > Reject cache block numbers that do not round-trip through cblock_t
> > before using them.
> >
> > Assisted-by: Codex:gpt-5.5-cyber-preview
> > Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> > ---
> >  drivers/md/dm-cache-target.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.=
c
> > index 097315a9bf0f..5f1a019a9a8d 100644
> > --- a/drivers/md/dm-cache-target.c
> > +++ b/drivers/md/dm-cache-target.c
> > @@ -3330,6 +3330,9 @@ static int parse_cblock_range(struct cache *cache=
, const char *str,
> >         r =3D sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> >
> >         if (r =3D=3D 2) {
> > +               if (b > U32_MAX || e > U32_MAX)
> > +                       return -EINVAL;
> > +
> >                 result->begin =3D to_cblock(b);
> >                 result->end =3D to_cblock(e);
> >                 return 0;
> > @@ -3341,8 +3344,11 @@ static int parse_cblock_range(struct cache *cach=
e, const char *str,
> >         r =3D sscanf(str, "%llu%c", &b, &dummy);
> >
> >         if (r =3D=3D 1) {
> > +               if (b > U32_MAX || b =3D=3D U32_MAX)
> > +                       return -EINVAL;
> > +
> >                 result->begin =3D to_cblock(b);
> > -               result->end =3D to_cblock(from_cblock(result->begin) + =
1u);
> > +               result->end =3D to_cblock(b + 1);
> >                 return 0;
> >         }
> >
> > --
> > 2.43.0
> >
> >
>
> This patch is a half-measure. sscanf() silently wraps on overflow, so
> values beyond U64_MAX still get wrapped to a u64 value, bypass the
> range check, and invalidate a different block than specified.
>
> Also, in the single-value path, the b =3D=3D U32_MAX check is redundant.
> With the original end calculation, end wraps to 0 via uint32_t
> overflow, and validate_cblock_range() already rejects it since begin
> >=3D end. Neither the extra check nor the new end calculation is needed
> here.
>
> To properly fix truncation, a rework using kstrtoull() is needed.

I will submit a new patch with the subject line "dm cache: parse
invalidate_cblocks with kstrtoull()".

Please consider this patch withdrawn.
