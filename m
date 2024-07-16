Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01091A00E3
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 15:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145088; cv=none; b=glHpeTjyduJMcnlKvwgfHHWhSaefZ5iyIZi7YTcIteWumrPBA3mKTzQWe+hLZdxqbrn9CP4pF09VpfY+AkVD+xGGe0sewWz4zv/UY8DvjlH5D+XVpFFXVFG5y8ywpGl8JnVb6K7DNez0OSWo4oDNQVLJp83rG8keLo/FRj8W0p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145088; c=relaxed/simple;
	bh=/C65XiZKcdQDgw802vjzRvR/W+1bs2TRTg032cvyJGc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bjzvTsucROI/mdseCUBNz7PJPnPGzsv8m33Jz5yBPfkQTdJ8c2UUumGKppaJInLzPUMxB90edgsWmqSP3nrpLjolPuw5DFPE53ZhEk0G8H2CPjw00FNH+OX9izQov3ggCjf7ss5GXMPCbtihyVnXrp08vmIxfigEfhyDmANPPZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CjaIkPRG; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CjaIkPRG"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52ea79e6979so6491286e87.2
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 08:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721145083; x=1721749883; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yv0vyC2rLJp3Gfd2i8SD34ypPiOrDBOGdULHh0ASc6M=;
        b=CjaIkPRG3rAbfVHLWnVCRESEUwDSRLQ0GYXDGXfbvGpcptXJ7P1DF6VsFKkJbZsHaz
         v4um/g/av0GAb9EJ7765AlGHGN/he+g/KXmd5YK7Dg3pxxE62ngjKBCG97nDmTpG9jIE
         UtfXBe7cA9gOAnytzjGw2TmuU+kK7QLvrpb/tQJGW7L9HZbyiVauPtXSaODMrdyMjQ+a
         1y+92s4FQxevd9Qc4lULUyY31sXpDw5+FjA/drD3A9ZfVwVTEHtz4Q1VkPiYL8v0HmvV
         fVGo57nRItQHIMvtTcBAufZ79BqTSpGklCl80AA3ia008nCLeP7ygApeE5N33kTAduiP
         8zpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721145083; x=1721749883;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yv0vyC2rLJp3Gfd2i8SD34ypPiOrDBOGdULHh0ASc6M=;
        b=bEtNTuI300WmDNhdbAOtvnHsSuT3d+NrP+mpC1fM5KE82KwNNBpPKIQdCMEyewAoAa
         97cC82DVb5srh+Jtv7m30iRWHbupPwnhfc/7an49rE2htRlDgwQSXf0DiDbLA1Gsn+pC
         SQfE21rUah0+9oi8+SycnUHVW6eM0Wlg/7HNJlRwPqkp18I57vQPWE5rLdCEi2ivzZ/r
         gATug+TO0kwIpcbGjU4Mjm1F7I/iXaFaGBX8Ho8QCN4clkULfPqUUEot/s60nyhUGquA
         9iKAJEUNcFVpH+OCa+ilJDN6no0lAlDNYZUj9mWDGrTpHM3FRWzBwJjGrbZWu7vjxFT6
         dP6g==
X-Forwarded-Encrypted: i=1; AJvYcCUGdIT2U1v6yOku78bgu8i68EFTevRo/P3cuMDn/glbW9/xSDHQ1XxWZsoNAQSIekltA/596VG7kXgVg8huI4yYKBirKe3Qa2M=
X-Gm-Message-State: AOJu0YwIOOMleW1GBwtNGp5zx+Zn4AMINStaRbTT/OO7JHLmn7DG7jSX
	W/TLvLu33Z7xEOm8ArOkHYmiNWnidMxCln0uRRnEme2Nn/K9ihXW/4oS80olGzc=
