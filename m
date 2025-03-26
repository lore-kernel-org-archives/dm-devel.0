Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97CB1F95C
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008281; cv=none; b=S9SOaVRT0QZOSYuB2tE5L1R+/0+TX+GnELc++x7UqeETgddFJX+fcsi0stfZse6WtE2scsx4Zanp6PmuH4rnGk3VjS4qthuUF0+eRwWqPhczMFU/tzhRgQ9HvzsQQcEOWbf0O86UAyv+LeyATESt/pHhzTuZsvrKN6wx4Q3fDTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008281; c=relaxed/simple;
	bh=1oHN/PwGXVm9Y90tDB57kkS9MEpjE8lge++fyTYwpjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=c6kCjIZOS/Pb+J7kvm+o4skWxusSaKZ0GJIyDuqmSfzAvs8KWyO/G6L2+zfrftF+PBHqHt/zfjsYQeEGX9pcp5ldPA5Nn3PKMUGim/4vrh1ArS6Hi5mmhflSajrD4DN798qZtwe8wHu0HGXNM796tjCFPqMrS0E0XAtKqmE7VPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bz6Uv2CO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bz6Uv2CO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743008278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FExUyLTc9L+wuCLs4JB2VDJBKInjGLDOsKxXPiu25NU=;
	b=Bz6Uv2COvGd1xIBuL597BfJnf3uYWFHN1RGQICBgxaqDUVBc5+X8ESY6oeB6IBs67Zd0QL
	JmFA/goBAY8IYrEZkV1kALAdBLcFq3COFuElGGKWO+PsWKWaDfWHbBFXLmQ91eOYtk+yJI
	8NzCk2bxJdhBB7FaVmZcOP3X8YPjXC8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-jgRgCtBFPaOZ2dSCJQZJnQ-1; Wed,
 26 Mar 2025 12:57:54 -0400
X-MC-Unique: jgRgCtBFPaOZ2dSCJQZJnQ-1
X-Mimecast-MFC-AGG-ID: jgRgCtBFPaOZ2dSCJQZJnQ_1743008273
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 967A218EBE85;
	Wed, 26 Mar 2025 16:57:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DDF61801747;
	Wed, 26 Mar 2025 16:57:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52QGvqFK2607169
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Mar 2025 12:57:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52QGvqo52607168;
	Wed, 26 Mar 2025 12:57:52 -0400
Date: Wed, 26 Mar 2025 12:57:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-delay: support zoned devices
Message-ID: <Z-QyEG6nNo4EJ__z@redhat.com>
References: <20250321071816.1674943-1-hch@lst.de>
 <Z92naQRO2DrpMnXE@redhat.com>
 <1b09a5a4-437b-466a-a238-8d4cb5526942@kernel.org>
 <Z-QWmaGsJlvntvZn@redhat.com>
 <df52d589-784c-4035-9e55-8ce94ad182dc@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <df52d589-784c-4035-9e55-8ce94ad182dc@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7XFX2ldBXzpzbko7ecGw8Dv0XUgwI5qcUziWBLaHshk_1743008273
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 26, 2025 at 11:17:24AM -0400, Damien Le Moal wrote:
> On 2025/03/26 11:00, Benjamin Marzinski wrote:
> > On Wed, Mar 26, 2025 at 08:55:48AM -0400, Damien Le Moal wrote:
> >> On 2025/03/21 13:52, Benjamin Marzinski wrote:
> >>> On Fri, Mar 21, 2025 at 08:18:16AM +0100, Christoph Hellwig wrote:
> >>>> Add support for zoned device by passing through report_zoned to the
> >>>> underlying read device.
> >>>>
> >>>> This is required to make enable xfstests xfs/311 on zoned devices.
> >>>
> >>> On suspend, delay_presuspend() stops delaying and it doesn't guarantee
> >>> that new bios coming in will always be submitted after the delayed bios
> >>> it is flushing. That can mess things up for zoned devices. I didn't
> >>> check if that matters for the specific test. Setting
> >>>
> >>> ti->emulate_zone_append = true;
> >>>
> >>> would enforce write ordering, at the expense of adding a whole other
> >>> layer of delays to zoned dm-delay devices. Since this isn't really
> >>> useful outside of testing, I think that could be acceptable if necessary
> >>> (it would require us to support table reloads of zoned devices with
> >>> emulated zone append, since tests often want to change the delay).
> >>> However it would probably be better to see if we can just make dm-delay
> >>> preserve write ordering during a suspend.
> >>
> >> delay_presuspend() calls flush_delayed_bios() with flush_all == true. So all
> >> BIOs will be flushed in the order they are queued in the delay list, which as
> >> far as I can tell is the order in which the user of dm-delay issued the BIOs. So
> >> for writes, the order is preserved as far as I can tell.
> > 
> > delay_presuspend() is called before we set the DMF_BLOCK_IO_FOR_SUSPEND
> > bit, which will stop incoming bio from getting mapped, and also before
> > lock_fs() is called. This means it's common for new bios to continue to
> > come into delay_map(), while delay_presuspend() is running.  The moment
> > delay_presuspend() sets dc->may_delay = false, those new bios will stop
> > getting queued by delay_bio(). They will get remapped immeditately to
> > the underlying device. flush_delayed_bios() doesn't even get called
> > until after dc->may_delay is set to false, and if there are a lot of
> > bios on the delayed_bios list, flush_delayed_bios() will schedule. So,
> > it's actually very common for new incoming bios to get passed to
> > underlying device before all the bios on the dc->delayed_bios list do.
> > 
> > Solving this without grabbing the dc->process_bios_lock mutex for every
> > bio sent to dm-delay probably involves keeping the incoming bios going
> > to dc->delayed_bios during suspend, at least until we can guarantee that
> > it's empty and no bios are being flushed.
> 
> OK. Understood. Thank you for the explanation. And the above sounds like a
> rather simple solution, which does not even needs to be zone specific.
> 
> I also think that this is orthogonal to Christoph patch and we can fix the
> suspend issue on top of Christoph's patch. This is a very niche issue anyway for
> the main target use case which is fstests, since fstests does not suspend/resume
> the dm-delay device as far as I know.

I'm not sure that I would call a patch that adds a feature which doesn't
work correctly in some situations orthogonal to making the feature work
correctly in those situations. But I'll grant you that dm-delay is a
testing target, and Christoph's patch makes in useful for more tests, as
long as they don't suspend the device while there is still outstanding
IO. So, sure. I agree that Christoph doesn't need to change his patch,
and we can fix the suspend issue in a separate one. How that all gets
merged is Mikulas's call.

-Ben

> 
> > 
> > -Ben
> > 
> >>
> >> -- 
> >> Damien Le Moal
> >> Western Digital Research
> > 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

