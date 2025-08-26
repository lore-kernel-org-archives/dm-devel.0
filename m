Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD3D327790
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756202816; cv=none; b=RxYjb23D7o5PT+UWlBNmF1N+wS/O83B2BwTvtyYQGWg6cY30g09p7FWDfYsf0q0oT2dotZPneW2DM306sa6btbjfQYoDbr/EoZ0Jmt2RaJBwTsIky+uZCKCuMPmClnoJXAK1sLaq4Tk2UuwXb/BKo86wRR8uAtpR0yH95q2GFUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756202816; c=relaxed/simple;
	bh=kSALoAwdCKz+nK2FwHDubf9u15bf545HFdovlwL8WDI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i2KeJ7eKE8OYnxy0sNmwzPieTBht2NmSeFi6dyxZfjgjX9qV7EqBA11hoiX4XsH+esRIKm4aOjmEjRnomfImqAeISfRzx9inGSoTwfq0MaBvkz68a1T/4DsisHg3FeHXyQdPX58fQln3qR+5YniNwaYE48De+NfP5NTIJQPJv/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b63awyP1; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b63awyP1"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61c325a4d83so4254409a12.0
        for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 03:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756202812; x=1756807612; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EAuyXUcQEeDKmWGTTGHBQSLpRMNF32uk9FFhSqGRwPE=;
        b=b63awyP1MSPVw5nQrDE1v06XwYTyB3mbPLilmIIq9j3XeIAkvUtvHXRVlBqRzZ2FFK
         tN6OIbR/ZGAwseb5nE9N7fGfITyL3rSBnF3m1hotZCXqLzF/I+MSpWXQUJwSSuNUu3Ah
         gJ+z544sdAUjCDfCba2Lw4jklDeMvMUFtP/v3aTFQZHSEKT0QQpn+K+K+QEjGRFe9Fjc
         LRJpuzy1IQlJrRFRDYVHFIBaUyJPvntKmSF/XgKjKJiIRaSYL+c0kx1HCBYW56GCP21W
         47FZhEsAdZWTVqQ/7nwo3ZnR4vDA00OeDeSgYDR98t/KSr61QbCrI0Feyw0GPVPqVMH/
         38rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756202812; x=1756807612;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EAuyXUcQEeDKmWGTTGHBQSLpRMNF32uk9FFhSqGRwPE=;
        b=N9oGUMh5cWEVI/Ccc0ZPNFuVE6g+ap5qFa1SlNQkI9DbKSxZ3283stdAhD5zD52gX8
         6lp8++X62QYIhk0rZHiCWzeVA0Ft4HZr2gsQJIXeRX6yCKoOnqUJow6MAofgMlv3DkMN
         w698eYDixwaFjkVhdvI+XosghFE4Gl6QdimLflG9Wkov9t5hheQmkJEOARak2YtRptJm
         ps7u02/A0KrT+BABxlJ69bVYu1ugsV/3qOEQpk5Inqs7pmOrL7K2rU6xySGNoRZ0khX4
         F5JxnPKQkQyF1ojTjoXOeJTpMvwSjv+t5be8jZxepLK61fXpE9ukged40cH+MspK9y4F
         boow==
X-Forwarded-Encrypted: i=1; AJvYcCXrWVLp9SzSQtWFu6IF3huGSSzUNqfo5lP1yOuIamYbdnV/mHKUUcenEsDjHXTv+rGUFszWweq+Vg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyAh9jm7WYgzvgnjguwBuKFOTtYVySEAN+kE6GfjXtB7VRGdiyG
	XUyhx9lUgN5BtwNV2TsMbvFiZYuEEEqc5VTF7pvNMNW/iG4Ec5Cz/h7ziKMq+C7MNlnXaL7B7FW
	ObXuWX3g=
X-Gm-Gg: ASbGnctzQkPOLVXog1C7pVSf5PIjlqc3+1UCAjiSlzd+qftTJk3DZb0a16rtK/9vRR/
	p1u8QfYRZ2Zrz83h8HQS0t7Q3/35JFI524KpR/rhk66US2eAdozjeHv8HXIqdaCGl8GJ9QiUR6s
	9LsmWQ4ie45qMyx8XvM1Bdozh60aDkmzi8/YoKNm+M0gAg17nVA8KKUI53fKcXjx6nv9aoPAfIC
	zzii/tS2A8PXnX6/3MDKVEZkccIswdb4o/+VFZHvwtw5y7X5HjQaZeVFhsnwwVGcx/FcFXR6mTt
	PU6FN9eWUiILIRZJ5IsL0cnzT+db4NUuUYh5qneE7mWugAv4Q5tXErJojmw8+rm6Xzjg0Mzxyrm
	YQqfSxGOMC+Gs240IML6EJED78GDlGB6orMi6DuVhTICix8YXrt3OAU/WBuYMC19Vv66zMA33lf
	K7g5dI+zcRzdANm20ljNgrkzzlzNvzCPs8JV0IqsHiIN/5FTxKfregSR0=
X-Google-Smtp-Source: AGHT+IGRaAfiRhTuNuv2+dxtBFHYI6uRJPsM7Edj1PcNvNp6LIRRM1mjRx/eIzZcJBLax/ljWjjmpQ==
X-Received: by 2002:a17:906:6a0f:b0:afa:2672:8c49 with SMTP id a640c23a62f3a-afe28fd037amr1323458166b.18.1756202811893;
        Tue, 26 Aug 2025 03:06:51 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afeb167670esm54649666b.112.2025.08.26.03.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 03:06:51 -0700 (PDT)
