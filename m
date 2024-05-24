Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D386AD6
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558230; cv=none; b=G50t6oBmwPnS0FK3mhiIu0Kv7fUP1K4DzooRJqp+nM9/tLCSTTITn2SSxa54Bsna2dniD7dlPBAtvV+XtpmNphoB5v6S26mz/UlA9jBShjU4rIbf5+akjWMJiT/MwpFqTOE61t0WWUGeInT5ClEm5Czi+Esd+8YeagYoFYUCRMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558230; c=relaxed/simple;
	bh=KEpw+nUC0h6utBFxG4JKkTyNa4N0nSg4yK83l8a8038=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aL96QXnvWAVrcyLIdsAb8TzKyGbDI6c0FmCV55UIj83FSOiel/pPh0T7aiE9PkESmvyDzlgi6tz14FajPBiiOvqs+DvIxaAGDY1361GqqQjRZFngrsOZIrDNvff5KP4dTxRMKk+frp2p90NS+psCwkcq7+7VJjAZSS8s+qpbEhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WCVZFrEq; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WCVZFrEq"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a59cc765c29so371256166b.3
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 06:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716558225; x=1717163025; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=16b/A2xRDYxumpG25A93qw+dE4Wyu7+C7Z97nAajQdE=;
        b=WCVZFrEqOvfy3ekugaqQ/xjUUt7XzOSzvJSHPWpfd1BKS5TK3k+WjXSZ9/2vaGsnHa
         je7R8rHkvd5Yspo+MnHvZxMB0x4s4FNaaP91ZcqRGZtmg7V9KX5DNEVRibB/LJHqwfuY
         N+xX2ZjoEFTuGaoKE2hpB46T+8I00aGuD5A51+4s7wT4jqA7curu7IG7yN3+uFDrffZ7
         uuYbpHb8nlWqvViTwHE4cvqZmdZ4JHqJkuFnOPUlvvTquL4qq+ckAusgsHGWXBPfTfrt
         WavJCTtyLHxRU2Sy8v2xFmnxxFanqaZrEjxT5qFucFhQsSwt7NuPO0r0PiwhNjARo4rG
         407A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716558225; x=1717163025;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=16b/A2xRDYxumpG25A93qw+dE4Wyu7+C7Z97nAajQdE=;
        b=u6jQv9xvUfMPgql1RHBGfZJ0QLOizoPFPQI0F2fdG65zkQKIU7w+mhyOhZIYIosDUO
         n5JWJ6cQ1ZP6P9bj5Na8fQ82xL7m5v7DMFeUpkRCrUnpc9ccDObzWFl8HhY78dQLMv26
         R4FlRc3BNH4fcf/eQcyIPY1OcHJ4lkfDUmE4M/f+lt7mm/sG8w2+6mhvrySuzVhUZtRk
         M/SMz7HybFwwAidQVN8gIptI0h7TizbslRoh6nIgRfrLWrtmIdvmb4YL3OBkBZ/8lTPU
         V0Lr089nBzYWrhGq3FqkH2uNM+vlZrbA3GZWssiq6g+Q6Xcq3/E6E4+97ZcJZGSuRs8m
         ASXQ==
X-Gm-Message-State: AOJu0YzNy5HCzK6Axk0CjFogF2cNN+STF801MflKnjxvS6098B+8oe0X
	Fbu+P3A2Ulpid7Npn+z2h7o5epp/b51GgnDKlBCCrkBUvS8Sjj2g5YY9s8PoU5c=
X-Google-Smtp-Source: AGHT+IGsYXBrFvJxJUofHkHTG9OxW74j1mGH/cgmus/ch03ziHXb9nXPDS7WCcXN4CXndqtBRGyFjg==
X-Received: by 2002:a17:906:7f15:b0:a62:e9c:f621 with SMTP id a640c23a62f3a-a6265148c46mr165646766b.58.1716558225523;
        Fri, 24 May 2024 06:43:45 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626c8170cbsm134449666b.20.2024.05.24.06.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 06:43:45 -0700 (PDT)
Message-ID: <5e534cd7c8034436819ef451e451fe00549d8a72.camel@suse.com>
Subject: Re: [PATCH 3/7] libmultipath: print all values in snprint_failback
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Nitin Yewale
	 <nyewale@redhat.com>
Date: Fri, 24 May 2024 15:43:44 +0200
In-Reply-To: <20240513173646.94424-4-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
	 <20240513173646.94424-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-05-13 at 13:36 -0400, Benjamin Marzinski wrote:
> Add the missing output for manual failback and print the defferral
> time
> for deferred failbacks, if one isn't currently in progress.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/print.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 89813517..14e7e325 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -218,9 +218,13 @@ snprint_failback (struct strbuf *buff, const
> struct multipath * mpp)
> =C2=A0		return append_strbuf_str(buff, "immediate");
> =C2=A0	if (mpp->pgfailback =3D=3D -FAILBACK_FOLLOWOVER)
> =C2=A0		return append_strbuf_str(buff, "followover");
> +	if (mpp->pgfailback =3D=3D -FAILBACK_MANUAL)
> +		return append_strbuf_str(buff, "manual");
> +	if (mpp->pgfailback =3D=3D FAILBACK_UNDEF)
> +		return append_strbuf_str(buff, "undef");
> =C2=A0
> =C2=A0	if (!mpp->failback_tick)
> -		return append_strbuf_str(buff, "-");
> +		return print_strbuf(buff, "%i", mpp->pgfailback);

Perhaps we should print something like "delayed:%i" here?

Martin



> =C2=A0	else
> =C2=A0		return snprint_progress(buff, mpp->failback_tick,
> =C2=A0					mpp->pgfailback);

