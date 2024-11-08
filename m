Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19E01F26E6
	for <dm-devel@lists.linux.dev>; Fri,  8 Nov 2024 22:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731103703; cv=none; b=fwUox4+rogV6P3aIahstkL7K0nrxiONZOl8Acw0PdyxFJvzympXnOIDiUeE5GG1j+Euv6O44dzRgfxm5C5WVgC1zS3+vqMOnaU/MQ8Z1nitOPSDW/uTfW5PtHAgGW/UAZADzuCVhnVoRxv16f3hMlEpzVa5TdOyYh4cq+FcVPfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731103703; c=relaxed/simple;
	bh=GffrwZZjdZkjQGTJLrYuRgIGPJISd3ilhSXNLVFdggk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=e+8ofXIvxfZSoZZvz8heqtbm/74tXZNaAQICv/XY0NDufE5pVhIOoXG2miLik3S8wdoEEhRixkjv1vZG0t4d8Bfbxm6EZp2Qkc22XlD5ehOxwOiLGImgPIYXpK8IsrK3/GsGxOtF/dh4AJH6kZtGe+FMvCWyT2uAFohZSf4+ziU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NkxaFSxn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NkxaFSxn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731103700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IKnh2DkNsu13lsV1khTNPdwiu7v7k6uRO2UvaMeRQzk=;
	b=NkxaFSxnrgBuVT2GNQYXSEbcwBUK0t4wzJU9Cnk/DNeWGGAKaKsc4D1uuaaF2M/3of1QrS
	S342XJ0lXLxDDXVHjtMdC1dALq+akHs/Ce4hDPG8IzG0kK/aKPTOqM1HAkkApmUQXPrSoh
	pggc6DDZiNch98bkojTCZ058GQOFNKI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-A4ebWNQfO0SIEcnKSfgcIA-1; Fri,
 08 Nov 2024 17:08:19 -0500
X-MC-Unique: A4ebWNQfO0SIEcnKSfgcIA-1
X-Mimecast-MFC-AGG-ID: A4ebWNQfO0SIEcnKSfgcIA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC5C819560B2;
	Fri,  8 Nov 2024 22:08:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AAC61953880;
	Fri,  8 Nov 2024 22:08:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A8M8F2K525244
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 8 Nov 2024 17:08:15 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A8M8FZe525243;
	Fri, 8 Nov 2024 17:08:15 -0500
Date: Fri, 8 Nov 2024 17:08:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
Message-ID: <Zy6Lz1y0-dVXvodH@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
 <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
 <Zyz8SFDAkIggpuND@redhat.com>
 <692cb30cad72ed8165b8efd0751c8c5cb1f03993.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <692cb30cad72ed8165b8efd0751c8c5cb1f03993.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XPlPDJ4ypBIzihh2XLA--fYcG4RMRfz5ZURXPz7Gru8_1731103698
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 07, 2024 at 07:02:11PM +0100, Martin Wilck wrote:
> On Thu, 2024-11-07 at 12:43 -0500, Benjamin Marzinski wrote:
> > On Thu, Nov 07, 2024 at 01:20:09PM +0100, Martin Wilck wrote:
> > > 
> > > Thinking about it, I believe we should actually accept devices that
> > > have an mpath UUID and an empty table, and add them to our mpvec.
> > > We
> > > should treat them like devices that have a multipath target but no
> > > path
> > > devices. If any matching paths become available, the map will be
> > > reloaded and the issue will be fixed. IMO, this is less prone to
> > > race
> > > conditions than trying to delete and re-add the devices.
> > 
> > I'm not sure off the top of my head how easy it will be to handle
> > devices with no dm table at all, but I'll take a look into this.
> 
> I tried this on a system with 0.9.9 yesterday. 0.9.9 will not add the
> map into the mpvec. But in coalesce_paths(), it will just reload the
> map:

Given that the code already does the right thing without needing any
changes to handle tableless maps makes me feel like just removing the
final patch is the best idea.

The only issue with the current code is that if you have a device with
no table with the UUID of a multipath device but a different name than
that multipath device should have, multipath will try to create a new
device instead of reload it, and this fails, since the UUID is already
in use.

That should probably be handled by making the multipath code pay more
attention to the device UUID and less to the device name, but that's
work for a different patchset. 

-Ben

> 
> multipathd[3198]: 360014053cdf4a9b80de42ab96c74f4ef: set ACT_CREATE (map does not exist)
> multipathd[3198]: 360014053cdf4a9b80de42ab96c74f4ef: map already present
> multipathd[3198]: 360014053cdf4a9b80de42ab96c74f4ef: reload [0 41943040 multipath 1 queue_if_no_path 1 alua 2 1 service-time 0 1 1 8:16 1 serv>
> 
> Note that it first says "map does not exist", and then sees it present (with no table).
> The reload works without issues though, if the map is empty.
> 
> If, on the contrary, the map is not empty but contains another incompatible target
> (I tried this with a trivial linear mapping), the reload operation will fail:
> 
> multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: set ACT_CREATE (map does not exist)
> multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: map already present
> multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: reload [0 41943040 multipath 1 queue_if_no_path 1 alua 2 1 service-time 0 1 1 8:16 1 serv>
> kernel: device-mapper: ioctl: can't change device type (old=1 vs new=2) after initial table load.
> multipathd[1347]: libdevmapper: ioctl/libdm-iface.c(1998): device-mapper: reload ioctl on 360014053cdf4a9b80de42ab96c74f4ef  failed: Invalid argument
> multipathd[1347]: dm_addmap: libdm task=1 error: Invalid argument
> multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: domap (0) failure for create/reload map
> multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: removing map
> 
> Regards
> Martin

