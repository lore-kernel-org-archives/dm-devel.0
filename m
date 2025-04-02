Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324218DB3D
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 16:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743612163; cv=none; b=JjChng2pYBsSyXhI8U1oA1SWkXUqHXvLgF0U3Im2Uox+tcAbUMJenD8V1wPQzUs5WN+d0ar8DqwMfXUAHCV3bfijcXTIpX8qXzbTzJo5nGw2402P7g45xYM9vTQ/JDSIKChCa+ah9Hyt4gsqFnLRk36LyPOSJqo7433PtlCMkxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743612163; c=relaxed/simple;
	bh=uWILg6jnSICO5E+wfs8CaM6y7iVtsts3fuuEceTZVec=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r9nCq8aR/4nbMeo/Kt4+zV0VKgJDC3GncltZrico+zdfpQVEvTTgT7/8BJZKFjdj8G+sVKUVO/tL1O4YbQaODJGJQq7DTBddgbtVZix6sosWeBY8W1Ebl49iQy6gDD/Qxi+7dM4UgaS3b2ZraY7nb5JyNpg9uJ2mgaYKt0QpVds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SyTFSDd0; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SyTFSDd0"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso693164f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 02 Apr 2025 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743612156; x=1744216956; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YC6SND4yNhpiSDWDxv+csCM/56K7ekiodlOF5s9KPCY=;
        b=SyTFSDd0W/ZtFXpDaPbQtFNVewjEOJoTh0zlp6y6DVkroL5Ht5QTYKqOWEcuEs50KH
         J33Tp2l8PNhJdV0ekbsiDP0fC2IeqOUx0JvK8cGEVP+wpuaH60E376S7wF+fdAIO3p5s
         5fORvmXd8dCIdLZ6clGFcudOCcHwZNPulUG+EDpyhSd9rv8OEv0bbKiEeJvPp1UkFzRk
         AaHbeEug4eH4mMlUTtCnm8BOhZhuoMbYfvmbClB5+FgEe6CWRvnSRUZlehbX1ok/hhdM
         aODdB6jJUkElWFJOCjg7Vn8v7XvhzEofj1xHqoN00XTTV1PHsKgmItV9ldYWDgu8IjJr
         FOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743612156; x=1744216956;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YC6SND4yNhpiSDWDxv+csCM/56K7ekiodlOF5s9KPCY=;
        b=gS/ek6cNBIapwS9YAKH1W3DRgjRqEG0o5vl7dLzMrPFQNTDa26RLE//p2nZfWKULSU
         slyLPYU07dqC0GvRrZlv4AzCkwr7gef7bVux4e2Ulkt6ckSfbZIqVha6ntRnMenV1S1Q
         bHncCMPfUhRGiMtz4Sz3kIy7yWGqoL6Y8ej5guvb4M94VOjvdeVi5Rx7MMAq5vNiC85Z
         x3zsUA685LgyK4e0Qm3zMmZtsybakb2SHCoUSouuG1I4DRHxavgl3M5b67Q8uCmk+hFf
         /+ACByQyEnu81aEkt0hzYFcJfcesz6ZjJE74OsO7pIox3vwLGQfD3rmqgdJRA5VvnH0G
         pU8Q==
X-Gm-Message-State: AOJu0Yznpnnh4WgqI4sJfKYsXpkTRaK8r9d+jYtGY6gqHbcksC+2uNj/
	gmEeqNKrcorjmBqYAVrxclnMy1PdHhFCCqA328kxMrMAD9TZUtZMuKVNf932vloSQhbEY6TjNoY
	y
X-Gm-Gg: ASbGncvbKw/tmq6XkBWuo5hoPfUFeds5DNrj38q779HBooZOr+WZgEqXK3Goqjru5U0
	qg3b/VkRiGi/jkR8XR/M/7epLaBiWAY4uGmCyb9Q338L+oopSPZPOYpgg1xoCT3k7rty2R720Pu
	hix03oFZH/dRTUnWNW4DnhTzQJugWW8JqmWe+5dS9KXT7QOULv29MIc/TiF94UD7MWdQiPPztAZ
	cc5+EooUKC23OyMGbYhIoMb7Byzlfgb0w3vd4vZlaHSiUlKl+0JWsIJGAjseygwjhBPUUSXng8v
	VgbVoYdJskriHR+Lqge1Yp7ZFBVrAtam+Y5ABJmA92HviMAFesLTdCc412M/1+Tpl9s3lhovsbw
	tVvELxmMc624ZhGC/tPv5A02N9cf6p27C6T5fGOsHArs7YmITNHBZ6SZxe85I/EBB2mbuFzB8gK
	7WXdk=
X-Google-Smtp-Source: AGHT+IGwqKNFevNicHVeg+fnx7OzdYImnFF2ZyyEq1Go4p9qbqTyOi5AdR5LQpwQV39cw21sJhuGUg==
X-Received: by 2002:a05:6000:1869:b0:39a:c9ae:a198 with SMTP id ffacd0b85a97d-39c2e5f512fmr223771f8f.1.1743612156029;
        Wed, 02 Apr 2025 09:42:36 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43eb5eb3e11sm26806035e9.0.2025.04.02.09.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 09:42:35 -0700 (PDT)
