Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0438EACE
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 04:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763438426; cv=none; b=k98iQ9hszu3t2bhaQih6QYFovYhgxKna91A07Lz3Xsc5jVjNYZkjnhTzMDuipHRODavWVCq3R2Xs66AcuevBzAPS/Uze1qklIv39/KfdpsU+7sJpyEGZ5CChTl/gAI4nht0hOtwQ23217MLm/APvz3rOaDUedhdvIOCVUmSfJPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763438426; c=relaxed/simple;
	bh=997Z/maGHsLf44LM0O8nw64Dh8HJPtN75NwCQR39bb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anIcIFOoJX36UbvAUXHOWHi+UAlH6nYGm+lx4o+PctdEzgzvwHewQ1tf4z2KapPXjNgCIc1BsEiN7lmm9n3ved+9NOPqNwEQc01p1vnJPODL67EpFDYsHvC6sD04KdbMNe5oksQbSDUPOUFsZbTs7/cxNdeZveKmPCPvZ8MvTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bmadW3y5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmadW3y5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763438422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZkEltBYdN5/6okIVR3iMzWAPc8m/JFkzzrpVoC+klpk=;
	b=bmadW3y5hvjQHsrRP0f+6PJm1Os1zXSbgXJ0m4P+I5UWSLA5+pJkK1t178L2fPYAPT1GXb
	b9F3mCsK2BYiBPoNeJ4xPDmo3fbwEtIu7PL8vHBIk0D10gmT1bvMJl+UFIBwQuXV6jb+7w
	6PtTCbm4IBoqmGGDmMxqNxRfMii+/wA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-340-3z-R1LzPNKygbRkvtBfgfQ-1; Mon,
 17 Nov 2025 23:00:17 -0500
X-MC-Unique: 3z-R1LzPNKygbRkvtBfgfQ-1
X-Mimecast-MFC-AGG-ID: 3z-R1LzPNKygbRkvtBfgfQ_1763438416
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DA6B1956057;
	Tue, 18 Nov 2025 04:00:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C09A19560A7;
	Tue, 18 Nov 2025 04:00:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5AI40AsF872578
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 23:00:10 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5AI40Ara872577;
	Mon, 17 Nov 2025 23:00:10 -0500
Date: Mon, 17 Nov 2025 23:00:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on bdev_logical_block_size
Message-ID: <aRvvSvyG8AK9hiCX@redhat.com>
References: <20251020123350.2671495-1-urezki@gmail.com>
 <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Oct 20, 2025 at 02:48:13PM +0200, Mikulas Patocka wrote:
> 
> 
> On Mon, 20 Oct 2025, Uladzislau Rezki (Sony) wrote:
> 
> > When performing a read-modify-write(RMW) operation, any modification
> > to a buffered block must cause the entire buffer to be marked dirty.
> > 
> > Marking only a subrange as dirty is incorrect because the underlying
> > device block size(ubs) defines the minimum read/write granularity. A
> > lower device can perform I/O only on regions which are fully aligned
> > and sized to ubs.
> 
> Hi
> 
> I think it would be better to fix this in dm-bufio, so that other dm-bufio 
> users would also benefit from the fix.

This looks to me like it should accomplish the same thing as
Uladzislau's patch. But I think there could still be problems with other
dm-bufio users, for devices where the blocksize is larger than 4k.

In dm_bufio_client_create() I think we want to make sure that block_size
is a multiple of bdev_logical_block_size(bdev), instead of 512b.
Otherwise block_to_sector() can return sectors that are not addressable
on the device. Unfortunatley, I don't think all users of dm-bufio will
pass in block_sizes that are larger than 4k (uds_make_bufio() in
dm-vdp/indexer/io-factory.c for instance).

-Ben

> Please try this patch - does it fix it?
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> There may be devices with logical block size larger than 4k. Fix
> dm-bufio, so that it will align I/O on logical block size. This commit
> fixes I/O errors on the dm-ebs target on the top of emulated nvme device
> with 8k logical block size created with qemu parameters:
> 
> -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/md/dm-bufio.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-bufio.c	2025-10-13 21:42:47.000000000 +0200
> +++ linux-2.6/drivers/md/dm-bufio.c	2025-10-20 14:40:32.000000000 +0200
> @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
>  {
>  	unsigned int n_sectors;
>  	sector_t sector;
> -	unsigned int offset, end;
> +	unsigned int offset, end, align;
>  
>  	b->end_io = end_io;
>  
> @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
>  			b->c->write_callback(b);
>  		offset = b->write_start;
>  		end = b->write_end;
> -		offset &= -DM_BUFIO_WRITE_ALIGN;
> -		end += DM_BUFIO_WRITE_ALIGN - 1;
> -		end &= -DM_BUFIO_WRITE_ALIGN;
> +		align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> +		offset &= -align;
> +		end += align - 1;
> +		end &= -align;
>  		if (unlikely(end > b->c->block_size))
>  			end = b->c->block_size;
>  
> 

