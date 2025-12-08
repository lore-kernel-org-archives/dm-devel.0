Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70701534EC
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765222220; cv=none; b=CPQMW7w8GIpH4XbTmJ5sYlfus926lt3cA9iG8103e8oxBuUqwcLvZb9RE+0JSO+V61Qk9pjyDeOXiZ9mpbsv5GYhngyVSTc17AIIXlND51oOYgyGlBK2E2dqssstYP7/WACTXPu03L+eQJAED1GdRNeF+HVarSWEcoC9HzEjlzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765222220; c=relaxed/simple;
	bh=nQvRRKid9XfwtE0AP1OBBErmAQ7XF8d/+g6EjsqQ0SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=J5O9AZXiKoT9SwFLcWh1CNeeZKDZ99cSpd4QfmjLbwkFbheormurBM6CfqUmzg4ByKequmB7ZdFYjbR7Be8ebZlm04nanS9lvbH9VNXzrrukxMpEXS9TJfMuv+/lerYvVauo9wkxxupjDr4IQlmQPPk9q76mihTiKPud4veXWJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDubBlWP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDubBlWP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765222217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IILdOtg9q1qS4u+Zz8CzXyjTQ/FxGm6zcSuR6vZ1UhI=;
	b=HDubBlWPPdxwRC3HD4dhy1R0Kg42PtHHS5dca3hgu1sn8bTg/49LKGIGSCzFJ1g6RcgYSl
	mkcGWtP1PtaBJ0Cu7ABPanF0G7l2BnN/WhNnoYPh6Gq4vZZKron2eKkiVKoG8CMokW1Jf+
	jsLKGLyVrL3PkZ6h5gQyo+/o3u+Pt9E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-LIEoMTP1PA2xa1oB62rppQ-1; Mon,
 08 Dec 2025 14:30:14 -0500
X-MC-Unique: LIEoMTP1PA2xa1oB62rppQ-1
X-Mimecast-MFC-AGG-ID: LIEoMTP1PA2xa1oB62rppQ_1765222213
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECCE4195606D;
	Mon,  8 Dec 2025 19:30:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FA101800346;
	Mon,  8 Dec 2025 19:30:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B8JUBif1705112
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Dec 2025 14:30:11 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B8JUAhZ1705111;
	Mon, 8 Dec 2025 14:30:10 -0500
Date: Mon, 8 Dec 2025 14:30:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH v3] mulitpath-tools Add purge capability to
 multipath-tools
Message-ID: <aTcnQopkeSCc7AxI@redhat.com>
References: <20251203161933.90318-1-brian@purestorage.com>
 <aTHiDRgQ2A3rjaKS@redhat.com>
 <8a93aa8d60eb620469c0e0f4dc535ddc8eb3c7b1.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8a93aa8d60eb620469c0e0f4dc535ddc8eb3c7b1.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: khHQs5HHx-qTyAaNELgBkunH2s9p7dUdDKFPDrBDA6w_1765222213
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Dec 08, 2025 at 01:27:32PM +0100, Martin Wilck wrote:
> On Thu, 2025-12-04 at 14:33 -0500, Benjamin Marzinski wrote:
> > On Wed, Dec 03, 2025 at 08:19:33AM -0800, Brian Bunker wrote:
> 
> > How about a simplifying the purge thread slightly. When the checker
> > gets
> > a path it is supposed to purge, it sets purge_path, just like now. I
> > don't think we need to track purge_retries at all. When the purge
> > loop
> > is triggered, it locks the vecs lock, and finds a single path to
> > purge,
> > like now. The only info it needs to save is the udev device (with a
> > new
> > refcount taken like now) and a dup of pp->fd (You need this to
> > guarantee
> > that the devnode won't get reused if the device is deleted and a new
> > one
> > is re-added). You could also save the name, but
> > udev_device_get_devnode() will get it for you.  Like I mentioned
> > above,
> > you need to have a pthread cleanup handler that gets run to clean
> > these
> > up if they are set and the thread is cancelled, just like how the
> > vecs
> > lock is handled. Then purgeloop() clears pp->purge_path, drops the
> > vecs
> > lock, does the sysfs delete, and cleans up the purge_info by calling
> > pthread_cleanup_pop(). Finally it loops back to reacquiring the vecs
> > lock and finding the next path to delete. I don't really see a value
> > in
> > all the stats tracking. If it goes through all the paths, and doesn't
> > find one in need of purging, it waits, just like now.
> 
> I'd go one step further and suggest an approach similar to what we do
> in the uevent handler, for which we have a separate list of uevents
> that shares no data with the main multipath threads.
> 
> Roughly like this:
> 
> enum purge_state {
>     PURGE_REQUESTED = 1,
>     PURGE_DONE,
>     PURGE_ERROR
> };
> 
> struct path_to_purge {
>         struct list_head queue;
> 	struct udev_device *udev; /* one ref taken while on the list
> */
> 	int fd;                   /* dup of pp->fd */
>         enum purge_state state;
> };
> 
> // global list_head for the queue of paths to be purged.
> static LIST_HEAD(purge_queue);
> 
> If multipathd detects a path to purge in the checker thread, it
> allocates and adds a path_to_purge entry with state PURGE_REQUESTED to
> the queue and triggers the purge thread e.g. with a pthreads condition
> variable.
> 
> The purge thread then walks through the list (without modifying the
> list itself), sends a delete request to the kernel and atomically sets
> the state field to PURGE_DONE when successful.
> 
> multipathd's checker thread walks the list next time and removes
> entries that have state != PURGE_REQUESTED, closing the fd and unref-
> ing the struct udev. IOW the resource allocation/freeing for this list
> and its elements would be handled by the checker alone. The checker
> would not immediately drop internal references to the path; this would
> be handled by the remove uevent handler as usual.
> 
> The purge thread would never write to the list, except to the state
> attribute of list members (which we could protect from being freed via
> RCU).
> 
> This would make the purge thread almost an independent process.

