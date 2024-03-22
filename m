Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E1227453
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 12:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711109006; cv=none; b=CO7MSPR+sG5CT0pymKCLTJxnw9VUvKeD6+ZqbasEnOVCBAMi29oV3PigxkR8aIq6Y+rJ9F8O7oiE0OCvJZz+OEUx7OhBJzw2v+y/2hp2S3pNUP0RVjgCLk8D/KE7qRWMLxK5u2qewspCR7/f7gCX9W1N7ppDHPzpdITMBbSO72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711109006; c=relaxed/simple;
	bh=fA/wMQyIlKM6/W1s+hUEIOQ/5WAUrByoWhNnkG3psqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=R7c2BtwKFD71pH0VqW7Qe9wPam7+g59K6Abc4yU1fQTPPzlHyg/N5XjCSLZKi5iuTtTGghHYhD+YMldcwEXaqGLu1WiP5Dhb6S4HYpAmbxlyr/bkEKg1MGOOh7bsZ3nX5ZvULaS8knLXOxaaq/hZBaAyKk71Ix5qFm4GSjZmwVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KL282dbt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KL282dbt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711109003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9FYK+sZ+7XbmqRJYBCWZvDI7J/5HEqDmyieTnlhXNKU=;
	b=KL282dbtB1TNixWpqEIzpgt/R9gk88hTtK2GacaoeO3W711e1qt2kFt5ieEySSRjcYZ1WS
	xCufvAyTGjr4ygleG8sjivYgfcki8c4bjSuryqrYVCXu6aYhuo4l4U2yuAiGtA6b606B0f
	bQbOBAPNjPVDRA++zsRj5I+3USojAwI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-50bShw5SOEG-0ofo8U_GfA-1; Fri, 22 Mar 2024 08:03:22 -0400
X-MC-Unique: 50bShw5SOEG-0ofo8U_GfA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 331C4185A783
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 12:03:22 +0000 (UTC)
Received: from fedora (unknown [10.72.116.114])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E87601C060A4;
	Fri, 22 Mar 2024 12:03:18 +0000 (UTC)
Date: Fri, 22 Mar 2024 20:03:10 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	ming.lei@redhat.com
Subject: Re: [PATCH] dm-integrity: align the outgoing bio in integrity_recheck
Message-ID: <Zf1zfjuzb9be0Uwz@fedora>
References: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com>
 <ZfzhzMgdJJaOZwGA@fedora>
 <2ca5a02-de66-a4bb-b42f-45ea54f79de@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2ca5a02-de66-a4bb-b42f-45ea54f79de@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 22, 2024 at 11:30:33AM +0100, Mikulas Patocka wrote:
> 
> 
> On Fri, 22 Mar 2024, Ming Lei wrote:
> 
> > On Thu, Mar 21, 2024 at 05:48:45PM +0100, Mikulas Patocka wrote:
> > > It may be possible to set up dm-integrity with smaller sector size than
> > > the logical sector size of the underlying device. In this situation,
> > > dm-integrity guarantees that the outgoing bios have the same alignment as
> > > incoming bios (so, if you create a filesystem with 4k block size,
> > > dm-integrity would send 4k-aligned bios to the underlying device).
> > > 
> > > This guarantee was broken when integrity_recheck was implemented.
> > > integrity_recheck sends bio that is aligned to ic->sectors_per_block. So
> > > if we set up integrity with 512-byte sector size on a device with logical
> > > block size 4k, we would be sending unaligned bio. This triggered a bug in
> > > one of our internal tests.
> > > 
> > > This commit fixes it - it determines what's the actual alignment of the
> > > incoming bio and then makes sure that the outgoing bio in
> > > integrity_recheck has the same alignment.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
> > > Cc: stable@vger.kernel.org
> > > 
> > > ---
> > >  drivers/md/dm-integrity.c |   12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/md/dm-integrity.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/md/dm-integrity.c	2024-03-21 14:25:45.000000000 +0100
> > > +++ linux-2.6/drivers/md/dm-integrity.c	2024-03-21 17:47:39.000000000 +0100
> > > @@ -1699,7 +1699,6 @@ static noinline void integrity_recheck(s
> > >  	struct bio_vec bv;
> > >  	sector_t sector, logical_sector, area, offset;
> > >  	struct page *page;
> > > -	void *buffer;
> > >  
> > >  	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
> > >  	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
> > > @@ -1708,13 +1707,14 @@ static noinline void integrity_recheck(s
> > >  	logical_sector = dio->range.logical_sector;
> > >  
> > >  	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
> > > -	buffer = page_to_virt(page);
> > >  
> > >  	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
> > >  		unsigned pos = 0;
> > >  
> > >  		do {
> > > +			sector_t alignment;
> > >  			char *mem;
> > > +			char *buffer = page_to_virt(page);
> > >  			int r;
> > >  			struct dm_io_request io_req;
> > >  			struct dm_io_region io_loc;
> > > @@ -1727,6 +1727,14 @@ static noinline void integrity_recheck(s
> > >  			io_loc.sector = sector;
> > >  			io_loc.count = ic->sectors_per_block;
> > >  
> > > +			/* Align the bio to logical block size */
> > > +			alignment = dio->range.logical_sector | bio_sectors(bio) | (PAGE_SIZE >> SECTOR_SHIFT);
> > > +			alignment &= -alignment;
> > 
> > The above is less readable, :-(
> 
> It isolates the lowest bit from dio->range.logical_sector, 
> bio_sectors(bio) and (PAGE_SIZE >> SECTOR_SHIFT).
> 
> See for example this https://www.felixcloutier.com/x86/blsi

Fine, but I have to say such usage isn't popular.

> 
> > > +			io_loc.sector = round_down(io_loc.sector, alignment);
> > > +			io_loc.count += sector - io_loc.sector;
> > > +			buffer += (sector - io_loc.sector) << SECTOR_SHIFT;
> > > +			io_loc.count = round_up(io_loc.count, alignment);
> > 
> > I feel the above code isn't very reliable, what we need actually is to
> > make sure that io's sector & size is aligned with dm's
> > bdev_logical_block_size(bdev).
> 
> I thought about using bdev_logical_block_size. But it may be wrong if the 
> device stack is reconfigured. So, I concluded that taking the alignment 
> from the bio would be better.

If logical block becomes mismatched by reconfiguration, the whole DM stack can't work:

- at the beginning, DM is over NVMe(512 bs), DM & NVMe lbs is 512
- later, nvme is reconfigured and its lbs becomes 4k, but DM's lbs can't
be updated
- then unaligned IO is submitted to NVMe

So DM _never_ works with mis-matched logical block size because of
reconfigure, and same with MD.

> 
> > Yeah, so far the max logical block size is 4k, but it may be increased
> > in future and you can see the recent lsfmm proposal, so can we force it to be
> > aligned with bdev_logical_block_size(bdev) here?
> > 
> > Also can the above change work efficiently in case of 64K PAGE_SIZE?
> 
> It doesn't work efficiently at all - this piece of code is only run in a 
> pathological case where the user writes into a buffer while reading it (or 
> when he reads multiple blocks into the same buffer), so I optimized it for 
> size, not for performance.
> 
> But yes, it works with 64K PAGE_SIZE.

Fine, but I still think PAGE_SIZE is hard to follow than logical block
size.

Thanks,
Ming

