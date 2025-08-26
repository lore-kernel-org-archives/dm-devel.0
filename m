Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9062E242D6B
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 08:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756197866; cv=none; b=I2/NkGyCJe3ybiGhVANwT19xqAqBjSEE5y1aev7XYSGyNDgqfwoQxEivMu4lgaG7y0jPpsjSvPw2FM254iu9+wgHGsLZ0B1jkg9waLcjZIQzOMQjkoCTyqADJZiRyeGWNVAXkAOqRove4AN9CXtH0IKBaIcJ1maRAuyVivwvBC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756197866; c=relaxed/simple;
	bh=hAPW4n1rZORimCRJ6MnYQWh54Fb4RQY6vQpFjr8xES8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U90VpAgG66yVy6FRGidy9nuCQbaUioM8bH6W7RqXM0UxyH9aM3M6XXiNHx5QomDSnfT9FrN/0qSyPJzz67nDqCrWkdGJMAjgfttLPx83tA/yHR/yrJMUA+eJna8Zi65lngCqAgpc4SsHldszpReyUCERm2ajIjjolpQx9tCf1Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NStzNXbX; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NStzNXbX"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61c38da6a0bso3744515a12.1
        for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 01:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756197863; x=1756802663; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JYxovt/f6+kOeHTG3tgsmbcYeHtDzOn2OP0+2FSa7jA=;
        b=NStzNXbXKzAQGmnAIR9WwAnLlTSyyUXgM74Feq2ISRoNAmfyDnR7W38CficxSEL/29
         uAKncfPQUMiMrNN7/V5aWZiIVAZDupgHeupi7/4uCBhAy3zXlmwXBX9byb/zWpVwX0PS
         6tMw9FcBpfdRj+LpCDVOHKprk86wExK/Gbi8a6JCZCAVv1iVSqmEBzAOhMRUYPnB3q+2
         4nqmsNB1xt/DXoCyGrxKets6/+XG5BxrXmtsGM1fRIIE7Ge0AdU1ysbZIhu8ae2IWdKs
         +hSQUCLTyJGXDb9HqWvCoz9Kbwy7jbqmQd8FqXnwH7wnbc0y41vP6vgY8VCebbjlzst3
         1iWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756197863; x=1756802663;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JYxovt/f6+kOeHTG3tgsmbcYeHtDzOn2OP0+2FSa7jA=;
        b=WUScDdKFcoIrmsAsYe3kKWu6yKm4lcjJKg+vSTs8Bmq58//TBGE2btuipvGX01x1wZ
         +1TfPzqAZnN+jhARFylRqOBeZhM3sw46hlZiw/Guz36E9+PnYRosZRQxmZQcwEKcVSTY
         ZzJUe1aMzC4ZMfjL3mNozkNQqDIQGPp4qDR7m3kPjskI7Ues5ma2DTwOy6lHJRLpzBX/
         pv4lIjWxehMRptB6rt/Ixy5Gz1sgWNH/lgpr68rsJCFMWgW9OpLCk18m4/r3OBdFAIL9
         L6PnomNt9oMkveL/Rs6axbvR3WXijtSMm10/w6vctdq5pf8tyuKxI8HMhe5loQx3CKiW
         Trig==
X-Forwarded-Encrypted: i=1; AJvYcCUHKH4B3AJ3lJjXKYM23dJAIiIuwpXxHF6yDfwq3uC6z/k96sBMrW61+oq6hBH1WflXvZ0Nytqu9A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwrDFdh2pTd32v4sJP2o/u6B2uU04bIeJ8qsqY/Lg5wKHwfR8i+
	nGxSW17kfvIiUJF2ftgqcHo1hK4TwL48QF8dddq6suDyRe4X3pjnMjVO/c4ucb+i/Oo/7mUYXHy
	5tF1GawI=
