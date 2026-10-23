Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792798846;
	b=26Hdar86YPYlEvm2N8ar5eL3WsuSyRh7gJ2YJJuV/HOKQtNNt5zbkutdF6HB3Yug+gah
	 XoZ1NUEYiL5wuRsdbnEoP/rE4WsiGb+JN7h3j40x1fsiHCOAQlwD8S/ryg5xaX5d7MpwY
	 RA/8J4bKnA2HR7ookxxpyCraCL3TSSid70DGg7a9vv7x684ypVeHHwGn4j/nFzXilftsp
	 rJlWWGZS3YEuvXYMnXAprQx3cmEm6e/CK1YjPyc01ieJ/8zfgOXE7wDKtTY+bH2Wbuxkh
	 VUmm3OhjqeztgoT8vcz2u4IgW6fmNBAnFz00Fnr4E3p04RDJQh/duribiu8ho2paoIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792798846;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=mYdWocvZZfDzsOAKZLrdW+DTqQ2tEM/hhAGKg2Iy6rc=;
	b=ILsGgEsN/eX/h6XruhSmYKdcUUjv8q6JzSHzD+rE4gHro0OAF7TlLCspdzGr1p0GU7Go
	 ZeOuanxN7e3wH/QCcc6b2/Io9V2rM85l1HF+ADdy3CaHOS3kQ0lsHbWuoBlFv4Y6fIXKi
	 UgaAX3xJ0wCkYdi92MLJTbinEg8zaptZYPXzkTAi9Q3SLO9pbiYxSE04fI99WlYPbaitF
	 VsAWssoLC1RVcbeM/pxveXKVn0llfLfqJh7jjeakttXq+3vye4PLMuARKI7H3CfWZlZFa
	 mMcBGicZYurYKL3bZ/wcRpeAS1e7Zwp55JHnM9qpm79+Tnn6JOjYjdZnKuS97sD9wPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="a/TVQleI";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C12606A31A
	for <dm-devel@lists.linux.dev>; Fri, 23 Oct 2026 23:40:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13C12606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a/TVQleI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792798845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mYdWocvZZfDzsOAKZLrdW+DTqQ2tEM/hhAGKg2Iy6rc=;
	b=a/TVQleIlvmSIo+3sOA8G0RGbFmnz/pO5PjtuwKEIWlzJ6I4YeZpSDTXpWmZJuHdxtHJOk
	QPZaKK+DmxuhmRPTo7XVAewI7sD1bz1w5vA5Vjbb6b39rYtZagPasmSaC1GxKuOYepQKHN
	9M9hz4+wSCXAJ0hmsK81UaimeneZuKw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-L0WgR57AOa2jcDgaG01_ew-1; Fri,
 23 Oct 2026 19:40:43 -0400
X-MC-Unique: L0WgR57AOa2jcDgaG01_ew-1
X-Mimecast-MFC-AGG-ID: L0WgR57AOa2jcDgaG01_ew_1792798842
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 277211955E89;
	Fri, 23 Oct 2026 23:40:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE66E1800642;
	Fri, 23 Oct 2026 23:40:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69NNeexq039719
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 19:40:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69NNeeEa039718;
	Fri, 23 Oct 2026 19:40:40 -0400
