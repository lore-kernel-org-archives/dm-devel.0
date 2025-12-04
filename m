Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A694C6D
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 20:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764878636; cv=none; b=dgryyWvSz4FmiHwLHM4HVNKeJjsK4pd8a6ILwfya4hvJkp2wQc/Lz/S1IsC6fIa5tPjn3+hKv7aWUYj4BanssGJB1sxVwfUPWJIHy0uZH8kQPKHac/jvOxJP8T1/pTebKukOamNMwM2bAVQjVwYJlUHwcZqh9Nh75p7822QxIRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764878636; c=relaxed/simple;
	bh=bgAcao6i3TYMJ7fhRh5qZdg+3G0lXXhQ5PK0d07B+Sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dyjCaHvIF8wqNjQ2j6agRAR+42hJynxzymIhS+WPwvl+5uMPSBMXZz+CgW5O373I6mwFnLtiaUbcoyMmVU+s999Hg2Zer/bQerJlKB1hwM2fuqIZs2cvmGi/tqt92OXIupT+b1Kx70utwVqQKkJ7j8UPTifP1xJCOognapINpCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gmK1qt3P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gmK1qt3P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764878633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Q6SRarXcOX8HbSdIu/5Uw2egzGysOaXZpC1lkpOZ9A=;
	b=gmK1qt3Pzp0Owimrc/hONjykR7SxsJ36zQAvr3zPUN+z8l6QcfNRcEjYOsJbSnnIEUFsRX
	7D48Bo7dnZTD+qNC8qBCSxfxM1YnY31LPMGYGe0tZfruvohLSfYIHPkd88cB1/oY4S45gN
	VhoWk8aBJmrmdzwZEg8ZfGweSAHuuMg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-T4-d3DbxMyibIZSC-_qB8Q-1; Thu,
 04 Dec 2025 15:03:51 -0500
X-MC-Unique: T4-d3DbxMyibIZSC-_qB8Q-1
X-Mimecast-MFC-AGG-ID: T4-d3DbxMyibIZSC-_qB8Q_1764878630
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B354919560A1;
	Thu,  4 Dec 2025 20:03:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E2C219560B4;
	Thu,  4 Dec 2025 20:03:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B4K3nOY1546422
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 4 Dec 2025 15:03:49 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B4K3n521546421;
	Thu, 4 Dec 2025 15:03:49 -0500
Date: Thu, 4 Dec 2025 15:03:49 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Martin Wilck <martin.wilck@suse.com>, dm-devel@lists.linux.dev,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] Add purge capability to multipath-tools
Message-ID: <aTHpJVhhDKrJxhBU@redhat.com>
References: <20251113184317.55038-1-brian@purestorage.com>
 <aSC4YOZjDiIZadJ4@redhat.com>
 <CAHZQxyLJMZ6VpFFj1D8TLECBrQ7_digxT1BS1Dk68LNqTzV5EQ@mail.gmail.com>
 <aSS75Rt0f4fFbUUA@redhat.com>
 <793c255dbd79b17a2a3e9e4f781f6efa5fabc622.camel@suse.com>
 <aTCRXZLVlq8me1EO@redhat.com>
 <CAHZQxyJ0Y7Tx4UC4je40s6dQKDE942qo-OwSpnFUeJcocozL-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAHZQxyJ0Y7Tx4UC4je40s6dQKDE942qo-OwSpnFUeJcocozL-Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hvgwVygGhCbprWRJzmCXdtpK1eg3blOGrm5SmRwMbDA_1764878630
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 04, 2025 at 08:55:58AM -0800, Brian Bunker wrote:
> On Wed, Dec 3, 2025 at 11:37 AM Benjamin Marzinski <bmarzins@redhat.com> wrote:
> >
> > On Thu, Nov 27, 2025 at 12:31:12PM +0100, Martin Wilck wrote:
> > > On Mon, 2025-11-24 at 15:11 -0500, Benjamin Marzinski wrote:
> > > > On Fri, Nov 21, 2025 at 02:35:23PM -0800, Brian Bunker wrote:
> > > >
> > > > >
> > > > > I added the purge thread because I didn't want to starve the
> > > > > checker thread at a large disconnect volume scale. I noticed
> > > > > that the number of devices if I purged inline with the check that
> > > > > it didn't scale linearly after a point and seemed to be
> > > > > significantly
> > > > > starving the checker thread. Doing the purge in another thread
> > > > > seemed to relieve that pressure.
> > > >
> > > > That might be because the check thread has safeguards to try to avoid
> > > > starving the other threads. Since a lot of multipathd's work is gated
> > > > by
> > > > the vecs lock, there's only so much parallelism that can happen with
> > > > multiple threads. If deleting the devices is taking a long time, it
> > > > might
> > > > be better for this to get interrupted, so that other threads can run.
> > > >
> > > > Since purging the paths is fairly low priority, we could continue to
> > > > run
> > > > it in its own thread, but instead of running through all the devices
> > > > at
> > > > once, purgeloop could lock the vecs->lock, handle one device, and
> > > > then
> > > > unlock and loop. This means it would need to search through the list
> > > > from the start each time it regrabbed the lock, since the list could
> > > > have changed while it wasn't holding it. When purgeloop makes it all
> > > > the
> > > > way through the list without finding any paths that are due for a
> > > > delete
> > > > attempt, it can sleep or block waiting for more paths.
> > > >
> > > > This would mean that paths would need to remember if they had already
> > > > been handled in a cycle. That could be done by purgeloop keeping
> > > > track
> > > > of which cycle it was on, and the paths storing the cycle number
> > > > whenever they were checked.
> > >
> > > As I wrote in my other post, wish that this thread wouldn't hold the
> > > vecs lock at all. multipathd could simply use a pipe to write dev_t's
> > > of to-be-purged paths to the purge thread (or process :-) ).
> >
> > This seems like a good idea. Obviously, writing to sysfs while the vecs
> > lock is being held means that multipath will continue to have that scsi
> > device open, so there's no chance of the device name getting reused if
> > the device is removed from the system. But this other thread/process
> > could simply open the scsi device, double check that it's still
> > disconnected, write to sysfs, and then close the device. That would
> > offer the same guarantee, without the need to interact with anything
> > else.
> >
> > > Martin
> >
> Martin,

Actually, this wasn't Martin, it was me.

> If you look at the v3 implementation that I sent up yesterday, you will
> see we are no longer holding the vecs lock during the sysfs delete
> operation. We also made the delete operation non-blocking.
> 
> The two places in the purgeloop where we do hold the lock are for two
> very short operations:
> 
> 1. We scan the vector to find one path that needs purging. We update
> pp->purge_cycle and increment the retry counter pp->purge_retries++.
> Then we copy the necessary data for the purge into the purge_info
> data structure. Then we release the lock. There shouldn't be much
> contention here with these operations.
> 
> 2. We also re-acquire the lock to make sure the path still exists in
> the pathvec and clear the purge_path and reset purge_retries. This should
> also be very fast.
> 
> We can't take the approach to open the device since it is disconnected.
> I think it will just fail or hang. We have the udev reference to make sure
> the device object is alive and not freed underneath us.

That makes sense. Unfortunately, I checked, and holding a reference on
the udev device does not keep the scsi device from being deleted, or a
new device from being created with the same devnode. 

My comments on your v3 patch talk about using a dup() to copy the
existing pp->fd to deal with this, which should work, regardless of the
path state.

-Ben
 
> Thanks,
> Brian
> 
> -- 
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com

