Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BD620DD2
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 16:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721061148; cv=none; b=st0DT3yJBBgSqareq4QZFDkRZ7hW+AmZeXIaOTlBskB6u8+NU6n8l2hjUaJqP+/wWxP4kEgLgL02vQ6ey7DMJAcV6zOHH/txCbXXAffszb9sy0vIvhkmeiBMmcjJvENJL49mWSOOUMOnRHDUR0IO+BZ5F3qXuN3Atvtyz7x/12s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721061148; c=relaxed/simple;
	bh=RX2t+jt/Gt5WyQcslypeeXPR+pSqA7k0ztsxBcJMojw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BcCuV9LKKlwUaeHt5r6GLf3A4kmhsWI6xEnLbYLR3QVXayKjcMIC/6SVgPmxbgU4WZD2jqRRd0/0SL6o2q9iItwvqEVznFMuDFYw1/kGfxqxfMCw0DZ6YyjPmLqwQ3+r20qfyxMEieWpIl9OYXuWBxp6lq5ptLggNBUMra75SfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b5U0Py3y; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b5U0Py3y"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-595850e7e11so5654066a12.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 09:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721061144; x=1721665944; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GVK021LYmnSF5jlSRXvHgqzm/TynMG4qCVor4qp3ExI=;
        b=b5U0Py3y8N642n1Xsr5Qeo4BXByKjSuAbK9Ufgca/0ecl8xTQxxEqkIIJ7OMQ+EeRU
         xCEOT9VkBA6bnIGF641OVXlqAKLFXlpE/IC4Zxp5uDsHZ4DAeMuseNkhUF+t1TP9/Z3P
         xfoj1oRpNzR5e2lVbmBFzdLS1owDmV/aAFNkBmug+B6hKUhKRa/XbhQGYcVv/RwGdFaq
         CL5KmWr2qFtaWfkxSiNFRaZaG2L3QUO7BG8epr6be9A/TDZwtKUcHZRX8ETUtPDQL0Ji
         EL9h+/2mp2CmmkJywlevFKYJnsVnbn9iaC6uSw1tCuGlB2iKqbjDl72a2rlWKZjZuDXG
         L/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721061144; x=1721665944;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVK021LYmnSF5jlSRXvHgqzm/TynMG4qCVor4qp3ExI=;
        b=iMgH5H5CdXVE7n6IlCvuHYON/ofxVvvdJFHiZyPqLPwqCRwmOtWTxiLufyzZj9JYOp
         l/zJAfsxcuPWoTjQNhExufsFdAUskl7rx8HqrSRvdF3MY7neLNmUBGQ4jvRjTejp+woX
         yOd2/FpqI2LTnsWYSdZej2bBfs7S1LBBl3X19jaU8+IgOfNpSi2brjMCkOsnrGZphyYI
         /DmxXFXr55gCn0a4Mtmj2inFgYCrYzshOYWd3QDlfAxuVSpVc+jpJew26CeKsMR44d+f
         mYmbw4pVjsGo8TJw5q6cVU59u6XyUpCNwv4cEPEug0aytx+lFNG1CJUlH0BKR9BNaABF
         RHAQ==
X-Gm-Message-State: AOJu0Ywyuk0ZtZhGqTofZbfPG/DWGjxI6N0u5TjlKpkq8nFAoCGuS4jJ
	dUCiRmOmqFysRA6r5jXymWOK/0PzVK5DRRqqE63xAAiE4wb6qaeFhbV6FceiQuc=
X-Google-Smtp-Source: AGHT+IFUkIZD886VpvaRbR7yHcWkRxbkiyPIFvmjqVVRUwSdtJBRzGo9rjNvHLEQp2anm3j5eUKEzw==
X-Received: by 2002:a05:6402:50c8:b0:58c:eee0:48ec with SMTP id 4fb4d7f45d1cf-59e996145edmr300321a12.26.1721061144253;
        Mon, 15 Jul 2024 09:32:24 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b26f625a2sm3534913a12.96.2024.07.15.09.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:32:24 -0700 (PDT)
Message-ID: <5b52909bfeca226b6713f0be1730a1f7026a67ad.camel@suse.com>
Subject: Re: [PATCH 13/22] multipathd: resync map after setup_map in
 ev_remove_path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 18:32:22 +0200
