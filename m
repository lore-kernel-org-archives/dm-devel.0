Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0E382D69
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 20:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720642724; cv=none; b=ObK9odwy3tErd9JsGU6TL822zlWiaoRvevyhq6eZ4IwJiwrXaWdMdz2jd+8Gq1s7MATu0grE9GqRRY2o25mlqd0Y87tEF9cBmD0y6/yVV38xl4iz2FGi6Drh73b74v2Z0LfpyrbnWJJzKp4l9uWd5YQvgwN1+MlWvjzETLogvtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720642724; c=relaxed/simple;
	bh=3Um89ho7gSWq/GjzbKfIBD22ZWJ2dlEUq24+zNSU3OE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ec4OrkraTImOSj/cVAZ2Rt3229/HK0+Z5GHUdKqZWZio5if9bCRW0I43/zHUrnLysVFezz8HqVj/KE/N3Oz3ddM4ZYW1Tb1Pc3if6nCy6PbS2LqBKen+emNjwdGzeisef76HdWlx9PkWuvrGvK/MCBPVPi0137d8Kgfd7uXLgmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ICZZwiHK; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ICZZwiHK"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52caebc6137so160615e87.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 13:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720642718; x=1721247518; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XVLCkR+mgXUw8oRW7TNtF3/Z/SV7+Q0XMxUdOjw5K/Q=;
        b=ICZZwiHK7Evea3cyhBVjZxT3w0b4HxiNctKMSuUCmXnOFAto+R1fJWgE2BUAKGPqdT
         y95mwcT7orD1O4D/d+tSR0VUMySq6qF7FabQxNraacrLBt+vQ/BvKh6cKF71FPu75NZe
         ii6Fs0H26VuLSINQQAYstNbZ1u0BZkQ4E1Kjbgv9gg9dlgGrUUHsoA8twzli3+66Kivc
         Z0q4jlT4XmFVXWWpCKbXJkGbettbniUPNefUpdkhHxE/P/N4/hDwjcxnWhJ8t9ne+VyF
         WtB4l4LGGUYfzqSjYYlaazcL8NjtMkye9rAEO/0Dffvbep42Q/tb9TMCYSrancT3/krl
         hLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720642718; x=1721247518;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XVLCkR+mgXUw8oRW7TNtF3/Z/SV7+Q0XMxUdOjw5K/Q=;
        b=on6IwkYGLGK7W1Zk9K7G4wMbQAjs/fqKPoA7mnog2ccX26N9cVlUoVVaB880GpVN5K
         XVHU7qJiMoXzl8pehmA+vzyP/PAaQhTOIiZTfG5PB4EjwglTMAvIkj+212D4yzuQ6+ZI
         ttG07F1AQWsPE//bfndezYeMV8Dd49oLor6c15MFsxvAqSbHjIjOG2KGMqaaAXRkvh4g
         CF+NNe7X41IRUTyzLELtAFNgSuif5a1ABvbUUMG8rjELc7WbBP+lWBQkMeo4XTb1Qw++
         nkbWzfU1sG+iNWkrcGMpav4sPQymDK4iOyvKETJQeB4x0I9llcbWfBRpD89OmYGFam2b
         BTqg==
X-Forwarded-Encrypted: i=1; AJvYcCXXNlAk6Qkz4g+/wzySiwNFvyB2xij3fCjZosRBWEpTeQH0bUzlbF2ukZEf/qGW/rlOQL41nZQScjECM2akKXojoKnMlDo4uEg=
X-Gm-Message-State: AOJu0YxmCZQZRtTKRi+tKrQMTG2dp5bSynbN/L9k36yJmXOz8S8SD9iN
	OdNC0eUpyKOLk9uNKn2ifi8fkFRF1+wYgiM0zD7VQxmRiOsIpMzEV4UcHAywF6A=
X-Google-Smtp-Source: AGHT+IHLA0CDhuJAbuBGNDTrVesnvEOoK6oWZSyQiH9isHg0VEVaWYbQzlM/1UUw/kJiQ5YKcRKTUg==
X-Received: by 2002:a05:6512:2247:b0:52c:dec1:4578 with SMTP id 2adb3069b0e04-52eb99d3d82mr4019843e87.60.1720642717690;
        Wed, 10 Jul 2024 13:18:37 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a872e02sm188227166b.216.2024.07.10.13.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 13:18:37 -0700 (PDT)
