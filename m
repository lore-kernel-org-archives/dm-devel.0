Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EB31A0B15
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763487973; cv=none; b=HUx5rggQlHSwKx7efeG31Xiq2ucbzfXGjKXFcYHpHueVydFcrHvjHCaVuGnijq0MQer9r5jDUhAn25ya6dA3UtLzkuIsXYWpjRZpJ0YmYP5skJudm7UaDak/Eev+8ZiraDPFolKkEcAPlKSry63y6JfF7i3M8bESA1xzTQhmpDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763487973; c=relaxed/simple;
	bh=Uq5tdJmE6Xub5JGG6Pj2iyTFU40wozpXyX01LkAU6oA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XiZl9Z2FziMedPqfYRQRlU8PjlB30oQRkGB9rzG12dXFdNU77Vn2pPy2vyW15op01RZHdoMSJ7cvUtVrdtO68q71vD6iuohPAWv7gokRV9tG9S/F2B5peEAmBMtq3T8jXWWfoWTwws39ywb8d4a0G3c2u67+NAFQyMJ7Xr0pmpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IIN0vAVy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIN0vAVy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763487969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G8901ol403sdgwix9HvW+bPtTpZJsvQHfZY+Qf5mb54=;
	b=IIN0vAVy9ZBdUvq8x1IWwHwRQPd+VD2UiLsoqFpWv7K386wNGGHq4106g3TaTMiAaH9V77
	kqZnxhFBR+84xshsOyCXb3Mx5rtIMgfFbBSEpfiMtPDQ8dMoaQ4hijrefwqAoqyFayc9Lo
	8ddb469hOOvNlYEy/8vf2sE/SHnRDeE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-2Pjm58uMOa-TN9bmlTAX6A-1; Tue,
 18 Nov 2025 12:46:08 -0500
X-MC-Unique: 2Pjm58uMOa-TN9bmlTAX6A-1
X-Mimecast-MFC-AGG-ID: 2Pjm58uMOa-TN9bmlTAX6A_1763487967
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5230F1800372;
	Tue, 18 Nov 2025 17:46:07 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75DF3180087C;
	Tue, 18 Nov 2025 17:46:04 +0000 (UTC)
Date: Tue, 18 Nov 2025 18:45:55 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, 
    LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on
 bdev_logical_block_size
In-Reply-To: <aRvvSvyG8AK9hiCX@redhat.com>
Message-ID: <faafd90d-e41c-dcfc-cc25-7f29ff4f958c@redhat.com>
References: <20251020123350.2671495-1-urezki@gmail.com> <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com> <aRvvSvyG8AK9hiCX@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Mon, 17 Nov 2025, Benjamin Marzinski wrote:

> On Mon, Oct 20, 2025 at 02:48:13PM +0200, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 20 Oct 2025, Uladzislau Rezki (Sony) wrote:
> > 
> > > When performing a read-modify-write(RMW) operation, any modification
> > > to a buffered block must cause the entire buffer to be marked dirty.
> > > 
> > > Marking only a subrange as dirty is incorrect because the underlying
> > > device block size(ubs) defines the minimum read/write granularity. A
> > > lower device can perform I/O only on regions which are fully aligned
> > > and sized to ubs.
> > 
> > Hi
> > 
> > I think it would be better to fix this in dm-bufio, so that other dm-bufio 
> > users would also benefit from the fix.
> 
> This looks to me like it should accomplish the same thing as
> Uladzislau's patch. But I think there could still be problems with other
> dm-bufio users, for devices where the blocksize is larger than 4k.
> 
> In dm_bufio_client_create() I think we want to make sure that block_size
> is a multiple of bdev_logical_block_size(bdev), instead of 512b.

I could add WARN_ON(block_size < bdev_logical_block_size(bdev)) to 
dm_bufio_client_create. But I think it's too late in this development 
cycle, I would add it after the next merge window closes, when I open a 
new patch series for the kernel 6.20 (or 7.0).

> Otherwise block_to_sector() can return sectors that are not addressable
> on the device. Unfortunatley, I don't think all users of dm-bufio will
> pass in block_sizes that are larger than 4k (uds_make_bufio() in
> dm-vdp/indexer/io-factory.c for instance).
> 
> -Ben
> 
> > Please try this patch - does it fix it?
> > 
> > Mikulas

I changed the patch below, so that it aligns write bios on 
max3(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev), 
bdev_physical_block_size(b->c->bdev)); - so that if physical block size is 
greater than logical block size, the writes are aligned so that the device 
doesn't do read-modify-write.

Mikulas

> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > There may be devices with logical block size larger than 4k. Fix
> > dm-bufio, so that it will align I/O on logical block size. This commit
> > fixes I/O errors on the dm-ebs target on the top of emulated nvme device
> > with 8k logical block size created with qemu parameters:
> > 
> > -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> > 
> > ---
> >  drivers/md/dm-bufio.c |    9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/dm-bufio.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-bufio.c	2025-10-13 21:42:47.000000000 +0200
> > +++ linux-2.6/drivers/md/dm-bufio.c	2025-10-20 14:40:32.000000000 +0200
> > @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
> >  {
> >  	unsigned int n_sectors;
> >  	sector_t sector;
> > -	unsigned int offset, end;
> > +	unsigned int offset, end, align;
> >  
> >  	b->end_io = end_io;
> >  
> > @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
> >  			b->c->write_callback(b);
> >  		offset = b->write_start;
> >  		end = b->write_end;
> > -		offset &= -DM_BUFIO_WRITE_ALIGN;
> > -		end += DM_BUFIO_WRITE_ALIGN - 1;
> > -		end &= -DM_BUFIO_WRITE_ALIGN;
> > +		align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> > +		offset &= -align;
> > +		end += align - 1;
> > +		end &= -align;
> >  		if (unlikely(end > b->c->block_size))
> >  			end = b->c->block_size;
> >  
> > 
> 

