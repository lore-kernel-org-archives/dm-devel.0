Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C69266B77
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 22:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742942003; cv=none; b=R20nZb46DDmksAZ616tXijye9IwUhWKy9byet/K7P0CfRcsjAdbDdXqisG219jePPtWppAjlnDYTHSu9Cj0HY64ZacMQx/kuvbp6FUbQr4ytsPxpqn/ODmAVJp75hiuQDoiAIVOwbo2Jn5+a79KIgrHH4+ZdPsrMaMEDEcWKmQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742942003; c=relaxed/simple;
	bh=dEIzsQA9RN8XzvKFgNymCExDL0rwOPDT3XW05vMVGAM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DWxaIKpSNYwTe/4ood/YL0mBXe3z0BUsN9EKkMM2x/hm2tU2qAQpTG1/RUKWH//yAqiZ+7iqQvk7wj1bEOeKXMJyhPD/i2S4cjEUVan7H3yCuTGDhna+ngVa58jb5f/pmQMlWIOOvXZfck1e0bvFbgySjPO5+eoQ6FRegdJ8B9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T43olTJ4; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T43olTJ4"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso1026168f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 15:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742941999; x=1743546799; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ruwy06a34I1o+6yH1DclErnDk20uBSKrlLS1t6JtJXs=;
        b=T43olTJ4rU5iU9k4xbAisp4KhskBKaV3cFscylbdnjX+4scGRvat/ZMw2VF2I5vB84
         LUPceb/vhuS3tiC4h41Q3cNMMnDx9gKMIpCIet4ZsyIJAr8Z01O2hJ4WkiIUbR2f4WsD
         HFzRSh07pkjFmNW/QdVrXwdwXv+qCXTJaNpWtWbMz4O0UEBevhxBcjW0hzRniKmuvfac
         gYrgoKz0cDjztAxTaad5Cmr0GIY/ckKc/FT42SHYghH8rwNw0v8bH9Whx5gKj2Od8pG3
         +cj3LIVzF0kehv0Ijn5zUN4E8hUwhbWuaPu6WrQ7LZJJQteXTtaK5Hu+ECZOJL6UX3+6
         dd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742941999; x=1743546799;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ruwy06a34I1o+6yH1DclErnDk20uBSKrlLS1t6JtJXs=;
        b=piggh5vZc7V7VF0LwEVJB05yD9bR0OYRGM+Tui+Jdmmf8/BqQU/lxx1C22bIrgacxn
         PsVqqqctcj8t6Xgwnxsz6pVEYr3Mn4iqs1Ozfpj33Bov3WTlbDY0oiUgpUT7VTqW17/t
         f/wEUZubJ4x9/mxupkkQ6YQEfHZeJu/EMTiGkH4ijSRA0jZliLaOaZIJVCYiMMB8P5nZ
         2cEWFM4PIDCc63PJ0GzJ4rXLT1moa31rPktbAciAEM1UKdfACP8vpOtb4vScmeJi2lhu
         +FDx4dl7YyZ90S/mSwFnHns6FfWl+WO7yW9TJfKZ7hBV1bP3FEB0Hlpph913xr64MAzm
         yhMA==
X-Gm-Message-State: AOJu0YxpPs4xMnubZuSX1qVUTnaBiMDNL+getPqC9bm1cQ4uEcvF8/mA
	Jzb6D9tPVBSn0H6G5EPxQPksenpvbfbIzJS6zd09eHO4hdITGGnpLvX30ODiLnk=
