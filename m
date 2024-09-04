Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3AA1E0B7F
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725479320; cv=none; b=jdS7N99wdwTyYAO9XNRHbKOIqb0wHKuF3Ief8A7x7NUBnlq8ujMa9RHjAJU8S+LnzQsyFPrICj9VmWXRM1j4SB30fhq1+M84AULZWq23cUrxk4qREW/p07iUbh7EsRFf4SDFvQQRG4DFsVrSRqtvVYVUR/uSKazwa4a33K7SELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725479320; c=relaxed/simple;
	bh=8DPca9uVSYjVbHt0H820T/XtT6GPimkDKEAGNggOF/c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AWhgWT98VM8wIzF9mp5varCOVgT1Pb7VxKhH2qiVC5zvmS8RjA1MiNN6AJK+pmE+G6pX8pW4qArJqeLusjxIjr7DAQhkSPE/FEoBXv4MzOF6bQ8q1SDWV+Y8A1kLtowENFXfKGVHQJOC/h2hO4hTDDtY4ciL2HglGcA0cx0mSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EBkxa6Z2; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EBkxa6Z2"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f4f24263acso263131fa.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 12:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725479316; x=1726084116; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DWpdPYuqeWJetydlonqSZGRl6Wd1+PBXvDMeTDAvLms=;
        b=EBkxa6Z2qnHSUtEUvZSjbF0wDi3vyuGHemeMxZ7fnYFDnpew9VR1Xta8s9GR4lrvLx
         MX6ft52v/EiwiLEcvL1YDCKzYtBrV+ZKEe+lfDdVm10CcphVpXJdjf2iGglFH8nSsWgX
         0tJd4qDpjYF82vJ4F9InsWvtcE8x4opUIzDn4VRm4lZ6sgldW2RIrghdCG1NOWee30BG
         nhwLmqGcZmrLq2xOucb1ZCAkkLS2i0tMPeKmo5HKmP/T4RYCTk5TZOzTk7ij+zxiE9zD
         /5JzZoyyDsMu4zz0IsptE8HKlXuKCrVe4QeK/O5gYBrqThtgPG6wwBZ2X1vBJzarcCUF
         WvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725479316; x=1726084116;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DWpdPYuqeWJetydlonqSZGRl6Wd1+PBXvDMeTDAvLms=;
        b=j5Rq8BEHzk9o9c+pxg0v2053p1LnaJcUG71aH9Lne1xgxKdqdxPwIDtwsDOKa+Xr7A
         IO11/b/w52DGf+S1GVh6nCQt26d98+TFgZf9F08NZLZqcpeXbj0gjfPKGHIYcsXMbOAJ
         5qFCbEIkLmYscYcinAAt/GgOPtnFF2wa+xxBZdlgsV6zt5HTGPX6hd4qAd3AFw+mrihv
         dGjTjHTrs+1TMQ1p9b9i9GC1AfdnrCCyxVxRWmRPtVmfZnbEtRjYs4h7q6WccgSQwO81
         oBCpnMicW84+Z/eSQ1suvp6Fijl87JuA7F9Z0SW7JUm6ITEWMklgIDCEwLdtlM8gB2J/
         xj6A==
X-Forwarded-Encrypted: i=1; AJvYcCVigPgk0EzUon/6LTdjQ8cJtDVu9iUDmFHPN8mCcNDo2hi0M+X0x04EnZeUwjxA7EeidyEH73VO3A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzgARh3VMSG2Kysq0iNyMZmfDE6onTQtNFzAOAlrmuHWxWnnxyo
	3ddhz7kr4yJ4y0HzDg0zlaFVhG8WL8XWLkW5i/wQt1kZyjxxjN68CJ25YXQ4xDA=
X-Google-Smtp-Source: AGHT+IG3EP0X6Xbfvp/1icuirIzSrmHYggAtc/h1wROV0R82jJuqRA22j+UPkf9H+G72X1rD7lqWoQ==
X-Received: by 2002:a05:651c:19ac:b0:2ef:1b1b:7f42 with SMTP id 38308e7fff4ca-2f610893553mr210965331fa.36.1725479315317;
        Wed, 04 Sep 2024 12:48:35 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a6204758esm30362066b.82.2024.09.04.12.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 12:48:35 -0700 (PDT)
