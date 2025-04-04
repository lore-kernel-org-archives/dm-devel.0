Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C827F1BEF87
	for <dm-devel@lists.linux.dev>; Fri,  4 Apr 2025 10:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743764052; cv=none; b=IpZFRq5zBiGlxSe525EuoQwQ0nT9DzkSnaNk89Dk5fOwmINunB8PeD3pr85xNNdsC3nUKE4lfvHLoriIw9W7rZI0n2+PCFX7pKWlkXSlQ4aML9zGOsSmL/JOi3rOCAC1iFStNucgA1FVsTsxKqh6OjK2RFXAsj+nQiKQdeHZ54Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743764052; c=relaxed/simple;
	bh=Mc0t9AqjN3Y4UYK9G7EjnUPm+hcaEuMisIICCVnRtpI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p74IPpFYuMJYV1JyezYfwikD5FEQf8jtsbdy7H0WmhiyWJzQnsXwt9MjRmJkdJFmx3adngF6xTx6D1XT+Md6xPGMc1dPxAhsaWlqqyKkTkNxuwzW/U871kUuMM4E4Jj2mQxquimdrjCFVPZPw7zkfMyguH1BNzBwLPVXJfKoxlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Sc/uFM9V; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Sc/uFM9V"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so19367515e9.3
        for <dm-devel@lists.linux.dev>; Fri, 04 Apr 2025 03:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743764048; x=1744368848; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mc0t9AqjN3Y4UYK9G7EjnUPm+hcaEuMisIICCVnRtpI=;
        b=Sc/uFM9VORoC25Z6LHM/xA38K5EzJBhgHmMJwV2kLBKRrMc0fcdYFajLvIpZopC7xp
         blocMmD94jrINOMSDnvBkMWonpj+Dd0z/CR7PBHeXLZj5RC+UngzN9gS4hOoj4nNTi7V
         GWzriHqRuDVFLo2E2zKMBQlaAFH+4Fm3AMgK2aVf40apYa1jeFra6+8DK35WUpVHzq/G
         3rg/tI5FBNCmKPnahugwcFrJj8JEoHteqtI53eAbvGW+8QdIH5hXwbISIzNh3Sxu8R1s
         xjeuSdrbdychOWmFFRbBpLxSngwXDxlqO+CObXYxmu4LsHzmSDthM/GKgCxA+7sEYVav
         3/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743764048; x=1744368848;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mc0t9AqjN3Y4UYK9G7EjnUPm+hcaEuMisIICCVnRtpI=;
        b=AmOpL1fYPCzO8hnDbF5OJGNKRAKC8Mf186D+vS4UdpsBiwvChcAaEjrdOQpIZketwW
         kh2v8Mr6b6tq+sBjqMWikZJVrqzUhG7i5gp7LE9QeioGW2JGYqRAon4g+ZY1981hwYsE
         f2nc5yd3qNDeIte3iAG1NcDEGO/Xlxmw5yA4lpRhB7FAR6h0pG2IMLzO+b+45YMzL0IJ
         ktisCK1pUu9RUQH+bYDQOzFwuhAw02iYrScrF38Pqr9+c50JcR6SQx88cSFvAdwCvFUh
         sJfX15uWN03QMkB8HBZzGlfd9kBPWBYqMADBWL0nMpCKPqVRiz77ZeKu+OFgLIlxUPH7
         wp/w==
X-Gm-Message-State: AOJu0YzzA2c+Bpovr8VlkreFdC1+N1+lVvR7lOu3+5ini8R+SAzMyylI
	72vd/umV2+he4M14fS9Y8/3KZsoI7IAiMbmxnr9EIJUDUlGVwtBtKR5PInfHiYTpgSm3FzQPctG
	r
