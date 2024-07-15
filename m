Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2011804F
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721078403; cv=none; b=PocHQQCBWIk2M0YEHSt483YY5DNpi6tOnOAdBcfJAwh6DyIOzrliySIiVoNY/VJtf5YYIGNCJ0fOMUPRtfFO21td8UfHmu3+9OzR8rnL80TR+c4ljsHBfmu8br/yjETVGkV1nkp5X3pKKDjQNh2sGcqoGS/baxA6yo8C/2Au6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721078403; c=relaxed/simple;
	bh=wfZ2yMmhYuYHkvvW22GfdpFT9H1vCKDdk1f+HkIpdN8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PSt7FSzppCuOJRKg52tP2G2jgCZjrxmOFjqa5Hr/eXXGjMyGt0nQYuPzj4YkAJhPQBOJ0knKRwaC13MpBpzgMn4DxoyKY4BPwCbEEO5+pSLeshqaESwBzAlcVjvxt7J4lYRSfAZxBXaCWowwK45K/2jFeaTYrWF3YR4EylrKPjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MlyPnHBF; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MlyPnHBF"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77b60cafecso574546466b.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 14:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721078399; x=1721683199; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zHOMIFtALVAim2AOq50BYwCn0ta7UtGo0i5ixMrjmBU=;
        b=MlyPnHBFs6mhzdFBBJO9suA2j4oVW2tiKjsSPQfJ1VLL/AUKiHcfrKQuhJvUvcAkMy
         IHhRSZrpStzx8sw4wazJyQcyBxjP1iyHnXmTfBtV8lAGXOo+x4HlqCAK3rQf1qIDpjRe
         SN2u/04nCKZ/AWmFqYeuZu2jTrMZVPdiGlbJz3YhKaDLRcgqYN85FA/Gr8jnCwcdxKxS
         bk9wWoLv69fi0DLWSzEVqTym+DS7HkJRfN2xtjuRO1w8Prk8Y3fDlViwTVcXmMUek/Le
         B4CJkrHL+vHJvz23FsjYwKGHs4YyoX+zKiUzBAVVmowUwXekYAEp/mgB8aBpGVaS2SWP
         bb9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721078399; x=1721683199;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zHOMIFtALVAim2AOq50BYwCn0ta7UtGo0i5ixMrjmBU=;
        b=l/WyI4JfkFpx8MB4PIH9M5xcc0KtzHtYDU4UIQjYQ9pCC3QON9RXPtXBKMVD0xP9Q0
         bjSgJylsuNr08L/CVy8Ou7o9HY8ZeWyFIGosSEcf/TyGhXQOLqEenuGXilwvG/CHM/M1
         8+THLWkZLfLUv7IP8pQ3BraxLPB3GNzM/p4OEPKrt5ev3ESeyGiCIj35AUATg8dEOJRr
         OUSONHzx65VMfEOHhCMbE+X73miAPCtL+T/Uk7JaL4lPLki7Vrtjy2BkNQzfFYXP+VfP
         UuHRpx72WBedX/7Be9YGxXqOt78CASxj97xEiZ2Omvy2QX3TKHYkJ69qto5pwVvH7bK1
         cutQ==
X-Gm-Message-State: AOJu0Yx4PJGwO2t9ffB/209IEJZWIpfqIhKQDPjyvi+vMLY81EJ6ihJV
	QuR6LaSP3v6POuocZTLH+JmY03jIZnIXVgRjn0XlEwOXFNE+mj+UAranARHaPf8=
X-Google-Smtp-Source: AGHT+IHxFmUBIlmKpUgm2dwAlHu4H1JSSND/aD5ZrcscPjhANFvIdIe2K0sQaQG3mnBzjBzsOSDPAg==
X-Received: by 2002:a17:906:4107:b0:a75:4723:b3b3 with SMTP id a640c23a62f3a-a79eaa31a1fmr12951666b.44.1721078398554;
        Mon, 15 Jul 2024 14:19:58 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc822b36sm239703466b.223.2024.07.15.14.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 14:19:58 -0700 (PDT)
