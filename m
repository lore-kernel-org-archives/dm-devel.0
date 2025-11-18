Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF932DCF72
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 20:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763498213; cv=none; b=hWwlaXhh+ISqnzxRwlqyyh/BBb9PeQvCD71Sh3QS9xDmXHESQGxBwAitArlj5bgNTTKJKGnYGartkIk+UaIEjCOuFDspoarm+fHNTdo0Ww5FlcLJBIURyCsN0nThANcW9GG2gI1gbgO7efnN+scxmqWyUne2NlewMC9Vd2Wc80I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763498213; c=relaxed/simple;
	bh=/BIQr0ofYn501Q+iBz7Eqq3F10Y3iICaRmo34Ir9F8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eX6i/kEeZk7gFZ7M11AHm76GmaTIL2mGUYDi25/1/gO3lthZiOauoSKL7q4DLUj338HwLjrFRdXS+ebCREPZKl3hBmxol3PQ9zTSlQWOPvaUScK1gDs2M95BfWTCO7FvM8pQ9GSlT+xMZcimIllhIMegFlqqnPiICtWzE0YYr1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Etzg+a1S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Etzg+a1S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763498210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MrfjbXeDDlfi8M07MQMbkw+jAJU87ZrYxBghXs4a60M=;
	b=Etzg+a1SnuhSBjfV0Ojq/rRpaQZ6WkHJ9wdWULK6vCbw5dS9T2i7ctS49sHF2WOw139szp
	CR+M7r+r7HL6K7EYoUcC9J06yDyz9seuD+ELLGth5CCDdcPJXbQtH67ue5Kp6lr3zDVCP7
	Uy24tZ9MeWU2Cmdw9Ijwv5+PtIP/KQI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-534-rfqy3y1OOCW6p-vu3rnd4g-1; Tue,
 18 Nov 2025 15:36:37 -0500
X-MC-Unique: rfqy3y1OOCW6p-vu3rnd4g-1
X-Mimecast-MFC-AGG-ID: rfqy3y1OOCW6p-vu3rnd4g_1763498196
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D96921831371;
	Tue, 18 Nov 2025 20:36:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5EEA180049F;
	Tue, 18 Nov 2025 20:36:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5AIKaEIY899248
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 15:36:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5AIKaEsM899247;
	Tue, 18 Nov 2025 15:36:14 -0500
Date: Tue, 18 Nov 2025 15:36:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on bdev_logical_block_size
Message-ID: <aRzYvYCLW66Zhcda@redhat.com>
References: <20251020123350.2671495-1-urezki@gmail.com>
 <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>
 <aRvvSvyG8AK9hiCX@redhat.com>
 <faafd90d-e41c-dcfc-cc25-7f29ff4f958c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faafd90d-e41c-dcfc-cc25-7f29ff4f958c@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Nov 18, 2025 at 06:45:55PM +0100, Mikulas Patocka wrote:
> 
> 
> On Mon, 17 Nov 2025, Benjamin Marzinski wrote:
> 
> > On Mon, Oct 20, 2025 at 02:48:13PM +0200, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Mon, 20 Oct 2025, Uladzislau Rezki (Sony) wrote:
> > > 
> > > > When performing a read-modify-write(RMW) operation, any modification
> > > > to a buffered block must cause the entire buffer to be marked dirty.
> > > > 
> > > > Marking only a subrange as dirty is incorrect because the underlying
> > > > device block size(ubs) defines the minimum read/write granularity. A
> > > > lower device can perform I/O only on regions which are fully aligned
> > > > and sized to ubs.
> > > 
> > > Hi
> > > 
> > > I think it would be better to fix this in dm-bufio, so that other dm-bufio 
> > > users would also benefit from the fix.
> > 
> > This looks to me like it should accomplish the same thing as
> > Uladzislau's patch. But I think there could still be problems with other
> > dm-bufio users, for devices where the blocksize is larger than 4k.
> > 
> > In dm_bufio_client_create() I think we want to make sure that block_size
> > is a multiple of bdev_logical_block_size(bdev), instead of 512b.
> 
> I could add WARN_ON(block_size < bdev_logical_block_size(bdev)) to 
> dm_bufio_client_create. But I think it's too late in this development 
> cycle, I would add it after the next merge window closes, when I open a 
> new patch series for the kernel 6.20 (or 7.0).
> 
> > Otherwise block_to_sector() can return sectors that are not addressable
> > on the device. Unfortunatley, I don't think all users of dm-bufio will
> > pass in block_sizes that are larger than 4k (uds_make_bufio() in
> > dm-vdp/indexer/io-factory.c for instance).
> > 
> > -Ben
> > 
> > > Please try this patch - does it fix it?
> > > 
> > > Mikulas
> 
> I changed the patch below, so that it aligns write bios on 
> max3(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev), 
> bdev_physical_block_size(b->c->bdev)); - so that if physical block size is 
> greater than logical block size, the writes are aligned so that the device 
> doesn't do read-modify-write.

This will really only help if the bufio client block_size is a multiple
of the underlying device's physical block size, and the device is
aligned to the physical block size. Perhaps we should figure
out the alignment in dm_bufio_client_create(), with something like:

	c->align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(bdev));
	if (block_size & -bdev_physical_block_size(bdev) &&
	    bdev_alignment_offset(bdev) == 0)
		c->align = bdev_physical_block_size(bdev);

I suppose pre-calculating this could cause problems if the underlying
device was another dm device, and it switched tables in a way that
changed its limits. I dunno if we care about that, however.

-Ben 

> Mikulas
> 
> > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > 
> > > There may be devices with logical block size larger than 4k. Fix
> > > dm-bufio, so that it will align I/O on logical block size. This commit
> > > fixes I/O errors on the dm-ebs target on the top of emulated nvme device
> > > with 8k logical block size created with qemu parameters:
> > > 
> > > -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: stable@vger.kernel.org
> > > 
> > > ---
> > >  drivers/md/dm-bufio.c |    9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/md/dm-bufio.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/md/dm-bufio.c	2025-10-13 21:42:47.000000000 +0200
> > > +++ linux-2.6/drivers/md/dm-bufio.c	2025-10-20 14:40:32.000000000 +0200
> > > @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
> > >  {
> > >  	unsigned int n_sectors;
> > >  	sector_t sector;
> > > -	unsigned int offset, end;
> > > +	unsigned int offset, end, align;
> > >  
> > >  	b->end_io = end_io;
> > >  
> > > @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
> > >  			b->c->write_callback(b);
> > >  		offset = b->write_start;
> > >  		end = b->write_end;
> > > -		offset &= -DM_BUFIO_WRITE_ALIGN;
> > > -		end += DM_BUFIO_WRITE_ALIGN - 1;
> > > -		end &= -DM_BUFIO_WRITE_ALIGN;
> > > +		align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> > > +		offset &= -align;
> > > +		end += align - 1;
> > > +		end &= -align;
> > >  		if (unlikely(end > b->c->block_size))
> > >  			end = b->c->block_size;
> > >  
> > > 
> > 

