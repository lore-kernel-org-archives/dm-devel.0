Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3179E21765B
	for <dm-devel@lists.linux.dev>; Wed, 24 Sep 2025 18:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739061; cv=none; b=E+2c6HbwIwZa4dVw/e062523pSPlDQ1WgyaA40tFu4jz1bgG1sicK8/49GK8tyqMZUbS/bBhmaXi6HJFWmtu2r15+bmphHOMUULm69mozBqgk9Q6f/gnTYRfy+zX1UQQv5jMZk8TTpn7Geqtx2LwMpYcCThScs9qhuQwK3tzUCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739061; c=relaxed/simple;
	bh=H8Z1+Wb3OKRwx569ctVEGoJwrJTpYlQX+RPWfoxXKc0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OE7Jsrd18/7jzq0xrsZB303T2fopf6aBkyzb/x3EhgirfG0B3JvfsZ5xTRPfTcgR4GiOLxV0AXrn/dnEY+BYP/OCaV9TT7fv9dE50JnQxFcrWgGl9xX1ocihmZaNKvjlqCi38LLOo1d42fq+FDoFem2Gu3w3eissineaU8IwHnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P8hboc3L; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P8hboc3L"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso668655e9.3
        for <dm-devel@lists.linux.dev>; Wed, 24 Sep 2025 11:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758739057; x=1759343857; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AiHYoYe720J77PLhDqCySZbm7w79NhGBZIaGqNsvUKc=;
        b=P8hboc3LZAbsn3IVBSeHTwDRmuCFiUKS5coVkbcjuwJ+zuVf9Rc/Ic3e4HgDieP5J6
         FSXaiHpquHHQODwYGfxvQYFSkbUXZCYsfFwJPtbItUdH8E6W2946lAaCkCRca8a+nX4s
         KfSQ50zmoNO7/5b6LTxCusnVX6WzMpvkbVfLepEA9JRWPy9szEcjHpKgChbxbPf0Ma/7
         B4DWyjO22rSyjX1BGrhj996PxHlCOezBArHabaeufPQvZFiSP2SbsOc95lAGeIZD2o9h
         tJuiKt5csQ9P4ennY5gq4BNdtom4M9xaMAQE7iFSgBIyYKErach54X4ZN55V4tixDRGK
         6xoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739057; x=1759343857;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AiHYoYe720J77PLhDqCySZbm7w79NhGBZIaGqNsvUKc=;
        b=VfdY1lHpKo/6Mj7YC5eFXHpuYJ94vSDQvkf0FvxuygvLJWUhLGfYia6kmmWvet2SMS
         Ak3c2HTnF9LHl+u4iD+HOeU32RIkgjkM2nYVqsaCqRdW+QeZ63j64ivwWHA2o1/Fr/rV
         mX1yk7xYpObByZF/T7fhJToM2rwwAdoipKnKOZQOMRPPYd5D1MhJK8NKMCcgrz73cV0X
         ftwiEZg9VyeOxaBPP2AZJab/qTXqQcjGXHDFSCN+eKSn0ywcldGebKMEW72ztRKkAPyb
         GkgzATVkhjMjvEJso6zWkfAMB7lc32Ltj5TZxlNFqUzfRAO4jmKsVFspzVRM0BbFwYBL
         lxfg==
X-Gm-Message-State: AOJu0YxpbE5jLAlWivD6IcwTfCoHr65cio89kOHavj3DQsp9WTGPrWFb
	DzdIGksS119X6DWU2v/HUEtIM2NRNExtRgS9gkVMBFIU3HYXVOib421QXcrmg4WhHJs=
X-Gm-Gg: ASbGncs74AsYfqiTmQyfQfyHcZ/xWNcQrclcCumEdxr3BvBj03Enj1snZGrq6OUCUOX
	xA/M0+lxIim+eLjFi/VbzpyqgSlI8l9HQR1T7+dvdmK+EaiGnPWTaTSUWGTdQeN4EqWAHKe0YAS
	YZuAuiXrKLyOtlVWRjPDcnZdlsSI0tzdFZrkfAD6tc8khl1JgthzeuvjWEGUUsrsyEB7iMSlNxJ
	g98/SOFoMD4hbLVTx68YVkpG6JHR5VnMNmr4lZHw4ZNNan3MjIq9GLmq4POU76/rQxIdxnD90Iv
	4G+nf6M4MyB/v6lMbP6jcbhjBmQQjMkNuPuxcPxlIBa9ZnO3vyacINSeKDsTIOxqBAnGLGXLPja
	Q4XDOdH4o8yhoNtDTTIs+ZcbQmY/z+ET2mmhzrLo1JffdDovLwuGbNsKKaMzUI9o85AqIGzUC3f
	0trL30yEfq3BfY2t6pidcFRcjKK3EczYIs9B243ms3/pPus3eVGTJyRe9e2g==
