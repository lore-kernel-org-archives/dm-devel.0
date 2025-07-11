Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083112BDC31
	for <dm-devel@lists.linux.dev>; Fri, 11 Jul 2025 12:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752236108; cv=none; b=M/6JLslGwRzVkvz8wiLTGJ2McvMWcHWfOnB08EIdsZ3maiWD8kDjVLwoaiYhaqVUi8yF3CYEmpnz3D9Z3OA52C7qhcJw5C7U+LX9ieZBHaG8XQf2DC9Z3hX0BbUV/LUD+UM8bikZYV73AYHUcvmnjlEAuUqGf7o8qNagH2T9HHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752236108; c=relaxed/simple;
	bh=L1pkBcKtETQ0JwHqtDgFkzM3BCigdfP5UU1yfd0fo0o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D/Ldz6y0nD240Js9YZwHICy4guH6KH91Vrq2pi4C9sffik+V4KizFYmsmcvDVGy8/jF+gDxX95f8pOjqEVAMyVGuvM77ylrwZzUzeGOQjSlSu7SKtyGk53md3dzcJ3/BLgoFDLwWTUDtaKhOQKcrXZiLS3PxJbJOPWj458BMD2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AE88PIGr; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AE88PIGr"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-ae223591067so335653666b.3
        for <dm-devel@lists.linux.dev>; Fri, 11 Jul 2025 05:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752236104; x=1752840904; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JHzm25N8LzFCs7gLRYsCqNfAidqHueTcbzdRwFhvVlM=;
        b=AE88PIGrgpK1h18rc1uZbgmlKIgmKSRF269jbG3M6PRIE1+mEbAyDbquhe6QNgfixY
         0dSR+cyznsXLUPjz9h1S7N2i5MPjNdKLp0xPW7pWgjSh0NvsdN+7L5JrPs4dXg2rdkgn
         g9uZuoOWfP/am7qM6OfSPNacQCUqsH7Ha718iXGMniHT8r7MQ+OLvHGSAH3QOfpIw4sf
         EeLbDpmM4ZUMM9qITkH6iE4GrEi9CW2NfoRKHCZ9+OXW3l9gKYRFfGUHTIdo8rkPMgg6
         DMtn5DVlqw4hUxEsu5e4QG9ORtObNbSCzDE1Nl6ItZCFyDkeoFtsRXtteBcJhK7Iigyw
         rDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752236104; x=1752840904;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JHzm25N8LzFCs7gLRYsCqNfAidqHueTcbzdRwFhvVlM=;
        b=tc/CI5RYX21I2rZZP8o7HadGF6OL8WJzDpPh9eKY5YrgnY2nAFSDCc6d86gKNe08xa
         I9ZOMU+VaoHQqHrE/lWc24/44s8ySvhEvtMz6YefFJVOeRKgeOTa7B7HK+T/Yh4gXFdo
         H1JrbAODcSpDY58vuv9yuKeH9W4vIaJqTycPtS7RlRYjrWYxlIqO2zgJtqA4cProM4iA
         j05IPSkLHD6mgBl/jqewlFN4xMPNMpec+BHVZnm+cKzLBTMQpzgsQGfnXeW1Exxhs/zM
         hHrizljGRe9b7WkNgSNmYwxWZcDHqs9cDGlxcttpz7YxxULtjyvbtc9YEztrSLIhfV3X
         pLFQ==
X-Gm-Message-State: AOJu0Ywchgn7AVGDCHTzTTV9fzRUrkOMxoigTabk2KnGDdcdKICxRrIV
	FEIDDRHohOqt0izkx8jHW2mXx8Ftc83x2012JHgNTAXcvfTGw5Ol2s6grcjDbdxcGlY=
