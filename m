Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88949463
	for <dm-devel@lists.linux.dev>; Tue,  9 Dec 2025 11:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765278084; cv=none; b=AgA+GqLSsj8w//xOJZGRSQjyYgLBasIDFCdBbY0XynQKpSfo1w64yBLV3cs7ftjB6fvisCuuJEszTETmsBj46WZJskEeGXqKTYV4D5R4ujB+YfchIiqvFdEFSlglR+Irylw1T30UIQr4wNGQCgNb4ERfJDVMdQYMxackT4Hp8Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765278084; c=relaxed/simple;
	bh=oUq95maPjjaotG1huwGzdYsVIJgbiqil2Nkky4ojsaI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iKV5c/vrwZk3Q+4Ond2XkbGFbzfU28oJ7LWJI2najvWhnOtqaOzTmWyHZDD1ET6lJsOusO/bQIZJBTL3h0QEmyFMe9NavM/MPLwzFO41vk1MqOoKa26sOd8PgBxaRk67eD+iHZ+ZwWQYQWCOc/72FQQHSVylDNCZybo5gKWgSyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=B29FgzTR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=in2aQN3Q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="B29FgzTR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="in2aQN3Q"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A26F933762;
	Tue,  9 Dec 2025 11:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765278079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTRf2op4uuCN9HgYbcjivbvdAUdmvmMR2j5c2aYQZkY=;
	b=B29FgzTR1IwaX+Xu1f7a6Tst3lEiOWJLZuFeNPZOgrabQ5HW5mF0ip5/o8Gzz5jIiA5rd/
	R0CeLT2RNoUZw9VJjikoNCerkoXahlyOhcMO8X6Xnh6yfqgln8lLXwYT84bQHJfQux6X+M
	Sc/4BGwcjv/f43wzdunIqnTFbEUvSag=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=in2aQN3Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765278078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTRf2op4uuCN9HgYbcjivbvdAUdmvmMR2j5c2aYQZkY=;
	b=in2aQN3QMfpl1/qobnaK4RWzBO3q7E03k1nGnY18eK4h3ENF3v0b/cNz0M+bezcrdKU45q
	Nz7WWn5AO3BrmGRIQEOV4agjUw6h+m2Jz52LfkNjCkizcxv+0gkeOATL/C8RJkwfYx5plm
	bnqrRsswC6g0obBf+l8rwe7AJpRhGHo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 807553EA63;
	Tue,  9 Dec 2025 11:01:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MA1FHn4BOGljEQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 09 Dec 2025 11:01:18 +0000
Message-ID: <fa15be0f83a0146e9e136cf37238684fe7603889.camel@suse.com>
Subject: Re: [PATCH v3] mulitpath-tools Add purge capability to
 multipath-tools
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
	 <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Krishna Kant <krishna.kant@purestorage.com>
Date: Tue, 09 Dec 2025 12:01:17 +0100
In-Reply-To: <aTcnQopkeSCc7AxI@redhat.com>
References: <20251203161933.90318-1-brian@purestorage.com>
	 <aTHiDRgQ2A3rjaKS@redhat.com>
	 <8a93aa8d60eb620469c0e0f4dc535ddc8eb3c7b1.camel@suse.com>
	 <aTcnQopkeSCc7AxI@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: A26F933762
X-Spam-Flag: NO
X-Spam-Score: -4.51