Message-ID: <5261990d40414f56f2476226e0997d728b81648e.camel@suse.com>
Subject: Re: [PATCH 09/15] limpathpersist: redesign failed release workaround
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 26 Aug 2025 12:06:50 +0200
In-Reply-To: <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
		 <20250710181100.3997759-10-bmarzins@redhat.com>
		 <dc941be94accce6ed554eac92f833cbb8e69263b.camel@suse.com>
		 <aK0FIY7cVE_LxNMg@redhat.com>
	 <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-08-26 at 10:44 +0200, Martin Wilck wrote:
> On Mon, 2025-08-25 at 20:51 -0400, Benjamin Marzinski wrote:
> > On Sun, Aug 24, 2025 at 05:26:50PM +0200, Martin Wilck wrote:
> >=20
> > >=20
> > > > +	/*
> > > > +	 * Cannot free the reservation because the path that
> > > > is
> > > > holding it
> > > > +	 * is not usable. Workaround this by:
> > > > +	 * 1. Suspending the device
> > > > +	 * 2. Preempting the reservation to move it to a
> > > > usable
> > > > path
> > > > +	 *=C2=A0=C2=A0=C2=A0 (this removes the registered keys on all pat=
hs
> > > > except
> > > > the
> > > > +	 *=C2=A0=C2=A0=C2=A0 preempting one. Since the device is suspende=
d,
> > > > no
> > > > IO
> > > > can
> > > > +	 *=C2=A0=C2=A0=C2=A0 go to these unregistered paths and fail).
> > > > +	 * 3. Releasing the reservation on the path that now
> > > > holds
> > > > it.
> > > > +	 * 4. Resuming the device (since it no longer matters
> > > > that
> > > > most of
> > > > +	 *=C2=A0=C2=A0=C2=A0 that paths no longer have a registered key)
> > > > +	 * 5. Reregistering keys on all the paths
> > > > +	 */
> > > > +
> > > > +	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp-
> > > > >alias,
> > > > 0))
> > > > {
> > > > +		condlog(0, "%s: release: failed to suspend dm
> > > > device.",
> > >=20
> > > Why do you use dm_simplecmd_noflush() here? Shouldn't queued IO
> > > be
> > > flushed from the dm device to avoid it being sent to paths that
> > > are
> > > going to be unregistered?
> > >=20
> >=20
> > I'm pretty certain that DM will still flush all the IO from the
> > target
> > to DM core before suspending, even with dm_simplecmd_noflush() set.
> > In
> > request based multipath, queued IOs are never stored in the target.
> > In
> > bio based multipath, they are, but they will get flushed back up to
> > DM
> > core when suspending and queued there. No IO should happen through
> > the
> > target after the suspend, until the resume. dm_simplecmd_noflush()
> > just
> > keeps multipath from failing any IO that it had queueing, and it's
> > only
> > really necessary when we resize the device, because if we shrink
> > the
> > device, outstanding IO might be outside the new bounds.
>=20
> OK, thanks for the clarification. I guess I've never fully understood
> the way queueing works in dm.
>=20
> What about queueing in the path devices?=C2=A0We'll be removing
> registration
> keys, so IO sent by the SCSI layer may end up with RESERVATION
> CONFLICT
> errors. To my understanding, without the DM_NOFLUSH_FLAG the kernel
> will freeze the queue and flush everything, as if the device was
> closed
> during shutdown. If DM_NOFLUSH_FLAG is set, this won't happen. What's
> preventing the SCSI layer from sending IO while we're modifying the
> registrations?

I just re-read commit 2e93ccc1933d ("[PATCH] dm: suspend: add noflush
pushback"), which explains that the noflush flag is mainly meant for
handling queue_if_no_path situations, in particular being able to
reload a queueing multipath map with new paths when all paths have
failed. That's exactly what you wrote, queueing IO in generic dm rather
than in the target in order to facilitate map reloads.

Here we're looking at a very different situation. RESERVATION CONFLICT
errors won't cause queueing, because the kernel doesn't classify them
as path errors.=C2=A0If we need to preempt a reservation held by another
host, we'd rather not send IO to the device yet. If we have a
reservation we want to give up, we should make sure to have all
outstanding IO sent to the storage beforehand. In other situations like
just registering keys without reservations being present, flushing
won't be necessary, but it won't hurt either, AFAICS.

I am not sure whether it makes sense to try sending PRIN or PROUT
commands to maps in queueing state. Depending on the nature of the
errors that caused the paths to fail, we may or may not be able to send
this type of commands. PRIN/PROUT must still work for devices in
STANDBY state, but there are other situations where they wouldn't work,
or would even hang.

I tend to think that sending PRIN or PROUT commands to queueing devices
is an extreme corner case. Perhaps we should just refuse to do this=20
(realizing that we can't avoid a device entering queueing mode while
we're processing PR commands, but that's an even more extreme corner
case).

If we can assume that the device is not queueing, it might actually be
better leave the NOFLUSH flag clear, making sure that the queue is=20
frozen and all IO is actually flushed before changing PR keys or
reservations.

Am I getting something wrong here?

Martin
