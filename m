Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3AA1C6FE1
	for <dm-devel@lists.linux.dev>; Wed,  5 Mar 2025 21:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741209860; cv=none; b=VHuqSxLvMuGk0oZaLegnTHN4tvP2YANWbNRbS61OuUd5L7lvqRwZoaFpUYqtIhFWxvSlt0aRff+GSCzoE/Ax+52+bNabCKfiOQQN8Px3KD4eo5QXynpR3ygtFgKQcr3JsCXhL+QgouJOqle08E7h1Qo98h6vVa4SRNUmwcQHjw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741209860; c=relaxed/simple;
	bh=7nZzuFCEDWgj6UnY2MJXbl7Gui9dz9vlC4MS4o1RiC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fTWVNwAh/tH4muSiHSDBDUee38K/Pnrr4FKBZ0ubyQ5pjsf/5xkM/ephXlM3sd9zJTDT7BFuDq8ijrXYnTcfTy7guWlUyVclTI2kw2xCEOsA64JneUMtNdNfm01x5XCFj4IPvcG0IqZRrRbaAQ1RRPSl8qUCm/hOt4JeaIShUaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g+LXGby1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g+LXGby1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741209857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZN7W1fGXIeWh67vpYoZPTkEnD3yQcqxwVDXdKdl751Y=;
	b=g+LXGby1ofyIb88eENEgwijgK93EPVQX0SsVOS5C1KUVKW1mh9Y2JKGM/dPl2PK1yyghFH
	6Uh6ugFJvoDbD/+a0Cp+mog5b1LwtR0OP5+fwPskSrx06qgXnEE18TdAyFTT1VZdk/z1Iv
	BYbMA4aT7/dR28BkIfMhaQEMHeh2WIM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-iRiz5GKmN2Gs1y28LnNjqQ-1; Wed,
 05 Mar 2025 16:24:15 -0500
X-MC-Unique: iRiz5GKmN2Gs1y28LnNjqQ-1
X-Mimecast-MFC-AGG-ID: iRiz5GKmN2Gs1y28LnNjqQ_1741209854
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FA601954B37;
	Wed,  5 Mar 2025 21:24:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAE17300019E;
	Wed,  5 Mar 2025 21:24:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 525LOCQo3092275
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Mar 2025 16:24:12 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 525LOCTw3092270;
	Wed, 5 Mar 2025 16:24:12 -0500
Date: Wed, 5 Mar 2025 16:24:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] multipathd: fix hang during shutdown with queuing maps
Message-ID: <Z8jA_Khks56lYn14@redhat.com>
References: <20250227174104.206721-1-mwilck@suse.com>
 <Z8YGC5oP9zFM79DC@redhat.com>
 <01c2cfdcad91bbdb37f89023887c5939db2066e6.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <01c2cfdcad91bbdb37f89023887c5939db2066e6.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wGwwJqH6ZAVYLi70bb8b_VVS3De5eYl7naGOJEwFTmQ_1741209854
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2025 at 09:26:12PM +0100, Martin Wilck wrote:
> On Mon, 2025-03-03 at 14:42 -0500, Benjamin Marzinski wrote:
> > On Thu, Feb 27, 2025 at 06:41:04PM +0100, Martin Wilck wrote:
> > > Since c9689b6 ("multipathd: Remove dependency on
> > > systemd-udev-settle.service"), multipathd.service starts very early
> > > during
> > > boot, which in systemd's service ordering logic means that it is
> > > stopped
> > > late. While this is generally a good thing, it means that, when
> > > systemd
> > > unmounts file systems and tears down the block device stack,
> > > multipathd
> > > is still running. Therefore our "queue_without_daemon" logic, which
> > > disables
> > > queuing when multipathd exits, isn't effective yet. If there are
> > > any
> > > multipath maps that are in queueing state at this point in time,
> > > the system
> > > may hang indefinitely.
> > > 
> > > To fix that, add a new service which starts later (and thus stops
> > > earlier) and
> > > disables queueing on all multipath maps during shutdown. Similar to
> > > lvm2's
> > > blk-availability.service, the service does nothing when started.
> > > 
> > > Fixes: c9689b6 ("multipathd: Remove dependency on systemd-udev-
> > > settle.service")
> > 
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Thanks - do you reckon this is suitable for the stable tree?
> There is not much of a regression risk, but it requires shipping
> another file, so it's non-trivial for packagers.
> 
> Personally I'm inclined to add it to stable (also because I'll need to
> backport it anyway).

I on the fence about this one. It does fix a bug, but adding a new
service is kinda feature-y. But your right that there's not much risk of
it breaking things, so it doesn't really matter much to me either way.

-Ben

> 
> Martin

