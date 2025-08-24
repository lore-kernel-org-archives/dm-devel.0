Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DF713AA2F
	for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 21:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756069230; cv=none; b=cTB1D05nZAoIm7/tX311FUngVxcACHKXp06cBw3Q6QLyE0Ix4vurg60AQq5Yv25udCu7mHEzbCWCdSYkdhc4uXaSE16aXq51Tr+n+Ipf4CfM1TXZDPFvkVDd4X9zYMy4s8q7IZwXKOd1emWyI/9BTm8p1lmBbm3evsaK6me75zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756069230; c=relaxed/simple;
	bh=lWa1OfKntbmeaV3xoj1VHGiV8iMrg0dzRTk6DF9/AIs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=du891ZkeAYB9i5OW22McfKRrTOw0r1Bgw++nxOzV6wKlG3dGCSChK1HBP/PYTvZuV82Ry8nZ8vzytQDUHmvvM3Q9IZEeHlkAUJw5mUdgf1zRt5qaEeQPI1/bqNd4pi105LwXvGr08knFl3BVcAav1riG6DDSYaqgnRdRUQexrTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fugvAjew; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fugvAjew"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3c8fe6bd038so330602f8f.1
        for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 14:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756069226; x=1756674026; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U1WW6dLgIkMKGeqPozJs7Kafiw9CwSlOBMOT5GqEgkA=;
        b=fugvAjew50weFQgmDxe+aaS86wm5mBuzctbeNNI2Bop9tya3PgWrIEO/BOFWmOMuRv
         mYU4rVuPOELK3VBBiXLpFFhRV0/VkMW66GigqyQVG3tlAJP/Z6wZwcX+68TBpxldLLYp
         g95dUqojdNkS0lgLqsiX8EJ/JQxfjZ+VsUmSyacg9JziTSX2UrWo4VWmKaEDI+0bObBD
         EECbIBvijaQs41PDOGROrjeubdL0jLSU7Xek3Ri/72km4JDBTJzZb6dBc1UfG8Ixio1p
         N5qbv3KNAyhiweS7kb87SOJBI2EgxFpUv9EJKqN8j3WfIhAAcP5jB8slk9DEe5YTnf4q
         i8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756069226; x=1756674026;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U1WW6dLgIkMKGeqPozJs7Kafiw9CwSlOBMOT5GqEgkA=;
        b=Gaos5IrsIXogOSBoOiMrphyruXIeqYOwEc2iwbstRrgBeAGmjkPE9lqhilxNqmMzYL
         Zeh2uX4zai73bwyfOdtVR9AivrMOamJsGpMSpLZnB2lx6rc3RDScvj6blAQGaYtNKfN1
         9T8WGBOyztwAx4XvNRAPfEhG0qw4jpCQXQ6TvYUfblDTWQjKgYWfwlGuRPOUJBbUZi4R
         MujYzkduqeOlnr1hMKWtDwAGN9qwxSzOKjlZ4YfoEm4XmagWthDuOGrSFbk+V1dwmiCR
         2gz7HoX+vPF0Ee19SbuUEevS0ycHuRUew5eYrGtbRsWWAgA52gTGWApuuGOBP/TCufzK
         kF7w==
X-Gm-Message-State: AOJu0YyPW3DP6KiCdcsOfE3l8dygkL1IlV+rDGLRLq/j9TcMizG92ZcM
	mqnZQUxrkiqV/cscsP9iCzQojyiiKato7R7TAmek1epZAWg6oDcu675kcfnIjZETUoc=
X-Gm-Gg: ASbGncuMp2QyU3qvnpBofXU7Kzb+GltAnES52fwUXqA+0bYNSyl+zPIAOjhfJe0nMWX
	dgLPwrcckMg38k7LAt9mb4DSD4pA2JlQRuaX+zqZQJgRPWA3mowV7zbCF/WmcxqT36VnzmpZwKZ
	IAJFk+iBJwbbNwV2dknmqgpEY971XxrGhatuaAGeoGO+o43qwOK4Lx4JnAv61lBJsZnm74Ruegv
	06leeCvTXptkv+U2lMTovQ76Eaq6Hb18XPFbjesgXq4UUc0OvvZbO8v7VxBia8bBWzqYUV5qjw2
	CDt6QlaIbSbG5FQvi9G4DKeWQ9zgMDiU22W50xmEmP0UCLeLdhqkGHYLooFN75aegicRRdaCrbn
	R/GwdPK3JL/Wzv9Z4M6sNpAVAJ6Nso/h6WJ6124augPtml9gH7DDBYFyFNArTqLV+vcY9GIS6zW
	6zVRFhIb4y38bOhmNQ6AXISUL67Xcj5f2Lil7wkFJaN4i7iryRnEPQqQ==
