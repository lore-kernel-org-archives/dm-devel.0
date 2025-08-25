Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2400919D07E
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756136803; cv=none; b=ibn4x69e5gd6Yb7I44cLsqSnUlRLUNfwAg0JCALhKBcrc++UqsFfgCRbRclVf9boCt4vtL0Y1+DBzcCyBjmk2rsMZnq4MiCtYsgeeVARU8nLHDgmecGm2u7qna67GAQa9buwnl2iRAvGBD+MsY5Lx01g0kE+n+S0dw09RByXKwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756136803; c=relaxed/simple;
	bh=7WEZHoONiZ4v0fWwFTcplz/2FpPocUSJDTszjNuU5+A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BBdLNrVuQj0HT6/N7CegziqebOlzPuQ1sd3DnfJW2sXCvtrcAzvNU3rV1grGvIt6u5ueOPFMvKgZCV4IfmquDEyqjigRyQjNFKShJ7Sxlc2b5AkidgfMZCGueYhpanBVpgRPtfAfUPDwxbNyEJzrM5ZzxJr3j4kwd+rqCNfRts8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y7yoLuN+; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y7yoLuN+"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3c84aea9d32so702562f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 08:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756136799; x=1756741599; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pr4NBhN2YYJERFgL+xScypxbTwbaPs+XQEJtqZLSNsI=;
        b=Y7yoLuN+9veVl20jdQ6y+XHnLpoSzbXH0FCBqV4BbWtoEiBvjzG3oBpL93mOFruCv5
         cTI8P3ugwyOQXgZnC5iQDujWA1ZbAuRYs0yWNk8OMLZOm8jJmhMkC6areUHuW00OfXEY
         9kSlw4msbOHoiv5mphrwShamQd9F2mqfpguOONGV/xLEvsgs4YZytzS0/zcN8VT48773
         kHQ2L9ssnSUZHEqYjpuhLUwVo1R+btVfto9xYeKVcPSUfzbhJwQmwp2DqLmB5ARZ2rzp
         ZZ8ZMy/QojHvF6WshlHR8crobnOSOmy+dQ6t0ByEUusLlohJoaxZonA5nLmT+7DvoAX8
         EYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756136799; x=1756741599;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pr4NBhN2YYJERFgL+xScypxbTwbaPs+XQEJtqZLSNsI=;
        b=UsmgV42CnOg2I8vod4vi0/gxbGk6Dq9H4neeZoTHBts9mXFGSNlWOLgTUp5FejFub3
         G2rsciL318FAvdrqS7kUiAZOEUS0j0oijFymCckI5YfoZz5a9fjPkNppONY8Gvaf9yow
         63xbxglTzHFet7pigbZZLUQOUg5bIl3XVV027xlASlkurzHI0/QUMUEBFrrglvdkh62c
         9KDP3ceh7wRwQiqLinCxNwgxn96uEyTDhCowGvvX8cJIZsUpo5BM9VGFPtvQrjlmexIi
         1VcBSgzcUnWG0YzIRVYeAm8YYqg4mF2rhEe8bimf75CfsdkwRKEslB74UVggQz7S4qDv
         D66g==
X-Gm-Message-State: AOJu0YzFkarkKQzVaVaCbp4V/BZr8e79NO2UbXqT1h0qb7RAWcru6Abw
	hU7oPRfTov3sJve9ClFAPTzlJ4Ru3WdO7Ur5dZ2385dAJtuSV39WVincgZbFoAYoxFM=
X-Gm-Gg: ASbGnctqI0d9QetFwUNuUID0A4H00tZpiuI3dDdjN6FvnGe192d2XJKxJfLVAhzBg/T
	tA17AF4SkrY8vnK9iaqIxiJJorz4m5GNyPd7TSeq0jN6IbdJBISOcbTSb4FR9GQS5G1LKgwbODk
	jI05hO8q5zCuQSxTlB3+bCSmelCWh2bNGe/4NfSFitteqZSbZ0T6h6jXV/JgYDaQeMrCOsjYsUS
	uwVF/LmMAT/fTuoWXPk5EIy/hG5T3jlK3dguWwO2l5rt63z2z4C53UErrMm8+FuKWEIDUsrYdRZ
	/Am3NjsJbRtLSQBWoisuq9luVLkXnG36IP2UMnPLkLGJbU+/Jfk1WvTJ++zqUHHWQHfrJ4mak4K
	eDj0ZYqMknigbd09zNPvPrZBv5jt/U2nEvrJWsS55w3h6Ol8ciqhuAgTPG9xzAvlWMO1i1MSszh
	SH1Ui+cyxmBrAAz1V1k8YILJDnh8ztWVF8z6qKSz5md5sfJDgUnyMk6d8=
X-Google-Smtp-Source: AGHT+IFi51pEeVndozZbVk5ffqZz6O/JnUbWPs1ggwiajGH4FsJL5TObcLvZXoim8SvZBxRhpZFTTA==
X-Received: by 2002:a05:6000:430e:b0:3ca:e6af:5f16 with SMTP id ffacd0b85a97d-3cae6af622cmr337379f8f.61.1756136799190;
        Mon, 25 Aug 2025 08:46:39 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5753ac36sm119190585e9.6.2025.08.25.08.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 08:46:38 -0700 (PDT)
Message-ID: <b40a4959dbe578e2400702b39b4439fd566963ef.camel@suse.com>
Subject: Re: [PATCH 15/15] libmpathpersist: Add safety check for preempting
 on key change
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 25 Aug 2025 17:46:38 +0200
In-Reply-To: <de273595e1dacc34be4a34a99e2d07e7e60d7d4f.camel@suse.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
		 <20250710181100.3997759-16-bmarzins@redhat.com>
	 <de273595e1dacc34be4a34a99e2d07e7e60d7d4f.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sun, 2025-08-24 at 23:00 +0200, Martin Wilck wrote:
> On Thu, 2025-07-10 at 14:11 -0400, Benjamin Marzinski wrote:
> > When a reservation key is changed from one non-zero value to
> > another,
> > libmpathpersist checks if the old key is still holding the
> > reservation,
> > and preempts it if it is. This was only safe if two nodes never
> > share
> > the same key. If a node uses the same key as another node that is
> > holding the reservation, and switches keys so that it no longer
> > matches,
> > it will end up preempting the reservation. This is clearly
> > unexpected
> > behavior, and it can come about by a simple accident of registering
> > a
> > device with the wrong key, and then immediately fixing it.
> >=20
> > To handle this, add code to track if a device is the reservation
> > holder
> > to multipathd. multipathd now has three new commands "getprhold",
> > "setprhold", and "unsetprhold". These commands work like the
> > equivalent
> > *prstatus commands. libmpathpersist calls setprhold on RESERVE
> > commands
> > and PREEMPT commands when the preempted key is holding the
> > reservation
> > and unsetprhold on RELEASE commands. Also, calling unsetprflag
> > causes
> > prhold to be unset as well, so CLEAR commands and REGISTER commands
> > with
> > a 0x0 service action key will also unset prhold. libmpathpersist()
> > will
> > also unset prhold if it notices that the device cannot be holding a
> > reservation in preempt_missing_path().
> >=20
> > When a new multipath device is created, its initial prhold state is
> > PR_UNKNOWN until it checks the current reservation, just like with
> > prflag. If multipathd ever finds that a device's registration has
> > been
> > preempted or cleared in update_map_pr(), it unsets prhold, just
> > like
> > with prflag.
> >=20
> > Now, before libmpathpersist preempts a reservation when changing
> > keys
> > it also checks if multipathd thinks that the device is holding
> > the reservation. If it does not, then libmpathpersist won't preempt
> > the key. It will assume that another node is holding the
> > reservation
> > with the same key.
> >=20
> > I should note that this safety check only stops a node not holding
> > the
> > reservation from preempting the node holding the reservation. If
> > the
> > node holding the reservation changes its key, but it fails to
> > change
> > the
> > resevation key, because that path is down or gone, it will still
> > issue
> > the preempt to move the reservation to a usable path, even if
> > another
> > node is using the same key. This will remove the registrations for
> > that
> > other node. It also will not work correctly if multipathd stops
> > tracking
> > a device for some reason. It's only a best-effort safety check.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =C2=A0libmpathpersist/mpath_persist_int.c | 87 ++++++++++++++++++++++++=
-
> > --
> > --
> > =C2=A0libmpathpersist/mpath_updatepr.c=C2=A0=C2=A0=C2=A0 | 19 ++++++-
> > =C2=A0libmpathpersist/mpathpr.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
> > =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> > =C2=A0multipathd/callbacks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +
> > =C2=A0multipathd/cli.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
4 +-
> > =C2=A0multipathd/cli.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
3 +
> > =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 48 ++++++++++++++++
> > =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 33 +++++++++=
+-
> > =C2=A09 files changed, 182 insertions(+), 18 deletions(-)
> >=20
>=20
> Two questions all the way down.
>=20
> > =C2=A0
> > +static void check_prhold(struct multipath *mpp, struct path *pp)
> > +{
> > +	struct prin_resp resp =3D {0};
> > +	int status;
> > +
> > +	if (mpp->prflag =3D=3D PR_UNSET) {
> > +		mpp->prhold =3D PR_UNSET;
> > +		return;
> > +	}
> > +	if (mpp->prflag !=3D PR_SET || mpp->prhold !=3D PR_UNKNOWN)
> > +		return;
>=20
> How can this situation come to pass? prflag must be PR_UNKNOWN.=20
> Shouldn't we reset prhold to PR_UNKNOWN as well?

Forget this remark. I was confused.

>=20
> > +
> > +	status =3D prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RRES_SA,
> > &resp, 0);
> > +	if (status !=3D MPATH_PR_SUCCESS) {
> > +		condlog (0, "%s: pr in read reservation command
> > failed: %d",
> > +			 mpp->wwid, status);
> > +		return;
> > +	}
> > +	mpp->prhold =3D PR_UNSET;
> > +	if (!resp.prin_descriptor.prin_readresv.additional_length)
> > +		return;
> > +
> > +	if (memcmp(&mpp->reservation_key,
> > resp.prin_descriptor.prin_readresv.key, 8) =3D=3D 0)
> > +		mpp->prhold =3D PR_SET;
> > +}
> > +
> > =C2=A0static void mpath_pr_event_handle(struct path *pp)
> > =C2=A0{
> > =C2=A0	struct multipath *mpp =3D pp->mpp;
> > @@ -4233,8 +4259,13 @@ static void mpath_pr_event_handle(struct
> > path
> > *pp)
> > =C2=A0		return;
> > =C2=A0	}
> > =C2=A0
> > -	if (update_map_pr(mpp, pp) !=3D MPATH_PR_SUCCESS)
> > +	if (update_map_pr(mpp, pp) !=3D MPATH_PR_SUCCESS) {
> > +		if (mpp->prflag =3D=3D PR_UNSET)
> > +			mpp->prhold =3D PR_UNSET;
>=20
> Perhaps we should move setting prhold to update_map_pr()?

You fixed this in your 2nd set.

Martin