X-Gm-Gg: ASbGncutft5C6vRtn5hbTbFWWOJEwyKJK+BQ4kFd5UjD4bblLtIesM8fTHJrqH64PVh
	5ZfYJiVPxlodLWNPXieE/N1D+NGJlB/XSMwdvTq1Sbd0Sh/UEyabJP6QSs1UBNwyg84cd4O9BoF
	g3lxg/PmB9A0quPST3PS50OWpzKitzblCjO6dTm4oK+nl6PFT6EcDqGI8MOK9Ej+ocIQrEtshX5
	Bt4CPogxajf5d/enAA81bGfg4y+q2khvzh4qUBqniTOvJXR3re5D2Po93SL8wP8u8gYZ5KQQ5WE
	7ObNX7mrqSCDzeTpiS8MISfmh9z/1UR2DP0u0ZOo7DN3qDDCldy3FA0u2I54IxSgkW0e1YkF1pR
	OAAl4UwfqWXig77/1Iiy6aTKYMFjU1sfkZ5gJ6eMoG6M7MGc+JAyrn4tE7gm9Wduo5oSBTBiNPX
	95li83d5F74z7XT8avg7zYaf+q/MLjgnLTIt7ZbVTYk3dDq81zGLK18GQ=
X-Google-Smtp-Source: AGHT+IHdLMa5ftkeYdUf5T+epFSTsE7Z5t0GquoXBKOezH1ACNTxmFNWx26BIKLJ6d1b7LKjKAKtIw==
X-Received: by 2002:a05:6402:2552:b0:61c:9852:bbb0 with SMTP id 4fb4d7f45d1cf-61c9852bed2mr688443a12.19.1756197862824;
        Tue, 26 Aug 2025 01:44:22 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c78e49c90sm2565433a12.45.2025.08.26.01.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 01:44:22 -0700 (PDT)
Message-ID: <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
Subject: Re: [PATCH 09/15] limpathpersist: redesign failed release workaround
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 26 Aug 2025 10:44:22 +0200
In-Reply-To: <aK0FIY7cVE_LxNMg@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-10-bmarzins@redhat.com>
	 <dc941be94accce6ed554eac92f833cbb8e69263b.camel@suse.com>
	 <aK0FIY7cVE_LxNMg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-08-25 at 20:51 -0400, Benjamin Marzinski wrote:
> On Sun, Aug 24, 2025 at 05:26:50PM +0200, Martin Wilck wrote:
>=20
> >=20
> > > +	/*
> > > +	 * Cannot free the reservation because the path that is
> > > holding it
> > > +	 * is not usable. Workaround this by:
> > > +	 * 1. Suspending the device
> > > +	 * 2. Preempting the reservation to move it to a usable
> > > path
> > > +	 *=C2=A0=C2=A0=C2=A0 (this removes the registered keys on all paths
> > > except
> > > the
> > > +	 *=C2=A0=C2=A0=C2=A0 preempting one. Since the device is suspended,=
 no
> > > IO
> > > can
> > > +	 *=C2=A0=C2=A0=C2=A0 go to these unregistered paths and fail).
> > > +	 * 3. Releasing the reservation on the path that now
> > > holds
> > > it.
> > > +	 * 4. Resuming the device (since it no longer matters
> > > that
> > > most of
> > > +	 *=C2=A0=C2=A0=C2=A0 that paths no longer have a registered key)
> > > +	 * 5. Reregistering keys on all the paths
> > > +	 */
> > > +
> > > +	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp->alias,
> > > 0))
> > > {
> > > +		condlog(0, "%s: release: failed to suspend dm
> > > device.",
> >=20
> > Why do you use dm_simplecmd_noflush() here? Shouldn't queued IO be
> > flushed from the dm device to avoid it being sent to paths that are
> > going to be unregistered?
> >=20
>=20
> I'm pretty certain that DM will still flush all the IO from the
> target
> to DM core before suspending, even with dm_simplecmd_noflush() set.
> In
> request based multipath, queued IOs are never stored in the target.
> In
> bio based multipath, they are, but they will get flushed back up to
> DM
> core when suspending and queued there. No IO should happen through
> the
> target after the suspend, until the resume. dm_simplecmd_noflush()
> just
> keeps multipath from failing any IO that it had queueing, and it's
> only
> really necessary when we resize the device, because if we shrink the
> device, outstanding IO might be outside the new bounds.

OK, thanks for the clarification. I guess I've never fully understood
the way queueing works in dm.

What about queueing in the path devices?=C2=A0We'll be removing registratio=
n
keys, so IO sent by the SCSI layer may end up with RESERVATION CONFLICT
errors. To my understanding, without the DM_NOFLUSH_FLAG the kernel
will freeze the queue and flush everything, as if the device was closed
during shutdown. If DM_NOFLUSH_FLAG is set, this won't happen. What's
preventing the SCSI layer from sending IO while we're modifying the
registrations?

Martin
