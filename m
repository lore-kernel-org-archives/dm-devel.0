Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D301F4C96
	for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 15:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756049218; cv=none; b=K/XLiLquPDywVcNPDKQgQfaAQqjM7dcoB0UcPkNQBOTkHgxj41JRu6CXgWKXYlLx+IzbvPr9PapW69zEcjdVZD/CTgKkvZUgWbAZMaiqj53tiqHpAYWQ6xAfKgINAr7qhRXXdlklt4Hzqy89rH4Uvjl1/7ApC5U7czLe0/gSKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756049218; c=relaxed/simple;
	bh=ysh7+9GVDQgcjRQhIJkymE7LRET/JD/fvR5aggiQUqM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JU7+e6KJqPjDqbOnHpytGJOqOd0IK3Rgb0U07DM7nRWQc5noUus+CQ1Zp2ln/w7+J3N6Rw77YYgnOxlrG+gHzOhYYuZIiFCCAOOlmURZJrBt6LR2zu2Aul57HiPcuA0KkZznA2fGHykdgbLF4mO9uMWTCl9Qpu0ofc6ZgYTI6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R09+uq4d; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R09+uq4d"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb78da8a7so557470766b.1
        for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 08:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756049212; x=1756654012; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O32LjaMoAXiWt+NyEgHgdeXhUkZPn/CNnINac3VCbNw=;
        b=R09+uq4dde7bQS30KCHzxdXW5QvkwlgGc6OEPoSwmkxFi3KZS3+qklJHfKWVCBqrDN
         jG/HG7z7Rm/L8fctvDEBMVLdFHjoBw6fMgPXI8DRoOhLkfqCfhnEczh1yZARD594xISD
         /46d/MHztSJNQ4RnQ3W2xb8PMMosJBSCIQxhRTa+41OAsZQZ8zP/1AkQopuU/imQYBMk
         wTL2YAAmta+x9qWKj03WJSwmwa5LqTy0eMVh9oTk1MZfDJB+fLYApTjM0ioCYtDgXgL8
         5WTBrWk0ZnbQdZqWU0ZT49iX63Pqvbcudgj2AK4l+sPeGOvTmeNikN1zOfnqU0u1pk8m
         mv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756049212; x=1756654012;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O32LjaMoAXiWt+NyEgHgdeXhUkZPn/CNnINac3VCbNw=;
        b=VBIhBn2xEeFMAg6w6wiQDlKO0uoqutH++jYBctWMu/OCGe0ortjkaeSNet2TVcPgBE
         1uszNtFK2YsrY7VZXgat/9/4/KStHyGAF/g+0Fn4796q6WdCic0clBiDFSk7pi9eg7bd
         /e5OgsCuK6XyMxaboat0eSx9rooEBtmfxv/o4zpMUFsJkBbYuD3N6AAmiR2S9WvMVF/9
         QEYo20XfulCjXDPcNnQyqBmHorbpoZLJUfoGIjgJqbbBz3oxBzq3+fxHdybYxe8MB6pL
         DUZo4cyfTMQigLIybnzI3Xb+O+wYd7m4di8uHJSP/oOWMOSNX9+zShACaMxvHUbgUbTH
         aSVw==
X-Gm-Message-State: AOJu0YwnFnPcE7dzgniODdfRL5q5i1+6qM+lHqUzlb0s44CzRSkUEwbh
	ZDZUjdphq16b8FgTY1Ui2EJtgNRQ4E8A3WbvvoT3Dkr1BQvsFg2kcHszU2vaFwsD/+kq98X6Vu1
	6h4pkkjI=
