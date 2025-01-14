Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A0529406
	for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 21:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890574; cv=none; b=pE99D9ci1zo5RhFzpuL8lS+zkX9blNPhbxBccCPZrZC6hb8hHpRwJQk3OHhbUmW0LnO385qEnp3okOwOJllR/CdsedRXvMSocVu757jmBg3qFzCefwgvGyizctxjcb6AyzyZq10VTX7qDzwbh/SOV9ywuoZsSbv2JZOSbVmUAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890574; c=relaxed/simple;
	bh=eudm5YmGhXGVYab+OzXduT0q2rnzp2CqgXmwWiFKpQ4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FCLbKtciaLn5NOfBX40/j7mpAsD4arFvcFLe3E1l+0qNUDgRnjnO9Hdf5myGfa53BZjWGUmJ4bkmAfrFVJQ8EiACtYyq4KHdI45ryBHCP+qvUOdahDQJ18YM3iSXRhkBZf56rHIgfE3jnWn/rBLL5eXUO0ePWbsrVlfNTUjHj5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y7VeeUUb; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y7VeeUUb"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d88c355e0dso10592192a12.0
        for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 13:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736890570; x=1737495370; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CtykQ2sKNS/yh2CZ5VsJHOebdrNHKY5svGlA4xiJejo=;
        b=Y7VeeUUbZdRw4oYH0CcFjXEmLMtMZ3zrOaeXf238tiranLvB5Wo9t9+D5ncika3BLY
         EXf4UYZeVbT1mWlEKop4Ysj+xrX2gui0mbNBjx4b7he+S0FpabHQePvHFjBlY8T40hto
         K7VX02iYAFQHDOLBFXe8muBC9mk6tYn7swEhRDJtXtA/yl5v+lrTHA0qHPRwL+B+dLS4
         FoE1BJr7wnj61djemgf/bHnLoMDSKqZ/UYocDoyrymDALddJ5vGIMyBI5UsCaU7ZB7r/
         ZSWv2mCbyYZ9E+kB6A2BJiBD8cJXr360HXZg9atHQC0o0AOkiL++3IsmmXjYIKTBbeGY
         jXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736890570; x=1737495370;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CtykQ2sKNS/yh2CZ5VsJHOebdrNHKY5svGlA4xiJejo=;
        b=Zqlek4tbbnSuDuX15miGUnHTZAD8sAt17abJ3z2Ff17Csk6Comz735xHBl5k9SkeyS
         C4B7U3LOT0se2VGQrQxdkiYm7jbFg6LDb4qRc21VYQdP0t9joN8g8iUnycHATLjV+Pc+
         qFJUC9ybsse2qNKChuuhDXSorkbHVOSNA5kTizOdOwqCkbcmES5Wsge0VEB1MFKwLldC
         abo+XY/RmQZKS6QDD6RLwH/Aps097xj/rf1vr3IAUJAHOYfm38dsE1mCt9nU6SDogW1/
         QQrqfPonjPCfSjtxz57SEbAdl+grPlEA0GvR/1UIx2jUZbyw51OX9GcwdXavKD+ZGoJO
         vk2A==
X-Forwarded-Encrypted: i=1; AJvYcCXq8AskDYrMideJetMM78+ct2U5cMKzunYNOP4NtVm7gzzDp9o9oJeypOe9FRPCwIuo6GOu0Iv+vA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwWRv0Jqng2BMVzOAmS2UenZBEj1qedaAeCqLErBM56YwWv4Ojs
	IrbS21H1Lw2ocFC+RUl0E+4sd9qLK5kNT0vKLrn4q9puPeNys7qAJsRPu3Cq3jHLix+KAQXSol3
	g
X-Gm-Gg: ASbGncvzTGrtaC6RCA6tESNT3ujdqj3hTIQSxLSofuwooEJ7HQcN2MkcETsEM2V6G2O
	Xy90tFSN8evs0FKsgacUP5KowZA3VSaoL2ps824+vWo+WUMvurXzLTt5V/Bcsc7c82uJJF8WKz8
	ZbpKKbmVr64kuVgw4kXDliyUPCqLihgDmeaFX5qMteVMR5W6tiyH95gDbk+rj/IuMLk6JfA6D99
	uwt35UbcOBG/iWWP5qICnpOnXYF6erdHFNsiqqg4oX7WMt3Xr4MYGtLmXERO2YKeWcqpja+mP4X
	J0gX6UacSC/q7kyxeM69Hw2SPRDfhCBfv9o4uApSc4v/On2vzbq9quhlK8mgvqqnqFpu8T3OVLP
	RtCy34RheQsM6
X-Google-Smtp-Source: AGHT+IEwIWHPOJBMHyaQ2yG6kmgfZKHc6RWFpq1YRHvNrstn4Q80Vm0giy/cJUPO1zwuBnTadBfbDA==
X-Received: by 2002:a05:6402:26c5:b0:5d1:2377:5b07 with SMTP id 4fb4d7f45d1cf-5d972e00011mr27013111a12.6.1736890569307;
        Tue, 14 Jan 2025 13:36:09 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99046e048sm6471070a12.71.2025.01.14.13.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 13:36:08 -0800 (PST)
