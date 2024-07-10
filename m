Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A45D198A28
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 20:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720642513; cv=none; b=nDZkFm8FbEebhJR6Pn/dK6DPfpKuYLOAi4iJOKTnHQ5cc3CwbRDs2PfFtLqzYgpVK8v5iKyJtgz1H3Y5l07grtzyLvydSliMaDXMvap5IvvvDl0v+H5xVvKh+Oa4pzQREQLw0gtjsjeY2330fDrN9GlB8qGCUu0G3aFnuQsq7Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720642513; c=relaxed/simple;
	bh=ayyDEA1Hw9b4d22lkNEjW7hYPl5IecW5pEfc4XOE4q0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KoG2WMCpse63PN/9BG0iHdwgULkpr+V8AteNGRiJlYT9CeoETdFZF/+C0ZXvJllJshBxL73Z7l1qOLztlYWD8GXs3lv33Jo4DiTALDTdyoxBLSbNS5WamLDP9fuw+pdwVg6QocG8qY3ESF2NqMeFebN0miHf3r0pgNjfyUwEJkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T0lGAIj8; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T0lGAIj8"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77d876273dso16633666b.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 13:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720642508; x=1721247308; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ayyDEA1Hw9b4d22lkNEjW7hYPl5IecW5pEfc4XOE4q0=;
        b=T0lGAIj8yq9AZIzmc3cTzUvZ+kALDf9UzGyHB/r5l2ZAQAXf/GvFwmkIlOPWQa0HFU
         LGr8iO9MP0cZQrRfEMtwvmG8D9mdLqcXejPiE/4YAU7Pj/ZJtTwsnHR6y0AxpJVdzrLC
         rHFO523jAe5OUZjwwjRwdmuW/w8LmnY0GJhC+Jvl75N0N/neCgkxnQTUMky3cUW+IhFc
         b+9UT+xTMmwTJ7eH+soWl/yewMuUB79nHWHrlpuS0P8n25nHpLM5RiLajYBRnfO9aC4A
         qOOEqEVF/BCZjWxbKQcaKXFyVZ3fPuDb1YBZBveCfag6XhDl071pdB8hbjuFEtx3SuNa
         d4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720642508; x=1721247308;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ayyDEA1Hw9b4d22lkNEjW7hYPl5IecW5pEfc4XOE4q0=;
        b=GD7Pq4vQW8zd/EC31NDaG5dS1xuetmqct2twz0tsiUMWeJjUUIeyYITs+iVIN65xtl
         oYpAouDRT5FZRWub97sGdCPX0kLmDCPNpkwPEtb5b7EXYbgHsa27J5JRR8/GYB7I1no6
         txfvM9V96IrIqWxA2P8mHn0oQjVEsuRk7rTe+rYblHkQf/LRFYiXlLyax0yHqOabRxyM
         3n3o0udfQGkvbQT/xjfE1DqWQMv+WxqfnMSxGqN+YIrygmUg+WpPbdYgXEx5nEwr8Xf3
         XS4rF8aSNzYX9xHRqVA+loMuvQx168Os3Dpas6gAMZ9VYUGS52BwoTWBxQs/piBBgUrJ
         favQ==
X-Forwarded-Encrypted: i=1; AJvYcCUU0TER8mAI/nw/Q3N7dXKvTHQtJIk49U5sRAXtOfIKYAw3V1ZVcAM5Jzsyvo+9oIxdWbg0UhVlH0CgbswBZhCdmp7R7IgZugo=
X-Gm-Message-State: AOJu0Yzk6x6r9lODOixgnaq/B+1BD1F16Iw4dnvZjVy1f69lPjLpJj2Y
	MC4HKD3uLW8/5vEEpxcFmIYL/cp5AcIjT/Y8pQGr3zbBJxI7secS0EIz0b5Y/GPTAeUe4fj9J6K
	j
X-Google-Smtp-Source: AGHT+IEq2IjuOme+23uAd9Cd+hCPHdrpk6JfXaI1SeavNn7mc0/BMp6PHh2m5FmkjUKZkXL4iKAnDg==
X-Received: by 2002:a05:6402:2790:b0:57d:496:209a with SMTP id 4fb4d7f45d1cf-594bab80aaamr7057392a12.6.1720642507450;
        Wed, 10 Jul 2024 13:15:07 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bbe2cf6bsm2582595a12.34.2024.07.10.13.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 13:15:07 -0700 (PDT)
Message-ID: <2c953b781a31f8a6bbba2957369130c1ba505b93.camel@suse.com>
Subject: Re: [PATCH 06/44] kpartx.rules: use @BINDIR@ to locate kpartx
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Wed, 10 Jul 2024 22:15:06 +0200
In-Reply-To: <Zo63QKdTJPxeBwdo@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-7-mwilck@suse.com> <Zo63QKdTJPxeBwdo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-10 at 12:30 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:38:57PM +0200, Martin Wilck wrote:
> > The path for kpartx should match the installed binary.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0.gitignore=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1 +
> > =C2=A0kpartx/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 4 ++--
> > =C2=A0kpartx/{kpartx.rules =3D> kpartx.rules.in} | 2 +-
> > =C2=A03 files changed, 4 insertions(+), 3 deletions(-)
> > =C2=A0rename kpartx/{kpartx.rules =3D> kpartx.rules.in} (96%)
> >=20
> > diff --git a/.gitignore b/.gitignore
> > index 049ffe8..355ddbb 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -12,6 +12,7 @@ config.mk
> > =C2=A0cscope.files
> > =C2=A0cscope.out
> > =C2=A0kpartx/kpartx
> > +kpartx/kpartx.rules
> > =C2=A0multipath/multipath
> > =C2=A0multipath/multipath.8
> > =C2=A0multipath/multipath.conf.5
> > diff --git a/kpartx/Makefile b/kpartx/Makefile
> > index 7720a74..0d4c798 100644
> > --- a/kpartx/Makefile
> > +++ b/kpartx/Makefile
>=20
> Shouldn't we have
>=20
> all: $(EXEC) kpartx.rules
>=20
> so that kpartx.rules gets create when running "make", like happens in
> the
> other makefiles?
>=20

Good catch, thanks!
Martin

