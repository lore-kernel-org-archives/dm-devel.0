Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9398A323D
	for <dm-devel@lists.linux.dev>; Fri, 16 May 2025 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747411595; cv=none; b=miPHhMuHQTxAFWFbWb8CoMs9kCTMWixSIMPeP3cVBI2Jx/O2k1XSaeRCkiU8mVCcQjBWlnYO5B6p7ODfWVgvXe6mm5KmQ0K8I/xctJ6R3xdXDht4dMLSXyD/5iVsqumLJdEh0kwSxQTWPWqeoqSbbwZGUMUBkAOIsETc3kLKEU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747411595; c=relaxed/simple;
	bh=HC/H8VnyKJuKuUZ71TLJWBCeSgv7yjRyPzRGx3eOA7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0fNvGi5Jxd+Cu6Y95onIyHia/ira3XKVMusG4bPogjYI21du1K2LdJzlfz8UdUN1HFYC3r+/4Am0KWGHrlL3ImygW8y05X1KYKYQVgAL0KkZRini9G8WofxmY5F2B9/XbPvVpFLFn2txxYoEh58MoZTjOywekHdXW3VvSMX08Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/A9Ngui; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/A9Ngui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747411592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dRCWQ0WRwb7J9Y3IrAKzkNOuD8+Pdqu2lycZWGkuFKw=;
	b=Y/A9NguiRLh74QjAVbTrie6hMrfvdG5tHa43ncdi2dnWjiXK32sjuO1LS81QaEI2kbKgXL
	fnLQGUz5539jxJMVb+SE+YeJ5Q34/oC59zjTIAODjH/rMmjDlercraUKXzqgrQ/YF0PdvO
	RDyA0y3BFpSyqWtlZnrAWO/SqdyOL2w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-eFYM2NxfNwea_SK1JxIigg-1; Fri,
 16 May 2025 12:06:29 -0400
X-MC-Unique: eFYM2NxfNwea_SK1JxIigg-1
X-Mimecast-MFC-AGG-ID: eFYM2NxfNwea_SK1JxIigg_1747411587
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B501319560AF;
	Fri, 16 May 2025 16:06:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 261B91956094;
	Fri, 16 May 2025 16:06:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54GG6OJ04185925
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 12:06:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54GG6LBK4185924;
	Fri, 16 May 2025 12:06:21 -0400
Date: Fri, 16 May 2025 12:06:21 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
        dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
        snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCdifWdCQCR3Nqb0@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
 <aCW95f8RGpLJZwSA@redhat.com>
 <aCbUcdew393RZIkV@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCbUcdew393RZIkV@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, May 15, 2025 at 11:00:17PM -0700, Christoph Hellwig wrote:
> On Thu, May 15, 2025 at 12:11:49PM +0200, Kevin Wolf wrote:
> > If you're talking about SG_IO in dm-mpath, then PRIN/PROUT commands are
> > actually the one thing that we don't need. libmpathpersist sends the
> > commands to the individual path devices, so dm-mpath will never see
> > those. It's mostly about getting the full results on the SCSI level for
> > normal I/O commands.
> > 
> > There has actually been a patch series on qemu-devel last year (that I
> > haven't found the time to review properly yet) that would add explicit
> > persistent reservation operations to QEMU's block layer that could then
> > be used with the emulated scsi-hd device. On the backend, it only
> > implemented it for iscsi, but I suppose we could implement it for
> > file-posix, too (using the same libmpathpersist code as for
> > passthrough). If that works, maybe at least some users can move away
> > from SCSI passthrough.
> 
> Please call into the kernel PR code instead of hacking up more of
> this, which will just run into problems again.
> 
> > The thing that we need to make sure, though, is that the emulated status
> > we can expose to the guest is actually good enough. That Paolo said that
> > the problem with reservation conflicts was mostly because -EBADE wasn't
> > a thing yet gives me some hope that at least this wouldn't be a problem
> > any more today.
> 
> And if you need more information we can add that to the kernel PR API.

I've run into SCSI arrays that always act like they were called with the
ALL_TG_PT flag set (or perhaps they were just configured that way, I
never could get a straight answer about that). libmpathpersist accepts
this flag, and only sends one registration per initiator & target device
when it's set, instead of one per initator & target port. dm-multipath
currently doesn't have the knowledge necessary to figure out which
devices it needs to send reservations to, even if the kernel PR API
supported this.

But I supposed it could just send the registration normally down one
path and if that works, it could just ignore the existing key when it
sends the registration down all the other paths.

-Ben

