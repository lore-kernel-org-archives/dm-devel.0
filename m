Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E54145B2B
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 20:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721334259; cv=none; b=dkrD3M36Cs1KciIMHvPLFqydkH/XpzDmNN0vXmD95ZjD6IN0sBtzAe646knqpARlNuQgh6r3C1BnG0d7c+iuEHdAhi6icy/T1C9W9V/IvBcKtjgtbCTxkwN9Ee/pZPMsWBfGH36yJcya9FqSjPSAzhZLhhW+rrqrIl7ZLdnjSyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721334259; c=relaxed/simple;
	bh=mQEvs4ikyhSBdEEVMW8SKRzTV1AtOHefjGuNAtDatBY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G2q9U0EXMv1jP++3NKdD0eZTz3tXi9YwHCdIGKf+cV+b7bLHrqTKl+0dbW6XN/iO+5cwM42GNqy2u5U19H/Ii58Y+D9CtdFot8j6IysGA7dY3VbCnDjJ9cU62k5Lldhdvjf/LalSfCY+Qf3mO5EF610qssyU58NhsO87OEB+ATI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SFaHSsIM; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SFaHSsIM"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a77c080b521so121898866b.3
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 13:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721334255; x=1721939055; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6aUIsWJrPVxmiv+dyaoa+usoJAruDING7Buqkxx/sGA=;
        b=SFaHSsIMxK2PA17cyY4UEbbXLEH3dkQvgErGC5yJuWGEfmIG5IXOam74z8ydCZkNH2
         ekLzgv3kKG0MluGeSZumWry4pccdgBYgD0QrzDQrvoX6rR+oiI7xgXJ7wmySxXrKbmVG
         eoab7noGysPBlUBmo2wzgQUjASF4hVX2fNU8kbfUWMK0RaUD6fI5XZ0zECHN1Wpp+M6b
         GqV8nSWtNX0DU54PbZAT0DJDXUPYz2SfKuLedW5RHal4JqSxXU0o6mRfI4yYPQ7ZqkpB
         jXmKrQm8N3JRp1aI7/hmZvH0ssby86D47V/reDX8+srKAcH7Tvp3OuxzPlOraH50BUo2
         YlAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721334255; x=1721939055;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6aUIsWJrPVxmiv+dyaoa+usoJAruDING7Buqkxx/sGA=;
        b=t5F303LOZzumtBl8lhCVGR+DJ99alTpz0FHIoXXiFxRcLKMYZi7WRaYVcCu7CZKEJ2
         0fScfPHK3c6TzFOe1v2t+h5usxriwB62Rs4VPAiPS7yUc2zOIOQuGixq2P1boG3FxbQm
         WqE07q1Ez6Ash4alE/Vyw5PmDeULvSzIZSnch3y3n2tfkYUdjNgnllSlO1++rIfiBRc9
         Y3j6HcnJS4fI9xQY8rEFX+GViXLWSNrWYLrGfeqqV+mNHKZdcE2ZJAT8N95o+CaFMCmx
         Dt1yrJE+k0xenF6IDaDytvGWm24UvlayOJfKxTrWhzRezeLiflNRH3BPKtf1faOqKtB7
         9YMA==
X-Gm-Message-State: AOJu0YywxL5cB3ft6JTPkB+1HAvyk0AjMcX07u/5dYdGRDSjxERx8DHG
	Crbir2yvi69t3qfQRlm3ngz1xXnw8+e383U5nIh2NloOcxcGSfZ07e+wJgRThsU=
X-Google-Smtp-Source: AGHT+IGBb7Xjj1L2p3zM5bbvgjmS7zAL4XFIHMlIY8fUbdUTHLwD/JOVzHfoOD6gKiWjPfu1UpWPPg==
X-Received: by 2002:a17:906:584d:b0:a77:dc70:b369 with SMTP id a640c23a62f3a-a7a01154251mr408379166b.22.1721334255204;
        Thu, 18 Jul 2024 13:24:15 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc7f2361sm596213766b.120.2024.07.18.13.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 13:24:15 -0700 (PDT)