Message-ID: <e623b494675f6613891bc97a54fa27aeedf9af08.camel@suse.com>
Subject: Re: [PATCH 16/44] libmultipath: add cleanup_dm_task(), and use it
 in devmapper.c
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Wed, 10 Jul 2024 22:18:36 +0200
In-Reply-To: <Zo7rERddnnfSvSsW@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-17-mwilck@suse.com> <Zo7rERddnnfSvSsW@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-10 at 16:12 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:07PM +0200, Martin Wilck wrote:
> > This allows us to get rid of a lot of goto statements, and
> > generally
> > obtain cleaner code.
> >=20
> > Additional small changes:
> >=20
> > =C2=A0- simplify the logic of dm_tgt_version(); the only caller isn't
> > interested
> > =C2=A0=C2=A0 in the nature of the error if the version couldn't be obta=
ined.
> > =C2=A0- libmultipath: rename dm_type() to the more fitting
> > dm_type_match()
> > =C2=A0- use symbolic return values in dm_is_mpath()
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmpathpersist/mpath_persist_int.c |=C2=A0=C2=A0 2 +-
> > =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 315 ++++++++++++------------
> > ----
> > =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 7 +-
> > =C2=A0multipath/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 4 +-
> > =C2=A0multipathd/dmevents.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 4 +-
> > =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 =
2 +-
> > =C2=A06 files changed, 145 insertions(+), 189 deletions(-)
> >=20
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 178c2f5..6da0401 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -185,7 +185,7 @@ static int mpath_get_map(vector curmp, vector
> > pathvec, int fd, char **palias,
> > =C2=A0
> > =C2=A0	condlog(3, "alias =3D %s", alias);
> > =C2=A0
> > -	if (dm_map_present(alias) && dm_is_mpath(alias) !=3D 1){
> > +	if (dm_map_present(alias) && dm_is_mpath(alias) !=3D
> > DM_IS_MPATH_YES) {
> > =C2=A0		condlog(3, "%s: not a multipath device.", alias);
> > =C2=A0		goto out;
> > =C2=A0	}
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 8996c1d..3685ef7 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -91,6 +91,12 @@ int libmp_dm_task_run(struct dm_task *dmt)
> > =C2=A0	return r;
> > =C2=A0}
> > =C2=A0
> > +static void cleanup_dm_task(struct dm_task **pdmt)
> > +{
> > +	if (*pdmt)
> > +		dm_task_destroy(*pdmt);
> > +}
> > +
> > =C2=A0__attribute__((format(printf, 4, 5))) static void
> > =C2=A0dm_write_log (int level, const char *file, int line, const char
> > *f, ...)
> > =C2=A0{
> > @@ -203,8 +209,8 @@ static void init_dm_drv_version(void)
> > =C2=A0
> > =C2=A0static int dm_tgt_version (unsigned int *version, char *str)
> > =C2=A0{
> > -	int r =3D 2;
> > -	struct dm_task *dmt;
> > +	bool found =3D false;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	struct dm_versions *target;
> > =C2=A0	struct dm_versions *last_target;
> > =C2=A0	unsigned int *v;
> > @@ -220,31 +226,28 @@ static int dm_tgt_version (unsigned int
> > *version, char *str)
> > =C2=A0	if (!libmp_dm_task_run(dmt)) {
> > =C2=A0		dm_log_error(2, DM_DEVICE_LIST_VERSIONS, dmt);
> > =C2=A0		condlog(0, "Cannot communicate with kernel DM");
> > -		goto out;
> > +		return 1;
> > =C2=A0	}
> > =C2=A0	target =3D dm_task_get_versions(dmt);
> > =C2=A0
> > =C2=A0	do {
> > =C2=A0		last_target =3D target;
> > =C2=A0		if (!strncmp(str, target->name, strlen(str))) {
> > -			r =3D 1;
> > +			found =3D true;
> > =C2=A0			break;
> > =C2=A0		}
> > =C2=A0		target =3D (void *) target + target->next;
> > =C2=A0	} while (last_target !=3D target);
> > =C2=A0
> > -	if (r =3D=3D 2) {
> > +	if (!found) {
> > =C2=A0		condlog(0, "DM %s kernel driver not loaded", str);
> > -		goto out;
> > +		return 1;
> > =C2=A0	}
> > =C2=A0	v =3D target->version;
> > =C2=A0	version[0] =3D v[0];
> > =C2=A0	version[1] =3D v[1];
> > =C2=A0	version[2] =3D v[2];
> > -	r =3D 0;
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > +	return 0;
> > =C2=A0}
> > =C2=A0
> > =C2=A0static void init_dm_mpath_version(void)
> > @@ -383,18 +386,18 @@ libmp_dm_task_create(int task)
> > =C2=A0
> > =C2=A0static int
> > =C2=A0dm_simplecmd (int task, const char *name, int flags, uint16_t
> > udev_flags) {
> > -	int r =3D 0;
> > +	int r;
> > =C2=A0	int udev_wait_flag =3D (((flags & DMFL_NEED_SYNC) ||
> > udev_flags) &&
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (task =3D=3D DM_DEVICE_RESUME |=
|
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 task =3D=3D DM_DEVICE_REM=
OVE));
> > =C2=A0	uint32_t cookie =3D 0;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0
> > =C2=A0	if (!(dmt =3D libmp_dm_task_create (task)))
> > =C2=A0		return 0;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name (dmt, name))
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
> > =C2=A0#ifdef LIBDM_API_FLUSH
> > @@ -408,7 +411,7 @@ dm_simplecmd (int task, const char *name, int
> > flags, uint16_t udev_flags) {
> > =C2=A0	if (udev_wait_flag &&
> > =C2=A0	=C2=A0=C2=A0=C2=A0 !dm_task_set_cookie(dmt, &cookie,
> > =C2=A0				DM_UDEV_DISABLE_LIBRARY_FALLBACK |
> > udev_flags))
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	r =3D libmp_dm_task_run (dmt);
> > =C2=A0	if (!r)
> > @@ -416,8 +419,6 @@ dm_simplecmd (int task, const char *name, int
> > flags, uint16_t udev_flags) {
> > =C2=A0
> > =C2=A0	if (udev_wait_flag)
> > =C2=A0			libmp_udev_wait(cookie);
> > -out:
> > -	dm_task_destroy (dmt);
> > =C2=A0	return r;
> > =C2=A0}
> > =C2=A0
> > @@ -440,8 +441,9 @@ static int
> > =C2=A0dm_addmap (int task, const char *target, struct multipath *mpp,
> > =C2=A0	=C2=A0=C2=A0 char * params, int ro, uint16_t udev_flags) {
> > =C2=A0	int r =3D 0;
> > -	struct dm_task *dmt;
> > -	char *prefixed_uuid =3D NULL;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > +	char __attribute__((cleanup(cleanup_charp)))
> > *prefixed_uuid =3D NULL;
> > +
> > =C2=A0	uint32_t cookie =3D 0;
> > =C2=A0
> > =C2=A0	if (task =3D=3D DM_DEVICE_CREATE && strlen(mpp->wwid) =3D=3D 0) =
{
> > @@ -457,10 +459,10 @@ dm_addmap (int task, const char *target,
> > struct multipath *mpp,
> > =C2=A0		return 0;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name (dmt, mpp->alias))
> > -		goto addout;
> > +		return 0;
> > =C2=A0
> > =C2=A0	if (!dm_task_add_target (dmt, 0, mpp->size, target,
> > params))
> > -		goto addout;
> > +		return 0;
> > =C2=A0
> > =C2=A0	if (ro)
> > =C2=A0		dm_task_set_ro(dmt);
> > @@ -469,10 +471,10 @@ dm_addmap (int task, const char *target,
> > struct multipath *mpp,
> > =C2=A0		if (asprintf(&prefixed_uuid, UUID_PREFIX "%s",
> > mpp->wwid) < 0) {
> > =C2=A0			condlog(0, "cannot create prefixed uuid :
> > %s",
> > =C2=A0				strerror(errno));
> > -			goto addout;
> > +			return 0;
> > =C2=A0		}
> > =C2=A0		if (!dm_task_set_uuid(dmt, prefixed_uuid))
> > -			goto freeout;
> > +			return 0;
> > =C2=A0		dm_task_skip_lockfs(dmt);
> > =C2=A0#ifdef LIBDM_API_FLUSH
> > =C2=A0		dm_task_no_flush(dmt);
> > @@ -481,33 +483,28 @@ dm_addmap (int task, const char *target,
> > struct multipath *mpp,
> > =C2=A0
> > =C2=A0	if (mpp->attribute_flags & (1 << ATTR_MODE) &&
> > =C2=A0	=C2=A0=C2=A0=C2=A0 !dm_task_set_mode(dmt, mpp->mode))
> > -		goto freeout;
> > +		return 0;
> > =C2=A0	if (mpp->attribute_flags & (1 << ATTR_UID) &&
> > =C2=A0	=C2=A0=C2=A0=C2=A0 !dm_task_set_uid(dmt, mpp->uid))
> > -		goto freeout;
> > +		return 0;
> > =C2=A0	if (mpp->attribute_flags & (1 << ATTR_GID) &&
> > =C2=A0	=C2=A0=C2=A0=C2=A0 !dm_task_set_gid(dmt, mpp->gid))
> > -		goto freeout;
> > +		return 0;
> > +
> > =C2=A0	condlog(2, "%s: %s [0 %llu %s %s]", mpp->alias,
> > =C2=A0		task =3D=3D DM_DEVICE_RELOAD ? "reload" : "addmap",
> > mpp->size,
> > =C2=A0		target, params);
> > =C2=A0
> > =C2=A0	if (task =3D=3D DM_DEVICE_CREATE &&
> > =C2=A0	=C2=A0=C2=A0=C2=A0 !dm_task_set_cookie(dmt, &cookie, udev_flags)=
)
> > -		goto freeout;
> > +		return 0;
> > =C2=A0
> > =C2=A0	r =3D libmp_dm_task_run (dmt);
> > =C2=A0	if (!r)
> > =C2=A0		dm_log_error(2, task, dmt);
> > =C2=A0
> > =C2=A0	if (task =3D=3D DM_DEVICE_CREATE)
> > -			libmp_udev_wait(cookie);
> > -freeout:
> > -	if (prefixed_uuid)
> > -		free(prefixed_uuid);
> > -
> > -addout:
> > -	dm_task_destroy (dmt);
> > +		libmp_udev_wait(cookie);
> > =C2=A0
> > =C2=A0	if (r)
> > =C2=A0		mpp->need_reload =3D false;
> > @@ -648,46 +645,41 @@ int dm_map_present(const char * str)
> > =C2=A0
> > =C2=A0int dm_get_map(const char *name, unsigned long long *size, char
> > **outparams)
> > =C2=A0{
> > -	int r =3D DMP_ERR;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	uint64_t start, length;
> > =C2=A0	char *target_type =3D NULL;
> > =C2=A0	char *params =3D NULL;
> > =C2=A0
> > =C2=A0	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_TABLE)))
> > -		return r;
> > +		return DMP_ERR;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name(dmt, name))
> > -		goto out;
> > +		return DMP_ERR;
> > =C2=A0
> > =C2=A0	errno =3D 0;
> > =C2=A0	if (!libmp_dm_task_run(dmt)) {
> > =C2=A0		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> > =C2=A0		if (dm_task_get_errno(dmt) =3D=3D ENXIO)
> > -			r =3D DMP_NOT_FOUND;
> > -		goto out;
> > +			return DMP_NOT_FOUND;
> > +		else
> > +			return DMP_ERR;
> > =C2=A0	}
> > =C2=A0
> > -	r =3D DMP_NOT_FOUND;
> > =C2=A0	/* Fetch 1st target */
> > =C2=A0	if (dm_get_next_target(dmt, NULL, &start, &length,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &target_type, &params) !=
=3D NULL ||
> > !params)
> > =C2=A0		/* more than one target or not found target */
> > -		goto out;
> > +		return DMP_NOT_FOUND;
> > =C2=A0
> > =C2=A0	if (size)
> > =C2=A0		*size =3D length;
> > =C2=A0
> > =C2=A0	if (!outparams)
> > -		r =3D DMP_OK;
> > +		return DMP_OK;
> > =C2=A0	else {
> > =C2=A0		*outparams =3D strdup(params);
> > -		r =3D *outparams ? DMP_OK : DMP_ERR;
> > +		return *outparams ? DMP_OK : DMP_ERR;
> > =C2=A0	}
> > -
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > =C2=A0}
> > =C2=A0
> > =C2=A0static int
> > @@ -767,7 +759,7 @@ is_mpath_part(const char *part_name, const char
> > *map_name)
> > =C2=A0int dm_get_status(const char *name, char **outstatus)
> > =C2=A0{
> > =C2=A0	int r =3D DMP_ERR;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	uint64_t start, length;
> > =C2=A0	char *target_type =3D NULL;
> > =C2=A0	char *status =3D NULL;
> > @@ -796,7 +788,7 @@ int dm_get_status(const char *name, char
> > **outstatus)
> > =C2=A0		goto out;
> > =C2=A0
> > =C2=A0	if (!status) {
> > -		condlog(2, "get null status.");
> > +		condlog(2, "got null status.");
> > =C2=A0		goto out;
> > =C2=A0	}
> > =C2=A0
> > @@ -808,62 +800,56 @@ int dm_get_status(const char *name, char
> > **outstatus)
> > =C2=A0	}
> > =C2=A0out:
> > =C2=A0	if (r !=3D DMP_OK)
> > -		condlog(0, "%s: error getting map status string",
> > name);
> > +		condlog(0, "%s: %s: error getting map status
> > string: %d",
> > +			__func__, name, r);
> > =C2=A0
> > -	dm_task_destroy(dmt);
> > =C2=A0	return r;
> > =C2=A0}
> > =C2=A0
> > -/*
> > - * returns:
> > - *=C2=A0=C2=A0=C2=A0 1 : match
> > - *=C2=A0=C2=A0=C2=A0 0 : no match
> > - *=C2=A0=C2=A0 -1 : empty map, or more than 1 target
> > - */
> > -int dm_type(const char *name, char *type)
> > +enum {
> > +	DM_TYPE_NOMATCH =3D 0,
> > +	DM_TYPE_MATCH,
> > +	/* more than 1 target */
> > +	DM_TYPE_MULTI,
> > +	/* empty map */
> > +	DM_TYPE_EMPTY,
> > +	DM_TYPE_ERR,
> > +};
> > +static int dm_type_match(const char *name, char *type)
> > =C2=A0{
> > -	int r =3D 0;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	uint64_t start, length;
> > =C2=A0	char *target_type =3D NULL;
> > =C2=A0	char *params;
> > =C2=A0
> > =C2=A0	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_TABLE)))
> > -		return 0;
> > +		return DM_TYPE_ERR;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name(dmt, name))
> > -		goto out;
> > +		return DM_TYPE_ERR;
> > =C2=A0
> > =C2=A0	if (!libmp_dm_task_run(dmt)) {
> > =C2=A0		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> > -		goto out;
> > +		return DM_TYPE_ERR;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	/* Fetch 1st target */
> > =C2=A0	if (dm_get_next_target(dmt, NULL, &start, &length,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &target_type, &params) !=
=3D NULL)
> > =C2=A0		/* multiple targets */
> > -		r =3D -1;
> > +		return DM_TYPE_MULTI;
> > =C2=A0	else if (!target_type)
> > -		r =3D -1;
> > +		return DM_TYPE_EMPTY;
> > =C2=A0	else if (!strcmp(target_type, type))
> > -		r =3D 1;
> > -
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > +		return DM_TYPE_MATCH;
> > +	else
> > +		return DM_TYPE_NOMATCH;
> > =C2=A0}
> > =C2=A0
> > -/*
> > - * returns:
> > - * 1=C2=A0 : is multipath device
> > - * 0=C2=A0 : is not multipath device
> > - * -1 : error
> > - */
> > =C2=A0int dm_is_mpath(const char *name)
> > =C2=A0{
> > -	int r =3D -1;
> > -	struct dm_task *dmt;
> > +	int r =3D DM_IS_MPATH_ERR;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	struct dm_info info;
> > =C2=A0	uint64_t start, length;
> > =C2=A0	char *target_type =3D NULL;
> > @@ -874,41 +860,39 @@ int dm_is_mpath(const char *name)
> > =C2=A0		goto out;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name(dmt, name))
> > -		goto out_task;
> > +		goto out;
> > =C2=A0
> > =C2=A0	if (!libmp_dm_task_run(dmt)) {
> > =C2=A0		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> > -		goto out_task;
> > +		goto out;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	if (!dm_task_get_info(dmt, &info))
> > -		goto out_task;
> > +		goto out;
> > =C2=A0
> > -	r =3D 0;
> > +	r =3D DM_IS_MPATH_NO;
> > =C2=A0
> > =C2=A0	if (!info.exists)
> > -		goto out_task;
> > +		goto out;
> > =C2=A0
> > =C2=A0	uuid =3D dm_task_get_uuid(dmt);
> > =C2=A0
> > =C2=A0	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN)
> > !=3D 0)
> > -		goto out_task;
> > +		goto out;
> > =C2=A0
> > =C2=A0	/* Fetch 1st target */
> > =C2=A0	if (dm_get_next_target(dmt, NULL, &start, &length,
> > &target_type,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &params) !=3D NULL)
> > =C2=A0		/* multiple targets */
> > -		goto out_task;
> > +		goto out;
> > =C2=A0
> > =C2=A0	if (!target_type || strcmp(target_type, TGT_MPATH) !=3D 0)
> > -		goto out_task;
> > +		goto out;
> > =C2=A0
> > -	r =3D 1;
> > -out_task:
> > -	dm_task_destroy(dmt);
> > +	r =3D DM_IS_MPATH_YES;
> > =C2=A0out:
> > =C2=A0	if (r < 0)
> > -		condlog(3, "%s: dm command failed in %s: %s",
> > name, __FUNCTION__, strerror(errno));
> > +		condlog(3, "%s: dm command failed in %s: %s",
> > name, __func__, strerror(errno));
> > =C2=A0	return r;
> > =C2=A0}
> > =C2=A0
> > @@ -1049,7 +1033,7 @@ int _dm_flush_map (const char *mapname, int
> > flags, int retries)
> > =C2=A0	unsigned long long mapsize;
> > =C2=A0	char *params =3D NULL;
> > =C2=A0
> > -	if (dm_is_mpath(mapname) !=3D 1)
> > +	if (dm_is_mpath(mapname) !=3D DM_IS_MPATH_YES)
> > =C2=A0		return DM_FLUSH_OK; /* nothing to do */
> > =C2=A0
> > =C2=A0	/* if the device currently has no partitions, do not
> > @@ -1096,7 +1080,7 @@ int _dm_flush_map (const char *mapname, int
> > flags, int retries)
> > =C2=A0			}
> > =C2=A0			condlog(4, "multipath map %s removed",
> > mapname);
> > =C2=A0			return DM_FLUSH_OK;
> > -		} else if (dm_is_mpath(mapname) !=3D 1) {
> > +		} else if (dm_is_mpath(mapname) !=3D
> > DM_IS_MPATH_YES) {
> > =C2=A0			condlog(4, "multipath map %s removed
> > externally",
> > =C2=A0				mapname);
> > =C2=A0			return DM_FLUSH_OK; /* raced. someone else
> > removed it */
> > @@ -1131,10 +1115,10 @@ dm_flush_map_nopaths(const char *mapname,
> > int deferred_remove __DR_UNUSED__)
> > =C2=A0	return _dm_flush_map(mapname, flags, 0);
> > =C2=A0}
> > =C2=A0
> > -int dm_flush_maps (int retries)
> > +int dm_flush_maps(int retries)
> > =C2=A0{
> > =C2=A0	int r =3D DM_FLUSH_FAIL;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	struct dm_names *names;
> > =C2=A0	unsigned next =3D 0;
> > =C2=A0
> > @@ -1143,15 +1127,15 @@ int dm_flush_maps (int retries)
> > =C2=A0
> > =C2=A0	if (!libmp_dm_task_run (dmt)) {
> > =C2=A0		dm_log_error(3, DM_DEVICE_LIST, dmt);
> > -		goto out;
> > +		return r;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	if (!(names =3D dm_task_get_names (dmt)))
> > -		goto out;
> > +		return r;
> > =C2=A0
> > =C2=A0	r =3D DM_FLUSH_OK;
> > =C2=A0	if (!names->dev)
> > -		goto out;
> > +		return r;
> > =C2=A0
> > =C2=A0	do {
> > =C2=A0		int ret;
> > @@ -1163,16 +1147,13 @@ int dm_flush_maps (int retries)
> > =C2=A0		names =3D (void *) names + next;
> > =C2=A0	} while (next);
> > =C2=A0
> > -out:
> > -	dm_task_destroy (dmt);
> > =C2=A0	return r;
> > =C2=A0}
> > =C2=A0
> > =C2=A0int
> > =C2=A0dm_message(const char * mapname, char * message)
> > =C2=A0{
> > -	int r =3D 1;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0
> > =C2=A0	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_TARGET_MSG)))
> > =C2=A0		return 1;
> > @@ -1191,13 +1172,10 @@ dm_message(const char * mapname, char *
> > message)
> > =C2=A0		goto out;
> > =C2=A0	}
> > =C2=A0
> > -	r =3D 0;
> > +	return 0;
> > =C2=A0out:
> > -	if (r)
> > -		condlog(0, "DM message failed [%s]", message);
> > -
> > -	dm_task_destroy(dmt);
> > -	return r;
> > +	condlog(0, "DM message failed [%s]", message);
> > +	return 1;
> > =C2=A0}
> > =C2=A0
> > =C2=A0int
> > @@ -1305,12 +1283,10 @@ out:
> > =C2=A0	return NULL;
> > =C2=A0}
> > =C2=A0
> > -int
> > -dm_get_maps (vector mp)
> > +int dm_get_maps(vector mp)
> > =C2=A0{
> > =C2=A0	struct multipath * mpp;
> > -	int r =3D 1;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	struct dm_names *names;
> > =C2=A0	unsigned next =3D 0;
> > =C2=A0
> > @@ -1322,28 +1298,28 @@ dm_get_maps (vector mp)
> > =C2=A0
> > =C2=A0	if (!libmp_dm_task_run(dmt)) {
> > =C2=A0		dm_log_error(3, DM_DEVICE_LIST, dmt);
> > -		goto out;
> > +		return 1;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	if (!(names =3D dm_task_get_names(dmt)))
> > -		goto out;
> > +		return 1;
> > =C2=A0
> > =C2=A0	if (!names->dev) {
> > -		r =3D 0; /* this is perfectly valid */
> > -		goto out;
> > +		/* this is perfectly valid */
> > +		return 0;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	do {
> > -		if (dm_is_mpath(names->name) !=3D 1)
> > +		if (dm_is_mpath(names->name) !=3D DM_IS_MPATH_YES)
> > =C2=A0			goto next;
> > =C2=A0
> > =C2=A0		mpp =3D dm_get_multipath(names->name);
> > =C2=A0		if (!mpp)
> > -			goto out;
> > +			return 1;
> > =C2=A0
> > =C2=A0		if (!vector_alloc_slot(mp)) {
> > =C2=A0			free_multipath(mpp, KEEP_PATHS);
> > -			goto out;
> > +			return 1;
> > =C2=A0		}
> > =C2=A0
> > =C2=A0		vector_set_slot(mp, mpp);
> > @@ -1352,11 +1328,7 @@ next:
> > =C2=A0		names =3D (void *) names + next;
> > =C2=A0	} while (next);
> > =C2=A0
> > -	r =3D 0;
> > -	goto out;
> > -out:
> > -	dm_task_destroy (dmt);
> > -	return r;
> > +	return 0;
> > =C2=A0}
> > =C2=A0
> > =C2=A0int
> > @@ -1419,10 +1391,10 @@ do_foreach_partmaps (const char * mapname,
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 int (*partmap_func)(const char *, void=
 *),
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 void *data)
> > =C2=A0{
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > +	char __attribute__((cleanup(cleanup_charp))) *params =3D
> > NULL;
> > =C2=A0	struct dm_names *names;
> > =C2=A0	unsigned next =3D 0;
> > -	char *params =3D NULL;
> > =C2=A0	unsigned long long size;
> > =C2=A0	char dev_t[32];
> > =C2=A0	int r =3D 1;
> > @@ -1431,28 +1403,25 @@ do_foreach_partmaps (const char * mapname,
> > =C2=A0	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_LIST)))
> > =C2=A0		return 1;
> > =C2=A0
> > -	if (!libmp_dm_task_run(dmt)) {
> > -		dm_log_error(3, DM_DEVICE_LIST, dmt);
> > -		goto out;
> > -	}
> > +	if (!libmp_dm_task_run(dmt))
> > +		return 1;
> > =C2=A0
> > =C2=A0	if (!(names =3D dm_task_get_names(dmt)))
> > -		goto out;
> > +		return 1;
> > =C2=A0
> > -	if (!names->dev) {
> > -		r =3D 0; /* this is perfectly valid */
> > -		goto out;
> > -	}
> > +	if (!names->dev)
> > +		/* this is perfectly valid */
> > +		return 0;
> > =C2=A0
> > =C2=A0	if (dm_dev_t(mapname, &dev_t[0], 32))
> > -		goto out;
> > +		return 1;
> > =C2=A0
> > =C2=A0	do {
> > =C2=A0		if (
> > =C2=A0		=C2=A0=C2=A0=C2=A0 /*
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 * if there is only a single "linear" t=
arget
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 */
> > -		=C2=A0=C2=A0=C2=A0 (dm_type(names->name, TGT_PART) =3D=3D 1) &&
> > +		=C2=A0=C2=A0=C2=A0 (dm_type_match(names->name, TGT_PART) =3D=3D
> > DM_TYPE_MATCH) &&
> > =C2=A0
> > =C2=A0		=C2=A0=C2=A0=C2=A0 /*
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 * and the uuid of the target is a part=
ition
> > of the
> > @@ -1472,7 +1441,7 @@ do_foreach_partmaps (const char * mapname,
> > =C2=A0		=C2=A0=C2=A0=C2=A0 !isdigit(*(p + strlen(dev_t)))
> > =C2=A0		=C2=A0=C2=A0 ) {
> > =C2=A0			if ((r =3D partmap_func(names->name, data))
> > !=3D 0)
> > -				goto out;
> > +				return 1;
> > =C2=A0		}
> > =C2=A0
> > =C2=A0		free(params);
> > @@ -1481,11 +1450,7 @@ do_foreach_partmaps (const char * mapname,
> > =C2=A0		names =3D (void *) names + next;
> > =C2=A0	} while (next);
> > =C2=A0
> > -	r =3D 0;
> > -out:
> > -	free(params);
> > -	dm_task_destroy (dmt);
> > -	return r;
> > +	return 0;
> > =C2=A0}
> > =C2=A0
> > =C2=A0struct remove_data {
> > @@ -1623,7 +1588,7 @@ int
> > =C2=A0dm_rename (const char * old, char * new, char *delim, int
> > skip_kpartx)
> > =C2=A0{
> > =C2=A0	int r =3D 0;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	uint32_t cookie =3D 0;
> > =C2=A0	uint16_t udev_flags =3D DM_UDEV_DISABLE_LIBRARY_FALLBACK |
> > ((skip_kpartx =3D=3D SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
> > =C2=A0
> > @@ -1634,22 +1599,19 @@ dm_rename (const char * old, char * new,
> > char *delim, int skip_kpartx)
> > =C2=A0		return r;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name(dmt, old))
> > -		goto out;
> > +		return r;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_newname(dmt, new))
> > -		goto out;
> > +		return r;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
> > -		goto out;
> > +		return r;
> > +
> > =C2=A0	r =3D libmp_dm_task_run(dmt);
> > =C2=A0	if (!r)
> > =C2=A0		dm_log_error(2, DM_DEVICE_RENAME, dmt);
> > =C2=A0
> > =C2=A0	libmp_udev_wait(cookie);
> > -
> > -out:
> > -	dm_task_destroy(dmt);
> > -
> > =C2=A0	return r;
> > =C2=A0}
> > =C2=A0
> > @@ -1672,9 +1634,10 @@ void dm_reassign_deps(char *table, const
> > char *dep, const char *newdep)
> > =C2=A0
> > =C2=A0int dm_reassign_table(const char *name, char *old, char *new)
> > =C2=A0{
> > -	int r =3D 0, modified =3D 0;
> > +	int modified =3D 0;
> > =C2=A0	uint64_t start, length;
> > -	struct dm_task *dmt, *reload_dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *reload_dmt =3D NULL;
> > =C2=A0	char *target, *params =3D NULL;
> > =C2=A0	char *buff;
> > =C2=A0	void *next =3D NULL;
> > @@ -1683,16 +1646,16 @@ int dm_reassign_table(const char *name,
> > char *old, char *new)
> > =C2=A0		return 0;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name(dmt, name))
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	if (!libmp_dm_task_run(dmt)) {
> > =C2=A0		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> > -		goto out;
> > +		return 0;
> > =C2=A0	}
> > =C2=A0	if (!(reload_dmt =3D
> > libmp_dm_task_create(DM_DEVICE_RELOAD)))
> > -		goto out;
> > +		return 0;
> > =C2=A0	if (!dm_task_set_name(reload_dmt, name))
> > -		goto out_reload;
> > +		return 0;
> > =C2=A0
> > =C2=A0	do {
> > =C2=A0		next =3D dm_get_next_target(dmt, next, &start,
> > &length,
> > @@ -1705,13 +1668,13 @@ int dm_reassign_table(const char *name,
> > char *old, char *new)
> > =C2=A0			 */
> > =C2=A0			condlog(1, "%s: invalid target found in
> > map %s",
> > =C2=A0				__func__, name);
> > -			goto out_reload;
> > +			return 0;
> > =C2=A0		}
> > =C2=A0		buff =3D strdup(params);
> > =C2=A0		if (!buff) {
> > =C2=A0			condlog(3, "%s: failed to replace target
> > %s, "
> > =C2=A0				"out of memory", name, target);
> > -			goto out_reload;
> > +			return 0;
> > =C2=A0		}
> > =C2=A0		if (strcmp(target, TGT_MPATH) && strstr(params,
> > old)) {
> > =C2=A0			condlog(3, "%s: replace target %s %s",
> > @@ -1729,18 +1692,12 @@ int dm_reassign_table(const char *name,
> > char *old, char *new)
> > =C2=A0		if (!libmp_dm_task_run(reload_dmt)) {
> > =C2=A0			dm_log_error(3, DM_DEVICE_RELOAD,
> > reload_dmt);
> > =C2=A0			condlog(3, "%s: failed to reassign
> > targets", name);
> > -			goto out_reload;
> > +			return 0;
> > =C2=A0		}
> > =C2=A0		dm_simplecmd_noflush(DM_DEVICE_RESUME, name,
> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0 MPATH_UDEV_RELOAD_FLAG);
> > =C2=A0	}
> > -	r =3D 1;
> > -
> > -out_reload:
> > -	dm_task_destroy(reload_dmt);
> > -out:
> > -	dm_task_destroy(dmt);
> > -	return r;
> > +	return 1;
> > =C2=A0}
> > =C2=A0
> > =C2=A0
> > @@ -1752,10 +1709,9 @@ out:
> > =C2=A0int dm_reassign(const char *mapname)
> > =C2=A0{
> > =C2=A0	struct dm_deps *deps;
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	struct dm_info info;
> > =C2=A0	char dev_t[32], dm_dep[32];
> > -	int r =3D 0;
> > =C2=A0	unsigned int i;
> > =C2=A0
> > =C2=A0	if (dm_dev_t(mapname, &dev_t[0], 32)) {
> > @@ -1769,21 +1725,21 @@ int dm_reassign(const char *mapname)
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name(dmt, mapname))
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	if (!libmp_dm_task_run(dmt)) {
> > =C2=A0		dm_log_error(3, DM_DEVICE_DEPS, dmt);
> > -		goto out;
> > +		return 0;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	if (!dm_task_get_info(dmt, &info))
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	if (!(deps =3D dm_task_get_deps(dmt)))
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	if (!info.exists)
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	for (i =3D 0; i < deps->count; i++) {
> > =C2=A0		sprintf(dm_dep, "%d:%d",
> > @@ -1792,15 +1748,12 @@ int dm_reassign(const char *mapname)
> > =C2=A0		sysfs_check_holders(dm_dep, dev_t);
> > =C2=A0	}
> > =C2=A0
> > -	r =3D 1;
> > -out:
> > -	dm_task_destroy (dmt);
> > -	return r;
> > +	return 1;
> > =C2=A0}
> > =C2=A0
> > =C2=A0int dm_setgeometry(struct multipath *mpp)
> > =C2=A0{
> > -	struct dm_task *dmt;
> > +	struct dm_task __attribute__((cleanup(cleanup_dm_task)))
> > *dmt =3D NULL;
> > =C2=A0	struct path *pp;
> > =C2=A0	char heads[4], sectors[4];
> > =C2=A0	char cylinders[10], start[32];
> > @@ -1825,7 +1778,7 @@ int dm_setgeometry(struct multipath *mpp)
> > =C2=A0		return 0;
> > =C2=A0
> > =C2=A0	if (!dm_task_set_name(dmt, mpp->alias))
> > -		goto out;
> > +		return 0;
> > =C2=A0
> > =C2=A0	/* What a sick interface ... */
> > =C2=A0	snprintf(heads, 4, "%u", pp->geom.heads);
> > @@ -1834,14 +1787,12 @@ int dm_setgeometry(struct multipath *mpp)
> > =C2=A0	snprintf(start, 32, "%lu", pp->geom.start);
> > =C2=A0	if (!dm_task_set_geometry(dmt, cylinders, heads, sectors,
> > start)) {
> > =C2=A0		condlog(3, "%s: Failed to set geometry", mpp-
> > >alias);
> > -		goto out;
> > +		return 0;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	r =3D libmp_dm_task_run(dmt);
> > =C2=A0	if (!r)
> > =C2=A0		dm_log_error(3, DM_DEVICE_SET_GEOMETRY, dmt);
> > -out:
> > -	dm_task_destroy(dmt);
> > =C2=A0
> > =C2=A0	return r;
> > =C2=A0}
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index 19b79c5..9438c2d 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -46,7 +46,12 @@ int dm_map_present (const char *name);
> > =C2=A0int dm_map_present_by_uuid(const char *uuid);
> > =C2=A0int dm_get_map(const char *name, unsigned long long *size, char
> > **outparams);
> > =C2=A0int dm_get_status(const char *name, char **outstatus);
> > -int dm_type(const char *name, char *type);
> > +
> > +enum {
> > +	DM_IS_MPATH_NO,
> > +	DM_IS_MPATH_YES,
> > +	DM_IS_MPATH_ERR,
> > +};
> > =C2=A0int dm_is_mpath(const char *name);
> > =C2=A0
> > =C2=A0enum {
> > diff --git a/multipath/main.c b/multipath/main.c
> > index ce702e7..c82bc86 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -247,7 +247,7 @@ static int check_usable_paths(struct config
> > *conf,
> > =C2=A0		goto out;
> > =C2=A0	}
> > =C2=A0
> > -	if (dm_is_mpath(mapname) !=3D 1) {
> > +	if (dm_is_mpath(mapname) !=3D DM_IS_MPATH_YES) {
> > =C2=A0		condlog(1, "%s is not a multipath map", devpath);
> > =C2=A0		goto free;
> > =C2=A0	}
> > @@ -1080,7 +1080,7 @@ main (int argc, char *argv[])
> > =C2=A0		goto out;
> > =C2=A0	}
> > =C2=A0	if (cmd =3D=3D CMD_FLUSH_ONE) {
> > -		if (dm_is_mpath(dev) !=3D 1) {
> > +		if (dm_is_mpath(dev) !=3D DM_IS_MPATH_YES) {
> > =C2=A0			condlog(0, "%s is not a multipath device",
> > dev);
> > =C2=A0			r =3D RTVL_FAIL;
> > =C2=A0			goto out;
> > diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
> > index 3fbdc55..605219e 100644
> > --- a/multipathd/dmevents.c
> > +++ b/multipathd/dmevents.c
> > @@ -170,7 +170,7 @@ static int dm_get_events(void)
> > =C2=A0
> > =C2=A0		/* Don't delete device if dm_is_mpath() fails
> > without
> > =C2=A0		 * checking the device type */
>=20
> Like the comments says, this check is only supposed to remove a
> multipath
> device from the list of devices if dm_is_mpath() returns
> DM_IS_MPATH_NO.
>=20
> See 9050cd5a1 ("libmultipath: fix false removes in dmevents polling
> code")

I saw these comments, but I didn't get the message, and failed to
lookup the history which I ususally do in cases like this.

Thanks for pointing it out, and for reading through this large
patch all the way to the bottom.

Martin

