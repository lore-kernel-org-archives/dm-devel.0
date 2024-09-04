Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820E91D54CE
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 15:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725462879; cv=none; b=FnB6YikbkWn9UDkHMOZr4/fg/MzaccDoo5W6Zvt7L1hl1mGmBzcMYDuWihvFXXN8pXcbKAlDtOTbqHRq+GUr/pYbn3GX2gT/5zInNAXlzGymuuYC+nFQc8VUgxI+qlzLV0+woxPrkNVHAoInWrNTVs3TK0xfBHrUn6Rtja2znMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725462879; c=relaxed/simple;
	bh=yfu0o5QfCnIShGyUvFGC+rjFTJVtdtspcpbPj4Kp9Gk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NNIiIvoSjB5PvL7BXOy2uecqipDrxFcLzpxl8sxymLD7tbqPED66TNJBH1ljdE9zOYoLNbYBdFQzt2WWFjWVX0fRgK2oBNb0hFkFlCxIloJjc+zD9dOS+UKDUEniFfcx0aog73pkWdnheXpTOaDkfDIN6FIiMnnzpH+4ZqExkeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PS9Cf1Xu; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PS9Cf1Xu"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2f64e82aeacso17390531fa.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 08:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725462875; x=1726067675; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V+6KiiWpE4156GH2AWRDjR2cBa/YVVnnk3Qgdwn5L6U=;
        b=PS9Cf1XuZzK1VomfAk31gdM6wjvzAMomFfHYFKn/1T6NlEv0icIYilSKIIej3FEU39
         SRAExXIg6p6swYPL7kyuWGtDed9/Hov7N5q6Xu1ukpVW8/dHzGLWmUYmNhA6KU36rqi5
         /K2yuQye4e0B+CGPS08ue4rkyJ3XlKtAafC4WTdVmfzgDHoikfDZpbRLr0TE5PjHjWnV
         4dsmOZKoALVIGZT9Tjz/+UnYQvAfiqbkR+Dycf1AgCY+J8/lhpYELDmTzuOtN7dvYlQ3
         NrVRxtUq6TZ3zVYLyzsPJkQZho8J45iqQplHhM3d/aLwisHsUdMnIumnjipoFK7Wbmyi
         UvWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725462875; x=1726067675;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V+6KiiWpE4156GH2AWRDjR2cBa/YVVnnk3Qgdwn5L6U=;
        b=vuLhWTHHlniL1d4t6ygIyK5c7ps9oXYkkLNIRK28JCgUHDMe7gIKH+vBx82rCFSMpf
         p+maExPrilKDCphqnYMIHlZWu7KzZy9Sgb67Q2RAfduSnahybpUl5R950o8gmOqm/uDF
         kv4fNv05X9nyIuXrqrOwYuEeYcR5NsQM5CvlUdRtC+hZeHz+Ih6hLDenEqhnXvdgvBnX
         g3EyHO7AEzMHydDMke+rEbeDg0f150kykawgjHFSTyuvXpa3sQcGsq9CuyUqdtia/+Xe
         NZBzO7jRxUaEY7rBzkfUqJQNQz/P/A69a6LQPwGRpS8gecLmxyKh/j8NCv1mg7eBzvAq
         waBw==
X-Gm-Message-State: AOJu0YxL/aCE+LLXutY7fZnuGb1qRw65Ysc0nKzM3sLl85OR9HlGcVmH
	g7JtbGnnI9H8VBOA1JOn7AjaRE+EQQMD5apCyUgU1l1hZU4cnb6CU7ze5E5FGBI=
X-Google-Smtp-Source: AGHT+IFoJjeEEwtHHjIhI7+9Sihjf1KKchClJeMysZ/1WzWMEByT7XvCzhtBe8UnADVGAm0P7CQblA==
X-Received: by 2002:a05:6512:acc:b0:530:ae22:a6f0 with SMTP id 2adb3069b0e04-53546afa19cmr12611653e87.5.1725462873930;
        Wed, 04 Sep 2024 08:14:33 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623c34b5sm3256066b.186.2024.09.04.08.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 08:14:33 -0700 (PDT)
Message-ID: <acde3728e780c2d0437487d76b932294ae7206d1.camel@suse.com>
Subject: Re: [PATCH 06/15] libmultipath: split get_state into two functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 17:14:32 +0200
In-Reply-To: <20240828221757.4060548-7-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-7-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> get_state() is now split into start_checker(), which runs the checker
> but doesn't wait for async checkers, and get_state(), which returns
> the
> state from the checker, after waiting for async checkers if
> necessary.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/discovery.c | 22 ++++++++++++++++------
> =C2=A0libmultipath/discovery.h |=C2=A0 4 +++-
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
 4 +++-
