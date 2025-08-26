Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FCF1E1E1C
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 20:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756241628; cv=none; b=gerrAkPA6L+9nKaLeP9vB+sgXwF7DZ2BkmshxCH2w8pfVfm34w/JzFXIIjGBBbZIPePyyX5fpbV09ypfO/O603HxugVg+VEX3smd+OJJxLQX5O/pdXUfcpnA/MjTld7LkgYyGecVsbEbJo3JqczvDb/9NPpkadHRn7nT31yKMDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756241628; c=relaxed/simple;
	bh=SSqySvljAi/QdGSUxxLurLvH/tZBhY6Oe6cTFpTKSVE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rlmf3JvmiRGVnllAsAh0gDMaM8UISohG2JFlSckHYrHI39nw+20XOkYsYMC8ZvuJmQcF9GyeeJwHOTIHy309ecs9NDpMpN94bNxN+y63BGxRI8NxjvzrFoJ485Y+p77SS82HT7MW//x2BWBFBz+gRfIjulqZxhGbk2LfV03bmLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WVetOL2h; arc=none smtp.client-ip=209.85.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WVetOL2h"
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-61c3b84df28so5336315a12.1
        for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 13:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756241624; x=1756846424; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3L2GO/bjUrF6eqoA4suQzHzHhm6OwTn2QJ34AlYre+k=;
        b=WVetOL2hkuZ0fDcU7Rh/AZxVliqJER2ec1eAvztANy0TEnTuVAD/svV5NpAo3PRqQu
         +hxvF5wiQ3HvqGVm2lDh93PVsfsgeheUYgNn0N6Sk5SZjdHhuaXbre804TzdFUNsfnxp
         AW2w8PJZ2v7azGnjWSWS/cysQFlzgVU0gyqSzhu9X9AE7nLnPeLG278nDPZkMLO47xBC
         NLfiOp1v+JeEh7SOA6oqvaHZINs6ZsLOKv+dv5ZSHRt61hcQWnqeN9dJ45GsrEOP+0Tt
         t6ag5lkfaWObwXPv+MUZW8uQ7R+y5Dt5DbasJjBD+v7jXrbF5qGSG3fpjiotYH3PGeAk
         6TZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241624; x=1756846424;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3L2GO/bjUrF6eqoA4suQzHzHhm6OwTn2QJ34AlYre+k=;
        b=W5SwpLtLjt37rS5ny+hC90szglq50o+gPr6R6rXU3tO2zIf08j7IheSxzJ0zX+aeg2
         NzmLOuJ5uKbOqe8m0+1Tfig5MBslIAKHRBendjAuXDXXEMGfO86LgvO32AXngwwM1eGq
         0tJ7/6eOFWuJS1Lu12/tbWa3os7uUdQ0fOKZ30pSVknv2FypjjOfdVDTA8aZC4Scbovf
         3SchVWFCQVYd2N/4fmW72C0CH6/W2nmclLyPpm4u5poer/plIvU/W5A9q3j04Ki9T30W
         AyoocafpKJ+BeJVpFo3oi+uaWhn5GsSnimvnjx7YKweItB01909ug/PoGDDeT7yp1+bQ
         aVew==
X-Forwarded-Encrypted: i=1; AJvYcCUQRwomgaIx8b3iib7NTxTpNfdVpW9BDux/sfBLygJFjGJozzlQd0VvGhHHDYtOHNJKSYDi2kxhzg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzDsf6cGRHV6+J28OuuEl74e/Ykj+tJl4kIUEls9X+wiDoKLJji
	qeiyM1qkCAVjx9HajGVEhPgMKAqoOwZYc5/rdLmvRKqT0xD2OFZSsPRS38f2qdvaods/OqEVXHs
	JGf5uUyMrZA==
X-Gm-Gg: ASbGncvXEKkw0a5KFgDtzp0XEy30/F/wxqPiJq37PP7z8S9UTVx3NIhdFLcGoIP0inu
	EATPTkBlS0kvrb61A22isd4Vc9ry2m+Q/1xOr1Z1GAprPtGQS3wClJ6sxtUPvPnHQljLuvRUMAB
	+6QOXDEw/djfXVKUhmUu1LIx0NuvWfoS1SDKJkyf32RCpKHf2Uh9Xh1idwO9OHvDS3McLsR2YaJ
	cLhJlv7aDESiQs/CBqMscFEdYPXoWksFqW2JRkQjR29jHe35qdWQhS5YVYErsEoUv5egl0l7Hr8
	G9HBbKYReAsDhMezXlhu8KFoLMooJOTUCBvC3NjhiMh4KsfJBVNhIzYUem2UWy5NJ21STZnOjmn
	T2mWq1knc+C4YY/gXMqKxT4R3nVvkUnYyKr+WqkGHn9Y8/pfsBtFX2HZ8sn9/J6mUFjX8kFtZO7
	mkU99D9w80A4zZ7jJb2GWa5Xir5UeYY+3DwUZKWenMwCIomO7vn7nwRgQ7Vq/4cu0uhw==
