Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F7515746F
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744210526; cv=none; b=lK0FTSUl+6JKEZUDEP1qhTGZmibSFQTA0mP4cYOC4g52oEV2lwKtU/2r5kPdTWE3Bq7lz7nlhdgPIUP+UW8kTdfNNwpwWQPC051vZqQLTNMooZdr2hhQG9VdXRrpB7r5Tu0R9BDVGI+yHPTB+FjRVpcCZWr5jBDIQPyf38e2jmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744210526; c=relaxed/simple;
	bh=HUEQ896hg2jp5LmGbpX0l5o/pp+aT2dwagCCBIp6BiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=E/VuwurfsI1PP59+WEd2xpYRnU2CEQXbT5ZA1yanhUr4V/fwyjPmXJwPm979fx9z1GcMfhpN3yMPAtS1FT9nrye7uzWivUUABY1k3owJwsJqmJmB5b+zG7AtunjaieGmWI03BW5BQy0c66I/k2cByiBlBOK0kvvIbgsOLyliuek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hYFgTMI3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hYFgTMI3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744210523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GdrN1w49tKr7URhVgWqyGYcgDereFnUcCvHD1A6ANXk=;
	b=hYFgTMI3ndcA3NbpA2ekVzVN5bBZTKYnWKHCFieSvD7dT7a4G/jOuRR2ADpHT/4YT/3Eg3
	8gHxX6w0FRYTznlJ7yp86Pi9Rgs8e2EQ7SeJ46Kxo+5dgOk7+VfVoh7MenpWfkt0wLE+/l
	kyKNg9xN7DipdRJTtJjdTZs4X8Eevdo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-fdM9-rbVM-OgSg9F7P3cdg-1; Wed,
 09 Apr 2025 10:55:22 -0400
X-MC-Unique: fdM9-rbVM-OgSg9F7P3cdg-1
X-Mimecast-MFC-AGG-ID: fdM9-rbVM-OgSg9F7P3cdg_1744210521
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54E941800265;
	Wed,  9 Apr 2025 14:55:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B495C1956094;
	Wed,  9 Apr 2025 14:55:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 539EtJUe4153864
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 9 Apr 2025 10:55:19 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 539EtJxm4153863;
	Wed, 9 Apr 2025 10:55:19 -0400
Date: Wed, 9 Apr 2025 10:55:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 4/6] dm: fix dm_blk_report_zones
Message-ID: <Z_aKV4gM5HCMwXeU@redhat.com>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
 <20250408235159.4128838-5-bmarzins@redhat.com>
 <c3e3521a-daf2-4856-9db5-e093a7e59be9@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c3e3521a-daf2-4856-9db5-e093a7e59be9@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KRtEgDpZBELZE-Q26cFZQEsO543zdAX1bhTf_dQIVSk_1744210521
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 03:02:58PM +0900, Damien Le Moal wrote:
> On 4/9/25 8:51 AM, Benjamin Marzinski wrote:
> > If dm_get_live_table() returned NULL, dm_put_live_table() was never
> > called. Also, it is possible that md->zone_revalidate_map will change
> > while calling this function. Only read it once, so that we are always
> > using the same value. Otherwise we might miss a call to
> > dm_put_live_table().
> > 
> > Finally, while md->zone_revalidate_map is set and a process is calling
> > blk_revalidate_disk_zones() to set up the zone append emulation
> > resources, it is possible that another process, perhaps triggered by
> > blkdev_report_zones_ioctl(), will call dm_blk_report_zones(). If
> > blk_revalidate_disk_zones() fails, these resources can be freed while
> > the other process is still using them, causing a use-after-free error.
> > 
> > blk_revalidate_disk_zones() will only ever be called when initially
> > setting up the zone append emulation resources, such as when setting up
> > a zoned dm-crypt table for the first time. Further table swaps will not
> > set md->zone_revalidate_map or call blk_revalidate_disk_zones().
> > However it must be called using the new table (referenced by
> > md->zone_revalidate_map) and the new queue limits while the DM device is
> > suspended. dm_blk_report_zones() needs some way to distinguish between a
> > call from blk_revalidate_disk_zones(), which must be allowed to use
> > md->zone_revalidate_map to access this not yet activated table, and all
> > other calls to dm_blk_report_zones(), which should not be allowed while
> > the device is suspended and cannot use md->zone_revalidate_map, since
> > the zone resources might be freed by the process currently calling
> > blk_revalidate_disk_zones().
> > 
> > Solve this by tracking the process that set md->zone_revalidate_map
> > dm_revalidate_zones() and only allowing that process to make use of it
> > in dm_blk_report_zones().
> 
> ..that sets md->zone_revalidate_map in dm_revalidate_zones() and... ?

Yep. I'll fix that.

> > 
> > Fixes: f211268ed1f9b ("dm: Use the block layer zone append emulation")
> > Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> I do not recall reviewing this version, but looks OK to me with the sentence
> above fixed.

The code is the same as the original version that you reviewed, but I
forgot to remove your Reviewed-by when I rewrote the commit message.
Sorry.

-Ben

> 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

