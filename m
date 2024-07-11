Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18CF15B145
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 12:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720702571; cv=none; b=YY6pk9uP23ooiKODjqGOBAyf69UeiZXUNLL15eAdLXD0gxznRKUFb2vRq//OGjOAK8VCq2d83geSordhUfEZu9ICUdjrVu6dfkyGCCrTb0m9cX8iJ8x4Ojg7De1Xq8FAAw04V/YpYa6gEYYO57s6rJZ6jBO9bXqXwVUb6Z4Mjw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720702571; c=relaxed/simple;
	bh=2jnyVKDxFCVJelOkN9eo2/to9XEQlWWn7SIuXkqfvdU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WJPFJo8+zfKz4U6Yc0m8KYjHshwemzOL9TMGERFgO+8rMhOcGWPK2fY4QHo6FierlltE332dbxN6Z10NIuLeHT3NhNzMlyavVQCcxvPov3uioxma7CXK/WGeJXBWQ+7ZUEJ0dmUPiV4zljkOcmt8uFRva2HQQRTD6LSL0Dzl1sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GvrOccW7; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GvrOccW7"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42797bcfc77so5720375e9.2
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 05:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720702567; x=1721307367; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TmzlR1O2Z3ZK3f0LLWLE7NN7SvTaPqyF4ZWXop6ZHJU=;
        b=GvrOccW7vJ63lu0w9CpOQP047tCbeIwr0eERBQj3dlIJiwEbBnNxr2LgAqXLkWqXly
         GY/5kvZdY4t5DVuaEZotP3FUkaRt3uRh5HQKvbD0Xn01dXD3tIoET9DeSmdbUwKe+g+9
         ZbhYATQLwIVkvTBhVTy33baEhr+Ic/luqZ4Xv5ZdEXgBA03mFJgolsHdC1yF6SdpUy01
         VoYQA/ArTwcfGz3gTKiBqDArId/XYGj4KxxQCLJxYHExcMRtXnIvzPK/NZP41L5oazP6
         0HPG2xDuc4nUkN3ADQh50h8rzuXtv7w5pOkO3kh3DBbdDC83nPzOOFYTtmo36uSdkTRV
         OT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720702567; x=1721307367;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TmzlR1O2Z3ZK3f0LLWLE7NN7SvTaPqyF4ZWXop6ZHJU=;
        b=adROGsr0Ma1csCtam0jdr7AFMi/Kbxf1DmPmO62KrA0ksf3kYt6V6sbpR9ANUSQahC
         Jyq+QAjnSZ1fQjM9XBUAywxdh1KwpAfGkAg0eOqBc+bmySbPZG+8AR7LHzpQZO9Tx0Vg
         xIPL0n2QyJo1Tiu/v7ENl1kwODOKi6aKG7tzQjRbNFiArcWxqSC5LbguYLNXBrWX/Did
         e+hQFJ0oESM9golCacP9LQkfLPM0IsqZOxPlqilnb9tKTnKMHYsgzj3Uq3brzvBtnOEg
         1il16zCrkTeqVBr4VgGBVHKw14B+C0UFjM1dlELxaWp12cM8OwUgFzP1vooU1qJP/xyi
         dwfg==
X-Forwarded-Encrypted: i=1; AJvYcCWalRkukgVULfnoLfQ7XtWWPp7ECnc6lTy6LgykVdmjYh6qTHwarDdHHKSpRQuMmEBeZIJi8Yj9qH01l+K7JnVslrPxWgoWl5I=
X-Gm-Message-State: AOJu0Yw/TZMxBpRqZCyzoTed8A4OKkraqpgE6Mwum1pHDEOTddRdnJoq
	Wf5C9Wn0a1Ix50KKDE/jQTr3Z/ep6ZdT+EcJ/sJa5skqdm4IaEDoNtukHgGx6wA=
X-Google-Smtp-Source: AGHT+IFleDEKJLCMdBE2AEoSsH9OBOyFU4OstkerKUoOAXoIjocEJTeaqZUE5AQTU4ji68VJEUcafQ==
X-Received: by 2002:a05:600c:63d0:b0:426:6e86:f82 with SMTP id 5b1f17b1804b1-426707e36e6mr59799675e9.22.1720702566731;
        Thu, 11 Jul 2024 05:56:06 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279944120dsm25789855e9.18.2024.07.11.05.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 05:56:06 -0700 (PDT)
Message-ID: <ed5136498c6ac428a5ee25d0c3af712ba57445d2.camel@suse.com>
Subject: Re: [PATCH 31/44] libmultipath: add is_mpath_uuid() helper
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 14:56:05 +0200
In-Reply-To: <Zo9TsqnZ3Zs6XD1w@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-32-mwilck@suse.com> <Zo9TsqnZ3Zs6XD1w@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-10 at 23:38 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:22PM +0200, Martin Wilck wrote:
> > Export it, as it will be used by multipathd and libmpathpersist.
> >=20
>=20
> This is fine. But I was thinking that if you wanted to actually add
> some optional flags to the flags argument of libmp_mapinfo(), this
> would
> be a good use. You could have a flag like DM_MAP_MPATH_WWID, which
> would
> verify that the device had a multipath UUID_PREFIX (and possibly
> force a
> check for a multipath target type) and then return the wwid without
> the
> multipath uuid prefix.
>=20
> Just a thought.

Interesting idea. My thinking was that libmp_mapinfo() should only be
an interface to libdevmapper, and should not interpret the data it
returns in any way.

