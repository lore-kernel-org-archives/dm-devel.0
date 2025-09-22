Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6822DC79F
	for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758559991; cv=none; b=YtmJD7T1UsWWbPjl22NPo6kSAkftBd8720SDtkl4/6KgxMj/v7YbGgZND4y1TeH6udKCHgTK+5Ujq3/esrG/EnRPww5kJYbuzurCPENdMXUHFNF3+N6wFqdrW2JwEjOWz3v40SPmybK6ozCrUzq6oeclQaox4cDjRptDv9LqS+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758559991; c=relaxed/simple;
	bh=W6n1AvvLBJe+fEEqXmMYZvfGH5HmokzDtbyXdFSHqRQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hmub/OLm9eNCXOHxePDT2XC6ZqymXtzX5GvyaKMPqK+ZSD8boOR+imhC+zHQmKC/z4cBtU81W0ZClBx3kLdKPN3+08j74YggDj9Jy3gYV9dAXBUQBgz3AMaDsjFTt/DKbN1QVY3na1vvLBKGPTcB6qHfW6XXBXWJ6dyGTZi+cMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aVrVzef+; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aVrVzef+"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so2707727f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 09:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758559987; x=1759164787; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nbHGAdx5apiEXQwr7XyFud1pln4eauLA8K2tpzvmqu4=;
        b=aVrVzef+8QRVP5Y/mQKdsn4pjuOJIW1kMiCpq7O2FQQXmWxuhaCJyplx12/sEzJkcc
         /SFCvDWPXq2fji9zIqDQ9zsJpuY36EdeC9mk7sbdEdL77PlsmHJ+mtlUQjB7KPhnvHGz
         qCxYlolTJberjzQJDvvwqf0utEdZBZXrF4v5JXiwEqYtKCaIyQCKi3pJOe24KfgkOjGR
         sU56nIGaanyd9WeCsHY8cTPLeqvT5uk867DKMFXzztgITvMX3ACsUFZ3NxRLygAtBC0y
         0w7hnkm9u3w+Z/VJRmHu3LmeUdd8f9vOyO/PnXOctLCgsuh7HxFQi7aZtjhD7Z9r2Nam
         wS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758559987; x=1759164787;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nbHGAdx5apiEXQwr7XyFud1pln4eauLA8K2tpzvmqu4=;
        b=W61u/wt19iu4IWaI7e1ylA9E8roktaIZS45UuIGrjCuSg6Io6o6Ge/CQ+iQDFVVag3
         VUu6EofS6sEM9Yf0pPzqtkxfu3US+qBm+ek103LRPJfWqL+wulOv47WtJmmb7Y9Sw7sm
         KEAR6momK3dn7xJlDS7kl43xpLRzDcYPzCeH1w/Rwf/GayKzBUXWrpCLjpfBbf99usNq
         5Vk0XVhx+DHZTTrlLKngMgKmixJSZ1kZRqVylWq6vZ4b92IzFBWjnDzNGPhBdd/N5vYp
         YzFtgiKfThGK7bDQy8gs1PMlKok8EyJEKO+bGrmt+8fO6u/JtDhSYExSjHfx/Bu/oAtJ
         Ra2w==
X-Gm-Message-State: AOJu0YzZD8TXWL+1tt+BM9h9zETCv9Al/JU3pJLZmCOAR8a1YbaZmUX9
	G0cOfY6F+sML8E4TraOLhz0LpH38iHu6U9dhc+K24Zk5MAzCCJZtB7yo3Gj5otjR/QY=
X-Gm-Gg: ASbGncsqJi8Lq+Lu9s3heVsMHg339Q+GpU7WEjA93eHdDrrJlIg2tQEZwin6LgPZocE
	qmDI61lIhaTrTZmpZwW3btY0sDgUDRXVRpunB0FYzb4VHiaAYH4xn6hVGhrNvIAyDs60TyfqhOa
	gLh1GwFG449ms3qlcsj5h6QanHvn3LADy+GUgchFYjpkqreQtu0frQdRPV2TVb/yFxWu+iYM5Fv
	UxkotXmYEV06ugjxDfN2U/F+/2pJuVWvheJR/vtoNv4WBj9G7LIunj8Yp8zwRl36elrIkqDZxuK
	BOTsXy6bc8Sjgu5s48yOhV49XvknfDNOmFS2fWRbh5MnIk7zf5fDne+ILzGNsxgw50QX/adfyuR
	m1n/rlNqytaedBNYOvraGCszDo8jFRPOWCyitRPrkA127CChn0VA2eJ8zCReofrxgIpf6lKsuRL
	5On0BXSDS2mgHdrJhf35X6Z0JXvxPO40onyKqpMxVLWYInzsQKjU+hISgo+A==
X-Google-Smtp-Source: AGHT+IF3ZMo1r/kRvBdcytCdm9yuAgHXKykJ2cv6O2ifUVkBdREAvEXZRHSzNxmk/7Nkypwvetr5sg==
X-Received: by 2002:a05:6000:18a4:b0:3e5:190b:b04e with SMTP id ffacd0b85a97d-3ee84171bcdmr8679517f8f.37.1758559986713;
        Mon, 22 Sep 2025 09:53:06 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbfedd6sm20829515f8f.60.2025.09.22.09.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 09:53:06 -0700 (PDT)
