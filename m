Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792715079;
	b=oFUnPIxEBFqm8tearipLYFTt0aGjMUWCcR+TPqEVhixcqKsT3lK+ufdsUDkKBfoeVzJy
	 tAHEjmp9a200lRU48voeTYOduq4XxSzIpbCeo6FddubC9IKzHOlTHsZobExFCGGrQch/k
	 cpLyXEqvgBXnqI29OCk7erFIvUgtlzW6rbhukQksHdBjt4eeq4jvWlIddcihgRqqhm4CB
	 lLRqe9RugwH3uAuBTFKPBMnB1i366d54Qg++sryaXn1NCmLhHEyYbH2bwyQuCUAaRIDIm
	 w1UWSuXxFGxUyVg1OfKTMVI8r4X9Jv4DCa1BZpIRjYwqOMYDcWpxD6nz8Kmmj2NSJ+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792715079;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=LIA4xADmhJkJy1ubDTJ7A1RZGxvkxhnrJg1u9uuJUg0=;
	b=pvJibQKaAytAnmJaCzE2zIYyn5aC0ZjFjGdVEciGVS7pZt6hi1r9GFjsicKQMLzVLyNi
	 GhVCeyVDYybj6F+dqgLHN7Yudi9YXtpARm6YtfwiycC2sD0F1GpLz6CPwx3Rqe1DKlbqP
	 ylN/z8IVgAwMkOHGVm4s/okH1+xnFXDevRmkB8iXOZ+6E/aL6vUFMR3EM0adwSsqDWtCS
	 em1PONRLGhY23x6NKRBOv6s4MPq8zBmB9im7gtWUMHYxf3LQeGPw2ny3CdXMcAUJXT1xG
	 wFT2e/Ezt10Q1ideDEfGnTK795R8M6dSTUP0KgvUm7QM1tWVBKon9VrtXHT5IbxUW0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Ss/x4QLA";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D5606A319
	for <dm-devel@lists.linux.dev>; Fri, 23 Oct 2026 00:24:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC7D5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ss/x4QLA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792715077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LIA4xADmhJkJy1ubDTJ7A1RZGxvkxhnrJg1u9uuJUg0=;
	b=Ss/x4QLA4nWzbq47gDbk1Ok0mPose4sHbzuwDVxHZzO5IAHaPdywNILtbaM3zLsLNuBm/i
	xanRWkgC0VziyJlI5IaZieMbDwMv5FZpoMpWHfuCKhHt7diEmUcayy31MK1+JVvLMJLx8i
	qI35j1cldrbgPuFDb245dTl5k+uXHe4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-f2cA2AlfMzOfBUmtOtXXAg-1; Thu,
 22 Oct 2026 20:24:28 -0400
X-MC-Unique: f2cA2AlfMzOfBUmtOtXXAg-1
X-Mimecast-MFC-AGG-ID: f2cA2AlfMzOfBUmtOtXXAg_1792715066
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D4EF1944CCA;
	Fri, 23 Oct 2026 00:24:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FEC418005B7;
	Fri, 23 Oct 2026 00:24:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69N0OO5u004859
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 20:24:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69N0OOvg004858;
	Thu, 22 Oct 2026 20:24:24 -0400
