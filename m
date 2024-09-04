Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D621CCB5C
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 18:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725476273; cv=none; b=jzJJZRqshTebzex3/6yk4BNnR4pV37yi+N/sfaQiAz4QJN9+HwEJD7Fwzdg93uEhasub3FzpuOQqFljJ2TqCOwsN5HRyr3CclvjeNWevS+KRpw4l40ATagVsf2HX8IuBzx7HnruEKGwgYpwZSyT24Nvf4VcEDzQhaMI/EJ6lczM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725476273; c=relaxed/simple;
	bh=RFpxOGK3DLLHPYsoza7Wp7/ZxKak8v1DAL8UIjWwzBc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d223MktGhjumeLuaTq/S92uwIRs+7PeUecaGdfnaTsZoQQORrtaUBiB3S7tjNumolds5PIT7WuV9sQkFviAZxFUPk57JsQoLaMTrsQJlWKjad/h7JH3Y6S+cn8LZ5QKAwbG4dtF8zpSgFbhMxSY+xmvkY77CleKY8P6WNpvuSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AEnCfufR; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AEnCfufR"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f029e9c9cfso87803051fa.2
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 11:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725476269; x=1726081069; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UrbwX1mEZBwSaguNlGX8Hd2w3ndt9NuO4KVL12bUvWg=;
        b=AEnCfufRT6Tns/Wz7VuLIQZYlnmNjBAM5SFtewfsWQQc6xFci6qnJX9l8GNLp7Cc4N
         yeYF3nAUzKHqJkV9h1skw+lpQiXDyHYtCHJ+hjrtEp8+F25L45Q3skMziztxytZQhGcE
         VH+7tKpfX1d7CNLxFuNBfYgeHi3144PngFNuKSrAHBP7ddiFs7robKSMV5f1pvB35hO4
         XUQKdDkR7w1XurQA9QM6TVsgHC3Jwv/mp2gqltZ+4ivNcPTRp8Gik421MTi4R3c2bWXV
         kqegLjkkDTi6E90NBZsQNzpo0dr64HDpU+PFBa/dSK97MKinGP2W6BRk0Ja41MP7M4+p
         hPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725476269; x=1726081069;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UrbwX1mEZBwSaguNlGX8Hd2w3ndt9NuO4KVL12bUvWg=;
        b=LFM/uFr5R4hEnwXrIB2M5C4tWp175IByEWM3W/ONYFc6SCtPBwu4yR+qGkKFPBV/6n
         b1M97dsJZVmMHMwF/aXqrzfuZ2i042uH2Okxh3wMPDnTh+NruK5FMX7AgGtKboQUJ04C
         NA2NjRSECCmmWvsAZm6/0tuYjo2yWOuuvWGfyxQKwjkiXjo9SArYu2GRHSLQwYvbPSmC
         GYrEEteuiuJxnOylQVrUklTlT7lBzOx6whn2fefSSyFv7bmn1rjwJxBILXYj3zAlAU0g
         BT00syUWsLC2Z/W9RCZ6RM8V+0Y1B23t5L/M7UT65QcOavIMW9YspWXoCJrg9F1SvbIZ
         ue7w==
X-Gm-Message-State: AOJu0Yw/PFxRuOwXAC0kH0nUlIdtA381ffrwpVJgV+9u9C28Lg5jC71k
	/tGTGhFILesWmtNmqmeuAYaLZ8VfKp+nHqnVMO23khgTrn88mtY0BcKoGLZ0lRolJSdje0UTIE2
	D
X-Google-Smtp-Source: AGHT+IF3VT1Qe9t8DGMRwADuCRJZ95smTynGIiifDXIygIikLnfS8vjv9AAB/f3bL3f6q4MEjAVqGQ==
X-Received: by 2002:a05:651c:2112:b0:2f5:7ed:abb0 with SMTP id 38308e7fff4ca-2f61070787emr206611441fa.26.1725476268000;
        Wed, 04 Sep 2024 11:57:48 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc698f69sm217522a12.71.2024.09.04.11.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 11:57:47 -0700 (PDT)
Message-ID: <053e43b8586abc36dd19f2ffee14cb0b31edb14f.camel@suse.com>
Subject: Re: [PATCH 13/15] multipathd: update priority once after updating
 all paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 20:57:46 +0200
