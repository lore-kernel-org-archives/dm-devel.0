Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767073B798
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 10:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711103438; cv=none; b=tufMGGODswN+x5zm8z8xjszH+y2R1tlvExOcxBa7mM0RtqQb+ZEXLZYkk+BZpdsU5vmTP29dnjmzBZDydzBejSlntUgC3m0aRoAzLih7ShhoJHxdT4CN3sWiQPlk4HaHq7vvlDHD2hnZ/UyO7xL1oO3o3zDo1flaI0Wf2EPZILI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711103438; c=relaxed/simple;
	bh=GhLFdWmqALrGiZHyr3bDMknUS4Z8+SeJ9RxGIinpuU0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cS2duEqpowdWxy07ZEAn83eLuMo5q7z6+3edVsnSFC5am2lMCy+sUQqxWfeGPTYpxLsuRiw9SjvZVFHvVLBkON8QwmQ397wqgZoWxMK3BXDynQbwN8YWTdKx+EKb36sy2hzlotoWuHo/G17Sl3RDDLB1amTlr740KW/pkHZ58h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ih2SFFTS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ih2SFFTS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711103435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fks4KRlP9M9l52lz6JNabYxqq1jTQlUP2PLKCpeIw5c=;
	b=ih2SFFTSI3+PRZ+xy0cjoxbUKpOrMymSrizb+aOskCuE1k0GLOadOBrZiUtKS1Z/ZIyLkw
	9espNNW2Vi4gkotD17D4u8ICix6RxOldEYj9nvEx2Ck0jyyDWkvhNDNNCXCw62qyCRAf8b
	4u9yE+Kf1Y7lZCeJ2I6uPC9lIUwKkhQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-Ilk99Au7Pk229mo--Gfxfg-1; Fri, 22 Mar 2024 06:30:33 -0400
X-MC-Unique: Ilk99Au7Pk229mo--Gfxfg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D8A488B7A0
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 10:30:33 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D6F3492BC6;
	Fri, 22 Mar 2024 10:30:33 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 3AD1130BFECA; Fri, 22 Mar 2024 10:30:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 377523FB4B;
	Fri, 22 Mar 2024 11:30:33 +0100 (CET)
Date: Fri, 22 Mar 2024 11:30:33 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
cc: Mike Snitzer <msnitzer@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-integrity: align the outgoing bio in
 integrity_recheck
In-Reply-To: <ZfzhzMgdJJaOZwGA@fedora>
Message-ID: <2ca5a02-de66-a4bb-b42f-45ea54f79de@redhat.com>
References: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com> <ZfzhzMgdJJaOZwGA@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 22 Mar 2024, Ming Lei wrote:

> On Thu, Mar 21, 2024 at 05:48:45PM +0100, Mikulas Patocka wrote:
> > It may be possible to set up dm-integrity with smaller sector size than
> > the logical sector size of the underlying device. In this situation,
> > dm-integrity guarantees that the outgoing bios have the same alignment as
> > incoming bios (so, if you create a filesystem with 4k block size,
> > dm-integrity would send 4k-aligned bios to the underlying device).
> > 
> > This guarantee was broken when integrity_recheck was implemented.
> > integrity_recheck sends bio that is aligned to ic->sectors_per_block. So
> > if we set up integrity with 512-byte sector size on a device with logical
> > block size 4k, we would be sending unaligned bio. This triggered a bug in
> > one of our internal tests.
> > 
> > This commit fixes it - it determines what's the actual alignment of the
> > incoming bio and then makes sure that the outgoing bio in
> > integrity_recheck has the same alignment.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
> > Cc: stable@vger.kernel.org
> > 
> > ---
> >  drivers/md/dm-integrity.c |   12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/dm-integrity.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-integrity.c	2024-03-21 14:25:45.000000000 +0100
> > +++ linux-2.6/drivers/md/dm-integrity.c	2024-03-21 17:47:39.000000000 +0100
> > @@ -1699,7 +1699,6 @@ static noinline void integrity_recheck(s
> >  	struct bio_vec bv;
> >  	sector_t sector, logical_sector, area, offset;
> >  	struct page *page;
> > -	void *buffer;
> >  
> >  	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
> >  	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
> > @@ -1708,13 +1707,14 @@ static noinline void integrity_recheck(s
> >  	logical_sector = dio->range.logical_sector;
> >  
> >  	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
> > -	buffer = page_to_virt(page);
> >  
> >  	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
> >  		unsigned pos = 0;
> >  
> >  		do {
> > +			sector_t alignment;
> >  			char *mem;
> > +			char *buffer = page_to_virt(page);
> >  			int r;
> >  			struct dm_io_request io_req;
> >  			struct dm_io_region io_loc;
> > @@ -1727,6 +1727,14 @@ static noinline void integrity_recheck(s
> >  			io_loc.sector = sector;
> >  			io_loc.count = ic->sectors_per_block;
> >  
> > +			/* Align the bio to logical block size */
> > +			alignment = dio->range.logical_sector | bio_sectors(bio) | (PAGE_SIZE >> SECTOR_SHIFT);
> > +			alignment &= -alignment;
> 
> The above is less readable, :-(

It isolates the lowest bit from dio->range.logical_sector, 
bio_sectors(bio) and (PAGE_SIZE >> SECTOR_SHIFT).

See for example this https://www.felixcloutier.com/x86/blsi

> > +			io_loc.sector = round_down(io_loc.sector, alignment);
> > +			io_loc.count += sector - io_loc.sector;
> > +			buffer += (sector - io_loc.sector) << SECTOR_SHIFT;
> > +			io_loc.count = round_up(io_loc.count, alignment);
> 
> I feel the above code isn't very reliable, what we need actually is to
> make sure that io's sector & size is aligned with dm's
> bdev_logical_block_size(bdev).

I thought about using bdev_logical_block_size. But it may be wrong if the 
device stack is reconfigured. So, I concluded that taking the alignment 
from the bio would be better.

> Yeah, so far the max logical block size is 4k, but it may be increased
> in future and you can see the recent lsfmm proposal, so can we force it to be
> aligned with bdev_logical_block_size(bdev) here?
> 
> Also can the above change work efficiently in case of 64K PAGE_SIZE?

It doesn't work efficiently at all - this piece of code is only run in a 
pathological case where the user writes into a buffer while reading it (or 
when he reads multiple blocks into the same buffer), so I optimized it for 
size, not for performance.

But yes, it works with 64K PAGE_SIZE.

> Thanks,
> Ming

Mikulas