X-Google-Smtp-Source: AGHT+IErbK+Fj0GAsgBU2DgyrYYQWOam/hqV8S3CZjFR1S6STDBSI4QszrP+i1LgbOOEdtmo0LnOLA==
X-Received: by 2002:a05:600c:4f51:b0:45d:e0d8:a0bb with SMTP id 5b1f17b1804b1-46e329eb0f4mr8753805e9.23.1758739057333;
        Wed, 24 Sep 2025 11:37:37 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc730dsm29212894f8f.41.2025.09.24.11.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 11:37:37 -0700 (PDT)
Message-ID: <bc551cc3e2bf5df5b9ed823f89259f2df3aea64b.camel@suse.com>
Subject: Re: [PATCH 3/4] libmpathpersist: use check_holding_reservation in
 mpath_prout_rel
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 24 Sep 2025 20:37:36 +0200
In-Reply-To: <20250923221252.1411687-4-bmarzins@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
	 <20250923221252.1411687-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-09-23 at 18:12 -0400, Benjamin Marzinski wrote:
> Instead of open-coding mostly the same work, just make
> mpath_prout_rel()
> call check_holding_reservation().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 86 ++++++++++++--------------=
-
> --
> =C2=A01 file changed, 35 insertions(+), 51 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 33c9e57a..9c71011f 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -639,12 +639,42 @@ static int preempt_all(struct multipath *mpp,
> int rq_servact, int rq_scope,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 noisy, false);
> =C2=A0}
> =C2=A0
> +static int reservation_key_matches(struct multipath *mpp, uint8_t
> *key,
> +				=C2=A0=C2=A0 unsigned int *type)
> +{
> +	struct prin_resp resp =3D {{{.prgeneration =3D 0}}};
> +	int status;
> +
> +	status =3D mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA,
> &resp, 0);
> +	if (status !=3D MPATH_PR_SUCCESS) {
> +		condlog(0, "%s: pr in read reservation command
> failed.", mpp->wwid);
> +		return YNU_UNDEF;
> +	}
> +	if (!resp.prin_descriptor.prin_readresv.additional_length)
> +		return YNU_NO;
> +	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8)
> =3D=3D 0) {
> +		if (type)
> +			*type =3D
> resp.prin_descriptor.prin_readresv.scope_type &
> +				MPATH_PR_TYPE_MASK;
> +		return YNU_YES;
> +	}
> +	return YNU_NO;
> +}
> +
> +static bool check_holding_reservation(struct multipath *mpp,
> unsigned int *type)
> +{
> +	if (get_be64(mpp->reservation_key) &&
> +	=C2=A0=C2=A0=C2=A0 get_prhold(mpp->alias) =3D=3D PR_SET &&
> +	=C2=A0=C2=A0=C2=A0 reservation_key_matches(mpp, (uint8_t *)&mpp-
> >reservation_key, type) =3D=3D YNU_YES)
> +		return true;
> +	return false;
> +}
> +
> =C2=A0static int mpath_prout_rel(struct multipath *mpp,int rq_servact, in=
t
> rq_scope,
> =C2=A0			=C2=A0=C2=A0 unsigned int rq_type,
> =C2=A0			=C2=A0=C2=A0 struct prout_param_descriptor * paramp,
> int noisy)
> =C2=A0{
> =C2=A0	int i, j;
> -	int num =3D 0;
> =C2=A0	struct pathgroup *pgp =3D NULL;
> =C2=A0	struct path *pp =3D NULL;
> =C2=A0	int active_pathcount =3D 0;
> @@ -652,9 +682,8 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0	int rc;
> =C2=A0	int count =3D 0;
> =C2=A0	int status =3D MPATH_PR_SUCCESS;
> -	struct prin_resp resp =3D {{{.prgeneration =3D 0}}};
> =C2=A0	bool all_threads_failed;
> -	unsigned int scope_type;
> +	unsigned int res_type;
> =C2=A0
> =C2=A0	if (!mpp)
> =C2=A0		return MPATH_PR_DMMP_ERROR;
> @@ -733,27 +762,13 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0		return status;
> =C2=A0	}
> =C2=A0
> -	status =3D mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA,
> &resp, noisy);
> -	if (status !=3D MPATH_PR_SUCCESS){
> -		condlog (0, "%s: pr in read reservation command
> failed.", mpp->wwid);
> -		return MPATH_PR_OTHER;
> -	}
> -
> -	num =3D resp.prin_descriptor.prin_readresv.additional_length /
> 8;
> -	if (num =3D=3D 0){
> -		condlog (2, "%s: Path holding reservation is
> released.", mpp->wwid);
> -		return MPATH_PR_SUCCESS;
> -	}
> -	if (!get_be64(mpp->reservation_key) ||
> -	=C2=A0=C2=A0=C2=A0 memcmp(&mpp->reservation_key,
> resp.prin_descriptor.prin_readresv.key, 8)) {
> +	if (!check_holding_reservation(mpp, &res_type)) {

The old code didn't call check_prhold() while
check_holding_reservation() does.

Is it possible that get_prhold() would return a "false negative" and
thus we'd wrongly skip releasing the reservation?

Martin
