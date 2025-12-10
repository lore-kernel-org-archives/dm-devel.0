Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE092C3278
	for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 19:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765396406; cv=none; b=TS4Uly1uOBd8PbkPq5cLrD6YK9wk/MZH51wQULiYDicssn6JsQAvIMjUG4PlB8ejdEKKlj0pWwJo7gcEhn2FH7hlSYfCwJJiI1VLFDmjFs6xonvxBZuMvavZVxo14MD7g//igkmDTzfwBZQ8moCMA3DZsoS++FCqfZ26Dj9859A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765396406; c=relaxed/simple;
	bh=fcVRz0prSZWQSnr+/YqVjGsL29z6wPLv6Xyw/F4KqoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Jba+cW3PKV2GUdMMzptlQVRajEQwtQJrCwAXP/eLoGxnu3lfHzIJYvTbfkC9DYKaux3EDTbp/hBpFFMfZcXjqW2Bl6LKgAls1l5jVyuquup+1vhhRLrS7yaNXN9FwssuqY7ZGlWXhBzm2YA3jLKrlY0wSR33QAt8k2f59Nr20Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJ5bmYUQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJ5bmYUQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765396403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyReqmg6b1i2Mn2TOnhmp2IMBPN6cP/jNoR40z6v5b8=;
	b=JJ5bmYUQVC1sqtr1sOXURESytM2T7DtExh775C9Y6YXYYFVraw8xRKs2dSSHuqgyb2DCH5
	RdISxfEtN4jZ1p/o/WM9HLPF2Se9QjJUdFORsmvw+dnf8iH3O2qzDvfotw86q7uSKv51F2
	8ekhgJ86V3/fe4M3YmXs4wQ80kUkntc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-yC_YiCJnOwuQCxFPDFlv4w-1; Wed,
 10 Dec 2025 14:53:20 -0500
X-MC-Unique: yC_YiCJnOwuQCxFPDFlv4w-1
X-Mimecast-MFC-AGG-ID: yC_YiCJnOwuQCxFPDFlv4w_1765396399
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF7A4180034C;
	Wed, 10 Dec 2025 19:53:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7473C1956095;
	Wed, 10 Dec 2025 19:53:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BAJrH8r1790367
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 14:53:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BAJrHrL1790366;
	Wed, 10 Dec 2025 14:53:17 -0500
Date: Wed, 10 Dec 2025 14:53:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH v3] mulitpath-tools Add purge capability to
 multipath-tools