Message-ID: <d0c3e9f100217a184efdc6ce502a70019e8f41ff.camel@suse.com>
Subject: Re: [PATCH 03/15] libmultipath: split out the code to wait for
 pending checkers
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 21:48:33 +0200
In-Reply-To: <Ztij5HLMXmw1apYh@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-4-bmarzins@redhat.com>
	 <43945011477a7fb65c6bd267c8302d91961d4c59.camel@suse.com>
	 <Ztij5HLMXmw1apYh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-09-04 at 14:16 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 04, 2024 at 05:01:39PM +0200, Martin Wilck wrote:
> > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
>=20
> <snip>
>=20
> > > diff --git a/libmultipath/checkers/tur.c
> > > b/libmultipath/checkers/tur.c
> > > index a2905af5..95af5214 100644
> > > --- a/libmultipath/checkers/tur.c
> > > +++ b/libmultipath/checkers/tur.c
> > > @@ -323,6 +323,49 @@ static int tur_check_async_timeout(struct
> > > checker *c)
> > > =C2=A0	return (now.tv_sec > ct->time);
> > > =C2=A0}
> > > =C2=A0
> > > +int check_pending(struct checker *c, struct timespec endtime)
> > > +{
> > > +	struct tur_checker_context *ct =3D c->context;
> > > +	int r, tur_status =3D PATH_PENDING;
> > > +
> > > +	pthread_mutex_lock(&ct->lock);
> > > +
> > > +	for (r =3D 0;
> > > +	=C2=A0=C2=A0=C2=A0=C2=A0 r =3D=3D 0 && ct->state =3D=3D PATH_PENDIN=
G &&
> > > +	=C2=A0=C2=A0=C2=A0=C2=A0 ct->msgid =3D=3D MSG_TUR_RUNNING;
> > > +	=C2=A0=C2=A0=C2=A0=C2=A0 r =3D pthread_cond_timedwait(&ct->active, =
&ct->lock,
> > > &endtime));
> > > +
> > > +	if (!r) {
> > > +		tur_status =3D ct->state;
> > > +		c->msgid =3D ct->msgid;
> > > +	}
> > > +	pthread_mutex_unlock(&ct->lock);
> > > +	if (tur_status =3D=3D PATH_PENDING && c->msgid =3D=3D
> > > MSG_TUR_RUNNING) {
> > > +		condlog(4, "%d:%d : tur checker still running",
> > > +			major(ct->devt), minor(ct->devt));
> > > +	} else {
> > > +		int running =3D uatomic_xchg(&ct->running, 0);
> > > +		if (running)
> > > +			pthread_cancel(ct->thread);
> > > +		ct->thread =3D 0;
> > > +	}
> > > +
> > > +	return tur_status;
> > > +}
> > > +
> > > +int libcheck_pending(struct checker *c)
> > > +{
> > > +	struct timespec endtime;
> > > +	struct tur_checker_context *ct =3D c->context;
> > > +
> > > +	/* The if path checker isn't running, just return the
> > > exiting value. */
> > > +	if (!ct || !ct->thread)
> > > +		return c->path_state;
> > > +
> > > +	get_monotonic_time(&endtime);
> > > +	return check_pending(c, endtime);
> >=20
> > Does this work?=C2=A0
> >=20
> > https://pubs.opengroup.org/onlinepubs/009695299/functions/pthread_cond_=
timedwait.html
> > says that "an error is returned [...] if the absolute time
> > specified by
> > abstime has already been passed at the time of the call".
> >=20
> > Which would always be the case if you pass a timestamp that you=20
> > fetched previously unmodified, meaning that you'd always get
> > ETIMEDOUT.
> > Or am I misreading the docs?
>=20
> No. You are reading the docs right.=C2=A0 I'm just don't understand why
> that's a problem.=C2=A0 When you start the checker, you set a timeout tha=
t
> you want to wait for, to give the checker a chance to complete in
> this
> checker loop.=C2=A0
>=20
> Once that timeout has passed, if the thread is still
> running, then libcheck_pending should return PATH_PENDING.
> pthread_cond_timedwait() doesn't get called unless the thread is
> running. So I would argue that pthread_cond_timedwait() always
> failing
> once that timeout has passed is the correct thing to do.
>=20
> Or are you arguing for having check_pending() manually check if the
> timeout has passed, and skipping the call to pthread_cond_timedwait()
> in
> that case?=20

I was confused by the missing patch 04/15. So let me read that one and
come back to you.

Martin