X-Gm-Gg: ASbGncvJgCluzv96KbLCBD+s0Ah0DN7wkMjjrOs8JXsVa6CLAGQFRMCB12F8pWj3hxw
	wp4wksOjO82Z9rr4yrWUTHjuIwOsUkZH4+gyNKylkV51phGBqd0jzZnqyDRkaadyQOmscBlVMdS
	nPZAjm3i2ZWwkaF3SNkfzbgr7TChIx8EtpGy4ogRy9Iw0ToffZwe3kIvfwyCk8hEhaMW5t8aQca
	AALBZywE26hZWuVKu77y1awxEeqB4bMVZSwkKQ4HSBWhC44su0TmMJfMXVUlJ7Ekb/hMp6kloU4
	bCz96srCqTX5FrW2fBI8V99Fvx1VfvMQcLoudgOVCqITUJjuv4DO4BLmqGTvn0A4t2oA7ZDMobn
	h4Ay35ccGFkYvRFXqVsOt5u1pkf3oPDwK1lccpEB3qEVnNxIDuwvq3ixY6JsdMfkEX1qVtjUrGn
	v3FCqzMpQ06BYFFpouFBk0M2yxo6wrnxY47pk3nNTuh+DL4gA0Ns+4Vdwi
X-Google-Smtp-Source: AGHT+IH3J/OHsLcaVh0z7K24fqD6oTJGwjl85wTpAOb+c/72Me0faBrbO7hjcqpIEcTuORp9kpBW4w==
X-Received: by 2002:a17:906:dc8a:b0:ade:cdec:7085 with SMTP id a640c23a62f3a-ae6fbeddf55mr332639666b.26.1752236104009;
        Fri, 11 Jul 2025 05:15:04 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f07:4200:3210:2a7d:8c76:e57d? (p200300f97f07420032102a7d8c76e57d.dip0.t-ipconnect.de. [2003:f9:7f07:4200:3210:2a7d:8c76:e57d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7e9235esm293484166b.12.2025.07.11.05.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 05:15:03 -0700 (PDT)
Message-ID: <cd323846226f9a1dd053d77e9e8bbe35faee8af4.camel@suse.com>
Subject: Re: [PATCH 11/15] limpathpersist: Handle changing key corner case
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 11 Jul 2025 14:15:03 +0200
In-Reply-To: <20250710181100.3997759-12-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-12-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> When you change the reservation key of a registered multipath device,
> some of paths might be down or even deleted since you originally

[...]
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This is not a full review, just feedback about a failing CI pipeline.

> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 124 ++++++++++++++++++++-----=
-
> --
> =C2=A01 file changed, 90 insertions(+), 34 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index ad5a4ee7..ca972c2b 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
>=20
> +void preempt_missing_path(struct multipath *mpp, uint8_t *key,
> uint8_t *sa_key,
> +			=C2=A0 int noisy)
> +{
> +	uint8_t zero[8] =3D {0};
> +	struct prin_resp resp =3D {0};

gcc 4.8 (Debian Jessie) dislikes this syntax.

> mpath_persist_int.c:272:9: error: missing braces around initializer [-Wer=
ror=3Dmissing-braces]

The same issue appears in patch 7/15 and patch 15/15.
It seems to be a gcc bug
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D53119).
So we could use #pragma to silence the warning, but I'd like to avoid
that, especially because it occurs multiple times.

I don't think we should drop Jessie support just yet.

This works:

	struct prin_resp resp =3D {{{0}}};

> +	int rq_scope;
> +	unsigned int rq_type;
> +	struct prout_param_descriptor paramp =3D {0};

Likewise, gcc 4.8 warns about this:

> mpath_persist_int.c:275:9: error: missing initializer for field 'sa_key' =
of 'struct prout_param_descriptor' [-Werror=3Dmissing-field-initializers]

It's not easy to find a syntax that this compiler accepts without
warning.=C2=A0{{0}} does _not_ work here.

The following did the trick for me:

	struct prout_param_descriptor paramp =3D {.sa_flags =3D 0};


Regards
Martin
