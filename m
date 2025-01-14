Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB6320CCF5
	for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 21:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890818; cv=none; b=oxd86WjQ9vUXXj421Q4LFg00Dy6rTTVWqYP6WgwxRasQoQAkooNXxkHY/DGI5v5F28waEWRjgJDU5Ab3gMpUCy2SfZfYd/r/hTn+b/fCouR17NAqyhB+0yHUKoSoIs14sGbfMqJckQYWRDp1GD1kqOzePUcw4kkeubdYGG0A0xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890818; c=relaxed/simple;
	bh=NqglY6eIzKuSv1/VaeqWUR1b8/6Yf9Pk3xiRCA+VQCM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S0/2ylwzXw9bchIYH5Pe5WpjJPGB9g6c9jQWuqeD1P6B/0yMvxYfio6k3JZgA7ICiOvLiEpIA2fwgAJBfipPJcBLpuyjf5syEuXJ1vT6WE3OTgAAPgJcQVbtJc1ENvLrunPX7IBGpdGMm7nJZvosInCLH66aCzk3SPFK1sD26xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XTtWI+wB; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XTtWI+wB"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4361f664af5so68493185e9.1
        for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 13:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736890814; x=1737495614; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IgrZcDCWhdArDGL7+vmJnwtZ2QHbdODzunuil7Rb8jI=;
        b=XTtWI+wBJO4UW98tSUWLXDJPLWh7WCoCBG+837kVHdS04lSXhE7nh3JS4+GN7/1p+y
         uoLx2dxL15xroGsE3ICyGSisTKEd4m8eyjWtFQmy6bxWXsIdw2CEhTswsqXYPWVm6xQW
         looA9hCD05tpWsKh6MOQwiVOAklC+3l1BJpW8autQAPTGwlbrYe3Bq/MJdLAMLj+nWBm
         ugFf4x1tUMD7FONLTPOz4QHxRPAyBDICY2/DllvRdGw+AvQmrfvBKLQeeg+lE1uLZMJf
         Rg4QkC6DzJu71pskq5h4eclUdwjlAsdvToSPOVAape3M30iaTsNNG54Mn3wn/djZZKjo
         hGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736890814; x=1737495614;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IgrZcDCWhdArDGL7+vmJnwtZ2QHbdODzunuil7Rb8jI=;
        b=Lm1RaYnGQSrF6IykDgVGSrFlZUQ4Y1NYGeAQZq2ngIzP/oPID96x5BAIX+J8u3WV5l
         sxjSKxYvQIwYnwBs3huCpJ4QhG+25l0gwONfbv894aQzDLcNeWAsaJ3nzYBrEyYfgBoJ
         GYJdcwKWDm2lobKOre8doIm/BIn3l5Rz9m51KZid4HFaVBAOemSDxP9IiWCctwLa/L/L
         VEoiF01iYBvEL+L35uQE7WsGFiD8DsBlHiNrNMKOHgKinXzmnCtMJil7FI5qfGcoJ2DR
         FXiEEQgGUvRUvcltuCohy58YuYY5+ncBhk4LNuK2Ckv5Cb9O4YY75L7e2ZALtNJEbNNW
         0W7g==
X-Forwarded-Encrypted: i=1; AJvYcCUdSSFzOrjvP8E+CUSe21xBIr4TR8ZppYj8eXEN1OWFP4N5fVNKsbTIHxmogyzqDkt+ZB2uiYDixw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzT5P4kOJLkDOGOeiF3wN7PfI1N41I5B0vCK90khd8FKBvrPZsk
	5lHoIZ5O/QexBpKGGafWYQyGzkLwtYpRRJv7rKEOIbkdfOCwTaWy4KLVD3kqEUE=
