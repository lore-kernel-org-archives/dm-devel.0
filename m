Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35FE13A276
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 20:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725480337; cv=none; b=juXSEDbjpkhAh9JZa8GZRrgofptx4ZYhB3VHYdVntlDxIjnjoJZWPCoQmNDmjGv8eF/+2Stjhe+m5B9JUu9dHDW/cu/yGeQFJfcuBCGWfNM+HwixGLQmcsmvGn2AMADM4G+E+dSoz8nC51irJ++Mr9xV1aoQGB9wCgtA0OYECMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725480337; c=relaxed/simple;
	bh=CPQ1B0oYpu/5+N3Qvwp67Qsl2a7cWbUKoWUFePb0g6k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TAf7vRAAMpYOrXxiNqQUlfgMz4X1Ff2jf3++QDJf3cN0GH8U673TeJnmsn1j7qBCZcN3ARvveoVJxbU2k+L/OqNc1oMDSVwRKyIqv33sGJxpJ/8CfztU44I6YgRbNMDwsJRnY8vy6ex/FAUhAo9YiDHxePe5V4EVsLxOcdtsfj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qi967qet; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qi967qet"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c263118780so3216732a12.2
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 13:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725480333; x=1726085133; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iAjtQJMEQqhaN7EHFgou/WCaKisO3iZH9t0H20dSC3Y=;
        b=Qi967qet9hpBvTJee7yQE1W/7JOcg0PbR8DtiRJn8uHuSwxDsmZ1c1WX/J7ALQEbC1
         x3ymk8iUipp4eRS9/828DgwohA3ok6zxkX/o/33hnt+V1UFUSOIYx0JT6F6G/TpujwZ+
         6TgOzROCL2PTwZKU0SYlFNpIcB8R92Ebfwu9VvfF6XXRlTlaA32vKeDP116LX1WEG+yX
         eNOLpFmWLYood6kOTwKzX5VrBCDWxuaLX91HaBBwOAGfK0nddEJ3Gcz8GSEHWrivbPOq
         hms50+iodt76dXSt5eEjNSsTxZzYyqpZ5T0IIx0iXK1P6yLgHkLwhniIK7yakki0+etU
         NT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725480333; x=1726085133;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAjtQJMEQqhaN7EHFgou/WCaKisO3iZH9t0H20dSC3Y=;
        b=l+E+swKBpluDzJXJiFv+5xhpxXlPb1mK/seNNYcdfBQbDJXF2oj3KlrDoZjHZ7k4op
         7pq/CjcvGGNeBIEzzlgdcprHGtnrIwFCXPVtxkVHJGCe8BrraY9Lxt4BXMcudP2Hacdo
         9a2XQ+QoIf7WXId3MitweDWqFHNHf3JD+M5kljLHzNIcKxBenRoMlE5B1nsQeUujgWdx
         /nmZpQDjewCzVPjcibN5jOtLclUOmoRodZLhJiSWHCaws4M/lkI7THAeiJhjz0DFjp5T
         KF8TfoiQhcKoZGrDDgeoc6WB18I3oMbB7NBJHdZUdaZXf/9zYtaNd2A8Ll1Yk+Ky3tYd
         cuOw==
X-Gm-Message-State: AOJu0Yy06u+B+Gj6sAOmy0x0lodQvKI3uiyGsygQ1JauMKYQTQy0Fkr7
	yDLgkXcbUbBzAczTIm00Yq6oVcwh7gQZ6cWUzvQNbDjAVndHZs0PEPh9I2Pz9j13PFJvFZANVdF
	U
X-Google-Smtp-Source: AGHT+IF2BcvJ96/ziSmx/M0iegaSy99XMsAhQmQocdUyf5dFb9XpZTehrotNJ2babKyBGeUrMfsKBg==
X-Received: by 2002:a05:6402:51ca:b0:5c0:aa23:e1c1 with SMTP id 4fb4d7f45d1cf-5c25f23a831mr8436891a12.14.1725480332699;
        Wed, 04 Sep 2024 13:05:32 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc6a7f5csm279666a12.94.2024.09.04.13.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:05:32 -0700 (PDT)
Message-ID: <de20ab3264728d3ce0d56b7f6debe79315ae72fd.camel@suse.com>
Subject: Re: [PATCH 04/15] libmultipath: remove pending wait code from
 libcheck_check calls
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 22:05:30 +0200
In-Reply-To: <20240828221757.4060548-5-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-5-bmarzins@redhat.com>
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
> When the tur and directio checkers start an asynchronous checker,
> they
> now immediately return with the path in PATH_PENDING, instead of
> waiting in checker_check(). Instead the wait now happens in
> checker_get_state().
>=20
> Additionally, the directio checker now waits for 1 ms, like the tur
> checker does. Also like the tur checker it now only waits once. If it
> is still pending after the first call to checker_get_state(). It will
> not wait at all on future calls, and will just process the already
> completed IOs.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Now I understand what you're doing, but I find it somewhat confusing. I
believe this can be simplified after the split between starting the
checkers and looking at their result.

