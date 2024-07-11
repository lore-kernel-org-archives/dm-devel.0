Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E42115EFB8
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720711773; cv=none; b=mz9+fXqpnXOv0qxdIwdFUE/C24JJCkxsMP38/LYf2g+kWkczk1aG0Mq98TyapOogPtSS5to6DHZLNScVlkJM+9s8pIUxr+Sxmjyg6o9GqqS5aHQjfRxMyPDG3SxNbbrY3utxfLYSwgIXifJLuPXys41W81odCK8C6lx4uOtEyA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720711773; c=relaxed/simple;
	bh=ynHXvdO/drt5FdRwAkLnyDzv51igILv6Fxa1CSMb2nQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d1yoBZbBKzRljcxkQNubZ8h8wzZR8Dxly8VRIFku62OOQYnjBZgS1VDz2CCIJQoDnHiGnADfM+yh6TSg6sENhLEBmA4c0QCK3uf18I1nv1R59jzgPm/uXJlp5XPmlJApTYZEltnimJb1NpNJiy9YN+3bio5DaFXGqrilCLgiEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BLqtMiRZ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BLqtMiRZ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-426526d30aaso6970055e9.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 08:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720711769; x=1721316569; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xHjbOzU2e1oqspxrjV3xZ+4Cm7BXuYKFUnPGc1365c8=;
        b=BLqtMiRZDqcAnnGzrBVp0q3dZVO4ePOCe4/v/T51LoFNia2qEGN7GZo7RDbSxSyTSx
         9esM1NUPMLk2Xa+zG+ah0bBsvBsw4N1nupgR24wkaC8Bca3qGG1ezt0r2MOxXohVyDL9
         5afaNpM07yJIPSCwFpBQP8U67LUc5gUhEnVPFuZcwTYeIGdvRFVbq0KeTSv9ECusf9he
         IVbOh6s3aUWLqsh7a42nUw5mOvhtjkoLERBwSFeRuCcayEBoAJBwGNKuubdWVPvRwDBt
         sUOox9vP/IbCxtphyLhnRs1bw+Yb8wNVlwLOElyctX6GfkoNKGBXGHmg73JJLuuJ8yI+
         vG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720711769; x=1721316569;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xHjbOzU2e1oqspxrjV3xZ+4Cm7BXuYKFUnPGc1365c8=;
        b=wI63vX5OT4zf4wQGRGuavKDNbPXJxIEAn4xwKym5clFdzX+iUoHKsUD/W+k4I04uRY
         1PIGpT3lE8A+V4hTF8qeJ36jmahGMw46y3zLgHechRvoLYQZnMcu3XBVAMNR56QDHWI4
         pWZO7+GwdGGW7GYV7cWaqeIqPw2hqwc5MpmvYTXS7/PqIUycX0Fkohfb0vL0GpAyVIpW
         1fcXftGG3KhXm7t2rTx4T2fMjGMYGzvAzn+1xw1TvCn7QE4HkQ1eQgwJ+IG0Gqw4Jm8g
         rxiKVfHwsVQ+TjyViIks4aVfSdC0Tbyix6/VuWn7yhn4VW5GJyIV1B8/Hz+GHBTWoA2U
         xCYg==
X-Forwarded-Encrypted: i=1; AJvYcCWjRRJizlEQR5R51Ntcq0F0Fxnnx3w0BLjAhh+NI1mGn1We4yjB41vh+m+dtY3IzYH4RPGoxMJUOlcTOIMPYxyJ1Ca7Z7/+jq4=
X-Gm-Message-State: AOJu0Yz38MEzs/8UPYFCMrm96+1gXr07kcDlL/TNXTKJGvQhvKd/AuxZ
	DTyYZpzppdmusrqPchGtQHKFDIRcisnW3qk5kb4BbyfIcMWjF9ISAks+m4IE+Ow=
X-Google-Smtp-Source: AGHT+IF6evsoKrUayX3zaSIUIHdlBp0KGEjrdf7diM9VD8QhbhvuUeFWyk34uY23wBLdyYDveSYxyw==
X-Received: by 2002:a05:600c:2257:b0:426:67f0:b4fa with SMTP id 5b1f17b1804b1-426707cf189mr53218125e9.1.1720711768670;
        Thu, 11 Jul 2024 08:29:28 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cde848cfsm7974168f8f.37.2024.07.11.08.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 08:29:28 -0700 (PDT)
Message-ID: <edfe7eef97e1aa539c967ce261417dfd778b89ec.camel@suse.com>
Subject: Re: [PATCH 35/44] libmultipath: use libmp_pathinfo() in
 update_multipath_table()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 17:29:27 +0200
