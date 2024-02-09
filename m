Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7F6F06C
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707495332; cv=none; b=OxheXlhhv5b0rBuYp/o3K90cpoaZCZKVVivy5qBCctUEbCrvufh4h8lUQvtIQ/EJove/BgH0My/qboFHpTZ46Y/E24qrn5f1JupXcCfaWaiaeWcbAsH+GYy4c5z05YqegS9k6B7ScAniO9PJm5+1B+cMJUUkY6qigTW3qq53qfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707495332; c=relaxed/simple;
	bh=cjEzihlfFpCHufP1Rt1lHKcgDNjqxQgGdS7EX/F1z5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VsWGf94IPP6YJ2DJ+ho7uff3GTSZyQA53dWlJmIBcl4z2WmXhfd8gXGbvK8qR6KeG5fTdRpZeAOWilFJUXvwXweFmSkMNxaqTr1X1RIoNFQaywpnEtDlu40Bqn7NVZm1lQvkWghnCD5OnV/kAiY1JJueFD+8k4Nxegbg5MkVTj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XCZjhUJp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XCZjhUJp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707495329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vCoH5GbZFYm5seoWMRWg+T4PnGNfKUX4qDdjJ58QCNM=;
	b=XCZjhUJpBymGWR5howw9Pj3pTq0quTd8eBYmNzzKr8Z8rI+0VgGFqm9vplLAhSNkyIZWf9
	+8uaYCpKIIqOzm5IU9T/xzbq02hzyg0uf/JA9GhqXLdrqQtJQMVoOLxv+Qn8ADQ7K/arRF
	1jBPQXYmyom4104z10txVVe3hJjIsVc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-KUTs_p6KNEyyXNSaLa2w_w-1; Fri,
 09 Feb 2024 11:15:25 -0500
X-MC-Unique: KUTs_p6KNEyyXNSaLa2w_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DEA43830089;
	Fri,  9 Feb 2024 16:15:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 360C72166B31;
	Fri,  9 Feb 2024 16:15:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 419GFORw346580
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Feb 2024 11:15:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 419GFOfP346579;
	Fri, 9 Feb 2024 11:15:24 -0500
Date: Fri, 9 Feb 2024 11:15:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 4/6] 11-dm-mpath.rules: handle reloads during coldplug
 events
Message-ID: <ZcZPnHkOJUWrvp1e@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-5-mwilck@suse.com>
 <ZcV5-kpJ2ZylDGBP@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <7fc6996c93def8360d27c60f6503ff2dc42d073c.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7fc6996c93def8360d27c60f6503ff2dc42d073c.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Feb 09, 2024 at 04:53:50PM +0100, Martin Wilck wrote:
> On Thu, 2024-02-08 at 20:03 -0500, Benjamin Marzinski wrote:
> > On Mon, Feb 05, 2024 at 01:46:36PM +0100, Martin Wilck wrote:
> > > If a map reload happens while udev is processing rules for a
> > > coldplug
> > > event, DM_SUSPENDED may be set if the respective test in 10-
> > > dm.rules
> > > happens while the device is suspened. This will cause the rules for
> > > all
> > > higher block device layers to be skipped. Record this situation in
> > > an udev
> > > property. The reload operation will trigger another "change" uevent
> > > later,
> > > which would normally be treated as a reload, and be ignored without
> > > rescanning the device. If a previous "coldplug while suspended"
> > > situation is
> > > detected, perform a full device rescan instead.
> > 
> > For what it's worth, this seems reasonable. 
> 
> If that's so, I'd appreciate a Reviewed-by: :-)
> See below.
> 
> > But I do see the issue you
> > pointed out where we can't trust DM_SUSPENDED.
> 
> That was my suspicion originally, but the actual problem that was
> observed was different, see my recent response to 1/6.
> 
> Yes, it can happen any time that a device gets suspended between the
> DM_SUSPENDED check and an attempt to do actual I/O in later udev rules,
> but that is much less likely than the other case. So far I haven't been
> able to actually observe it.
> 
> Btw am I understanding correctly that you don't like the idea of going
> back to exclusive locking?

Oh, and yeah, I'd rather avoid exclusive locking if possible, just out
of a hunch that it could lead to other unexpected problems.

-Ben

> 
> >   Perhaps we could track
> > in multipathd if an add event occured for a path between when we
> > issued
> > a reload, and when we got the change event (unfortunately, change
> > events
> > can occur for things other than reloads that multipathd triggers, and
> > the only way I know to accurately associate a uevent with a reload is
> > by
> > using dm udev cookies. We have those turned off in multipathd and I
> > think it would be a good bit of work to turn them back on without
> > causing lots of waiting with locks held in multipathd). 
> 
> IMO doing this right in multipathd will be hard. We must be careful not
> to trigger too many additional uevents just because something *might*
> have gone wrong during udev handling (most of the time all is well,
> even if a reload happens). I believe to do this properly we must listen
> for *kernel* uevents, too, and that's something we've been trying to
> avoid for good reason.
> 
> I had a different idea: to track a "reload count" for a map somehow
> (e.g. in a file under /run/multipath) and checking that at the
> beginning and end of uevent handling in order to see if a reload
> occurred while the uevent was being processed (which would be detected
> by seeing a different the reload count change during the uevent).
> 
> For now, I hope that this change plus my latest addition will make the
> practical issue go away. All else can be discussed later.
> We haven't got any reports about this sort of race for years, so it's
> safe to assume that happens very rarely.
> 
> Regards
> Martin

