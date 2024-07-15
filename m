Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC031C6A3
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721060639; cv=none; b=cP2ZuAa8G2QPzUcoTLA1P/Pr/U0NWUuDBwGkSP4pSsdd0/b24+8hmh8X+qKvMay0yPScuXZwG2dotTatAZnzfzYsrZno3/TU+LbN2eaPnDcFgZriE3ahLJmLAv22Hj1OctHx8VoLpzM4TtcHKt/ONd9BshYrTDe2wQi+2N3riYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721060639; c=relaxed/simple;
	bh=k7A7pt+rJGQodKysmTlRDIwRLSJKhNtCbg3i4dKiFBs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wd7dA8+uhUAer+gHauTq9znPdyXAoxC45f8kgB/1abCm6auRfskpw1efz+jlnq51cbbRp2e2uQmYi9G9C+dvfQ+wtJoHWOdiIlvIC8F1/Y4TqgDkwxCv56IVfaU7tzgowxO3jyasy/c+Fy8ghx8rcvLT0pFCKDCdel5U9m1/VWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Uy1zJFu8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Uy1zJFu8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4279c924ca7so26891745e9.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 09:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721060636; x=1721665436; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FxJHut8OvBFxQn3OEX0KxE4QVRNcu1wGdJvW1Urn9Wk=;
        b=Uy1zJFu8kEhyFVT3pDwA/uJveTAbg1sz+iMITu7DNipTDJqfl9DlF84pOKeHeahus2
         E6rgOVAKTkQuoLjtDzHPfqIThK6BAhDqqW9zxxthWus1DzSieA+lZEcFcuqc52+EiSkI
         A5+JNpjmJs/ziRKTlcf6sWtT84z+UcPWhdZvw7NJ3lq8ui76XDBjue5mkeG+DIbP4wwS
         8KQGI+Mr3n6wVCA8VGFkfabq2xUzo9slyRT5Z8FkVR9Meb3hcV49G6uK9PUSf9CWT94T
         k15HGYJjDAIp9tkZO8eCuGmsU2p/xFdeoeYb5vTk3er2b3dV2TZoHUgwaiilN84bxb+O
         5Bmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721060636; x=1721665436;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FxJHut8OvBFxQn3OEX0KxE4QVRNcu1wGdJvW1Urn9Wk=;
        b=ZEVZzb73bzqVvhslnuT+uA9c9DCX2FpYL+dtFjIxOdb76BT/c8Ywd1eDF+pFerb1eh
         h/bMEQdbnaiGdNOHP9sK9ZLaVIOB/jE2X3yhlY7lLCAIekA2jrlY311ulIS6Tbk+Tzbh
         ZKnWkq4RW8Zmo3pSFSZb23wVDz5C9MwWAubMeJfoGI2oF/yRZGTgs39Q2Qm6vh8NuscD
         la9VbBoIfOuAblHutD6N4Wn+keCILKnG/zpW1u6N4tTzlqQj+kfR405c9Np1PF6pvMXF
         je5cXdeqCPQb5/9UQf37/gOFu6FeKyc1BtqqLzYxlMWWny0vHFPTAGNth24yrKvmF8KZ
         GP5A==
X-Gm-Message-State: AOJu0Yyw7L2eYMkIhHmCc0lGzb0hGytHURo3Jq/3vcnGVJoFym7H1Nd+
	pQ/qiUUaWizOGbZhHUwYJef3EqvzHKoK2WaJ1SRfW0VCZwoj9bMuWiXJG/Sfa0umwrAsltYgEAC
	G
X-Google-Smtp-Source: AGHT+IE+K8tdo7/nJ8D1VIV7oQcv5ipWTq3PyXqaHXRaHhKcu9/pMk/Ne0ucpiaoGglbUIVbRIYtyg==
X-Received: by 2002:a05:600c:3c9a:b0:426:6158:962d with SMTP id 5b1f17b1804b1-427b889803cmr1239725e9.23.1721060635421;
        Mon, 15 Jul 2024 09:23:55 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5ef4793sm93049635e9.43.2024.07.15.09.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:23:55 -0700 (PDT)