X-Gm-Gg: ASbGncsV+LkFy9vugUkq6YzqYHfIrxYwjlaPFJROW8j1V91vRcCrAngGj+4SnuNS/o5
	KJy0VV/eViw23CW52/oXBbMW8v4qPMuU4ffJtCvEGS7kJgAWMB6KM/BxRZ53uMxRCFR98/v8zxp
	XOSyBrUE+twLmzS6OsQw5DMmceLDZnrRTgsOX85HIh6pfUiVl3OGbEXrfcULF79wHR2pa+b3iHR
	yHtlHnB5v0iWvr4CeEP6AEvi7h6QLdQgBlDcArllzbNqL9KLJMi8Ql0/iTA+f2kFQ6Fxx1mxNf3
	3EoSjiTl3B8JSeu8J31AiCCbDO1d5v6hVkvV0beWOBZkci2K6/C/A9oUxZcgag5JSfM6mZrU0IJ
	u8EC0icdXsrlkzibaAjWxynTHcgOwRSwfAuUXv9Aq1s0ZOolg4Wi+s7abz4h4MRdqgKw//DtXOK
	PFhVFsXZhMsVzNUMrK7bAqGFzoO/Zmx8rmHUm+H6haNJZG+luGMpcQ/g==
X-Google-Smtp-Source: AGHT+IFpElD3UCEkjBEUuUNXusJDKVCJfeusSiDu/0JEDBRR4EDpNqXhxzJWt9/8RQs9Rge98D3JYg==
X-Received: by 2002:a17:907:86a6:b0:af9:34d0:836f with SMTP id a640c23a62f3a-afe29446a55mr863874466b.27.1756049212200;
        Sun, 24 Aug 2025 08:26:52 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe48fbdbf6sm386404466b.36.2025.08.24.08.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 08:26:51 -0700 (PDT)
Message-ID: <dc941be94accce6ed554eac92f833cbb8e69263b.camel@suse.com>
Subject: Re: [PATCH 09/15] limpathpersist: redesign failed release workaround
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 24 Aug 2025 17:26:50 +0200
In-Reply-To: <20250710181100.3997759-10-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-10-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi Ben,

I like this approach, but I have a few questions.

On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> The workaround for releasing a reservation held by a failed path
> (clearing all persistent reservation data and then reregistering all
> the
> keys) has several problems. It requires devices that support the READ
> FULL STATUS command and are capable of specifying TransportIDs with
> REGISTRATION commands (SIP_C), neither of which are mandatory to
> support
> SCSI Persistent Reservations.

While I have made similar experiences, I wonder where the SCSI specs
state which service actions and which parameters are mandatory for
Persistent Reservation commands.

I've tried to figure it out from SPC-6, but I couldn't.

>  Non SIP_C devices will be left with no
> registered keys. Also, not all cleared keys are registered, just the
> ones going to the Target Port receiving the REGISTRATION command. To
> reregister all the keys, the code would have to also use the "All
> Target
> Ports" flag to register keys on different Target Ports, but this
> could
> end up registering keys on paths they aren't supposed to be on (for
> instance if one of the registered keys was only there because the
> path
> was down and it couldn't be released).
>=20
> The redesign avoids these issues by only using mandatory Persistent
> Reservation commands, without extra optional parameters or flags, and
> only effects the keys of the multipath device it is being issued on.
> The new workaround is:
> 1. Suspend the multipath device to prevent I/O
> 2. Preempt the key to move the reservation to an available path. This
> =C2=A0=C2=A0 also removes the registered keys from every path except the =
path
> =C2=A0=C2=A0 issuing the PREEMPT command. Since the device is suspended, =
not
> I/O
> =C2=A0=C2=A0 can go to these unregisted paths and fail.
> 3. Release the reservation on the path that now holds it.

Why that? Can't the reservation just be kept?

> 4. Resume the device (since it no longer matters that most of the
> paths
> =C2=A0=C2=A0 no longer have a registered key)
> 5. Reregister the keys on all the paths.

Why not re-register before resuming?

