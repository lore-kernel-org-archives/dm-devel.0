Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DD22DEA8E
	for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 18:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758564710; cv=none; b=sF6wpIqmGvV0Hk+EDn2JzcZ+PCaAFIcBoL/D+kdkDngI6ajqXtxEFaY5JFCPMkkBrKt1JtBy9aqEgCSt4LtKeZLyH3a/xx5MKFidXsvvlX4JqKDWPwHgNNih8q3E+RxhT+M61oOEXfpfaGhqc4EFMkyX4boFzOLYUQWN78oCeAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758564710; c=relaxed/simple;
	bh=F3NGd/Iy9PAa0Fxhnbsqm1E40wfqrjo18j3HneOhIOc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xwo15/Fe8Ze9k3Zq+i/bLLkr7J2Z9PY7760c5RViDmzmEk18w46S6FQ3hlLZlzBKHK7JKCKDZL0jyIGNDfhhWXlEGR0I4WPX07Tzl5E202FkB3gmDjKtcJ2Hj17e9t0+5kOh80niISnM/CEeRGuq2n6VrIsatvERJJ4lyWVuoeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Uk82VXDZ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Uk82VXDZ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46cf7bbfda8so10663905e9.2
        for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 11:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758564706; x=1759169506; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=htJkR4x3Ukqe9IpaYnVmJc55WMn5PbicFAxDfjGEHPg=;
        b=Uk82VXDZfmXEjwE0nGKIrGkou4HF6IJmmhUtIBqVjZNc/ixiciO1qNyoJ120Mkb+yQ
         RQ31LGkGzoAxAD7myk4os7hfp8c1cIwevNrBwAF0H4JSX2+CExkPcB/Po23uaqbx0a2D
         UWaj7vIcEKENetQc8EcDQweXJ7HbjcCYx6DLa4v85vOMPtNyvltDfJukzyCWddErIZR4
         oigCBVsCMK2IGMuxZIuF7sqIP+r658euw7C19agT4VSOajlWyj70QruWlLUx1hOYRJiv
         LjErfKIaehE6p6jOf+jGKZ8D2YSwClD24OoYS2raE+UgFEzZ5mDn3S0Gb5yIxe7UEXYv
         Xi1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758564706; x=1759169506;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=htJkR4x3Ukqe9IpaYnVmJc55WMn5PbicFAxDfjGEHPg=;
        b=KLh5GcjTTmvwt+sikHXRUoRcp1tZXf9pCHSRtSwp870pmSllZzV0QHNXt6fDBs0q4e
         bTax4Gbx1Rb5L+8Z3W+zGABChq1lG15XkeUCU+EK3t2rYXMbWV69qbSlM+CowuTrbJV/
         LkvPZjDJCZAR+ERmkwP6Q/UZPT8pzh9s0/QypmzotmhoVW7u3LUw6hcOg33p6OjLIG30
         BlCDzuvKVOr3Zqz1XmGvAxgTtcG2/Sb3bHAuQNFErmrw9mNSnBLzva7PqzX3bNLPXj8Q
         zMLvSr0idqXOFJocFzOHS9wNv7mV3RIqYjYuiF1UpB5/vuy/BPLn+qbNOLDHMxaQ6ADN
         4yzg==
X-Forwarded-Encrypted: i=1; AJvYcCVYWji2WwwU4kSKBaeh3z+5vI1300I3H43SOIDGHYur6E1s4UvbAgbiCgEagS0ENEtXQygs9lyxMA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzlcfJ7gfdhFC3qn7EvWJD9aA0WHwklemyfuVc7VB54OmViiwda
	5/A3/38JPf1r2oF5D+KDkTH0jkzlULSl5rHf2DuBp6Gxl8z/dUKCG7EH5huDP1xTeow=