X-Google-Smtp-Source: AGHT+IHe0Y0u0+hutcVuKu7exAyvZ3Yjy06DglJu0CdBt+Kq/PFuOQ088+V9b0u6pQk9HSbQCl0sQQ==
X-Received: by 2002:a05:6402:2110:b0:61c:5b95:c8bd with SMTP id 4fb4d7f45d1cf-61c5b95c9f1mr8551691a12.35.1756241624381;
        Tue, 26 Aug 2025 13:53:44 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c316f4f45sm7566033a12.36.2025.08.26.13.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:53:44 -0700 (PDT)
Message-ID: <3768ef4f4be10174b710173d1e27c14f0f143ec1.camel@suse.com>
Subject: Re: [PATCH 09/15] limpathpersist: redesign failed release workaround
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 26 Aug 2025 22:53:43 +0200
In-Reply-To: <aK4MsHaPBxu_JIxu@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-10-bmarzins@redhat.com>
	 <dc941be94accce6ed554eac92f833cbb8e69263b.camel@suse.com>
	 <aK0FIY7cVE_LxNMg@redhat.com>
	 <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
	 <aK4MsHaPBxu_JIxu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-08-26 at 15:36 -0400, Benjamin Marzinski wrote:
> On Tue, Aug 26, 2025 at 10:44:22AM +0200, Martin Wilck wrote:
> > On Mon, 2025-08-25 at 20:51 -0400, Benjamin Marzinski wrote:
> > > On Sun, Aug 24, 2025 at 05:26:50PM +0200, Martin Wilck wrote:
> > >=20
> > > >=20
> > > > > +	/*
> > > > > +	 * Cannot free the reservation because the path that
> > > > > is
> > > > > holding it
> > > > > +	 * is not usable. Workaround this by:
> > > > > +	 * 1. Suspending the device
> > > > > +	 * 2. Preempting the reservation to move it to a
> > > > > usable
> > > > > path
> > > > > +	 *=C2=A0=C2=A0=C2=A0 (this removes the registered keys on all p=
aths
> > > > > except
> > > > > the
> > > > > +	 *=C2=A0=C2=A0=C2=A0 preempting one. Since the device is suspen=
ded,
> > > > > no
> > > > > IO
> > > > > can
> > > > > +	 *=C2=A0=C2=A0=C2=A0 go to these unregistered paths and fail).
> > > > > +	 * 3. Releasing the reservation on the path that now
> > > > > holds
> > > > > it.
> > > > > +	 * 4. Resuming the device (since it no longer
> > > > > matters
> > > > > that
> > > > > most of
> > > > > +	 *=C2=A0=C2=A0=C2=A0 that paths no longer have a registered key=
)
> > > > > +	 * 5. Reregistering keys on all the paths
> > > > > +	 */
> > > > > +
> > > > > +	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp-
> > > > > >alias,
> > > > > 0))
> > > > > {
> > > > > +		condlog(0, "%s: release: failed to suspend
> > > > > dm
> > > > > device.",
> > > >=20
> > > > Why do you use dm_simplecmd_noflush() here? Shouldn't queued IO
> > > > be
> > > > flushed from the dm device to avoid it being sent to paths that
> > > > are
> > > > going to be unregistered?
> > > >=20
> > >=20
> > > I'm pretty certain that DM will still flush all the IO from the
> > > target
> > > to DM core before suspending, even with dm_simplecmd_noflush()
> > > set.
> > > In
> > > request based multipath, queued IOs are never stored in the
> > > target.
> > > In
> > > bio based multipath, they are, but they will get flushed back up
> > > to
> > > DM
> > > core when suspending and queued there. No IO should happen
> > > through
> > > the
> > > target after the suspend, until the resume.
> > > dm_simplecmd_noflush()
> > > just
> > > keeps multipath from failing any IO that it had queueing, and
> > > it's
> > > only
> > > really necessary when we resize the device, because if we shrink
> > > the
> > > device, outstanding IO might be outside the new bounds.
> >=20
> > OK, thanks for the clarification. I guess I've never fully
> > understood
> > the way queueing works in dm.
> >=20
> > What about queueing in the path devices?=C2=A0We'll be removing
> > registration
> > keys, so IO sent by the SCSI layer may end up with RESERVATION
> > CONFLICT
> > errors. To my understanding, without the DM_NOFLUSH_FLAG the kernel
> > will freeze the queue and flush everything, as if the device was
> > closed
> > during shutdown. If DM_NOFLUSH_FLAG is set, this won't happen.
> > What's
> > preventing the SCSI layer from sending IO while we're modifying the
> > registrations?
>=20
> In __dm_suspend() we block all new IOs to the dm device here:
> https://github.com/torvalds/linux/blob/fab1beda7597fac1cecc01707d55eadb6b=
be773c/drivers/md/dm.c#L2955-L2966
>=20
> Once we know that no new IOs are getting sent to the target, we wait
> for
> all the IOs that were send to the target to get completed by calling
> dm_wait_for_completion() here:
>=20
> https://github.com/torvalds/linux/blob/fab1beda7597fac1cecc01707d55eadb6b=
be773c/drivers/md/dm.c#L2973

I saw that code. I realize now that dm_wait_for_completion() will
finish all IO on underlying path devices. I wasn't 100% certain about
that in the first place.

I also saw that lock_fs() is not called if we set the noflush flag. And
I am wondering if that's what we want. If there's dirty data on the
file system and we drop our registration key, the file system will most
probably error out.

Martin
