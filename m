Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171CE29DB64
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766165256; cv=none; b=a+SidTFG/cJmM0MuN/wgeyehi3O+kQeNHvs7fIZ5GjKKeCogGB+FhlGQaYh8swKZ0pFgMgyf324pixgX2Pi7HVNc59FlBb8cbR08U3TcwhhMG0pymq56mIhTjVMwzBs5Mh1D1iEDP/Ceh1OkT/M696N8OrlbjwZfjrzS0qs+tMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766165256; c=relaxed/simple;
	bh=20o2stF5xQy19K/o7Md25t59JAb4OllZsb35x1jPQ4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=EbFJmClH1xQP48fu8P+gaT1xMv5EgOKLKzIf2uoyNSS0+ie4gIpNBK1hojtlPeDAP9iCz3uJRv1VuMv0hYnJfR75l/XnVtm7IKaOtxZ5EKzGgvld9PiRGenW6midDg3GvRftFZwVPYLftizpIagZo5i9c4KJsTGmHCqLgX6+Fx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N40T2NmW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N40T2NmW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766165253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+7NdZHgWQZzXcJhQb/rQOSzAFj79EKKpkHfeTHW4ko=;
	b=N40T2NmWcQ0dSZpTATCSr2c+V8BIadgsVfWOWRZMOCB1yK11CmTkdbYmPtJ4Qfhn5SHXjt
	kL5by5XJ/GgAsCB257MMrT0dotJSvI7EFRe1zfWB02QUC0HlxcaIu5fg1vTPH6xvod8MwA
	MwgSUDI4qvkzPUwmroK/uUZqlU73MB8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-416-dxBKuoRnOG6rTKhXK0zBDQ-1; Fri,
 19 Dec 2025 12:27:30 -0500
X-MC-Unique: dxBKuoRnOG6rTKhXK0zBDQ-1
X-Mimecast-MFC-AGG-ID: dxBKuoRnOG6rTKhXK0zBDQ_1766165249
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A8161956095;
	Fri, 19 Dec 2025 17:27:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88D2619560B4;
	Fri, 19 Dec 2025 17:27:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BJHRRiY2154043
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 12:27:27 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BJHRRZn2154042;
	Fri, 19 Dec 2025 12:27:27 -0500
Date: Fri, 19 Dec 2025 12:27:27 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 18/21] libmpathutil: add wrapper code for libudev
Message-ID: <aUWK_4QoG6JFWIqG@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
 <20251217212113.234959-19-mwilck@suse.com>
 <aUSedLFHsg6xRGRR@redhat.com>
 <af00ff3e05b643a9ed41e23a9f0ba4553d6c2e4b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <af00ff3e05b643a9ed41e23a9f0ba4553d6c2e4b.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s6_yas9P0r8zlSAb7ZvDvsh2QVRJ6o0HyJwsKCEFlN4_1766165249
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Dec 19, 2025 at 09:06:49AM +0100, Martin Wilck wrote:
> On Thu, 2025-12-18 at 19:38 -0500, Benjamin Marzinski wrote:
> > On Wed, Dec 17, 2025 at 10:21:10PM +0100, Martin Wilck wrote:
> > It sounds like
> > the functions themselves are safe to call from multiple threads, as
> > long
> > as they are working on separate data. If they were manipulating
> > global
> > state that wouldn't be true.
> 
> They aren't working on completely separate data, that's the problem. We
> only have one "struct udev", which provides the context for the entire
> operation of libudev in our code. The udev_device structs we use are
> created from that object and link to it internally. Individual
> udev_device structs are linked together e.g. through parent
> releationships. That's why devices obtained by udev_device_get_parent()
> et al. don't need to be unref()'d; they're referenced by their children
> and supposed to be freed together with the last child.
> 
> As the udev operations are opaque, we can't make any assumptions about
> which of the libudev funtions allocate memory, or modify shared data
> structures otherwise. Some properties are fetched "lazily", when the
> user actually needs them, and then cached in libudev. The 2-layer
> architecture with udev_device being actually a shallow wrapper around
> sd_device etc. doesn't make it easier to assess the code flow inside
> the systemd libraries.
> 
> These issues should be fixed by serializing the libudev accesses with a
> mutex. I agree with you that I don't understand what could still go
> wrong if that's done.
> 
> In theory we could have separate "struct udev" devices per thread, but
> keeping these in sync with each other would be a nightmare. We could
> rather give up running multithreaded altogether.

Yeah. I started looking into this, and quickly realized the issue with
the shared struct udev and gave up. I can easily believe that two
threads running at the same time could corrupt a sharted object, and
since everything is linked to one struct udev, there's no way that we
can claim that there can't be shared objects in any of our calls.

I assume that we've likely been pretty safe because most (maybe all) of
our udev device accesses (which is where I assume things could get
corrupted the easiest) have been protected by the vecs lock. But the
purge code is about to add a bunch of unprotected accesses, so clearly
we need some locking there. 
 
> > 
> > > Add wrapper code that wraps all calls to libudev in a critical
> > > section
> > > holding a specific mutex.
> > > 
> > > [1] https://man7.org/linux/man-pages/man3/libudev.3.html
> > 
> > I assume that there must be times when use call a udev outside of the
> > vecs lock. Did you check how often that is? Not that would be great
> > to
> > pile even more work on the vecs lock.
> 
> I wouldn't want to do that. Even if we could create a comprehensive
> assessment now, it could become incorrect any time just by adding an
> innocent libudev call somewhere. Also, I wouldn't want to overload the
> vecs lock further. This code is ugly, but I am pretty sure that the
> mutex operations will be light-weight. The mutex is always at the
> bottom of our call stack, so no ABBA deadlock is possibe.
> 
> I started out by just wrapping some libudev calls, but I soon realized
> that we can't do that without making assumptions about libudev's inner
> workings, which we shouldn't (see above).
> 
> That said, I agree that it's unclear if this is really worth the
> effort. I did it because I was hoping to fix the memory leak issue #129
> with it. But that attempt was unsuccessful. So we have no evidence that
> this serialization fixes any actual issue. multipathd has been using
> libudev from multi-theaded context for 20 years, and we have never
> encountered a problem that was caused by that (or if we did, we didn't
> realize). At least in theory, the mutex could cause a deadlock or
> noticeable delay if some libudev operation blocks or crashes, so the
> change is not without risk. 
> 
> So, consider this part of the patch set an RFC.
> 
> OTOH, the libudev man page is pretty clear about being not thread-safe.

Especially with the purge code adding otherwise unprotected udev device
accesses, I think this is probably a good idea. I don't recall seeing
libudev calls block. I'm betting the real risk is for systems where the
root filesystem is multipathed, and you lose all paths. But that's
always the scary case, and we do enough udev accesses with the vecs lock
held, that if we can get wedged in one, we're likely already gonna get
locked up, even without these mutexes.

-Ben
 
> > Also, git flagged some whitespace errors.
> 
> Ups, will fix.
> 
> Thanks,
> Martin

