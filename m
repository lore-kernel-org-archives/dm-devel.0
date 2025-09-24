Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC85265623
	for <dm-devel@lists.linux.dev>; Wed, 24 Sep 2025 19:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758741152; cv=none; b=rvdYVpw/v0RUbApSN54mxS5JqvVNBnYzYRcm7llJcxCqg22yE/N4JJg4pfhg6/J+KJuQFUzyJZbBJRVScB25ZZJiOXcMcIrR9E5KsnwMNHzhoB8JfvqTUhrXSMiZdPznIR8D+lN/0jEKrxM5ZqZz0ys3TRpcW2j8jjkrsgsAnrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758741152; c=relaxed/simple;
	bh=Q1k1B8HVrNeuRqHteWjz8GG9OYPp7pr6DeaEtYmjZcw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s+GoJ6pV0E7VPxMhuqV7M2Ko1tsOU5HHNcx3i4PEiRU/oFzZ0FsKH4J2IRPPCCffoNg3Ts8yWgbHrxjKt3Jq3eW3iuGb0HxL+i+fvd5uIqrk2AQSlzHdniPd3CWJyeZvP30MYnxVCo8ah7Y4XYTbB/HSXRpagmkUO3/yAmM+w80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UfKb6UGh; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UfKb6UGh"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-46b303f755aso1259305e9.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Sep 2025 12:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758741148; x=1759345948; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KGtLQyC7eqIBUSNLtnd8ZpU9HLgq/WnTVVFid7ZqZ/M=;
        b=UfKb6UGhibTmjCHSzphUnmdK14Fn5CGtEaw4toYiB1sCbfLru/kVIYnx5lZe1rAyEs
         ksWGyOD4JeMCCQhm/P83pg+ZdJEioWjuFvjGOCm+2jQGOjhxb+bzdJqC5kPVa1r7VKBv
         3Ggrhps+eVKZQpOoMSXYJmdYvGCODUbKqKsbrss8np812kK7fyEKqiHe+Fe51woxhdXY
         c0/9M/F9JwWKf4DMXtufFSGwfMcO4e7UH2R1nZ/y6Q3VPqcTA0kr3p92ZkoKu4jGJ/rA
         B8PXzR4eX1+eAooTMnse46/G7korw+ymrhGd1aT1nT5YoCA9JF1hV/86uC5DNfpUDWMN
         qYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758741148; x=1759345948;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KGtLQyC7eqIBUSNLtnd8ZpU9HLgq/WnTVVFid7ZqZ/M=;
        b=cl8H7wuELIFeqwR98TBOD8rKWoS40EaEvK02goglWCx7yWzZZ96B/H0AmQ49w6EeQb
         8zu1LBEhkC5/m0dzTFQ5iFbJCsFsYYeosVemAv86xThtERy/1jGnNOED+us0zt2mFtfs
         N3iIyatJHxBpM+JuZHbouZSAQbgLYrsijXLJqNjZHGSaNSxZwZVaWPQ+hojkoRBUUupC
         Onq/Q42mzix/YvUcq8yOxBuPZS0c/9Ytt6lNx7mbRIJ0YR3YFiOEz/VmuchXDsFAEfE/
         IDu1h50KWRRlw9iEKzxDmk140gAYqjFVRgfw6AbpjnVj8xZ9qDpUAgomDs8damqMxq2g
         sTeA==
X-Gm-Message-State: AOJu0YxFrz3XlV1eT5AUToYSLG8+Dph8kxqVvjHzbS8ZMO5lCjWn8UnM
	Ai3/W2BIJ1/KDVUGttYhE6baU+w1hC5BT5cxKngIY3qalZkc+EJYXM3Tr9BmdVTAlP+hsgoT9Dv
	eOsCknrrzbA==
