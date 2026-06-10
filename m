Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581B43148DD
	for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 19:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781118158; cv=pass; b=L/zz8L2OFSgmD/zUrC4ZdUL+r87A29tZD23OFpaiol8ZOOsWhFE1ZVM4AjThxFMkRYVzmu1Bc49UEPf53/hdLHgeTPmKcvDGIPYqGGeomCPWk+BH4EBBkOb1i+KT3JDMewomfDT7sB/j383Ns6T/sJ0pfWAqBYOxsDKHvcQiRhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781118158; c=relaxed/simple;
	bh=C/Fa3SLqsYjf+XEIArqUWESBN+bt3nf0fopshzrO/7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jlF+Qe+87MnpvQwH6hKDIH8cVcayTyic2B3wbZ76xS4jLz8LI5FaFH970vGYLtGZ50aZblx2c/nmNBZZFQR+Qli+/AT/+3+m/r12fLAcfn0zikdKWXUQ+UF3RHywhPZhG+F7o+Hlx/dWAyqSPG4K6GLR4PIFI8wWBU19ISpMwqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=ZJsRDeml; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="ZJsRDeml"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aa7a70c0aaso7231334e87.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 12:02:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781118156; cv=none;
        d=google.com; s=arc-20240605;
        b=TkCt2+eVWUrlOhi+2sDa1X7sbCHRNk0ZAZ/SsiUn66myCah3CqWs2M3sF3NVvlPEJ2
         4mfO4ZxtgQxg5gv/ekxBugO0jUGMYCv53aH3GB4Xih3EzZajNX/ywAYsydtg6RWz727K
         g3Dz3AomGl7NUOpMcgIn4gM6ow+2MeJyV5KRvi4SkfYsPqpQ/EMK8nlI8EUxShB854YO
         ROR6BolWxv/JTGkYaWImXog5hZ7lMBC/Us65QUKyJnuYZgGbKzbwi5wsw9kMXPuSIDoB
         t+jTt3uldVblS/SbUzEKt9BOjahGZZaGh7opShXBUSJw6yRvkF5vqPJ+dAuTGVhzSYrW
         HE9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aUJEKNOVm0IWiS8LEIX5N8TIjDauqTCFtiavIHACgjI=;
        fh=+0Kgjkk3V0GUIRANHS4kO50WRmzYdr1bl4rLk3yRjZc=;
        b=GzR0hxDIkoNI5IWr3y2hYFSFIu/pzr1gwZ29hEdYAi1ucKKocFi/pGDaeB0tM/ltPI
         zaSKATDaodXqceIs06SWH/gI3WHhIpHWK9UlgJpfmo4UM9W0Ko24yVgw8cphaONxBuKH
         KhKo3PMq3XfZ1vq7+94W4Vf3+V3jNBoBs175x6B799Dw926j/IGBkNdK2AXSWwD58dSS
         /GABICdnYvFFQum/cUgsLgGRlWqvAPCCaUqTADs3W1m/8YRSMjmTg3upuM2TX1HssDEX
         Uno2b1q4fYsNh3p1bTPN1QCxBoQLgHe6vxw3+OHGkmdhaqWiiAUcM8Kh09N44GQomb4m
         qvAQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1781118156; x=1781722956; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUJEKNOVm0IWiS8LEIX5N8TIjDauqTCFtiavIHACgjI=;
        b=ZJsRDemlhY4Cjqyt1rrke1njAg6Svzn70lDX1KhHqtp8VIE1xRJu9341NFJia23ZP5
         cG5m9e0ykE0X7r/fJmRbM+Kk0fKYDUVDzMnMgzMH8DkgwPuTcpxiE6dIB2U0pNYAfz+C
         PlOK3C74Puo5dau7KWbWnCVMbvpN+e7GHW6eJMdyQiOKoSvTqR+Yo7HB7jM4r+7Rxu8f
         vKt2ISdL9vtEkRtMscn0FzOLUiNRRl0a0aPlnwwX9ORaTEbzh4ugPpOUvzclH203p7By
         nyenoEfFnZNlOiTKpAcRj7X9f1eRgv1fQtRStF/+NzEPkhoGdwHvjsJeOZBptoeR6bbo
         xndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781118156; x=1781722956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aUJEKNOVm0IWiS8LEIX5N8TIjDauqTCFtiavIHACgjI=;
        b=XkfcmyOPU0XFC1P5AnnXD30wAGK994T4Jl4D8R09qtL6ext03UB03H1z0+seYKqInm
         q1QEfZEWqOb1T8DpihAKdrJshsXAYMaWjcxMTALAW2klgSmjIcHDnF4MN5b11gzRdm06
         zgH3UxUpL+Q5eM2ubfgiyfK6gjiZZK2Gvqh9s1xwS8MFtGH1AoC7y7A4RguboI/OMWXE
         iIhMbutrRHmeYMCaRrPyKVWj69wHB58O5rc5ezDUDl7+fPOhSjUbd4rBmGS/JkEKb5LT
         jnPWRv6FLQn0qJyMQ/sirDoh9bCBZCYDfLsZ+qfCcETrlT7zJOmruJwO3ZPMOZQu01f7
         a84A==
X-Gm-Message-State: AOJu0YyjfQguwOSFIEim2eJrp1QaFj4K9Iv7VQvVJtbQipECgrMo9tdh
	CeXLgu+FHj0DkhuixY5ONSXqFQtRfnKlobuelOimo9JbmZrpv6x5joj5MKqkSqV34hmL60rR0wj
	/Ne6KCbEvjgNkntxnnEN3A7VUMn4jbq0jrl2/5s4uQw==
X-Gm-Gg: Acq92OFiBSeGE4xxCihTrIoiikiL6upMDKqmtsuCK4ho0yhFT05U779Zkq0j6YcVg4O
	XDcSDKrGiUNHjQxELwYJeYPggEQYFnOTAHVackUEdYNXMLuGAzUL2/3fToK7z39evXtVJfwGb9r
	ifheEQrxT68izaGJFCxk3RQZKBBoEt4TURfcA7HRXW8dvrU/38sA8xPx6kpuhICfbALPvRNT/4y
	jjLcWWXSwBEbplbi54fXD4xIZUZwCE/qlrQCEIewiS3dFRDxQLLRUYtBZwoFTLImj7gFLb4fsAC
	VLBNprDGj93N3gRz46RoclNOwaw=
X-Received: by 2002:a05:6512:3f10:b0:5aa:6833:f6c7 with SMTP id
 2adb3069b0e04-5ad27347b3cmr42862e87.3.1781118155616; Wed, 10 Jun 2026
 12:02:35 -0700 (PDT)
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
Date: Wed, 10 Jun 2026 15:02:23 -0400
X-Gm-Features: AVVi8CdySD--SPYVLKXEvmeWg9b4rGAwqzZGJyOKewqYxy5WUYMH35QGsM6tnSU
Message-ID: <CAE+C+DbnhE+VG4X5foUeRBoHy_L9aHV-PDQRjvwhmWUtVzKBiQ@mail.gmail.com>
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

I am getting ready to travel and I will address this when I return in
about two weeks. Thank you for understanding.