X-Google-Smtp-Source: AGHT+IHTCyHTn2msPZTulMHkfD2PrtqXOBanC3FpwZj+P5Cs1ZS/W9Ys5CXDe9FDd/PHNCKapnKmqQ==
X-Received: by 2002:a05:6000:4383:b0:3c5:9e0f:7607 with SMTP id ffacd0b85a97d-3c5dc734286mr7309783f8f.33.1756069225400;
        Sun, 24 Aug 2025 14:00:25 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba078sm9309440f8f.4.2025.08.24.14.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 14:00:24 -0700 (PDT)
Message-ID: <de273595e1dacc34be4a34a99e2d07e7e60d7d4f.camel@suse.com>
Subject: Re: [PATCH 15/15] libmpathpersist: Add safety check for preempting
 on key change
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 24 Aug 2025 23:00:24 +0200
In-Reply-To: <20250710181100.3997759-16-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-16-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-07-10 at 14:11 -0400, Benjamin Marzinski wrote:
> When a reservation key is changed from one non-zero value to another,
> libmpathpersist checks if the old key is still holding the
> reservation,
> and preempts it if it is. This was only safe if two nodes never share
> the same key. If a node uses the same key as another node that is
> holding the reservation, and switches keys so that it no longer
> matches,
> it will end up preempting the reservation. This is clearly unexpected
> behavior, and it can come about by a simple accident of registering a
> device with the wrong key, and then immediately fixing it.
>=20
> To handle this, add code to track if a device is the reservation
> holder
> to multipathd. multipathd now has three new commands "getprhold",
> "setprhold", and "unsetprhold". These commands work like the
> equivalent
> *prstatus commands. libmpathpersist calls setprhold on RESERVE
> commands
> and PREEMPT commands when the preempted key is holding the
> reservation
> and unsetprhold on RELEASE commands. Also, calling unsetprflag causes
> prhold to be unset as well, so CLEAR commands and REGISTER commands
> with
> a 0x0 service action key will also unset prhold. libmpathpersist()
> will
> also unset prhold if it notices that the device cannot be holding a
> reservation in preempt_missing_path().
>=20
> When a new multipath device is created, its initial prhold state is
> PR_UNKNOWN until it checks the current reservation, just like with
> prflag. If multipathd ever finds that a device's registration has
> been
> preempted or cleared in update_map_pr(), it unsets prhold, just like
> with prflag.
>=20
> Now, before libmpathpersist preempts a reservation when changing keys
> it also checks if multipathd thinks that the device is holding
> the reservation. If it does not, then libmpathpersist won't preempt
> the key. It will assume that another node is holding the reservation
> with the same key.
>=20
> I should note that this safety check only stops a node not holding
> the
> reservation from preempting the node holding the reservation. If the
> node holding the reservation changes its key, but it fails to change
> the
> resevation key, because that path is down or gone, it will still
> issue
> the preempt to move the reservation to a usable path, even if another
> node is using the same key. This will remove the registrations for
> that
> other node. It also will not work correctly if multipathd stops
> tracking
> a device for some reason. It's only a best-effort safety check.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 87 ++++++++++++++++++++++++--=
-
> --
> =C2=A0libmpathpersist/mpath_updatepr.c=C2=A0=C2=A0=C2=A0 | 19 ++++++-
> =C2=A0libmpathpersist/mpathpr.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/callbacks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +
> =C2=A0multipathd/cli.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +=
-
> =C2=A0multipathd/cli.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 48 ++++++++++++++++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 33 +++++++++=
+-
> =C2=A09 files changed, 182 insertions(+), 18 deletions(-)
>=20

Two questions all the way down.


> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index ae0defc2..91f0d018 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -260,6 +260,10 @@ static int mpath_prout_common(struct multipath
> *mpp,int rq_servact, int rq_scope
> =C2=A0 * holding the reservation on a path that couldn't get its key
> updated,
> =C2=A0 * either because it is down or no longer part of the multipath
> device,
> =C2=A0 * you need to preempt the reservation to a usable path with the ne=
w
> key
> + *
> + * Also, it's possible that the reservation was preempted, and the
> device
> + * is being re-registered. If it appears that is the case, clear
> + * mpp->prhold in multipathd.
> =C2=A0 */
> =C2=A0void preempt_missing_path(struct multipath *mpp, uint8_t *key,
> uint8_t *sa_key,
> =C2=A0			=C2=A0 int noisy)
> @@ -272,12 +276,19 @@ void preempt_missing_path(struct multipath
> *mpp, uint8_t *key, uint8_t *sa_key,
> =C2=A0	int status;
> =C2=A0
> =C2=A0	/*
> -	 * If you previously didn't have a key registered or you
> didn't
> -	 * switch to a different key, there's no need to preempt.
> Also, you
> -	 * can't preempt if you no longer have a registered key
> +	 * If you previously didn't have a key registered, you can't
> +	 * be holding the reservation. Also, you can't preempt if
> you
> +	 * no longer have a registered key
> =C2=A0	 */
> -	if (memcmp(key, zero, 8) =3D=3D 0 || memcmp(sa_key, zero, 8) =3D=3D
> 0 ||
> -	=C2=A0=C2=A0=C2=A0 memcmp(key, sa_key, 8) =3D=3D 0)
> +	if (memcmp(key, zero, 8) =3D=3D 0 || memcmp(sa_key, zero, 8) =3D=3D
> 0) {
> +		update_prhold(mpp->alias, false);
> +		return;
> +	}
> +	/*
> +	 * If you didn't switch to a different key, there is no need
> to
> +	 * preempt.
> +	 */
> +	if (memcmp(key, sa_key, 8) =3D=3D 0)
> =C2=A0		return;
> =C2=A0
> =C2=A0	status =3D mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA,
> &resp, noisy);
> @@ -286,13 +297,29 @@ void preempt_missing_path(struct multipath
> *mpp, uint8_t *key, uint8_t *sa_key,
> =C2=A0		return;
> =C2=A0	}
> =C2=A0	/* If there is no reservation, there's nothing to preempt */
> -	if (!resp.prin_descriptor.prin_readresv.additional_length)
> +	if (!resp.prin_descriptor.prin_readresv.additional_length) {
> +		update_prhold(mpp->alias, false);
> =C2=A0		return;
> +	}
> =C2=A0	/*
> =C2=A0	 * If there reservation is not held by the old key, you
> don't
> =C2=A0	 * want to preempt it
> =C2=A0	 */
> -	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8)
> !=3D 0)
> +	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8)
> !=3D 0) {
> +		/*
> +		 * If reseravation key doesn't match either the old
> or
> +		 * the new key, then clear prhold.
> +		 */
> +		if (memcmp(sa_key,
> resp.prin_descriptor.prin_readresv.key, 8) !=3D 0)
> +			update_prhold(mpp->alias, false);
> +		return;
> +	}
> +
> +	/*
> +	 * If multipathd doesn't think it is holding the
> reservation, don't
> +	 * preempt it
> +	 */
> +	if (get_prhold(mpp->alias) !=3D PR_SET)
> =C2=A0		return;
> =C2=A0	/* Assume this key is being held by an inaccessable path on
> this
> =C2=A0	 * node. libmpathpersist has never worked if multiple nodes
> share
> @@ -640,19 +667,38 @@ fail_resume:
> =C2=A0	return (status =3D=3D MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER
> : status;
> =C2=A0}
> =C2=A0
> +static int reservation_key_matches(struct multipath *mpp, uint8_t
> *key,
> +				=C2=A0=C2=A0 int noisy)
> +{
> +	struct prin_resp resp =3D {0};
> +	int status;
> +
> +	status =3D mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA,
> &resp, noisy);
> +	if (status !=3D MPATH_PR_SUCCESS) {
> +		condlog(0, "%s: pr in read reservation command
> failed.",
> +			mpp->wwid);
> +		return YNU_UNDEF;
> +	}
> +	if (!resp.prin_descriptor.prin_readresv.additional_length)
> +		return YNU_NO;
> +	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8)
> =3D=3D 0)
> +		return YNU_YES;
> +	return YNU_NO;
> +}
> +
> =C2=A0/*
> =C2=A0 * for MPATH_PROUT_REG_IGN_SA, we use the ignored paramp->key to
> store the
> - * currently registered key.
> + * currently registered key for use in preempt_missing_path(), but
> only if
> + * the key is holding the reservation.
> =C2=A0 */
> =C2=A0static void set_ignored_key(struct multipath *mpp, uint8_t *key)
> =C2=A0{
> =C2=A0	memset(key, 0, 8);
> =C2=A0	if (!get_be64(mpp->reservation_key))
> =C2=A0		return;
> -	if (get_prflag(mpp->alias) =3D=3D PR_UNSET)
> +	if (get_prhold(mpp->alias) =3D=3D PR_UNSET)
> =C2=A0		return;
> -	update_map_pr(mpp, NULL);
> -	if (mpp->prflag !=3D PR_SET)
> +	if (reservation_key_matches(mpp, key, 0) =3D=3D YNU_NO)
> =C2=A0		return;
> =C2=A0	memcpy(key, &mpp->reservation_key, 8);
> =C2=A0}
> @@ -665,6 +711,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0	int ret;
> =C2=A0	uint64_t prkey;
> =C2=A0	struct config *conf;
> +	bool preempting_reservation =3D false;
> =C2=A0
> =C2=A0	ret =3D mpath_get_map(curmp, pathvec, fd, &mpp);
> =C2=A0	if (ret !=3D MPATH_PR_SUCCESS)
> @@ -715,9 +762,12 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0	case MPATH_PROUT_REG_IGN_SA:
> =C2=A0		ret=3D mpath_prout_reg(mpp, rq_servact, rq_scope,
> rq_type, paramp, noisy);
> =C2=A0		break;
> -	case MPATH_PROUT_RES_SA :
> -	case MPATH_PROUT_PREE_SA :
> -	case MPATH_PROUT_PREE_AB_SA :
> +	case MPATH_PROUT_PREE_SA:
> +	case MPATH_PROUT_PREE_AB_SA:
> +		if (reservation_key_matches(mpp, paramp->sa_key,
> noisy) =3D=3D YNU_YES)
> +			preempting_reservation =3D true;
> +		/* fallthrough */
> +	case MPATH_PROUT_RES_SA:
> =C2=A0	case MPATH_PROUT_CLEAR_SA:
> =C2=A0		ret =3D mpath_prout_common(mpp, rq_servact, rq_scope,
> rq_type,
> =C2=A0					 paramp, noisy, NULL);
> @@ -744,6 +794,15 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0	case MPATH_PROUT_CLEAR_SA:
> =C2=A0		update_prflag(mpp->alias, 0);
> =C2=A0		update_prkey(mpp->alias, 0);
> +		break;
> +	case MPATH_PROUT_RES_SA:
> +	case MPATH_PROUT_REL_SA:
> +		update_prhold(mpp->alias, (rq_servact =3D=3D
> MPATH_PROUT_RES_SA));
> +		break;
> +	case MPATH_PROUT_PREE_SA:
> +	case MPATH_PROUT_PREE_AB_SA:
> +		if (preempting_reservation)
> +			update_prhold(mpp->alias, 1);
> =C2=A0	}
> =C2=A0	return ret;
> =C2=A0}
> diff --git a/libmpathpersist/mpath_updatepr.c
> b/libmpathpersist/mpath_updatepr.c
> index c8fbe4a2..dd8dd48e 100644
> --- a/libmpathpersist/mpath_updatepr.c
> +++ b/libmpathpersist/mpath_updatepr.c
> @@ -75,13 +75,13 @@ static int do_update_pr(char *alias, char *cmd,
> char *key)
> =C2=A0	return ret;
> =C2=A0}
> =C2=A0
> -int get_prflag(char *mapname)
> +static int do_get_pr(char *mapname, const char *cmd)
> =C2=A0{
> =C2=A0	char str[256];
> =C2=A0	char *reply;
> =C2=A0	int prflag;
> =C2=A0
> -	snprintf(str, sizeof(str), "getprstatus map %s", mapname);
> +	snprintf(str, sizeof(str), "%s map %s", cmd, mapname);
> =C2=A0	reply =3D do_pr(mapname, str);
> =C2=A0	if (!reply)
> =C2=A0		prflag =3D PR_UNKNOWN;
> @@ -96,11 +96,26 @@ int get_prflag(char *mapname)
> =C2=A0	return prflag;
> =C2=A0}
> =C2=A0
> +int get_prflag(char *mapname)
> +{
> +	return do_get_pr(mapname, "getprstatus");
> +}
> +
> +int get_prhold(char *mapname)
> +{
> +	return do_get_pr(mapname, "getprhold");
> +}
> +
> =C2=A0int update_prflag(char *mapname, int set) {
> =C2=A0	return do_update_pr(mapname, (set)? "setprstatus" :
> "unsetprstatus",
> =C2=A0			=C2=A0=C2=A0=C2=A0 NULL);
> =C2=A0}
> =C2=A0
> +int update_prhold(char *mapname, bool set)
> +{
> +	return do_update_pr(mapname, (set) ? "setprhold" :
> "unsetprhold", NULL);
> +}
> +
> =C2=A0int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t
> sa_flags) {
> =C2=A0	char str[256];
> =C2=A0
> diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
> index 912957e5..99d6b82f 100644
> --- a/libmpathpersist/mpathpr.h
> +++ b/libmpathpersist/mpathpr.h
> @@ -9,6 +9,8 @@
> =C2=A0int update_prflag(char *mapname, int set);
> =C2=A0int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t
> sa_flags);
> =C2=A0int get_prflag(char *mapname);
> +int get_prhold(char *mapname);
> +int update_prhold(char *mapname, bool set);
> =C2=A0#define update_prkey(mapname, prkey) update_prkey_flags(mapname,
> prkey, 0)
> =C2=A0
> =C2=A0#endif
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 6c427d6f..97093675 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -522,6 +522,7 @@ struct multipath {
> =C2=A0	struct be64 reservation_key;
> =C2=A0	uint8_t sa_flags;
> =C2=A0	int prflag;
> +	int prhold;
> =C2=A0	int all_tg_pt;
> =C2=A0	struct gen_multipath generic_mp;
> =C2=A0	bool fpin_must_reload;
> diff --git a/multipathd/callbacks.c b/multipathd/callbacks.c
> index fb87b280..b6b57f45 100644
> --- a/multipathd/callbacks.c
> +++ b/multipathd/callbacks.c
> @@ -69,4 +69,7 @@ void init_handler_callbacks(void)
> =C2=A0	set_handler_callback(VRB_UNSETMARGINAL | Q1_PATH,
> HANDLER(cli_unset_marginal));
> =C2=A0	set_handler_callback(VRB_UNSETMARGINAL | Q1_MAP,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 HANDLER(cli_unset_all_marginal));
> +	set_handler_callback(VRB_GETPRHOLD | Q1_MAP,
> HANDLER(cli_getprhold));
> +	set_handler_callback(VRB_SETPRHOLD | Q1_MAP,
> HANDLER(cli_setprhold));
> +	set_handler_callback(VRB_UNSETPRHOLD | Q1_MAP,
> HANDLER(cli_unsetprhold));
> =C2=A0}
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index 34588290..d0e6cebc 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -224,7 +224,9 @@ load_keys (void)
> =C2=A0	r +=3D add_key(keys, "setmarginal", VRB_SETMARGINAL, 0);
> =C2=A0	r +=3D add_key(keys, "unsetmarginal", VRB_UNSETMARGINAL, 0);
> =C2=A0	r +=3D add_key(keys, "all", KEY_ALL, 0);
> -
> +	r +=3D add_key(keys, "getprhold", VRB_GETPRHOLD, 0);
> +	r +=3D add_key(keys, "setprhold", VRB_SETPRHOLD, 0);
> +	r +=3D add_key(keys, "unsetprhold", VRB_UNSETPRHOLD, 0);
> =C2=A0
> =C2=A0	if (r) {
> =C2=A0		free_keys(keys);
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index 9fa50145..5a943a45 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -38,6 +38,9 @@ enum {
> =C2=A0	VRB_UNSETMARGINAL	=3D 23,
> =C2=A0	VRB_SHUTDOWN		=3D 24,
> =C2=A0	VRB_QUIT		=3D 25,
> +	VRB_GETPRHOLD		=3D 26,
> +	VRB_SETPRHOLD		=3D 27,
> +	VRB_UNSETPRHOLD		=3D 28,
> =C2=A0
> =C2=A0	/* Qualifiers, values must be different from verbs */
> =C2=A0	KEY_PATH		=3D 65,
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index a92b07ce..34910c9b 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1314,6 +1314,10 @@ cli_unsetprstatus(void * v, struct strbuf
> *reply, void * data)
> =C2=A0		mpp->prflag =3D PR_UNSET;
> =C2=A0		condlog(2, "%s: prflag unset", param);
> =C2=A0	}
> +	if (mpp->prhold !=3D PR_UNSET) {
> +		mpp->prhold =3D PR_UNSET;
> +		condlog(2, "%s: prhold unset (by clearing prflag)",
> param);
> +	}
> =C2=A0
> =C2=A0	return 0;
> =C2=A0}
> @@ -1401,6 +1405,50 @@ cli_setprkey(void * v, struct strbuf *reply,
> void * data)
> =C2=A0	return ret;
> =C2=A0}
> =C2=A0
> +static int do_prhold(struct vectors *vecs, char *param, int prhold)
> +{
> +	struct multipath *mpp =3D find_mp_by_str(vecs->mpvec, param);
> +
> +	if (!mpp)
> +		return -ENODEV;
> +
> +	if (mpp->prhold !=3D prhold) {
> +		mpp->prhold =3D prhold;
> +		condlog(2, "%s: prhold %s", param, pr_str[prhold]);
> +	}
> +
> +	return 0;
> +}
> +
> +static int cli_setprhold(void *v, struct strbuf *reply, void *data)
> +{
> +	return do_prhold((struct vectors *)data, get_keyparam(v,
> KEY_MAP),
> +			 PR_SET);
> +}
> +
> +static int cli_unsetprhold(void *v, struct strbuf *reply, void
> *data)
> +{
> +	return do_prhold((struct vectors *)data, get_keyparam(v,
> KEY_MAP),
> +			 PR_UNSET);
> +}
> +
> +static int cli_getprhold(void *v, struct strbuf *reply, void *data)
> +{
> +	struct multipath *mpp;
> +	struct vectors *vecs =3D (struct vectors *)data;
> +	char *param =3D get_keyparam(v, KEY_MAP);
> +
> +	param =3D convert_dev(param, 0);
> +
> +	mpp =3D find_mp_by_str(vecs->mpvec, param);
> +	if (!mpp)
> +		return -ENODEV;
> +
> +	append_strbuf_str(reply, pr_str[mpp->prhold]);
> +	condlog(3, "%s: reply =3D %s", param, get_strbuf_str(reply));
> +	return 0;
> +}
> +
> =C2=A0static int cli_set_marginal(void * v, struct strbuf *reply, void *
> data)
> =C2=A0{
> =C2=A0	struct vectors * vecs =3D (struct vectors *)data;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 582af880..d22425f6 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -4222,6 +4222,32 @@ main (int argc, char *argv[])
> =C2=A0		return (child(NULL));
> =C2=A0}
> =C2=A0
> +static void check_prhold(struct multipath *mpp, struct path *pp)
> +{
> +	struct prin_resp resp =3D {0};
> +	int status;
> +
> +	if (mpp->prflag =3D=3D PR_UNSET) {
> +		mpp->prhold =3D PR_UNSET;
> +		return;
> +	}
> +	if (mpp->prflag !=3D PR_SET || mpp->prhold !=3D PR_UNKNOWN)
> +		return;

How can this situation come to pass? prflag must be PR_UNKNOWN.=20
Shouldn't we reset prhold to PR_UNKNOWN as well?

> +
> +	status =3D prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RRES_SA,
> &resp, 0);
> +	if (status !=3D MPATH_PR_SUCCESS) {
> +		condlog (0, "%s: pr in read reservation command
> failed: %d",
> +			 mpp->wwid, status);
> +		return;
> +	}
> +	mpp->prhold =3D PR_UNSET;
> +	if (!resp.prin_descriptor.prin_readresv.additional_length)
> +		return;
> +
> +	if (memcmp(&mpp->reservation_key,
> resp.prin_descriptor.prin_readresv.key, 8) =3D=3D 0)
> +		mpp->prhold =3D PR_SET;
> +}
> +
> =C2=A0static void mpath_pr_event_handle(struct path *pp)
> =C2=A0{
> =C2=A0	struct multipath *mpp =3D pp->mpp;
> @@ -4233,8 +4259,13 @@ static void mpath_pr_event_handle(struct path
> *pp)
> =C2=A0		return;
> =C2=A0	}
> =C2=A0
> -	if (update_map_pr(mpp, pp) !=3D MPATH_PR_SUCCESS)
> +	if (update_map_pr(mpp, pp) !=3D MPATH_PR_SUCCESS) {
> +		if (mpp->prflag =3D=3D PR_UNSET)
> +			mpp->prhold =3D PR_UNSET;

Perhaps we should move setting prhold to update_map_pr()?

Martin

> =C2=A0		return;
> +	}
> +
> +	check_prhold(mpp, pp);
> =C2=A0
> =C2=A0	if (mpp->prflag !=3D PR_SET)
> =C2=A0		return;