On Mon, 2025-12-08 at 14:30 -0500, Benjamin Marzinski wrote:
> On Mon, Dec 08, 2025 at 01:27:32PM +0100, Martin Wilck wrote:
> > On Thu, 2025-12-04 at 14:33 -0500, Benjamin Marzinski wrote:
> > > On Wed, Dec 03, 2025 at 08:19:33AM -0800, Brian Bunker wrote:
> >=20
> > > How about a simplifying the purge thread slightly. When the
> > > checker
> > > gets
> > > a path it is supposed to purge, it sets purge_path, just like
> > > now. I
> > > don't think we need to track purge_retries at all. When the purge
> > > loop
> > > is triggered, it locks the vecs lock, and finds a single path to
> > > purge,
> > > like now. The only info it needs to save is the udev device (with
> > > a
> > > new
> > > refcount taken like now) and a dup of pp->fd (You need this to
> > > guarantee
> > > that the devnode won't get reused if the device is deleted and a
> > > new
> > > one
> > > is re-added). You could also save the name, but
> > > udev_device_get_devnode() will get it for you.=C2=A0 Like I mentioned
> > > above,
> > > you need to have a pthread cleanup handler that gets run to clean
> > > these
> > > up if they are set and the thread is cancelled, just like how the
> > > vecs
> > > lock is handled. Then purgeloop() clears pp->purge_path, drops
> > > the
> > > vecs
> > > lock, does the sysfs delete, and cleans up the purge_info by
> > > calling
> > > pthread_cleanup_pop(). Finally it loops back to reacquiring the
> > > vecs
> > > lock and finding the next path to delete. I don't really see a
> > > value
> > > in
> > > all the stats tracking. If it goes through all the paths, and
> > > doesn't
> > > find one in need of purging, it waits, just like now.
> >=20
> > I'd go one step further and suggest an approach similar to what we
> > do
> > in the uevent handler, for which we have a separate list of uevents
> > that shares no data with the main multipath threads.
> >=20
> > Roughly like this:
> >=20
> > enum purge_state {
> > =C2=A0=C2=A0=C2=A0 PURGE_REQUESTED =3D 1,
> > =C2=A0=C2=A0=C2=A0 PURGE_DONE,
> > =C2=A0=C2=A0=C2=A0 PURGE_ERROR
> > };
> >=20
> > struct path_to_purge {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head queue;
> > 	struct udev_device *udev; /* one ref taken while on the
> > list
> > */
> > 	int fd;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* dup of pp->fd */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum purge_state state;
> > };
> >=20
> > // global list_head for the queue of paths to be purged.
> > static LIST_HEAD(purge_queue);
> >=20
> > If multipathd detects a path to purge in the checker thread, it
> > allocates and adds a path_to_purge entry with state PURGE_REQUESTED
> > to
> > the queue and triggers the purge thread e.g. with a pthreads
> > condition
> > variable.
> >=20
> > The purge thread then walks through the list (without modifying the
> > list itself), sends a delete request to the kernel and atomically
> > sets
> > the state field to PURGE_DONE when successful.
> >=20
> > multipathd's checker thread walks the list next time and removes
> > entries that have state !=3D PURGE_REQUESTED, closing the fd and
> > unref-
> > ing the struct udev.=C2=A0IOW the resource allocation/freeing for this
> > list
> > and its elements would be handled by the checker alone. The checker
> > would not immediately drop internal references to the path; this
> > would
> > be handled by the remove uevent handler as usual.
> >=20
> > The purge thread would never write to the list, except to the state
> > attribute of list members (which we could protect from being freed
> > via
> > RCU).
> >=20
> > This would make the purge thread almost an independent process.
>=20
> I'm a little confused about this design. Lets say a path gets removed
> while on this list. If the purgeloop doesn't modify the list, then
> how
> does the remove function know that it's safe to remove the item.
> The
> purgeloop could be in the process notifying sysfs right now, making
> use
> of the udev device.

My thinking was that we'd not free the items as long as the state is
PURGE_REQUESTED, and the purge thread wouldn't set that state until
it's done with the item. That should be safe during normal operations.
We could of course add PURGE_INPROGRESS, mainly to protect against
races during shutdown. But AFAICS, for that it should be sufficient to
join the purge thread before freeing the the queue, which we need to do
anyway.

>  Similarly multipathd will change a path's udev
> device when it gets a new uevent. How does it know if it's safe to
> update the pointer on this list.

