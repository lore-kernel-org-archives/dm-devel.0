Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FEE4644E
	for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 22:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736893425; cv=none; b=bDMOpoM0BiR57ib1ixJOhl5sI7fNoqIaSj+ningQkxsRwOrEXx1Uh3Wjjc2B1x7iIMm2H9+yQPA12cJKU9RUePtsgxsI6GcIzI7RPFkExDS9BTZ1yUa5h9JIaKmdwtGGJnQ8F4r5jIu98sYG89J3KEdW6+6qKV00x8PU1gQsCr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736893425; c=relaxed/simple;
	bh=NAqKQzoRYr9uWTsfSDflRSE8JjpVQVKg6ZNKn4jLnR0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TMNm6VurfSMGLneQkm4kMq65+Eiz7HdFz4t/A9eZRb9xXzZ/hpzTkAvmQl/Odm2rjMVAzA+wz3m98DRKmV+ZX7wW0ZtfDqjFWBn3BICRbDqX3M4KACiZQ3ozz11gD9Dawa8D8VXyUXzEmZq5bQ8izHvvJ5z6QQU2Qs5bmvEbAYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Zg3xdzbp; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zg3xdzbp"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3cf094768so10443574a12.0
        for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 14:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736893420; x=1737498220; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NAqKQzoRYr9uWTsfSDflRSE8JjpVQVKg6ZNKn4jLnR0=;
        b=Zg3xdzbpRco8ngEU7Op5Ub/onotCuRHZV5n6+DY1M5XX8KBk9Cv73+JaqeZfXByMZL
         vQcg00OhLS/7wNRTFd0QAL2e88MaVr5GYlbYTc+f9gBDrxSratR87RIZT18E34jqw7fP
         QntYPPMc6zR+U2mZqK//cdM0Y0g0Rna7dPtbnbFP6aJ7fOTsyYwCOb53TBewn9RaRgiJ
         hn/yvHlGC3laCqDTMjr/+95hYcsmomJiSCDbNwq9oQ0bwVMmxX0+Wsqj6qmsE4Nd7mC8
         6MmSO4pygFnDsJP818YQfZXiAl0RIvQ/wtRaGPG4Z6QxrYvUuc5x0Ei/X2a6yBrQNVl6
         PzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736893420; x=1737498220;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NAqKQzoRYr9uWTsfSDflRSE8JjpVQVKg6ZNKn4jLnR0=;
        b=RutLzJG2UUwQaEYpC6UukT4Ms28p/4PEunQp6RBowpReyTENyTgpzUpEa/jKNXRTCB
         s+JU4ghgxnaW/hzJOOJFE2GL1t8GCDlMtwRTaibxf65UFlHHrujwhurnRr0gEPWQlTcf
         0HC6yTmaU+JHQunRSdVvP4sEk5LvT/D/XZLU1pjF28xL4A01k4xkVe9BIGMi1XHWVvOU
         mQcMlVMaqtz3dVw9jaFYeXSuWaiAJfQCce1fLjFIOVVE4V4v4zIaRCmieUjXv2eiUWol
         C9lEGlGkiifbthwF8nI297gZJg6DFXJwQZbSHEUQc11R5H2Jsf9B+gomBS0ZiXg2fgqC
         iB9Q==
X-Gm-Message-State: AOJu0YxLqJiAlKwCbMWCqfnYej7qS2zAmub7E3897XkTy/hamGu7Z2pY
	NHgMukWFSL/CVbImDCpNFBvvcXhOST3h+scZiwKuW6gCyQ/q5OaCoxlJowI5e1U=
X-Gm-Gg: ASbGncuCboa2nJxXq9uT3y29yBfK3ls6AmAvpzptdEbIa5rh+2uBNqcORCRJP4s0/V4
	p1tQuxiEpcnu1KM5wQKIPSYMvCRAWuManAuvM9M59l/ii1XxUSZpl4DeIW+uXz98E29wwKfXU29
	a49yBQy5ahrRs7Sm+xTRSt5VAE9CuWn+QkMUonFrINJbDNQjPuyLHOvgDlXVoqR/0DSHGrUu2dO
	3e5UznQNGd2gOwGwFtkHI4du/iot3Trt5QVcJeL1R1IFfHuuC6Lo2JcnyI1vA4c4C9ggJ8l1kL/
	mfy1yDvlbks/B7HsnjTpnjEDYTet4TlyGZqSOsQDIRIzpEK9bzyWYL+c9ufwBLSw+BY+J+gvnDz
	w6CtgjXnTw4mz
X-Google-Smtp-Source: AGHT+IGYv9DdN33IU2Ag5SWwEentf7GS34FU5aJ1Ctwg3OW2e8wuVlmJrKYMV05BULUztReTuPBkYA==
X-Received: by 2002:a05:6402:50d0:b0:5d3:d917:dd90 with SMTP id 4fb4d7f45d1cf-5d972dfb3d9mr26882699a12.6.1736893419949;
        Tue, 14 Jan 2025 14:23:39 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99008c29fsm6547811a12.9.2025.01.14.14.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:23:39 -0800 (PST)
Message-ID: <bcf6b2a386e4e4057b5fedbb2dbca2864d8b9d53.camel@suse.com>
Subject: Re: [PATCH 0/2] multipath: set rport port_state on NVMe FPIN events
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Muneendra Kumar
	 <muneendra.kumar@broadcom.com>
Date: Tue, 14 Jan 2025 23:23:38 +0100
In-Reply-To: <20241220020235.1759375-1-bmarzins@redhat.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-12-19 at 21:02 -0500, Benjamin Marzinski wrote:
> When multipathd handles link integrity FPIN events, it sets the rport
> associated with the effected SCSI paths to Marginal. These patches
> make
> it do the same thing for NVMe paths.
>=20
> I actually have a stupid Fibre Channel question. Does the host number
> and the target wwpn uniquely identfy an rport? I never see the
> channel
> set to anything other than 0, but I don't think that it MUST be 0.

IMO, yes. As the WWPN is unique, it's by itself sufficient to identify
the physical remote port. By adding the host number,
which corresponds to a unique WWPN on the host, you uniquely identify
the Linux fc_remote_port. =20

This also fits the fc symlinks that udev creates under by-path.

> But
> if we knew that there was only one rport for a given host number and
> target WWPN, we could stop checking as soon as we found one. These
> patches don't do that. They check all the rports.

I think we could stop if the WWPN is found.

Martin

>=20
> Benjamin Marzinski (2):
> =C2=A0 libmultipath: export udev pthread cleanup functions
> =C2=A0 multipathd: set rport port_state to marginal for NVMe devices
>=20
> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0libmultipath/discovery.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 2 +
> =C2=A0libmultipath/libmultipath.version |=C2=A0 6 +++
> =C2=A0multipathd/fpin_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 74 ++++++++++++++++++++++++++++-
> --
> =C2=A04 files changed, 78 insertions(+), 8 deletions(-)
>=20

