Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11F627EC98
	for <dm-devel@lists.linux.dev>; Fri, 11 Jul 2025 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752243112; cv=none; b=flSHoiiIrYSg+xkzra+vc6aSMtjARHfg4GBXZ1CXRM0O5Q2P2fwLdQKAgA1BMkeCMNO7TiiaOABXooqZnLU/peHNJXAt5YfyhrEfSTCPeyjbp9Tfuec/a0p2FP7T2tlVJVYM4MlO68ijMaGzY8UPCk2R8J19FaaH5LpJNttclg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752243112; c=relaxed/simple;
	bh=quniNVddkBMPfhES2p79gQNhk+aY1OuwyQ5ZiyvHw3Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cAAHccvHDGV6dvwCSnhQWMnkdORI+3FPpOvZpQW+gCSOzPzZKvRIEO6UldYdbr9mXv4aj9sQ0/n63TMvA/lzgmVLEbNUjVim2lKYGM45hvuMwCM70yQ4zy2dnoGg9mFuDtCPzacRh5+1NYXhuuYIhUlrdVRRhZDXqfeQZNDXrqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gSl3vDcG; arc=none smtp.client-ip=209.85.221.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gSl3vDcG"
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-3a57c8e247cso1464327f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 11 Jul 2025 07:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752243108; x=1752847908; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xb+rSHn7GbSAUS2/iE6RSbvptCN1SnNsGmBM8P5BapE=;
        b=gSl3vDcGOSZXHQR0PWF3SMDWqkWVEIcESFsloBsX+SF7E5edTnI0FhNvuDhI9ef43g
         d+8dTnvlzNbfMgAuE+pPLr1feenQYM5bCwYXmy5RWkIMSlyi3s9MWhmJf6tA9ckKqhrG
         3IiHcd2lQnxLoswxBlqsc8GZCksjpP6yADxbNIoSlHcTrfk2Ar9QuGz/4e+flekJ56Or
         8PR5cMlh4bFeRbamEZmIKIhs3NNYk6YicxqHnZyYnPnaqPk4MU8QASWROAodhtsBK27j
         aorb1maOLJrG4s3UFczc8828v7+fRG0neT2hxvlf57t7+Q1rdmJ0RhqmAtz14XBv7F+C
         D+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752243108; x=1752847908;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xb+rSHn7GbSAUS2/iE6RSbvptCN1SnNsGmBM8P5BapE=;
        b=dMi6SiBb0/xXa4a40ewDUluV+9q2eeHcoINpODLimHoeMrraSy5jYkYN/7+E6Ky7BZ
         aSjWzXQgspmi4GjPp1fbuCuf7OiiVwXinPEAjyfyImJ7EKevk1ApDUWcJvkjP1oiPs+t
         xNy6WWmld4lWV4C3PvkIs2tv/SWMcuuSfPM8W+olC3UEKgcCgJsM3dYQBPDbDEWKByVo
         0I8qspNDG1ZoV0tcPm8NI2oXJcvyvbxLaOGBFbVSe3ZwJH4ux6/zWXU5SwMITEIFY+zq
         i5pdJ8DLd6n5COGZ0/nQSG9pUQZvVsO0q1/OvjkUdG5JLfpcrCm8yFM9XDSobM04wl0i
         vz6w==
X-Gm-Message-State: AOJu0Yx1aZ9o/tjosUu0ezwOs2c2bKmnpLIdVg9PPEjmRbaeMvyNmXsL
	WurlOKw9keWii283nbkbD7BRO+Me7DQRrOSiW85n+o2013snb3dj9f4dKTv+T34ZwE4=
