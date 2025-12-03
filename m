Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054F33B6EA
	for <dm-devel@lists.linux.dev>; Wed,  3 Dec 2025 19:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764790629; cv=none; b=PscubBPuV8kzSBTY4+S28kJWjkL/l1Q+KDLC1R880Wc3ncClC6KokvfV/v6o+dazX/bW30gIernwRvSc4BrossyqiiEj/pYVNIs9jBy18DjafAYnZsGUELzx46cussdN9uY/XZaORFz5j4LSpymTrbMRdwyKm4EJ+JpColS9O0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764790629; c=relaxed/simple;
	bh=sPYNV3nB3twAvagRfSEtCgx0s6/K3mB6R2J0jU0V5Ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=cr8Orlh40yuFeqdygr1TBtWlwyweI1qYjnugODleqDlii0SKawr3p+M0XbnQ0gU8sEArJb75DVCjWN2chhQXDPyoZyFvfZ5L7GrDYWODNOAnOC7aoZKwjYrVrrcTvm5ONOaZYgS2QjCezoN6llHMQW3zed6mqi6ZVayKR8w1PMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SKqZBDPe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SKqZBDPe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764790625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I6DxD6i1pa8W/Ta02UuuOJRXlZiH2j4U/UH6qiI8vWw=;
	b=SKqZBDPewNEaZZqfzOzRdQFAOvrPb2RX5MXDXqY9cmHTn0RCBw4JnhptaGMyjwYLo7bULV
	2h7phTn1BTOMVG3wmnxcH7PAcItrf4QZfavU+AVLrRapk8eH7xT4CMvHNyCqnCS93CTC9+
	qV3wo9f6f8qFgeyBXLS1adLwNcYEl+E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-Nwu1__C9Pj237amh3MrBaQ-1; Wed,
 03 Dec 2025 14:37:04 -0500
X-MC-Unique: Nwu1__C9Pj237amh3MrBaQ-1
X-Mimecast-MFC-AGG-ID: Nwu1__C9Pj237amh3MrBaQ_1764790623
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CF5E1800642;
	Wed,  3 Dec 2025 19:37:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E19D030001A2;
	Wed,  3 Dec 2025 19:37:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B3Jb1Jb1500730
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Dec 2025 14:37:01 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B3Jb1i11500729;
	Wed, 3 Dec 2025 14:37:01 -0500
Date: Wed, 3 Dec 2025 14:37:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] Add purge capability to multipath-tools
Message-ID: <aTCRXZLVlq8me1EO@redhat.com>
References: <20251113184317.55038-1-brian@purestorage.com>
 <aSC4YOZjDiIZadJ4@redhat.com>
 <CAHZQxyLJMZ6VpFFj1D8TLECBrQ7_digxT1BS1Dk68LNqTzV5EQ@mail.gmail.com>
 <aSS75Rt0f4fFbUUA@redhat.com>
 <793c255dbd79b17a2a3e9e4f781f6efa5fabc622.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <793c255dbd79b17a2a3e9e4f781f6efa5fabc622.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bf7sJbYnQQdWiLaJqB0OuoDkrjrPpgXpYNMwJj2Tfnc_1764790623
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2025 at 12:31:12PM +0100, Martin Wilck wrote:
> On Mon, 2025-11-24 at 15:11 -0500, Benjamin Marzinski wrote:
> > On Fri, Nov 21, 2025 at 02:35:23PM -0800, Brian Bunker wrote:
> > 
> > > 
> > > I added the purge thread because I didn't want to starve the
> > > checker thread at a large disconnect volume scale. I noticed
> > > that the number of devices if I purged inline with the check that
> > > it didn't scale linearly after a point and seemed to be
> > > significantly
> > > starving the checker thread. Doing the purge in another thread
> > > seemed to relieve that pressure.
> > 
> > That might be because the check thread has safeguards to try to avoid
> > starving the other threads. Since a lot of multipathd's work is gated
> > by
> > the vecs lock, there's only so much parallelism that can happen with
> > multiple threads. If deleting the devices is taking a long time, it
> > might
> > be better for this to get interrupted, so that other threads can run.
> > 
> > Since purging the paths is fairly low priority, we could continue to
> > run
> > it in its own thread, but instead of running through all the devices
> > at
> > once, purgeloop could lock the vecs->lock, handle one device, and
> > then
> > unlock and loop. This means it would need to search through the list
> > from the start each time it regrabbed the lock, since the list could
> > have changed while it wasn't holding it. When purgeloop makes it all
> > the
> > way through the list without finding any paths that are due for a
> > delete
> > attempt, it can sleep or block waiting for more paths.
> > 
> > This would mean that paths would need to remember if they had already
> > been handled in a cycle. That could be done by purgeloop keeping
> > track
> > of which cycle it was on, and the paths storing the cycle number
> > whenever they were checked.
> 
> As I wrote in my other post, wish that this thread wouldn't hold the
> vecs lock at all. multipathd could simply use a pipe to write dev_t's
> of to-be-purged paths to the purge thread (or process :-) ).

This seems like a good idea. Obviously, writing to sysfs while the vecs
lock is being held means that multipath will continue to have that scsi
device open, so there's no chance of the device name getting reused if
the device is removed from the system. But this other thread/process
could simply open the scsi device, double check that it's still
disconnected, write to sysfs, and then close the device. That would
offer the same guarantee, without the need to interact with anything
else.
 
> Martin