Message-ID: <a55e8f056b18f97cd40e27d7262cd0640d036967.camel@suse.com>
Subject: Re: [PATCH 21/22] multipathd: check paths in order by mpp
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 23:19:57 +0200
In-Reply-To: <20240713060506.2015463-22-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-22-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> Instead of checking all of the paths in vecs->pathvec in order, first
> check all the paths in each multipath device. Then check the
> uninitialized paths.
>=20
> One issue with checking paths this way is that the multipath device
> can
> be resynced or even removed while a path is being checked. The path
> can
> also be removed. If there is any change to the multipath device,
> multipathd needs to loop through its paths again, because the current
> indexes may not longer be valid.
>=20
> To do this change mpp->is_checked to an int called mpp->synced_count,
> and increment it whenever the multipath device gets resynced. After
> each
> path is checked, make sure that the multipath device still exists,
> that
> mpp->synced_count hasn't changed. If either has happened, restart
> checking at the current index in mpvec (which will either be the same
> mpp if it was just resynced, or the next mpp if the last one was
> deleted). Since the multipath device is resynced when its first path
> is
> checked, this restart will happen to every multipath device at least
> once per loop. But the paths themselves aren't rechecked, so it's not
> much overhead.

Why don't we just sync the map once before we start checking the paths,
instead of doing it when the first path is checked?=20