>=20
> If steps 3 or 4 fail, the code will attempt to reregister the keys,
> and
> then attempt (or possibly re-attempt) the resume.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 173 ++++++++++++-------------=
-
> --
> =C2=A0libmultipath/libmultipath.version=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A02 files changed, 76 insertions(+), 98 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 13829742..7fb08b2e 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -366,7 +366,8 @@ static int mpath_prout_reg(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0
> =C2=A0static int mpath_prout_common(struct multipath *mpp,int rq_servact,
> int rq_scope,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int rq_type,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct prout_param_descriptor* paramp,
> int noisy)
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct prout_param_descriptor* paramp,
> int noisy,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct path **pptr)
> =C2=A0{
> =C2=A0	int i,j, ret;
> =C2=A0	struct pathgroup *pgp =3D NULL;
> @@ -385,6 +386,8 @@ static int mpath_prout_common(struct multipath
> *mpp,int rq_servact, int rq_scope
> =C2=A0			found =3D true;
> =C2=A0			ret =3D prout_do_scsi_ioctl(pp->dev,
> rq_servact, rq_scope,
> =C2=A0						=C2=A0 rq_type, paramp,
> noisy);
> +			if (ret =3D=3D MPATH_PR_SUCCESS && pptr)
> +				*pptr =3D pp;
> =C2=A0			if (ret !=3D MPATH_PR_RETRYABLE_ERROR)
> =C2=A0				return ret;
> =C2=A0		}
> @@ -405,14 +408,12 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0	struct path *pp =3D NULL;
> =C2=A0	int active_pathcount =3D 0;
> =C2=A0	pthread_attr_t attr;
> -	int rc, found =3D 0;
> +	int rc;
> =C2=A0	int count =3D 0;
> =C2=A0	int status =3D MPATH_PR_SUCCESS;
> -	struct prin_resp resp;
> -	struct prout_param_descriptor *pamp =3D NULL;
> -	struct prin_resp *pr_buff;
> -	int length;
> -	struct transportid *pptr =3D NULL;
> +	struct prin_resp resp =3D {0};
> +	uint16_t udev_flags =3D (mpp->skip_kpartx) ?
> MPATH_UDEV_NO_KPARTX_FLAG : 0;
> +	bool did_resume =3D false;
> =C2=A0
> =C2=A0	if (!mpp)
> =C2=A0		return MPATH_PR_DMMP_ERROR;
> @@ -502,104 +503,78 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0	}
> =C2=A0
> =C2=A0	condlog (2, "%s: Path holding reservation is not
> available.", mpp->wwid);
> -
> -	pr_buff =3D=C2=A0 mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
> -	if (!pr_buff){
> -		condlog (0, "%s: failed to=C2=A0 alloc pr in response
> buffer.", mpp->wwid);
> +	/*
> +	 * Cannot free the reservation because the path that is
> holding it
> +	 * is not usable. Workaround this by:
> +	 * 1. Suspending the device
> +	 * 2. Preempting the reservation to move it to a usable path
> +	 *=C2=A0=C2=A0=C2=A0 (this removes the registered keys on all paths exc=
ept
> the
> +	 *=C2=A0=C2=A0=C2=A0 preempting one. Since the device is suspended, no =
IO
> can
> +	 *=C2=A0=C2=A0=C2=A0 go to these unregistered paths and fail).
> +	 * 3. Releasing the reservation on the path that now holds
> it.
> +	 * 4. Resuming the device (since it no longer matters that
> most of
> +	 *=C2=A0=C2=A0=C2=A0 that paths no longer have a registered key)
> +	 * 5. Reregistering keys on all the paths
> +	 */
> +
> +	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp->alias, 0))
> {
> +		condlog(0, "%s: release: failed to suspend dm
> device.",

Why do you use dm_simplecmd_noflush() here? Shouldn't queued IO be
flushed from the dm device to avoid it being sent to paths that are
going to be unregistered?


> mpp->wwid);
> =C2=A0		return MPATH_PR_OTHER;
> =C2=A0	}
> =C2=A0
> -	status =3D mpath_prin_activepath (mpp, MPATH_PRIN_RFSTAT_SA,
> pr_buff, noisy);
> -
> -	if (status !=3D MPATH_PR_SUCCESS){
> -		condlog (0,=C2=A0 "%s: pr in read full status command
> failed.",=C2=A0 mpp->wwid);
> -		goto out;
> -	}
> -
> -	num =3D pr_buff-
> >prin_descriptor.prin_readfd.number_of_descriptor;
> -	if (0 =3D=3D num){
> -		goto out;
> -	}
> -	length =3D sizeof (struct prout_param_descriptor) + (sizeof
> (struct transportid *));
> -
> -	pamp =3D (struct prout_param_descriptor *)malloc (length);
> -	if (!pamp){
> -		condlog (0, "%s: failed to alloc pr out parameter.",
> mpp->wwid);
> -		goto out;
> -	}
> -
> -	memset(pamp, 0, length);
> -
> -	pamp->trnptid_list[0] =3D (struct transportid *) malloc
> (sizeof (struct transportid));
> -	if (!pamp->trnptid_list[0]){
> -		condlog (0, "%s: failed to alloc pr out
> transportid.", mpp->wwid);
> -		goto out1;
> -	}
> -	pptr =3D pamp->trnptid_list[0];
> -
> -	if (get_be64(mpp->reservation_key)){
> -		memcpy (pamp->key, &mpp->reservation_key, 8);
> -		condlog (3, "%s: reservation key set.", mpp->wwid);
> +	memset(paramp, 0, sizeof(*paramp));
> +	memcpy(paramp->key, &mpp->reservation_key, 8);
> +	memcpy(paramp->sa_key, &mpp->reservation_key, 8);
> +	status =3D mpath_prout_common(mpp, MPATH_PROUT_PREE_SA,
> rq_scope, rq_type,
> +				=C2=A0=C2=A0=C2=A0 paramp, noisy, &pp);
> +	if (status !=3D MPATH_PR_SUCCESS) {
> +		condlog(0, "%s: release: pr preempt command
> failed.", mpp->wwid);
> +		goto fail_resume;
> =C2=A0	}
> =C2=A0
> -	status =3D mpath_prout_common (mpp, MPATH_PROUT_CLEAR_SA,
> -				=C2=A0=C2=A0=C2=A0=C2=A0 rq_scope, rq_type, pamp,
> noisy);
> -
> -	if (status) {
> -		condlog(0, "%s: failed to send CLEAR_SA", mpp-
> >wwid);
> -		goto out2;
> +	memset(paramp, 0, sizeof(*paramp));
> +	memcpy(paramp->key, &mpp->reservation_key, 8);
> +	status =3D prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REL_SA,
> rq_scope,
> +				=C2=A0=C2=A0=C2=A0=C2=A0 rq_type, paramp, noisy);
> +	if (status !=3D MPATH_PR_SUCCESS) {
> +		condlog(0, "%s: release on alternate path failed.",
> mpp->wwid);
> +		goto out_reregister;
> =C2=A0	}
> =C2=A0
> -	pamp->num_transportid =3D 1;
> -
> -	for (i =3D 0; i < num; i++){
> -		if (get_be64(mpp->reservation_key) &&
> -			memcmp(pr_buff-
> >prin_descriptor.prin_readfd.descriptors[i]->key,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &mpp->reservation_key, 8)){
> -			/*register with transport id*/
> -			memset(pamp, 0, length);
> -			pamp->trnptid_list[0] =3D pptr;
> -			memset (pamp->trnptid_list[0], 0, sizeof
> (struct transportid));
> -			memcpy (pamp->sa_key,
> -					pr_buff-
> >prin_descriptor.prin_readfd.descriptors[i]->key, 8);
> -			pamp->sa_flags =3D MPATH_F_SPEC_I_PT_MASK;
> -			pamp->num_transportid =3D 1;
> -
> -			memcpy (pamp->trnptid_list[0],
> -					&pr_buff-
> >prin_descriptor.prin_readfd.descriptors[i]->trnptid,
> -					sizeof (struct
> transportid));
> -			status =3D mpath_prout_common (mpp,
> MPATH_PROUT_REG_SA, 0, rq_type,
> -					pamp, noisy);
> -
> -			pamp->sa_flags =3D 0;
> -			memcpy (pamp->key, pr_buff-
> >prin_descriptor.prin_readfd.descriptors[i]->key, 8);
> -			memset (pamp->sa_key, 0, 8);
> -			pamp->num_transportid =3D 0;
> -			status =3D mpath_prout_common (mpp,
> MPATH_PROUT_REG_SA, 0, rq_type,
> -					pamp, noisy);
> -		}
> -		else
> -		{
> -			if (get_be64(mpp->reservation_key))
> -				found =3D 1;
> -		}
> -
> -
> -	}
> -
> -	if (found){
> -		memset (pamp, 0, length);
> -		memcpy (pamp->sa_key, &mpp->reservation_key, 8);
> -		memset (pamp->key, 0, 8);
> -		status =3D mpath_prout_reg(mpp, MPATH_PROUT_REG_SA,
> rq_scope, rq_type, pamp, noisy);
> +	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
> udev_flags)) {
> +		condlog(0, "%s release: failed to resume dm
> device.", mpp->wwid);
> +		/*
> +		 * leave status set to MPATH_PR_SUCCESS, we will
> have another
> +		 * chance to resume the device.
> +		 */
> +		goto out_reregister;
> +	}
> +	did_resume =3D true;
> +
> +out_reregister:
> +	memset(paramp, 0, sizeof(*paramp));
> +	memcpy(paramp->sa_key, &mpp->reservation_key, 8);
> +	rc =3D mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA, rq_scope,
> rq_type,
> +			=C2=A0=C2=A0=C2=A0=C2=A0 paramp, noisy);
> +	if (rc !=3D MPATH_PR_SUCCESS)
> +		condlog(0, "%s: release: failed to reregister
> paths.", mpp->wwid);
> +
> +	/*
> +	 * If we failed releasing the reservation or resuming
> earlier
> +	 * try resuming now. Otherwise, return with the
> reregistering status
> +	 * This means we will report failure, even though the
> resevation
> +	 * has been released, since the keys were not reregistered.
> +	 */
> +	if (did_resume)
> +		return rc;
> +	else if (status =3D=3D MPATH_PR_SUCCESS)
> +		status =3D rc;
> +fail_resume:
> +	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
> udev_flags)) {
> +		condlog(0, "%s: release: failed to resume dm
> device.", mpp->wwid);
> +		if (status =3D=3D MPATH_PR_SUCCESS)
> +			status =3D MPATH_PR_OTHER;
> =C2=A0	}
> -
> -out2:
> -	free(pptr);
> -out1:
> -	free (pamp);
> -out:
> -	free (pr_buff);
> =C2=A0	return (status =3D=3D MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER
> : status;
> =C2=A0}
> =C2=A0
> @@ -620,6 +595,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0	mpp->mpe =3D find_mpe(conf->mptable, mpp->wwid);
> =C2=A0	select_reservation_key(conf, mpp);
> =C2=A0	select_all_tg_pt(conf, mpp);
> +	select_skip_kpartx(conf, mpp);

I understand that this is because of the DM_DEVICE_RESUME, but it
deserves a comment here as it seems a bit out of place in this code
that deals only with persistent reservations. Actually, we may want to
move this logic to dm_simplecmd().

Thanks,
Martin

> =C2=A0	put_multipath_config(conf);
> =C2=A0
> =C2=A0	memcpy(&prkey, paramp->sa_key, 8);
> @@ -661,7 +637,8 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0	case MPATH_PROUT_PREE_SA :
> =C2=A0	case MPATH_PROUT_PREE_AB_SA :
> =C2=A0	case MPATH_PROUT_CLEAR_SA:
> -		ret =3D mpath_prout_common(mpp, rq_servact, rq_scope,
> rq_type, paramp, noisy);
> +		ret =3D mpath_prout_common(mpp, rq_servact, rq_scope,
> rq_type,
> +					 paramp, noisy, NULL);
> =C2=A0		break;
> =C2=A0	case MPATH_PROUT_REL_SA:
> =C2=A0		ret =3D mpath_prout_rel(mpp, rq_servact, rq_scope,
> rq_type, paramp, noisy);
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index a6718355..2f47b3ad 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -249,4 +249,5 @@ local:
> =C2=A0LIBMULTIPATH_29.1.0 {
> =C2=A0global:
> =C2=A0	can_recheck_wwid;
> +	select_skip_kpartx;
> =C2=A0} LIBMULTIPATH_29.0.0;