X-Gm-Gg: ASbGncvanluhP8X2aZuWOw9SZyC6Q5gYAO6Ua3ngdmYLJ7Yi0VMtfGT7PjqPeZ8YXmS
	0rgJRLAR+rgf8Tb77ZukZ/UgLSCYeg0OqhCTbfcf3BYzPyDK1n6xF89mHweuoXF3oKKVIE8tUAq
	i6RQKIYgZ65KaNO6AjfPTgcmOMU0wUu09SpV1vx2gcmLOfJcvWBJ6zNU02ng/raQ3lnSEXfHn3+
	Z0eWZAq1/eyIFUS+hRnHCFLaFg1K6FdBaU1tL8mjS48UyWbpbMebcDOFqAMqMN72mdkojdERHPM
	yzhN6WpDA09wZSHsv5DIzLOE2lzoVKWCIQVgvyniBz52990eOUoA0dWrvJk0ewxN8iTHaZ+FEcx
	phpnE0Bp+za6V
X-Google-Smtp-Source: AGHT+IHxrh1UjxhAjFIvNzbiDk70QnqMod1XX1l2kiJwcNOjjM5BRsRpXVRvdjhdG14RMSYcq3UAMQ==
X-Received: by 2002:a05:6000:4617:b0:385:f220:f779 with SMTP id ffacd0b85a97d-38a873392e7mr22089315f8f.49.1736890814192;
        Tue, 14 Jan 2025 13:40:14 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a9362947dsm14316996f8f.40.2025.01.14.13.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 13:40:13 -0800 (PST)
Message-ID: <f99bc4d20e5135adf8599e6c8280451a236e9983.camel@suse.com>
Subject: Re: [PATCH v2 08/14] multipathd: don't call reload_and_sync_map()
 from deferred_failback_tick()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 14 Jan 2025 22:40:12 +0100
In-Reply-To: <Z2SYZtAkLuqK-h6x@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
	 <20241211225909.298770-9-mwilck@suse.com> <Z2SYZtAkLuqK-h6x@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-12-19 at 17:04 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 11, 2024 at 11:59:03PM +0100, Martin Wilck wrote:
> > Instead, move the call inside the existing loop over vecs->mpvec
> > and call
> > reload_and_sync_map() from checker_finished(). Note that we can't
> > simply
> > put the call deferred_failback_tick() in the "if" condition,
> > because we
> > need to adjust the ticks even if update_mpp_prio() returns true.
> > For
> > consistency, use separate bool variables for each condition that
> > would
> > necessitate a reload.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0multipathd/main.c | 39 ++++++++++++++-------------------------
> > =C2=A01 file changed, 14 insertions(+), 25 deletions(-)
> >=20
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index b045f8b..b1f0f81 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2076,32 +2076,20 @@ ghost_delay_tick(struct vectors *vecs)
> > =C2=A0	}
> > =C2=A0}
> > =C2=A0
> > -static void
> > -deferred_failback_tick (struct vectors *vecs)
> > +static bool deferred_failback_tick(struct multipath *mpp)
> > =C2=A0{
> > -	struct multipath * mpp;
> > -	int i;
> > =C2=A0	bool need_reload;
> > =C2=A0
> > -	vector_foreach_slot (vecs->mpvec, mpp, i) {
> > -		/*
> > -		 * deferred failback getting sooner
> > -		 */
> > -		if (mpp->pgfailback > 0 && mpp->failback_tick > 0)
> > {
> > -			mpp->failback_tick--;
> > +	if (mpp->pgfailback <=3D 0 || mpp->failback_tick <=3D 0)
> > +		return false;
> > =C2=A0
> > -			if (!mpp->failback_tick &&
> > -			=C2=A0=C2=A0=C2=A0 need_switch_pathgroup(mpp,
> > &need_reload)) {
> > -				if (need_reload) {
> > -					if
> > (reload_and_sync_map(mpp, vecs) =3D=3D 2) {
> > -						/* multipath
> > device removed */
> > -						i--;
> > -					}
> > -				} else
> > -					switch_pathgroup(mpp);
> > -			}
> > -		}
> > -	}
> > +	mpp->failback_tick--;
> > +	if (!mpp->failback_tick &&
> > +	=C2=A0=C2=A0=C2=A0 need_switch_pathgroup(mpp, &need_reload) &&
> > +	=C2=A0=C2=A0=C2=A0 need_reload)
> > +		return true;
> > +	else
>=20
> If (!mpp->failback_tick && need_switch_pathgroup(mpp, &need_reload)
> is
> true by need_reload isn't, don't we still need to call
> switch_pathgroup(mpp);

Ups. Good call, thanks!

Martin