X-Gm-Gg: ASbGncuVpjejk893Dt/HJCUVktcoY1sY83A6OhkCXZyOficKFhbpavLShy4bt2fZOUP
	qfIltSrEIiVt20pHJ84xUFOhOGlI4lYhIjEO65mBsBl8rj1BYaMopqrIZa1UHZdRbEpvdICNzjg
	TrD7Ksj76U6QDoRk088+RTAG3gIHCcsulxNXrabu2Z90FuODvIMTHSCNxn4wN/O8qO3K/aWiaIE
	4YExsvTaLKCNhUSk2QhGOa8j1/6W1Zf5DRHWgs6iC/hs36uxedYyB+mzD5pIWjLpeqjyI5dntJi
	Fpk6qyWExnbQIE1WsdyjFMhDd29bMEIITHcbCUU87R9K8/rIpr+9E6vVk8d/v3woYUc74cBK94B
	eAOEdwCoJUL7jMzbfCIF9XH5b0MGlmx1C122FBowSByUC/9GjFMrWseOx8hVtK41xCHwFSl+FwN
	AMrno=
X-Google-Smtp-Source: AGHT+IEAAjcnz8h9uUq8MHi9780LhqSsh4VKclT0L3J/+H3yk+enmqyWlxV1Kicbzq66Of12GN8btA==
X-Received: by 2002:a05:6000:178f:b0:391:31c8:ba6b with SMTP id ffacd0b85a97d-3997f8eddd6mr18442570f8f.10.1742941999176;
        Tue, 25 Mar 2025 15:33:19 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f995423sm14727746f8f.20.2025.03.25.15.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 15:33:18 -0700 (PDT)
Message-ID: <8f0c3fab83d329c22a2d1921356fe7c91966da73.camel@suse.com>
Subject: Re: [PATCH 2/3] multipathd: re-add paths skipped because they were
 offline
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 25 Mar 2025 23:33:18 +0100
In-Reply-To: <20250324205504.2523493-3-bmarzins@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
	 <20250324205504.2523493-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-03-24 at 16:55 -0400, Benjamin Marzinski wrote:
> When a new device is added by the multipath command, multipathd may
> know
> of other paths that cannot be added to the device because they are
> currently offline. Instead of ignoring these paths, multipathd will
> now
> re-add them when they come back online. To do this, it multipathd
> needs
> a new device initialized state, INIT_OFFLINE, to track devices that
> were
> in INIT_OK, but could not be added to an existing multipath device
> because they were offline. These paths are handled along with the
> other
> uninitialized paths.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This looks good in general, but I'm not certain about INIT_OFFLINE. The
property "path was temporarily offline while we tried to add it to a
map" is not logically related to path initialization, IMO. Also, we
have plenty of (pp->initialized !=3D INIT_xyz) conditionals in the code,
and your patch touches only 2 of them. I find it difficult to rule out
that some of them might be broken by the additional init state. Have
you double-checked them all?

Maybe it would be better to store this property in a separate flag in
struct path?

2 more remarks below.

Thanks
Martin

