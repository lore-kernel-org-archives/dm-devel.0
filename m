Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E8F1E32B7
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728488980; cv=none; b=Sy+Y0oTb3sqdeQoKA69rpCdXAb4vp218L7nR7jg0G1CR1LRKl0k60tzqQAULfMhyrk4oHKdsxEcQ4fKeLlRHH7CVCnR7c37XRvrwJ+UcPK+rn8QDpXjDjZ2mFmQWxiMCeGTrEPeW4N433dp+9AU8WiA95B4Re6Pf6nDeRL3KCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728488980; c=relaxed/simple;
	bh=UKSA8H/15Krp30AD4AbbGNyefo6fHnG9O5LnxIBdZHs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UUu9gOQGqKLGlwWa8DWNY4XgOhJNnougw6/er7qtlMhaqjlEH+6T7UbcINOCaOGMnG/wIctZdFmJsdhJn/c+swwnAA72gXHkKLFUzU98LDLTFV/yl4cVH+l3AI1tTQlrVThVhEni8e8WrhwE03Q7pM7NClIDrrpTEJaKDkuFfQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VuG4HDWZ; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VuG4HDWZ"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9952ea05c5so533477766b.2
        for <dm-devel@lists.linux.dev>; Wed, 09 Oct 2024 08:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728488975; x=1729093775; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J0Je9/p8Ioy26QaqmKcQMIageXx7hZHrLaqugzEgw90=;
        b=VuG4HDWZgasxxj4lR0oFumxzd5MXBbeV1a3s5xWWJLC7KRORf+pA2UWBcALgqwYvkT
         9XCMSPf0Yjz/xEQWKEBFCkNnLU6I9gr/nDH/poghPokuVrFhLxSOwtpkWF/XQADSY0kD
         aFV9LGt0g+GgJgl2M4I6mSDSIR6g62Ss6t3IAYqp45nSiAPTXyjfoCTmhoGGYa2Pw5iV
         IliQVkhTqxxXiuT8Lut208JJaWNjjwCavP8ejNC5BB7EFKr+wv/RFCiEv52fujWjKS+d
         XAhqcq6v+ohe858r0FlYCu7yD/06+1f6MqnxVy/WHGJqUoUOYZAJsMbc6pavv1bKqESZ
         fevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728488975; x=1729093775;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J0Je9/p8Ioy26QaqmKcQMIageXx7hZHrLaqugzEgw90=;
        b=DtU0YJAZymaoFPXqE/l9ApXuWYNMSo00T90QktGOFCJudQf16Rz00dCEVnlSICtLdz
         y1WEaocK5knS2g8tUlGJ8L9XAI7yC0ANuGAeQbNysqM0Xw5bbNsLBKKsvm55E07mUz0Z
         XtaRfTz5T4vGOZq8HNPxJtXV8YjtoXGp0jaCfnLsrQx9MsgNnGwep5fyKyeUhhrHuCVu
         Y48ZpWaKZuF2QW13jn/U/Cb39E4jjHO//J6mv/dYrQtxS7xlNnPkGt6iZQ5EbvQlGGqz
         LCQ5wOobb6AbWvlP9EEvK8dIY6W9/t5tZC43pYiVscMqmU4gIbgCZYDeOfgk9tY9W6cB
         SKCw==
X-Forwarded-Encrypted: i=1; AJvYcCWUoJEr4bIMkgJBygl0+/sCvm7EADYW12OyWy7sAJtONes5E+3oyAiPWH0dPalIUD5sbvnk5/laOQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzyQssSO7v11JMdC+Y+LGD64thFQXfT9srOF4HeHms8cDRHmzGO
	R6aAF9oeuX/ChKlMV5j8NvxzmJ0+YVIR79tKVrOVi+F1FKsDNyybYSygwb3bPgQ=