Why not just fire off the checkers, wait 1ms for _all_ the just started
checkers in checkerloop() [*], and then do the pending test like it is
now (but just in polling mode, with no c->timeout)?

Regards
Martin

[*] or maybe even a little more, 5ms, say: we'd still be waiting far
less time than we used to, but greatly increase the odds that most
checkers actually complete.


> ---
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 7 +++-
> =C2=A0libmultipath/checkers/directio.c | 57 +++++++++++++++++------------=
-
> --
> =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 13 +++-=
----
> =C2=A03 files changed, 41 insertions(+), 36 deletions(-)
>=20
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index 298aec78..b44b856a 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -303,7 +303,12 @@ void checker_put (struct checker * dst)
> =C2=A0
> =C2=A0int checker_get_state(struct checker *c)
> =C2=A0{
> -	return c ? c->path_state : PATH_UNCHECKED;
> +	if (!c)
> +		return PATH_UNCHECKED;
> +	if (c->path_state !=3D PATH_PENDING || !c->cls->pending)
> +		return c->path_state;
> +	c->path_state =3D c->cls->pending(c);
> +	return c->path_state;
> =C2=A0}
> =C2=A0
> =C2=A0void checker_check (struct checker * c, int path_state)
> diff --git a/libmultipath/checkers/directio.c
> b/libmultipath/checkers/directio.c
> index 3f88b40d..904e3071 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -60,10 +60,11 @@ const char *libcheck_msgtable[] =3D {
> =C2=A0#define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt,
> ##args)
> =C2=A0
> =C2=A0struct directio_context {
> -	int		running;
> +	unsigned int	running;
> =C2=A0	int		reset_flags;
> =C2=A0	struct aio_group *aio_grp;
> =C2=A0	struct async_req *req;
> +	struct timespec endtime;
> =C2=A0};
> =C2=A0
> =C2=A0static struct aio_group *
> @@ -314,19 +315,16 @@ check_pending(struct directio_context *ct,
> struct timespec endtime)
> =C2=A0static int
> =C2=A0check_state(int fd, struct directio_context *ct, int sync, int
> timeout_secs)
> =C2=A0{
> -	struct timespec	timeout =3D { .tv_nsec =3D 1000 };
> =C2=A0	struct stat	sb;
> =C2=A0	int		rc;
> +	struct io_event event;
> =C2=A0	struct timespec endtime;
> =C2=A0
> =C2=A0	if (fstat(fd, &sb) =3D=3D 0) {
> =C2=A0		LOG(4, "called for %x", (unsigned) sb.st_rdev);
> =C2=A0	}
> -	if (sync > 0) {
> +	if (sync > 0)
> =C2=A0		LOG(4, "called in synchronous mode");
> -		timeout.tv_sec=C2=A0 =3D timeout_secs;
> -		timeout.tv_nsec =3D 0;
> -	}
> =C2=A0
> =C2=A0	if (ct->running) {
> =C2=A0		if (ct->req->state !=3D PATH_PENDING) {
> @@ -345,31 +343,26 @@ check_state(int fd, struct directio_context
> *ct, int sync, int timeout_secs)
> =C2=A0			LOG(3, "io_submit error %i", -rc);
> =C2=A0			return PATH_UNCHECKED;
> =C2=A0		}
> +		get_monotonic_time(&ct->endtime);
> +		ct->endtime.tv_nsec +=3D 1000 * 1000;
> +		normalize_timespec(&ct->endtime);
> =C2=A0	}
> =C2=A0	ct->running++;
> +	if (!sync)
> +		return PATH_PENDING;
> =C2=A0
> =C2=A0	get_monotonic_time(&endtime);
> -	endtime.tv_sec +=3D timeout.tv_sec;
> -	endtime.tv_nsec +=3D timeout.tv_nsec;
> +	endtime.tv_sec +=3D timeout_secs;
> =C2=A0	normalize_timespec(&endtime);
> =C2=A0
> =C2=A0	check_pending(ct, endtime);
> =C2=A0	if (ct->req->state !=3D PATH_PENDING)
> =C2=A0		return ct->req->state;
> =C2=A0
> -	if (ct->running > timeout_secs || sync) {
> -		struct io_event event;
> -
> -		LOG(3, "abort check on timeout");
> -
> -		io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
> -		rc =3D PATH_DOWN;
> -	} else {
> -		LOG(4, "async io pending");
> -		rc =3D PATH_PENDING;
> -	}
> +	LOG(3, "abort check on timeout");
> =C2=A0
> -	return rc;
> +	io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
> +	return PATH_DOWN;
> =C2=A0}
> =C2=A0
> =C2=A0static void set_msgid(struct checker *c, int state)
> @@ -395,21 +388,31 @@ static void set_msgid(struct checker *c, int
> state)
> =C2=A0
> =C2=A0int libcheck_pending(struct checker *c)
> =C2=A0{
> -	struct timespec endtime;
> +	int rc;
> +	struct io_event event;
> =C2=A0	struct directio_context *ct =3D (struct directio_context *)c-
> >context;
> =C2=A0
> =C2=A0	/* The if path checker isn't running, just return the
> exiting value. */
> =C2=A0	if (!ct || !ct->running)
> =C2=A0		return c->path_state;
> =C2=A0
> -	if (ct->req->state =3D=3D PATH_PENDING) {
> -		get_monotonic_time(&endtime);
> -		check_pending(ct, endtime);
> -	} else
> +	if (ct->req->state =3D=3D PATH_PENDING)
> +		check_pending(ct, ct->endtime);
> +	else
> =C2=A0		ct->running =3D 0;
> -	set_msgid(c, ct->req->state);
> +	rc =3D ct->req->state;
> +	if (rc =3D=3D PATH_PENDING) {
> +		if (ct->running > c->timeout) {
> +			LOG(3, "abort check on timeout");
> +			io_cancel(ct->aio_grp->ioctx, &ct->req->io,
> &event);
> +			rc =3D PATH_DOWN;
> +		}
> +		else
> +			LOG(4, "async io pending");
> +	}
> +	set_msgid(c, rc);
> =C2=A0
> -	return ct->req->state;
> +	return rc;
> =C2=A0}
> =C2=A0
> =C2=A0int libcheck_check (struct checker * c)
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index 95af5214..81db565b 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -58,6 +58,7 @@ struct tur_checker_context {
> =C2=A0	int msgid;
> =C2=A0	struct checker_context ctx;
> =C2=A0	unsigned int nr_timeouts;
> +	struct timespec endtime;
> =C2=A0};
> =C2=A0
> =C2=A0int libcheck_init (struct checker * c)
> @@ -323,7 +324,7 @@ static int tur_check_async_timeout(struct checker
> *c)
> =C2=A0	return (now.tv_sec > ct->time);
> =C2=A0}
> =C2=A0
> -int check_pending(struct checker *c, struct timespec endtime)
> +int check_pending(struct checker *c)
> =C2=A0{
> =C2=A0	struct tur_checker_context *ct =3D c->context;
> =C2=A0	int r, tur_status =3D PATH_PENDING;
> @@ -333,7 +334,7 @@ int check_pending(struct checker *c, struct
> timespec endtime)
> =C2=A0	for (r =3D 0;
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 r =3D=3D 0 && ct->state =3D=3D PATH_PENDI=
NG &&
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 ct->msgid =3D=3D MSG_TUR_RUNNING;
> -	=C2=A0=C2=A0=C2=A0=C2=A0 r =3D pthread_cond_timedwait(&ct->active, &ct-=
>lock,
> &endtime));
> +	=C2=A0=C2=A0=C2=A0=C2=A0 r =3D pthread_cond_timedwait(&ct->active, &ct-=
>lock, &ct-
> >endtime));
> =C2=A0
> =C2=A0	if (!r) {
> =C2=A0		tur_status =3D ct->state;
> @@ -355,21 +356,18 @@ int check_pending(struct checker *c, struct
> timespec endtime)
> =C2=A0
> =C2=A0int libcheck_pending(struct checker *c)
> =C2=A0{
> -	struct timespec endtime;
> =C2=A0	struct tur_checker_context *ct =3D c->context;
> =C2=A0
> =C2=A0	/* The if path checker isn't running, just return the
> exiting value. */
> =C2=A0	if (!ct || !ct->thread)
> =C2=A0		return c->path_state;
> =C2=A0
> -	get_monotonic_time(&endtime);
> -	return check_pending(c, endtime);
> +	return check_pending(c);
> =C2=A0}
> =C2=A0
> =C2=A0int libcheck_check(struct checker * c)
> =C2=A0{
> =C2=A0	struct tur_checker_context *ct =3D c->context;
> -	struct timespec tsp;
> =C2=A0	pthread_attr_t attr;
> =C2=A0	int tur_status, r;
> =C2=A0
> @@ -479,8 +477,7 @@ int libcheck_check(struct checker * c)
> =C2=A0				" sync mode", major(ct->devt),
> minor(ct->devt));
> =C2=A0			return tur_check(c->fd, c->timeout, &c-
> >msgid);
> =C2=A0		}
> -		tur_timeout(&tsp);
> -		tur_status =3D check_pending(c, tsp);
> +		tur_timeout(&ct->endtime);
> =C2=A0	}
> =C2=A0
> =C2=A0	return tur_status;