X-Gm-Gg: ASbGnctFY/73IxhFgSfkzA91eFfv1fQYnLLstYtMqkAYdaMypoW8Wz5iPGuegEVHB8Q
	kL5uMUecRxguav94EA0PZJ4CmyWIjm44lBKj0WDv6EHwKQ/hI2SG/mLmQT00Zu4cbWEGFNtkcAk
	tRqONg9w/lUtp9aGAVYS+3WP7Xo47mHmo7p1I3+WtByUUusJv2rFMo6hQMC+1sXW2oyCscq89Lg
	AhfXIN+b/e5Teghqv8tS93AJVUIMItUuvEAEaNLdJ99IZDpGL3P1ikvXX6JMpte597DL/0g0tW8
	ODAOt6cxfknFUayVfi/3BpsAlCtKHdqISbyEEvt8/7S8TatuVDHnuIzXMaRxJJUUl/A6DdvGC8T
	HCLLwgB33wXxWP+Ajrv8ZfDFn7SSHrriEmePJFH4ll/tLqXLh/6iwIG6qVLDdfJAl0lhzJR0xA8
	+7um0gk+RVBG3dnagvj9hYXoryvV01Il6S7r8oD5h6xixuVRc6S32fzwoIJw==
X-Google-Smtp-Source: AGHT+IHasWYmm/TsBfOXt7HX8CeRriWSPw8RK9dk9eTNB12mtbXCy5vgp1urUsBVvTyUHHRgbFFWWQ==
X-Received: by 2002:a05:600c:190c:b0:46c:7397:fb03 with SMTP id 5b1f17b1804b1-46e329a8211mr12068505e9.8.1758741147450;
        Wed, 24 Sep 2025 12:12:27 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32bd164fsm2960235e9.1.2025.09.24.12.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 12:12:27 -0700 (PDT)
