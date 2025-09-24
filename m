Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4C8834
	for <dm-devel@lists.linux.dev>; Wed, 24 Sep 2025 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758738175; cv=none; b=IxXGLo1a3JXrQPdOIoWpw8dtuzsMe2c8X8ftvsaky34gXnlSvgFO8ntKc8Mmd6k8ZfNHfA4Js0RaoSSpBuscI8FqcgDtea0vrY0IShP/EtsETqW/m2grxNRjx/89zxKQypjMbXoSsZ4eTfZVDPf6io58DJCvzgn6v92tAaMbYr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758738175; c=relaxed/simple;
	bh=fnssrh3arn5RXI0WVGyWBK2eJ3QiJT0aFJ5keeb8imQ=;
	h=Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 MIME-Version:Date; b=EitrufUCcEhfCDUOL1rCt+P9jibSkydxU+DoZiMHbnmXjIDxYLqSPI/iaNdm2euT4nYv3MtzZ0BN5+noeJf+/N6a4FOZiil8NP73ro1pX/36gOjV0E5C8PNVBYIgkUBUUE9+Hm4MOuiLn76A8ht+ojHBJguQCb2lxNU34zreRPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ONV5JcEJ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ONV5JcEJ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3f42b54d1b9so205764f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 24 Sep 2025 11:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758738171; x=1759342971; darn=lists.linux.dev;
        h=user-agent:date:mime-version:content-transfer-encoding:references
         :in-reply-to:cc:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lwhvk2+v10A72wuER5rLnkT6+hPScst7FX8kuuWxMZs=;
        b=ONV5JcEJL6HkJKnFpzpN7WwboeP1AC18O+KhGUAj1nttAmdnEbAabXqUi4AiGCZDbb
         k+UWFTX/zP80MxqIPK7OKN4XNosfCgFdFgIifXChHAlILUOB7Mt7m/JZepdfO4JqEOtG
         kFFv+lwQnCdHzz/LfAOduvq/FVEfK9jG2LaAnn35OJY7+lzv14zi/ulTHocS6juoJQzU
         nX/sIHxF4bopGN+HVnZg2gTsKtDQWia9fk4857skGpS1LchosnG8dWjoBkuItdb+N9Co
         6uciE+fSmgWN2M5bT+ajaAs47DvYlca0p9KYdviVZjZ770FAnCo3vhuRsMyJTmZMYLxS
         LiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758738171; x=1759342971;
        h=user-agent:date:mime-version:content-transfer-encoding:references
         :in-reply-to:cc:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lwhvk2+v10A72wuER5rLnkT6+hPScst7FX8kuuWxMZs=;
        b=F2A6yY75EwMopzdmzDzj02wfakn0x7lcT5tijjKGqLbwf/V4alr+RqKWSOVrWhcoyQ
         8K2rv4J/ZhxHUuHz93i9eLyAVZt5cfixETI9aqlisJrNCdEUsGkIsh9t5kSMh89eDbyL
         gPc7JALVFlr5bva4ihhEeoehjL/JWucmreIHmKDCQ5GPijibCUOLyo7B1AWkManK5s5F
         9fKP1TTeyi9tho8dV38F+XGloasULLBlNoErVfS2xWhifE1yjeypJkgtKzalSLM5wb78
         A/WE+MYeCCwsYm23O22f0zeddWDVK8u5kDuWP/r0hNUZLtUDPtuQ3sz5Xosm8Ng71MSH
         t2vA==
X-Gm-Message-State: AOJu0Yw7B+SZI5TR8UNm+mf9Zsi3iNqRTOv5L0tr2cyKtROOSMnZHylx
	VYeIJHLl+eRNAPDE6q7AFIl2OuxdR5sYcMYwNdmeY26ByqYreKANFACMnyXsIMEFn4tnsFmE5x8
	J5CkZ
X-Gm-Gg: ASbGncuLyYisc2V9VFktwlFiGT98HXI5rr4znTzx+jhDHNST6kaXAulXsvq5vVBhPww
	NWQUub5HhIHjUqRtkGrTrV3akgLIHibscwBcNF8iPDULxU8xYzVzXO0R2YY0J664uSWJoEuzrQx
	ml90noZiYGRMFmdilIpQA+jAjw+kBlgtS/mH6cGIvqgyz+rjK4EV1okB55YUEV7Db8UUpeEIx+Q
	S+3GJRyqLmJtspds2JThRtysAxdbgkj7RF/DZfWAfGva+i0eEgX76blmnBh+nLOubzmVhkwvPmU
	kx+Zu8jBAkNj10q0K5z8FzEp7UNGJ94FDchiVC5tbiK800v/0fnZVbkwbVn8Oszt6/uAXSx9/VN
	NQqytKisRmD4WxJt5O2dJvhR0Fl0o+GR0o5YKZbeblx+LfNKWg5Ynk4jA4cBdjCsBwm7PTm0FmK
	qPEzCpo9NMC4Qd/HSMz6rPcgwZHB8aRKQYgH7GOdXKykkSq86DYJwx4EcpmA==
