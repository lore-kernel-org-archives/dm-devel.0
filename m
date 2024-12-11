Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C5124634B
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733936985; cv=none; b=NB3Eu/6knqwnUJkdba0GtKyWZFX6wHRTA+ei/z2Al0RYkbAEBL1kByJwVwoahtgIdGBfqkZVpB9ObhhA8sX14uVBrgoBL/35tt4++M+YAn7y1t/1b+CL8gkQXiXAHCcKfQelIH+8tWf5yaA3jj8GnmowK7YMj5ut3PuzEBPBVOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733936985; c=relaxed/simple;
	bh=A2RSQ9UCTsaVCgvCMDdKmvvATBDDn6uIKCyPpJ3FzVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PKgk+wVLjQ51L4+U7CdnNZlPyFzopyxeUnBiSQGsllNfUeA8ao6jDkI4jdcNIO9roJ4aX28lwnVCq/KyEGWh9X8KXMuJ0Bt6i4gVDBYzChYT6vZzr/eML3/U1xCSzMgpxyFJ1SnCmuKJSjFV8ykwbkDlDwgnlbtDPJTt3GeHFKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVJgN0km; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVJgN0km"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733936983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Niy+7icABMJwzqUMzhWHXuxg2yPo+kRzrLl7SzxjdU=;
	b=iVJgN0kmo1FdiCr3mRf3z8jIvyJ5P6xE5hpbrs/9sRiiAB8Lu8qRDzLK8+K6AfJDKgfVIm
	/Y6VdnZBpVQuh2kpymH0a950roH9havgV0JUcVubldHsn2ObdDUlDaYF1/jqyH76zS3XUG
	2xRhw+bZW2KURCh44h0bL0hZDSGtw6k=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-x9EiFWniOuqVSGHpRSie4A-1; Wed,
 11 Dec 2024 12:09:41 -0500
X-MC-Unique: x9EiFWniOuqVSGHpRSie4A-1
X-Mimecast-MFC-AGG-ID: x9EiFWniOuqVSGHpRSie4A
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83FBE1956089;
	Wed, 11 Dec 2024 17:09:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 218B11956089;
	Wed, 11 Dec 2024 17:09:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BBH9cKN1450809
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Dec 2024 12:09:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BBH9cDp1450808;
	Wed, 11 Dec 2024 12:09:38 -0500
Date: Wed, 11 Dec 2024 12:09:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
Message-ID: <Z1nHUk8o3_qqPwED@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-4-mwilck@suse.com>
 <Z1jPMVejcI61qP9z@redhat.com>
 <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ywJPAQcWEcOCeyrA5-e_EmNcjYF_38fIcemdk99CxIs_1733936980
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Dec 11, 2024 at 01:06:46PM +0100, Martin Wilck wrote:
> On Tue, 2024-12-10 at 18:30 -0500, Benjamin Marzinski wrote:
> > On Sat, Dec 07, 2024 at 12:36:07AM +0100, Martin Wilck wrote:
> > > We previously didn't allow map removal inside the checker loop. But
> > > with the late updates to the checkerloop code, it should be safe to
> > > orphan
> > > paths and delete maps even in this situation. We remove such maps
> > > everywhere
> > > else in the code already, whenever refresh_multipath() or
> > > setup_multipath()
> > > is called.
> > 
> > Actually, thinking about this more, what do we get by proactively
> > deleting the multipath device if something goes wrong in the checker?
> > If
> > we successfully reload a device, but can't sync it with the kernel,
> > that's one thing, But that was triggered by a change in the device,
> > and
> > we know that when we reloaded the device, device-mapper was working.
> > I'm
> > leery of possibly deleting the map because of a transient device-
> > mapper
> > issue.  I'm not sure if on a check that we do repeatedly, we should
> > delete the device on an error.  We haven't in the past, and as far as
> > I
> > know, it doesn't cause problems.  
> 
> I don't disagree. But the same can be said for basically all call
> chains where setup_multipath() is called for an existing map. I was
> just following the pattern that we use e.g. in ev_add_path(), or in
> update_mpp_prio(). Why would we treat the checker and path addition
> differently in this respect?