X-Gm-Gg: ASbGnctoycQccK2U0KJjeyTPfVez17ODmkP0K1NhbukU/Rdu17seZexxR83vnGboA91
	stR+B8PJBatC4a1o/h9/Pvxt4mFRa3r3+5NbDnfZnbPfq1kmRl+8PhtcGXPnTjCgFfsambPrquK
	RaE6IS5dIq+0tw2RhFC17aikTezvHcRoOKl2Wos+W0ClbZRCbNaVPpJtjsEnXScSsLVDnfb+cTb
	a3k+o27m7ympiyB50laD5w5/0c/gWUNDtARPjZSzHpcl1DUliI0F1FbcyJFeScc78K/qglEJg+p
	tU5h5wWn7mRd0Q40p37XtQGkNJa13BeqeildutVpSXHZrTHYu/F8kcNmtHLaVYWQQJtpBCLKIxB
	/CzGkfIKXT6+WzXmyaoUi9OX+KsDWd2aHVkGyOtmNt9D5qxb237HN+dF7cQiXbS6fb7P7oStngB
	Xbrlw=
X-Google-Smtp-Source: AGHT+IGEfvJ9Rvv2feKYqIUnODkcQzooaLgVJIA1UVVyqgIU48jmDKIkAu6A75rqvUeSQbHGpkFErw==
X-Received: by 2002:a05:600c:4f45:b0:43d:7588:6688 with SMTP id 5b1f17b1804b1-43ed0bc8db0mr22613285e9.12.1743764047894;
        Fri, 04 Apr 2025 03:54:07 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec1663053sm45887625e9.15.2025.04.04.03.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:54:07 -0700 (PDT)
Message-ID: <078a7cf43f2d9b8bf6129ca2e94ba8e4b27496f4.camel@suse.com>
Subject: Re: [PATCH v3 0/4] fix issue of multipathd not tracking device
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 04 Apr 2025 12:54:06 +0200
In-Reply-To: <20250402231322.3044064-1-bmarzins@redhat.com>
References: <20250402231322.3044064-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-04-02 at 19:13 -0400, Benjamin Marzinski wrote:
> I ran into an issue where multipathd wasn't tracking a multipath
> device that was created by the multipath command. It turns out that
> if
> multipathd fully initialized a path device, and that device later
> goes offline and then a multipath device that could use that path is
> created by multipath, multipathd will attempt to reload the device
> to use the offline path, which will fail. This will cause it to not
> track the multipath device at all.
>=20
> The first patch fixes this. The second patch is prep work. The third
> patch allows mutipathd to track these offline paths that should
> belong
> to a device, and add them to device once they come back online. The
> third fourth is just a cleanup.
>=20
> changes from v2
> - 0002: New patch to avoid duplicating the code to determine if we
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 can recheck the paths wwid.
> - 0003: Always recheck WWID when path comes back online if capable
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (suggested by Martin Wilck). F=
ixed holdover code from v1 to
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set pp->initialized =3D INIT_O=
K when the path came back online.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Fixed typo in documentation.
>=20
> changes from v1
> - 0002: Switch from tracking this state with pp->initialized to a new
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 variable, as suggested by Mart=
in Wilck. To make is so that
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 multipathd can still show path=
s in this state without adding
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 a new wildcard for it, add [of=
fline] as a possible output for
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the %m (multipath device) path=
 wildcard, for paths that
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 couldn't be added to a multipa=
th device because they are
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offline. Also constify a funct=
ion parameter and add an
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 explanitory comment as suggest=
ed by Martin.
>=20
> Benjamin Marzinski (4):
> =C2=A0 multipathd: monitor new multipath dev even if we can't update it
> =C2=A0 libmultipath: add helper function check_path_wwid_change
> =C2=A0 multipathd: re-add paths skipped because they were offline
> =C2=A0 multipathd: don't update paths in INIT_MISSING_UDEV
>=20
> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 12 ++++++-
> =C2=A0libmultipath/discovery.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0libmultipath/libmultipath.version |=C2=A0 5 +++
> =C2=A0libmultipath/print.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++-
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +--
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/structs_vec.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 5 +++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 59
> +++++++++++++++++++++++++++++--
> =C2=A0multipathd/multipathd.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 5 +--
> =C2=A09 files changed, 87 insertions(+), 11 deletions(-)

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>