> =C2=A04 files changed, 23 insertions(+), 8 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 5648be60..e0f46ff2 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1974,30 +1974,29 @@ cciss_ioctl_pathinfo(struct path *pp)
> =C2=A0}
> =C2=A0
> =C2=A0int
> -get_state (struct path * pp, struct config *conf, int daemon, int
> oldstate)
> +start_checker (struct path * pp, struct config *conf, int daemon,
> int oldstate)
> =C2=A0{
> =C2=A0	struct checker * c =3D &pp->checker;
> -	int state;
> =C2=A0
> =C2=A0	if (!checker_selected(c)) {
> =C2=A0		if (daemon) {
> =C2=A0			if (pathinfo(pp, conf, DI_SYSFS) !=3D
> PATHINFO_OK) {
> =C2=A0				condlog(3, "%s: couldn't get sysfs
> pathinfo",
> =C2=A0					pp->dev);
> -				return PATH_UNCHECKED;
> +				return -1;
> =C2=A0			}
> =C2=A0		}
> =C2=A0		select_detect_checker(conf, pp);
> =C2=A0		select_checker(conf, pp);
> =C2=A0		if (!checker_selected(c)) {
> =C2=A0			condlog(3, "%s: No checker selected", pp-
> >dev);
> -			return PATH_UNCHECKED;
> +			return -1;
> =C2=A0		}
> =C2=A0		checker_set_fd(c, pp->fd);
> =C2=A0		if (checker_init(c, pp->mpp?&pp->mpp-
> >mpcontext:NULL)) {
> =C2=A0			checker_clear(c);
> =C2=A0			condlog(3, "%s: checker init failed", pp-
> >dev);
> -			return PATH_UNCHECKED;
> +			return -1;
> =C2=A0		}
> =C2=A0	}
> =C2=A0	if (pp->mpp && !c->mpcontext)
> @@ -2008,6 +2007,15 @@ get_state (struct path * pp, struct config
> *conf, int daemon, int oldstate)
> =C2=A0	else
> =C2=A0		checker_set_sync(c);
> =C2=A0	checker_check(c, oldstate);
> +	return 0;
> +}
> +
> +int
> +get_state (struct path * pp)
> +{
> +	struct checker * c =3D &pp->checker;
> +	int state;
> +
> =C2=A0	state =3D checker_get_state(c);
> =C2=A0	condlog(3, "%s: %s state =3D %s", pp->dev,
> =C2=A0		checker_name(c), checker_state_name(state));
> @@ -2455,7 +2463,9 @@ int pathinfo(struct path *pp, struct config
> *conf, int mask)
> =C2=A0
> =C2=A0	if (mask & DI_CHECKER) {
> =C2=A0		if (path_state =3D=3D PATH_UP) {
> -			int newstate =3D get_state(pp, conf, 0,
> path_state);
> +			int newstate =3D PATH_UNCHECKED;
> +			if (start_checker(pp, conf, 0, path_state)
> =3D=3D 0)
> +				newstate =3D get_state(pp);
> =C2=A0			if (newstate !=3D PATH_PENDING ||
> =C2=A0			=C2=A0=C2=A0=C2=A0 pp->state =3D=3D PATH_UNCHECKED ||
> =C2=A0			=C2=A0=C2=A0=C2=A0 pp->state =3D=3D PATH_WILD)
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index c93abf1c..f3e0c618 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -34,7 +34,9 @@ int path_discovery (vector pathvec, int flag);
> =C2=A0int path_get_tpgs(struct path *pp); /* This function never returns
> TPGS_UNDEF */
> =C2=A0int do_tur (char *);
> =C2=A0int path_offline (struct path *);
> -int get_state (struct path * pp, struct config * conf, int daemon,
> int state);
> +int start_checker(struct path * pp, struct config * conf, int
> daemon,
> +		=C2=A0 int state);
> +int get_state(struct path * pp);
> =C2=A0int get_vpd_sgio (int fd, int pg, int vend_id, char * str, int
> maxlen);
> =C2=A0int pathinfo (struct path * pp, struct config * conf, int mask);
> =C2=A0int alloc_path_with_pathinfo (struct config *conf, struct
> udev_device *udevice,
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index a3fce203..ad771d35 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -700,6 +700,7 @@ out:
> =C2=A0	condlog(3, "%s: path_checker =3D %s %s", pp->dev,
> =C2=A0		checker_name(c), origin);
> =C2=A0	c->timeout =3D pp->checker_timeout;
> +	c->path_state =3D PATH_UNCHECKED;

Should this be in 01/15 already?

Martin

