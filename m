Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8BFD51C
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 12:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720701169; cv=none; b=b6+Dx6J1nSGX39FMtp6JRt4A6DIqkK3diGVWrrYMcTMOco9eaBsAYGqFKSj2B0/gpmnbJGXX8EABTTa54lT27OizVgVAEyNwDoptalFK7vD7UiuFXKUoihFR2x9pa8oDL3WOk1KHzVdHbATmK8OZdFwv6+ZJzdYfer584bz9XB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720701169; c=relaxed/simple;
	bh=gqVjUL28pmrJzLykFX2m4Kwjlfleh3MpLTW+kcfi6Q4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A78i48P0CTvxc1WMNidLw8eRCN9/3XysQdmi3nRfNOFucffwSI2aV46LQZ5CVeO51rKADc+aeHOrxVIv4tWNLupugaA3i5DklVMu1w6CJCcsNM7u/f8iSsXO1ehXGOuss+agVd1z0oruAnhOlBFtqYmY3lB612V69qilt2j8uQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q+nOvF9I; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q+nOvF9I"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-367940c57ddso449539f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 05:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720701165; x=1721305965; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=voL+jZ69b5Ty3MytXNCJmzdK65MRsNhydQxzIrM8yEc=;
        b=Q+nOvF9Ibn4X1KNKeaMs8AAd5SbXItUo7eD0UBBNEEt4WnJgj8uZ9FVA5ZqrEY9Y1D
         BFQjwts0iyLsazfBIZ18ihpXBN2pcEC9QZtgVZeR/J35kh5U5fcqmO4bplEYwYK6hJuB
         FoRwDdjEzsqd7eJhgKYrziEQrAcuA3Xb8e4NnXR+2U51ywBnZGLQbqMWn5Qzn6+zTqzX
         ecSornepv5VMob7P8qSmZrN0Gh1cFGn/uzRcO760PgH/zOiGosw/qOqkQRmC2xdyGRHk
         EUZrVSQHgclpYLpMG+NyonzHtVNXtgBW2PQVjQYrDzZlbbriPx6pGG4rl7clVEgdBMpx
         cjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720701165; x=1721305965;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=voL+jZ69b5Ty3MytXNCJmzdK65MRsNhydQxzIrM8yEc=;
        b=gemSKj2rhszGFnV+9HDbyiRY9Y1mZ0Ix8fTDNH/OTzwZIrQCvuvd910Z2v7rl2Th4G
         ncZLcQZaD4Cc4eT9xX4Jz0TytrSqoPy9UmeS3H2tsim/0X27knyMgEIbJ3ze8nqFATzY
         uXrQ8WEHNF7pw0poHiNpNw+huSO/eRIf0Q1H3DjTLkxwmpjxjsNeVT95xcEt+bgo4qz5
         EI9Xp4noWJePQA97gDikQ0UU1xU9uDOCbjxuWtx183svoz/hABIkaHAJjXj5uhVi9I/+
         VJyjomHX6CbO6azzZtREBkr2xRcnYfVHmwYMoA7WQa71kI2zHwnc3L83iw2ltruYQxqW
         8CYw==
X-Forwarded-Encrypted: i=1; AJvYcCVv0ULpaJCI/lawzJPu1t/p2Eb3YxQUxRDCldRvboBswsWi5y5uWKTV7OyRvlDdfSMP8Dr9ceZVfpyCYrfX1U98uHfN+gT95Wc=
X-Gm-Message-State: AOJu0Yy3pMdMF+YQayvDjLDLgwJ+q9mW/zbKnTx/fmTFTylcqjtaQKcF
	n69pcpZQCdGN/t0OGuSY6alA/MnELjm4+sbostrUV5G2X1PwE2hvwrzNxD7xf9w=
X-Google-Smtp-Source: AGHT+IEsgXXBzq9CWq1/V0pKBtLQX9UBo2Ll4znbJrigZlXWpi6jU7FKzKRtrYQ5s9nsgZE2W9XuQw==
X-Received: by 2002:a5d:6346:0:b0:35f:24f5:e597 with SMTP id ffacd0b85a97d-367ceadb1afmr5417475f8f.65.1720701164833;
        Thu, 11 Jul 2024 05:32:44 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cdfb2327sm7646209f8f.116.2024.07.11.05.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 05:32:44 -0700 (PDT)
