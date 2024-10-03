Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FA713B2AF
	for <dm-devel@lists.linux.dev>; Thu,  3 Oct 2024 21:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727990128; cv=none; b=DozlaUf/aM7hbla4+SfvCYR2oNcVxpquFRaEx02NA4C0m/E+ndA0A84mITVZFA29uV/q0cqVfFj+PBN1Dss/9IfFklXpRvSb1AoASaHPjf0zpJXo08T5dqEy8a0rtTjv6m3+ZTVXqjh6OgZAxTPhUsRNHKSrXdlw6m8bGqGNGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727990128; c=relaxed/simple;
	bh=cNGeweLK28fgwJIpuqRtsCgAWNYQmrneRrp/OIqDd2c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IVREY11zOU03rBsy143fvPM3Xvo+SO+9Bca62Nm+T6qkkJEVpRloN+UgNhLjS2E1PteHu3+H89jyjxpJGpAfXnxknSFLtzcA89rrcY1Dx/YQ0b45TcYaU6VlcPYfckx3QF0yT3Gy6ZtNSAwyUvdxAw+csNgdECBJirWH4R2GKYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T/9y+ENT; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T/9y+ENT"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8d24f98215so218511966b.1
        for <dm-devel@lists.linux.dev>; Thu, 03 Oct 2024 14:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727990124; x=1728594924; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4JTSIQHdnj/uewFIKDy0ve1voaF/jTm6w1XdZpJpU14=;
        b=T/9y+ENTBRZRDHf83Glt3QGbCPg6Y5sVrkVxXcX8NuBtj0v6OGMq2YP5gE5Yndrzh4
         lkp9Xt2TSXvaE/kY7350CgCHj0R2rv4E6VpfC7w4+JMrH6+Q+u4YJ1Io4H6Wrdr5K+hm
         SdfvbeXmARdCBHPlQWj7oAb5UB/e2jtDeBv48QTZgkQ9clp2kdpyMKKKwSKmG/wYr6D5
         QJOlj3CN2opWHpGkDAS+UFuPYC31Mt/jo68Wx4++P7Iywhk/g9oeHlX5ZWDsWmkrj6vo
         ZGHluhecsObCMmXWm58D71SMofoee+avm1E8mlO0IE5Kr+OxOVkskBPuzAYIE6ZJXhqD
         xQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727990124; x=1728594924;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4JTSIQHdnj/uewFIKDy0ve1voaF/jTm6w1XdZpJpU14=;
        b=Yl4mwusJ3ZwVUdhpVh3rUKT6x4Ip1QIgGvmmFeyoCczRlNUXt8y4rs2Otu8c2wyHzr
         pNjTXwf74VspdvO1v/7OML9QLIJNCacNDT23icVIw91UwLpY6bl/cULcvhQyqsQnQhq9
         RoniyuUsEOYq2o4bP33DyHIamK+eCa+yRSRaaaTwUywVrPF81NqB9Tf99x9U8DWfBKuh
         U8+W/nE0fABPIwvCGcf2/cOF0xWtDmOrPOiJN+7kjmOt3Sd4HXMo8bCROyz7NsmBdMY0
         SKpDyQ0ucBUniIAOyvG/Q7K4aT36liFPeYc+X27WxAontoL+lNIgKn18ldTaX8yXxCWb
         KhYg==
X-Gm-Message-State: AOJu0Yy9YpC91wDEKPWFNIGEjmNnZWqCDF0V4omJQ3mxqmXZ0Z0sos2F
	3/H5sMlTd+MTCCNHGu4BnDIj0z5vbZ3nvVRRuTjdp8UAqimqgq9qnG9HTBues+cM0iiz1Mcp9Ct
	E
X-Google-Smtp-Source: AGHT+IE35mxqhMY3HdbVp8KIfzIYUkUFjQGJFsOxSZsojdG05W5kOUuyRyXCdzqTdZaE0AeAg/wkFA==
X-Received: by 2002:a17:907:3689:b0:a7a:aa35:408c with SMTP id a640c23a62f3a-a991bd137c8mr62958466b.8.1727990123346;
        Thu, 03 Oct 2024 14:15:23 -0700 (PDT)