The only exception is the target type. In theory, the function could
just have returned the target type, and left the interpretation to the
caller. But then, it would have to perform several strdup()s for the
results, and the caller would have to free() the data it wasn't
interested in, which would lead to clumsy and inefficent code in the
frequent case that we're just interested=C2=A0in "multipath" or "linear"
targets. That's why I decided to pass the tgt_type field in, and return
DMP_NO_MATCH if it didn't match, even though it's arguably odd in the
mapinfo_t structure, which is otherwise only used for output fields.

Your flag idea would work, too (an earlier version of this patch set
used flags to indicate which output fields should be filled in; I
discarded that because it was duplicated information, and more elegant
to simply check it the respective output field was non-NULL).

Instead of tgt_type, we could also pass a "filter" callback function
with which the caller could determine whether or not it was interested
in a given map. But I wonder if that'd be over-engineered.

Whatever we eventually do, I think the is_mpath_uuid() helper will be
useful. I am not sure whether we can unexport it even if we implement
more sophisticated "filtering" in libmp_mapinfo().

In general, I wonder what multipath-tools should do if it encounters a
map that has "multipath" target type, but the WWID of which doesn't
conform to the mpath-XYZ convention, or vice versa. This can only
happen if another tool like dmsetup had been used to create the map.
IMO, if multipathd encounters such a situation, it should warn about it
and keep its fingers off the map in question. But we might also play it
simple and just assume that multipath maps always adhere to our
convention. I don't think we currently behave consistently in this
respect.

AFAIU, both the WWID and the target type are immutable and can't be
altered without destroying the map completely (because "multipath" is
an "immutable target" in DM). Thus it should be sufficient to check the
WWID when a map is first encountered.

Thoughts?

Martin

> -Ben
>=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 13 +++++++++----
> > =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> > =C2=A0libmultipath/libmultipath.version |=C2=A0 1 +
> > =C2=A03 files changed, 12 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 806ffb8..5f6c0c8 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -829,6 +829,11 @@ int dm_get_map(const char *name, unsigned long
> > long *size, char **outparams)
> > =C2=A0	}
> > =C2=A0}
> > =C2=A0
> > +bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
> > +{
> > +	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
> > +}
> > +
> > =C2=A0/**
> > =C2=A0 * dm_get_wwid(): return WWID for a multipath map
> > =C2=A0 * @returns:
> > @@ -845,7 +850,7 @@ int dm_get_wwid(const char *name, char *uuid,
> > int uuid_len)
> > =C2=A0	if (rc !=3D DMP_OK)
> > =C2=A0		return rc;
> > =C2=A0
> > -	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
> > +	if (is_mpath_uuid(tmp))
> > =C2=A0		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
> > =C2=A0	else {
> > =C2=A0		uuid[0] =3D '\0';
> > @@ -970,7 +975,7 @@ int dm_is_mpath(const char *name)
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (mapid_t) { .str =3D name=
 },
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (mapinfo_t) { .uuid =3D u=
uid,
> > .tgt_type =3D TGT_MPATH });
> > =C2=A0
> > -	if (rc !=3D DMP_OK || strncmp(uuid, UUID_PREFIX,
> > UUID_PREFIX_LEN))
> > +	if (rc !=3D DMP_OK || !is_mpath_uuid(uuid))
> > =C2=A0		return DM_IS_MPATH_NO;
> > =C2=A0	else
> > =C2=A0		return DM_IS_MPATH_YES;
> > @@ -1065,7 +1070,7 @@ int _dm_flush_map (const char *mapname, int
> > flags, int retries)
> > =C2=A0				=C2=A0 .uuid =3D uuid,
> > =C2=A0				=C2=A0 .tgt_type =3D TGT_MPATH,
> > =C2=A0				=C2=A0 .target =3D &params }) !=3D DMP_OK
> > -	=C2=A0=C2=A0=C2=A0 || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> > +	=C2=A0=C2=A0=C2=A0 || !is_mpath_uuid(uuid))
> > =C2=A0		return DM_FLUSH_OK; /* nothing to do */
> > =C2=A0
> > =C2=A0	/* if the device currently has no partitions, do not
> > @@ -1309,7 +1314,7 @@ struct multipath *dm_get_multipath(const char
> > *name)
> > =C2=A0			=C2=A0 }) !=3D DMP_OK)
> > =C2=A0		return NULL;
> > =C2=A0
> > -	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> > +	if (!is_mpath_uuid(uuid))
> > =C2=A0		return NULL;
> > =C2=A0
> > =C2=A0	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp-
> > >wwid));
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index db5c5fd..a2b2837 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -131,6 +131,8 @@ enum {
> > =C2=A0	DM_IS_MPATH_YES,
> > =C2=A0	DM_IS_MPATH_ERR,
> > =C2=A0};
> > +
> > +bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
> > =C2=A0int dm_is_mpath(const char *name);
> > =C2=A0
> > =C2=A0enum {
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index 7d3ff63..5b8f9e0 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -127,6 +127,7 @@ global:
> > =C2=A0	init_foreign;
> > =C2=A0	init_prio;
> > =C2=A0	io_err_stat_handle_pathfail;
> > +	is_mpath_uuid;
> > =C2=A0	is_path_valid;
> > =C2=A0	libmp_dm_task_create;
> > =C2=A0	libmp_get_version;
> > --=20
> > 2.45.2
>=20