Message-ID: <b29efd52f75d1ef802c1b7e015657ee25d02bec1.camel@suse.com>
Subject: Re: [PATCH 12/22] multipathd: adjust when mpp is synced with the
 kernel
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 18:23:53 +0200
In-Reply-To: <20240713060506.2015463-13-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-13-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> Move the code to sync the mpp device state into a helper function and
> add a counter to to make sure that the device is synced at least once
> every max_checkint secs. This makes sure that multipath devices with
> no
> paths will still get synced with the kernel.=C2=A0 Also, if multiple path=
s
> are checked in the same loop, the multipath device will only be
> synced
> with the kernel once, since every time the mpp is synced in any code
> path, mpp->sync_tick is reset.
>=20
> The code still syncs the mpp before updating the path state for two
> main reasons.
>=20
> 1. Sometimes multipathd leaves the mpp with a garbage state. Future
> =C2=A0=C2=A0 patches will fix most of these cases, but the code intential=
ly
> =C2=A0=C2=A0 does not remove the mpp is resyncing fails while checking pa=
ths.
> =C2=A0=C2=A0 But this does leave the mpp with a garbage state.
>=20
> 2. The kernel chages the multipath state independently of multipathd.
> If
> =C2=A0=C2=A0 the kernel fails a path, a uevent will arrive shortly. But t=
he
> kernel
> =C2=A0=C2=A0 doesn't provide any notification when it switches the active
> =C2=A0=C2=A0 path group or if it ends up picking a different one than
> multipathd
> =C2=A0=C2=A0 selected. Multipathd needs to know the actual current pathgr=
oup to
> =C2=A0=C2=A0 know when it should be switching them.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/configure.c=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> =C2=A0libmultipath/structs_vec.c |=C2=A0 5 +++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 64 +++++++++++++++++++++++++-----------
> --
> =C2=A04 files changed, 50 insertions(+), 22 deletions(-)
>=20
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index fbd253ca..179fec24 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2342,6 +2342,37 @@ check_path_state(struct path *pp)
> =C2=A0	return newstate;
> =C2=A0}
> =C2=A0
> +static void
> +do_check_mpp(struct vectors * vecs, struct multipath *mpp)
> +{
> +	int i, ret;
> +	struct path *pp;
> +
> +	mpp->is_checked =3D true;
> +	ret =3D update_multipath_strings(mpp, vecs->pathvec);
> +	if (ret !=3D DMP_OK) {
> +		condlog(1, "%s: %s", mpp->alias, ret =3D=3D
> DMP_NOT_FOUND ?
> +			"device not found" :
> +			"couldn't synchronize with kernel state");
> +		vector_foreach_slot (mpp->paths, pp, i)
> +			pp->dmstate =3D PSTATE_UNDEF;
> +		return;
> +	}
> +	set_no_path_retry(mpp);
> +}
> +
> +static void
> +check_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int
> ticks)
> +{
> +	if (mpp->sync_tick)
> +		mpp->sync_tick -=3D (mpp->sync_tick > ticks) ? ticks :
> +				=C2=A0 mpp->sync_tick;
> +	if (mpp->sync_tick)
> +		return;
> +
> +	do_check_mpp(vecs, mpp);
> +}
> +
> =C2=A0/*
> =C2=A0 * Returns '1' if the path has been checked and '0' otherwise
> =C2=A0 */
> @@ -2356,7 +2387,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0	unsigned int checkint, max_checkint;
> =C2=A0	struct config *conf;
> =C2=A0	int marginal_pathgroups, marginal_changed =3D 0;
> -	int ret;
> =C2=A0	bool need_reload;
> =C2=A0
> =C2=A0	if (pp->initialized =3D=3D INIT_REMOVED)
> @@ -2395,26 +2425,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0		pp->tick =3D 1;
> =C2=A0		return 0;
> =C2=A0	}
> -	/*
> -	 * Synchronize with kernel state
> -	 */
> -	ret =3D update_multipath_strings(pp->mpp, vecs->pathvec);
> -	if (ret !=3D DMP_OK) {
> -		if (ret =3D=3D DMP_NOT_FOUND) {
> -			/* multipath device missing. Likely removed
> */
> -			condlog(1, "%s: multipath device '%s' not
> found",
> -				pp->dev, pp->mpp ? pp->mpp->alias :
> "");
> -			return 0;
> -		} else
> -			condlog(1, "%s: Couldn't synchronize with
> kernel state",
> -				pp->dev);
> -		pp->dmstate =3D PSTATE_UNDEF;
> -	}
> -	/* if update_multipath_strings orphaned the path, quit early
> */
> -	if (!pp->mpp)
> -		return 0;
> -	set_no_path_retry(pp->mpp);
> -
> =C2=A0	if (pp->recheck_wwid =3D=3D RECHECK_WWID_ON &&
> =C2=A0	=C2=A0=C2=A0=C2=A0 (newstate =3D=3D PATH_UP || newstate =3D=3D PAT=
H_GHOST) &&
> =C2=A0	=C2=A0=C2=A0=C2=A0 ((pp->state !=3D PATH_UP && pp->state !=3D PATH=
_GHOST) ||
> @@ -2424,7 +2434,12 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0		handle_path_wwid_change(pp, vecs);
> =C2=A0		return 0;
> =C2=A0	}
> -
> +	if (!pp->mpp->is_checked) {
> +		do_check_mpp(vecs, pp->mpp);
> +		/* if update_multipath_strings orphaned the path,
> quit early */
> +		if (!pp->mpp)
> +			return 0;
> +	}
> =C2=A0	if ((newstate !=3D PATH_UP && newstate !=3D PATH_GHOST &&
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 newstate !=3D PATH_PENDING) && (pp->state=
 =3D=3D
> PATH_DELAYED)) {
> =C2=A0		/* If path state become failed again cancel path
> delay state */
> @@ -2752,12 +2767,17 @@ checkerloop (void *ap)
> =C2=A0		while (checker_state !=3D CHECKER_FINISHED) {
> =C2=A0			unsigned int paths_checked =3D 0, i;
> =C2=A0			struct timespec chk_start_time;
> +			struct multipath *mpp;
> =C2=A0
> =C2=A0			pthread_cleanup_push(cleanup_lock, &vecs-
> >lock);
> =C2=A0			lock(&vecs->lock);
> =C2=A0			pthread_testcancel();
> +			vector_foreach_slot(vecs->mpvec, mpp, i)
> +				mpp->is_checked =3D false;

Why is this not done inside the "if (checker_state =3D=3D CHECKER_STARTING)
code path?

Martin


> =C2=A0			get_monotonic_time(&chk_start_time);
> =C2=A0			if (checker_state =3D=3D CHECKER_STARTING) {
> +				vector_foreach_slot(vecs->mpvec,
> mpp, i)
> +					check_mpp(vecs, mpp, ticks);
> =C2=A0				vector_foreach_slot(vecs->pathvec,
> pp, i)
> =C2=A0					pp->is_checked =3D false;
> =C2=A0				checker_state =3D CHECKER_RUNNING;