Message-ID: <aTnPrWww7NEdzR0I@redhat.com>
References: <20251203161933.90318-1-brian@purestorage.com>
 <aTHiDRgQ2A3rjaKS@redhat.com>
 <8a93aa8d60eb620469c0e0f4dc535ddc8eb3c7b1.camel@suse.com>
 <aTcnQopkeSCc7AxI@redhat.com>
 <fa15be0f83a0146e9e136cf37238684fe7603889.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fa15be0f83a0146e9e136cf37238684fe7603889.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8e0Dc16SL8OekXroGQOO817OOPSyWb7WcolJO0uMR5A_1765396399
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Dec 09, 2025 at 12:01:17PM +0100, Martin Wilck wrote:
> On Mon, 2025-12-08 at 14:30 -0500, Benjamin Marzinski wrote:
> > On Mon, Dec 08, 2025 at 01:27:32PM +0100, Martin Wilck wrote:
> > > On Thu, 2025-12-04 at 14:33 -0500, Benjamin Marzinski wrote:
> > > > On Wed, Dec 03, 2025 at 08:19:33AM -0800, Brian Bunker wrote:
> > > 
> > > > How about a simplifying the purge thread slightly. When the
> > > > checker
> > > > gets
> > > > a path it is supposed to purge, it sets purge_path, just like
> > > > now. I
> > > > don't think we need to track purge_retries at all. When the purge
> > > > loop
> > > > is triggered, it locks the vecs lock, and finds a single path to
> > > > purge,
> > > > like now. The only info it needs to save is the udev device (with
> > > > a
> > > > new
> > > > refcount taken like now) and a dup of pp->fd (You need this to
> > > > guarantee
> > > > that the devnode won't get reused if the device is deleted and a
> > > > new
> > > > one
> > > > is re-added). You could also save the name, but
> > > > udev_device_get_devnode() will get it for you.  Like I mentioned
> > > > above,
> > > > you need to have a pthread cleanup handler that gets run to clean
> > > > these
> > > > up if they are set and the thread is cancelled, just like how the
> > > > vecs
> > > > lock is handled. Then purgeloop() clears pp->purge_path, drops
> > > > the
> > > > vecs
> > > > lock, does the sysfs delete, and cleans up the purge_info by
> > > > calling
> > > > pthread_cleanup_pop(). Finally it loops back to reacquiring the
> > > > vecs
> > > > lock and finding the next path to delete. I don't really see a
> > > > value
> > > > in
> > > > all the stats tracking. If it goes through all the paths, and
> > > > doesn't
> > > > find one in need of purging, it waits, just like now.
> > > 
> > > I'd go one step further and suggest an approach similar to what we
> > > do
> > > in the uevent handler, for which we have a separate list of uevents
> > > that shares no data with the main multipath threads.
> > > 
> > > Roughly like this:
> > > 
> > > enum purge_state {
> > >     PURGE_REQUESTED = 1,
> > >     PURGE_DONE,
> > >     PURGE_ERROR
> > > };
> > > 
> > > struct path_to_purge {
> > >         struct list_head queue;
> > > 	struct udev_device *udev; /* one ref taken while on the
> > > list
> > > */
> > > 	int fd;                   /* dup of pp->fd */
> > >         enum purge_state state;
> > > };
> > > 
> > > // global list_head for the queue of paths to be purged.
> > > static LIST_HEAD(purge_queue);
> > > 
> > > If multipathd detects a path to purge in the checker thread, it
> > > allocates and adds a path_to_purge entry with state PURGE_REQUESTED
> > > to
> > > the queue and triggers the purge thread e.g. with a pthreads
> > > condition
> > > variable.
> > > 
> > > The purge thread then walks through the list (without modifying the
> > > list itself), sends a delete request to the kernel and atomically
> > > sets
> > > the state field to PURGE_DONE when successful.
> > > 
> > > multipathd's checker thread walks the list next time and removes
> > > entries that have state != PURGE_REQUESTED, closing the fd and
> > > unref-
> > > ing the struct udev. IOW the resource allocation/freeing for this
> > > list
> > > and its elements would be handled by the checker alone. The checker
> > > would not immediately drop internal references to the path; this
> > > would
> > > be handled by the remove uevent handler as usual.
> > > 
> > > The purge thread would never write to the list, except to the state
> > > attribute of list members (which we could protect from being freed
> > > via
> > > RCU).
> > > 
> > > This would make the purge thread almost an independent process.
> > 
> > I'm a little confused about this design. Lets say a path gets removed
> > while on this list. If the purgeloop doesn't modify the list, then
> > how
> > does the remove function know that it's safe to remove the item.
> > The
> > purgeloop could be in the process notifying sysfs right now, making
> > use
> > of the udev device.
> 
> My thinking was that we'd not free the items as long as the state is
> PURGE_REQUESTED, and the purge thread wouldn't set that state until
> it's done with the item. That should be safe during normal operations.
> We could of course add PURGE_INPROGRESS, mainly to protect against
> races during shutdown. But AFAICS, for that it should be sufficient to
> join the purge thread before freeing the the queue, which we need to do
> anyway.
> 
> >  Similarly multipathd will change a path's udev
> > device when it gets a new uevent. How does it know if it's safe to
> > update the pointer on this list.
> 
> Good point (not sure how wise it is that multipathd does this, but
> that's a different discussion). I believe it's not that bad, though.
> 
> The purge thread would have its own reference (the _ref() being done by
> the checker before adding the element to the queue), so that the
> udev_device won't be freed as long as it's working on it, even if
> multipathd unref()s and forgets it. When the purge thread is done with
> a path, it drops the ref before changing the state. The checker should
> then _not_ drop the ref any more when it frees the queue item. If
> multipathd has allocated a different struct udev_device in the
> meantime, it will just continue using that. Similar for the dup'd fd.
> 
> >  Someone has to unref the purgeloops
> > extra ref, and multipathd can't, once it's updated pp->udev and
> > forgotten the old value. You might be able to solve this with more
> > purge_states so that the purgeloop could signal that it's actually
> > working on the device, but I'm pretty sure you'd need actual locking
> > to
> > avoid races here. Aside from the timing issue, we're adding multiple
> > places where multipathd needs to go checking and modifying this list
> > as
> > part of other actions, which seems like it gets pretty fiddly.
> 
> I don't see why this would be necessary. In my mind, we need one extra
> function in checker_finished() that takes care of the purge queue.
> checker_finished() will be aware of both unavailable and reinstated
> paths. This will require some locking around the queue, I guess.
> 
> > If we instead say that purgeloop is in charge of cleaning up the
> > list,
> > there would still need to be locking, because multipathd might want
> > to
> > take items off the list, if they become reconnected or removed before
> > the thread gets around to purging. 
> 
> Right. That's why I proposed that the purge thread would never modify
> the queue.
> 
> >  In theory, you could just not modify
> > the list in these cases, and just let the purgeloop run on those
> > paths,
> > but then you would be removing paths that have been reconnected, 
> 
> This can't be avoided anyway. It's a generic risk of the purging
> approach. With any design, there's a time window between the purge
> thread being notified about a path and that path actually being purged,
> and the path can change state any time during this time window, meaning
> that we may be purging a healthy device. 
> 
> @Brian: AFAICS this problem affects your original design as well. I'm
> wondering — if this happens, would we ever get this path back?
> 
> The safest method to protect against that is the purge thread double-
> checking the state before deleting, using TUR (or RTPG?). But even that
> isn't safe, the path could change state in the tiny time window between
> check and deletion. The purge thread would need to check the state
> _after_ deleting the Linux SCSI device to avoid a race, and re-probe
> the device in that case. But it isn't clear which device that TUR could
> be sent to, with the Linux device being deleted. We could delete the
> disk first and double-check via the sg device, maybe.
> 
> When multipathd reinstates an item, it could walk the list and
> atomically change the state to e.g. PURGE_REINSTATED. That would add
> complexity; I'm not sure if it would buy us much in terms of safety
> against paths being wrongly deleted. It would cover only the time
> window between the checker noticing that the path is reinstated and the
> deletion, which is smaller than the time window between path checks.
> 
> The fact that multipathd will carry around references to a path that
> it's going to delete in the purge thread is another issue. But I think
> we agree that this is non-fatal, and that future "remove" uevents will
> fix this situation.
> 
> 
> > and
> > possibly keeping a number of references to udev devices and fds for
> > paths that are gone (assuming that deleting devices can actually
> > block
> > for a chunk of time). 
> 
> That can happen, yes, but do you see a solution that avoids this?
> We do need to keep references to the device in some way until we
> actually delete it. (Edit: reading further, I saw you other proposal...
> see below).
> 
> > Also, multipathd would need to check the list so
> > paths didn't get added multiple times, if the checker re-ran before
> > the
> > path was purged. 
> 
> Right. Not a big issue IMO. The same applies to passing path names or
> devt to the purge thread; it's even more difficult in that case, no?
> 
> > Again, unless you were fine with keeping unnecessary
> > extra references to the device.
> > 
> > 
> > My original idea was to try to keep purgeloop from needing to grab
> > the
> > vecs lock, but I just kept coming up with extra complications that
> > this
> > would cause. So I settled on something where the normal multipath
> > code
> > just needs to set a path variable to communicate with the purgeloop,
> > and
> > the purgeloop just needs to hold the vecs lock while looking through
> > the
> > path list until it finds a device in need of purging.
> 
> Unless I am mistaken, this has similar problems as my approach, just in
> different ways. After scanning the pathvec, the purge thread will need
> to hold some extra references to the paths it's going to work on, or
> copy data structures; otherwise they can go away under it. Just like
> above, the paths could be reinstated just after the purge loop is done
> reading the list.

Yes. It would still need to hold a udev ref and a fd dup, that it would
clean up after doing the purge.

I think I was assuming that your fix was more complicated than you
intended, with multipathd removing paths from the list if the path got
removed. But if you don't care about paths being on the list after
multipathd removed them, your can ignore my objections.

The biggest difference between your method and mine is that in exchange
for needing to grab the vecs lock in purge thread, if devices get freed
or restored by multipathd after they've been marked for purging, you
won't bother trying to purge them. Also, you don't have to worry about
putting a device on the list multiple times.

While both methods are race-y, if you find the path to purge while
holding the vecs lock, and then unlock and immediately purge, it's very
unlikely that multipathd freed or restored the path in that gap. If you
put the path on a list and it sits there while the purge loop does
blocking operations until it gets to the path, there's a much bigger gap
where the path state can change.

Also, you do need locking between the checker modifying the list, and
the purge thread reading it, but if you're willing to duplicate the list
whever you add or remove from it, you could use rcu locking, like you
metioned.

But none of these issue is that important. Either method should work
fine.

> 
> > My other option make the purgeloop do much more work. The idea was
> > that
> > multipathd just put the pathname on a list when it found a
> > disconnected
> > path, and the purge loop would pull items off that list. This would
> > still need locking, but you could probably do it with rcu locking.
> > Alternatively, you could use sockets to send the pathnames to the
> > purgeloop thread, to avoid locking and possibly make the purgeloop
> > it's
> > own process completely.
> 
> If we do this, I'd vote for dev_t rather that path names. I thought
> about it (remember, using a pipe was my first idea) and came to the
> conclusion that the socket/pipe approach has no real benefit over the
> linked list in shared memory.
> 
> As you pointed out yourself, we need to keep the fd open to avoid the
> device being replaced by something else in the kernel. If we just path
> names or dev_t, that isn't guaranteed any more. Similar for the
> udev_device, to me it seems to be a good thing to be sure not to free
> it before we know that the path is gone.
> 
> That's why I came to think that passing udev_device and fd is safer
> than just a name.
> 
> > For each path, the purgeloop would
> > 
> > 1. open the path device (to make sure it didn't get deleted and
> > reused)
> 
> What if the device is removed in multipathd before this happens?
> 
> > 2. check the path holders to make sure it was part of a multipath
> > device
> 
> So orphaned devices won't be deleted? AFAICS that's not in Brian's
> proposal. But that's orthogonal to the rest of the discussion here.
> 
> > 3. run a TUR check on the path to make sure that it was still
> >    disconnected
> > 4. delete the path, if so.
> > 5. close the path device.
> > 
> > This is completely disconnected from multipath, minus the pathname
> > communication, and should be able to make the right decisions about
> > paths that were removed or reconnected, without sharing any resources
> > that need cleaing up. It just makes the purgeloop duplicate a bunch
> > of
> > work that multipathd already did.
> > 
> > Thoughts? Am I misunderstanding your design?
> 
> I don't think we're that far away from each other. As written above, I
> think that handling the resources (udev_device and fd) in multipathd
> actually has a few advantages, and that I (perhaps naïvely) think it
> can be cleanly handled.
> 
> My proposal seems to be somewhat between the two you have put forward.
> It's not a religious issue to me in general, and I'm certain that my
> idea is far from perfect. Just that, as I wrote before, the less the
> purge thread accesses multipathd's internal data structures, the
> better.

Yep. Now that I understand your proposal, I don't think it really
matters how we solve this.

-Ben
 
> Regards,
> Martin