Message-ID: <7a57bdf8bac354ac3548728afa1d72141fe900c9.camel@suse.com>
Subject: Re: [PATCH 4/4] libmpathpersist: Fix unregistering while holding
 the reservation
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 24 Sep 2025 21:12:26 +0200
In-Reply-To: <20250923221252.1411687-5-bmarzins@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
	 <20250923221252.1411687-5-bmarzins@redhat.com>
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
> There were two problems with how libmpathpersist handled
> unregistering
> a key while holding the reseravation (which should also release the
> reservation).
> 1. If the path holding the reservation is not unregistered first,
> there
> =C2=A0=C2=A0 will be unregistered paths, while a reservation is still hel=
d,
> which
> =C2=A0=C2=A0 would cause IO to those paths to fail, when it shouldn't.
> 2. If the path that holds the reservation is down, libmpathpersist
> was
> =C2=A0=C2=A0 not clearing the resrvation, since the there were no registe=
red
> keys
> =C2=A0=C2=A0 it could use for the PREEMPT command workaround
>=20
> To fix these, libmpathpersist now releases the reservation first when
> trying to unregister a key that is holding the reservation.
> mpath_prout_rel() has a new option so that if it needs to self
> preempt
> to clear the reservation, it won't re-register the paths when called
> as part of unregistering a key. Also, instead of checking if the
> device
> is currently holding a reservation using mpp->reservation_key in
> check_holding_reservation() (which will already be set to 0 when
> called
> as part of unregistering a key), pass in the key to check.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 101 +++++++++++++++++++------=
-
> --
> =C2=A01 file changed, 70 insertions(+), 31 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 9c71011f..f130f5f5 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -564,18 +564,23 @@ static int mpath_prout_reg(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0	return status;
> =C2=A0}
> =C2=A0
> +enum preempt_work {
> +	PREE_WORK_NONE,
> +	PREE_WORK_REL,
> +	PREE_WORK_REL_UNREG,
> +};
> =C2=A0/*
> =C2=A0 * Called to make a multipath device preempt its own reservation
> (and
> - * optionally release the reservation). Doing this causes the
> reservation
> - * keys to be removed from all the device paths except that path
> used to issue
> - * the preempt, so they need to be restored. To avoid the chance
> that IO
> - * goes to these paths when they don't have a registered key, the
> device
> - * is suspended before issuing the preemption, and the keys are
> reregistered
> - * before resuming it.
> + * optional extra work). Doing this causes the reservation keys to
> be removed
> + * from all the device paths except that path used to issue the
> preempt, so
> + * they may need to be restored. To avoid the chance that IO goes to
> these
> + * paths when they don't have a registered key and a reservation
> exists, the
> + * device is suspended before issuing the preemption, and the keys
> are
> + * reregistered (or the reservation is released) before resuming it.
> =C2=A0 */
> =C2=A0static int do_preempt_self(struct multipath *mpp, struct be64
> sa_key,
> =C2=A0			=C2=A0=C2=A0 int rq_servact, int rq_scope, unsigned
> int rq_type,
> -			=C2=A0=C2=A0 int noisy, bool do_release)
> +			=C2=A0=C2=A0 int noisy, enum preempt_work work)
> =C2=A0{
> =C2=A0	int status, rel_status =3D MPATH_PR_SUCCESS;
> =C2=A0	struct path *pp =3D NULL;
> @@ -596,7 +601,7 @@ static int do_preempt_self(struct multipath *mpp,
> struct be64 sa_key,
> =C2=A0		goto fail_resume;
> =C2=A0	}
> =C2=A0
> -	if (do_release) {
> +	if (work !=3D PREE_WORK_NONE) {
> =C2=A0		memset(&paramp, 0, sizeof(paramp));
> =C2=A0		memcpy(paramp.key, &mpp->reservation_key, 8);
> =C2=A0		rel_status =3D prout_do_scsi_ioctl(pp->dev,
> MPATH_PROUT_REL_SA,
> @@ -604,15 +609,26 @@ static int do_preempt_self(struct multipath
> *mpp, struct be64 sa_key,
> =C2=A0		if (rel_status !=3D MPATH_PR_SUCCESS)
> =C2=A0			condlog(0, "%s: release on alternate path
> failed.",
> =C2=A0				mpp->wwid);
> +		else if (work =3D=3D PREE_WORK_REL_UNREG) {
> +			/* unregister the last path */
> +			rel_status =3D prout_do_scsi_ioctl(pp->dev,
> +						=09
> MPATH_PROUT_REG_IGN_SA,
> +							 rq_scope,
> rq_type,
> +							 &paramp,
> noisy);
> +			if (rel_status !=3D MPATH_PR_SUCCESS)
> +				condlog(0, "%s: final self preempt
> unregister failed,",
> +					mpp->wwid);
> +		}
> +	}
> +	if (work !=3D PREE_WORK_REL_UNREG) {
> +		memset(&paramp, 0, sizeof(paramp));
> +		memcpy(paramp.sa_key, &mpp->reservation_key, 8);
> +		status =3D mpath_prout_reg(mpp,
> MPATH_PROUT_REG_IGN_SA, rq_scope,
> +					 rq_type, &paramp, noisy);
> +		if (status !=3D MPATH_PR_SUCCESS)
> +			condlog(0, "%s: self preempt failed to
> reregister paths.",
> +				mpp->wwid);
> =C2=A0	}
> -
> -	memset(&paramp, 0, sizeof(paramp));
> -	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
> -	status =3D mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA,
> rq_scope,
> -				 rq_type, &paramp, noisy);
> -	if (status !=3D MPATH_PR_SUCCESS)
> -		condlog(0, "%s: self preempt failed to reregister
> paths.",
> -			mpp->wwid);
> =C2=A0
> =C2=A0fail_resume:
> =C2=A0	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
> udev_flags)) {
> @@ -625,10 +641,10 @@ fail_resume:
> =C2=A0}
> =C2=A0
> =C2=A0static int preempt_self(struct multipath *mpp, int rq_servact, int
> rq_scope,
> -			unsigned int rq_type, int noisy, bool
> do_release)
> +			unsigned int rq_type, int noisy, enum
> preempt_work work)
> =C2=A0{
> =C2=A0	return do_preempt_self(mpp, mpp->reservation_key,
> rq_servact, rq_scope,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rq_type, noisy, do_release);
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rq_type, noisy, work);
> =C2=A0}
> =C2=A0
> =C2=A0static int preempt_all(struct multipath *mpp, int rq_servact, int
> rq_scope,
> @@ -636,7 +652,7 @@ static int preempt_all(struct multipath *mpp, int
> rq_servact, int rq_scope,
> =C2=A0{
> =C2=A0	struct be64 zerokey =3D {0};
> =C2=A0	return do_preempt_self(mpp, zerokey, rq_servact, rq_scope,
> rq_type,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 noisy, false);
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 noisy, PREE_WORK_NONE);
> =C2=A0}
> =C2=A0
> =C2=A0static int reservation_key_matches(struct multipath *mpp, uint8_t
> *key,
> @@ -661,18 +677,21 @@ static int reservation_key_matches(struct
> multipath *mpp, uint8_t *key,
> =C2=A0	return YNU_NO;
> =C2=A0}
> =C2=A0
> -static bool check_holding_reservation(struct multipath *mpp,
> unsigned int *type)
> +static bool check_holding_reservation(struct multipath *mpp, uint8_t
> *curr_key,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int *type)
> =C2=A0{
> -	if (get_be64(mpp->reservation_key) &&
> +	uint64_t zerokey =3D 0;
> +	if (memcmp(curr_key, &zerokey, 8) !=3D 0 &&
> =C2=A0	=C2=A0=C2=A0=C2=A0 get_prhold(mpp->alias) =3D=3D PR_SET &&
> -	=C2=A0=C2=A0=C2=A0 reservation_key_matches(mpp, (uint8_t *)&mpp-
> >reservation_key, type) =3D=3D YNU_YES)
> +	=C2=A0=C2=A0=C2=A0 reservation_key_matches(mpp, curr_key, type) =3D=3D =
YNU_YES)
> =C2=A0		return true;
> =C2=A0	return false;
> =C2=A0}
> =C2=A0
> -static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int
> rq_scope,
> +static int mpath_prout_rel(struct multipath *mpp, int rq_servact,
> int rq_scope,
> =C2=A0			=C2=A0=C2=A0 unsigned int rq_type,
> -			=C2=A0=C2=A0 struct prout_param_descriptor * paramp,
> int noisy)
> +			=C2=A0=C2=A0 struct prout_param_descriptor *paramp,
> int noisy,
> +			=C2=A0=C2=A0 bool *unregistered)
> =C2=A0{
> =C2=A0	int i, j;
> =C2=A0	struct pathgroup *pgp =3D NULL;
> @@ -685,6 +704,8 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0	bool all_threads_failed;
> =C2=A0	unsigned int res_type;
> =C2=A0
> +	if (unregistered)
> +		*unregistered =3D false;
> =C2=A0	if (!mpp)
> =C2=A0		return MPATH_PR_DMMP_ERROR;
> =C2=A0
> @@ -762,7 +783,8 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0		return status;
> =C2=A0	}
> =C2=A0
> -	if (!check_holding_reservation(mpp, &res_type)) {
> +	if (!check_holding_reservation(mpp, (uint8_t *)&mpp-
> >reservation_key,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &res_type)) {
> =C2=A0		condlog(2, "%s: Releasing key not holding
> reservation.", mpp->wwid);
> =C2=A0		return MPATH_PR_SUCCESS;
> =C2=A0	}
> @@ -785,7 +807,10 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0	 * 4. Reregistering keys on all the paths
> =C2=A0	 * 5. Resuming the device
> =C2=A0	 */
> -	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope,
> rq_type, noisy, true);
> +	if (unregistered)
> +		*unregistered =3D true;
> +	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope,
> rq_type, noisy,
> +			=C2=A0=C2=A0=C2=A0 unregistered ? PREE_WORK_REL_UNREG :
> PREE_WORK_REL);

This is hard to understand and possibly error-prone in the future.

You use the pointer "unregistered" as a boolean, which looks like a
typo (missing "*") in the first place. It turns out that it's
intentional, and that (unregistered !=3D NULL) indicates that this code
was called from the MPATH_PROUT_REG_IGN_SA case in
do_mpath_persistent_reserve_out() (as opposed to the MPATH_PROUT_REL_SA
case).

Could you write this in a somewhat more obvious way, please; perhaps by
passing a preempt_work parameter to mpath_prout_rel()?


> =C2=A0}
> =C2=A0
> =C2=A0/*
> @@ -828,7 +853,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0	select_reservation_key(conf, mpp);
> =C2=A0	put_multipath_config(conf);
> =C2=A0
> -	memcpy(&oldkey, &mpp->reservation_key, 8);
> +	oldkey =3D mpp->reservation_key;
> =C2=A0	unregistering =3D (memcmp(&zerokey, paramp->sa_key, 8) =3D=3D 0);
> =C2=A0	if (mpp->prkey_source =3D=3D PRKEY_SOURCE_FILE &&
> =C2=A0	=C2=A0=C2=A0=C2=A0 (rq_servact =3D=3D MPATH_PROUT_REG_IGN_SA ||
> @@ -905,7 +930,21 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0	{
> =C2=A0	case MPATH_PROUT_REG_SA:
> =C2=A0	case MPATH_PROUT_REG_IGN_SA:
> -		ret=3D mpath_prout_reg(mpp, rq_servact, rq_scope,
> rq_type, paramp, noisy);
> +		if (unregistering && check_holding_reservation(mpp,
> (uint8_t *)&oldkey, &rq_type)) {
> +			bool unregistered =3D false;
> +			struct be64 newkey =3D mpp->reservation_key;
> +			/* temporarily restore reservation key */
> +			mpp->reservation_key =3D oldkey;
> +			ret =3D mpath_prout_rel(mpp,
> MPATH_PROUT_REL_SA, rq_scope,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rq_type, paramp,
> noisy,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &unregistered);
> +			mpp->reservation_key =3D newkey;
> +			if (ret =3D=3D MPATH_PR_SUCCESS &&
> !unregistered)
> +				ret =3D mpath_prout_reg(mpp,
> rq_servact, rq_scope,
> +						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rq_type,
> paramp, noisy);

