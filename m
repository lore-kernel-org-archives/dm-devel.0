Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D112530CDA0
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 19:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756236984; cv=none; b=PfYFe+QeDDiHi9UMCgm0zJUBzhYcPP/oejtO1+oX3SZDoSAnex4YVvnjXjc3EjjpeJTI4FayRYm1iAknmP6YQQX03NcNSX3aS8dFG8zWmdBiziLmG8ec/6R/imxZGGIuA3I3y6/WJ7VoPhv0T/GnjftsyIqLPK5N02T2vRUVes0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756236984; c=relaxed/simple;
	bh=lZM8yDfJM4Yuycq3TlIkJV6CtVScjCBU+JMMARPlU+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=bgzCdPxvv0Ff50/JyfMJmR82zMF+xZ5xwQ9CAG6oRx17NhxA6L6FX/48RaZ1NAkgbuJdzNJj5jVKcjtZJoi6rtNXnT5+7Rp91G6Yu42knsCmR4WXSSuuMHRbu9DUBahNOuBqZLk+tv8R+ETMiK1vdiJsfBeOM1YOS8YI91p3JgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BKFlNSfl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKFlNSfl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756236981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mx5lYC37PS0wTn5cueDbjKm+X7LcCWqiMH5ROOD3Cl4=;
	b=BKFlNSflvQGS/VNWyHtHVEXiCKgidYn9bYpQaVSWR+td+AYy25CI5ZClBNA6giY6IPhucX
	S7rBvuVftenzDEHw9j85jSn1k2o4mIt2Pd1AH8jqiFMWy+RkLevw8m84cpZgDF4rjOX1Bf
	/fEGuMCxA6gO4gQASRIVp+4IsF7fmmA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-gjVRjsXmNgCIDi4wL5zdFg-1; Tue,
 26 Aug 2025 15:36:20 -0400
X-MC-Unique: gjVRjsXmNgCIDi4wL5zdFg-1
X-Mimecast-MFC-AGG-ID: gjVRjsXmNgCIDi4wL5zdFg_1756236979
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 113D01800359;
	Tue, 26 Aug 2025 19:36:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7948D30001A2;
	Tue, 26 Aug 2025 19:36:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57QJaHMj257773
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 15:36:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57QJaGTK257772;
	Tue, 26 Aug 2025 15:36:16 -0400
Date: Tue, 26 Aug 2025 15:36:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 09/15] limpathpersist: redesign failed release workaround
Message-ID: <aK4MsHaPBxu_JIxu@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
 <20250710181100.3997759-10-bmarzins@redhat.com>
 <dc941be94accce6ed554eac92f833cbb8e69263b.camel@suse.com>
 <aK0FIY7cVE_LxNMg@redhat.com>
 <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hy352Qp8UX9lAIgMj_LxEGPFnxYo4h47kxum6xqhugw_1756236979
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Aug 26, 2025 at 10:44:22AM +0200, Martin Wilck wrote:
> On Mon, 2025-08-25 at 20:51 -0400, Benjamin Marzinski wrote:
> > On Sun, Aug 24, 2025 at 05:26:50PM +0200, Martin Wilck wrote:
> > 
> > > 
> > > > +	/*
> > > > +	 * Cannot free the reservation because the path that is
> > > > holding it
> > > > +	 * is not usable. Workaround this by:
> > > > +	 * 1. Suspending the device
> > > > +	 * 2. Preempting the reservation to move it to a usable
> > > > path
> > > > +	 *    (this removes the registered keys on all paths
> > > > except
> > > > the
> > > > +	 *    preempting one. Since the device is suspended, no
> > > > IO
> > > > can
> > > > +	 *    go to these unregistered paths and fail).
> > > > +	 * 3. Releasing the reservation on the path that now
> > > > holds
> > > > it.
> > > > +	 * 4. Resuming the device (since it no longer matters
> > > > that
> > > > most of
> > > > +	 *    that paths no longer have a registered key)
> > > > +	 * 5. Reregistering keys on all the paths
> > > > +	 */
> > > > +
> > > > +	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp->alias,
> > > > 0))
> > > > {
> > > > +		condlog(0, "%s: release: failed to suspend dm
> > > > device.",
> > > 
> > > Why do you use dm_simplecmd_noflush() here? Shouldn't queued IO be
> > > flushed from the dm device to avoid it being sent to paths that are
> > > going to be unregistered?
> > > 
> > 
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
> > really necessary when we resize the device, because if we shrink the
> > device, outstanding IO might be outside the new bounds.
> 
> OK, thanks for the clarification. I guess I've never fully understood
> the way queueing works in dm.
> 
> What about queueing in the path devices? We'll be removing registration
> keys, so IO sent by the SCSI layer may end up with RESERVATION CONFLICT
> errors. To my understanding, without the DM_NOFLUSH_FLAG the kernel
> will freeze the queue and flush everything, as if the device was closed
> during shutdown. If DM_NOFLUSH_FLAG is set, this won't happen. What's
> preventing the SCSI layer from sending IO while we're modifying the
> registrations?

In __dm_suspend() we block all new IOs to the dm device here:
https://github.com/torvalds/linux/blob/fab1beda7597fac1cecc01707d55eadb6bbe773c/drivers/md/dm.c#L2955-L2966

Once we know that no new IOs are getting sent to the target, we wait for
all the IOs that were send to the target to get completed by calling
dm_wait_for_completion() here:

https://github.com/torvalds/linux/blob/fab1beda7597fac1cecc01707d55eadb6bbe773c/drivers/md/dm.c#L2973

Any IOs that are currently being sent inside the multipath target will
get handled either while getting mapped or when ending the path IO by
multipath_clone_and_map(), __multipath_map_bio(), multipath_end_io(), or
multipath_end_io_bio(), which will complete the IOs or send them back to
DM core for queueing there (which also satisfies dm_wait_for_completion).

So by the time the suspend command returns, there won't be any IOs in
flight for the the SCSI layer to send to the target, and there can't be
new ones coming in through DM until we resume.

-Ben 
 
> Martin

