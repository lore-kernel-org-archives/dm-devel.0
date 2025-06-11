Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D22E227EBE
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 20:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749672751; cv=none; b=iX0EMLJt8Gk6laWZrV53YvnasYt7Kq79Wt29ctgQkRMa4KJRg8H6HGVVU6dCw6swVEeP+3SL5Auip/K+CaDfFdmMedztaN3km5btdr8fdqGmLz1Y3PLIIdIkTsRSP2krj6vnxpZyTWeFK4gvOFgUBwpPn1zosge4vGUCmzWMlUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749672751; c=relaxed/simple;
	bh=lT+bl0iBqRlWAfTnbpCgCNYpZVfLnBUDVCUcBwsP0CU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y77BjdAWqm1VNbPaBpf8E+eFAxGyAHFOFhjvtlQrez+PKe+91YR2CV1X44kfgg5JYd001QHiZe50av9OrL7pZYYx7iGDzZyK7iE5XOIUmLcEkOBUOO3AtgmFH5+E/2bMvnFUS1EIkgMsGWf0CYfr46dj3NyEOdFtvMZz+0vlvPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YZWR3DHJ; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YZWR3DHJ"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a5257748e1so209914f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 13:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1749672747; x=1750277547; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lT+bl0iBqRlWAfTnbpCgCNYpZVfLnBUDVCUcBwsP0CU=;
        b=YZWR3DHJ58p8wkKTe07TfS9w0bgD9Ro3lyogojEpB0CddllgW30eEKS6d8yGMmC6zz
         PiYQhjZlZEsr71r2vlmN+Sl7/LAuVu32ftsmGxSv2XEtABlJdL+r1ryXvvzARro+pLZy
         8FeY6LWhA/kGRpvWBYfRGU+zizoAnharvXmw37olQe+2223wHriMS7Tqp2jkKbmWzA+t
         Rcemee/Hj2Q7X09mCObWM8IUoIqGPIQXfZZjYmYs6SUnt/XkNzlDQsVCplLcJU6mmycv
         dB3QRlCK8qEO+txRd3hxowEGsPBV78MnkEzMM3u/9AQ4slFqZvXZeMAS/h0ApZmofjOy
         r0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749672747; x=1750277547;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lT+bl0iBqRlWAfTnbpCgCNYpZVfLnBUDVCUcBwsP0CU=;
        b=OdhWnxSUReZPaJhNQjVS4kHw9cW2BWMEnsNtnq2KKk0tOaMTkxtdmL0x04DC4Mqqpj
         QEuQ9lN1RzVE+6KGCIsnVyQsulVIrWBip4zwGIVQP+0MXyG8q5B3YV6YuvnyQhGb4ME/
         TgZaMM0ATdWERrVbTMgQ/BviDRs0fEJF+lq3hqaEHpFvl4oZS5lWn5C9FQeJnfxcNVYD
         95tR1ZzU8r0QCPkDQD8+MmHaUB4736TaAdbLK8AHOJA1bndeXpVEddAcRS4z3dJ0oH0i
         TtJlEf0Qj7MWiuriupc/c0JcfpytL42/0Ij42Ef6vh2OTMF78D7fyNjqhAZcsxl7xgw2
         xJzg==
X-Gm-Message-State: AOJu0Yx298RdWdDa4FS6olrxDkwmgJR8I4IER4D0GOJA0G8EKRZk5Co7
	ulOJ/nf80s4R0IeGVdo7kzWkomNFXTf6TJD79siATKdSX55II9koLn/2k2xjHvh4Ag0ZBeeez60
	nAffv
X-Gm-Gg: ASbGnctcZ7lzeKoX8U+7B/vb0j5O2rEYd0kmKmEAfkDNXnTfER08p/5O2ftv1XaHMBa
	g/IxXSJBW9ZkPIxi2brPlwdd0j+nhexF9CMv+SUzQBFbieb3ZCTVfZIeW7H4z4V8zg8mwcyXplI
	0riLqUE/rCxz9VONgbV4nKzS+9/ALD1fh/DUT9KUbL2yKjOCnIbxT8l+Dz+uNAQZFSrvM53TI+g
	yUWC3AlxF1Yxn5Hnu6Rtak4aZuToInXdVcBOKKO8rjwoF+RZCAX8s1rLXaCwkZoptwilMjFdw06
	Xdnmo9D0Z5lDN456WDhupcb0xJCXNnha7CZ/LwEZCOVJpzmbRuwrvaOk5qmWbW5bN0yszsg1Drq
	eAeks8zK0T8qzpLBacaDxFZmsX3Uh6/hhHvYSfxZ3Y3TpgPSI3arHwmzt/hzuaGscw9YgX5fs3P
	VWo29ABjd8NQfiassyd2kF
X-Google-Smtp-Source: AGHT+IHFfJQUR84g6j50FsDiKObvg4AQ/OpFnYO03xRJt9fdHLcO8d07g1VEQlr+IHH+hhVokt8lxQ==
X-Received: by 2002:a05:6000:2289:b0:3a4:f900:21c4 with SMTP id ffacd0b85a97d-3a5613158efmr234482f8f.26.1749672746603;
        Wed, 11 Jun 2025 13:12:26 -0700 (PDT)
Received: from ?IPv6:2003:de:3732:f600:8099:d8a4:e4f5:c830? (p200300de3732f6008099d8a4e4f5c830.dip0.t-ipconnect.de. [2003:de:3732:f600:8099:d8a4:e4f5:c830])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a532468360sm16055552f8f.100.2025.06.11.13.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 13:12:26 -0700 (PDT)
Message-ID: <b32c2ff2aee026821dacd01fd845ecdad662152d.camel@suse.com>
Subject: Re: [PATCH 0/2] libmpathpersist: reserve and release fixes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 11 Jun 2025 22:12:25 +0200
In-Reply-To: <20250604033504.2121566-1-bmarzins@redhat.com>
References: <20250604033504.2121566-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-06-03 at 23:35 -0400, Benjamin Marzinski wrote:
> These are two patches libmpathpersist patches. The first deals with a
> possible race condition where mpath_prout_common() can fail because a
> path went down after libmpathpersist checked its status but before it
> handled the prout command. Previously libmpathpersist wouldn't fail
> without ever trying another path in these cases. The second patch
> keeps libmpathpersit from being able to remove a reservation that
> is held by a different key than the releasing device.=20
>=20
> Benjamin Marzinski (2):
> =C2=A0 libmpathpersist: retry commands on other paths in
> mpath_prout_common
> =C2=A0 libmpathpersist: check released key against the reservation key
>=20
> =C2=A0libmpathpersist/mpath_persist.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +=
++
> =C2=A0libmpathpersist/mpath_persist_int.c | 20 ++++++++++++++++----
> =C2=A0libmpathpersist/mpath_pr_ioctl.c=C2=A0=C2=A0=C2=A0 | 24 +++++++++++=
++-----------
> =C2=A03 files changed, 32 insertions(+), 15 deletions(-)

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>