In-Reply-To: <20240713060506.2015463-14-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-14-bmarzins@redhat.com>
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
> In ev_remove_path() it was possible to exit after calling setup_map()
> without resyncing the mpp state with the kernel. This meant that the
> mpp state in multipathd might not match with the kernel state at all.
>=20
> It's safe to exit before calling setup_map() if either wait_for_udev
> or need_do_map is set. In both cases, setup_map() will later be
> called,
> either by a uevent or by the calling function.
>=20
> Once setup_map() has been called, setup_multipath() and
> sync_map_state()
> are now always called, to make sure the mpp matches the kernel state.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 40 +++++++++++++++++++---------------------
> =C2=A01 file changed, 19 insertions(+), 21 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 179fec24..3c84c2a0 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1395,6 +1395,8 @@ ev_remove_path (struct path *pp, struct vectors
> * vecs, int need_do_map)
> =C2=A0	 * avoid referring to the map of an orphaned path
> =C2=A0	 */
> =C2=A0	if ((mpp =3D pp->mpp)) {
> +		char devt[BLK_DEV_SIZE];
> +
> =C2=A0		/*
> =C2=A0		 * Mark the path as removed. In case of success, we
> =C2=A0		 * will delete it for good. Otherwise, it will be
> deleted
> @@ -1428,12 +1430,6 @@ ev_remove_path (struct path *pp, struct
> vectors * vecs, int need_do_map)
> =C2=A0		=C2=A0=C2=A0=C2=A0 flush_map_nopaths(mpp, vecs))
> =C2=A0			goto out;
> =C2=A0
> -		if (setup_map(mpp, &params, vecs)) {
> -			condlog(0, "%s: failed to setup map for"
> -				" removal of path %s", mpp->alias,
> pp->dev);
> -			goto fail;
> -		}
> -
> =C2=A0		if (mpp->wait_for_udev) {
> =C2=A0			mpp->wait_for_udev =3D 2;
> =C2=A0			retval =3D REMOVE_PATH_DELAY;
> @@ -1444,33 +1440,35 @@ ev_remove_path (struct path *pp, struct
> vectors * vecs, int need_do_map)
> =C2=A0			retval =3D REMOVE_PATH_DELAY;
> =C2=A0			goto out;
> =C2=A0		}
> +
> +		if (setup_map(mpp, &params, vecs)) {
> +			condlog(0, "%s: failed to setup map for"
> +				" removal of path %s", mpp->alias,
> pp->dev);
> +			goto fail;
> +		}
> =C2=A0		/*
> =C2=A0		 * reload the map
> =C2=A0		 */
> =C2=A0		mpp->action =3D ACT_RELOAD;
> +		strlcpy(devt, pp->dev_t, sizeof(devt));

Move this statement further down, directly before the call to
setup_multipath(), perhaps? It's only for the condlog anyway.

Except for that, LGTM.

Martin


> =C2=A0		if (domap(mpp, params, 1) =3D=3D DOMAP_FAIL) {
> =C2=A0			condlog(0, "%s: failed in domap for "
> =C2=A0				"removal of path %s",
> =C2=A0				mpp->alias, pp->dev);
> =C2=A0			retval =3D REMOVE_PATH_FAILURE;
> -		} else {
> -			/*
> -			 * update our state from kernel
> -			 */
> -			char devt[BLK_DEV_SIZE];
> -
> -			strlcpy(devt, pp->dev_t, sizeof(devt));
> -
> -			/* setup_multipath will free the path
> -			 * regardless of whether it succeeds or
> -			 * fails */
> -			if (setup_multipath(vecs, mpp))
> -				return REMOVE_PATH_MAP_ERROR;
> -			sync_map_state(mpp);
> +		}
> +		/*
> +		 * update mpp state from kernel even if domap
> failed.
> +		 * If the path was removed from the mpp,
> setup_multipath will
> +		 * free the path regardless of whether it succeeds
> or fails
> +		 */
> +		if (setup_multipath(vecs, mpp))
> +			return REMOVE_PATH_MAP_ERROR;
> +		sync_map_state(mpp);
> =C2=A0
> +		if (retval =3D=3D REMOVE_PATH_SUCCESS)
> =C2=A0			condlog(2, "%s: path removed from map %s",
> =C2=A0				devt, mpp->alias);
> -		}
> =C2=A0	} else {
> =C2=A0		/* mpp =3D=3D NULL */
> =C2=A0		if ((i =3D find_slot(vecs->pathvec, (void *)pp)) !=3D -
> 1)

