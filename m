Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA93413D99
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 07:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619828; cv=none; b=LF6NUxIhwBZ2okSWSfkHu7UhumKh4K9DXVTwjXsKCGN4LLkkiu6lA1H8C8XGIiTr1EE4qubzGtkanpJkiBYMQpaKKoF+SdgqSqSJ0AaYpFHo72WqikDJ+eXgKhQ0Um7PuHDbij+jDmQLL/GZcPJoLqTkmLHQUb478RvExpV3Te0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619828; c=relaxed/simple;
	bh=1Gk2d/8x4PTkL+ffhP/6zBi0X/tB7oV1nGDEiUeQ+oY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eMn7VlMOzmYQwnycI1xah06MXvqbq0XppTDO9aekEUfk/aUJU2McwAJVKNXohU8vDP4euQw817EEMPdjPSf86XRsBNIMD927tAkFxnldYCi0Muonq5VRenHCrmyoa6CfLkl7HUj85F76o5dgNmjQXBiDOAIyMwMYNkzLItAAks8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D0IE3qxj; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D0IE3qxj"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so77649575e9.1
        for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784619825; x=1785224625; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3gH+IVsWbA1XEj8PCV+4hp4vfPJw/pu7HpmfTFrgEvE=;
        b=D0IE3qxjI/XNUa6vjrEEvrDlHy9zQKUvS0lzvR2tppfqcUZBm9ChuFuBrvehISFRxV
         zz+Pae+SsHYU9AX9coyL5Qz203Kxhz9+ETfGW46iBtc5a5Dkg8ngwCZIlLw1zLmf3YHG
         S1HRmYxTkd4yNGAGL3YEN4emkdEFP+c1uq2GHH/A0ZRo3AKyDRV8WxXkWEXZjr63EEgY
         tLKs5TSSExTManl1oqZp9dtZDKRiiAaw8i439UOEbZVBej6TqMWMEq9/TPOHwOag4XIr
         gr4JptPYkTGXGIR9XlGpm6APfd/DDqunCZK3DoAX3xx461dX+qC6tF0lvasI3EscbGGh
         O/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784619825; x=1785224625;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3gH+IVsWbA1XEj8PCV+4hp4vfPJw/pu7HpmfTFrgEvE=;
        b=FjWSyg1petlxkRxudBISUS2s4L1sBf5YXzX6Zsce1dh52xQzUGf/XGIGJU5a+c1h4q
         GD93JS/f2VIV6yPWYPJDuFDfkpd+fXQDvyIVDnq/XnIE/RM/Atnlvx6viS+fCp+qoAOA
         Bw3tlJcbzgcAJuS/lohVBWS1jk/H8qEBqS/pIqyRC/yO1mYlZ9cZaeDsRUXv6pBaJDP8
         ylRRc318cPjwmzT4zT0VMTET2dbxgeuNQAVjGTwIId5E57H+EvPSGcniLZPB12ZTplHW
         IBj7fWbE453x3mDkptCj53xJ8zlRijQoDaO69oIRGysdBY9jRE9Mqg7BP4zI3fiGH4ad
         4xSA==
X-Gm-Message-State: AOJu0YzK9han56vLHb44FtC9SvkgcPMngLHro9dikWXKf4I9ItAHWaIE
	l2yh3HanQULpu/BQlV9k+JAwhc8U1DIqD26mMvTzYGdqJAIph9hcbfWh98EoIRmkPfm9UGwRypz
	P/taw0eA=