Received: from ?IPv6:2003:de:3719:4a00:e912:812a:2309:b70? (p200300de37194a00e912812a23090b70.dip0.t-ipconnect.de. [2003:de:3719:4a00:e912:812a:2309:b70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9910479fe4sm132292166b.158.2024.10.03.14.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 14:15:23 -0700 (PDT)
Message-ID: <e46270826de9a255d6e16bcae56e984dfde346ac.camel@suse.com>
Subject: Re: [PATCH v2 19/22] libmultipath: add libcheck_need_wait checker
 function
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 03 Oct 2024 23:15:21 +0200
In-Reply-To: <20240912214947.783819-20-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
	 <20240912214947.783819-20-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> Add a new optional checker class function, libcheck_need_wait() and a
> new function to call it, checker_need_wait(). This can be used to see
> if
> a path_checker is currently running. This will be used to determine
> if
> there are pending checkers that need to be waited for.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 12 +++++++++++-
> =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 4 +++-
> =C2=A0libmultipath/checkers/directio.c | 10 ++++++++++
> =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 ++++=
++++++
> =C2=A04 files changed, 34 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index f3e98352..e2eda58d 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -27,6 +27,7 @@ struct checker_class {
> =C2=A0	void (*reset)(void);		=C2=A0=C2=A0=C2=A0=C2=A0 /* to reset the glo=
bal
> variables */
> =C2=A0	void *(*thread)(void *);	=C2=A0=C2=A0=C2=A0=C2=A0 /* async thread =
entry
> point */
> =C2=A0	int (*pending)(struct checker *);=C2=A0=C2=A0=C2=A0 /* to recheck =
pending
> paths */
> +	bool (*need_wait)(struct checker *); /* checker needs
> waiting for */
> =C2=A0	const char **msgtable;
> =C2=A0	short msgtable_size;
> =C2=A0};
> @@ -182,7 +183,8 @@ static struct checker_class
> *add_checker_class(const char *name)
> =C2=A0	c->reset =3D (void (*)(void)) dlsym(c->handle,
> "libcheck_reset");
> =C2=A0	c->thread =3D (void *(*)(void*)) dlsym(c->handle,
> "libcheck_thread");
> =C2=A0	c->pending =3D (int (*)(struct checker *)) dlsym(c->handle,
> "libcheck_pending");
> -	/* These 4 functions can be NULL. call dlerror() to clear
> out any
> +	c->need_wait =3D (bool (*)(struct checker *)) dlsym(c->handle,
> "libcheck_need_wait");
> +	/* These 5 functions can be NULL. call dlerror() to clear
> out any
> =C2=A0	 * error string */
> =C2=A0	dlerror();
> =C2=A0
> @@ -313,6 +315,14 @@ int checker_get_state(struct checker *c)
> =C2=A0	return c->path_state;
> =C2=A0}
> =C2=A0
> +bool checker_need_wait(struct checker *c)
> +{
> +	if (!c || !c->cls || c->path_state !=3D PATH_PENDING ||
> +	=C2=A0=C2=A0=C2=A0 !c->cls->need_wait)
> +		return false;
> +	return c->cls->need_wait(c);
> +}
> +
> =C2=A0void checker_check (struct checker * c, int path_state)
> =C2=A0{
> =C2=A0	if (!c)
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index b2342a1b..da91f499 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -2,6 +2,7 @@
> =C2=A0#define CHECKERS_H_INCLUDED
> =C2=A0
> =C2=A0#include <pthread.h>
> +#include <stdbool.h>
> =C2=A0#include "list.h"
> =C2=A0#include "defaults.h"
> =C2=A0
> @@ -171,6 +172,7 @@ struct checker_context {
> =C2=A0int start_checker_thread (pthread_t *thread, const pthread_attr_t
> *attr,
> =C2=A0			=C2=A0 struct checker_context *ctx);
> =C2=A0int checker_get_state(struct checker *c);
> +bool checker_need_wait(struct checker *c);
> =C2=A0void checker_check (struct checker *, int);
> =C2=A0int checker_is_sync(const struct checker *);
> =C2=A0const char *checker_name (const struct checker *);
> @@ -191,7 +193,7 @@ void *libcheck_thread(struct checker_context
> *ctx);
> =C2=A0void libcheck_reset(void);
> =C2=A0int libcheck_mp_init(struct checker *);
> =C2=A0int libcheck_pending(struct checker *c);
> -
> +bool libcheck_need_wait(struct checker *c);
> =C2=A0
> =C2=A0/*
> =C2=A0 * msgid =3D> message map.
> diff --git a/libmultipath/checkers/directio.c
> b/libmultipath/checkers/directio.c
> index 904e3071..4beed02e 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -65,6 +65,7 @@ struct directio_context {
> =C2=A0	struct aio_group *aio_grp;
> =C2=A0	struct async_req *req;
> =C2=A0	struct timespec endtime;
> +	bool waited_for;
> =C2=A0};
> =C2=A0
> =C2=A0static struct aio_group *
> @@ -295,6 +296,7 @@ check_pending(struct directio_context *ct, struct
> timespec endtime)
> =C2=A0	int r;
> =C2=A0	struct timespec currtime, timeout;
> =C2=A0
> +	ct->waited_for =3D true;

Not sure if it's important, but strictly speaking, we have only waited
for the checker if the endtime was in the future, which is often not
the case. Otherwise we'd just have polled.

Martin


> =C2=A0	while(1) {
> =C2=A0		get_monotonic_time(&currtime);
> =C2=A0		timespecsub(&endtime, &currtime, &timeout);
> @@ -346,6 +348,7 @@ check_state(int fd, struct directio_context *ct,
> int sync, int timeout_secs)
> =C2=A0		get_monotonic_time(&ct->endtime);
> =C2=A0		ct->endtime.tv_nsec +=3D 1000 * 1000;
> =C2=A0		normalize_timespec(&ct->endtime);
> +		ct->waited_for =3D false;
> =C2=A0	}
> =C2=A0	ct->running++;
> =C2=A0	if (!sync)
> @@ -386,6 +389,13 @@ static void set_msgid(struct checker *c, int
> state)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> +bool libcheck_need_wait(struct checker *c)
> +{
> +	struct directio_context *ct =3D (struct directio_context *)c-
> >context;
> +	return (ct && ct->running && ct->req->state =3D=3D PATH_PENDING
> &&
> +		!ct->waited_for);
> +}
> +
> =C2=A0int libcheck_pending(struct checker *c)
> =C2=A0{
> =C2=A0	int rc;
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index 81db565b..41d6b9c3 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -59,6 +59,7 @@ struct tur_checker_context {
> =C2=A0	struct checker_context ctx;
> =C2=A0	unsigned int nr_timeouts;
> =C2=A0	struct timespec endtime;
> +	bool waited_for;
> =C2=A0};
> =C2=A0
> =C2=A0int libcheck_init (struct checker * c)
> @@ -351,9 +352,17 @@ int check_pending(struct checker *c)
> =C2=A0		ct->thread =3D 0;
> =C2=A0	}
> =C2=A0
> +	ct->waited_for =3D true;
> =C2=A0	return tur_status;
> =C2=A0}
> =C2=A0
> +bool libcheck_need_wait(struct checker *c)
> +{
> +	struct tur_checker_context *ct =3D c->context;
> +	return (ct && ct->thread && uatomic_read(&ct->running) !=3D 0
> &&
> +		!ct->waited_for);
> +}
> +
> =C2=A0int libcheck_pending(struct checker *c)
> =C2=A0{
> =C2=A0	struct tur_checker_context *ct =3D c->context;
> @@ -463,6 +472,7 @@ int libcheck_check(struct checker * c)
> =C2=A0		pthread_mutex_unlock(&ct->lock);
> =C2=A0		ct->fd =3D c->fd;
> =C2=A0		ct->timeout =3D c->timeout;
> +		ct->waited_for =3D false;
> =C2=A0		uatomic_add(&ct->holders, 1);
> =C2=A0		uatomic_set(&ct->running, 1);
> =C2=A0		tur_set_async_timeout(c);

