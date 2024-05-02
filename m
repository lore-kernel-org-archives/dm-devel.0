Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D07158A11
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714662383; cv=none; b=Ot/Icwe24i56j9li8HQJvpJJnMqK93XiwLx3PuHMRGzQpKR/hfvUiCnpFKusitIQGotVr1rt4lj1F63MUJWhWOE7UZVKHW5Ops5RgJGxR0JzhTYo6ZNCyTskEUwCbVucGPkBmRmg/5ZbOKu+3qFzRPEYo4YGA/0a5biXjZImWKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714662383; c=relaxed/simple;
	bh=8sX1p1RaH83w/Tq85w4yhsKzR1hjlMIUrIfLl2GirO0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C/Q6JMRnQWQpO25pD0vBJbHVTxG9V9B4vl3pvDx6BFrSo5KuPmL6RfcXj0NJBMfna0G6YdvTl+CxtPSgm8hr/BnKy3axsNDYoqWyZkJjiwl0P7dBVaT9S8IyfPxcdwY/2nMTZ1rdI/ADMyI2nMXLynZVJzb5p+n0Q3yrgL/gjdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WgR1DcR8; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WgR1DcR8"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a58c89bda70so847351566b.3
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 08:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714662380; x=1715267180; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8sX1p1RaH83w/Tq85w4yhsKzR1hjlMIUrIfLl2GirO0=;
        b=WgR1DcR8kZoX6mArPaGx/PgAKnJXNsKnXcRNySyVIdBJb2J/rHzaRKl3bM2FoNwaXw
         azamCvKwFaP6ipnkkammSfJRj0mgcw4SjcJ9LTWmg0tRLRMYvu+boWLuT1KxgjjjUikN
         3lpuuQ0rxCyeGu/8d0UDnBD0h2DPhzw3sp6/vhnbx8tu7pBHbbA0V4yW7egZkIT52Yeb
         miXl3wn77MjME7QLHIMaKQE9ausFPH0MKOdhfi/6RaNSezQB9DPZ1/Ld7/QZ5ftw/Ayu
         0hduypAbxDdRwY5aersNsH7wwK4WFgAEfH/h22k5/vRdi5WVIJ6s1sdr1YLkgYWIrwU8
         xfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714662380; x=1715267180;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8sX1p1RaH83w/Tq85w4yhsKzR1hjlMIUrIfLl2GirO0=;
        b=NNNTphV/Qr4EqKd0HpxH4BL9dsKObS3PaJuHNAYrZOxtcc6squheDDq0z4K+Mv85lp
         N/hxFvA0cCcOesoJStG3KAki5Q03wGEQNpAXm7V+/AX6oj+qbB8uF2dDsAP0QdXHrInO
         9lilP62TpLrpG/ILXRLcfLDMg5bAQ2+4VrO2vGMSmODG1K3GkYdKe10RuFZR2vI5/GtM
         R/7uCuCWyqOgOOjeM8Mnkj6KFDw4uEBrUaayYzd7ib5w/TENWRgTwUB8g21vouLx1onS
         m/bKWd2lQ3DfsnL/WF1phsixagUMeEm6AUkSYaq7GTJCxRVOQ17Jw9b8sbfD/czj8Qjk
         w7YQ==
X-Gm-Message-State: AOJu0YzM/hOwiTShU/GK1wR1nIXZdH3uuHu9Xpv45C9d8IypuIxnxKNr
	nJi69Te+uss/zXD73spSK0qKDi9pyrGfbA6+DramJT5REiZe7haqDd+lmYh1KQA=
X-Google-Smtp-Source: AGHT+IFQ7Eh/720MVU/aseztC6De/R5NN8n3+RcHIqmGAQ7mSmJjB1VbuOc99+cEdi3yQq9xUNNxuA==
X-Received: by 2002:a17:906:2a05:b0:a52:2e91:321e with SMTP id j5-20020a1709062a0500b00a522e91321emr3821167eje.72.1714662379849;
        Thu, 02 May 2024 08:06:19 -0700 (PDT)
Received: from ?IPv6:2003:de:373e:dc00:b298:a6be:282c:8242? (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with ESMTPSA id c3-20020a170906528300b00a4e5866448bsm644727ejm.155.2024.05.02.08.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 08:06:19 -0700 (PDT)
Message-ID: <57a036f3daaa858c0b32c7c2ee241ba2ede3aab1.camel@suse.com>
Subject: Re: [PATCH 1/3] libmultipath: export partmap_in_use and do_deferred
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 02 May 2024 17:06:18 +0200
In-Reply-To: <20240423222536.2096486-2-bmarzins@redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
	 <20240423222536.2096486-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-04-23 at 18:25 -0400, Benjamin Marzinski wrote:
> A future commit will make use of these functions
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 4 +---
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 3 +++
> =C2=A0libmultipath/libmultipath.version | 1 +
> =C2=A03 files changed, 5 insertions(+), 3 deletions(-)
>=20

Reviewed-by: Martin Wilck <mwilck@suse.com>

