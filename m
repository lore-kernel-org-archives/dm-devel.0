Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A9B382
	for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 00:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731456436; cv=none; b=sH9ch9tubkS7jxYo/ZxC1sW1G8aJmnnHoNtWH6DlbD1A1j8FL4P8bW0YfUw+bSKOUWII9VNBDizbR1dzgpnIxJq53BA95uN9KQ2HG0mlTw/inUqAIdpEFe0akbGOXR698GAoBri4+5oJWCIka+MPxTi7rTutpEvRqccvorZPA7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731456436; c=relaxed/simple;
	bh=2uhiSOHC2UXfRXbTUwEke6AFdeENUQkwggn1PD+Mhlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=biV0NVk7pxWQw2KQl/jxJ84XCSPvQmEvB+AeXEE4oo4cFfhUbQEHrctCBPcBlLYCbrYjZOEDg/4MnRejPhB/wPRJApqsl85FHJfQpD65UsZoONnPLDy60PPdspyGZkyGNI5h8+P14ouO4bzBAVPoiq2G6Zrxloqom9+VGd0o32k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bm1JAhFx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bm1JAhFx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731456432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6k1K53X6zWYR1dHfPoFNGIrH+u2K69uKMVsheKS4GRk=;
	b=bm1JAhFxe70D+NWLiGT0IJICUQ0Akr++bPm41ObCb40Er9FgDxP/RfaURqVBT5J4tpa7wi
	zcG9kgZSwnCgE1eDnoVC6+ErL/C/D/ttHovsfh5RRR3B6XPCGg+ootOg8Mm5WPNLnOTvIL
	bSedA/gdtDK6rmMf2pfhRqO4c+ooH9E=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-d9f_JtoYO5CbIIA2N7CtqA-1; Tue,
 12 Nov 2024 19:07:10 -0500
X-MC-Unique: d9f_JtoYO5CbIIA2N7CtqA-1
X-Mimecast-MFC-AGG-ID: d9f_JtoYO5CbIIA2N7CtqA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 111AD1977321;
	Wed, 13 Nov 2024 00:07:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDD351956086;
	Wed, 13 Nov 2024 00:07:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AD077Vp580693
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 19:07:07 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AD0773r580692;
	Tue, 12 Nov 2024 19:07:07 -0500