Message-ID: <9e2964e30e443c86488ceae6680edd1e1b59bff2.camel@suse.com>
Subject: Re: [PATCH 28/44] libmultipath: implement dm_is_mpath() with new API
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 14:32:43 +0200
In-Reply-To: <Zo8lcu9JCzpZee8T@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-29-mwilck@suse.com> <Zo8lcu9JCzpZee8T@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-10 at 20:21 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:19PM +0200, Martin Wilck wrote:
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/devmapper.c | 53 ++++++-----------------------------=
-
> > ----
> > =C2=A01 file changed, 8 insertions(+), 45 deletions(-)
> >=20
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 859a861..6276041 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -965,52 +965,15 @@ static int dm_type_match(const char *name,
> > char *type)
> > =C2=A0
> > =C2=A0int dm_is_mpath(const char *name)
> > =C2=A0{
> > -	int r =3D DM_IS_MPATH_ERR;
> > -	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > -	struct dm_info info;
> > -	uint64_t start, length;
> > -	char *target_type =3D NULL;
> > -	char *params;
> > -	const char *uuid;
> > +	char uuid[DM_UUID_LEN];
> > +	int rc =3D libmp_mapinfo(DM_MAP_BY_NAME,
> > +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (mapid_t) { .str =3D name },
> > +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (mapinfo_t) { .uuid =3D uuid,
> > .tgt_type =3D TGT_MPATH });
> > =C2=A0
> > -	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_TABLE)))
> > -		goto out;
> > -
> > -	if (!dm_task_set_name(dmt, name))
> > -		goto out;
> > -
> > -	if (!libmp_dm_task_run(dmt)) {
> > -		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> > -		goto out;
> > -	}
> > -
> > -	if (!dm_task_get_info(dmt, &info))
> > -		goto out;
> > -
> > -	r =3D DM_IS_MPATH_NO;
> > -
> > -	if (!info.exists)
> > -		goto out;
> > -
> > -	uuid =3D dm_task_get_uuid(dmt);
> > -
> > -	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN)
> > !=3D 0)
> > -		goto out;
> > -
> > -	/* Fetch 1st target */
> > -	if (dm_get_next_target(dmt, NULL, &start, &length,
> > &target_type,
> > -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &params) !=3D NULL)
> > -		/* multiple targets */
> > -		goto out;
> > -
> > -	if (!target_type || strcmp(target_type, TGT_MPATH) !=3D 0)
> > -		goto out;
> > -
> > -	r =3D DM_IS_MPATH_YES;
> > -out:
> > -	if (r < 0)
> > -		condlog(3, "%s: dm command failed in %s: %s",
> > name, __func__, strerror(errno));
> > -	return r;
>=20
> Since dm_get_events() and watch_dmevents() need to differentiate
> between
> DM_IS_MPATH_NO and DM_IS_MPATH_ERR, this function needs to return
> DM_IS_MPATH_ERR if libmp_mapinfo() returns DM_ERR.
>=20
> Looking over this function, I did notice one thing.=C2=A0 It returns
> DM_IS_MPATH_ERR if dm_task_get_info() fails, while libmp_mapinfo__()
> returns DMP_NOT_FOUND if dm_task_get_info() fails.
>  Looking at the
> current lvm code, I can't see a way for dm_task_get_info() to fail
> if we just called libmp_dm_task_run() and it succeeded. On the other
> hand dm_task_get_info() failing does seem to be an error, not a
> a sign that the device doesn't exist, so perhaps ibmp_mapinfo__()
> should treat it like one. Although most of our code doesn't, and like
> I
> said, I don't see how it could fail unless dm_task_run() already
> failed
> (or wasn't called).

Right. I also looked at the lvm code, and dm_task_get_XYZ functions
hardly ever fail if running the task succeeded, and they probably never
will. But we shouldn't make any assumptions about libdevmapper in
libmultipath. I will change libmp_mapinfo() to return DMP_ERR in this
case.

Thanks,
Martin


>=20
> Any thoughts?
>=20
> -Ben
>=20
>=20
> > +	if (rc !=3D DMP_OK || strncmp(uuid, UUID_PREFIX,
> > UUID_PREFIX_LEN))
> > +		return DM_IS_MPATH_NO;
> > +	else
> > +		return DM_IS_MPATH_YES;
> > =C2=A0}
> > =C2=A0
> > =C2=A0int dm_map_present_by_wwid(const char *wwid)
> > --=20
> > 2.45.2
>=20