I'm confused here. ev_add_path() doesn't remove the device if the reload
fails. If a reload fails, the table should stay the same. That's why I
said that in other cases where we delete the device, we know that when
we just reloaded the device, device-mapper was working. Looking at the
code, that isn't really true. After failed reloads, we still call
setup_multipath to update our state, and we will delete the device if
that fails.
 
> If we look at this pragmatically (assuming that multipathd gets the
> parameters right), the most probable reason for a map reload failure is
> failure to open a path device in bdev_open(), either because the device
> doesn't exist, or because it's busy or otherwise unavailable. If this
> happens in ev_add_path(), the likely reason is that the path just added
> was busy, and the smartest action upon such a failure would probably be
> to just undo that addition. We currently don't do that; we remove the
> entire map, which is questionable, as you state correctly.

This is why we call setup_multipath after failed reloads, to make sure
multipathd's view of the multipath device resyncs with the kernel's,
which hasn't changed from what it was before the reload failed.

> In the checker, this can't happen. Obviously, no other process can grab
> a path device while the device mapper is holding it, so -EBUSY won't
> occur if we reload an existing map. Even device deletion doesn't cause
> failure on reload. It is possible to delete a SCSI device while it's
> mapped, and execute a table reload / suspend / resume cycle on the map
> while referencing the deleted device. The kernel keeps holding the
> reference to the deleted device, and will simply mark it as
> failed. This holds also if the mapped paths are re-grouped or re-
> ordered in the table. Failure occurs only if we temporarily remove the
> device from the map and re-add it, because as soon as the device is
> removed from the map's dm table, its refcount drops to zero, and it's
> gone for good.
> 
> IOW, reloading a map with a table containing only already-mapped
> devices will never fail, except in extreme situations like kernel OOM.

Maybe I should clarify my position a bit. I am fine with reloading the
device in the checkerloop if something has changed. This obviously
does run a very small risk of something going wrong and a device getting
removed unnecessarily, but we know that we need to reload the device, so
we should.

What I would rather avoid is reloading the device because we failed to
get it's state in do_sync_mpp(). We don't do this because we know that
something has changed. We do this as a safety measure to deal with
corner cases where our state doesn't match the kernel's and we didn't
get an event. Double checking this each time we check a path in a
device saves having to catch all these corner cases elsewhere. But it's
almost always completely unnecessary, and we're doing it on every
multipath device every couple of seconds, unlike reloading a device,
which is rare.

> Thus, AFAICS, the only relevant scenario where a reloading would fail
> is trying to add a path device that was not previously mapped, and
> that's either busy (perhaps in another map) or has been deleted, IOW
> only when we reload after calling adopt_paths(). This is where we could
> improve. If we fail to reload after adopting new paths, we could fall
> back to the existing table, and perhaps try to add paths one by one.
> Again, this is post-0.11 material.
> 
> OTOH, practially impossible is not totally impossible, so we need to be
> prepared to map reload failure either way. IMO the best thing we can do
> in this case is to keep using the kernel's map, and retry reloading
> later. 

I'm not actually worried about the kernel so much as libdevmapper. It is
not designed for multi-threaded processes, and that has bitten us in the
past. For intance, it's why we don't delete devices in dmevent_loop() on
libdevmapper errors. dm_get_events() just waits and retries if getting
the device list fails, and for each device, it calls dm_is_mpath and
will only delete a device on DM_IS_MPATH_NO, which is what I suggested
for the cleanup function.

I'm pretty sure we've handled all of the known issues here, with fixes
like:
02d4bf07 ("libmultipath: protect racy libdevmapper calls with a mutex")
34e01d2f ("multipath-tools: don't call dm_lib_release() any more")

I'd rather not risk having missed some issue that could cause a
temporary error in a function that we call every couple of seconds
(almost always unnecessarily).

-Ben

> The only critical situation is WWID change of path devices. We must try
> to fix this situation ASAP when we detect it. I'm unsure what the best
> action is if a reload fails in that situation, though (other than
> failing the path, as we already do).
> 
> Martin

