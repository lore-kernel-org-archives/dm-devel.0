Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA7B1A238E
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 12:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744635365; cv=none; b=nMvYbpUMYYUJ/+//oIUREsqLwpu/cnjSyeycHvXtH3Qpwy8bLJCmUxNd5tPZyqp1qEeWjaernJVBfhbxq3ff89cj/fNSAoUdhQkVyUUfHjQwqtfjPvdE5ObQBdVzUZ9r85wIx8C1hQ/a3MNzWvOm6NRHnxBanwIheaBNmnNC74M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744635365; c=relaxed/simple;
	bh=zReXNSG6CzrbZX2WMUQ0cL8l5ZTxZvXAXHGZozJlGDI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XXQHpfMibmaceUyVJPi+1dgq/H4zZxY5Wpz87QoRKHK/vFF7mnOfXdTJZvB/cRH8UIyWfS1Gk6kBRvFP54EBQuGPUU0KpbCzI/Mg68HR4DAWnk9BI9no8tMwlChbGgKKp3FQD7W1+FYydfUiOqVvkcDA6AdK92dNFwYwwG+q89g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DEhuk7jp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DEhuk7jp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744635360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KpDkH166B0WL4R8qE4P6rVBWES/NpBWRjttKMb+8iS8=;
	b=DEhuk7jp7ioU1WZYTKQNPA328A90sjPaMhw/46wDnUt1lJuTBrpVEC/w+qgEHacjzKCTXU
	UewCtXCDrEHqgfQQ37DX4CaIvdYNpUvN1mglRhjNHQ2gggCPl891DZfOgtyZDOgq1HnftM
	cTMclRdf+16ilI9xXhreowe2LXBw4zM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-Mge8fCr1PH--HsOgvnm0LQ-1; Mon,
 14 Apr 2025 08:55:57 -0400
X-MC-Unique: Mge8fCr1PH--HsOgvnm0LQ-1
X-Mimecast-MFC-AGG-ID: Mge8fCr1PH--HsOgvnm0LQ_1744635356
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9F79195608A;
	Mon, 14 Apr 2025 12:55:56 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF9B71809B64;
	Mon, 14 Apr 2025 12:55:54 +0000 (UTC)
Date: Mon, 14 Apr 2025 14:55:50 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/6] dm: fix issues with swapping dm tables
In-Reply-To: <99d3e0b0-faac-4262-8f8c-1979b5bc839d@kernel.org>
Message-ID: <e0984018-40b0-24e0-6220-9ffefb3ca1e7@redhat.com>
References: <20250410194943.9326-1-bmarzins@redhat.com> <80cfd413-1bee-4ed1-a49f-163a28d0b426@kernel.org> <35ea47e0-21dc-a0b9-8531-b1c49fce08c3@redhat.com> <99d3e0b0-faac-4262-8f8c-1979b5bc839d@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FXPRH2Ypjm2kZTdCv2wqgDyUWXO2mAr1DH04nhrOOYQ_1744635356
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 14 Apr 2025, Damien Le Moal wrote:

> On 4/11/25 8:41 PM, Mikulas Patocka wrote:
> > 
> > 
> > On Fri, 11 Apr 2025, Damien Le Moal wrote:
> > 
> >> On 4/11/25 04:49, Benjamin Marzinski wrote:
> >>> There were multiple places in dm's __bind() function where it could fail
> >>> and not completely roll back, leaving the device using the the old
> >>> table, but with device limits and resources from the new table.
> >>> Additionally, unused mempools for request-based devices were not always
> >>> freed immediately.
> >>>
> >>> Also, there were a number of issues with switching zoned tables that
> >>> emulate zone append (in other words, dm-crypt on top of zoned devices).
> >>> dm_blk_report_zones() could be called while the device was initially
> >>> setting up a zoned table and creating zoned resources or could possibly
> >>> fail to end a srcu read section.  More importantly,
> >>> blk_revalidate_disk_zones() would never get called when updating a zoned
> >>> table. This could cause the dm device to see the wrong zone write
> >>> offsets, not have a large enough zwplugs reserved in its mempool, or
> >>> read invalid memory when checking the conventional zones bitmap.
> >>>
> >>> Finally, any DM device created on top of a device emulating zone appeads
> >>> will automatically have zone write plug resources created for it, since
> >>> max_hw_zone_append_sectors will always be 0 for a device stacked on top
> >>> of a device max_hw_zone_append_sectors = 0
> >>>
> >>> This patchset fixes these issues. It deals with the problems around
> >>> blk_revalidate_disk_zones() by only calling it for devices that have no
> >>> zone write plug resources. This will always correctly update the zoned
> >>> settings. If a device has zone write plug resources, calling
> >>> blk_revalidate_disk_zones() will not correctly update them in many
> >>> cases, so DM simply doesn't call it for devices with zone write plug
> >>> resources. Instead of allowing people to load tables that can break the
> >>> device, like currently happens, DM disallosw any table reloads that
> >>> change the zoned setting for devices that already have zone write plug
> >>> resources. Finally, it deals with the max_hw_zone_append_sectors issue
> >>> by making sure that it is non-zero for zoned DM devices that do not need
> >>> zone write append emulation.
> >>>
> >>> Changes in V4:
> >>> - Fixed typos in 2 commit messages (patches 4 and 5)
> >>> - rephrased comment in dm_revalidate_zones() (patch 5)
> >>
> >> I gave this a quick spin and did not detect any issues.
> >> So feel free to add:
> >>
> >> Tested-by: Damien Le Moal <dlemoal@kernel.org>
> >>
> >> -- 
> >> Damien Le Moal
> >> Western Digital Research
> > 
> > Thanks.
> > 
> > I staged the patches for the next merge window.
> 
> Hmmm... These are all fixes, so shouldn't they go into rc3 ?

I think the fixed bugs are not serious (we haven't received any user's bug 
report that is fixed by these patches). And the patches are big and 
there's a risk that they break something. So, I wouldn't hurry with them.

Mikulas

