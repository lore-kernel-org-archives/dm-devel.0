Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554CF348866
	for <dm-devel@lists.linux.dev>; Sun, 17 May 2026 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779011857; cv=none; b=EHYtutOZKJdgKu1ela23/BzFCCSvvGmMQJGFtmWD63Oioqky5z4TgjY8GkoinadyHB//IqIQ2PdnTwxWKPP5HCh/IARiYoKETx2V9e82aVMmEu6aCx7881bcGMKqCdenSP1lQ15zbOAKYSiTl/Q0ZPHg1/ligdv/vqBCuDi1z0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779011857; c=relaxed/simple;
	bh=QrLEntlR9eCJgKpfnOERLDwvgQnIcENE2UtUNxnc9eM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J4YaJSfWW85LXSA4duVbN2KhS/5six84bnzbUCsbb8JK3/9ubMn8tSxiG4xPxoJFZUKc/15r5Co7KjoDQhrEI98+lWXUbL9+B/K7R1Pi5Ga+z7BknomeRDVUk9YJplxQKlDkdK51lFzK70o2xqZQNMxKPnQUeouJFi0EZ4CAqZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T/M8byQG; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T/M8byQG"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4585a116a4aso972981f8f.3
        for <dm-devel@lists.linux.dev>; Sun, 17 May 2026 02:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779011854; x=1779616654; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Sl1Bw/0RxsOrZnosvkgEqpf9C8mJ0ZVAuZnVOQypWcg=;
        b=T/M8byQGhpXo7EA4lPRPGBTyMYR8h1vsLJa/bI6IKYvQos4GuRiM8ov5QApK+qooFD
         aGVzA24qm+jipGDoUJeiPhNbPsnlDc76yc7ZuSirB6Ty57blLZPdIytDxzOV/efLt4KP
         GAFJyjyZTGjneeEhypEQWtkouT17WIWWtmKhFf81ENysNDNIJKhPlddfe5T4Va/PFuo+
         h7t4JtnFGV+tGcnKEaytx3QX/vorUzWkIgecTOEclPxFbdaTjUygVbcfqYYO9j2XrSMM
         t7848BS3hx5+3qC1R6mTuZhO86NI8xbFt1sn8tWI7rOG/9PQer0mBjxVrnireRXLp5j9
         aCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779011854; x=1779616654;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sl1Bw/0RxsOrZnosvkgEqpf9C8mJ0ZVAuZnVOQypWcg=;
        b=iK+3EB3IUXy01WD95+hRvjOwZ3k7i6F11Ww3/FioN+bN7KV3BjWrJZI/RZfL9VZQUg
         ZLG5l1cg/MP+WC4UnAPu2tY1GyoRCYIATf9XFDEECy7611Brd1pgrVPM0flQZ500jaup
         ani4ADmFHs9LoFiuhcuUIWKKb08ZAgCcgJMSrW+0RtYe2HxWRJsKMCruFNYhl6Sevg9L
         adsiz93J/f2C0U1TfrBkzHmELVfoWtnvUI66fhO8YoK6HBJGl2HoHhpzRSPVhlRpUAp5
         NWBSCWnr3YyXugVDT++/S68GY4nP2IY4i7a2gqo7e+jHo59l2eyeJyCUGwL7f+9kHEx7
         6i7A==
X-Forwarded-Encrypted: i=1; AFNElJ893s8R7HmOyqQZiFxRDuKat1KCtWzoowEjzS8mxp25U8ZLEY5M3bQbi8tE2cKvhWaY/j2p4FcmYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWz+46sTTyYNRrIJpFrROrRP3Tj1+E7r8g+l4spvWFgAJhfqXL
	ltOib8Xo4SghcO5eZq41AhYr/KzpURORD48fhpPBsvssxwjrXhKDTjj+Ps44MUa8iHo=
X-Gm-Gg: Acq92OHCXEBspHiaGhCzTE1SEOuDIMJvG57qSgL1dNP8Di0zgmeMf2TrTHuaBTkEOgJ
	z5EaSL2N2zwHdnoe8ZmdnOoUVniao1tP7IzGHhFvRm+lVJMHUUFmsmIlrRl7fXOof+acVm/OImU
	tniYxskTduzgjGFb3GBHa0qa1W8Pk9R8jGID9mppl/bSw6FTNUDVMlMVnebyYsRm7V1WYN54Qfu
	G3NATmGY9RYHKPy8Gm6lRux4kDy6AcgrmFRIAOA7J+CxFe+bguuq4c7dKwLjY8R/wbSDvPiKZ8+
	Xm9bBdcys+MR4A2edxn6o0Fr7PQv64CRtqVkz+JF5VQ60AtkB4ZlWjzmLs/ZpUwnPDSVR9zTx2j
	ckekp8FM1qQHRaqxkS2FVMVor5q5vGgHDi7yFQwBZvGupEaxnBkPuoULLB3YfVErX5ksKKIHDvr
	G6rbw2qcIBFVNUPZuvT+411v2J/pPGO5ItPb9uJac5mKYpffrJbmQWXmdunEBc7eI7EAMlbQ==
