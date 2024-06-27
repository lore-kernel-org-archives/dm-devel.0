Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBCE23BE
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 09:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480467; cv=none; b=UfkNFrzvKn3n9/QXrrzdxax4/RjROv/yfMpFt4H+W1Fo8vCEKRYamWmygOLAxMSRnODKAlNb2p+VyOe5u1Dl4hdX+vlhpin86lJxVDplTShgwzKq6oPIhPDrcFL7Kj4jqJ0PosV03ayn65ypzZr8akwXqJ29s2yklprRXAlvbwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480467; c=relaxed/simple;
	bh=jrNnhSOzlXGLoYdAyPRykpao3aT8P1wvul/5Y1TsBD8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M9TpxHURRHy9KssCLEkjxIv8Hbc0szH7jyO4gnp26pJ6anDLdFdrD58zY+lkksjFW1Fy5Bh89yC+IZRQQ2kk4wHsmLBy5i32Y2Aqn4F/1jL8eYowKy6BqLXYYgYZXfSq5vJuiMgJ7/Dq0W2cbDp04QeFhJKbgHTopeTv+lqIB3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FchwhYz2; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FchwhYz2"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a6fd513f18bso765833866b.3
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 02:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719480463; x=1720085263; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JT/9VCqd6yTJtUbtDT6RiUm5LN8Gmvtf1iz6WlwoZg0=;
        b=FchwhYz2g+girtfx4vLP/g06wpQzFESu546Pzig0M9NYr88lUPmj5SNfNlKbIJHaXp
         wcbqh0ULLRLlpmHhxozsdA6gDA0E6+RnJ9DpPxoge4ZgnOaNmzOIHFZDC65UXyJK7hTf
         mGTpx9se6wRtbL0csS1Opv/ssPvnK5A8nAqX0MUMRNWidqnNvoM3UsTOKcp3Bj+W+6kq
         7DDZsdzSEfND0g2+s/m4TFNggsHdiT8jbqeAOXvXA9cp496lc3p2tNPuL+yw71KtiPxj
         csFd0OrkLSparT+RQZqjdih8Vzd6UCH0I2DIuj12o8Zc2YdSqPZqrTDdneHQ17S13GQj
         pu8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719480463; x=1720085263;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JT/9VCqd6yTJtUbtDT6RiUm5LN8Gmvtf1iz6WlwoZg0=;
        b=oaHdSYJ/ilm7g4nE0Rmaka3t8enpv0xaFuRBFkYdb9sVWmkkGD/kYkTfqC0xssAoTv
         jZmhiOOz6v9cnAD5yZgv3qxYghUcMcJdWWGpx1Cqi6o02ESqnzv0WEW8WOcErkPrc/I6
         V0UQVXENgRahTfyipoz96jlyVjQZyQzKxwVwokyINAWi96k/lw0upsx84K4ncBi2YIE9
         wK7xrJoF2LgkQquoMfxSnS+jwk5LRJEru5RhGHNiC7RQrF5mye+wfDQynJIhlw9Mtpqb
         5/FJAtEmuMVWw7Ywb5MfcOsuNbRe88/2ffU7jdCgBe69MNyZcD/uiD6PauPsPXmb2JBr
         oWcw==
X-Gm-Message-State: AOJu0YziBtv5Kf6k9n9ksebQbBsO7sHcLjzVxn2xeRVsTqw1lJnI3sDa
	7Hj36Sf3XmsjD8yVCcu4QT7gsD0w+QLgFYgPkpilzTs3TICGqd4i5VcfEgEJvDXfKZvIdpScBac
	8
X-Google-Smtp-Source: AGHT+IHvY3fkOZQugBtMZsIwKHc1a/rUex2jvCR8Y5WRvAdfa01OKTpwZ0v8udgCYU1s6w6DWi3wNw==
X-Received: by 2002:a17:906:2b05:b0:a6f:1025:8dd6 with SMTP id a640c23a62f3a-a7245c648admr678681166b.71.1719480463243;
        Thu, 27 Jun 2024 02:27:43 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367435852afsm1241639f8f.53.2024.06.27.02.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 02:27:43 -0700 (PDT)