Message-ID: <82a83835794202de7fe4f2093802d51df888a50d.camel@suse.com>
Subject: Re: [PATCH 2/2] libmpathpersist: handle preempting all registrants
 reservations
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 22 Sep 2025 18:53:05 +0200
In-Reply-To: <20250910225812.829847-3-bmarzins@redhat.com>
References: <20250910225812.829847-1-bmarzins@redhat.com>
	 <20250910225812.829847-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-09-10 at 18:58 -0400, Benjamin Marzinski wrote:
> All Registrants reservations (types 7 and 8) are held by key 0x0.
> When
> preempting one, all registrations are cleared, except for the one on
> the
> path that issued the PREEMPT. libmpathpersist needs to handle this
> just
> like the other cases of self-preemption, so that all the paths of the
> preempting multipath device have their registrations restored while
> the
> device is suspended.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 31 +++++++++++++++++++++++++-=
-
> --
> =C2=A01 file changed, 27 insertions(+), 4 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 9f301859..ab3d70cd 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -569,8 +569,9 @@ static int mpath_prout_reg(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0 * is suspended before issuing the preemption, and the keys are
> reregistered
> =C2=A0 * before resuming it.
> =C2=A0 */
> -static int preempt_self(struct multipath *mpp, int rq_servact, int
> rq_scope,
> -			unsigned int rq_type, int noisy, bool
> do_release)
> +static int do_preempt_self(struct multipath *mpp, struct be64
> sa_key,
> +			=C2=A0=C2=A0 int rq_servact, int rq_scope, unsigned
> int rq_type,
> +			=C2=A0=C2=A0 int noisy, bool do_release)
> =C2=A0{
> =C2=A0	int status, rel_status =3D MPATH_PR_SUCCESS;
> =C2=A0	struct path *pp =3D NULL;
> @@ -583,7 +584,7 @@ static int preempt_self(struct multipath *mpp,
> int rq_servact, int rq_scope,
> =C2=A0	}
> =C2=A0
> =C2=A0	memcpy(paramp.key, &mpp->reservation_key, 8);
> -	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
> +	memcpy(paramp.sa_key, &sa_key, 8);
> =C2=A0	status =3D mpath_prout_common(mpp, rq_servact, rq_scope,
> rq_type,
> =C2=A0				=C2=A0=C2=A0=C2=A0 &paramp, noisy, &pp);
> =C2=A0	if (status !=3D MPATH_PR_SUCCESS) {
> @@ -619,6 +620,21 @@ fail_resume:
> =C2=A0	return (rel_status !=3D MPATH_PR_SUCCESS) ? rel_status :
> status;
> =C2=A0}
> =C2=A0
> +static int preempt_self(struct multipath *mpp, int rq_servact, int
> rq_scope,
> +			unsigned int rq_type, int noisy, bool
> do_release)
> +{
> +	return do_preempt_self(mpp, mpp->reservation_key,
> rq_servact, rq_scope,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rq_type, noisy, do_release);
> +}
> +
> +static int preempt_all(struct multipath *mpp, int rq_servact, int
> rq_scope,
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int rq_type, int noisy)
> +{
> +	struct be64 zerokey =3D {0};
> +	return do_preempt_self(mpp, zerokey, rq_servact, rq_scope,
> rq_type,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 noisy, false);
> +}
> +
> =C2=A0static int mpath_prout_rel(struct multipath *mpp,int rq_servact, in=
t
> rq_scope,
> =C2=A0			=C2=A0=C2=A0 unsigned int rq_type,
> =C2=A0			=C2=A0=C2=A0 struct prout_param_descriptor * paramp,
> int noisy)
> @@ -889,8 +905,15 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0		break;
> =C2=A0	case MPATH_PROUT_PREE_SA:
> =C2=A0	case MPATH_PROUT_PREE_AB_SA:
> -		if (reservation_key_matches(mpp, paramp->sa_key,
> noisy) =3D=3D YNU_YES)
> +		if (reservation_key_matches(mpp, paramp->sa_key,
> noisy) =3D=3D YNU_YES) {
> =C2=A0			preempting_reservation =3D true;
> +			if (memcmp(paramp->sa_key, &zerokey, 8) =3D=3D
> 0) {


Don't you need to check if pr_type is 7 or 8 here?

> +				/* all registrants case */
> +				ret =3D preempt_all(mpp, rq_servact,
> rq_scope,
> +						=C2=A0 rq_type, noisy);
> +				break;
> +			}
> +		}
> =C2=A0		/* if we are preempting ourself */
> =C2=A0		if (memcmp(paramp->sa_key, paramp->key, 8) =3D=3D 0) {
> =C2=A0			ret =3D preempt_self(mpp, rq_servact,
> rq_scope, rq_type,
