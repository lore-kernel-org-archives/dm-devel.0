Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB3F2F7459
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 21:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756242466; cv=none; b=I2Pdt2eO3+WacK4E7lZdHYH3kyBl7Wr863UlUKhjcva5F9PpycnmuYqUCpeH11gdqvVD10KC5B83Xy56jJt+PjQhh7y4cUPJNZBiBusQrNW5SERbCb8gpy6ps25sKf/0yZvKogOWqc95hdpATHdF+xG7eCjq21FxEMwaXVD1gLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756242466; c=relaxed/simple;
	bh=3T/byAsV/OZqYL546BO6mi991WW/8bii+dneJseBD7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=O3rICA0PbI8gwiFHGOBlgZKybEr9ONyMsTqrNPqPSeYZeS8HfIXetgn9ozgnXFYT2LpUhOhx8JiNJl7yxvUz1hspqIa6Y6sXDs/n+KjDH/oItUO8Csqqeqs1RNjPIhfrQRwixvXzHnU1autCNGV0swATH6ffCtrHy3q993+GVDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TVgmcdpB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TVgmcdpB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756242462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ms48NvrwF4pFfrLM/kENxG7YqXpqThblXM6RCopiG9A=;
	b=TVgmcdpB/GfJKr7cos0EDyhvh3SFkTJYZRkL1SNXZYcIZswmNebz0nbxXkidIq26FsZ8Du
	kvJQj1KGmYgmQPIYonnlJIRjwlIpI75acJJbC+ak5nsYBkcvY7tO1nDv9rzUJ2s4j4zdYm
	5K8UVhuenIEaBGOsLTrW+pr03F0xmuI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-xFZAvBWyNoakyAW0WFHt0Q-1; Tue,
 26 Aug 2025 17:07:40 -0400
X-MC-Unique: xFZAvBWyNoakyAW0WFHt0Q-1
X-Mimecast-MFC-AGG-ID: xFZAvBWyNoakyAW0WFHt0Q_1756242459
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5542818003FD;
	Tue, 26 Aug 2025 21:07:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0509A19560AB;
	Tue, 26 Aug 2025 21:07:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57QL7bkX260086
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 17:07:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57QL7bpj260085;
	Tue, 26 Aug 2025 17:07:37 -0400
