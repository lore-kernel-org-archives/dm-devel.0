Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB47F1DC74F
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725462107; cv=none; b=CaJNP92ELbJEB+4Z//bPLcLrGYXlbHYSEcK/mTCNKmh3KI+btr8mQiAcnbQ8QttyfeYkANFZpJaUGJlMONthuU1bXKbF8YbmIgUqzsXx+ind/pVtBRQ0S/HX+GhBNkvuSD55FxOQhT6wLWxXre18ZrMSzMNhASx3/HRLJSryimc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725462107; c=relaxed/simple;
	bh=bgXh7IZ4UqlHquCmXgL4HKa14LY0Ey9qgD4TxjuSFQA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=izqewUeGcLiSuMdT1nLbDkzdHkNvAZr+OAXsC7tFy5JfSQI0lUkiy3M/lnkDGH65ZkovS97QVn0Uz9Cxps/wAXIKrC6sWJU8auivALoHxkjowOQwHWqszC7vntxDrR0pbZ/ZgN5Ukk4ygL79hEs/Hs22wALs6/s/rA1R3olad58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QbUiYOjS; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QbUiYOjS"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a83597ce5beso147152366b.1
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 08:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725462102; x=1726066902; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cJAbtJPkacQ++HELnHkfs//O15YyglKA4B1TSFuqNI8=;
        b=QbUiYOjSqNTcA9TXrLhzyDyb6RlHDy07znjRzMdF46wZMknG216bXjMZHk5qlK2iWV
         EaCd5XwV+iU8zoh18Uwr371DAgD30xeqKeqmXA81r4Qu+OBB0fpp/3UWvrlCSB6wVMKx
         xsSuLQ3CFBptxeImE8bA/56W5yJDfd6Vbm9X2VDbPA2vtkFzli1FmcZpkGcZDpmZuUBx
         r7dozQ08dMRg7IAmQ0a3fGizUbBkZM77Ha/ebvlsYec/fsGQfd+CIEgEFhfbTWlKX0Ow
         +rUAnnlK/s7eS49lYLpRp11ugz+bvQ2XgWVx/oBNO9TmDBtamQhhFs6aoFPGv0LVdUg+
         s68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725462102; x=1726066902;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cJAbtJPkacQ++HELnHkfs//O15YyglKA4B1TSFuqNI8=;
        b=MHwwhiqdccQ6eLCOEC2M2cnawwuKC2EDf5q/KuEk6a5Z6zZ3Yh/uFqJkLesMrodI2e
         ANgMvwuhEnAm8pVssJ/rP9LEgu2EDdBbupHGXFfffDSrGIpJ8e4qx71/dcT4UvXE378n
         jDgg89cNLqy3U+VlmO16pUeC+dAcjHV6rrUnRVO050qhc2UDYWW2PwxOIKuhii3iIKmp
         +YP76uoSPttLsMW50UQOB4jnMWfMZ+i1mKaVSJ6qJcCtxBbRs3Sj4pqsU5PdagPrfy4+
         mes4CL3biu63JWjnvID3PhgSS/Tva9dIiiElg0pyyCy6PG5FpR1NrSC3BkuUaXyzc0Uz
         mEug==
X-Gm-Message-State: AOJu0Yz5k8zTXaXXIjNpZsYmij3F/GTU/TcbkY8odnXcGXcd4oX0BCKq
	79TekRo3AlZSSm+Rt9ZGucVf/Q4V2Qa2kcM1zXETVg5v+eH5UvnOo/c89h10WHs=
X-Google-Smtp-Source: AGHT+IH/Rl7d5/VaOeLI+u/rochHeddi7/bqmk7PO5l7rdnF76A8Z7sWQ5XZ+KyWTWonAtQ7mKQreQ==
X-Received: by 2002:a17:907:7e85:b0:a7a:ac5f:bbef with SMTP id a640c23a62f3a-a8a432099d9mr256924866b.31.1725462100982;
        Wed, 04 Sep 2024 08:01:40 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623a9234sm2115466b.156.2024.09.04.08.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 08:01:40 -0700 (PDT)
