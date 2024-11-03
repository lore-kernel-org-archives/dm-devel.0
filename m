Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9299983CD3
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 20:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730667405; cv=none; b=seM0DF6f0IJbGtuX4t+ve+zvkPq6g5pCGwgPx2MaQ3PU/sBHXsE/SJCe66Ak11JdcJ6HfALaaFQIvkM8jEnR2trj0zrYZXMvVbtYeuYxymG3qRhykoKLNmRcQBUvKZfFKhEhrqcNuhjqcX8RwY8Xtd9lrHiNrVYSIluaPzGUjCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730667405; c=relaxed/simple;
	bh=euIy3+ZOVI5GwIjNfulHgusDt37OSI43lU4nrR5kUpc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o6B9WKoRV8nbN665cWKprw96SQPolO4UdLo6BGsE39hygRCt8WqQ/FVVjU1EeaVV/mM07lExfRB14UXUCgg1ZoyV9Af58UCR6bX1uPXUha3MfftsUWweKCTyqDYNfnEAVno3U+n5f0+chcv7agu6NljbnIsbJ25mRGQEU0JadsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Zu5NFaba; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zu5NFaba"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9a6b4ca29bso451879166b.3
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 12:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730667402; x=1731272202; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tY02D8PTXstOE6X5g6uk28WlSIl2wxPy96O7hUiy4QY=;
        b=Zu5NFabaaojLnb3vpTnigCOcdfqTdUJfcdNHcGmNLpQ69nTxAgFP93ptEKgbfDWMxr
         3Brc0GUX6aLbqxdkmZxqDY7fYWxw2vnPfdTeNieCI3MvaJtr5K5w6IEXXbhrzMXlkKKv
         uMkIiSzqRw1BleSY6PuIwRv24xKvXu7Cvs1yOq/q2yEaAx7bmWypVYlDWkV8W1CxT6VK
         OF8oIvP4ONH0hOQObMPHfTXAH6QeNA6wTsXuvdoSCXxqkapn5/lcHBukdzl7GpA3DOxe
         vu8sGDTqLcZOesNFqB9Uk8AgXZBEdA64YGZlZIVhJPT72eSfaANDHI7x6QgsHXFwLIsz
         aCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730667402; x=1731272202;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tY02D8PTXstOE6X5g6uk28WlSIl2wxPy96O7hUiy4QY=;
        b=h0RiaxOt2cNsX5ygdq426Ajtfb2IQAHOcLkpz/I1p8HKKyH9wYvu7MwmEYLOk4YVi2
         i7pZomoa3gGMRuuYIUnlDfNRckknd1ZgAP0ozz5OeVmPUiNfAi41qTQc0fc+krtrvCy3
         pNmhWU2jpU0u5mWJkp+34oMgpkakM99F4T3TuMDuSOArwiHcZqXwAFpBS9kUp8ODFNTs
         H/avGAMZqG9Y7PdPb/qEEBANGdnwj7gjtlwkceC12jaqiE3ras553LNmNL7VIVDkW/sP
         4GUnkBbNqYhcdqjf2/jM0JAA+Y4RqjmZFDAIEzS3brzB1T2Qwk1oUm2X2j6Lptj4mr5n
         /O+A==
X-Gm-Message-State: AOJu0YzfNqY0/uVyQ4FA0E/uGhJJ/ALuavcpyHITPGqwqA2BGfX5t/f1
	6MSygAwAVKUrE2AYrljXFOe9B+JyFqDbLjbPTRIStxBB11V4G+4HCtLB9ZmUoliOz1dpwqatD4e
	i
X-Google-Smtp-Source: AGHT+IEf3VPdZ8YpYuOEzRXBBxABcAJ3e14OPUBXONum2s9En/RhwvfVYsABSODIR6k0n316TToRaQ==
X-Received: by 2002:a17:907:72d6:b0:a9a:14fc:9868 with SMTP id a640c23a62f3a-a9e5089b6b2mr1244418866b.4.1730667401470;
        Sun, 03 Nov 2024 12:56:41 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564e8e63sm463631466b.91.2024.11.03.12.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 12:56:40 -0800 (PST)
Message-ID: <f13217ad2bca4c8a013251471fccdf296d925818.camel@suse.com>
Subject: Re: [PATCH v5 23/23] multipathd: use timestamps to tell when the
 directio checker timed out
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 21:56:40 +0100
In-Reply-To: <20241015032835.2693247-24-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
	 <20241015032835.2693247-24-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> Instead of counting the number of times the path checker has been