> ---
> =C2=A0libmultipath/print.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 =
+
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++++
> =C2=A0libmultipath/structs_vec.c |=C2=A0 5 ++++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 58
> ++++++++++++++++++++++++++++++++++++--
> =C2=A04 files changed, 67 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 00c03ace..ed8adebe 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -572,6 +572,7 @@ static int snprint_initialized(struct strbuf
> *buff, const struct path * pp)
> =C2=A0		[INIT_OK] =3D "ok",
> =C2=A0		[INIT_REMOVED] =3D "removed",
> =C2=A0		[INIT_PARTIAL] =3D "partial",
> +		[INIT_OFFLINE] =3D "offline",
> =C2=A0	};
> =C2=A0	const char *str;
> =C2=A0
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 28de9a7f..8644407f 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -258,6 +258,11 @@ enum initialized_states {
> =C2=A0	 * change uevent is received.
> =C2=A0	 */
> =C2=A0	INIT_PARTIAL,
> +	/*
> +	 * INIT_OFFLINE: paths that should be part of an existing
> multipath
> +	 * device, but cannot be added because they are offline,
> +	 */
> +	INIT_OFFLINE,
> =C2=A0	INIT_LAST__,
> =C2=A0};
> =C2=A0
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index f6407e12..f122d056 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -389,6 +389,9 @@ static void orphan_paths(vector pathvec, struct
> multipath *mpp, const char *reas
> =C2=A0				free_path(pp);
> =C2=A0			} else
> =C2=A0				orphan_path(pp, reason);
> +		} else if (pp->initialized =3D=3D INIT_OFFLINE &&
> +			=C2=A0=C2=A0 strncmp(mpp->wwid, pp->wwid, WWID_SIZE)
> =3D=3D 0) {
> +			pp->initialized =3D INIT_OK;
> =C2=A0		}
> =C2=A0	}
> =C2=A0}
> @@ -595,6 +598,8 @@ void sync_paths(struct multipath *mpp, vector
> pathvec)
> =C2=A0		found =3D 0;
> =C2=A0		vector_foreach_slot(mpp->pg, pgp, j) {
> =C2=A0			if (find_slot(pgp->paths, (void *)pp) !=3D -1)
> {
> +				if (pp->initialized =3D=3D INIT_OFFLINE)
> +					pp->initialized =3D INIT_OK;
> =C2=A0				found =3D 1;
> =C2=A0				break;
> =C2=A0			}
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7aaae773..ecad5a4f 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -644,11 +644,44 @@ pr_register_active_paths(struct multipath *mpp)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> +static void
> +save_offline_paths(struct multipath *mpp, vector offline_paths)

const struct multipath *mpp ?

> +{
> +	unsigned int i, j;
> +	struct path *pp;
> +	struct pathgroup *pgp;
> +
> +	vector_foreach_slot (mpp->pg, pgp, i)
> +		vector_foreach_slot (pgp->paths, pp, j)
> +			if (pp->initialized =3D=3D INIT_OK &&
> +			=C2=A0=C2=A0=C2=A0 pp->sysfs_state =3D=3D PATH_DOWN)
> +				store_path(offline_paths, pp);

You're not handling error from store_path here. I don't think you need
to, but perhaps indicate this by adding a comment or calling
(void)store_path(...).

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
> +			pp->initialized =3D INIT_OFFLINE;
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
> @@ -685,6 +718,9 @@ fail:
> =C2=A0		return 1;
> =C2=A0	}
> =C2=A0
> +	if (new_map && retries < 0)
> +		save_offline_paths(mpp, offline_paths);
> +
> =C2=A0	if (setup_multipath(vecs, mpp))
> =C2=A0		return 1;
> =C2=A0
> @@ -695,6 +731,9 @@ fail:
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
> @@ -2793,7 +2832,8 @@ check_uninitialized_path(struct path * pp,
> unsigned int ticks)
> =C2=A0	struct config *conf;
> =C2=A0
> =C2=A0	if (pp->initialized !=3D INIT_NEW && pp->initialized !=3D
> INIT_FAILED &&
> -	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV)
> +	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV &&
> +	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_OFFLINE)
> =C2=A0		return CHECK_PATH_SKIPPED;
> =C2=A0
> =C2=A0	if (pp->tick)
> @@ -2849,7 +2889,8 @@ update_uninitialized_path(struct vectors *
> vecs, struct path * pp)
> =C2=A0	struct config *conf;
> =C2=A0
> =C2=A0	if (pp->initialized !=3D INIT_NEW && pp->initialized !=3D
> INIT_FAILED &&
> -	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV)
> +	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV &&
> +	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_OFFLINE)
> =C2=A0		return CHECK_PATH_SKIPPED;
> =C2=A0
> =C2=A0	newstate =3D get_new_state(pp);
> @@ -2875,6 +2916,19 @@ update_uninitialized_path(struct vectors *
> vecs, struct path * pp)
> =C2=A0			free_path(pp);
> =C2=A0			return CHECK_PATH_REMOVED;
> =C2=A0		}
> +	} else if (pp->initialized =3D=3D INIT_OFFLINE &&
> +		=C2=A0=C2=A0 (newstate =3D=3D PATH_UP || newstate =3D=3D PATH_GHOST))
> {
> +		pp->initialized =3D INIT_OK;
> +		if (pp->recheck_wwid =3D=3D RECHECK_WWID_ON &&
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