> If resyncing a multipath device fails in do_check_mpp(), there may be
> path devices that have pp->mpp set, but are no longer in one of the
> multipath device's pathgroups, and thus will not get checked. This
> almost definitely means the multipath device was deleted. If
> do_check_mpp() failed to resync the device, but it wasn't deleted, it
> will get called again in max_checkint seconds even if it no longer
> has
> mpp->pg set, and the paths will get checked again after that.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0libmultipath/structs_vec.c |=C2=A0 1 +
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 54 ++++++++++++++++++++++++++++++++----
> --
> =C2=A03 files changed, 48 insertions(+), 9 deletions(-)
>=20
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 457d7836..91509881 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -455,7 +455,7 @@ struct multipath {
> =C2=A0	int ghost_delay_tick;
> =C2=A0	int queue_mode;
> =C2=A0	unsigned int sync_tick;
> -	bool is_checked;
> +	int synced_count;
> =C2=A0	uid_t uid;
> =C2=A0	gid_t gid;
> =C2=A0	mode_t mode;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 60360c76..704e0f21 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -513,6 +513,7 @@ update_multipath_table (struct multipath *mpp,
> vector pathvec, int flags)
> =C2=A0	conf =3D get_multipath_config();
> =C2=A0	mpp->sync_tick =3D conf->max_checkint;
> =C2=A0	put_multipath_config(conf);
> +	mpp->synced_count++;
> =C2=A0
> =C2=A0	r =3D libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> =C2=A0			=C2=A0 (mapid_t) { .str =3D mpp->alias },
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 27e18a0c..d51bc852 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2356,7 +2356,6 @@ do_check_mpp(struct vectors * vecs, struct
> multipath *mpp)
> =C2=A0	int i, ret;
> =C2=A0	struct path *pp;
> =C2=A0
> -	mpp->is_checked =3D true;
> =C2=A0	ret =3D update_multipath_strings(mpp, vecs->pathvec);
> =C2=A0	if (ret !=3D DMP_OK) {
> =C2=A0		condlog(1, "%s: %s", mpp->alias, ret =3D=3D
> DMP_NOT_FOUND ?
> @@ -2428,7 +2427,7 @@ do_check_path (struct vectors * vecs, struct
> path * pp)
> =C2=A0		condlog(0, "%s: path wwid change detected.
> Removing", pp->dev);
> =C2=A0		return handle_path_wwid_change(pp, vecs)? -1 : 0;
> =C2=A0	}
> -	if (!pp->mpp->is_checked) {
> +	if (pp->mpp->synced_count =3D=3D 0) {
> =C2=A0		do_check_mpp(vecs, pp->mpp);
> =C2=A0		/* if update_multipath_strings orphaned the path,
> quit early */
> =C2=A0		if (!pp->mpp)
> @@ -2787,18 +2786,57 @@ check_paths(struct vectors *vecs, unsigned
> int ticks, int *num_paths_p)
> =C2=A0{
> =C2=A0	unsigned int paths_checked =3D 0;
> =C2=A0	struct timespec diff_time, start_time, end_time;
> +	struct multipath *mpp;
> =C2=A0	struct path *pp;
> =C2=A0	int i, rc;
> =C2=A0
> =C2=A0	get_monotonic_time(&start_time);
> +
> +	vector_foreach_slot(vecs->mpvec, mpp, i) {
> +		struct pathgroup *pgp;
> +		struct path *pp;
> +		int j, k;
> +		bool check_for_waiters =3D false;
> +		/* maps can be rechecked, so this is not always 0 */
> +		int synced_count =3D mpp->synced_count;
> +
> +		vector_foreach_slot (mpp->pg, pgp, j) {
> +			vector_foreach_slot (pgp->paths, pp, k) {
> +				if (!pp->mpp || pp->is_checked)
> +					continue;
> +				pp->is_checked =3D true;
> +				rc =3D check_path(vecs, pp, ticks,
> +						start_time.tv_sec);
> +				if (rc > 0)
> +					*num_paths_p +=3D 1;
> +				if (++paths_checked % 128 =3D=3D 0)
> +					check_for_waiters =3D true;
> +				/*
> +				 * mpp has been removed or resynced.
> Path may
> +				 * have been removed.
> +				 */
> +				if (VECTOR_SLOT(vecs->mpvec, i) !=3D
> mpp ||
> +				=C2=A0=C2=A0=C2=A0 synced_count !=3D mpp-
> >synced_count) {
> +					i--;
> +					goto next_mpp;
> +				}

I'm aware that you have implemented the rather vague idea I had
mentioned previously, thanks a lot for that.

This is ok, but the fact that the arrays we are looping over can be
modified deeply inside functions inside the loop feels fragile.=C2=A0I
wonder if it would be possible to clean up our code flow such that
neither mpp nor path objects can be removed at this point the code.=C2=A0

The sync code could set flags on paths and / or multipath objects that
tell the caller that these objects are no longer valid, and we could
remove them when we're done with the loop. I'm aware that we'd still
need to cover path group changes.=C2=A0Perhaps we should create a temporary
array of all paths in the map (possibly sorted by major/minor number).
We'd ignore newly added paths (they should have been checked recently
anyway, shouldn't they?) and skip over paths that are flagged as being
removed.

I realize I'm making vague suggestions again. Your current work shows
that this is more complicated than I first imagined. Thanks a lot for
considering all the corner cases.

This isn't something I'd expect to change in the current patch set,
just something to think about for the future.


> +			}
> +		}
> +next_mpp:
> +		if (check_for_waiters &&
> +		=C2=A0=C2=A0=C2=A0 (lock_has_waiters(&vecs->lock) ||
> waiting_clients())) {
> +			get_monotonic_time(&end_time);
> +			timespecsub(&end_time, &start_time,
> &diff_time);
> +			if (diff_time.tv_sec > 0)
> +				return CHECKER_RUNNING;
> +		}
> +	}
> =C2=A0	vector_foreach_slot(vecs->pathvec, pp, i) {
> -		if (pp->is_checked)
> +		if (pp->mpp || pp->is_checked)
> =C2=A0			continue;
> =C2=A0		pp->is_checked =3D true;
> -		if (pp->mpp)
> -			rc =3D check_path(vecs, pp, ticks,
> start_time.tv_sec);
> -		else
> -			rc =3D handle_uninitialized_path(vecs, pp,
> ticks);
> +
> +		rc =3D handle_uninitialized_path(vecs, pp, ticks);
> =C2=A0		if (rc < 0)
> =C2=A0			i--;
> =C2=A0		else
> @@ -2871,7 +2909,7 @@ checkerloop (void *ap)
> =C2=A0			lock(&vecs->lock);
> =C2=A0			pthread_testcancel();
> =C2=A0			vector_foreach_slot(vecs->mpvec, mpp, i)
> -				mpp->is_checked =3D false;
> +				mpp->synced_count =3D 0;

Why do we need to reset this? Can't we just increment the counter
whenever we sync, and let it wrap at UINT_MAX?

> =C2=A0			if (checker_state =3D=3D CHECKER_STARTING) {
> =C2=A0				vector_foreach_slot(vecs->mpvec,
> mpp, i)
> =C2=A0					check_mpp(vecs, mpp, ticks);