I'm a little confused about this design. Lets say a path gets removed
while on this list. If the purgeloop doesn't modify the list, then how
does the remove function know that it's safe to remove the item. The
purgeloop could be in the process notifying sysfs right now, making use
of the udev device. Similarly multipathd will change a path's udev
device when it gets a new uevent. How does it know if it's safe to
update the pointer on this list. Someone has to unref the purgeloops
extra ref, and multipathd can't, once it's updated pp->udev and
forgotten the old value. You might be able to solve this with more
purge_states so that the purgeloop could signal that it's actually
working on the device, but I'm pretty sure you'd need actual locking to
avoid races here. Aside from the timing issue, we're adding multiple
places where multipathd needs to go checking and modifying this list as
part of other actions, which seems like it gets pretty fiddly.

If we instead say that purgeloop is in charge of cleaning up the list,
there would still need to be locking, because multipathd might want to
take items off the list, if they become reconnected or removed before
the thread gets around to purging.  In theory, you could just not modify
the list in these cases, and just let the purgeloop run on those paths,
but then you would be removing paths that have been reconnected, and
possibly keeping a number of references to udev devices and fds for
paths that are gone (assuming that deleting devices can actually block
for a chunk of time). Also, multipathd would need to check the list so
paths didn't get added multiple times, if the checker re-ran before the
path was purged. Again, unless you were fine with keeping unnecessary
extra references to the device.

My original idea was to try to keep purgeloop from needing to grab the
vecs lock, but I just kept coming up with extra complications that this
would cause. So I settled on something where the normal multipath code
just needs to set a path variable to communicate with the purgeloop, and
the purgeloop just needs to hold the vecs lock while looking through the
path list until it finds a device in need of purging.

My other option make the purgeloop do much more work. The idea was that
multipathd just put the pathname on a list when it found a disconnected
path, and the purge loop would pull items off that list. This would
still need locking, but you could probably do it with rcu locking.
Alternatively, you could use sockets to send the pathnames to the
purgeloop thread, to avoid locking and possibly make the purgeloop it's
own process completely.

For each path, the purgeloop would

1. open the path device (to make sure it didn't get deleted and reused)
2. check the path holders to make sure it was part of a multipath device
3. run a TUR check on the path to make sure that it was still
   disconnected
4. delete the path, if so.
5. close the path device.

This is completely disconnected from multipath, minus the pathname
communication, and should be able to make the right decisions about
paths that were removed or reconnected, without sharing any resources
that need cleaing up. It just makes the purgeloop duplicate a bunch of
work that multipathd already did.

Thoughts? Am I misunderstanding your design?

-Ben

> Opinions?
> 
> Martin