Message-ID: <6204dbb3f98a53b472e52c0356a16260f95ba2af.camel@suse.com>
Subject: Re: [PATCH 4/7] libmultipath: add name and minor outputs for
 dm_map_present_by_uuid()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 11:27:41 +0200
In-Reply-To: <20240605232254.623290-5-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-5-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> add arguments to dm_map_present_by_uuid() to allow optionally
> fetching
> the device name and minor number for the devices found by WWID. These
> will be used by a later patch.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I have to say I don't like this much. At least the function name should
be changed. But actually, our handling of DM_DEVICE_INFO and
DM_DEVICE_STATUS dm tasks needs refactoring. As far as the kernel is
concerned, all dm ioctls that refer to an existing map will find the
map either by uuid, by name, or by major/minor, and the map uuid and
name will always be filled in.

I'll see if I can come up with something to clean this up.

Regards
Martin=20


> ---
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 11 ++++++++++-
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0libmultipath/libmultipath.version |=C2=A0 2 +-
> =C2=A0libmultipath/valid.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A04 files changed, 13 insertions(+), 4 deletions(-)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 08bb3c51..7fe68841 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -936,7 +936,7 @@ out:
> =C2=A0 *=C2=A0 -1 : error
> =C2=A0 */
> =C2=A0int
> -dm_map_present_by_uuid(const char *uuid)
> +dm_map_present_by_uuid(const char *uuid, char **name_p, int *minor)
> =C2=A0{
> =C2=A0	struct dm_task *dmt;
> =C2=A0	struct dm_info info;
> @@ -966,6 +966,15 @@ dm_map_present_by_uuid(const char *uuid)
> =C2=A0		goto out_task;
> =C2=A0
> =C2=A0	r =3D !!info.exists;
> +	if (!r)
> +		goto out_task;
> +
> +	if (name_p) {
> +		const char *name =3D dm_task_get_name(dmt);
> +		*name_p =3D (name && strlen(name)) ? strdup(name) :
> NULL;
> +	}
> +	if (minor)
> +		*minor =3D info.minor;
> =C2=A0
> =C2=A0out_task:
> =C2=A0	dm_task_destroy(dmt);
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 19b79c5b..d9c71e92 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -43,7 +43,7 @@ int dm_simplecmd_noflush (int task, const char
> *name, uint16_t udev_flags);
> =C2=A0int dm_addmap_create (struct multipath *mpp, char *params);
> =C2=A0int dm_addmap_reload (struct multipath *mpp, char *params, int
> flush);
> =C2=A0int dm_map_present (const char *name);
> -int dm_map_present_by_uuid(const char *uuid);
> +int dm_map_present_by_uuid(const char *uuid, char **name_p, int
> *minor);
> =C2=A0int dm_get_map(const char *name, unsigned long long *size, char
> **outparams);
> =C2=A0int dm_get_status(const char *name, char **outstatus);
> =C2=A0int dm_type(const char *name, char *type);
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index eb511749..600de394 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> =C2=A0	put_multipath_config;
> =C2=A0};
> =C2=A0
> -LIBMULTIPATH_24.0.0 {
> +LIBMULTIPATH_25.0.0 {
> =C2=A0global:
> =C2=A0	/* symbols referenced by multipath and multipathd */
> =C2=A0	add_foreign;
> diff --git a/libmultipath/valid.c b/libmultipath/valid.c
> index f2237787..3b060192 100644
> --- a/libmultipath/valid.c
> +++ b/libmultipath/valid.c
> @@ -360,7 +360,7 @@ is_path_valid(const char *name, struct config
> *conf, struct path *pp,
> =C2=A0	if (check_wwids_file(pp->wwid, 0) =3D=3D 0)
> =C2=A0		return PATH_IS_VALID_NO_CHECK;
> =C2=A0
> -	if (dm_map_present_by_uuid(pp->wwid) =3D=3D 1)
> +	if (dm_map_present_by_uuid(pp->wwid, NULL, NULL) =3D=3D 1)
> =C2=A0		return PATH_IS_VALID;
> =C2=A0
> =C2=A0	/* all these act like FIND_MULTIPATHS_STRICT for finding if
> a