X-Gm-Gg: AfdE7cneGxLqKKkjTAPcTG/WtpeZawpJtwei1y7eA/5MET/ozKZ5v9C4RgmUfuMmVUY
	KF1B29pPJhWVUOWXiO1V0boPfR5jFsII+/sDB5GbLIo+geP023ay//eHGPZIgNb7//ZiZKSXb7u
	ldQPdcBLGtF2cHABYzCFQ3kRkttpVqPE3KljGmN71FbRyDjR0nAIyR8dkzieLG89uj3UUW3Fc7s
	6tYpqdd5H9QEMIFjMeqQFE07wrbjfqTOuYn5AU7kZKzpFW9A1uzx9gL2LcKodx3E6oiSSog7GfL
	qjh2+MpXwbcTNGQ6oeH55fI33j9lIslYqxf/pZnwWAptj68zwUKkjbemqy4LQypcAcpl0JuJ+Ke
	VQk8NkDoeGCAJdGW2Q2wQadHfTR0kcT/H0l3Dei2EHRMdiq9nQSng4TfmPiYsa63kQNX0j5Dpnc
	sRPFp/7TsZkzHzOd3RxUvkPgOdZTzwO/HS0VlR7iFKi+8EOJuHCYKOMn+NdpEUj67wWlYzxwHJ+
	mdZWWLFd+z+GSsTd2jivlB3mMdLobZPWGuP3iCjaD6eIa/clGo=
X-Received: by 2002:a05:600c:b96:b0:495:4b00:1bab with SMTP id 5b1f17b1804b1-4954b001c39mr187313885e9.21.1784619825234;
        Tue, 21 Jul 2026 00:43:45 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f6b85970esm30199593f8f.15.2026.07.21.00.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 00:43:44 -0700 (PDT)
Message-ID: <7ff8a06cebaeea6d49c27044be2b3e4c66b9eda1.camel@suse.com>
Subject: Re: [PATCH] libmpathpersist: fix self-preemption when key has no
 active reservation
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Cykang
	 <cykang4830@gmail.com>
Date: Tue, 21 Jul 2026 09:43:44 +0200
In-Reply-To: <20260720215200.2464152-1-bmarzins@redhat.com>
References: <20260720215200.2464152-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-07-20 at 17:52 -0400, Benjamin Marzinski wrote:
> From: Cykang <cykang4830@gmail.com>
>=20
> According to the SCSI-3 Persistent Reservations specification, when a
> self-preemption is performed with a key that does not currently hold
> an active reservation, the operation should be treated as an
> unregister
> and should not fail.
>=20
> The current code in do_mpath_persistent_reserve_out() does not check
> whether the preempting key has a reservation before invoking the
> self-preemption path. It unconditionally calls preempt_self() and
> re-registers the key on the local paths, even when the key has no
> reservation. This violates the SCSI-3 PR spec and can lead to
> incorrect reservation states.
>=20
> This patch moves the self-preemption check inside the conditional
> block so that it only executes when the key matches, but does not
> bypass the general preemption path for keys without a reservation.
> With this change, the code will fall through to the common PR_OUT
> handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
> reserved, allowing the storage target to properly process the
> operation as an unregister.
>=20
> Signed-off-by: Cykang <cykang4830@gmail.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 22 ++++++++++++++++------
> =C2=A01 file changed, 16 insertions(+), 6 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 3091c5c2..6ca3b97d 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -841,6 +841,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0	bool unregistering, preempting_reservation =3D false;
> =C2=A0	bool updated_prkey =3D false;
> =C2=A0	bool failed_paths =3D false;
> +	bool self_preempt_unreg =3D false;
> =C2=A0
> =C2=A0	ret =3D mpath_get_map(curmp, fd, &mpp);
> =C2=A0	if (ret !=3D MPATH_PR_SUCCESS)
> @@ -961,13 +962,20 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0						=C2=A0 rq_type, noisy);
> =C2=A0				break;
> =C2=A0			}
> +			/* if we are preempting ourself */
> +			if (memcmp(paramp->sa_key, paramp->key, 8)
> =3D=3D 0) {
> +				ret =3D preempt_self(mpp, rq_servact,
> rq_scope,
> +						=C2=A0=C2=A0 rq_type, noisy,
> PREE_WORK_NONE);
> +				break;
> +			}
> +		} else if (memcmp(paramp->sa_key, paramp->key, 8) =3D=3D
> 0) {
> +			/*
> +			 * We are self-preempting, but we don't hold
> the
> +			 * reservation. This will unregister the
> device

key and sa_key are just parameters entered by the caller. How do you
know, without calling check_holding_reservation(), whether or not we
currently hold a reservation?

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