X-Google-Smtp-Source: AGHT+IFF+TjY/k0+knwINppHHtT4dxXtlh645QVe49Zs/2vVZoueX5BxwcosR/cIGSPsyATxklJ2gA==
X-Received: by 2002:a17:906:d7e9:b0:a99:d52:4518 with SMTP id a640c23a62f3a-a998d19eb4fmr277727566b.21.1728488974383;
        Wed, 09 Oct 2024 08:49:34 -0700 (PDT)
Received: from ?IPv6:2003:de:3707:9400:b9ee:e7ce:aa91:658e? (p200300de37079400b9eee7ceaa91658e.dip0.t-ipconnect.de. [2003:de:3707:9400:b9ee:e7ce:aa91:658e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99527e8e15sm450738266b.181.2024.10.09.08.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 08:49:34 -0700 (PDT)
Message-ID: <8d27a1e4823d7382a19d1914c0b28b6feb94353e.camel@suse.com>
Subject: Re: [PATCH v2 19/22] libmultipath: add libcheck_need_wait checker
 function
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 09 Oct 2024 17:49:33 +0200
In-Reply-To: <ZwWJBhwOnrUmtEa_@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
	 <20240912214947.783819-20-bmarzins@redhat.com>
	 <e46270826de9a255d6e16bcae56e984dfde346ac.camel@suse.com>
	 <ZwWJBhwOnrUmtEa_@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-10-08 at 15:33 -0400, Benjamin Marzinski wrote:
> On Thu, Oct 03, 2024 at 11:15:21PM +0200, Martin Wilck wrote:
> > On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> > > Add a new optional checker class function, libcheck_need_wait()
> > > and a
> > > new function to call it, checker_need_wait(). This can be used to
> > > see
> > > if
> > > a path_checker is currently running. This will be used to
> > > determine
> > > if
> > > there are pending checkers that need to be waited for.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 12 +++++++++++-
> > > =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 4 +++-
> > > =C2=A0libmultipath/checkers/directio.c | 10 ++++++++++
> > > =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 =
++++++++++
> > > =C2=A04 files changed, 34 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > > index f3e98352..e2eda58d 100644
> > > --- a/libmultipath/checkers.c
> > > +++ b/libmultipath/checkers.c
> > > @@ -27,6 +27,7 @@ struct checker_class {
> > > =C2=A0	void (*reset)(void);		=C2=A0=C2=A0=C2=A0=C2=A0 /* to reset the
> > > global
> > > variables */
> > > =C2=A0	void *(*thread)(void *);	=C2=A0=C2=A0=C2=A0=C2=A0 /* async thr=
ead
> > > entry
> > > point */
> > > =C2=A0	int (*pending)(struct checker *);=C2=A0=C2=A0=C2=A0 /* to rech=
eck
> > > pending
> > > paths */
> > > +	bool (*need_wait)(struct checker *); /* checker needs
> > > waiting for */
> > > =C2=A0	const char **msgtable;
> > > =C2=A0	short msgtable_size;
> > > =C2=A0};
> > > @@ -182,7 +183,8 @@ static struct checker_class
> > > *add_checker_class(const char *name)
> > > =C2=A0	c->reset =3D (void (*)(void)) dlsym(c->handle,
> > > "libcheck_reset");
> > > =C2=A0	c->thread =3D (void *(*)(void*)) dlsym(c->handle,
> > > "libcheck_thread");
> > > =C2=A0	c->pending =3D (int (*)(struct checker *)) dlsym(c-
> > > >handle,
> > > "libcheck_pending");
> > > -	/* These 4 functions can be NULL. call dlerror() to
> > > clear
> > > out any
> > > +	c->need_wait =3D (bool (*)(struct checker *)) dlsym(c-
> > > >handle,
> > > "libcheck_need_wait");
> > > +	/* These 5 functions can be NULL. call dlerror() to
> > > clear
> > > out any
> > > =C2=A0	 * error string */
> > > =C2=A0	dlerror();
> > > =C2=A0
> > > @@ -313,6 +315,14 @@ int checker_get_state(struct checker *c)
> > > =C2=A0	return c->path_state;
> > > =C2=A0}
> > > =C2=A0
> > > +bool checker_need_wait(struct checker *c)
> > > +{
> > > +	if (!c || !c->cls || c->path_state !=3D PATH_PENDING ||
> > > +	=C2=A0=C2=A0=C2=A0 !c->cls->need_wait)
> > > +		return false;
> > > +	return c->cls->need_wait(c);
> > > +}
> > > +
> > > =C2=A0void checker_check (struct checker * c, int path_state)
> > > =C2=A0{
> > > =C2=A0	if (!c)
> > > diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> > > index b2342a1b..da91f499 100644
> > > --- a/libmultipath/checkers.h
> > > +++ b/libmultipath/checkers.h
> > > @@ -2,6 +2,7 @@
> > > =C2=A0#define CHECKERS_H_INCLUDED
> > > =C2=A0
> > > =C2=A0#include <pthread.h>
> > > +#include <stdbool.h>
> > > =C2=A0#include "list.h"
> > > =C2=A0#include "defaults.h"
> > > =C2=A0
> > > @@ -171,6 +172,7 @@ struct checker_context {
> > > =C2=A0int start_checker_thread (pthread_t *thread, const
> > > pthread_attr_t
> > > *attr,
> > > =C2=A0			=C2=A0 struct checker_context *ctx);
> > > =C2=A0int checker_get_state(struct checker *c);
> > > +bool checker_need_wait(struct checker *c);
> > > =C2=A0void checker_check (struct checker *, int);
> > > =C2=A0int checker_is_sync(const struct checker *);
> > > =C2=A0const char *checker_name (const struct checker *);
> > > @@ -191,7 +193,7 @@ void *libcheck_thread(struct checker_context
> > > *ctx);
> > > =C2=A0void libcheck_reset(void);
> > > =C2=A0int libcheck_mp_init(struct checker *);
> > > =C2=A0int libcheck_pending(struct checker *c);
> > > -
> > > +bool libcheck_need_wait(struct checker *c);
> > > =C2=A0
> > > =C2=A0/*
> > > =C2=A0 * msgid =3D> message map.
> > > diff --git a/libmultipath/checkers/directio.c
> > > b/libmultipath/checkers/directio.c
> > > index 904e3071..4beed02e 100644
> > > --- a/libmultipath/checkers/directio.c
> > > +++ b/libmultipath/checkers/directio.c
> > > @@ -65,6 +65,7 @@ struct directio_context {
> > > =C2=A0	struct aio_group *aio_grp;
> > > =C2=A0	struct async_req *req;
> > > =C2=A0	struct timespec endtime;
> > > +	bool waited_for;
> > > =C2=A0};
> > > =C2=A0
> > > =C2=A0static struct aio_group *
> > > @@ -295,6 +296,7 @@ check_pending(struct directio_context *ct,
> > > struct
> > > timespec endtime)
> > > =C2=A0	int r;
> > > =C2=A0	struct timespec currtime, timeout;
> > > =C2=A0
> > > +	ct->waited_for =3D true;
> >=20
> > Not sure if it's important, but strictly speaking, we have only
> > waited
> > for the checker if the endtime was in the future, which is often
> > not
> > the case. Otherwise we'd just have polled.
>=20
> But we always set the endtime in the future when we're starting a new
> request, so the first time the we call check_pending() we don't
> return
> till we either get an answer or endtime has passed, which is what we
> want waited_for to check (that we've give the checker till endtime to
> respond).

That holds for this patch. But right in the next patch, the code is
changed such that libcheck_pending doesn't actually wait at all. So
"ct->waited_for" is a really confusing name. It just means that we have
polled for the state once. In theory that can happen very quickly after
starting the checker.

Regards
Martin