In-Reply-To: <20240828221757.4060548-14-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-14-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> Instead of updating the path priorities and possibly reloading the
> multipath device when each path is updated, wait till all paths
> have been updated, and then go through the multipath devices updating
> the priorities once, reloading if necessary.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/structs.h |=C2=A0=C2=A0 9 +++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 169 +++++++++++++=
+++++++++++++-------------
> --
> =C2=A02 files changed, 118 insertions(+), 60 deletions(-)
>=20
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index af8e31e9..1f531d30 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -318,6 +318,7 @@ enum check_path_states {
> =C2=A0	CHECK_PATH_UNCHECKED,
> =C2=A0	CHECK_PATH_STARTED,
> =C2=A0	CHECK_PATH_CHECKED,
> +	CHECK_PATH_NEW_UP,
> =C2=A0	CHECK_PATH_SKIPPED,
> =C2=A0	CHECK_PATH_REMOVED,
> =C2=A0};
> @@ -421,6 +422,13 @@ enum prflag_value {
> =C2=A0	PRFLAG_SET,
> =C2=A0};
> =C2=A0
> +enum prio_update_type {
> +	PRIO_UPDATE_NONE,
> +	PRIO_UPDATE_NORMAL,
> +	PRIO_UPDATE_NEW_PATH,
> +	PRIO_UPDATE_MARGINAL,
> +};
> +
> =C2=A0struct multipath {
> =C2=A0	char wwid[WWID_SIZE];
> =C2=A0	char alias_old[WWID_SIZE];
> @@ -464,6 +472,7 @@ struct multipath {
> =C2=A0	int queue_mode;
> =C2=A0	unsigned int sync_tick;
> =C2=A0	int synced_count;
> +	enum prio_update_type prio_update;
> =C2=A0	uid_t uid;
> =C2=A0	gid_t gid;
> =C2=A0	mode_t mode;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2bcc6066..1511f701 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1996,15 +1996,13 @@ mpvec_garbage_collector (struct vectors *
> vecs)
> =C2=A0 * best pathgroup, and this is the first path in the pathgroup to
> come back
> =C2=A0 * up, then switch to this pathgroup */
> =C2=A0static int
> -followover_should_failback(struct path * pp)
> +do_followover_should_failback(struct path * pp)
> =C2=A0{
> =C2=A0	struct pathgroup * pgp;
> =C2=A0	struct path *pp1;
> =C2=A0	int i;
> =C2=A0
> -	if (pp->mpp->pgfailback !=3D -FAILBACK_FOLLOWOVER ||
> -	=C2=A0=C2=A0=C2=A0 !pp->mpp->pg || !pp->pgindex ||
> -	=C2=A0=C2=A0=C2=A0 pp->pgindex !=3D pp->mpp->bestpg)
> +	if (pp->pgindex !=3D pp->mpp->bestpg)
> =C2=A0		return 0;

What happened to the !pp->pgindex test? Is it not necessary any more?


> =C2=A0
> =C2=A0	pgp =3D VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
> @@ -2017,6 +2015,26 @@ followover_should_failback(struct path * pp)
> =C2=A0	return 1;
> =C2=A0}
> =C2=A0
> +static int
> +followover_should_failback(struct multipath *mpp)
> +{
> +	struct path *pp;
> +	struct pathgroup * pgp;
> +	int i, j;
> +
> +	if (mpp->pgfailback !=3D -FAILBACK_FOLLOWOVER || !mpp->pg ||
> !mpp->bestpg)
> +		return 0;
> +
> +	vector_foreach_slot (mpp->pg, pgp, i) {
> +		vector_foreach_slot (pgp->paths, pp, j) {
> +			if (pp->is_checked =3D=3D CHECK_PATH_NEW_UP &&
> +			=C2=A0=C2=A0=C2=A0 do_followover_should_failback(pp))
> +				return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> =C2=A0static void
> =C2=A0missing_uev_wait_tick(struct vectors *vecs)
> =C2=A0{
> @@ -2132,41 +2150,53 @@ partial_retrigger_tick(vector pathvec)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> -static int update_prio(struct path *pp, int force_refresh_all)
> +static bool update_prio(struct multipath *mpp, bool refresh_all)
> =C2=A0{
> =C2=A0	int oldpriority;
> -	struct path *pp1;
> +	struct path *pp;
> =C2=A0	struct pathgroup * pgp;
> -	int i, j, changed =3D 0;
> +	int i, j;
> +	bool changed =3D false;
> +	bool skipped_path =3D false;
> =C2=A0	struct config *conf;
> =C2=A0
> -	oldpriority =3D pp->priority;
> -	if (pp->state !=3D PATH_DOWN) {
> -		conf =3D get_multipath_config();
> -		pthread_cleanup_push(put_multipath_config, conf);
> -		pathinfo(pp, conf, DI_PRIO);
> -		pthread_cleanup_pop(1);
> +	vector_foreach_slot (mpp->pg, pgp, i) {
> +		vector_foreach_slot (pgp->paths, pp, j) {
> +			if (pp->state !=3D PATH_UP && pp->state !=3D
> PATH_GHOST)
> +				continue;

This test used to be pp->state =3D=3D PATH_DOWN (see below).

Just trying to confirm that you did this on purpose. It might justify a
separate patch, with rationale. After all, AFAICS, we will now keep the
old priority for all path states except PATH_UP and PATH_GHOST, while
previously we attempted to fetch the prio for most of them, and only
used the previous value if fetching the prio failed.

> +			if (!refresh_all &&
> +			=C2=A0=C2=A0=C2=A0 pp->is_checked !=3D CHECK_PATH_CHECKED) {
> +				skipped_path =3D true;
> +				continue;
> +			}
> +			oldpriority =3D pp->priority;
> +			conf =3D get_multipath_config();
> +			pthread_cleanup_push(put_multipath_config,
> conf);
> +			pathinfo(pp, conf, DI_PRIO);
> +			pthread_cleanup_pop(1);
> +			if (pp->priority !=3D oldpriority)
> +				changed =3D true;
> +		}
> =C2=A0	}
> -
> -	if (pp->priority !=3D oldpriority)
> -		changed =3D 1;
> -	else if (!force_refresh_all)
> -		return 0;
> -
> -	vector_foreach_slot (pp->mpp->pg, pgp, i) {
> -		vector_foreach_slot (pgp->paths, pp1, j) {
> -			if (pp1 =3D=3D pp || pp1->state =3D=3D PATH_DOWN)
> +	if (!changed || !skipped_path)
> +		return changed;
> +	/*
> +	 * If a path changed priorities, refresh the priorities of
> any
> +	 * paths we skipped
> +	 */
> +	vector_foreach_slot (mpp->pg, pgp, i) {
> +		vector_foreach_slot (pgp->paths, pp, j) {
> +			if (pp->state !=3D PATH_UP && pp->state !=3D
> PATH_GHOST)
> +				continue;
> +			if (pp->is_checked =3D=3D CHECK_PATH_CHECKED)
> =C2=A0				continue;
> -			oldpriority =3D pp1->priority;
> =C2=A0			conf =3D get_multipath_config();
> =C2=A0			pthread_cleanup_push(put_multipath_config,
> conf);
> -			pathinfo(pp1, conf, DI_PRIO);
> +			pathinfo(pp, conf, DI_PRIO);
> =C2=A0			pthread_cleanup_pop(1);
> -			if (pp1->priority !=3D oldpriority)
> -				changed =3D 1;
> =C2=A0		}
> =C2=A0	}
> -	return changed;
> +	return true;
> =C2=A0}
> =C2=A0
> =C2=A0static int reload_map(struct vectors *vecs, struct multipath *mpp,
> @@ -2393,14 +2423,12 @@ static int
> =C2=A0update_path_state (struct vectors * vecs, struct path * pp)
> =C2=A0{
> =C2=A0	int newstate;
> -	int new_path_up =3D 0;
> =C2=A0	int chkr_new_path_up =3D 0;
> =C2=A0	int disable_reinstate =3D 0;
> =C2=A0	int oldchkrstate =3D pp->chkrstate;
> =C2=A0	unsigned int checkint, max_checkint;
> =C2=A0	struct config *conf;
> -	int marginal_pathgroups, marginal_changed =3D 0;
> -	bool need_reload;
> +	int marginal_pathgroups;
> =C2=A0
> =C2=A0	conf =3D get_multipath_config();
> =C2=A0	checkint =3D conf->checkint;
> @@ -2462,7 +2490,7 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0			}
> =C2=A0			if (!pp->marginal) {
> =C2=A0				pp->marginal =3D 1;
> -				marginal_changed =3D 1;
> +				pp->mpp->prio_update =3D
> PRIO_UPDATE_MARGINAL;
> =C2=A0			}
> =C2=A0		} else {
> =C2=A0			if (pp->marginal || pp->state =3D=3D
> PATH_DELAYED)
> @@ -2470,7 +2498,7 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0					pp->dev);
> =C2=A0			if (marginal_pathgroups && pp->marginal) {
> =C2=A0				pp->marginal =3D 0;
> -				marginal_changed =3D 1;
> +				pp->mpp->prio_update =3D
> PRIO_UPDATE_MARGINAL;
> =C2=A0			}
> =C2=A0		}
> =C2=A0	}
> @@ -2537,7 +2565,8 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0		 */
> =C2=A0		if (!disable_reinstate)
> =C2=A0			reinstate_path(pp);
> -		new_path_up =3D 1;
> +		if (pp->mpp->prio_update !=3D PRIO_UPDATE_MARGINAL)
> +			pp->mpp->prio_update =3D PRIO_UPDATE_NEW_PATH;
> =C2=A0
> =C2=A0		if (oldchkrstate !=3D PATH_UP && oldchkrstate !=3D
> PATH_GHOST)
> =C2=A0			chkr_new_path_up =3D 1;
> @@ -2588,38 +2617,48 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0				LOG_MSG(2, pp);
> =C2=A0		}
> =C2=A0	}
> -
> +	if (pp->mpp->prio_update =3D=3D PRIO_UPDATE_NONE &&
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (news=
tate =3D=3D PATH_UP || newstate =3D=3D PATH_GHOST))
> +		pp->mpp->prio_update =3D PRIO_UPDATE_NORMAL;
> =C2=A0	pp->state =3D newstate;
> +	return chkr_new_path_up ? CHECK_PATH_NEW_UP :
> CHECK_PATH_CHECKED;
> +}
> =C2=A0
> -	if (pp->mpp->wait_for_udev)
> -		return CHECK_PATH_CHECKED;
> -	/*
> -	 * path prio refreshing
> -	 */
> -	condlog(4, "path prio refresh");
> -
> -	if (marginal_changed) {
> -		update_prio(pp, 1);
> -		reload_and_sync_map(pp->mpp, vecs);
> -	} else if (update_prio(pp, new_path_up) &&
> -		=C2=A0=C2=A0 pp->mpp->pgpolicyfn =3D=3D (pgpolicyfn
> *)group_by_prio &&
> -		=C2=A0=C2=A0 pp->mpp->pgfailback =3D=3D -FAILBACK_IMMEDIATE) {
> +static int
> +update_mpp_prio(struct vectors *vecs, struct multipath *mpp)
> +{
> +	bool need_reload, changed;
> +	enum prio_update_type prio_update =3D mpp->prio_update;
> +	mpp->prio_update =3D PRIO_UPDATE_NONE;
> +
> +	if (mpp->wait_for_udev || prio_update =3D=3D PRIO_UPDATE_NONE)
> +		return 0;
> +	condlog(4, "prio refresh");
> +
> +	changed =3D update_prio(mpp, prio_update !=3D
> PRIO_UPDATE_NORMAL);
> +	if (prio_update =3D=3D PRIO_UPDATE_MARGINAL)
> +		return reload_and_sync_map(mpp, vecs);
> +	if (changed && mpp->pgpolicyfn =3D=3D (pgpolicyfn
> *)group_by_prio &&
> +	=C2=A0=C2=A0=C2=A0 mpp->pgfailback =3D=3D -FAILBACK_IMMEDIATE) {
> =C2=A0		condlog(2, "%s: path priorities changed. reloading",
> -			pp->mpp->alias);
> -		reload_and_sync_map(pp->mpp, vecs);
> -	} else if (need_switch_pathgroup(pp->mpp, &need_reload)) {
> -		if (pp->mpp->pgfailback > 0 &&
> -		=C2=A0=C2=A0=C2=A0 (new_path_up || pp->mpp->failback_tick <=3D 0))
> -			pp->mpp->failback_tick =3D pp->mpp->pgfailback
> + 1;
> -		else if (pp->mpp->pgfailback =3D=3D -FAILBACK_IMMEDIATE
> ||
> -			 (chkr_new_path_up &&
> followover_should_failback(pp))) {
> +			mpp->alias);
> +		return reload_and_sync_map(mpp, vecs);
> +	}
> +	if (need_switch_pathgroup(mpp, &need_reload)) {
> +		if (mpp->pgfailback > 0 &&
> +		=C2=A0=C2=A0=C2=A0 (prio_update =3D=3D PRIO_UPDATE_NEW_PATH ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0 mpp->failback_tick <=3D 0))
> +			mpp->failback_tick =3D mpp->pgfailback + 1;
> +		else if (mpp->pgfailback =3D=3D -FAILBACK_IMMEDIATE ||
> +			 (prio_update =3D=3D PRIO_UPDATE_NEW_PATH &&
> +			=C2=A0 followover_should_failback(mpp))) {
> =C2=A0			if (need_reload)
> -				reload_and_sync_map(pp->mpp, vecs);
> +				return reload_and_sync_map(mpp,
> vecs);
> =C2=A0			else
> -				switch_pathgroup(pp->mpp);
> +				switch_pathgroup(mpp);
> =C2=A0		}
> =C2=A0	}
> -	return CHECK_PATH_CHECKED;
> +	return 0;
> =C2=A0}
> =C2=A0
> =C2=A0static int
> @@ -2859,7 +2898,7 @@ update_paths(struct vectors *vecs, int
> *num_paths_p, time_t start_secs)
> =C2=A0			i--;
> =C2=A0		else {
> =C2=A0			pp->is_checked =3D rc;
> -			if (rc =3D=3D CHECK_PATH_CHECKED)
> +			if (rc =3D=3D CHECK_PATH_CHECKED ||
> CHECK_PATH_NEW_UP)
> =C2=A0				(*num_paths_p)++;
> =C2=A0		}
> =C2=A0		if (++paths_checked % 128 =3D=3D 0 &&
> @@ -2932,8 +2971,10 @@ checkerloop (void *ap)
> =C2=A0			vector_foreach_slot(vecs->mpvec, mpp, i)
> =C2=A0				mpp->synced_count =3D 0;
> =C2=A0			if (checker_state =3D=3D CHECKER_STARTING) {
> -				vector_foreach_slot(vecs->mpvec,
> mpp, i)
> +				vector_foreach_slot(vecs->mpvec,
> mpp, i) {
> =C2=A0					sync_mpp(vecs, mpp, ticks);
> +					mpp->prio_update =3D
> PRIO_UPDATE_NONE;
> +				}
> =C2=A0				vector_foreach_slot(vecs->pathvec,
> pp, i)
> =C2=A0					pp->is_checked =3D
> CHECK_PATH_UNCHECKED;
> =C2=A0				checker_state =3D
> CHECKER_CHECKING_PATHS;
> @@ -2943,6 +2984,14 @@ checkerloop (void *ap)
> =C2=A0			if (checker_state =3D=3D CHECKER_UPDATING_PATHS)
> =C2=A0				checker_state =3D update_paths(vecs,
> &num_paths,
> =C2=A0							=C2=A0=C2=A0=C2=A0=C2=A0
> start_time.tv_sec);
> +			if (checker_state =3D=3D CHECKER_FINISHED) {
> +				vector_foreach_slot(vecs->mpvec,
> mpp, i) {
> +					if (update_mpp_prio(vecs,
> mpp) =3D=3D 2) {
> +						/* multipath device
> deleted */
> +						i--;
> +					}
> +				}
> +			}
> =C2=A0			lock_cleanup_pop(vecs->lock);
> =C2=A0			if (checker_state !=3D CHECKER_FINISHED) {
> =C2=A0				/* Yield to waiters */

