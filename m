Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6DC10E3
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 01:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711071710; cv=none; b=WVeNXUSrZOKGzxdo9hGG/jDWYTmyyJIbtFhhrBEiEE1goVIGWtL5Ux5yNMUnLK/aYbqVe75HXxUPC63LwdgjKpxtn9lse6X5noSjXNns8QRic9tJ7ZDHWKZevH+p1XO60E19fnh1kg0P0FNeIBBqtiAPYw94wIxRAaSV9dUhkhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711071710; c=relaxed/simple;
	bh=Ft5u502/izjnsAwNWPy20E/m8yanrU19N5qyzi5Z+0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=tnpJXWhuSahBRbdMk6r3YIzSA8bhE1AY6K5FuV0k1LYPh1hfap517iqKihiUHTuNkO6F1uiXAkEmkHjaY6DiPI3NX3RRCORdILerXwK1x259fmCg6BK9TWHpk8PAXwEwi4/qofp3V6d/+/bfoJpicz6vsFzYFQ6boeHGNcH+8O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YF+q1hYk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YF+q1hYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711071707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R/meFkut62NYS10fTsS9z+PwawATcl6x28OcJlWH9ok=;
	b=YF+q1hYkiAnq2iKtm9UmgRLQ/ylueEgG7NYQZ8VSZX9s/TcrN/+y9q2lkvSwxdCt3SVU8Z
	WdtmA+BJqjwFcK1TaxqWkkl40HD5MpYuCOanmYSgzhb24FYDYOOmBNRI1aRkggZuRHpPKo
	UWhbC767oNfJXbyYI4fZvwAVTQNJ1AY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-zMAtkVeRNA61afGY8oRb-Q-1; Thu,
 21 Mar 2024 21:41:45 -0400
X-MC-Unique: zMAtkVeRNA61afGY8oRb-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3C253C025D2
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 01:41:44 +0000 (UTC)
Received: from fedora (unknown [10.72.116.75])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC0102166B33;
	Fri, 22 Mar 2024 01:41:40 +0000 (UTC)
Date: Fri, 22 Mar 2024 09:41:32 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	ming.lei@redhat.com
Subject: Re: [PATCH] dm-integrity: align the outgoing bio in integrity_recheck
Message-ID: <ZfzhzMgdJJaOZwGA@fedora>
References: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2024 at 05:48:45PM +0100, Mikulas Patocka wrote:
> It may be possible to set up dm-integrity with smaller sector size than
> the logical sector size of the underlying device. In this situation,
> dm-integrity guarantees that the outgoing bios have the same alignment as
> incoming bios (so, if you create a filesystem with 4k block size,
> dm-integrity would send 4k-aligned bios to the underlying device).
> 
> This guarantee was broken when integrity_recheck was implemented.
> integrity_recheck sends bio that is aligned to ic->sectors_per_block. So
> if we set up integrity with 512-byte sector size on a device with logical
> block size 4k, we would be sending unaligned bio. This triggered a bug in
> one of our internal tests.
> 
> This commit fixes it - it determines what's the actual alignment of the
> incoming bio and then makes sure that the outgoing bio in
> integrity_recheck has the same alignment.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/md/dm-integrity.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-integrity.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-integrity.c	2024-03-21 14:25:45.000000000 +0100
> +++ linux-2.6/drivers/md/dm-integrity.c	2024-03-21 17:47:39.000000000 +0100
> @@ -1699,7 +1699,6 @@ static noinline void integrity_recheck(s
>  	struct bio_vec bv;
>  	sector_t sector, logical_sector, area, offset;
>  	struct page *page;
> -	void *buffer;
>  
>  	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
>  	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
> @@ -1708,13 +1707,14 @@ static noinline void integrity_recheck(s
>  	logical_sector = dio->range.logical_sector;
>  
>  	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
> -	buffer = page_to_virt(page);
>  
>  	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
>  		unsigned pos = 0;
>  
>  		do {
> +			sector_t alignment;
>  			char *mem;
> +			char *buffer = page_to_virt(page);
>  			int r;
>  			struct dm_io_request io_req;
>  			struct dm_io_region io_loc;
> @@ -1727,6 +1727,14 @@ static noinline void integrity_recheck(s
>  			io_loc.sector = sector;
>  			io_loc.count = ic->sectors_per_block;
>  
> +			/* Align the bio to logical block size */
> +			alignment = dio->range.logical_sector | bio_sectors(bio) | (PAGE_SIZE >> SECTOR_SHIFT);
> +			alignment &= -alignment;

The above is less readable, :-(

> +			io_loc.sector = round_down(io_loc.sector, alignment);
> +			io_loc.count += sector - io_loc.sector;
> +			buffer += (sector - io_loc.sector) << SECTOR_SHIFT;
> +			io_loc.count = round_up(io_loc.count, alignment);

I feel the above code isn't very reliable, what we need actually is to
make sure that io's sector & size is aligned with dm's
bdev_logical_block_size(bdev).

Yeah, so far the max logical block size is 4k, but it may be increased
in future and you can see the recent lsfmm proposal, so can we force it to be
aligned with bdev_logical_block_size(bdev) here?

Also can the above change work efficiently in case of 64K PAGE_SIZE?


Thanks,
Ming

