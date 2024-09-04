Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29DDDCD
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725462391; cv=none; b=Pba+wv28bjhnGhrqONdtntaMKH54ReykeDPSPVNwhUsNSLt9py31dv2Jd4jjEKe9eW7xy+Ye58HYZU55diRlSI+V7fY4DRLFWvkm8XLfbEgNC3raAbO6i6eEq7zj/tYyr1b3qdshyInLfDt4f/+GpI8fa8BpOxHna0o74roGjXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725462391; c=relaxed/simple;
	bh=EA0yhw0MTmlHo7WA9FKloHv0Uh0wqeilYYQMqUxFPe0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QLoN2dpRfJVbJwlIy/hzOZthDiJvdNd8G4pT77JqaSh0Bqd8VFjZFCZs7DR3cUlXPh0D27ha1tnos/rM6pQGkz3q/vnDd/oIRM9U0s3QTVarIAsRttxWcKX7FutByRouNQi4jE74gCvU9D2uIgiazFoxmX2Xljp0s43I+vC6rz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CTGf6Unf; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CTGf6Unf"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2f504652853so75257721fa.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 08:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725462387; x=1726067187; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PXoYEMbzo9KXdjM4LExEs6n/qUeFCvAPnHM5AVXfZK0=;
        b=CTGf6UnfDVkJUXJPUjJ0l6SYAlrV1QKGwcdbWwxnwV/+nV/EOYp5Xi52T0sW4GN2yx
         4NXUQDPeB3LQXu9NUfw7jNlf8hBcO2DpQpcMFQlsxM1ccOgPcpt20+oHoq21opcSYkI0
         gP+XjXT06pYVjNXoDa276O93MlEYTJle0DMNDvsD8/xESyMLs2DwVqhZH/bVeCOpvG+V
         rO+niUdiF3CgX8J44oUCKYJEhor/CLKbBPlWVZKL9jhlqzlSuCuG2RgmeRE45YDVJInr
         gerPQbeq2fi14bwr/kxXTyB+nNd4iYdoERv0gQBRwocDid8zGRHUerh1s8HQJPYYmk5H
         UB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725462387; x=1726067187;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PXoYEMbzo9KXdjM4LExEs6n/qUeFCvAPnHM5AVXfZK0=;
        b=FdBsg7KjfNjfaZXcKuuDbmk0tGFk8GB07aQWp1yU65XJijlq6ieegRg2alnOqvygcr
         SfYHeTHS+7yJ/GpLz/Q9o0Ppx/lYYEnHYuYLesvjztLrQKhygy/sSi5qXCSmiAHg65Ny
         4cvBKIx0FHWFpCU/kTyHGvjE6pkh1ieDfyyyGDm1Qmxs1zKmuFKbO10AP5mD+W6Q0AKL
         i+82B4ZsHTiRS5zkWUEdaZqvd7/td/u5aXZhrw0Ijwg4OYNOHR1g3kN3P6hO2YfZYidr
         /uoqeKBZdsEovYQKrkGjo9Y5vWvjJIOMYM1FrECqn86T2J/MuMnDk6ohWbWwgMaQuDCZ
         11ag==
X-Gm-Message-State: AOJu0YzDM4J53ESZMTxvfPv/OeftmqEXibTVOxUgi9l6czoIJU2D4MCS
	nPia+FIqRF6SG+XMX0KWavbL7P2FJ9ks6guIZD3mVpvjg7bVJm08mc133xtiCJFOdXsjPlfCV8v
	B
X-Google-Smtp-Source: AGHT+IFJaA5UHprBO3bwQiso8UQzFCIP6R1VsUsB7JvtHCKZe8hah/P59N0qVRkCn3QhCqgAHChlsQ==
X-Received: by 2002:a05:651c:1507:b0:2f5:104b:f2c with SMTP id 38308e7fff4ca-2f61e0b27f4mr112335721fa.39.1725462385182;
        Wed, 04 Sep 2024 08:06:25 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc697eefsm24430a12.67.2024.09.04.08.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 08:06:24 -0700 (PDT)
Message-ID: <3153bab711698dbe3ca2e1f45d1ad30392d68832.camel@suse.com>
Subject: Re: [PATCH 13/15] multipathd: update priority once after updating
 all paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 17:06:23 +0200
In-Reply-To: <20240828221757.4060548-14-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-14-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> Instead of updating the path priorities and possibly reloading the
> multipath device when each path is updated, wait till all paths
> have been updated, and then go through the multipath devices updating
> the priorities once, reloading if necessary.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/structs.h |=C2=A0=C2=A0 9 +++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 169 +++++++++++++=
+++++++++++++-------------
> --
> =C2=A02 files changed, 118 insertions(+), 60 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2bcc6066..1511f701 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> =C2=A0
> @@ -2859,7 +2898,7 @@ update_paths(struct vectors *vecs, int
> *num_paths_p, time_t start_secs)
> =C2=A0			i--;
> =C2=A0		else {
> =C2=A0			pp->is_checked =3D rc;
> -			if (rc =3D=3D CHECK_PATH_CHECKED)
> +			if (rc =3D=3D CHECK_PATH_CHECKED ||
> CHECK_PATH_NEW_UP)

This causes compilation errors. I suppose you meant (rc =3D=3D
CHECK_PATH_CHECKED || rc =3D=3D CHECK_PATH_NEW_UP)

(fixed this up for now on my "tip" branch).

Martin

