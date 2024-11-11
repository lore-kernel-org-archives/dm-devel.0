Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F591A302E
	for <dm-devel@lists.linux.dev>; Mon, 11 Nov 2024 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731345447; cv=none; b=Tl19n8z0suFyeMYBPrQ5Dmvf9vBI2QaIuBlhO4eEUplloXj8y4G+PltTBgKA8+r7Fye7hPCeqPb/Vrl/AdgZYT1sBeKanS/hEuYPCsLV6dSh6QSDM+g8/uzun5MRp4oUv6k94Plzy8XJ/o/PtTCmuW5uUc2DytShv2t7zHYubKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731345447; c=relaxed/simple;
	bh=A36kBCnoWEhCmCiId7KIUVyTSYfSeS87/IoFY/7AOQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iszCRhH9ej7MiSEdnA/iw4420d1H/vTxOWK2RuSaYx20JTUD/Dxt88k9Pgpod3cO7QNAIrw3yhStjdUZEIJKB6+WENL23lH1t0ufpHzbjqTgnxeHCn1RH8hzuM4ywZqhBgaIPIHgw0w5SSfRsBi96B58oisKi2wBtxCYi4i+cE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmN3V3GV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmN3V3GV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731345444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA6YaIJKV0Fud+RNR0JBkpQ9taZWmeDP/N6BqtZlWas=;
	b=PmN3V3GVpBVg3Eeu3yJ0t3SSKTDX/5uGUFKTvRSznPZ3+j2O9V8A54dG2uOtMyTjot9iV8
	1xl7+5pEDlvxUdZp4gOSCvW9xnJoBlo94/Q38cZB6GaAF6JvpGHYVdf3PNXtrhakZ4qTc0
	yGEJZDVpgD/x4m8V5KQ1O0C5vZOdM20=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-RNQGGa4AMXSv5-iVW2FukQ-1; Mon,
 11 Nov 2024 12:17:21 -0500
X-MC-Unique: RNQGGa4AMXSv5-iVW2FukQ-1
X-Mimecast-MFC-AGG-ID: RNQGGa4AMXSv5-iVW2FukQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3003519560AB;
	Mon, 11 Nov 2024 17:17:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0B28195E480;
	Mon, 11 Nov 2024 17:17:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4ABHHI8t563633
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 11 Nov 2024 12:17:18 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4ABHHHFt563632;
	Mon, 11 Nov 2024 12:17:17 -0500
Date: Mon, 11 Nov 2024 12:17:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
Message-ID: <ZzI8HbwgmBQSLbLk@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
 <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
 <Zyz8SFDAkIggpuND@redhat.com>
 <692cb30cad72ed8165b8efd0751c8c5cb1f03993.camel@suse.com>
 <Zy6Lz1y0-dVXvodH@redhat.com>
 <a7b6076cc759383e407ac9e46ff39be14f5a1b6d.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a7b6076cc759383e407ac9e46ff39be14f5a1b6d.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AsBFk-v52nw1RA-quqb1XtFgvjO9X6lRPXW4m2Adu1o_1731345440
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 09, 2024 at 12:03:33AM +0100, Martin Wilck wrote:
> On Fri, 2024-11-08 at 17:08 -0500, Benjamin Marzinski wrote:
> > On Thu, Nov 07, 2024 at 07:02:11PM +0100, Martin Wilck wrote:
> > > On Thu, 2024-11-07 at 12:43 -0500, Benjamin Marzinski wrote:
> > > > On Thu, Nov 07, 2024 at 01:20:09PM +0100, Martin Wilck wrote:
> > > > > 
> > > > > Thinking about it, I believe we should actually accept devices
> > > > > that
> > > > > have an mpath UUID and an empty table, and add them to our
> > > > > mpvec.
> > > > > We
> > > > > should treat them like devices that have a multipath target but
> > > > > no
> > > > > path
> > > > > devices. If any matching paths become available, the map will
> > > > > be
> > > > > reloaded and the issue will be fixed. IMO, this is less prone
> > > > > to
> > > > > race
> > > > > conditions than trying to delete and re-add the devices.
> > > > 
> > > > I'm not sure off the top of my head how easy it will be to handle
> > > > devices with no dm table at all, but I'll take a look into this.
> > > 
> > > I tried this on a system with 0.9.9 yesterday. 0.9.9 will not add
> > > the
> > > map into the mpvec. But in coalesce_paths(), it will just reload
> > > the
> > > map:
> > 
> > Given that the code already does the right thing without needing any
> > changes to handle tableless maps makes me feel like just removing the
> > final patch is the best idea.
> 
> If we do this, do we still need the special case for DMP_BAD_DEV? IMO
> we just need to make sure that dm_get_maps() doesn't return an error if
> it encounters an empty map.

Depends. If we fail attempting to create a device, we could have raced
with something else attempting to create it.  Just checking for
dm_map_present() before we remove the device won't distinguish between
these two cases at all.

On the other hand, there is still a window where the program that we
raced with is in the middle of creating the device, but it doesn't have
a live table yet. In this case, even the DMP_BAD_DEV code won't be able
to distinguish between a map that didn't get created correctly and one
that is in the process of getting created. It would reduce the window
where we could accidentally delete a working device, however.

Since it doesn't add much complexity, I lean towards keeping it, but it
is one more state we need to handle on returns from libmp_mapinfo(), so
I'm open to an argument that it's not worth it.
 
> > The only issue with the current code is that if you have a device
> > with
> > no table with the UUID of a multipath device but a different name
> > than
> > that multipath device should have, multipath will try to create a new
> > device instead of reload it, and this fails, since the UUID is
> > already
> > in use.
> 
> That should be handled in coalesce_paths(). It's basically the scenario
> that occurs if we enable or disable user_friendly names.

Except that we have a mpp for the other device if it has a table. If the
device doesn't have a table, then a mpp isn't created, so
coalesce_paths() doesn't track it. We could add code to create mpps for
these tableless devices, but it's another trade off of added complexity
to handle a rare corner case, and I'm not sure this one is worth it.

-Ben
 
> > That should probably be handled by making the multipath code pay more
> > attention to the device UUID and less to the device name, but that's
> > work for a different patchset. 
> 
> Yes, definitely.
> 
> Martin