Date: Thu, 22 Oct 2026 20:24:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-ID: <atqpOBViqKWLZ7Q3@redhat.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
 <20261021231959.69270-1-brian@purestorage.com>
 <20261021231959.69270-2-brian@purestorage.com>
 <179270025923.152861.15521453184442767016.b4-review@b4>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <179270025923.152861.15521453184442767016.b4-review@b4>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gAPoCYFbjTDEADtgNTOsW-ac1hYZZppQOmBVIBMb1fo_1792715066
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 22, 2026 at 10:17:39PM +0200, Martin Wilck wrote:
> > ev_add_path() sets mpp->force_readonly when a newly added path is
> > read-only, but never clears it. If a map is created or reloaded while
> > its storage is write protected, the flag stays set. When write protect
> > is cleared, the reload that uev_update_path() does for the DISK_RO=0
> > uevent uses the stale flag and loads the map read-only, even though all
> > of its paths are read-write. uev_update_path() clears the flag after
> > that reload, so the map only recovers if another DISK_RO=0 uevent
> > reloads it again. If none comes, the map stays read-only, and since
> > mpp->dmi.read_only is then 1, needs_ro_update() also ignores later
> > DISK_RO=1 uevents for it.
> > 
> > Fix this by setting force_readonly before each load and clearing it
> > when the load reads it:
> > 
> > - needs_ro_update() now sets force_readonly whenever it returns true:
> >   to 1 for a DISK_RO=1 uevent, and to 0 when all of the map's paths
> >   are writable. uev_update_path() no longer sets or clears it itself.
> >   If the map has no dm info, needs_ro_update() now fetches it, and
> >   returns false if that fails, instead of assuming a reload is needed.
> > 
> > - ev_add_path() sets it from all of the map's paths rather than only
> >   the path being added, and only when it is about to load the map
> >   (need_do_map). mpp->paths is up to date there after adopt_paths(),
> >   while mpp->pg doesn't contain the new paths yet.
> > 
> > - update_map(), which does reloads that were delayed while the map was
> >   waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
> >   paths before setting up the map.
> > 
> > - dm_addmap_create() and dm_addmap_reload() clear it as soon as they
> >   have read it, so it only applies to the load it was set for, even if
> >   that load fails. Otherwise a failed load would leave it set, and a
> >   later reload for an unrelated reason, such as a path group change,
> >   would load the map read-only.
> > 
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> 
> Almost there. One remark below.
> 
> >
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index e3870f5..c994715 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -539,10 +539,15 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
> >  
> >  int dm_addmap_create (struct multipath *mpp, char *params)
> >  {
> > -	int ro;
> > +	int ro = mpp->force_readonly ? 1 : 0;
> >  	uint16_t udev_flags = build_udev_flags(mpp, 0);
> >  
> > -	for (ro = mpp->force_readonly ? 1 : 0; ro <= 1; ro++) {
> > +	/*
> > +	 * force_readonly only applies to this load. Clear it, so that it
> > +	 * can't affect later loads, even if this one fails.
> > +	 */
> > +	mpp->force_readonly = 0;
> > +	for (; ro <= 1; ro++) {
> >  		int err;
> >  
> >  		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
> > @@ -578,19 +583,23 @@ int dm_addmap_create (struct multipath *mpp, char *params)
> >  int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
> >  {
> >  	int r = 0;
> > +	int force_ro = mpp->force_readonly;
> >  	uint16_t udev_flags = build_udev_flags(mpp, 1);
> >  
> > +	/* As in dm_addmap_create(), force_readonly only applies to this load */
> > +	mpp->force_readonly = 0;
> > +
> 
> One minor issue here. If the reload below fails, the map is still read-write
> in the kernel. As we reset force_readonly, it will remain so, at least until
> we get another event with RO=1.
> 
> If the RO reload fails with force_readonly=1, we could set force_readonly to 1 again
> after the failure. In needs_ro_update(), we'd then need to modify the fast
> return clause "if (mpp->dmi.read_only == ro)"; if both are 0 and force_readonly is
> still set, you'd need to check the paths and see if there's still a read-only path
> around.

I can actually see both sides of this argument. If the reload fails, and
the next reload doesn't check the paths again, we really don't know what
the correct setting is. This may be overthinking things, but we could make
force_readonly a three state value, somthing like:

MP_RELOAD_RO
MP_RELOAD_RW
MP_RELOAD_RECHECK

If mpp->force_readonly was MP_RELOAD_RECHECK needs_ro_update() would
always return true, and dm_addmap_create() and dm_addmap_reload() would
check the paths themselves. Again, because these could be called in
cases where we can't trust mpp->paths to be up to date, They should
probably loop through the mpp->pg. You can make it always correct to use
mpp->pg in has_ro_path() by moving the calls to has_ro_path() to after
setup_map() is called. If that succeeds, that pathgroups have to be set up
correctly.

If we don't do something complicated, it might be better to always unset
mpp->force_readonly like it patch currently does. It's an unlikely
corner case and at worst you would get a readwrite mpath device where
writes failed, because the device really should be read-only. That seems
better that making a read-only device that should be read-write.

Thoughts?

-Ben

> 
> Martin
> 
> -- 
> Martin Wilck <mwilck@suse.com>