> called and treating that as the number of seconds that have passed,
> calculate the actual timestamp when the checker will time out, and
> check that instead.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/checkers/directio.c | 44 ++++++++++++++++++++++-------=
-
> --
> =C2=A01 file changed, 31 insertions(+), 13 deletions(-)
>=20
> diff --git a/libmultipath/checkers/directio.c
> b/libmultipath/checkers/directio.c
> index 27227894..d35a6bac 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -60,13 +60,28 @@ const char *libcheck_msgtable[] =3D {
> =C2=A0#define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt,
> ##args)
> =C2=A0
> =C2=A0struct directio_context {
> -	unsigned int	running;
> -	int		reset_flags;
> +	time_t timeout;


I'd have used a struct timespec here rather than time_t.

> +	int reset_flags;
> =C2=A0	struct aio_group *aio_grp;
> =C2=A0	struct async_req *req;
> =C2=A0	bool checked_state;
> =C2=A0};
> =C2=A0
> +bool is_running(struct directio_context *ct) {
> +	return (ct->timeout !=3D 0);
> +}
> +
> +void start_running(struct directio_context *ct, int timeout_secs) {
> +	struct timespec now;
> +
> +	get_monotonic_time(&now);
> +	ct->timeout =3D now.tv_sec + timeout_secs;
> +}
> +
> +void stop_running(struct directio_context *ct) {
> +	ct->timeout =3D 0;
> +}
> +

I think the 3 functions above should be static.

> =C2=A0static struct aio_group *
> =C2=A0add_aio_group(void)
> =C2=A0{
> @@ -234,9 +249,9 @@ void libcheck_free (struct checker * c)
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> -	if (ct->running && ct->req->state !=3D PATH_PENDING)
> -		ct->running =3D 0;
> -	if (!ct->running) {
> +	if (is_running(ct) && ct->req->state !=3D PATH_PENDING)
> +		stop_running(ct);
> +	if (!is_running(ct)) {
> =C2=A0		free(ct->req->buf);
> =C2=A0		free(ct->req);
> =C2=A0		ct->aio_grp->holders--;
> @@ -304,7 +319,7 @@ check_pending(struct directio_context *ct, struct
> timespec timeout)
> =C2=A0		r =3D get_events(ct->aio_grp, &timeout);
> =C2=A0
> =C2=A0		if (ct->req->state !=3D PATH_PENDING) {
> -			ct->running =3D 0;
> +			stop_running(ct);
> =C2=A0			return;
> =C2=A0		} else if (r =3D=3D 0 ||
> =C2=A0			=C2=A0=C2=A0 (timeout.tv_sec =3D=3D 0 && timeout.tv_nsec
> =3D=3D 0))
> @@ -330,10 +345,10 @@ check_state(int fd, struct directio_context
> *ct, int sync, int timeout_secs)
> =C2=A0	if (sync > 0)
> =C2=A0		LOG(4, "called in synchronous mode");
> =C2=A0
> -	if (ct->running) {
> +	if (is_running(ct)) {
> =C2=A0		ct->checked_state =3D true;
> =C2=A0		if (ct->req->state !=3D PATH_PENDING) {
> -			ct->running =3D 0;
> +			stop_running(ct);
> =C2=A0			return ct->req->state;
> =C2=A0		}
> =C2=A0	} else {
> @@ -348,9 +363,9 @@ check_state(int fd, struct directio_context *ct,
> int sync, int timeout_secs)
> =C2=A0			LOG(3, "io_submit error %i", -rc);
> =C2=A0			return PATH_UNCHECKED;
> =C2=A0		}
> +		start_running(ct, timeout_secs);
> =C2=A0		ct->checked_state =3D false;
> =C2=A0	}
> -	ct->running++;
> =C2=A0	if (!sync)
> =C2=A0		return PATH_PENDING;
> =C2=A0
> @@ -388,7 +403,7 @@ static void set_msgid(struct checker *c, int
> state)
> =C2=A0bool libcheck_need_wait(struct checker *c)
> =C2=A0{
> =C2=A0	struct directio_context *ct =3D (struct directio_context *)c-
> >context;
> -	return (ct && ct->running && ct->req->state =3D=3D PATH_PENDING
> &&
> +	return (ct && is_running(ct) && ct->req->state =3D=3D
> PATH_PENDING &&
> =C2=A0		!ct->checked_state);
> =C2=A0}
> =C2=A0
> @@ -400,7 +415,7 @@ int libcheck_pending(struct checker *c)
> =C2=A0	struct timespec no_wait =3D { .tv_sec =3D 0 };
> =C2=A0
> =C2=A0	/* The if path checker isn't running, just return the
> exiting value. */
> -	if (!ct || !ct->running) {
> +	if (!ct || !is_running(ct)) {
> =C2=A0		rc =3D c->path_state;
> =C2=A0		goto out;
> =C2=A0	}
> @@ -408,10 +423,13 @@ int libcheck_pending(struct checker *c)
> =C2=A0	if (ct->req->state =3D=3D PATH_PENDING)
> =C2=A0		check_pending(ct, no_wait);
> =C2=A0	else
> -		ct->running =3D 0;
> +		stop_running(ct);
> =C2=A0	rc =3D ct->req->state;
> =C2=A0	if (rc =3D=3D PATH_PENDING) {
> -		if (ct->running > c->timeout) {
> +		struct timespec now;
> +
> +		get_monotonic_time(&now);
> +		if (now.tv_sec > ct->timeout) {

We could timeout a second too late here, that's why I'd suggest using
timespec.

> =C2=A0			LOG(3, "abort check on timeout");
> =C2=A0			io_cancel(ct->aio_grp->ioctx, &ct->req->io,
> &event);
> =C2=A0			rc =3D PATH_DOWN;

Regards
Martin