X-Google-Smtp-Source: AGHT+IG/1+dr7BFZcbtDsTKSYF1XPpTlecG8jKOHn/taC4b5AAiAGp5Yz00lvy/hDV/qwKPRVf4MHw==
X-Received: by 2002:a05:6512:3b83:b0:52b:8c88:2d6b with SMTP id 2adb3069b0e04-52edef0fcf3mr1744668e87.11.1721145082415;
        Tue, 16 Jul 2024 08:51:22 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b268a28ddsm5163515a12.71.2024.07.16.08.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 08:51:22 -0700 (PDT)
Message-ID: <46b6209d0d86f545fdc5cf3b4b95efaf7ada591f.camel@suse.com>
Subject: Re: [PATCH v2 19/49] libmultipath: add libmp_mapinfo()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 16 Jul 2024 17:51:21 +0200
In-Reply-To: <ZpWltID7xe-rT5tJ@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
	 <20240712171458.77611-20-mwilck@suse.com> <ZpWltID7xe-rT5tJ@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-07-15 at 18:41 -0400, Benjamin Marzinski wrote:
> On Fri, Jul 12, 2024 at 07:14:27PM +0200, Martin Wilck wrote:
> > libmp_mapinfo() is intended as a generic abstraction for retrieving
> > information from
> > the kernel device-mapper driver. It retrieves the information that
> > the caller
> > needs, with a minimal set of DM ioctls, and never more then 2 ioctl
> > calls.
> >=20
> > libdm's DM_DEVICE_TABLE and DM_DEVICE_STATUS calls map to the
> > kernel's
> > DM_TABLE_STATUS ioctl, with or without the DM_STATUS_TABLE_FLAG
> > set,
> > respectively. DM_TABLE_STATUS always retrieves the basic map status
> > (struct
> > dm_info) and the map UUID and name, too.
> >=20
> > Note: I'd prefer to use an unnamed struct instead of _u in
> > union libmp_map_identifer. But doing using an unnamed struct and
> > and
> > initializing the union like this in a function argument:
> >=20
> > =C2=A0 func((mapid_t) { .major =3D major, .minor =3D minor })
> >=20
> > is not part of C99, and not supported in gcc 4.8, which we still
> > support.
> >=20
> > Likewise, the following syntax for initializing an empty struct:
> >=20
> > =C2=A0 (mapinfo_t) { 0 }
> >=20
> > is not supported on all architectures we support (notably clang 3.5
> > under
> > Debian Jessie).
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 192
> > +++++++++++++++++++++++++++++-
> > =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 70 +++++++++++
> > =C2=A0libmultipath/libmultipath.version |=C2=A0=C2=A0 3 +-
> > =C2=A03 files changed, 263 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 3abdc26..4e6b5b2 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -14,7 +14,6 @@
> > =C2=A0#include <errno.h>
> > =C2=A0#include <syslog.h>
> > =C2=A0#include <sys/sysmacros.h>
> > -#include <linux/dm-ioctl.h>
> > =C2=A0
> > =C2=A0#include "util.h"
> > =C2=A0#include "vector.h"
> > @@ -604,6 +603,197 @@ has_dm_info(const struct multipath *mpp)
> > =C2=A0	return (mpp && mpp->dmi.exists !=3D 0);
> > =C2=A0}
> > =C2=A0
> > +static int libmp_set_map_identifier(int flags, mapid_t id, struct
> > dm_task *dmt)
> > +{
> > +	switch (flags & __DM_MAP_BY_MASK) {
> > +	case DM_MAP_BY_UUID:
> > +		if (!id.str || !(*id.str))
> > +			return 0;
> > +		return dm_task_set_uuid(dmt, id.str);
> > +	case DM_MAP_BY_NAME:
> > +		if (!id.str || !(*id.str))
> > +			return 0;
> > +		return dm_task_set_name(dmt, id.str);
> > +	case DM_MAP_BY_DEV:
> > +		if (!dm_task_set_major(dmt, id._u.major))
> > +			return 0;
> > +		return dm_task_set_minor(dmt, id._u.minor);
> > +	case DM_MAP_BY_DEVT:
> > +		if (!dm_task_set_major(dmt, major(id.devt)))
> > +			return 0;
> > +		return dm_task_set_minor(dmt, minor(id.devt));
> > +	default:
> > +		condlog(0, "%s: invalid by_id", __func__);
> > +		return 0;
> > +	}
> > +}
> > +
> > +static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info,
> > const char *map_id)
> > +{
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > +	struct dm_info dmi;
> > +	int rc, ioctl_nr;
> > +	uint64_t start, length =3D 0;
> > +	char *target_type =3D NULL, *params =3D NULL;
> > +	const char *name =3D NULL, *uuid =3D NULL;
> > +	char __attribute__((cleanup(cleanup_charp))) *tmp_target =3D
> > NULL;
> > +	char __attribute__((cleanup(cleanup_charp))) *tmp_status =3D
> > NULL;
> > +	bool tgt_set =3D false;
> > +
> > +	/*
> > +	 * If both info.target and info.status are set, we need
> > two
> > +	 * ioctls. Call this function recursively.
> > +	 * If successful, tmp_target will be non-NULL.
> > +	 */
> > +	if (info.target && info.status) {
> > +		rc =3D libmp_mapinfo__(flags, id,
> > +				=C2=A0=C2=A0=C2=A0=C2=A0 (mapinfo_t) { .target =3D
> > &tmp_target },
> > +				=C2=A0=C2=A0=C2=A0=C2=A0 map_id);
> > +		if (rc !=3D DMP_OK)
> > +			return rc;
> > +		tgt_set =3D true;
> > +	}
> > +
> > +	/*
> > +	 * The DM_DEVICE_TABLE and DM_DEVICE_STATUS ioctls both
> > fetch the basic
> > +	 * information from DM_DEVICE_INFO, too.
> > +	 * Choose the most lightweight ioctl to fetch all
> > requested info.
> > +	 */
> > +	if (info.target && !info.status)
> > +		ioctl_nr =3D DM_DEVICE_TABLE;
> > +	else if (info.status || info.size || flags &
> > __MAPINFO_TGT_TYPE)
> > +		ioctl_nr =3D DM_DEVICE_STATUS;
> > +	else
> > +		ioctl_nr =3D DM_DEVICE_INFO;
> > +
> > +	if (!(dmt =3D libmp_dm_task_create(ioctl_nr)))
> > +		return DMP_ERR;
> > +
> > +	if (!libmp_set_map_identifier(flags, id, dmt)) {
> > +		condlog(2, "%s: failed to set map identifier to
> > %s", __func__, map_id);
> > +		return DMP_ERR;
> > +	}
> > +
> > +	if (!libmp_dm_task_run(dmt)) {
> > +		dm_log_error(3, ioctl_nr, dmt);
> > +		if (dm_task_get_errno(dmt) =3D=3D ENXIO) {
>=20
> I wonder if we should wrap ibmp_mapinfo in a macro that grabs the
> function name of the calling function and passes it down to
> libmp_mapinfo__() otherwise there will be a lot of messages like this
> or
>=20
> condlog(2, "%s: map %s doesn't exist", __func__, map_id);
>=20
> that use "libmp_mapinfo__" as the function, which isn't super useful.

Right. I think what I'll do is just hardcode "libmp_mapinfo" in these
messages instead of using __func__.

>=20
> > +			condlog(2, "%s: map %s not found",
> > __func__, map_id);
> > +			return DMP_NOT_FOUND;
> > +		} else
> > +			return DMP_ERR;
> > +	}
> > +
> > +	condlog(4, "%s: DM ioctl %d succeeded for %s",
> > +		__func__, ioctl_nr, map_id);
> > +
> > +	if (!dm_task_get_info(dmt, &dmi)) {
> > +		condlog(2, "%s: dm_task_get_info() failed for %s
> > ", __func__, map_id);
> > +		return DMP_ERR;
> > +	} else if(!dmi.exists) {
> > +		condlog(2, "%s: map %s doesn't exist", __func__,
> > map_id);
> > +		return DMP_NOT_FOUND;
> > +	}
> > +
> > +	if (info.target || info.status || info.size || flags &
> > __MAPINFO_TGT_TYPE) {
> > +		if (dm_get_next_target(dmt, NULL, &start, &length,
> > +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &target_type, &params) !=3D
> > NULL) {
> > +			condlog(2, "%s: map %s has multiple
> > targets", __func__, map_id);
> > +			return DMP_NOT_FOUND;
> > +		}
> > +		if (!params) {
> > +			condlog(2, "%s: map %s has no targets",
> > __func__, map_id);
> > +			return DMP_NOT_FOUND;
> > +		}
> > +		if (flags & __MAPINFO_TGT_TYPE) {
> > +			const char *tgt_type =3D flags &
> > MAPINFO_MPATH_ONLY ? TGT_MPATH : TGT_PART;
> > +
> > +			if (strcmp(target_type, tgt_type)) {
> > +				condlog(3, "%s: target type
> > mismatch: \"%s\" !=3D \"%s\"",
> > +					__func__, tgt_type,
> > target_type);
> > +				return DMP_NO_MATCH;
> > +			}
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Check possible error conditions.
> > +	 * If error is returned, don't touch any output
> > parameters.
> > +	 */
> > +	if ((info.name && !(name =3D dm_task_get_name(dmt)))
> > +	=C2=A0=C2=A0=C2=A0 || (info.uuid && !(uuid =3D dm_task_get_uuid(dmt))=
)
> > +	=C2=A0=C2=A0=C2=A0 || (info.status && !(tmp_status =3D strdup(params)=
))
> > +	=C2=A0=C2=A0=C2=A0 || (info.target && !tmp_target && !(tmp_target =3D
> > strdup(params))))
> > +		return DMP_ERR;
> > +
> > +	if (info.name) {
> > +		strlcpy(info.name, name, WWID_SIZE);
> > +		condlog(4, "%s: %s: name: \"%s\"", __func__,
> > map_id, info.name);
> > +	}
> > +	if (info.uuid) {
> > +		strlcpy(info.uuid, uuid, DM_UUID_LEN);
> > +		condlog(4, "%s: %s: uuid: \"%s\"", __func__,
> > map_id, info.uuid);
> > +	}
> > +
> > +	if (info.size) {
> > +		*info.size =3D length;
> > +		condlog(4, "%s: %s: size: %lld", __func__, map_id,
> > *info.size);
> > +	}
> > +
> > +	if (info.dmi) {
> > +		memcpy(info.dmi, &dmi, sizeof(*info.dmi));
> > +		condlog(4, "%s: %s %d:%d, %d targets, %s table,
> > %s, %s, %d opened, %u events",
> > +			__func__, map_id,
> > +			info.dmi->major, info.dmi->minor,
> > +			info.dmi->target_count,
> > +			info.dmi->live_table ? "live" :
> > +				info.dmi->inactive_table ?
> > "inactive" : "no",
> > +			info.dmi->suspended ? "suspended" :
> > "active",
> > +			info.dmi->read_only ? "ro" : "rw",
> > +			info.dmi->open_count,
> > +			info.dmi->event_nr);
> > +	}
> > +
> > +	if (info.target) {
> > +		*info.target =3D steal_ptr(tmp_target);
> > +		if (!tgt_set)
> > +			condlog(4, "%s: %s: target: \"%s\"",
> > __func__, map_id, *info.target);
> > +	}
> > +
> > +	if (info.status) {
> > +		*info.status =3D steal_ptr(tmp_status);
> > +		condlog(4, "%s: %s: status: \"%s\"", __func__,
> > map_id, *info.status);
> > +	}
> > +
> > +	return DMP_OK;
> > +}
> > +
> > +/* Helper: format a string describing the map for log messages */
> > +static const char* libmp_map_identifier(int flags, mapid_t id,
> > char buf[BLK_DEV_SIZE])
> > +{
> > +	switch (flags & __DM_MAP_BY_MASK) {
> > +	case DM_MAP_BY_NAME:
> > +	case DM_MAP_BY_UUID:
> > +		return id.str;
> > +	case DM_MAP_BY_DEV:
> > +		safe_snprintf(buf, BLK_DEV_SIZE, "%d:%d",
> > id._u.major, id._u.minor);
> > +		return buf;
> > +	case DM_MAP_BY_DEVT:
> > +		safe_snprintf(buf, BLK_DEV_SIZE, "%d:%d",
> > major(id.devt), minor(id.devt));
> > +		return buf;
> > +	default:
> > +		safe_snprintf(buf, BLK_DEV_SIZE, "*invalid*");
> > +		return buf;
> > +	}
> > +}
> > +
> > +int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
> > +{
> > +	char idbuf[BLK_DEV_SIZE];
> > +
> > +	return libmp_mapinfo__(flags, id, info,
> > +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libmp_map_identifier(flags, id=
,
> > idbuf));
> > +}
> > +
> > =C2=A0int
> > =C2=A0dm_get_info(const char *name, struct dm_info *info)
> > =C2=A0{
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index 9438c2d..725889b 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -1,5 +1,6 @@
> > =C2=A0#ifndef _DEVMAPPER_H
> > =C2=A0#define _DEVMAPPER_H
> > +#include <linux/dm-ioctl.h>
> > =C2=A0#include "autoconfig.h"
> > =C2=A0#include "structs.h"
> > =C2=A0
> > @@ -31,8 +32,77 @@ enum {
> > =C2=A0	DMP_ERR,
> > =C2=A0	DMP_OK,
> > =C2=A0	DMP_NOT_FOUND,
> > +	DMP_NO_MATCH,
> > =C2=A0};
> > =C2=A0
> > +/**
> > + * enum mapinfo_flags: input flags for libmp_mapinfo()
> > + */
> > +enum __mapinfo_flags {
> > +	/** DM_MAP_BY_NAME: identify map by device-mapper name
> > from @name */
> > +	DM_MAP_BY_NAME=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0,
> > +	/** DM_MAP_BY_UUID: identify map by device-mapper UUID
> > from @uuid */
> > +	DM_MAP_BY_UUID,
> > +	/** DM_MAP_BY_DEV: identify map by major/minor number from
> > @dmi */
> > +	DM_MAP_BY_DEV,
> > +	/** DM_MAP_BY_DEVT: identify map by a dev_t */
> > +	DM_MAP_BY_DEVT,
>=20
> I mentioned tihs before, but the DM_MAP_BY_* identifiers only take up
> 3
> bytes so __DM_MAP_BY_MASK can just be 3 or (1 << 2) - 1, unless you
> are
> reserving space for more identifiers which is fine but probably
> unnecessary, since libmultipath isn't a stable API. Or is there some
> other reason I'm missing.

Is it important that this bit field is "dense"? Indeed I wanted to=20
leave some space, even though your're right that it most probably won't
be necessary. I thought it might be helpful during debugging, for
example.

Perhaps I should have used the entire low byte for the map_by part.
That might even provide optimization opportunities for the compiler.
Unless you object, this is what I'll do.

>=20
> > +	__DM_MAP_BY_MASK=C2=A0=C2=A0=C2=A0 =3D (1 << 3) - 1,
> > +	/* Fail if target type is not multipath */
> > +	MAPINFO_MPATH_ONLY=C2=A0 =3D (1 << 3),
> > +	/* Fail if target type is not "partition" (linear) */
> > +	MAPINFO_PART_ONLY=C2=A0=C2=A0 =3D (1 << 4),
> > +	__MAPINFO_TGT_TYPE=C2=A0 =3D (MAPINFO_MPATH_ONLY |
> > MAPINFO_PART_ONLY),
> > +};
> > +
> > +typedef union libmp_map_identifier {
> > +	const char *str;
> > +	struct {
> > +		int major;
> > +		int minor;
> > +	} _u;
> > +	dev_t devt;
> > +} mapid_t;
> > +
> > +typedef struct libmp_map_info {
> > +	/** @name: name of the map.
> > +	 * If non-NULL, it must point to an array of WWID_SIZE
> > bytes
> > +	 */
> > +	char *name;
> > +	/** @uuid: UUID of the map.
> > +	 * If non-NULL it must point to an array of DM_UUID_LEN
> > bytes
> > +	 */
> > +	char *uuid;
> > +	/** @dmi: Basic info, must point to a valid dm_info buffer
> > if non-NULL */
> > +	struct dm_info *dmi;
> > +	/** @target: target params, *@target will be allocated if
> > @target is non-NULL*/
> > +	char **target;
> > +	/** @size: target size. Will be ignored if @target is NULL
> > */
>=20
> AFAICT this isn't true. You can just request the device size, and
> libmp_mapinfo() will give you the size.

Right.

Thanks
Martin

>=20
> -Ben
>=20
> > +	unsigned long long *size;
> > +	/** @status: target status, *@status will be allocated if
> > @status is non-NULL */
> > +	char **status;
> > +} mapinfo_t;
> > +
> > +/**
> > + * libmp_mapinfo(): obtain information about a map from the kernel
> > + * @param flags: see __mapinfo_flags above.
> > + *=C2=A0=C2=A0=C2=A0=C2=A0 Exactly one of DM_MAP_BY_NAME, DM_MAP_BY_UU=
ID, and
> > DM_MAP_BY_DEV must be set.
> > + * @param id: string or major/minor to identify the map to query
> > + * @param info: output parameters, see above. Non-NULL elements
> > will be filled in.
> > + * @returns:
> > + *=C2=A0=C2=A0=C2=A0=C2=A0 DMP_OK if successful.
> > + *=C2=A0=C2=A0=C2=A0=C2=A0 DMP_NOT_FOUND if the map wasn't found, or h=
as no or
> > multiple targets.
> > + *=C2=A0=C2=A0=C2=A0=C2=A0 DMP_NO_MATCH if the map didn't match @tgt_t=
ype (see above).
> > + *=C2=A0=C2=A0=C2=A0=C2=A0 DMP_ERR if some other error occurred.
> > + *
> > + * This function obtains the requested information for the device-
> > mapper map
> > + * identified by the input parameters.
> > + * Output parameters are only filled in if the return value is
> > DMP_OK.
> > + * For target / status / size information, the=C2=A0 map's table shoul=
d
> > contain
> > + * only one target (usually multipath or linear).
> > + */
> > +int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info);
> > +
> > =C2=A0int dm_prereq(unsigned int *v);
> > =C2=A0void skip_libmp_dm_init(void);
> > =C2=A0void libmp_dm_exit(void);
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index f58cb1d..48c2b67 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> > =C2=A0	put_multipath_config;
> > =C2=A0};
> > =C2=A0
> > -LIBMULTIPATH_24.0.0 {
> > +LIBMULTIPATH_25.0.0 {
> > =C2=A0global:
> > =C2=A0	/* symbols referenced by multipath and multipathd */
> > =C2=A0	add_foreign;
> > @@ -134,6 +134,7 @@ global:
> > =C2=A0	libmp_get_version;
> > =C2=A0	libmp_get_multipath_config;
> > =C2=A0	libmp_dm_task_run;
> > +	libmp_mapinfo;
> > =C2=A0	libmp_put_multipath_config;
> > =C2=A0	libmp_udev_set_sync_support;
> > =C2=A0	libmultipath_exit;
> > --=20
> > 2.45.2
>=20