Message-ID: <fb619d770cced66f3ebe90cedd8636901728d032.camel@suse.com>
Subject: Re: [PATCH v2 2/3] multipathd: re-add paths skipped because they
 were offline
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 02 Apr 2025 18:42:34 +0200
In-Reply-To: <20250331231730.2857655-3-bmarzins@redhat.com>
References: <20250331231730.2857655-1-bmarzins@redhat.com>
	 <20250331231730.2857655-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-03-31 at 19:17 -0400, Benjamin Marzinski wrote:
> When a new device is added by the multipath command, multipathd may
> know
> of other paths that cannot be added to the device because they are
> currently offline. Instead of ignoring these paths, multipathd will
> now
> re-add them when they come back online. To do this, it multipathd
> needs
> a new path variable add_when_online, to track devices that could not
> be
> added to an existing multipath device because they were offline.
> These
> paths are handled along with the other uninitialized paths.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/print.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 =
+++-
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/structs_vec.c |=C2=A0 5 ++++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 59
> ++++++++++++++++++++++++++++++++++++--
> =C2=A0multipathd/multipathd.8.in |=C2=A0 5 ++--
> =C2=A05 files changed, 70 insertions(+), 5 deletions(-)
>=20
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 00c03ace..019ae56f 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -658,8 +658,11 @@ snprint_path_serial (struct strbuf *buff, const
> struct path * pp)
> =C2=A0static int
> =C2=A0snprint_path_mpp (struct strbuf *buff, const struct path * pp)
> =C2=A0{
> -	if (!pp->mpp)
> +	if (!pp->mpp) {
> +		if (pp->add_when_online)
> +			return append_strbuf_str(buff, "[offline]");
> =C2=A0		return append_strbuf_str(buff, "[orphan]");
> +	}
> =C2=A0	if (!pp->mpp->alias)
> =C2=A0		return append_strbuf_str(buff, "[unknown]");
> =C2=A0	return snprint_str(buff, pp->mpp->alias);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 28de9a7f..39d1c71c 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -413,6 +413,7 @@ struct path {
> =C2=A0	int eh_deadline;
> =C2=A0	enum check_path_states is_checked;
> =C2=A0	bool can_use_env_uid;
> +	bool add_when_online;
> =C2=A0	unsigned int checker_timeout;
> =C2=A0	/* configlet pointers */
> =C2=A0	vector hwe;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index f6407e12..663c9053 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -389,6 +389,9 @@ static void orphan_paths(vector pathvec, struct
> multipath *mpp, const char *reas
> =C2=A0				free_path(pp);
> =C2=A0			} else
> =C2=A0				orphan_path(pp, reason);
> +		} else if (pp->add_when_online &&
> +			=C2=A0=C2=A0 strncmp(mpp->wwid, pp->wwid, WWID_SIZE)
> =3D=3D 0) {
> +			pp->add_when_online =3D false;
> =C2=A0		}
> =C2=A0	}
> =C2=A0}
> @@ -595,6 +598,8 @@ void sync_paths(struct multipath *mpp, vector
> pathvec)
> =C2=A0		found =3D 0;
> =C2=A0		vector_foreach_slot(mpp->pg, pgp, j) {
> =C2=A0			if (find_slot(pgp->paths, (void *)pp) !=3D -1)
> {
> +				if (pp->add_when_online)
> +					pp->add_when_online =3D false;
> =C2=A0				found =3D 1;
> =C2=A0				break;
> =C2=A0			}
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7aaae773..9aa5a2fa 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -644,11 +644,45 @@ pr_register_active_paths(struct multipath *mpp)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> +static void
> +save_offline_paths(const struct multipath *mpp, vector
> offline_paths)
> +{
> +	unsigned int i, j;
> +	struct path *pp;
> +	struct pathgroup *pgp;
> +
> +	vector_foreach_slot (mpp->pg, pgp, i)
> +		vector_foreach_slot (pgp->paths, pp, j)
> +			if (pp->initialized =3D=3D INIT_OK &&
> +			=C2=A0=C2=A0=C2=A0 pp->sysfs_state =3D=3D PATH_DOWN)
> +				/* ignore failures storing the
> paths. */
> +				store_path(offline_paths, pp);
> +}
> +
> +static void
> +handle_orphaned_offline_paths(vector offline_paths)
> +{
> +	unsigned int i;
> +	struct path *pp;
> +
> +	vector_foreach_slot (offline_paths, pp, i)
> +		if (pp->mpp =3D=3D NULL)
> +			pp->add_when_online =3D true;
> +}
> +
> +static void
> +cleanup_reset_vec(struct vector_s **v)
> +{
> +	vector_reset(*v);
> +}
> +
> =C2=A0static int
> =C2=A0update_map (struct multipath *mpp, struct vectors *vecs, int
> new_map)
> =C2=A0{
> =C2=A0	int retries =3D 3;
> =C2=A0	char *params __attribute__((cleanup(cleanup_charp))) =3D NULL;
> +	struct vector_s offline_paths_vec =3D { .allocated =3D 0 };
> +	vector offline_paths
> __attribute__((cleanup(cleanup_reset_vec))) =3D &offline_paths_vec;
> =C2=A0
> =C2=A0retry:
> =C2=A0	condlog(4, "%s: updating new map", mpp->alias);
> @@ -685,6 +719,9 @@ fail:
> =C2=A0		return 1;
> =C2=A0	}
> =C2=A0
> +	if (new_map && retries < 0)
> +		save_offline_paths(mpp, offline_paths);
> +
> =C2=A0	if (setup_multipath(vecs, mpp))
> =C2=A0		return 1;
> =C2=A0
> @@ -695,6 +732,9 @@ fail:
> =C2=A0	if (mpp->prflag =3D=3D PRFLAG_SET)
> =C2=A0		pr_register_active_paths(mpp);
> =C2=A0
> +	if (VECTOR_SIZE(offline_paths) !=3D 0)
> +		handle_orphaned_offline_paths(offline_paths);
> +
> =C2=A0	if (retries < 0)
> =C2=A0		condlog(0, "%s: failed reload in new map update",
> mpp->alias);
> =C2=A0	return 0;
> @@ -2793,7 +2833,8 @@ check_uninitialized_path(struct path * pp,
> unsigned int ticks)
> =C2=A0	struct config *conf;
> =C2=A0
> =C2=A0	if (pp->initialized !=3D INIT_NEW && pp->initialized !=3D
> INIT_FAILED &&
> -	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV)
> +	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV &&
> +	=C2=A0=C2=A0=C2=A0 !(pp->initialized =3D=3D INIT_OK && pp->add_when_onl=
ine))
> =C2=A0		return CHECK_PATH_SKIPPED;
> =C2=A0
> =C2=A0	if (pp->tick)
> @@ -2849,7 +2890,8 @@ update_uninitialized_path(struct vectors *
> vecs, struct path * pp)
> =C2=A0	struct config *conf;
> =C2=A0
> =C2=A0	if (pp->initialized !=3D INIT_NEW && pp->initialized !=3D
> INIT_FAILED &&
> -	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV)
> +	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV &&
> +	=C2=A0=C2=A0=C2=A0 !(pp->initialized =3D=3D INIT_OK && pp->add_when_onl=
ine))
> =C2=A0		return CHECK_PATH_SKIPPED;
> =C2=A0
> =C2=A0	newstate =3D get_new_state(pp);
> @@ -2875,6 +2917,19 @@ update_uninitialized_path(struct vectors *
> vecs, struct path * pp)
> =C2=A0			free_path(pp);
> =C2=A0			return CHECK_PATH_REMOVED;
> =C2=A0		}
> +	} else if (pp->initialized =3D=3D INIT_OK && pp->add_when_online
> &&
> +		=C2=A0=C2=A0 (newstate =3D=3D PATH_UP || newstate =3D=3D PATH_GHOST))
> {
> +		pp->initialized =3D INIT_OK;
> +		if (pp->recheck_wwid =3D=3D RECHECK_WWID_ON &&

I wonder if we should always check the WWID here. After all, this path
has never been part of the map, and it was offline when the map was
created (IOW, the WWID couldn't be checked at that point in time).=C2=A0
Can we rely on the stored WWID?

Other than that, LGTM.

Regards,
Martin

> +		=C2=A0=C2=A0=C2=A0 check_path_wwid_change(pp)) {
> +			condlog(0, "%s: path wwid change detected.
> Removing",
> +				pp->dev);
> +			return handle_path_wwid_change(pp, vecs)?
> +					CHECK_PATH_REMOVED :
> +					CHECK_PATH_SKIPPED;
> +		}
> +		ev_add_path(pp, vecs, 1);
> +		pp->tick =3D 1;
> =C2=A0	}
> =C2=A0	return CHECK_PATH_CHECKED;
> =C2=A0}
> diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> index 43f87bf8..a91acff1 100644
> --- a/multipathd/multipathd.8.in
> +++ b/multipathd/multipathd.8.in
> @@ -595,8 +595,9 @@ The device serial number.
> =C2=A0The device marginal state, either \fImarginal\fR or \fInormal\fR.
> =C2=A0.TP
> =C2=A0.B %m
> -The multipath device that this device is a path of, or
> \fI[orphan]\fR if
> -it is not part of any multipath device.
> +The multipath device that this device is a path of, or
> \fI[offline]\fR
> +if this device could not be added to a device because is is offline
> or
> +\fI[orphan]\fR if it is not part of any multipath device.
> =C2=A0.TP
> =C2=A0.B %N
> =C2=A0The host World Wide Node Name (WWNN) of the device, if any.