X-Gm-Gg: ASbGnctFIbFluAKdWbELvhBJMqgdteUKLPzKEEaGuguWlRmkAwkksLgSRZjQuu5cZK6
	xzmOjHQz5UfG5YELhBpPNjwRg2hVi5fJkHXNQcrSdwwIIfoyvw6PtnMlZ0xuE1k2sVOvdlr632x
	+6NJkHpapR5LwfmDGX+TwyF4RHWLOOP4zQ4WMDFOTsy8xH97KS7LdnvIRZ6SEbigA7euvCSRhqT
	d0JnB7jExVbKVPxSOYm0yg3eYNz+TB68fnHcs3cL0whhEdR9j3i+MMwLwk9SdTrHzzwrtkXCAQC
	IAjDFzr3mEp08bVTkqXsxG9DFJ69C4HkqhYWetYnmJ5tEFrjRF+JJwj+3E/KitisvoPW/W15xvY
	4rhBrrYuukfOR+wLndvIWWyLPwiEyOJJyS0qq3vc7XRTUHwBO59mI8Z26xrI3/cy8K4BR2P3zDo
	89MBuGRZePNMheFUOgbxRNM8KRxnLVxqwrc7DdPqhCGYHID+FXAsJ8t3INgw==
X-Google-Smtp-Source: AGHT+IGS8ZM4EBDDoaH760e+p4h+spHYrkOcRcpP8xjhqt+UbFTq6c4Jk+NSJvcDLbzssVRzLlCijQ==
X-Received: by 2002:a05:6000:4310:b0:3fb:9950:b9fe with SMTP id ffacd0b85a97d-3fb9950bebfmr4126873f8f.47.1758564706137;
        Mon, 22 Sep 2025 11:11:46 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613d14d212sm276808215e9.12.2025.09.22.11.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 11:11:45 -0700 (PDT)
Message-ID: <8bfdebc6e1b7687d17e1d388935351575edbb160.camel@suse.com>
Subject: Re: [PATCH 2/2] libmpathpersist: handle preempting all registrants
 reservations
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Mon, 22 Sep 2025 20:11:45 +0200
In-Reply-To: <aNGQ7ZqwHEwA27L8@redhat.com>
References: <20250910225812.829847-1-bmarzins@redhat.com>
	 <20250910225812.829847-3-bmarzins@redhat.com>
	 <82a83835794202de7fe4f2093802d51df888a50d.camel@suse.com>
	 <aNGQ7ZqwHEwA27L8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-09-22 at 14:09 -0400, Benjamin Marzinski wrote:
> On Mon, Sep 22, 2025 at 06:53:05PM +0200, Martin Wilck wrote:
> > On Wed, 2025-09-10 at 18:58 -0400, Benjamin Marzinski wrote:
> > > All Registrants reservations (types 7 and 8) are held by key 0x0.
> > > When
> > > preempting one, all registrations are cleared, except for the one
> > > on
> > > the
> > > path that issued the PREEMPT. libmpathpersist needs to handle
> > > this
> > > just
> > > like the other cases of self-preemption, so that all the paths of
> > > the
> > > preempting multipath device have their registrations restored
> > > while
> > > the
> > > device is suspended.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0libmpathpersist/mpath_persist_int.c | 31
> > > +++++++++++++++++++++++++--
> > > --
> > > =C2=A01 file changed, 27 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/libmpathpersist/mpath_persist_int.c
> > > b/libmpathpersist/mpath_persist_int.c
> > > index 9f301859..ab3d70cd 100644
> > > --- a/libmpathpersist/mpath_persist_int.c
> > > +++ b/libmpathpersist/mpath_persist_int.c
> > > @@ -569,8 +569,9 @@ static int mpath_prout_reg(struct multipath
> > > *mpp,int rq_servact, int rq_scope,
> > > =C2=A0 * is suspended before issuing the preemption, and the keys are
> > > reregistered
> > > =C2=A0 * before resuming it.
> > > =C2=A0 */
> > > -static int preempt_self(struct multipath *mpp, int rq_servact,
> > > int
> > > rq_scope,
> > > -			unsigned int rq_type, int noisy, bool
> > > do_release)
> > > +static int do_preempt_self(struct multipath *mpp, struct be64
> > > sa_key,
> > > +			=C2=A0=C2=A0 int rq_servact, int rq_scope,
> > > unsigned
> > > int rq_type,
> > > +			=C2=A0=C2=A0 int noisy, bool do_release)
> > > =C2=A0{
> > > =C2=A0	int status, rel_status =3D MPATH_PR_SUCCESS;
> > > =C2=A0	struct path *pp =3D NULL;
> > > @@ -583,7 +584,7 @@ static int preempt_self(struct multipath
> > > *mpp,
> > > int rq_servact, int rq_scope,
> > > =C2=A0	}
> > > =C2=A0
> > > =C2=A0	memcpy(paramp.key, &mpp->reservation_key, 8);
> > > -	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
> > > +	memcpy(paramp.sa_key, &sa_key, 8);
> > > =C2=A0	status =3D mpath_prout_common(mpp, rq_servact, rq_scope,
> > > rq_type,
> > > =C2=A0				=C2=A0=C2=A0=C2=A0 &paramp, noisy, &pp);
> > > =C2=A0	if (status !=3D MPATH_PR_SUCCESS) {
> > > @@ -619,6 +620,21 @@ fail_resume:
> > > =C2=A0	return (rel_status !=3D MPATH_PR_SUCCESS) ? rel_status :
> > > status;
> > > =C2=A0}
> > > =C2=A0
> > > +static int preempt_self(struct multipath *mpp, int rq_servact,
> > > int
> > > rq_scope,
> > > +			unsigned int rq_type, int noisy, bool
> > > do_release)
> > > +{
> > > +	return do_preempt_self(mpp, mpp->reservation_key,
> > > rq_servact, rq_scope,
> > > +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rq_type, noisy, do_release);
> > > +}
> > > +
> > > +static int preempt_all(struct multipath *mpp, int rq_servact,
> > > int
> > > rq_scope,
> > > +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int rq_type, int noi=
sy)
> > > +{
> > > +	struct be64 zerokey =3D {0};
> > > +	return do_preempt_self(mpp, zerokey, rq_servact,
> > > rq_scope,
> > > rq_type,
> > > +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 noisy, false);
> > > +}
> > > +
> > > =C2=A0static int mpath_prout_rel(struct multipath *mpp,int rq_servact=
,
> > > int
> > > rq_scope,
> > > =C2=A0			=C2=A0=C2=A0 unsigned int rq_type,
> > > =C2=A0			=C2=A0=C2=A0 struct prout_param_descriptor *
> > > paramp,
> > > int noisy)
> > > @@ -889,8 +905,15 @@ int do_mpath_persistent_reserve_out(vector
> > > curmp, vector pathvec, int fd,
> > > =C2=A0		break;
> > > =C2=A0	case MPATH_PROUT_PREE_SA:
> > > =C2=A0	case MPATH_PROUT_PREE_AB_SA:
> > > -		if (reservation_key_matches(mpp, paramp->sa_key,
> > > noisy) =3D=3D YNU_YES)
> > > +		if (reservation_key_matches(mpp, paramp->sa_key,
> > > noisy) =3D=3D YNU_YES) {
> > > =C2=A0			preempting_reservation =3D true;
> > > +			if (memcmp(paramp->sa_key, &zerokey, 8)
> > > =3D=3D
> > > 0) {
> >=20
> >=20
> > Don't you need to check if pr_type is 7 or 8 here?
>=20
> I don't think so. When we get here, we know that the reservation is
> reported to be held by the key 0x0. That's obviously not a valid
> registered key. I'm pretty sure that a SCSI device will only report
> this
> reservation key in the "all registrants" case, and that "all
> registrants" reservations will always report 0x0 as the key.

Ok, fine. Thanks for confirming.

>=20
> That being said, I needed to make reservation_key_matches() return
> the
> reservation type to handle a different issue, so it's pretty trivial
> to
> make this code double-check it for this case.

Not necessary, thanks.

Martin