X-Gm-Gg: ASbGncuQMnlvwi3RI2avHgtGjWXOXS+Gqrx3P85NPI30hCIB/FI4EmgrX+WwjmlffGd
	g23bEytggnoY/uPUXzhjFzbP0zKy46sMfvipetgNzVMoHBoDvcapaUGQP2ajVdfibkSEYnd5Ped
	cDMX7PJ8ewFjCopKclgvuE51rEiCb3dAynEI+ScFdVXqX/38Blqy9VAaZTPz51ywNG6g4idPpd0
	8ZkimbIApxxr43xUTy4+tzybvlnkv9WRCo/8aA+a1txKhl4Kpo6NKz+T4suT7A1Txzn9InuLbhF
	DCpIyAFkZQ8Y7QD8mZsoEqd5hI1bAjAqE+/y5sFrVzRYVVEhAKIQ5PY+dhOBEarmScTz3fhtv2f
	Epoed6vR71a9rwReRlNMBk4d+X82sriILkF8/zTujAZ84D72ctGdFZpvIJDzFVbA1c0kH29zEUq
	AWdLX30zPoPd1jav4irjnWeHOskul0kXesBtIDJpB6PJSS8n9daV1OBHA+
X-Google-Smtp-Source: AGHT+IGY9iqv8lM6F7zL6u4SS6iQEbBgK6vVOwudlK585TR+zPsT++nZohXrykKwERx0a4sx4YJxQw==
X-Received: by 2002:a05:6000:1a85:b0:3a6:d7e9:4309 with SMTP id ffacd0b85a97d-3b5f2e1b7c9mr2580507f8f.29.1752243108028;
        Fri, 11 Jul 2025 07:11:48 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f07:4200:3210:2a7d:8c76:e57d? (p200300f97f07420032102a7d8c76e57d.dip0.t-ipconnect.de. [2003:f9:7f07:4200:3210:2a7d:8c76:e57d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd1736sm4625608f8f.15.2025.07.11.07.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 07:11:47 -0700 (PDT)
Message-ID: <09e59080ff857ab63d46355e47528ea32253fdf1.camel@suse.com>
Subject: Re: [PATCH 11/15] limpathpersist: Handle changing key corner case
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 11 Jul 2025 16:11:46 +0200
In-Reply-To: <cd323846226f9a1dd053d77e9e8bbe35faee8af4.camel@suse.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
		 <20250710181100.3997759-12-bmarzins@redhat.com>
	 <cd323846226f9a1dd053d77e9e8bbe35faee8af4.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-07-11 at 14:15 +0200, Martin Wilck wrote:
> On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> > When you change the reservation key of a registered multipath
> > device,
> > some of paths might be down or even deleted since you originally
>=20
> [...]
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> This is not a full review, just feedback about a failing CI pipeline.
>=20
> > ---
> > =C2=A0libmpathpersist/mpath_persist_int.c | 124 ++++++++++++++++++++---=
-
> > --
> > --
> > =C2=A01 file changed, 90 insertions(+), 34 deletions(-)
> >=20
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index ad5a4ee7..ca972c2b 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> >=20
> > +void preempt_missing_path(struct multipath *mpp, uint8_t *key,
> > uint8_t *sa_key,
> > +			=C2=A0 int noisy)
> > +{
> > +	uint8_t zero[8] =3D {0};
> > +	struct prin_resp resp =3D {0};
>=20
> gcc 4.8 (Debian Jessie) dislikes this syntax.
>=20
> > mpath_persist_int.c:272:9: error: missing braces around initializer
> > [-Werror=3Dmissing-braces]
>=20
> The same issue appears in patch 7/15 and patch 15/15.
> It seems to be a gcc bug
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D53119).
> So we could use #pragma to silence the warning, but I'd like to avoid
> that, especially because it occurs multiple times.
>=20
> I don't think we should drop Jessie support just yet.
>=20
> This works:
>=20
> 	struct prin_resp resp =3D {{{0}}};

It does, but it causes an error with Jessie's clang compiler (clang
3.5.0).
                                  ^
> mpath_persist_int.c:673:30: error: missing field 'additional_length' init=
ializer [-Werror,-Wmissing-field-initializers]
>         struct prin_resp resp =3D {{{0}}};
=20
Both compilers seem to accept this:

	struct prin_resp resp =3D {{{.prgeneration =3D 0}}};

It's getting so awkward that we might as well just use memset.

Martin