X-Google-Smtp-Source: AGHT+IHx1wosaA96X5E3sagyX5xxWHtGlN5R0q+X6kLM2mb+oPHwIALn5WAjstsj86pK5JBgxn1MMw==
X-Received: by 2002:a5d:64e8:0:b0:3ff:17ac:a34b with SMTP id ffacd0b85a97d-40e499acbf7mr802453f8f.42.1758738170831;
        Wed, 24 Sep 2025 11:22:50 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407fa3sm28937036f8f.21.2025.09.24.11.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 11:22:50 -0700 (PDT)
Message-ID: <21dec62792f95a257aafbe254b42dbbd2815d13f.camel@suse.com>
Subject: Re: [PATCH 2/4] libmpathpersist: Handle RESERVE with reservation
 held by failed path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
In-Reply-To: <20250923221252.1411687-3-bmarzins@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
	 <20250923221252.1411687-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 24 Sep 2025 20:02:41 +0200
User-Agent: Evolution 3.56.2 

On Tue, 2025-09-23 at 18:12 -0400, Benjamin Marzinski wrote:
> Issuing a RESERVE on a device that already holds the reservation
> should
> succeed, as long as the type is the same. But if the path that holds
> the
> reservation is unavailable, mpathpersist fails, since it gets a
> reservation conflict on all available paths. To deal with this, if
> the
> multipath device has failed paths, and the key holding the
> reservation
> matches the multipath device's key, and multipathd says that it is
> holding the reservation, assume the reservation is held by a failed
> path
> and claim the RESERVE succeeded, even though none of the actual scsi
> commands did

