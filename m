Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332601C5F34
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 22:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737669828; cv=none; b=McJrUkzGHW4xfwlyQZRYG9OTYJLU1Hd3Xtzwzj1Y9SGCLZH600rdLeU6Ke+Cd3u2QjjWvoVeYzA7aC3Ci6G50sdvEEe1k+ifpg+GU7P2Tpb/39ryPhiIFxj5PgyKNTZCFJt3Uu2GVuCFNOV4aNiGHchvSxqz5c/PTwdEa8PrfKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737669828; c=relaxed/simple;
	bh=rxDqovmdSmRuECaqV+9OY1Avy3zzTNA+yRy4CphSRMg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xx6lVrKmmsK7rCHqYNacZpCcdE2pjQR98pTA66dti8T5r4QrVB/MVJEtJJdemP1MKmIOb3hCNWqHwt/auDuL8/kIqIPtju0zJEQCahDoewNjTqTGQgn6xst7Rs60JpVc0pIRQhlomhsgmghMUfDj4DLbPaRyrYkh+yX1kDVHJgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VruXxhP7; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VruXxhP7"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3862f32a33eso721840f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 14:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737669823; x=1738274623; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rxDqovmdSmRuECaqV+9OY1Avy3zzTNA+yRy4CphSRMg=;
        b=VruXxhP7WmGpv6YnIyUwSmaS5eRjtW1tZNURoa95fgWwI9TkQFaVE6n081RS01LZt3
         Y/H3sZWVUrYI02hrZMumwYx7CMSLufc/DdpjxAoMt5zCYTDHX56SNW5fDHkt6+sRrwzF
         vy8FXwcstK0D7Lj/fdwMaYp3SzsDevfxHf0e/ipZ28+3knQUwSRWFaJAa4wXfE2NpAXN
         faaHD7bgrMcQdtLkcG73AeyEm+4+arfwVssOARw/rxWtZHIQckALeNHJTBClSuYE1eO8
         UK/zq2cuWo2s3fJQ8Gmfo9PNaXDfv42yOHgymDBGCVvx5+zFc5vsXgd4cCBCMMl8cqQv
         1TUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737669823; x=1738274623;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rxDqovmdSmRuECaqV+9OY1Avy3zzTNA+yRy4CphSRMg=;
        b=WP7KY8KLCfkQZxYbQmJ8yOr3gD4nqtEO7ZPUwgI9LDOkUuPNlJ0sgjUn+8l42odoD8
         +O8JnJRM0BW+W6BOoossjb9RS3h0pS2NC6OLOz8m4WBB9Bl8oBT4MT/RqJ0naz4PK4iJ
         plLkc+JLiL4YfF+077BujfxXcm2v5ceB+Bi1sXnFQ+nPZ6g5HrbInythXuH8y7u+5SXQ
         7ieBM3xD9tzBqGoTIWr6bfaSCP5f/JBgBPtxMd7gC7rz6KRirV0/rc38x8h5UI0pT6Tp
         Ol0VXT5YC5517qnW//VI3RbXefUBvoAiMl3PGX/G0I/TOe7IV4ExYAAjdUl7kLQ0s08T
         hZZA==
X-Gm-Message-State: AOJu0YyoJuwDRsPyhfA8Sp7Uuv9neI//YFShyhFdDI1U0noL/G8TTzQ4
	12eHuQRSJIOuLx7fr7MDu9SZeaSR/3JC2S3Uabo2yi53bMCcTAFcPCT5iC/vkGE=
X-Gm-Gg: ASbGnctzX6dJzE3hUG1dEDxY7OzGwEzAlZribHc5erce7KLxDd5Xipgad00vCp+mPWd
	zkCoQKqhtq6SH7bBpAq7uoj+S2+1sd/FI7UnF3nvs/wRURrA67coNG6DAbdYVwaoFbvnpXFzwBE
	Y2WmIeDaTjM6wxgAx5tJMk7sBrYQTShcAURDYxhFcP8KsajKXI54ijkfuEPPC49VIHarkt1bNpt
	U2jXRhLXTOb4icJdKguDgcUa6CAreqyz64OJFEFvqpeUx6ZiUGMOTA1YyY7iHhXCGiErXRDF8Hn
	kvVIu6Lj7Ix+rIq1k3uBfZbWwkdY1l3M2G+Cg0aLW1UsH4tddaLCw2m5K40jhCxpOzR/Kskorgc
	zpnIXBStL10qAQPBDPYTdL44qgLU2Hi2cbs3e