Message-ID: <5ae128660980dcc037e97a607668498408958638.camel@suse.com>
Subject: Re: [PATCH v2 03/14] multipathd: sync maps at end of checkerloop
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 14 Jan 2025 22:36:06 +0100
In-Reply-To: <Z2Smet8-Smj8Oyj_@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
	 <20241211225909.298770-4-mwilck@suse.com> <Z2Smet8-Smj8Oyj_@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-12-19 at 18:04 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 11, 2024 at 11:58:58PM +0100, Martin Wilck wrote:
> > Rather than calling sync_mpp early in the checkerloop and tracking
> > map synchronization with synced_count, call sync_mpp() in the
> > CHECKER_FINISHED
> > state, if either at least one path of the map has been checked in
> > the current
> > iteration, or the sync tick has expired. This avoids potentially
> > deleting
> > paths from the pathvec through the do_sync_mpp() ->
> > update_multipath_strings()
> > -> sync_paths -> check_removed_paths() call chain while we're
> > iterating over
> > the pathvec. Also, the time gap between obtaining path states and
> > syncing
> > the state with the kernel is smaller this way.
> >=20
> > Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> > =C2=A0libmultipath/structs_vec.c |=C2=A0 1 -
> > =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 26 +++++++++++---------------
> > =C2=A03 files changed, 12 insertions(+), 17 deletions(-)
> >=20
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 6a30c59..9d22bdd 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -471,7 +471,7 @@ struct multipath {
> > =C2=A0	int ghost_delay_tick;
> > =C2=A0	int queue_mode;
> > =C2=A0	unsigned int sync_tick;
> > -	int synced_count;
> > +	int checker_count;
> > =C2=A0	enum prio_update_type prio_update;
> > =C2=A0	uid_t uid;
> > =C2=A0	gid_t gid;
> > diff --git a/libmultipath/structs_vec.c
> > b/libmultipath/structs_vec.c
> > index 7a4e3eb..6aa744d 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -530,7 +530,6 @@ update_multipath_table (struct multipath *mpp,
> > vector pathvec, int flags)
> > =C2=A0	conf =3D get_multipath_config();
> > =C2=A0	mpp->sync_tick =3D conf->max_checkint;
> > =C2=A0	put_multipath_config(conf);
> > -	mpp->synced_count++;
> > =C2=A0
> > =C2=A0	r =3D libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> > =C2=A0			=C2=A0 (mapid_t) { .str =3D mpp->alias },
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 4a28fbb..e4e6bf7 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2470,7 +2470,7 @@ sync_mpp(struct vectors * vecs, struct
> > multipath *mpp, unsigned int ticks)
> > =C2=A0	if (mpp->sync_tick)
> > =C2=A0		mpp->sync_tick -=3D (mpp->sync_tick > ticks) ? ticks
> > :
> > =C2=A0				=C2=A0 mpp->sync_tick;
> > -	if (mpp->sync_tick)
> > +	if (mpp->sync_tick && !mpp->checker_count)
> > =C2=A0		return;
> > =C2=A0
> > =C2=A0	do_sync_mpp(vecs, mpp);
> > @@ -2513,12 +2513,6 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> > =C2=A0		return handle_path_wwid_change(pp, vecs)?
> > CHECK_PATH_REMOVED :
> > =C2=A0							=C2=A0
> > CHECK_PATH_SKIPPED;
> > =C2=A0	}
> > -	if (pp->mpp->synced_count =3D=3D 0) {
> > -		do_sync_mpp(vecs, pp->mpp);
> > -		/* if update_multipath_strings orphaned the path,
> > quit early */
> > -		if (!pp->mpp)
> > -			return CHECK_PATH_SKIPPED;
> > -	}
> > =C2=A0	if ((newstate !=3D PATH_UP && newstate !=3D PATH_GHOST &&
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 newstate !=3D PATH_PENDING) && (pp->sta=
te =3D=3D
> > PATH_DELAYED)) {
> > =C2=A0		/* If path state become failed again cancel path
> > delay state */
> > @@ -2918,9 +2912,11 @@ check_paths(struct vectors *vecs, unsigned
> > int ticks)
> > =C2=A0	vector_foreach_slot(vecs->pathvec, pp, i) {
> > =C2=A0		if (pp->is_checked !=3D CHECK_PATH_UNCHECKED)
> > =C2=A0			continue;
> > -		if (pp->mpp)
> > +		if (pp->mpp) {
> > =C2=A0			pp->is_checked =3D check_path(pp, ticks);
> > -		else
> > +			if (pp->is_checked =3D=3D CHECK_PATH_STARTED)
> > +				pp->mpp->checker_count++;
> > +		} else
> > =C2=A0			pp->is_checked =3D
> > check_uninitialized_path(pp, ticks);
> > =C2=A0		if (pp->is_checked =3D=3D CHECK_PATH_STARTED &&
> > =C2=A0		=C2=A0=C2=A0=C2=A0 checker_need_wait(&pp->checker))
> > @@ -3014,12 +3010,10 @@ checkerloop (void *ap)
> > =C2=A0			pthread_cleanup_push(cleanup_lock, &vecs-
> > >lock);
> > =C2=A0			lock(&vecs->lock);
> > =C2=A0			pthread_testcancel();
> > -			vector_foreach_slot(vecs->mpvec, mpp, i)
> > -				mpp->synced_count =3D 0;
> > =C2=A0			if (checker_state =3D=3D CHECKER_STARTING) {
> > =C2=A0				vector_foreach_slot(vecs->mpvec,
> > mpp, i) {
> > -					sync_mpp(vecs, mpp,
> > ticks);
> > =C2=A0					mpp->prio_update =3D
> > PRIO_UPDATE_NONE;
> > +					mpp->checker_count =3D 0;
> > =C2=A0				}
> > =C2=A0				vector_foreach_slot(vecs->pathvec,
> > pp, i)
> > =C2=A0					pp->is_checked =3D
> > CHECK_PATH_UNCHECKED;
> > @@ -3032,11 +3026,13 @@ checkerloop (void *ap)
> > =C2=A0							=C2=A0=C2=A0=C2=A0=C2=A0
> > start_time.tv_sec);
> > =C2=A0			if (checker_state =3D=3D CHECKER_FINISHED) {
> > =C2=A0				vector_foreach_slot(vecs->mpvec,
> > mpp, i) {
> > -					if ((update_mpp_prio(mpp)
> > ||
> > -					=C2=A0=C2=A0=C2=A0=C2=A0 (mpp->need_reload &&
> > mpp->synced_count > 0)) &&
>=20
> When you call reload_and_sync_map(), it will automatically resync the
> map via setup_multipath() -> refresh_multipath() ->
> update_multipath_strings().
>=20
> This means that if for some reason multipathd and the kernel disagree
> about a map, and reloading it doesn't fix the problem, you will
> immediately set mpp->need_reload again. With the old mpp-
> >synced_count
> check, you only reload maps with need_reload() when a path is
> checked.
> Without this check, or a (mpp->checker_count > 0) check to replace
> it,
> you will keep reloading these maps every loop, roughly once a second.
> I
> would rather not do this.
>=20
> If you want to make sure to immediately handle a need_reload that
> wasn't
> triggered by this call to reload_and_sync_map() which was because of
> an
> earlier need_reload, we could make need_reload have three states, to
> distinguish between a reload we want done immediately, and one we
> would
> like to wait on because we just did a reload and it didn't fix the
> problem. Then we could remember if need_reload was set before calling
> reload_and_sync_map(), and if it was, and if it is still set after,
> we
> could switch it to the delayed version.
>=20
> Or perhaps I'm just being paranoid here.=20

As you probably know and as I recently verified, reloading the kernel
from the checker loop will hardly ever fail except with -ENOMEM [1]. We
can pass non-existing or failed devices to the kernel, it will happily
accept them.

update_pathvec_from_dm() never adds any devices to the map, it just
removes some. If need_reload is set, it means that it has removed
either a path or an entire pathgroup. When the map is reloaded, it will
only reference (a subset of) the devices that were already mapped. I
see no way how this could fail unless either multipathd or the kernel
are really badly malfunctioning, in which case we don't need to bother
about reloading too frequently.

But *if* the reload succeeds, the set of devices in the kernel is
guaranteed to be identical to the table that we've just used for
reloading. So only way that another difference between kernel and
multipath state could occur between the reload and
update_pathvec_from_dm() running again is that another device has just
diappeared from the system, in which case a quick reload would be a
reasonable action. (Well I guess another possibility would be a 3rd
party maliciously adding wrong path devices to the maps we maintain,
but that's not something we can do much about).

If need_reload is indeed set again in this situation, I would indeed
prefer to double-check this map quickly. As argued above, I strongly
believe that such a situation will not persist. IMO a detected
inconsistency between the kernel and multipathd is a very bad thing
that we should try to fix rather sooner than later. It's at least as
bad as a failed path, which we'll check every second, too.

Bottom line: I think re-checking this quickly is actually the right
thing to do. Would you accept this if I add a warning in the
"inconsistent" case, so that in the event that we actually run into a
persistent discrepancy situation, we will notice?

Regards,
Martin

[1]
https://lore.kernel.org/dm-devel/ee6fcbda31fd1f13969653782417fbed748f5bc7.c=
amel@suse.com/

> -Ben
>=20
> > -					=C2=A0=C2=A0=C2=A0
> > reload_and_sync_map(mpp, vecs) =3D=3D 2)
> > +					sync_mpp(vecs, mpp,
> > ticks);
> > +					if ((update_mpp_prio(mpp)
> > || mpp->need_reload) &&
> > +					=C2=A0=C2=A0=C2=A0
> > reload_and_sync_map(mpp, vecs) =3D=3D 2) {
> > =C2=A0						/* multipath
> > device deleted */
> > =C2=A0						i--;
> > +						continue;
> > +					}
> > =C2=A0				}
> > =C2=A0			}
> > =C2=A0			lock_cleanup_pop(vecs->lock);
> > --=20
> > 2.47.0
>=20