Can we really trust multipathd? What if the PR had been preemtped by
another host?

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 47 +++++++++++++++++++++++---=
-
> --
> =C2=A01 file changed, 37 insertions(+), 10 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 476c3433..33c9e57a 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -200,7 +200,7 @@ static void *mpath_prout_pthread_fn(void *p)
> =C2=A0static int
> =C2=A0mpath_prout_common(struct multipath *mpp, int rq_servact, int
> rq_scope,
> =C2=A0		=C2=A0=C2=A0 unsigned int rq_type, struct
> prout_param_descriptor *paramp,
> -		=C2=A0=C2=A0 int noisy, struct path **pptr)
> +		=C2=A0=C2=A0 int noisy, struct path **pptr, bool
> *failed_paths)
> =C2=A0{
> =C2=A0	int i, j, ret;
> =C2=A0	struct pathgroup *pgp =3D NULL;
> @@ -213,6 +213,8 @@ mpath_prout_common(struct multipath *mpp, int
> rq_servact, int rq_scope,
> =C2=A0			if (!((pp->state =3D=3D PATH_UP) || (pp->state
> =3D=3D PATH_GHOST))) {
> =C2=A0				condlog(1, "%s: %s path not up.
> Skip",
> =C2=A0					mpp->wwid, pp->dev);
> +				if (failed_paths)
> +					*failed_paths =3D true;
> =C2=A0				continue;
> =C2=A0			}
> =C2=A0
> @@ -247,6 +249,8 @@ mpath_prout_common(struct multipath *mpp, int
> rq_servact, int rq_scope,
> =C2=A0			}
> =C2=A0			if (ret !=3D MPATH_PR_RETRYABLE_ERROR)
> =C2=A0				return ret;
> +			if (failed_paths)
> +				*failed_paths =3D true;
> =C2=A0		}
> =C2=A0	}
> =C2=A0	if (found)
> @@ -333,7 +337,7 @@ void preempt_missing_path(struct multipath *mpp,
> uint8_t *key, uint8_t *sa_key,
> =C2=A0	memcpy(paramp.key, sa_key, 8);
> =C2=A0	memcpy(paramp.sa_key, key, 8);
> =C2=A0	status =3D mpath_prout_common(mpp, MPATH_PROUT_PREE_SA,
> rq_scope,
> -				=C2=A0=C2=A0=C2=A0 rq_type, &paramp, noisy, NULL);
> +				=C2=A0=C2=A0=C2=A0 rq_type, &paramp, noisy, NULL,
> NULL);
> =C2=A0	if (status !=3D MPATH_PR_SUCCESS)
> =C2=A0		condlog(0, "%s: register: pr preempt command
> failed.", mpp->wwid);
> =C2=A0}
> @@ -586,7 +590,7 @@ static int do_preempt_self(struct multipath *mpp,
> struct be64 sa_key,
> =C2=A0	memcpy(paramp.key, &mpp->reservation_key, 8);
> =C2=A0	memcpy(paramp.sa_key, &sa_key, 8);
> =C2=A0	status =3D mpath_prout_common(mpp, rq_servact, rq_scope,
> rq_type,
> -				=C2=A0=C2=A0=C2=A0 &paramp, noisy, &pp);
> +				=C2=A0=C2=A0=C2=A0 &paramp, noisy, &pp, NULL);
> =C2=A0	if (status !=3D MPATH_PR_SUCCESS) {
> =C2=A0		condlog(0, "%s: self preempt command failed.", mpp-
> >wwid);
> =C2=A0		goto fail_resume;
> @@ -769,20 +773,25 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope,
> rq_type, noisy, true);
> =C2=A0}
> =C2=A0
> -static int reservation_key_matches(struct multipath *mpp, uint8_t
> *key, int noisy)
> +static int reservation_key_matches(struct multipath *mpp, uint8_t
> *key,
> +				=C2=A0=C2=A0 unsigned int *type)
> =C2=A0{
> =C2=A0	struct prin_resp resp =3D {{{.prgeneration =3D 0}}};
> =C2=A0	int status;
> =C2=A0
> -	status =3D mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA,
> &resp, noisy);
> +	status =3D mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA,
> &resp, 0);
> =C2=A0	if (status !=3D MPATH_PR_SUCCESS) {
> =C2=A0		condlog(0, "%s: pr in read reservation command
> failed.", mpp->wwid);
> =C2=A0		return YNU_UNDEF;
> =C2=A0	}
> =C2=A0	if (!resp.prin_descriptor.prin_readresv.additional_length)
> =C2=A0		return YNU_NO;
> -	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8)
> =3D=3D 0)
> +	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8)
> =3D=3D 0) {
> +		if (type)
> +			*type =3D
> resp.prin_descriptor.prin_readresv.scope_type &
> +				MPATH_PR_TYPE_MASK;
> =C2=A0		return YNU_YES;
> +	}
> =C2=A0	return YNU_NO;
> =C2=A0}
> =C2=A0
> @@ -799,11 +808,20 @@ static void set_ignored_key(struct multipath
> *mpp, uint8_t *curr_key,
> =C2=A0		return;
> =C2=A0	if (get_prhold(mpp->alias) =3D=3D PR_UNSET)
> =C2=A0		return;
> -	if (reservation_key_matches(mpp, curr_key, 0) =3D=3D YNU_NO)
> +	if (reservation_key_matches(mpp, curr_key, NULL) =3D=3D YNU_NO)
> =C2=A0		return;
> =C2=A0	memcpy(key, curr_key, 8);
> =C2=A0}
> =C2=A0
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
> =C2=A0int do_mpath_persistent_reserve_out(vector curmp, vector pathvec,
> int fd,
> =C2=A0				=C2=A0=C2=A0=C2=A0 int rq_servact, int rq_scope,
> unsigned int rq_type,
> =C2=A0				=C2=A0=C2=A0=C2=A0 struct prout_param_descriptor
> *paramp, int noisy)
> @@ -815,6 +833,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0	struct config *conf;
> =C2=A0	bool unregistering, preempting_reservation =3D false;
> =C2=A0	bool updated_prkey =3D false;
> +	bool failed_paths =3D false;
> =C2=A0
> =C2=A0	ret =3D mpath_get_map(curmp, fd, &mpp);
> =C2=A0	if (ret !=3D MPATH_PR_SUCCESS)
> @@ -906,7 +925,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0		break;
> =C2=A0	case MPATH_PROUT_PREE_SA:
> =C2=A0	case MPATH_PROUT_PREE_AB_SA:
> -		if (reservation_key_matches(mpp, paramp->sa_key,
> noisy) =3D=3D YNU_YES) {
> +		if (reservation_key_matches(mpp, paramp->sa_key,
> NULL) =3D=3D YNU_YES) {
> =C2=A0			preempting_reservation =3D true;
> =C2=A0			if (memcmp(paramp->sa_key, &zerokey, 8) =3D=3D
> 0) {
> =C2=A0				/* all registrants case */
> @@ -923,10 +942,18 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0		}
> =C2=A0		/* fallthrough */
> =C2=A0	case MPATH_PROUT_RES_SA:
> -	case MPATH_PROUT_CLEAR_SA:
> +	case MPATH_PROUT_CLEAR_SA: {
> +		unsigned int res_type;
> =C2=A0		ret =3D mpath_prout_common(mpp, rq_servact, rq_scope,
> rq_type,
> -					 paramp, noisy, NULL);
> +					 paramp, noisy, NULL,
> &failed_paths);
> +		if (rq_servact =3D=3D MPATH_PROUT_RES_SA &&
> +		=C2=A0=C2=A0=C2=A0 ret !=3D MPATH_PR_SUCCESS && failed_paths &&
> +		=C2=A0=C2=A0=C2=A0 check_holding_reservation(mpp, &res_type) &&
> +		=C2=A0=C2=A0=C2=A0 res_type =3D=3D rq_type)
> +			/* The reserve failed, but multipathd says
> we hold it */
> +			ret =3D MPATH_PR_SUCCESS;

I'd prefer splitting up the case statement here, as the code for
MPATH_PROUT_RES_SA is now pretty different from the other cases.

Martin
