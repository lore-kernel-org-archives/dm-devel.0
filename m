Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1BB1DF27C
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747238509; cv=none; b=anUY0z0La+vEZln/ZJMXcD8S0RDt9lFOe70dyfLFS5gtCWeoe+PIvsalKSuvNkMMMXimhesNg7WqCrpTC0v3CDK0N/Uow6WoCHpp9MopOU6tOfkwQVOghRyVydsOZb5h5fIafvt30NkQD+boXLi9zcSiMMHOoqJw6EJQ6llaQ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747238509; c=relaxed/simple;
	bh=t3zqotCc69D1ZiHZiIfRDk1HCfugGpfCQ0wBwgvEZ3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Os3BRzYRiMaw1r118EQBVopNjSHp2FLVUgqNrV2OWjmtHWGGadRqf7OebBlqdAQIF/XR9yTiHaaf3UvxXXClKt4T/nWp3plqFRc3ToKzLRdjjGB6CYVChhNLX1qqnjxPomjIKsSTPrWOXXRQGgKvUPNRpcKOEqdSulmoiXNibvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXSkO863; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXSkO863"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747238506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pQGPzAIMOel7514Af+ySMZmuE4RATU4iiPxk+J1cvws=;
	b=CXSkO863ASu3BTtzktYbYWjCPZOYsBDTXWDkcthF3ocWLLGhi9Qm3xxsTlfypRZvUVf7US
	WjA1OBL+bBcb0FuGAgjCoMO4NyXWZjFTuiKOHUhS5yKiPNUrC5HVY21iNs6Nk6MbZZt9WT
	Qm9V51pBxJpl4sedxTVyMFHBMu2F0us=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-BAEcIoTUOGyd9mS2oZRkaQ-1; Wed,
 14 May 2025 12:01:44 -0400
X-MC-Unique: BAEcIoTUOGyd9mS2oZRkaQ-1
X-Mimecast-MFC-AGG-ID: BAEcIoTUOGyd9mS2oZRkaQ_1747238503
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E241119560A7;
	Wed, 14 May 2025 16:01:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31D3219560B4;
	Wed, 14 May 2025 16:01:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54EG1e8T3730502
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 12:01:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54EG1b8P3730501;
	Wed, 14 May 2025 12:01:37 -0400
Date: Wed, 14 May 2025 12:01:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev,
        hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCS-YRWMT596l4Tq@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
 <aCLjPLCztuXhgpnA@infradead.org>
 <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
 <aCLrbz3bRLwUbA8p@infradead.org>
 <aCNzf7MJa-hLQpmv@redhat.com>
 <37bb9993-baaa-4dc8-b5d4-e66201e4a462@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37bb9993-baaa-4dc8-b5d4-e66201e4a462@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, May 14, 2025 at 08:39:25AM +0200, Hannes Reinecke wrote:
> On 5/13/25 18:29, Benjamin Marzinski wrote:
> > On Mon, May 12, 2025 at 11:49:19PM -0700, Christoph Hellwig wrote:
> > > On Tue, May 13, 2025 at 08:32:12AM +0200, Hannes Reinecke wrote:
> > > > Reservations and stuff.
> > > 
> > > They should use the kernel persistent reservation API.
> > 
> > Currently QEMU isn't sending Persistent Reservation requests to
> > multipath devices at all. It's sending those directly to the underlying
> > scsi devices. The issue here is with all the other SCSI commands that
> > users want to send to their SCSI passthrough device that is actually a
> > multipath device on top of a number of SCSI paths. They expect to
> > get back the actual sense and status information, so QEMU needs to
> > send them via SG_IOs.
> > 
> > Without reading that sense and status information in kernel, the
> > multipath target can't know if it needs to fail a path and retry the
> > ioctl down a different path. QEMU can read this information, but it
> > doesn't know what path the multipath device send the ioctl down. This
> > patch just gives users a way to check the paths in the active pathgroup
> > (which all should be able to handle IO) and fail those that can't.
> > While QEMU is the driver of this, it's completely general functionality.
> > 
> Ouch.
> Different reservations on different paths? Really?
> How do you manage to keep the reservations up-to-date?

multipath's libmpathpersist library. You contributed some code to it
IIRC. It predates the kernel interface, and even if we switched to using
the kernel interface to send persistent reservation commands to the
paths instead of doing that in userspace (the dm_pr_ops functions would
needs some reworking to handle multipath, where the rules are different
than for other dm-devices. For instance, you only want to reserve on one
path, and it's not necessarily a failure if you can't register a key
down all paths) we would still probably want to use the library, since
it also coordinates with multipathd so that it can register keys on
paths that are later added to the multipath device or were down when the
registration initially happened. 
 
> My recommendation is to use the _same_ reservation on all paths,
> precisely to avoid having to re-do reservations on path failure.
> And for that scenario the kernel persistent reservation API
> would work fine.

Libmpathpersist does register the same key for all paths of a multipath
device. Doing anything else would be crazy. Sorry if my last email was
misleading. But the kernel API cannot help in the case where a path is
later added to the multipath device, or was down when the initial
registration happened.

But again, all this is orthogonal to the patches in question, which have
nothing to do with Persistent Reservations.

-Ben

> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