Date: Tue, 12 Nov 2024 19:07:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
Message-ID: <ZzPtq-Bd_P_ZuUSm@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
 <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
 <Zyz8SFDAkIggpuND@redhat.com>
 <692cb30cad72ed8165b8efd0751c8c5cb1f03993.camel@suse.com>
 <Zy6Lz1y0-dVXvodH@redhat.com>
 <a7b6076cc759383e407ac9e46ff39be14f5a1b6d.camel@suse.com>
 <ZzI8HbwgmBQSLbLk@redhat.com>
 <b46184d0ccf8f0c1f492a53313fe88ea33a0269e.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b46184d0ccf8f0c1f492a53313fe88ea33a0269e.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SeUUyN4rdspLVo4FZYeWe4nv6Bn4S1LRTglplmST2fc_1731456429
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 12, 2024 at 08:46:52AM +0100, Martin Wilck wrote:
> On Mon, 2024-11-11 at 12:17 -0500, Benjamin Marzinski wrote:
> > On Sat, Nov 09, 2024 at 12:03:33AM +0100, Martin Wilck wrote:
> > > On Fri, 2024-11-08 at 17:08 -0500, Benjamin Marzinski wrote:
> > > > 
> > > > Given that the code already does the right thing without needing
> > > > any
> > > > changes to handle tableless maps makes me feel like just removing
> > > > the
> > > > final patch is the best idea.
> > > 
> > > If we do this, do we still need the special case for DMP_BAD_DEV?
> > > IMO
> > > we just need to make sure that dm_get_maps() doesn't return an
> > > error if
> > > it encounters an empty map.
> > 
> > Depends. If we fail attempting to create a device, we could have
> > raced
> > with something else attempting to create it.  Just checking for
> > dm_map_present() before we remove the device won't distinguish
> > between
> > these two cases at all.
> 
> I would like to keep things as simple as possible. 
> 
> The main mistake that I made in bf3a4ad ("libmultipath: simplify
> dm_get_maps()") was that I'd changed dm_get_maps() such that returned
> error if anything went wrong for a single map. That was wrong, it
> should just skip the map in question (IMO that even includes the
> DMP_ERR case, but that's up to discussion). Just changing the behavior
> of dm_get_maps() would fix the regressions reported on GitHub (correct
> me if I'm wrong).
> 
> Wrt libmp_mapinfo:
> 
> >From my PoV, there's no difference between "has no table" and "has no
> targets". There _is_ a difference between "no targets" and "multiple
> targets" though, as the former can be reloaded as a proper multipath
> table whereas the latter cannot. So these two cases must be treated
> differently.
> 
> I think we should actually introduce a new return code.
> 
>  - DMP_NOT_FOUND should actually mean that the given map does not exist
> at all
>  - DMP_NO_MATCH should mean that it has targets that don't match
> (either multiple targets, or something non-multipath), or that the UUID
> doesn't match (if MAPINFO_CHECK_UUID is set).
>  - We should have another rc code for "exists but is empty", but that
> should be called DMP_EMPTY rather than DMP_BAD_DEV.

This sounds reasonable. I can redo my patch for that on top of the set
you just posted.
 
> > On the other hand, there is still a window where the program that we
> > raced with is in the middle of creating the device, but it doesn't
> > have
> > a live table yet. In this case, even the DMP_BAD_DEV code won't be
> > able
> > to distinguish between a map that didn't get created correctly and
> > one
> > that is in the process of getting created. It would reduce the window
> > where we could accidentally delete a working device, however.
> 
> I wouldn't bother about this kind of race too much. If multipathd just
> ignores this kind of maps as it used to, it won't do any harm AFAICT.
> We shouldn't alter this behavior, IOW multipathd should neither remove
> these maps nor add them to its internal tables unless they become
> populated with paths.
> 
> If anything, we should finally get down to delegating map creation from
> multipath to multipathd.

The issue is that if creating a multipath device fails, the current code
will only delete any leftover device it finds if that device is already
set up correctly (since dm_flush_map_nosync() won't delete the map if it
doesn't have a multipath table). This means we only delete devices in
the case where we did race and something else managed to set the device
up, which is exactly what we don't want to do. So, I'm going to repost a
version of my ("libmultipath: fix removing device after failed
creation") patch because anything is better than what we do right now,
which is just wrong.

> > Since it doesn't add much complexity, I lean towards keeping it, but
> > it
> > is one more state we need to handle on returns from libmp_mapinfo(),
> > so
> > I'm open to an argument that it's not worth it.
> 
> I agree, comments above.
> 
> > > > The only issue with the current code is that if you have a device
> > > > with
> > > > no table with the UUID of a multipath device but a different name
> > > > than
> > > > that multipath device should have, multipath will try to create a
> > > > new
> > > > device instead of reload it, and this fails, since the UUID is
> > > > already
> > > > in use.
> > > 
> > > That should be handled in coalesce_paths(). It's basically the
> > > scenario
> > > that occurs if we enable or disable user_friendly names.
> > 
> > Except that we have a mpp for the other device if it has a table. If
> > the
> > device doesn't have a table, then a mpp isn't created, so
> > coalesce_paths() doesn't track it. We could add code to create mpps
> > for
> > these tableless devices, but it's another trade off of added
> > complexity
> > to handle a rare corner case, and I'm not sure this one is worth it.
> 
> What I meant is that if there are matching path devices,
> coalesce_paths() will create an mpp and reload the table. Otherwise,
> the table will continue lurking around without being tracked, which
> doesn't do harm even if it may not seem optimal. If a matching path is
> added, again, uev_add_path() should reload the map (to be tested).
> 
> I think that behavior is sane enough for a corner case like this.

Even if there are matching path devices, if there is a dm device that
has a different name than the device we are trying to create, but the
same UUID, and no table (and thus, not in the current list of mpps),
multipath will try to create a new device instead of reload it, and it
will fail. I'm trying to avoid that. But this issue has been around
forever, and AFAIK has never actually caused a problem, so fixing it
isn't worth any real added complexity.

-Ben
 
> Martin