Message-ID: <745dd5f5611bc3e571af1d03a563c370f9161c9c.camel@suse.com>
Subject: Re: [PATCH v2 17/20] multipathd: make multipath devices manage
 their path check times
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 18 Jul 2024 22:24:13 +0200
In-Reply-To: <20240717181106.2173527-18-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
	 <20240717181106.2173527-18-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-17 at 14:11 -0400, Benjamin Marzinski wrote:
> multipathd's path checking can be very bursty, with all the paths
> running their path checkers at the same time, and then all doing
> nothing
> while waiting for the next check time. Alternatively, the paths in a
> multipath device might all run their path checkers at a different
> time,
> which can keep the multipath device from having a coherent view of
> the
> state of all of its paths.
>=20
> This patch makes all the paths of a multipath device converge to
> running
> their checkers at the same time, and spreads out when this time is
> for
> the different multipath devices.
>=20
> To do this, the checking time is divided into adjustment intervals
> (conf->adjust_int), so that the checkers run at some index within
> this
> interval. conf->adjust_int is chosen so that it is a multiple of all
> possible pp->checkint values. This means that regardless of
> pp->checkint, the path should always be checked on the same indexes,
> each adjustement interval.
>=20
> Each multipath device has a goal index. These are evenly spread out
> between 0 and conf->max_checkint. Every conf->adjust_int seconds,
> each
> multipath device should try to check all of its paths on its goal
> index.
> If the multipath device's check times are not aligned with the goal
> index, then pp->tick for the next check will be decremented by one,
> to
> align it over time.
>=20
> In order for the path checkers to run every pp->checkint seconds,
> multipathd needs to track how long a path check has been pending for,
> and subtract that time from the number of ticks till the checker is
> run
> again. If the checker has been pending for more that pp->checkint,
> the path will be rechecked on the next tick after the checker
> returns.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/config.c=C2=A0 | 12 ++++++
> =C2=A0libmultipath/config.h=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/structs.c |=C2=A0 1 +
> =C2=A0libmultipath/structs.h |=C2=A0 1 +
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 91 ++++++++++++++=
++++++++++++++++++++------
> --
> =C2=A05 files changed, 89 insertions(+), 17 deletions(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 83fa7369..a59533b5 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -982,6 +982,18 @@ int _init_config (const char *file, struct
> config *conf)
> =C2=A0		conf->checkint =3D conf->max_checkint;
> =C2=A0	condlog(3, "polling interval: %d, max: %d",
> =C2=A0		conf->checkint, conf->max_checkint);
> +	/*
> +	 * make sure that that adjust_int is a multiple of all
> possible values
> +	 * of pp->checkint.
> +	 */
> +	if (conf->max_checkint % conf->checkint =3D=3D 0) {
> +		conf->adjust_int =3D conf->max_checkint;
> +	} else {
> +		conf->adjust_int =3D conf->checkint;
> +		while (2 * conf->adjust_int < conf->max_checkint)
> +			conf->adjust_int *=3D 2;
> +		conf->adjust_int *=3D conf->max_checkint;
> +	}
> =C2=A0
> =C2=A0	if (conf->blist_devnode =3D=3D NULL) {
> =C2=A0		conf->blist_devnode =3D vector_alloc();
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 384193ab..800c0ca9 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -147,6 +147,7 @@ struct config {
> =C2=A0	int minio_rq;
> =C2=A0	unsigned int checkint;
> =C2=A0	unsigned int max_checkint;
> +	unsigned int adjust_int;
> =C2=A0	bool use_watchdog;
> =C2=A0	int pgfailback;
> =C2=A0	int rr_weight;
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 0a26096a..232b4230 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -149,6 +149,7 @@ uninitialize_path(struct path *pp)
> =C2=A0	pp->state =3D PATH_UNCHECKED;
> =C2=A0	pp->uid_attribute =3D NULL;
> =C2=A0	pp->checker_timeout =3D 0;
> +	pp->pending_ticks =3D 0;
> =C2=A0
> =C2=A0	if (checker_selected(&pp->checker))
> =C2=A0		checker_put(&pp->checker);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 002eeae1..457d7836 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -360,6 +360,7 @@ struct path {
> =C2=A0	unsigned long long size;
> =C2=A0	unsigned int checkint;
> =C2=A0	unsigned int tick;
> +	unsigned int pending_ticks;
> =C2=A0	int bus;
> =C2=A0	int offline;
> =C2=A0	int state;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 84450906..87ddb101 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2388,7 +2388,7 @@ enum check_path_return {
> =C2=A0};
> =C2=A0
> =C2=A0static int
> -check_path (struct vectors * vecs, struct path * pp, unsigned int
> ticks)
> +do_check_path (struct vectors * vecs, struct path * pp)
> =C2=A0{
> =C2=A0	int newstate;
> =C2=A0	int new_path_up =3D 0;
> @@ -2400,14 +2400,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0	int marginal_pathgroups, marginal_changed =3D 0;
> =C2=A0	bool need_reload;
> =C2=A0
> -	if (pp->initialized =3D=3D INIT_REMOVED)
> -		return CHECK_PATH_SKIPPED;
> -
> -	if (pp->tick)
> -		pp->tick -=3D (pp->tick > ticks) ? ticks : pp->tick;
> -	if (pp->tick)
> -		return CHECK_PATH_SKIPPED;
> -
> =C2=A0	conf =3D get_multipath_config();
> =C2=A0	checkint =3D conf->checkint;
> =C2=A0	max_checkint =3D conf->max_checkint;
> @@ -2419,12 +2411,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0		pp->checkint =3D checkint;
> =C2=A0	};
> =C2=A0
> -	/*
> -	 * provision a next check soonest,
> -	 * in case we exit abnormally from here
> -	 */
> -	pp->tick =3D checkint;
> -
> =C2=A0	newstate =3D check_path_state(pp);
> =C2=A0	if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED)
> =C2=A0		return CHECK_PATH_SKIPPED;
> @@ -2587,7 +2573,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0				condlog(4, "%s: delay next check
> %is",
> =C2=A0					pp->dev_t, pp->checkint);
> =C2=A0			}
> -			pp->tick =3D pp->checkint;
> =C2=A0		}
> =C2=A0	}
> =C2=A0	else if (newstate !=3D PATH_UP && newstate !=3D PATH_GHOST) {
> @@ -2640,6 +2625,77 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0	return CHECK_PATH_CHECKED;
> =C2=A0}
> =C2=A0
> +static int
> +check_path (struct vectors * vecs, struct path * pp, unsigned int
> ticks,
> +	=C2=A0=C2=A0=C2=A0 time_t start_secs)
> +{
> +	int r;
> +	unsigned int adjust_int, max_checkint;
> +	struct config *conf;
> +	time_t next_idx, goal_idx;
> +
> +	if (pp->initialized =3D=3D INIT_REMOVED)
> +		return CHECK_PATH_SKIPPED;
> +
> +	if (pp->tick)
> +		pp->tick -=3D (pp->tick > ticks) ? ticks : pp->tick;
> +	if (pp->tick)
> +		return CHECK_PATH_SKIPPED;
> +
> +	conf =3D get_multipath_config();
> +	max_checkint =3D conf->max_checkint;
> +	adjust_int =3D conf->adjust_int;
> +	put_multipath_config(conf);
> +
> +	r =3D do_check_path(vecs, pp);
> +
> +	/*
> +	 * do_check_path() removed or orphaned the path.
> +	 */
> +	if (r < 0 || !pp->mpp)
> +		return r;

do_check_path() returns an enum now, so this should be r =3D=3D
CHECK_PATH_REMOVED.