Date: Tue, 26 Aug 2025 17:07:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 09/15] limpathpersist: redesign failed release workaround
Message-ID: <aK4iGbsHLVXvhs1w@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
 <20250710181100.3997759-10-bmarzins@redhat.com>
 <dc941be94accce6ed554eac92f833cbb8e69263b.camel@suse.com>
 <aK0FIY7cVE_LxNMg@redhat.com>
 <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
 <5261990d40414f56f2476226e0997d728b81648e.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <5261990d40414f56f2476226e0997d728b81648e.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G8us3UXKyHf2dk6Erw4N_5ubOKusBSQXWaPkA9Bhn_I_1756242459
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Aug 26, 2025 at 12:06:50PM +0200, Martin Wilck wrote:
> On Tue, 2025-08-26 at 10:44 +0200, Martin Wilck wrote:
> > On Mon, 2025-08-25 at 20:51 -0400, Benjamin Marzinski wrote:
> > > On Sun, Aug 24, 2025 at 05:26:50PM +0200, Martin Wilck wrote:
> > > 
> > > > 
> > > > > +	/*
> > > > > +	 * Cannot free the reservation because the path that
> > > > > is
> > > > > holding it
> > > > > +	 * is not usable. Workaround this by:
> > > > > +	 * 1. Suspending the device
> > > > > +	 * 2. Preempting the reservation to move it to a
> > > > > usable
> > > > > path
> > > > > +	 *    (this removes the registered keys on all paths
> > > > > except
> > > > > the
> > > > > +	 *    preempting one. Since the device is suspended,
> > > > > no
> > > > > IO
> > > > > can
> > > > > +	 *    go to these unregistered paths and fail).
> > > > > +	 * 3. Releasing the reservation on the path that now
> > > > > holds
> > > > > it.
> > > > > +	 * 4. Resuming the device (since it no longer matters
> > > > > that
> > > > > most of
> > > > > +	 *    that paths no longer have a registered key)
> > > > > +	 * 5. Reregistering keys on all the paths
> > > > > +	 */
> > > > > +
> > > > > +	if (!dm_simplecmd_noflush(DM_DEVICE_SUSPEND, mpp-
> > > > > >alias,
> > > > > 0))
> > > > > {
> > > > > +		condlog(0, "%s: release: failed to suspend dm
> > > > > device.",
> > > > 
> > > > Why do you use dm_simplecmd_noflush() here? Shouldn't queued IO
> > > > be
> > > > flushed from the dm device to avoid it being sent to paths that
> > > > are
> > > > going to be unregistered?
> > > > 
> > > 
> > > I'm pretty certain that DM will still flush all the IO from the
> > > target
> > > to DM core before suspending, even with dm_simplecmd_noflush() set.
> > > In
> > > request based multipath, queued IOs are never stored in the target.
> > > In
> > > bio based multipath, they are, but they will get flushed back up to
> > > DM
> > > core when suspending and queued there. No IO should happen through
> > > the
> > > target after the suspend, until the resume. dm_simplecmd_noflush()
> > > just
> > > keeps multipath from failing any IO that it had queueing, and it's
> > > only
> > > really necessary when we resize the device, because if we shrink
> > > the
> > > device, outstanding IO might be outside the new bounds.
> > 
> > OK, thanks for the clarification. I guess I've never fully understood
> > the way queueing works in dm.
> > 
> > What about queueing in the path devices? We'll be removing
> > registration
> > keys, so IO sent by the SCSI layer may end up with RESERVATION
> > CONFLICT
> > errors. To my understanding, without the DM_NOFLUSH_FLAG the kernel
> > will freeze the queue and flush everything, as if the device was
> > closed
> > during shutdown. If DM_NOFLUSH_FLAG is set, this won't happen. What's
> > preventing the SCSI layer from sending IO while we're modifying the
> > registrations?
> 
> I just re-read commit 2e93ccc1933d ("[PATCH] dm: suspend: add noflush
> pushback"), which explains that the noflush flag is mainly meant for
> handling queue_if_no_path situations, in particular being able to
> reload a queueing multipath map with new paths when all paths have
> failed. That's exactly what you wrote, queueing IO in generic dm rather
> than in the target in order to facilitate map reloads.
> 
> Here we're looking at a very different situation. RESERVATION CONFLICT
> errors won't cause queueing, because the kernel doesn't classify them
> as path errors.

True. But to be pendantic, since we're sending the PR commands directly
to the scsi devices and not through DM, multipath's queueing can't
effect them or be effected by them. DM won't ever see those ioctls or
any errors that occur from them.

> If we need to preempt a reservation held by another
> host, we'd rather not send IO to the device yet. If we have a
> reservation we want to give up, we should make sure to have all
> outstanding IO sent to the storage beforehand. In other situations like
> just registering keys without reservations being present, flushing
> won't be necessary, but it won't hurt either, AFAICS.

The only situations where we will do the suspend is when a multipath
device preempts the reservation key that it is holding, either because
it was explicitly told to (which is something that the SCSI spec
specifically calls out as valid, and is in-fact the only way to change
the reservation type of an existing reservation) or because we failed to
release a reservation, since the path holding the reservation is down.

If we do a flushing suspend, all queued IO will be failed, regardless of
the user's no_path_retry setting. We really don't want to do that unless
we have to (like when we're shrinking the device).

If we still have usable paths to the storage, that IO will get completed
before we suspend. The noflush code only matters if we don't have usable
paths. I would argue that even if we are releasing a reservation, we
want to continue queueing the IO if we end up in a queueing situation.
After we release a reservation, nobody is holding one, and all IO is
allowed. Plus, our paths still have keys registered (aside from that gap
when they are suspended) if another device grabs the reservation. So
there's no point in giving up on the queued IO when we release a
reservation, since we have every reason to believe it will be able to go
through when a path gets restored. 

> I am not sure whether it makes sense to try sending PRIN or PROUT
> commands to maps in queueing state. Depending on the nature of the
> errors that caused the paths to fail, we may or may not be able to send
> this type of commands. PRIN/PROUT must still work for devices in
> STANDBY state, but there are other situations where they wouldn't work,
> or would even hang.
> 
> I tend to think that sending PRIN or PROUT commands to queueing devices
> is an extreme corner case. Perhaps we should just refuse to do this 
> (realizing that we can't avoid a device entering queueing mode while
> we're processing PR commands, but that's an even more extreme corner
> case).

libmpathpersist runs the path checkers before it sends any commands and
doesn't send PRIN or PROUT commands to paths that are down. If there are
no usable paths, libmpathpersist will just return failure. I have no
plans to change any of this. Sure, it's unlikely that we will enter the
queueing state later, while processing the libmpathpersist command. But
the code doesn't get any simpler by doing a flushing suspend instead of
a noflush suspend, and we make sure that we won't fail IOs when
multipath is configured not to, even in this corner case. There are
plenty of places in the multipath code where we suspend (or reload a
table, where we implicitly suspend) knowing there are usable devices,
and we do noflush suspends anyways. I don't see why this is any
different.

And the window where we lose our last path while mpathpersist is running
is small but not super-small, especially in the case where we were told
to PREEMPT our key. libmpathpersist runs the path checkers pretty early.
There is still a bunch of setup and checking stuff it needs to do before
it actually gets around to suspending in preparation for a device
preempting its own key. So if the last path failed between when the path
checkers were run and when we suspend, we could have queued IO. Users
running a PREEMPT or a RELEASE command shouldn't expect it to cause
queued IO to fail if all the paths go down, and I don't see any big
benefit to offset the downside of allowing that possibility.

> 
> If we can assume that the device is not queueing, it might actually be
> better leave the NOFLUSH flag clear, making sure that the queue is 
> frozen and all IO is actually flushed before changing PR keys or
> reservations.

So, I'm assuming that you are talking about the lock_fs() call in
__dm_suspend() that gets skipped when we do a noflush suspend. This is
the only difference I can see that isn't just us opening ourselves up to
unwanted IO errors. And this admittedly will cause the fs to flush IO to
the device, which would be a good thing if we were about to lose our
ability to write to the disk. I have two arguments against caring about
this.

1. sg_persist doesn't force the filesystem to quiesce, so why should
mpathpersist? Nothing that is doing persistent reservations should rely
on that happening when they change a reservation.

2. We won't be losing our ability to write to the disk. Like I said,
there are only two cases where we try to preempt ourselves and trigger
this suspend: either we were explicitly told to preempt ourselves, or we
failed doing a release because the path holding the reservation was
down. In both cases, we keep our registered keys.

The only Persistent reservation types where a path with a registered key
can't do any IO it wants are types 1 (write exclusive) and 3 (exclusive
access), and we should probably disallow those types in libmpathpersist,
because they will never work. With those types of reservations, only the
I_T Nexus holding the reservation is allowed to do IO. This means that
only one path of a multipath device will ever be able to do IO. The
others will fail with RESEVATION CONFLICT errors. 

-Ben

> Am I getting something wrong here?
> 
> Martin

