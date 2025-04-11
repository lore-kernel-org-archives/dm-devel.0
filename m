Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4969F203716
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 11:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744371683; cv=none; b=V3RkF5ltJHXQ4o6t1/PUyASzD3YTWSmwdn0CvrAg85PZO+/T8vjDIx3mV1uNSnf9m5qeexHkTx4B6kOiCwXX5hoLFLhX3b/OoKvJJHGk+p4Rwp+LfJ1deIFjfg/8zS8pWojEYsAaJpJUrne9WAGXwfUFeoJkffW4SI0hiz8TPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744371683; c=relaxed/simple;
	bh=XFTbNiCbtEj+gSOWivwnTD3/mjVURcBP3jyJcWLRQCQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DZRqrZoC1qLZna6Zv816lMzXdh6AIqWbiwtdCGBmq3JRUw22n1fszp861bYB7rY93gsy/LA0YwzCqJZj2/Avgt66ujIJFadP7+pYSmsYU+aXMJEswFca7hK8h2WFGBLzs4r3GJ72GO4cP5LL/X//FwDxKsTQaZcPwpnDn/f2nNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvU9HqFC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvU9HqFC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744371676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dp/c6PR89T57o0+D5yoCx+arP0GKiadOI6yqBI+zdDM=;
	b=IvU9HqFC8sjixYKZfVWWUXv36CD1vclKTzMXce5lIcItfIHcOxTWqRjDn5aj3rZUUj+6gj
	07QwW9PLqvEg8hjnApoMprDTaRUJI0ZR2UCztdvMl/zISpXIkyOAio3aJAqHgNfHEgrvqY
	2cJvNjyn6lRUEtb8AozfpoGKQpJ+SCw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-4RkEZKSyO3GBLPigR8Vp6g-1; Fri,
 11 Apr 2025 07:41:14 -0400
X-MC-Unique: 4RkEZKSyO3GBLPigR8Vp6g-1
X-Mimecast-MFC-AGG-ID: 4RkEZKSyO3GBLPigR8Vp6g_1744371674
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91A591808985;
	Fri, 11 Apr 2025 11:41:13 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C9C31956094;
	Fri, 11 Apr 2025 11:41:11 +0000 (UTC)
Date: Fri, 11 Apr 2025 13:41:08 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/6] dm: fix issues with swapping dm tables
In-Reply-To: <80cfd413-1bee-4ed1-a49f-163a28d0b426@kernel.org>
Message-ID: <35ea47e0-21dc-a0b9-8531-b1c49fce08c3@redhat.com>
References: <20250410194943.9326-1-bmarzins@redhat.com> <80cfd413-1bee-4ed1-a49f-163a28d0b426@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2JYM7xKUAiFhsdTLIfScmaXZCtU2dnugsT36gwXza6w_1744371674
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 11 Apr 2025, Damien Le Moal wrote:

> On 4/11/25 04:49, Benjamin Marzinski wrote:
> > There were multiple places in dm's __bind() function where it could fail
> > and not completely roll back, leaving the device using the the old
> > table, but with device limits and resources from the new table.
> > Additionally, unused mempools for request-based devices were not always
> > freed immediately.
> > 
> > Also, there were a number of issues with switching zoned tables that
> > emulate zone append (in other words, dm-crypt on top of zoned devices).
> > dm_blk_report_zones() could be called while the device was initially
> > setting up a zoned table and creating zoned resources or could possibly
> > fail to end a srcu read section.  More importantly,
> > blk_revalidate_disk_zones() would never get called when updating a zoned
> > table. This could cause the dm device to see the wrong zone write
> > offsets, not have a large enough zwplugs reserved in its mempool, or
> > read invalid memory when checking the conventional zones bitmap.
> > 
> > Finally, any DM device created on top of a device emulating zone appeads
> > will automatically have zone write plug resources created for it, since
> > max_hw_zone_append_sectors will always be 0 for a device stacked on top
> > of a device max_hw_zone_append_sectors = 0
> > 
> > This patchset fixes these issues. It deals with the problems around
> > blk_revalidate_disk_zones() by only calling it for devices that have no
> > zone write plug resources. This will always correctly update the zoned
> > settings. If a device has zone write plug resources, calling
> > blk_revalidate_disk_zones() will not correctly update them in many
> > cases, so DM simply doesn't call it for devices with zone write plug
> > resources. Instead of allowing people to load tables that can break the
> > device, like currently happens, DM disallosw any table reloads that
> > change the zoned setting for devices that already have zone write plug
> > resources. Finally, it deals with the max_hw_zone_append_sectors issue
> > by making sure that it is non-zero for zoned DM devices that do not need
> > zone write append emulation.
> > 
> > Changes in V4:
> > - Fixed typos in 2 commit messages (patches 4 and 5)
> > - rephrased comment in dm_revalidate_zones() (patch 5)
> 
> I gave this a quick spin and did not detect any issues.
> So feel free to add:
> 
> Tested-by: Damien Le Moal <dlemoal@kernel.org>
> 
> -- 
> Damien Le Moal
> Western Digital Research

Thanks.

I staged the patches for the next merge window.

Mikulas