Good point (not sure how wise it is that multipathd does this, but
that's a different discussion). I believe it's not that bad, though.

The purge thread would have its own reference (the _ref() being done by
the checker before adding the element to the queue), so that the
udev_device won't be freed as long as it's working on it, even if
multipathd unref()s and forgets it. When the purge thread is done with
a path, it drops the ref before changing the state. The checker should
then _not_ drop the ref any more when it frees the queue item. If
multipathd has allocated a different struct udev_device in the
meantime, it will just continue using that. Similar for the dup'd fd.

>  Someone has to unref the purgeloops
> extra ref, and multipathd can't, once it's updated pp->udev and
> forgotten the old value. You might be able to solve this with more
> purge_states so that the purgeloop could signal that it's actually
> working on the device, but I'm pretty sure you'd need actual locking
> to
> avoid races here. Aside from the timing issue, we're adding multiple
> places where multipathd needs to go checking and modifying this list
> as
> part of other actions, which seems like it gets pretty fiddly.

I don't see why this would be necessary. In my mind, we need one extra
function in checker_finished() that takes care of the purge queue.
checker_finished() will be aware of both unavailable and reinstated
paths. This will require some locking around the queue, I guess.

> If we instead say that purgeloop is in charge of cleaning up the
> list,
> there would still need to be locking, because multipathd might want
> to
> take items off the list, if they become reconnected or removed before
> the thread gets around to purging.=C2=A0

Right. That's why I proposed that the purge thread would never modify
the queue.

>  In theory, you could just not modify
> the list in these cases, and just let the purgeloop run on those
> paths,
> but then you would be removing paths that have been reconnected,=C2=A0

This can't be avoided anyway. It's a generic risk of the purging
approach. With any design, there's a time window between the purge
thread being notified about a path and that path actually being purged,
and the path can change state any time during this time window, meaning
that we may be purging a healthy device.=C2=A0

@Brian:=C2=A0AFAICS this problem affects your original design as well. I'm
wondering =E2=80=94 if this happens, would we ever get this path back?

The safest method to protect against that is the purge thread double-
checking the state before deleting, using TUR (or RTPG?). But even that
isn't safe, the path could change state in the tiny time window between
check and deletion. The purge thread would need to check the state
_after_ deleting the Linux SCSI device to avoid a race, and re-probe
the device in that case. But it isn't clear which device that TUR could
be sent to, with the Linux device being deleted. We could delete the
disk first and double-check via the sg device, maybe.

When multipathd reinstates an item, it could walk the list and
atomically change the state to e.g. PURGE_REINSTATED. That would add
complexity; I'm not sure if it would buy us much in terms of safety
against paths being wrongly deleted. It would cover only the time
window between the checker noticing that the path is reinstated and the
deletion, which is smaller than the time window between path checks.

The fact that multipathd will carry around references to a path that
it's going to delete in the purge thread is another issue. But I think
we agree that this is non-fatal, and that future "remove" uevents will
fix this situation.


> and
> possibly keeping a number of references to udev devices and fds for
> paths that are gone (assuming that deleting devices can actually
> block
> for a chunk of time).=C2=A0

That can happen, yes, but do you see a solution that avoids this?
We do need to keep references to the device in some way until we
actually delete it. (Edit: reading further, I saw you other proposal...
see below).

> Also, multipathd would need to check the list so
> paths didn't get added multiple times, if the checker re-ran before
> the
> path was purged.=C2=A0

Right. Not a big issue IMO. The same applies to passing path names or
devt to the purge thread; it's even more difficult in that case, no?

> Again, unless you were fine with keeping unnecessary
> extra references to the device.
>=20
>=20
> My original idea was to try to keep purgeloop from needing to grab
> the
> vecs lock, but I just kept coming up with extra complications that
> this
> would cause. So I settled on something where the normal multipath
> code
> just needs to set a path variable to communicate with the purgeloop,
> and
> the purgeloop just needs to hold the vecs lock while looking through
> the
> path list until it finds a device in need of purging.

Unless I am mistaken, this has similar problems as my approach, just in
different ways. After scanning the pathvec, the purge thread will need
to hold some extra references to the paths it's going to work on, or
copy data structures; otherwise they can go away under it. Just like
above, the paths could be reinstated just after the purge loop is done
reading the list.


> My other option make the purgeloop do much more work. The idea was
> that
> multipathd just put the pathname on a list when it found a
> disconnected
> path, and the purge loop would pull items off that list. This would
> still need locking, but you could probably do it with rcu locking.
> Alternatively, you could use sockets to send the pathnames to the
> purgeloop thread, to avoid locking and possibly make the purgeloop
> it's
> own process completely.

If we do this, I'd vote for dev_t rather that path names. I thought
about it (remember, using a pipe was my first idea) and came to the
conclusion that the socket/pipe approach has no real benefit over the
linked list in shared memory.

As you pointed out yourself, we need to keep the fd open to avoid the
device being replaced by something else in the kernel. If we just path
names or dev_t, that isn't guaranteed any more. Similar for the
udev_device, to me it seems to be a good thing to be sure not to free
it before we know that the path is gone.

That's why I came to think that passing udev_device and fd is safer
than just a name.

> For each path, the purgeloop would
>=20
> 1. open the path device (to make sure it didn't get deleted and
> reused)

What if the device is removed in multipathd before this happens?

> 2. check the path holders to make sure it was part of a multipath
> device

So orphaned devices won't be deleted? AFAICS that's not in Brian's
proposal. But that's orthogonal to the rest of the discussion here.

> 3. run a TUR check on the path to make sure that it was still
> =C2=A0=C2=A0 disconnected
> 4. delete the path, if so.
> 5. close the path device.
>=20
> This is completely disconnected from multipath, minus the pathname
> communication, and should be able to make the right decisions about
> paths that were removed or reconnected, without sharing any resources
> that need cleaing up. It just makes the purgeloop duplicate a bunch
> of
> work that multipathd already did.
>=20
> Thoughts? Am I misunderstanding your design?

I don't think we're that far away from each other. As written above, I
think that handling the resources (udev_device and fd) in multipathd
actually has a few advantages, and that I (perhaps na=C3=AFvely) think it
can be cleanly handled.

My proposal seems to be somewhat between the two you have put forward.
It's not a religious issue to me in general, and I'm certain that my
idea is far from perfect. Just that, as I wrote before, the less the
purge thread accesses multipathd's internal data structures, the
better.

Regards,
Martin
