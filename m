Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C18224E8
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713976482; cv=none; b=XhnVTBLiHpYHlaHcD63BOUMI8cJADVBW6gDr4k9fhBKmO70iKHA3gcrErWrrlK30KpDJrma44VWlyIaLChmI4zp3C67WOKHwuIEwAsQKtH/f/KZ6VoEcCZjldECP/Yzj03sTBZKm9uMTzlFEIcKLAZLGcwHm1monAs+xchDP8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713976482; c=relaxed/simple;
	bh=LAqU2RXv/K06V39uC1ZFzQ2WUgBMOPwtNYqh5g12UoI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kQaOXGkQmOfRPoINonQKUxsPqxqM3R9o3i0xVvYD/65hLUp2OE71fhV528fE2xIJaOH+dCZ3lcobhVLUWUj/A+FL+vUu9neecGmqxD3YiM3hjWtSeOzdZ4wWbK7Y4fJs8aN4aQgcNeWswKCrCmNksvNmmFM3Be50rYu6ejPOI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YhFwuJse; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YhFwuJse"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-34665dd7610so3791051f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 09:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713976477; x=1714581277; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pq+9GCqWI+kzP/NgFcQ086URGXCxbL03OKJVfeD1UQE=;
        b=YhFwuJseAkf7nh401yMQHxBk/uP0mJotFFhfHAZt+ut2Zk9T1cxL8amo6cqWuVFVEC
         3tLb7B+eCxtCdu+mAdLkc6VYCQMMm4oPTUJzMgdDA14U28cz+E9dCh8h0vJJeKyhfceq
         YHNyQBEaw+FAD4E6jY8t/EDhri5FzhezUJIKjrCiweHgSquTwjR36UOyqqviCQD1ukxR
         d/NTm/wbVDJYDGzhAnhz2FJWNHNIO6muM+PUA77HsyY/7pYGhNOzaV6jL+cAoaeESH7P
         oR6vGDKsK7VVejiXLRxTlsKZ62Yn49MjiT+cSPwE+Nni40buQuafBiLySf/IE5r+n/UE
         uvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713976477; x=1714581277;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pq+9GCqWI+kzP/NgFcQ086URGXCxbL03OKJVfeD1UQE=;
        b=vQtgMn3tFQgJOfqa7noFyta6kF9VAOmu4J4DGgU30R5qG2QcK7m5HcPtbkYFHpQRhp
         Te/NqKwkXHN3y+kGUJIsBlwrOJD7AbFjKQ0DHbB4iAGmhT/mwhRLmtp1MTOhjBp4tT6+
         DWLl0ZxrmbRH9gUhvs+heCoeMJ9dCMJ7m9uNQhxHXVeZ3gDJCeWxTioyxdgYrP9puV5P
         tHC1M1i0dEgdl/h11D3VKqr8EUTYOu47kTIBwjBFSmcRoEw7GpNTXXTv9frP/ArsFTRR
         j5umIZ/lbkjLJpY9jIyxLmzRfPF8qFEsBFq8yPASPNfsmOlYcHGFL2tH9znI2DPa9QI1
         7vnQ==
X-Gm-Message-State: AOJu0YwaAHkpRTktILm07QTf6TtlOR1eJHkJGGeYPbePeJ+lX+oipKga
	LYwcwAJqwe656xvIPIF88cc2IThvMZ+LiM9MRw/hSKP+D7AryS93QeT8nNQwaqQ=
X-Google-Smtp-Source: AGHT+IEBubnPRzqbJIfWC6b6bk+eYizqJ6DnOTRuZj1xZeS8R0+DlCcmEh/CiKisfJnAxYdsGlwOsw==
X-Received: by 2002:adf:db4b:0:b0:343:6b09:7551 with SMTP id f11-20020adfdb4b000000b003436b097551mr1843931wrj.38.1713976476693;
        Wed, 24 Apr 2024 09:34:36 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id b4-20020a5d6344000000b00347363b77dasm17447710wrw.33.2024.04.24.09.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 09:34:36 -0700 (PDT)
Message-ID: <439b76a2cdc7d044d2588315663bcca3a21063e2.camel@suse.com>
Subject: Re: [PATCH 2/3] libmultipath: change flush_on_last_del to fix a
 multipathd hang
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 24 Apr 2024 18:34:35 +0200
In-Reply-To: <20240423222536.2096486-3-bmarzins@redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
	 <20240423222536.2096486-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-04-23 at 18:25 -0400, Benjamin Marzinski wrote:
> Commit 9bd3482e ("multipathd: make flush_map() delete maps like the
> multipath command") Fixed an issue where deleting a queueing
> multipath
> device through multipathd could hang because the multipath device had
> outstanding IO, even thought the only openers of it at the time of

typo: "thought"

> deletion were the kpartx partition devices. However it is still
> possible
> to hang multipathd, because autoremoving the device when all paths
> have
> been deleted doesn't disable queueing. To reproduce this hang:
>=20
> 1. create a multipath device with a kpartx partition on top of it and
> no_path_retry set to either "queue" or something long enough to run
> all
> the commands in the reproduce before it expires.
> 2. disable all the paths to the device with something like
> 3. Write directly to the multipath device with something like
> 4. delete all the paths to the device with something like

something like what?


> Multipathd will be hung trying to delete the kpartx device because,
> as
> the last opener, it must flush the multipath device before closing
> it.
> Because it hangs holding the vecs_lock, multipathd will never disable
> queueing on the device, so it will hang forever, even if
> no_path_retry
> is set to a number.
>=20
> Mulitpath can currently be configured to avoid this hang by setting
>=20
> flush_on_last_del yes
>=20
> However there are good reasons why users wouldn't want to set that.
> They
> may need to be able to survive having all paths temporarily get
> deleted.
> I should note that this is a pretty rare corner case, since multipath
> automatically sets dev_loss_tmo so that it should not trigger before
> queueing is disabled.
>=20
> This commit avoids the hang by changing the possible values for
> flush_on_last_del to "never", "unused", and "always", and sets the
> default to "unused".=C2=A0 "always" works like "yes" did, "never" will no=
t
> disable queueing, and "unused" will only disable queueing if nothing
> has
> the kpartx devices or the multipath device open. In order to be safe,
> if
> the device has queue_if_no_paths set, and the remove is not a
> deferred
> one (and in case of "unused", the device is in-use) the autoremove
> will
> be skipped. Also, instead of just trusting the lack of
> "queue_if_no_paths" in the current mpp->features, multipathd will
> tell
> the kernel to disable queueing, just to be sure it actually is.
>=20
> I chose "unused" as the default because this should generally only
> cause
> multipathd to work differently from the users perspective when
> nothing
> has the multipath device open but it is queueing and there is
> outstanding IO. Without this change, it would have hung instead of
> failing the outstanding IO. However, I do understand that an argument
> could be made that "never" makes more sense as default, even though
> it
> will cause multipathd to skip autoremoves in cases where it wouldn't
> before.

How important is the autoremove feature, actually? I have do confess I
don't like it too much, anyway.

I'd actually vote to set the default to "never", even if that means a
change in the default behavior, unless someone convinces me that
autoremoving unused maps with no paths is actually the right thing to
do.

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/defaults.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
 2 +-
> =C2=A0libmultipath/dict.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 72 +++++++++++++++++++++++++++++++--
> --
> =C2=A0libmultipath/dict.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/hwtable.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 6 +--
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 4 +-
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 7 ++--
> =C2=A0multipath/multipath.conf.5.in | 20 +++++++---
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 42 +++++++++++++++++---
> =C2=A08 files changed, 127 insertions(+), 27 deletions(-)
>=20
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 64b633f2..ed08c251 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -43,7 +43,7 @@
> =C2=A0#define DEFAULT_PRIO		PRIO_CONST
> =C2=A0#define DEFAULT_PRIO_ARGS	""
> =C2=A0#define DEFAULT_CHECKER		TUR
> -#define DEFAULT_FLUSH		FLUSH_DISABLED
> +#define DEFAULT_FLUSH		FLUSH_UNUSED
> =C2=A0#define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
> =C2=A0#define DEFAULT_FORCE_SYNC	0
> =C2=A0#define UNSET_PARTITION_DELIM "/UNSET/"
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 5af036b7..546103f2 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -791,14 +791,70 @@ declare_def_snprint(checker_timeout,
> print_nonzero)
> =C2=A0declare_def_handler(allow_usb_devices, set_yes_no)
> =C2=A0declare_def_snprint(allow_usb_devices, print_yes_no)
> =C2=A0
> -declare_def_handler(flush_on_last_del, set_yes_no_undef)
> -declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef,
> DEFAULT_FLUSH)
> -declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
> -declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
> -declare_hw_handler(flush_on_last_del, set_yes_no_undef)
> -declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
> -declare_mp_handler(flush_on_last_del, set_yes_no_undef)
> -declare_mp_snprint(flush_on_last_del, print_yes_no_undef)
> +
> +static const char * const flush_on_last_del_optvals[] =3D {
> +	[FLUSH_NEVER] =3D "never",
> +	[FLUSH_ALWAYS] =3D "always",
> +	[FLUSH_UNUSED] =3D "unused",
> +};
> +
> +static int
> +set_flush_on_last_del(vector strvec, void *ptr, const char *file,
> int line_nr)
> +{
> +	int i;
> +	int *flush_val_ptr =3D (int *)ptr;
> +	char *buff;
> +
> +	buff =3D set_value(strvec);
> +	if (!buff)
> +		return 1;
> +
> +	for (i =3D FLUSH_NEVER; i <=3D FLUSH_UNUSED; i++) {
> +		if (flush_on_last_del_optvals[i] !=3D NULL &&
> +		=C2=A0=C2=A0=C2=A0 !strcmp(buff, flush_on_last_del_optvals[i])) {
> +			*flush_val_ptr =3D i;
> +			break;
> +		}
> +	}
> +
> +	if (i > FLUSH_UNUSED) {
> +		bool deprecated =3D true;
> +		if (strcmp(buff, "no") =3D=3D 0 || strcmp(buff, "0") =3D=3D
> 0)
> +			*flush_val_ptr =3D FLUSH_UNUSED;
> +		else if (strcmp(buff, "yes") =3D=3D 0 || strcmp(buff,
> "1") =3D=3D 0)
> +			*flush_val_ptr =3D FLUSH_ALWAYS;
> +		else {
> +			deprecated =3D false;
> +			condlog(1, "%s line %d, invalid value for
> flush_on_last_del: \"%s\"",
> +				file, line_nr, buff);
> +		}
> +		if (deprecated)
> +			condlog(2, "%s line %d, \"%s\" is a
> deprecated value for flush_on_last_del and is treated as \"%s\"",
> +				file, line_nr, buff,
> +				flush_on_last_del_optvals[*flush_val
> _ptr]);
> +	}
> +
> +	free(buff);
> +	return 0;
> +}
> +
> +int
> +print_flush_on_last_del(struct strbuf *buff, long v)
> +{
> +	if (v =3D=3D FLUSH_UNDEF)
> +		return 0;
> +	return append_strbuf_quoted(buff,
> flush_on_last_del_optvals[(int)v]);
> +}
> +
> +declare_def_handler(flush_on_last_del, set_flush_on_last_del)
> +declare_def_snprint_defint(flush_on_last_del,
> print_flush_on_last_del,
> +			=C2=A0=C2=A0 DEFAULT_FLUSH)
> +declare_ovr_handler(flush_on_last_del, set_flush_on_last_del)
> +declare_ovr_snprint(flush_on_last_del, print_flush_on_last_del)
> +declare_hw_handler(flush_on_last_del, set_flush_on_last_del)
> +declare_hw_snprint(flush_on_last_del, print_flush_on_last_del)
> +declare_mp_handler(flush_on_last_del, set_flush_on_last_del)
> +declare_mp_snprint(flush_on_last_del, print_flush_on_last_del)
> =C2=A0
> =C2=A0declare_def_handler(user_friendly_names, set_yes_no_undef)
> =C2=A0declare_def_snprint_defint(user_friendly_names, print_yes_no_undef,
> diff --git a/libmultipath/dict.h b/libmultipath/dict.h
> index 7e2dfbe0..e1794537 100644
> --- a/libmultipath/dict.h
> +++ b/libmultipath/dict.h
> @@ -18,4 +18,5 @@ int print_undef_off_zero(struct strbuf *buff, long
> v);
> =C2=A0int print_dev_loss(struct strbuf *buff, unsigned long v);
> =C2=A0int print_off_int_undef(struct strbuf *buff, long v);
> =C2=A0int print_auto_resize(struct strbuf *buff, long v);
> +int print_flush_on_last_del(struct strbuf *buff, long v);
> =C2=A0#endif /* _DICT_H */
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 640bf347..ce600030 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -60,7 +60,7 @@
> =C2=A0		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> =C2=A0		.minio=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 1000,
> =C2=A0		.minio_rq=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 1,
> -		.flush_on_last_del =3D FLUSH_DISABLED,
> +		.flush_on_last_del =3D FLUSH_UNUSED,
> =C2=A0		.user_friendly_names =3D USER_FRIENDLY_NAMES_OFF,
> =C2=A0		.fast_io_fail=C2=A0 =3D 5,
> =C2=A0		.dev_loss=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 600,
> @@ -829,7 +829,7 @@ static struct hwentry default_hw[] =3D {
> =C2=A0		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
> =C2=A0		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_PRIO,
> =C2=A0		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_IMMEDIATE,
> -		.flush_on_last_del =3D FLUSH_ENABLED,
> +		.flush_on_last_del =3D FLUSH_ALWAYS,

How much sense do these hwtable entries make? In view of your commit
description, this seems to be a dangerous device default. It has the
surprising side effect that users who don't want flush_on_last_del will
need to set in either in the overrides section or in a dedicated device
section for the device at hand. This can be changed in a separate patch
of course.

> =C2=A0		.dev_loss=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D MAX_DEV_LOSS_TMO,
> =C2=A0		.prio_name=C2=A0=C2=A0=C2=A0=C2=A0 =3D PRIO_ONTAP,
> =C2=A0		.user_friendly_names =3D USER_FRIENDLY_NAMES_OFF,
> @@ -1160,7 +1160,7 @@ static struct hwentry default_hw[] =3D {
> =C2=A0		.no_path_retry =3D NO_PATH_RETRY_FAIL,
> =C2=A0		.minio=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 1,
> =C2=A0		.minio_rq=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 1,
> -		.flush_on_last_del =3D FLUSH_ENABLED,
> +		.flush_on_last_del =3D FLUSH_ALWAYS,
> =C2=A0		.fast_io_fail=C2=A0 =3D 15,
> =C2=A0	},
> =C2=A0	/*
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 44241e2a..e2dcb316 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -963,6 +963,7 @@ out:
> =C2=A0int select_flush_on_last_del(struct config *conf, struct multipath
> *mp)
> =C2=A0{
> =C2=A0	const char *origin;
> +	STRBUF_ON_STACK(buff);
> =C2=A0
> =C2=A0	mp_set_mpe(flush_on_last_del);
> =C2=A0	mp_set_ovr(flush_on_last_del);
> @@ -970,8 +971,9 @@ int select_flush_on_last_del(struct config *conf,
> struct multipath *mp)
> =C2=A0	mp_set_conf(flush_on_last_del);
> =C2=A0	mp_set_default(flush_on_last_del, DEFAULT_FLUSH);
> =C2=A0out:
> +	print_flush_on_last_del(&buff, mp->flush_on_last_del);
> =C2=A0	condlog(3, "%s: flush_on_last_del =3D %s %s", mp->alias,
> -		(mp->flush_on_last_del =3D=3D FLUSH_ENABLED)? "yes" :
> "no", origin);
> +		get_strbuf_str(&buff), origin);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 734905e2..a32f6d41 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -109,9 +109,10 @@ enum marginal_pathgroups_mode {
> =C2=A0};
> =C2=A0
> =C2=A0enum flush_states {
> -	FLUSH_UNDEF =3D YNU_UNDEF,
> -	FLUSH_DISABLED =3D YNU_NO,
> -	FLUSH_ENABLED =3D YNU_YES,
> +	FLUSH_UNDEF,
> +	FLUSH_NEVER,
> +	FLUSH_ALWAYS,
> +	FLUSH_UNUSED,
> =C2=A0};
> =C2=A0
> =C2=A0enum log_checker_err_states {
> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index c788c180..1463e1ea 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -707,12 +707,22 @@ The default is: \fBno\fR
> =C2=A0.TP
> =C2=A0.B flush_on_last_del
> =C2=A0If set to
> -.I yes
> +.I always
> =C2=A0, multipathd will disable queueing when the last path to a device
> has been
> -deleted.
> -.RS
> -.TP
> -The default is: \fBno\fR
> +deleted. If set to
> +.I never
> +, multipathd will not disable queueing when the last path to a
> device has
> +been deleted. Since multipath cannot safely remove a device while
> queueing
> +is enabled, setting this to \fInever\fR means that multipathd will
> not
> +automatically remove an unused multipath device whose paths are all
> deleted if
> +it is currently set to queue_if_no_path. If set to
> +.I unused
> +, multipathd will only disable queueing when the last path is
> removed if
> +nothing currently has the multipath device or any of the kpartx
> parition
> +devices on top of it open.
> +.RS
> +.TP
> +The default is: \fBunused\fR
> =C2=A0.RE
> =C2=A0.
> =C2=A0.
> diff --git a/multipathd/main.c b/multipathd/main.c
> index dd17d5c3..20780e7c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -583,13 +583,43 @@ int update_multipath (struct vectors *vecs,
> char *mapname)
> =C2=A0
> =C2=A0static bool
> =C2=A0flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
> -	int r;
> -
> +	int r, in_use =3D 1;
> +	int deferred_remove =3D 0;
> +	bool is_queueing =3D true;
> +
> +	if (mpp->features)
> +		is_queueing =3D strstr(mpp->features,
> "queue_if_no_path");
> +
> +	#ifdef LIBDM_API_DEFERRED
> +	deferred_remove =3D mpp->deferred_remove;
> +	#endif

Unusual indentation of the cpp directives here, and rather ugly in
general. Maybe we should implement a get_deferred_remove(mpp) helper.

> +
> +	/* It's not safe to do a non-deferred remove of a map that
> has
> +	 * "queue_if_no_path" set, since there could be outstanding
> IO which
> +	 * will cause multipathd to hang while attempting the remove
> */
> +	if (mpp->flush_on_last_del =3D=3D FLUSH_NEVER &&
> +	=C2=A0=C2=A0=C2=A0 !do_deferred(deferred_remove) && is_queueing) {
> +		condlog(2, "%s: map is queueing, can't remove", mpp-
> >alias);
> +		return false;
> +	}

Just a thought: Why don't we just pretend that deferred_remove is on if
flush_on_last_del is set to "never"? Wouldn't that avoid our issues?
In the same context, why haven't we made deferred_remove the default
yet?


> +	if (mpp->flush_on_last_del =3D=3D FLUSH_UNUSED &&
> +	=C2=A0=C2=A0=C2=A0 !do_deferred(deferred_remove) &&
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (in_u=
se =3D partmap_in_use(mpp->alias, NULL)) &&
> is_queueing) {
> +		condlog(2, "%s: map in use and queueing, can't
> remove",
> +			mpp->alias);
> +		return false;
> +	}

Same reasoning as above, why not just defer?

> =C2=A0	/*
> -	 * flush_map will fail if the device is open
> +	 * This will flush FLUSH_NEVER devices and FLUSH_UNUSED
> devices
> +	 * that are in use, but only if this is not a deferred
> remove, and

"that are not in use" ?

> +	 * they are already marked as not queueing. That is just to
> make
> +	 * absolutely certain that they really are not queueing like
> they
> +	 * claim.
> =C2=A0	 */
> -	if (mpp->flush_on_last_del =3D=3D FLUSH_ENABLED) {
> -		condlog(2, "%s Last path deleted, disabling
> queueing",
> +	if (mpp->flush_on_last_del =3D=3D FLUSH_ALWAYS ||
> +	=C2=A0=C2=A0=C2=A0 !do_deferred(deferred_remove) || !in_use) {
> +		condlog(is_queueing ? 2 : 3,
> +			"%s Last path deleted, disabling queueing",
> =C2=A0			mpp->alias);
> =C2=A0		mpp->retry_tick =3D 0;
> =C2=A0		mpp->no_path_retry =3D NO_PATH_RETRY_FAIL;
> @@ -597,7 +627,7 @@ flush_map_nopaths(struct multipath *mpp, struct
> vectors *vecs) {
> =C2=A0		mpp->stat_map_failures++;
> =C2=A0		dm_queue_if_no_path(mpp, 0);
> =C2=A0	}
> -	r =3D dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
> +	r =3D dm_flush_map_nopaths(mpp->alias, deferred_remove);

AFAIU, this line should only be executed if either disabling queueing
above succeeded, or do_deferred(deferred_remove) is true.
This code doesn't guarantee that, or am I overlooking something?

Regards,
Martin


> =C2=A0	if (r !=3D DM_FLUSH_OK) {
> =C2=A0		if (r =3D=3D DM_FLUSH_DEFERRED) {
> =C2=A0			condlog(2, "%s: devmap deferred remove",
> mpp->alias);

