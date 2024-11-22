Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723DA18A95F
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 22:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732314070; cv=none; b=PQ9eW1aqVcP+zAF88QdfdmosLBfYXy+eHHrak6ds3jdKlRaZg7vtukRoAXShaam2GH6rOnnOH/EU/Ux1OiXyt58Icdssis9pWweyvZfuL6Et1wlUgbYevOKWPcoZlpPS8ngw8OqRhqPQIu+0kCfCyakge08BYr2r4ekG83Lz2PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732314070; c=relaxed/simple;
	bh=pKcDAXgT4qr9qab7igQwtXyMMBlTaDlu9R0JbbTAWm8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DGhPhMwGE4LIpUhQiBQB8dswZuBS45E7u9gsqMxZN/voN6gbvczXhGrig1B8qdKoEHaP4b6fT3W2NkuS0e6rVx0Tj+60v6P4ekB6mkJ122HfVmfxhfbuGRqwiFlQ1sSDpKHq83Bg+vlPw3YFrtLelejF+McoKmwuTLqV9Vlvuoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DvPcTYti; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DvPcTYti"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38246333e12so2405195f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 14:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732314064; x=1732918864; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pKcDAXgT4qr9qab7igQwtXyMMBlTaDlu9R0JbbTAWm8=;
        b=DvPcTYtiwdQE/z2rKE9p+Qry52DikwS+Kt/Cka/Tv4I/j0oRqVyoT+mtyePfcxbLcc
         Ism8XiV8spHLsx+1trjMNM0WJYXyWZZq5ish+45C3SxPiHCfk8ApucyTWkI3Sr4T4IFX
         d5mcOFaFllflVuj2KexLwGquYgzvnMgWR7qr1V62tlTxB9CwZTPUmvUaZzoJoaWx+arW
         EeEm1v8a8s5wusa4GmOGKPz1O2TjMTqL2Dh6sUaTepMkSYDn7dnr6JL4PowSICKmK37e
         U2wSGMpBADns3I0eKSM/2i7w48vJK+3W3azvIZ7dESqFRTQCHFCXaPTDJtujztTOHx1W
         gv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732314064; x=1732918864;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pKcDAXgT4qr9qab7igQwtXyMMBlTaDlu9R0JbbTAWm8=;
        b=UCS9m5cXZsTe8SJloY/hXH+YXwz/SJR6wDD9BGCqrQITGwqbtyjA3EelgzAwMcABhN
         zKwL/PVHH1i2NWdiQekTOPkNoXqIwGkQFgISDFJptFIgtHO4V9CLR601NzX+SBoRcNJ/
         ytgnN8TMGVn3eTKeIyySRoivnqGji/a8DygZNhjU/aRGi7VMWuppoRqinv8ZrKilWnLe
         CQWwXj65ekgmA1spwLAK4XN776W/XKrqYuLeltuIssEzxq7vTZdvjhvOBLknuIYsR1dU
         JgjpnIi4oVQVPLuYCY2GoenrlpMLBALRlxcuBAE7laVSBZJHTtxv+SG4+CI0AUnq+9MR
         qX5A==
X-Gm-Message-State: AOJu0YyPfaBzdedTDofSbcZYwpyT62q04Sk3wJzrAtHvFqDMd6tXor0q
	dATnj8HgJtxfT1OZ3ao+CAcCLa0zU6iXQzyS/W4dyAkZqtmlYJgR0j3HhDyQHx0=
X-Gm-Gg: ASbGncuoAhSTUDZp3pvH4N3KPuuqSIMvjHvbliuuqKxvBmIY8tjvqUhDNjhFxx35ikc
	FOH5nYcYyhpSnYQFVhs8K5XIVCaGnAloLkFhGaMCM0zaIQzW3bcsCVceR8VJOqojyYsLEDAfC/h
	RoM0WS3EjbQs1o68pdsxMR0KfBR9fC8dq6O6Df714WTEsushzf0YSnHH3VZdnOHcdl4Neoh8RSq
	qUL77ZTOweOSL4feQo34ANb9S9cK92QK81eu8ivb5WqK6A4RU0pgn75C97a6YfnuLyUQKABfYhm
	4fHkAV88EldiK8xN7SDTE9Y1GsuhDxKBCWjgU+FAhnzyEnLq6PXQQj7S4vOkO9lB2lo2brigsrz
	5KtM99w==