Date: Fri, 23 Oct 2026 19:40:40 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-ID: <atvweCfhjWkT9i-U@redhat.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
 <20261021231959.69270-1-brian@purestorage.com>
 <20261021231959.69270-2-brian@purestorage.com>
 <179270025923.152861.15521453184442767016.b4-review@b4>
 <atqpOBViqKWLZ7Q3@redhat.com>
 <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ULW3eGrhu3TWXfF9G0PLZrW-0hxx2r_jpTctTCowweM_1792798842
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 10:50:08PM +0200, Martin Wilck wrote:
> On Thu, 2026-10-22 at 20:24 -0400, Benjamin Marzinski wrote:
> > On Thu, Oct 22, 2026 at 10:17:39PM +0200, Martin Wilck wrote:
> > > > ev_add_path() sets mpp->force_readonly when a newly added path is
> > > > read-only, but never clears it. If a map is created or reloaded
> > > > while
> > > > its storage is write protected, the flag stays set. When write
> > > > protect
> > > > is cleared, the reload that uev_update_path() does for the
> > > > DISK_RO=0
> > > > uevent uses the stale flag and loads the map read-only, even
> > > > though all
> > > > of its paths are read-write. uev_update_path() clears the flag
> > > > after
> > > > that reload, so the map only recovers if another DISK_RO=0 uevent
> > > > reloads it again. If none comes, the map stays read-only, and
> > > > since
> > > > mpp->dmi.read_only is then 1, needs_ro_update() also ignores
> > > > later
> > > > DISK_RO=1 uevents for it.
> > > > 
> > > > Fix this by setting force_readonly before each load and clearing
> > > > it
> > > > when the load reads it:
> > > > 
> > > > - needs_ro_update() now sets force_readonly whenever it returns
> > > > true:
> > > >   to 1 for a DISK_RO=1 uevent, and to 0 when all of the map's
> > > > paths
> > > >   are writable. uev_update_path() no longer sets or clears it
> > > > itself.
> > > >   If the map has no dm info, needs_ro_update() now fetches it,
> > > > and
> > > >   returns false if that fails, instead of assuming a reload is
> > > > needed.
> > > > 
> > > > - ev_add_path() sets it from all of the map's paths rather than
> > > > only
> > > >   the path being added, and only when it is about to load the map
> > > >   (need_do_map). mpp->paths is up to date there after
> > > > adopt_paths(),
> > > >   while mpp->pg doesn't contain the new paths yet.
> > > > 
> > > > - update_map(), which does reloads that were delayed while the
> > > > map was
> > > >   waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the
> > > > map's
> > > >   paths before setting up the map.
> > > > 
> > > > - dm_addmap_create() and dm_addmap_reload() clear it as soon as
> > > > they
> > > >   have read it, so it only applies to the load it was set for,
> > > > even if
> > > >   that load fails. Otherwise a failed load would leave it set,
> > > > and a
> > > >   later reload for an unrelated reason, such as a path group
> > > > change,
> > > >   would load the map read-only.
> > > > 
> > > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > > 
> > > Almost there. One remark below.
> > > 
> > > > 
> > > > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > > > index e3870f5..c994715 100644
> > > > --- a/libmultipath/devmapper.c
> > > > +++ b/libmultipath/devmapper.c
> > > > @@ -539,10 +539,15 @@ static uint16_t build_udev_flags(const
> > > > struct multipath *mpp, int reload)
> > > >  
> > > >  int dm_addmap_create (struct multipath *mpp, char *params)
> > > >  {
> > > > -	int ro;
> > > > +	int ro = mpp->force_readonly ? 1 : 0;
> > > >  	uint16_t udev_flags = build_udev_flags(mpp, 0);
> > > >  
> > > > -	for (ro = mpp->force_readonly ? 1 : 0; ro <= 1; ro++) {
> > > > +	/*
> > > > +	 * force_readonly only applies to this load. Clear it,
> > > > so that it
> > > > +	 * can't affect later loads, even if this one fails.
> > > > +	 */
> > > > +	mpp->force_readonly = 0;
> > > > +	for (; ro <= 1; ro++) {
> > > >  		int err;
> > > >  
> > > >  		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp,
> > > > params, ro,
> > > > @@ -578,19 +583,23 @@ int dm_addmap_create (struct multipath
> > > > *mpp, char *params)
> > > >  int dm_addmap_reload(struct multipath *mpp, char *params, int
> > > > flush)
> > > >  {
> > > >  	int r = 0;
> > > > +	int force_ro = mpp->force_readonly;
> > > >  	uint16_t udev_flags = build_udev_flags(mpp, 1);
> > > >  
> > > > +	/* As in dm_addmap_create(), force_readonly only applies
> > > > to this load */
> > > > +	mpp->force_readonly = 0;
> > > > +
> > > 
> > > One minor issue here. If the reload below fails, the map is still
> > > read-write
> > > in the kernel. As we reset force_readonly, it will remain so, at
> > > least until
> > > we get another event with RO=1.
> > > 
> > > If the RO reload fails with force_readonly=1, we could set
> > > force_readonly to 1 again
> > > after the failure. In needs_ro_update(), we'd then need to modify
> > > the fast
> > > return clause "if (mpp->dmi.read_only == ro)"; if both are 0 and
> > > force_readonly is
> > > still set, you'd need to check the paths and see if there's still a
> > > read-only path
> > > around.
> > 
> > I can actually see both sides of this argument. If the reload fails,
> > and
> > the next reload doesn't check the paths again, we really don't know
> > what
> > the correct setting is.
> > 
> >  This may be overthinking things, but we could make
> > force_readonly a three state value, somthing like:
> > 
> > MP_RELOAD_RO
> > MP_RELOAD_RW
> > MP_RELOAD_RECHECK
> > 
> > If mpp->force_readonly was MP_RELOAD_RECHECK needs_ro_update() would
> > always return true, and dm_addmap_create() and dm_addmap_reload()
> > would
> > check the paths themselves. Again, because these could be called in
> > cases where we can't trust mpp->paths to be up to date, They should
> > probably loop through the mpp->pg. You can make it always correct to
> > use
> > mpp->pg in has_ro_path() by moving the calls to has_ro_path() to
> > after
> > setup_map() is called. If that succeeds, that pathgroups have to be
> > set up
> > correctly.
> > 
> > If we don't do something complicated, it might be better to always
> > unset
> > mpp->force_readonly like it patch currently does. It's an unlikely
> > corner case and at worst you would get a readwrite mpath device where
> > writes failed, because the device really should be read-only. 
> 
> I agree that it isn't a big issue if such writes fail. But if some
> paths are still read-write, writes might actually _succeed_ on them,
> Data corruption would be possible, as some writes would succeed an
> others wouldn't.
>
> Am I overlooking something, and this is actually impossible? I guess
> it's highly unlikely because in practice the ro/rw is toggled on the
> storage side, and happens per volume, i.e. for all paths
> simultaneously.

Yeah. I don't think there really is such a thing as only one path being
read-only. If you have a read/write dm device, all of the underlying
devices must be opened read/write. The table won't load if they can't be
opened with a matching mode. So the IO will go through to the scsi
device, and I think it will fail on any path.

> But if that's true and writes-succeeding-although-they-shouldn't is not
> an issue, I wonder why we go through the hassle of setting the read-
> only attribute on our maps at all. We could just keep them read-write
> and trust that the writes (which shouldn't be attempted on read-only
> devices after all) will fail at lower layers.

Originally, dm would open the underlying devices anew whenever you
loaded a new table. This caused problems with multipath, because
sometimes failed device aren't openable when you try to reload the
table. It used to cause multipath to be unable to reload the device
table when it included failed paths in certain states.

To fix that, if a device in a new inactive table already exists in the
existing active table, opened in the same mode as the new table wants, 
dm no longer opens the device again. It just shares the opened device
between the two tables.

However this caused a problem with multipath's ability to automatically
switch to read-only when a path switched to read-only. When dm still
opened the devices per table, the read-write load of the table would
fail, because it couldn't open all the path devices read-write. However
now that dm shares the path devices between tables, multipath devices
would never switch to read-only if they were previously loaded
read-write, as long as you weren't adding a new path device in the new
table. All the existing devices were already opened read-write, and the
first time multipath tries to reload the table it tries read-write.
Since it just shared the devices instead of opening them again, this
would succeed, regardless of whether or not the devices really were
read-write.

To solve this, whenever multipath detects that a device has switched to
read-only, it forces a read-only table reload, so that all the path
devices get re-opened read-only (since their requested mode doesn't
match their current mode). After that, the regular reload code will
work, since it will have to re-open all the paths read-write for the
read-write multipath table load-to succeed (again, since the requested
mode changed).

Actually, this makes me realize that there's no reason to care about
force_readonly in dm_addmap_create().

> > That seems
> > better that making a read-only device that should be read-write.

I do still waver a bit on whether or not we could leave force_readonly
set on failed reloads. Once a device turns read-only, it should stay
that way until we get another uevent, at which point we will call
needs_ro_update() again. Perhaps we just need to make sure that we clear
force_readonly when needs_ro_update() returns false. In that case, it
seems like the only way we would do the wrong thing is if we somehow
missed all the uevents for setting the path devices back to read-write.

Thoughts? I'm clearly overthinking this.

-Ben

> If this is consensus, Brian's v3 would actually be preferred to his v4.
> It isn't a religious matter to me, I agree that failing to reload read-
> only is a highly unlikely thing to happen. But I'd like to clarify the
> question above.
> 
> I am not so enthusastic about the idea of the 3-valued force_readonly.
> 
> If we want to do this right, we need to check on every reload. And IMO
> that means that we need to track the read-only state of the paths in
> multipathd. It's cheap to retrieve the "ro" attribute in
> sysfs_pathinfo() and track it. If it changes, we expect an uevent,
> where we check DISK_RO anyway. The logic could be similar as it is now,
> but we can check on each reload whether the map should be read-only,
> because the check would be just a cheap loop over the paths. And we
> wouldn't need force_readonly at all any more.
> 
> Regards,
> Martin
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
> 36809,AG Nürnberg)