I comment stating that mpp->reservation_key is zero here and that
mpath_prout_reg() actually unregisters the key would help readers of
this code.

Regards
Martin

> +		} else
> +			ret =3D mpath_prout_reg(mpp, rq_servact,
> rq_scope,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rq_type, paramp,
> noisy);
> =C2=A0		break;
> =C2=A0	case MPATH_PROUT_PREE_SA:
> =C2=A0	case MPATH_PROUT_PREE_AB_SA:
> @@ -921,7 +960,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0		/* if we are preempting ourself */
> =C2=A0		if (memcmp(paramp->sa_key, paramp->key, 8) =3D=3D 0) {
> =C2=A0			ret =3D preempt_self(mpp, rq_servact,
> rq_scope, rq_type,
> -					=C2=A0=C2=A0 noisy, false);
> +					=C2=A0=C2=A0 noisy, PREE_WORK_NONE);
> =C2=A0			break;
> =C2=A0		}
> =C2=A0		/* fallthrough */
> @@ -932,14 +971,14 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0					 paramp, noisy, NULL,
> &failed_paths);
> =C2=A0		if (rq_servact =3D=3D MPATH_PROUT_RES_SA &&
> =C2=A0		=C2=A0=C2=A0=C2=A0 ret !=3D MPATH_PR_SUCCESS && failed_paths &&
> -		=C2=A0=C2=A0=C2=A0 check_holding_reservation(mpp, &res_type) &&
> +		=C2=A0=C2=A0=C2=A0 check_holding_reservation(mpp, paramp->key,
> &res_type) &&
> =C2=A0		=C2=A0=C2=A0=C2=A0 res_type =3D=3D rq_type)
> =C2=A0			/* The reserve failed, but multipathd says
> we hold it */
> =C2=A0			ret =3D MPATH_PR_SUCCESS;
> =C2=A0		break;
> =C2=A0	}
> =C2=A0	case MPATH_PROUT_REL_SA:
> -		ret =3D mpath_prout_rel(mpp, rq_servact, rq_scope,
> rq_type, paramp, noisy);
> +		ret =3D mpath_prout_rel(mpp, rq_servact, rq_scope,
> rq_type, paramp, noisy, NULL);
> =C2=A0		break;
> =C2=A0	default:
> =C2=A0		return MPATH_PR_OTHER;