X-Google-Smtp-Source: AGHT+IGUO3NuHsN9lP0d1t7dvw2f+uWakhJzJkTLh3kcw4W1sv1LUyivuebiOr9KJQ/yA+WEdTEW4w==
X-Received: by 2002:a05:6000:2cf:b0:382:486f:1360 with SMTP id ffacd0b85a97d-38260bc6921mr4332942f8f.44.1732314063491;
        Fri, 22 Nov 2024 14:21:03 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825faf9d97sm3483474f8f.35.2024.11.22.14.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:21:03 -0800 (PST)
Message-ID: <9df2a5a809fa170598508357cbe7e9099fb60566.camel@suse.com>
Subject: Re: [PATCH v2 00/13] multipath-tools: Handle tableless DM devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 22 Nov 2024 23:21:01 +0100
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-22 at 16:11 -0500, Benjamin Marzinski wrote:
> This is another stab at handling tableless multipath devices. The
> first
> two patches are reworkings of two patches from my last patchset based
> on feedback from Martin. The rest are new.
>=20
> libmp_mapinfo now has a new return value, DMP_EMPTY, for devices that
> don't have any table. The creation failure path is fixed to check for
> this value before removing a device after a failed create, instead of
> just removing any existing DM device with the same name.=20
>=20
> libmp_mapinfo now also always fills in info.name, info.uuid and
> info.dmi
> if requested, whenever a device is found, even if it returns
> DMP_NO_MATCH, DMP_EMPTY, or DMP_ERR. dm_find_map_by_wwid() uses this,
> as
> well as MAPINFO_MPATH_ONLY, to only return DM_OK for valid multipath
> devices, but to return the alias of any device that matches the uuid,
> even if it's not a valid multipath device.
>=20
> domap() has been updated to use dm_find_map_by_wwid() to check for
> any
> DM device that matches the WWID of the device to be created. This
> lets
> it handle tableless devices that share the WWID of the device to be
> created but not its alias. Previously, multipath would fail
> attempting
> to create these devices. Now it correctly renames and reloads them
> when
> running multipath, starting or reloading multipathd, or running
> "multipathd add map".
>=20
> Finally, dm_flush_map__() and do_foreach_partmaps() also handle
> tabless
> devices. So multipath -F will remove tabless multipath devices, as
> well
> as tableless partition devices on top of multipath devices (tabless
> or
> not). I cleanup up a number of minor issues while working on this.
>=20
> Changes from v1 (based on discussions with Martin Wilck):
> 0004: Dropped the flag. libmp_mapinfo now always fills in uuid, name,
> and
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dmi if a device was found and they are non=
-NULL.
> 0005: Adapt to the changes in 0004
> 0007-0013: New patches to handle tabless devices in dm_flush_map__()
> and
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_foreach_p=
artmaps(), as well as some minor
> fixes/cleanups I
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 encountered =
along the way.
>=20
> Benjamin Marzinski (12):
> =C2=A0 libmultipath: signal device with no table in libmp_mapinfo
> =C2=A0 libmultipath: fix removing device after failed creation
> =C2=A0 libmultipath: set uuid, name, and dmi if a device is found
> =C2=A0 libmultipath: check table type in dm_find_map_by_wwid
> =C2=A0 libmultipath: handle a create corner case for empty devices
> =C2=A0 libmultipath: handle empty maps in dm_flush_map__
> =C2=A0 libmultipath: factor out code to check if a device is a parition
> =C2=A0 libmultipath: remove recursive calls in partmap_funcs
> =C2=A0 libmultipath: move dm_rename__ before rename_partmap
> =C2=A0 libmultipath: assume device is in use if dm_get_opencount fails
> =C2=A0 libmultipath: accept empty partitions as valid in
> do_foreach_partmaps
> =C2=A0 libmultipath: reduce log level for DMP_NOT_FOUND
>=20
> Martin Wilck (1):
> =C2=A0 multipath-tools tests: fix mapinfo tests
>=20
> =C2=A0libmultipath/configure.c=C2=A0=C2=A0 |=C2=A0 21 +++-
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0 | 212 +++++++++++++++++++++---=
-----------
> --
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0 |=C2=A0 13 ++-
> =C2=A0libmultipath/structs_vec.c |=C2=A0=C2=A0 5 +-
> =C2=A0multipathd/cli_handlers.c=C2=A0 |=C2=A0=C2=A0 8 +-
> =C2=A0tests/mapinfo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 92 ++++++++++++----
> =C2=A06 files changed, 235 insertions(+), 116 deletions(-)
>=20

For the series, except for the small nits I mentioned in previous
posts:

Reviewed-by: Martin Wilck <mwilck@suse.com>