In-Reply-To: <Zo9qpc0sry9Td0Jm@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-36-mwilck@suse.com> <Zo9qpc0sry9Td0Jm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-07-11 at 01:16 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:26PM +0200, Martin Wilck wrote:
> > This allows us to remove dm_get_status(), and dm_get_map(), of
> > which
> > update_multipath_table() was the last caller.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0 | 89 -----------------------=
-----------
> > ----
> > =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0 |=C2=A0 2 -
> > =C2=A0libmultipath/structs_vec.c | 22 +++++-----
> > =C2=A03 files changed, 12 insertions(+), 101 deletions(-)
> >=20
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 185c76b..105e838 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -804,45 +804,6 @@ static int dm_get_dm_uuid(const char *mapname,
> > char uuid[DM_UUID_LEN])
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 (mapinfo_t) { .uuid =3D uuid });
> > =C2=A0}
> > =C2=A0
> > -int dm_get_map(const char *name, unsigned long long *size, char
> > **outparams)
> > -{
> > -	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > -	uint64_t start, length;
> > -	char *target_type =3D NULL;
> > -	char *params =3D NULL;
> > -
> > -	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_TABLE)))
> > -		return DMP_ERR;
> > -
> > -	if (!dm_task_set_name(dmt, name))
> > -		return DMP_ERR;
> > -
> > -	errno =3D 0;
> > -	if (!libmp_dm_task_run(dmt)) {
> > -		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> > -		if (dm_task_get_errno(dmt) =3D=3D ENXIO)
> > -			return DMP_NOT_FOUND;
> > -		else
> > -			return DMP_ERR;
> > -	}
> > -
> > -	/* Fetch 1st target */
> > -	if (dm_get_next_target(dmt, NULL, &start, &length,
> > -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &target_type, &params) !=3D NU=
LL ||
> > !params)
> > -		/* more than one target or not found target */
> > -		return DMP_NOT_FOUND;
> > -
> > -	if (size)
> > -		*size =3D length;
> > -
> > -	if (!outparams)
> > -		return DMP_OK;
> > -	else {
> > -		*outparams =3D strdup(params);
> > -		return *outparams ? DMP_OK : DMP_ERR;
> > -	}
> > -}
> > -
> > =C2=A0bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
> > =C2=A0{
> > =C2=A0	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
> > @@ -886,56 +847,6 @@ static bool is_mpath_part_uuid(const char
> > part_uuid[DM_UUID_LEN],
> > =C2=A0	return !strcmp(part_uuid + nc, map_uuid);
> > =C2=A0}
> > =C2=A0
> > -int dm_get_status(const char *name, char **outstatus)
> > -{
> > -	int r =3D DMP_ERR;
> > -	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > -	uint64_t start, length;
> > -	char *target_type =3D NULL;
> > -	char *status =3D NULL;
> > -
> > -	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_STATUS)))
> > -		return r;
> > -
> > -	if (!dm_task_set_name(dmt, name))
> > -		goto out;
> > -
> > -	errno =3D 0;
> > -	if (!libmp_dm_task_run(dmt)) {
> > -		dm_log_error(3, DM_DEVICE_STATUS, dmt);
> > -		if (dm_task_get_errno(dmt) =3D=3D ENXIO)
> > -			r =3D DMP_NOT_FOUND;
> > -		goto out;
> > -	}
> > -
> > -	r =3D DMP_NOT_FOUND;
> > -	/* Fetch 1st target */
> > -	if (dm_get_next_target(dmt, NULL, &start, &length,
> > -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &target_type, &status) !=3D NU=
LL)
> > -		goto out;
> > -
> > -	if (!target_type || strcmp(target_type, TGT_MPATH) !=3D 0)
> > -		goto out;
> > -
> > -	if (!status) {
> > -		condlog(2, "got null status.");
> > -		goto out;
> > -	}
> > -
> > -	if (!outstatus)
> > -		r =3D DMP_OK;
> > -	else {
> > -		*outstatus =3D strdup(status);
> > -		r =3D *outstatus ? DMP_OK : DMP_ERR;
> > -	}
> > -out:
> > -	if (r !=3D DMP_OK)
> > -		condlog(0, "%s: %s: error getting map status
> > string: %d",
> > -			__func__, name, r);
> > -
> > -	return r;
> > -}
> > -
> > =C2=A0int dm_is_mpath(const char *name)
> > =C2=A0{
> > =C2=A0	char uuid[DM_UUID_LEN];
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index ed5e866..cb5151e 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -126,8 +126,6 @@ int dm_simplecmd_noflush (int task, const char
> > *name, uint16_t udev_flags);
> > =C2=A0int dm_addmap_create (struct multipath *mpp, char *params);
> > =C2=A0int dm_addmap_reload (struct multipath *mpp, char *params, int
> > flush);
> > =C2=A0int dm_map_present_by_wwid(const char *uuid);
> > -int dm_get_map(const char *name, unsigned long long *size, char
> > **outparams);
> > -int dm_get_status(const char *name, char **outstatus);
> > =C2=A0
> > =C2=A0enum {
> > =C2=A0	DM_IS_MPATH_NO,
> > diff --git a/libmultipath/structs_vec.c
> > b/libmultipath/structs_vec.c
> > index ccc4efc..770e498 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -484,30 +484,32 @@ int
> > =C2=A0update_multipath_table (struct multipath *mpp, vector pathvec, in=
t
> > flags)
> > =C2=A0{
> > =C2=A0	int r =3D DMP_ERR;
> > -	char *params =3D NULL;
> > +	char __attribute__((cleanup(cleanup_charp))) *params =3D
> > NULL;
> > +	char __attribute__((cleanup(cleanup_charp))) *status =3D
> > NULL;
> > =C2=A0
> > =C2=A0	if (!mpp)
> > =C2=A0		return r;
> > =C2=A0
> > -	r =3D dm_get_map(mpp->alias, &mpp->size, &params);
>=20
> Shouldn't we update mpp->size like we were with dm_get_map()?

Yes. Thanks for catching this.
Although if we do we should probably check whether it changed...

Martin