X-Received: by 2002:a5d:584c:0:b0:44b:7ec9:2d76 with SMTP id ffacd0b85a97d-45e5c57d400mr15640757f8f.7.1779011853540;
        Sun, 17 May 2026 02:57:33 -0700 (PDT)
Received: from [172.18.125.123] (ip-185-104-138-119.ptr.icomera.net. [185.104.138.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768bcesm30290208f8f.4.2026.05.17.02.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 02:57:33 -0700 (PDT)
Message-ID: <41f748a2979937ca6d7e8016d06de9ddc4c4d129.camel@suse.com>
Subject: Re: [PATCH 06/18] libmultipath: use shared_ptr for checker classes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Brian Bunker
	 <brian@purestorage.com>, dm-devel@lists.linux.dev, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Date: Sun, 17 May 2026 11:57:25 +0200
In-Reply-To: <agPKtqVRFSIsxerR@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
	 <20260505154332.448054-7-mwilck@suse.com> <agPKtqVRFSIsxerR@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-05-12 at 20:49 -0400, Benjamin Marzinski wrote:
> On Tue, May 05, 2026 at 05:43:20PM +0200, Martin Wilck wrote:
> > Utilize the share_ptr code for tracking the refcount of checker
> > classes.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/checkers.c | 98 +++++++++---------------------------=
-
> > ----
> > =C2=A0libmultipath/checkers.h |=C2=A0 2 -
> > =C2=A02 files changed, 20 insertions(+), 80 deletions(-)
> >=20
> > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > index 8f18ca6..a3b9cc8 100644
> > --- a/libmultipath/checkers.c
> > +++ b/libmultipath/checkers.c
> [...]
> > @@ -163,8 +143,7 @@ static struct checker_class
> > *add_checker_class(const char *name)
> > =C2=A0		goto out;
> > =C2=A0
> > =C2=A0	c->mp_init =3D (int (*)(struct checker *)) dlsym(c->handle,
> > "libcheck_mp_init");
> > -	c->reset =3D (void (*)(void)) dlsym(c->handle,
> > "libcheck_reset");
> > -	c->thread =3D (void *(*)(void*)) dlsym(c->handle,
> > "libcheck_thread");
> > +	c->reset =3D (void (*)(void))dlsym(c->handle,
> > "libcheck_reset");
>=20
> Nitpick. Dropped a space here.

I didn't do that. clang-format did, as it also reformats context lines
in patches. I think clang-format is correct. We usually don't use space
after cast, do we? (As usual, our code base is inconsistent in this
respect).

While I don't want to enforce formatting style throughout the entire
code base, I tend to keep the changes that clang-format applies to
context lines (be it only to avoid red lights from the GitHub CI).

Do you disagree with this policy?

Regards
Martin

>=20
> > =C2=A0	c->pending =3D (int (*)(struct checker *)) dlsym(c->handle,
> > "libcheck_pending");
> > =C2=A0	c->need_wait =3D (bool (*)(struct checker *)) dlsym(c-
> > >handle, "libcheck_need_wait");
> > =C2=A0	/* These 5 functions can be NULL. call dlerror() to clear
> > out any
> [...]
> > @@ -371,43 +350,6 @@ bad_id:
> > =C2=A0	return generic_msg[CHECKER_MSGID_NONE];
> > =C2=A0}
>=20
> Removing the checker thread stuff is more of a cleanup from d1ebd977.
> It
> should probably either be it's own cleanup patch, or it should at
> least
> get mentioned in the commit message.
> =C2=A0=20
> > -static void checker_cleanup_thread(void *arg)
> > -{
> > -	struct checker_class *cls =3D arg;
> > -
> > -	free_checker_class(cls);
> > -	rcu_unregister_thread();
> > -}
> > -
> > -static void *checker_thread_entry(void *arg)
> > -{
> > -	struct checker_context *ctx =3D arg;
> > -	void *rv;
> > -
> > -	rcu_register_thread();
> > -	pthread_cleanup_push(checker_cleanup_thread, ctx->cls);
> > -	rv =3D ctx->cls->thread(ctx);
> > -	pthread_cleanup_pop(1);
> > -	return rv;
> > -}
> > -
>=20
> Also, start_checker_thread() is stil declared in
> libmultipath/checkers.h,
> along with a comment.
>=20
> -Ben
>=20
> > -int start_checker_thread(pthread_t *thread, const pthread_attr_t
> > *attr,
> > -			 struct checker_context *ctx)
> > -{
> > -	int rv;
> > -
> > -	assert(ctx && ctx->cls && ctx->cls->thread);
> > -	/* Take a ref here, lest the class be freed before the
> > thread starts */
> > -	(void)checker_class_ref(ctx->cls);
> > -	rv =3D pthread_create(thread, attr, checker_thread_entry,
> > ctx);
> > -	if (rv !=3D 0) {
> > -		condlog(1, "failed to start checker thread for %s:
> > %m",
> > -			ctx->cls->name);
> > -		checker_class_unref(ctx->cls);
> > -	}
> > -	return rv;
> > -}
> > -
> > =C2=A0void checker_clear_message (struct checker *c)
> > =C2=A0{
> > =C2=A0	if (!c)
