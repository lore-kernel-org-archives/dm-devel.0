Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1018FDD8
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001424; cv=none; b=rDM+5OIUSyUzHSIeiEO539udp9bAfyZ/ABbRIHXKbHNPe1/3CISYO/EuhXBdXWiYB8l0vXHuzkxyDjeVqbp/ThQW0LD/i9HqWCdkXY+9K4LQlAArM5xZEsxQc138SLKhspQpGG0CO0jfdB/sZ1FWdNxBL+f+Wp6Cz9mKA1gepmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001424; c=relaxed/simple;
	bh=fCnNeg4sH0S564m1EQxi4J80QGnnwQElXc57NrBRy4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=M3uUx0nHmEqVJ+2OKZmHDsIm7OxGQwRme29K6Z1xO9FF1B03H7dCSfhIq3XuXJ2Q5HtqnDja+887pPmgeYR0ADvhcxge5Xk0xN+Ht5zLMc3TSIwsPzrMf6+w6CQF7KsShuVQ7RbjB4X52DUViH7NbKFoRAA/S9afZzx+BdWzqFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBNFq3af; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBNFq3af"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731001420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FARYd7IpJR3Hs+U0rsLPGosW0cdNKT+6l5BY3KCjTDg=;
	b=eBNFq3af4j4CVlol34bG+/fWMvZeCXLwIeZ0fa8hcQW7zuxwgAxqecvxI/CRCuRbUux19b
	2LlYZf4aSqaBMz6VrErvX2hE3PXHmklaq9AdSuukZEdfHtXLwsE2T4OWgxmv7OBKWVzUPd
	6GCj6hH7uSULtG55qsxIlLEevkngVmU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-a8NFIx-sO1qa0xP_BFGRVA-1; Thu,
 07 Nov 2024 12:43:39 -0500
X-MC-Unique: a8NFIx-sO1qa0xP_BFGRVA-1
X-Mimecast-MFC-AGG-ID: a8NFIx-sO1qa0xP_BFGRVA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3464519560B1;
	Thu,  7 Nov 2024 17:43:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5DF51956054;
	Thu,  7 Nov 2024 17:43:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A7Hhab2496786
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 7 Nov 2024 12:43:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A7Hhat3496785;
	Thu, 7 Nov 2024 12:43:36 -0500
Date: Thu, 7 Nov 2024 12:43:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
Message-ID: <Zyz8SFDAkIggpuND@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
 <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C__hLbU3FO02QiWRptZ6MTooC17FF1fO9m8kGUe4Mx4_1731001418
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 07, 2024 at 01:20:09PM +0100, Martin Wilck wrote:
> On Wed, 2024-11-06 at 17:52 +0100, Martin Wilck wrote:
> > On Thu, 2024-10-31 at 14:32 -0400, Benjamin Marzinski wrote:
> > > This patchset include a couple of miscellaneous cleanups, but is
> > > mostly
> > > in response to issues brought up in
> > > https://github.com/opensvc/multipath-tools/issues/100
> > > It adds auto restarting to the multipathd.service unit file. I'm
> > > fairly
> > > conflicted about the correct limits to be placed on these restarts,
> > > so
> > > if anyone has strong opinions and a good argument, I'm more than
> > > willing
> > > to change them.
> > > 
> > > The bulk of the changes deal with how multipath handles devices
> > > without
> > > any table. Multipath was supposed to delete these if they were left
> > > behind after a failed device creation, but that code was broken.
> > > However devices aren't typically left behind after failed creates,
> > > so
> > > it
> > > didn't matter.  
> > > 
> > > A bigger issue is that multipathd and multipath could fail if
> > > tableless
> > > devices were present. With this patchset, they will simply ignore
> > > tableless devices that don't have a multipath prefixed DM UUID. The
> > > last
> > > patch is a RFC patch that changes the behavior for tableless
> > > devices
> > > that do have a multipath prefixed DM UUID. It makes multipath
> > > remove
> > > these devices on the grounds that they are likely failed creates.
> > > However, looking at the libdevmapper code, I'm not sure that we
> > > actually
> > > want to do this.  When a DM_DEVICE_CREATE task is run, it will
> > > first
> > > create a tableless device, and then immediately load the table and
> > > resume the device. So it's possible any that tableless devices
> > > which
> > > multipath sees are actually in the process of getting created. I
> > > left
> > > the patch as part of the set, but I'm not sure that removing the
> > > devices
> > > is the right answer here. I haven't ever seen any tableless
> > > multipath
> > > devices lying around (and I couldn't force any to get created when
> > > I
> > > tried). Unless other people have seen these, then I don't think the
> > > final patch of this set should go in.
> > > 
> > 
> > Does it do any harm if we just keep these devices around? If there
> > are
> > path devices around with matching UUIDs, the right thing to do for
> > multipathd would be to reload the map's table with an appropriate
> > multipath target. Otherwise, the map will just float around empty and
> > do no harm. This is how multipathd 0.9.9 and earlier behave, and
> > I see no issue with that.
> 
> Thinking about it, I believe we should actually accept devices that
> have an mpath UUID and an empty table, and add them to our mpvec. We
> should treat them like devices that have a multipath target but no path
> devices. If any matching paths become available, the map will be
> reloaded and the issue will be fixed. IMO, this is less prone to race
> conditions than trying to delete and re-add the devices.

I'm not sure off the top of my head how easy it will be to handle
devices with no dm table at all, but I'll take a look into this.

-Ben
 
> Martin