X-Google-Smtp-Source: AGHT+IEGz8KGv1o6k9S1zZx1Ei+6Qd9RrLyrKYW8yqUvMwoshf6BoNEff8pBew05n6Vuen1AItJWyQ==
X-Received: by 2002:a05:6000:4008:b0:38a:624b:e37b with SMTP id ffacd0b85a97d-38bf57b642dmr24033043f8f.53.1737669823075;
        Thu, 23 Jan 2025 14:03:43 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c4006sm804062f8f.94.2025.01.23.14.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 14:03:42 -0800 (PST)
Message-ID: <a18e29f1c385187a29bea25479412b48b51d832d.camel@suse.com>
Subject: Re: [PATCH 00/13] fix for GitHub issue #108 and misc cleanups
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 23 Jan 2025 23:03:41 +0100
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-01-22 at 22:16 -0500, Benjamin Marzinski wrote:
> This patchset has a couple of different pieces, but that main part
> is fixing the issue where, if a path is added while offline (for
> instance by doing a "multipath reconfigure" while the path is
> offline)
> It won't be able to get the SCSI device serial number (or its ALUA
> target port group). This meant that the GROUP_BY_SERIAL and
> GROUP_BY_TPG path grouping policies would not group the path
> correctly,
> even once it came back online.
>=20
> Patches 1 & 2 are just a fix on top of Martin's recent device
> reloading
> work.
>=20
> Patches 3, 4, & 5 are changes to need_reload. They avoid setting and
> checking it in cases where it won't change how multipathd behaves.
> The side benefit of doing this work is that it's easier to reason
> about
> what setting need_reload can and can't effect. Specifically, it will
> now
> only cause multipathd to fix incorrect device tables while in
> checker_finished().
>=20
> Patches 6 - 11 deal with the serial and tpg_id problem from issue
> #108
>=20
> Patch 12 is shutting up a static analyzer warning that popped up on a
> recent rhel build.
>=20
> Patch 13 is a fix for an issue I ran into while testing this set.
>=20
> Benjamin Marzinski (13):
> =C2=A0 multipathd: use symbolic values for wait_for_udev
> =C2=A0 multipathd: don't reload the map when waiting for udev
> =C2=A0 libmultipath: don't set need_reload in adopt_paths
> =C2=A0 libmultipath: remove need_reload check from select_action
> =C2=A0 libmultipath: drop return value from update_pathvec_from_dm
> =C2=A0 libmultipath: Dont scan pointless sysfs parents
> =C2=A0 libmultipath: move sysfs checks out of scsi_ioctl_pathinfo
> =C2=A0 libmultipath: rename DI_SERIAL to DI_IOCTL
> =C2=A0 libmultipath: retry DI_IOCTL functions if they were skipped
> =C2=A0 libmultipath: set need_reload when pp->serial gets set
> =C2=A0 libmultipath: set need_reload when the tpg_id gets set
> =C2=A0 libmultipath: stop static analyzer complaint in init_foreign
> =C2=A0 libmultipath: be lenient in allowing the alua-based pgpolicies
>=20
> =C2=A0libmultipath/configure.c=C2=A0=C2=A0 |=C2=A0=C2=A0 4 +-
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0 |=C2=A0 22 +++++---
> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0 | 104 ++++++++++++++++--------=
-----------
> --
> =C2=A0libmultipath/discovery.h=C2=A0=C2=A0 |=C2=A0=C2=A0 7 ++-
> =C2=A0libmultipath/foreign.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 6 ++-
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 15 +++++-
> =C2=A0libmultipath/structs_vec.c |=C2=A0 10 ++--
> =C2=A0multipath/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0multipathd/cli_handlers.c=C2=A0 |=C2=A0 16 +++---
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 40 +++++++-------
> =C2=A0tests/test-lib.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 9 +---
> =C2=A012 files changed, 119 insertions(+), 118 deletions(-)
>=20

For the set:
Reviewed-by: Martin Wilck <mwilck@suse.com>