Message-ID: <43945011477a7fb65c6bd267c8302d91961d4c59.camel@suse.com>
Subject: Re: [PATCH 03/15] libmultipath: split out the code to wait for
 pending checkers
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 17:01:39 +0200
In-Reply-To: <20240828221757.4060548-4-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-4-bmarzins@redhat.com>
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
> This patch adds a new optional symbol for the dynamic path checker
> libraries, libcheck_pending. This is currently unused, but can be
> called
> on pending checkers to check if they've completed and return their
> value.
> The "tur" and "directio" checkers are the only ones which can return
> PATH_PENDING. They now implement libcheck_pending() as a wrapper
> around
> the code that libcheck_check uses to wait for pending paths, which
> has
> been broken out into its own function.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/checkers/directio.c | 86 ++++++++++++++++++++++-------=
-
> --
> =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 65 ++++=
++++++++++++--------
> =C2=A04 files changed, 109 insertions(+), 47 deletions(-)
>=20
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index c4918d28..298aec78 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -26,6 +26,7 @@ struct checker_class {
> =C2=A0	void (*free)(struct checker *);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* t=
o free the context
> */
> =C2=A0	void (*reset)(void);		=C2=A0=C2=A0=C2=A0=C2=A0 /* to reset the glo=
bal
> variables */
> =C2=A0	void *(*thread)(void *);	=C2=A0=C2=A0=C2=A0=C2=A0 /* async thread =
entry
> point */
> +	int (*pending)(struct checker *);=C2=A0=C2=A0=C2=A0 /* to recheck pendi=
ng
> paths */
> =C2=A0	const char **msgtable;
> =C2=A0	short msgtable_size;
> =C2=A0};
> @@ -180,7 +181,8 @@ static struct checker_class
> *add_checker_class(const char *name)
> =C2=A0	c->mp_init =3D (int (*)(struct checker *)) dlsym(c->handle,
> "libcheck_mp_init");
> =C2=A0	c->reset =3D (void (*)(void)) dlsym(c->handle,
> "libcheck_reset");
> =C2=A0	c->thread =3D (void *(*)(void*)) dlsym(c->handle,
> "libcheck_thread");
> -	/* These 3 functions can be NULL. call dlerror() to clear
> out any
> +	c->pending =3D (int (*)(struct checker *)) dlsym(c->handle,
> "libcheck_pending");
> +	/* These 4 functions can be NULL. call dlerror() to clear
> out any
> =C2=A0	 * error string */
> =C2=A0	dlerror();
> =C2=A0
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index fb1160af..b2342a1b 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -190,6 +190,7 @@ void libcheck_free(struct checker *);
> =C2=A0void *libcheck_thread(struct checker_context *ctx);
> =C2=A0void libcheck_reset(void);
> =C2=A0int libcheck_mp_init(struct checker *);
> +int libcheck_pending(struct checker *c);
> =C2=A0
> =C2=A0
> =C2=A0/*
> diff --git a/libmultipath/checkers/directio.c
> b/libmultipath/checkers/directio.c
> index 8e87878b..3f88b40d 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -288,14 +288,36 @@ get_events(struct aio_group *aio_grp, struct
> timespec *timeout)
> =C2=A0	return got_events;
> =C2=A0}
> =C2=A0
> +static void
> +check_pending(struct directio_context *ct, struct timespec endtime)
> +{
> +	int r;
> +	struct timespec currtime, timeout;
> +
> +	while(1) {
> +		get_monotonic_time(&currtime);
> +		timespecsub(&endtime, &currtime, &timeout);
> +		if (timeout.tv_sec < 0)
> +			timeout.tv_sec =3D timeout.tv_nsec =3D 0;
> +
> +		r =3D get_events(ct->aio_grp, &timeout);
> +
> +		if (ct->req->state !=3D PATH_PENDING) {
> +			ct->running =3D 0;
> +			return;
> +		} else if (r =3D=3D 0 ||
> +			=C2=A0=C2=A0 (timeout.tv_sec =3D=3D 0 && timeout.tv_nsec
> =3D=3D 0))
> +			return;
> +	}
> +}
> +
> =C2=A0static int
> =C2=A0check_state(int fd, struct directio_context *ct, int sync, int
> timeout_secs)
> =C2=A0{
> =C2=A0	struct timespec	timeout =3D { .tv_nsec =3D 1000 };
> =C2=A0	struct stat	sb;
> =C2=A0	int		rc;
> -	long		r;
> -	struct timespec currtime, endtime;
> +	struct timespec endtime;
> =C2=A0
> =C2=A0	if (fstat(fd, &sb) =3D=3D 0) {
> =C2=A0		LOG(4, "called for %x", (unsigned) sb.st_rdev);
> @@ -330,21 +352,11 @@ check_state(int fd, struct directio_context
> *ct, int sync, int timeout_secs)
> =C2=A0	endtime.tv_sec +=3D timeout.tv_sec;
> =C2=A0	endtime.tv_nsec +=3D timeout.tv_nsec;
> =C2=A0	normalize_timespec(&endtime);
> -	while(1) {
> -		r =3D get_events(ct->aio_grp, &timeout);
> =C2=A0
> -		if (ct->req->state !=3D PATH_PENDING) {
> -			ct->running =3D 0;
> -			return ct->req->state;
> -		} else if (r =3D=3D 0 ||
> -			=C2=A0=C2=A0 (timeout.tv_sec =3D=3D 0 && timeout.tv_nsec
> =3D=3D 0))
> -			break;
> +	check_pending(ct, endtime);
> +	if (ct->req->state !=3D PATH_PENDING)
> +		return ct->req->state;
> =C2=A0
> -		get_monotonic_time(&currtime);
> -		timespecsub(&endtime, &currtime, &timeout);
> -		if (timeout.tv_sec < 0)
> -			timeout.tv_sec =3D timeout.tv_nsec =3D 0;
> -	}
> =C2=A0	if (ct->running > timeout_secs || sync) {
> =C2=A0		struct io_event event;
> =C2=A0
> @@ -360,17 +372,9 @@ check_state(int fd, struct directio_context *ct,
> int sync, int timeout_secs)
> =C2=A0	return rc;
> =C2=A0}
> =C2=A0
> -int libcheck_check (struct checker * c)
> +static void set_msgid(struct checker *c, int state)
> =C2=A0{
> -	int ret;
> -	struct directio_context * ct =3D (struct directio_context *)c-
> >context;
> -
> -	if (!ct)
> -		return PATH_UNCHECKED;
> -
> -	ret =3D check_state(c->fd, ct, checker_is_sync(c), c-
> >timeout);
> -
> -	switch (ret)
> +	switch (state)
> =C2=A0	{
> =C2=A0	case PATH_UNCHECKED:
> =C2=A0		c->msgid =3D MSG_DIRECTIO_UNKNOWN;
> @@ -387,5 +391,37 @@ int libcheck_check (struct checker * c)
> =C2=A0	default:
> =C2=A0		break;
> =C2=A0	}
> +}
> +
> +int libcheck_pending(struct checker *c)
> +{
> +	struct timespec endtime;
> +	struct directio_context *ct =3D (struct directio_context *)c-
> >context;
> +
> +	/* The if path checker isn't running, just return the
> exiting value. */
> +	if (!ct || !ct->running)
> +		return c->path_state;
> +
> +	if (ct->req->state =3D=3D PATH_PENDING) {
> +		get_monotonic_time(&endtime);
> +		check_pending(ct, endtime);
> +	} else
> +		ct->running =3D 0;
> +	set_msgid(c, ct->req->state);
> +
> +	return ct->req->state;
> +}
> +
> +int libcheck_check (struct checker * c)
> +{
> +	int ret;
> +	struct directio_context * ct =3D (struct directio_context *)c-
> >context;
> +
> +	if (!ct)
> +		return PATH_UNCHECKED;
> +
> +	ret =3D check_state(c->fd, ct, checker_is_sync(c), c-
> >timeout);
> +	set_msgid(c, ret);
> +
> =C2=A0	return ret;
> =C2=A0}
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index a2905af5..95af5214 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -323,6 +323,49 @@ static int tur_check_async_timeout(struct
> checker *c)
> =C2=A0	return (now.tv_sec > ct->time);
> =C2=A0}
> =C2=A0
> +int check_pending(struct checker *c, struct timespec endtime)
> +{
> +	struct tur_checker_context *ct =3D c->context;
> +	int r, tur_status =3D PATH_PENDING;
> +
> +	pthread_mutex_lock(&ct->lock);
> +
> +	for (r =3D 0;
> +	=C2=A0=C2=A0=C2=A0=C2=A0 r =3D=3D 0 && ct->state =3D=3D PATH_PENDING &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0 ct->msgid =3D=3D MSG_TUR_RUNNING;
> +	=C2=A0=C2=A0=C2=A0=C2=A0 r =3D pthread_cond_timedwait(&ct->active, &ct-=
>lock,
> &endtime));
> +
> +	if (!r) {
> +		tur_status =3D ct->state;
> +		c->msgid =3D ct->msgid;
> +	}
> +	pthread_mutex_unlock(&ct->lock);
> +	if (tur_status =3D=3D PATH_PENDING && c->msgid =3D=3D
> MSG_TUR_RUNNING) {
> +		condlog(4, "%d:%d : tur checker still running",
> +			major(ct->devt), minor(ct->devt));
> +	} else {
> +		int running =3D uatomic_xchg(&ct->running, 0);
> +		if (running)
> +			pthread_cancel(ct->thread);
> +		ct->thread =3D 0;
> +	}
> +
> +	return tur_status;
> +}
> +
> +int libcheck_pending(struct checker *c)
> +{
> +	struct timespec endtime;
> +	struct tur_checker_context *ct =3D c->context;
> +
> +	/* The if path checker isn't running, just return the
> exiting value. */
> +	if (!ct || !ct->thread)
> +		return c->path_state;
> +
> +	get_monotonic_time(&endtime);
> +	return check_pending(c, endtime);

Does this work?=C2=A0

https://pubs.opengroup.org/onlinepubs/009695299/functions/pthread_cond_time=
dwait.html
says that "an error is returned [...] if the absolute time specified by
abstime has already been passed at the time of the call".

Which would always be the case if you pass a timestamp that you=20
fetched previously unmodified, meaning that you'd always get ETIMEDOUT.
Or am I misreading the docs?

Martin







> +}
> +
> =C2=A0int libcheck_check(struct checker * c)
> =C2=A0{
> =C2=A0	struct tur_checker_context *ct =3D c->context;
> @@ -437,27 +480,7 @@ int libcheck_check(struct checker * c)
> =C2=A0			return tur_check(c->fd, c->timeout, &c-
> >msgid);
> =C2=A0		}
> =C2=A0		tur_timeout(&tsp);
> -		pthread_mutex_lock(&ct->lock);
> -
> -		for (r =3D 0;
> -		=C2=A0=C2=A0=C2=A0=C2=A0 r =3D=3D 0 && ct->state =3D=3D PATH_PENDING &=
&
> -			=C2=A0=C2=A0=C2=A0=C2=A0 ct->msgid =3D=3D MSG_TUR_RUNNING;
> -		=C2=A0=C2=A0=C2=A0=C2=A0 r =3D pthread_cond_timedwait(&ct->active, &ct=
-
> >lock, &tsp));
> -
> -		if (!r) {
> -			tur_status =3D ct->state;
> -			c->msgid =3D ct->msgid;
> -	}
> -		pthread_mutex_unlock(&ct->lock);
> -		if (tur_status =3D=3D PATH_PENDING && c->msgid =3D=3D
> MSG_TUR_RUNNING) {
> -			condlog(4, "%d:%d : tur checker still
> running",
> -				major(ct->devt), minor(ct->devt));
> -		} else {
> -			int running =3D uatomic_xchg(&ct->running, 0);
> -			if (running)
> -				pthread_cancel(ct->thread);
> -			ct->thread =3D 0;
> -		}
> +		tur_status =3D check_pending(c, tsp);
> =C2=A0	}
> =C2=A0
> =C2=A0	return tur_status;

