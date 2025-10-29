Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCEE3563C7
	for <dm-devel@lists.linux.dev>; Wed, 29 Oct 2025 10:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733481; cv=none; b=mpzNrGRn8dkIGqK2MjFr0RWf8TjjGPlhVrvgtAL0mtck1lR3T0AlIgYcYBduYys321wwELFkDmBSQWAsrqjF4QsgwpJfWVwo1cZY4Qy0f1r+HJz+YgtToSMXzmbYiRkof+lH7pbinSdsaGSGa8eDtCNXzW1ah+pZa9H6EdrKbBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733481; c=relaxed/simple;
	bh=Z44vuyu2MrVYwfTW/yc0pB6Ji3RTlKJKYIQJbHC8uPw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=t0mNdFdsIfXaP3LHP/p4c6wZ5w0Yy5PyTUelHC8ArCoPt3a+8CM79TVNoXXlyQ+1ilIJEKyty6tYyrjEyltyCcGFdUGnNJ7STqHf5k6vEqJyJdLHj9QRye9e6xND+MMpfnawl793XecItweRncEaiUGyWyqW3zjQltQXzQw2f6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B35ptEd5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B35ptEd5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761733478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E6f+84ImUEYc+D1CR/6xPUPVSLmLeBI4AIreT3xba8s=;
	b=B35ptEd5QpTBcTkFbcpVNSQuk1Lg1at0CjdhCMgDJ0r8+wQpTng9uyau7kv0+J7/laiGDQ
	ACJT2Ld+q5iBl/pKK+nT3SyyJ1GJknZ7arIs1MpRraLLpCrvbS2WJEnZDCq3ZY69RVfJpK
	piWHNiA/ok19bgk6wZqVkvyE0E4XR5s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-MXXfm3ZgNZ-qtSdGulSP5A-1; Wed,
 29 Oct 2025 06:24:35 -0400
X-MC-Unique: MXXfm3ZgNZ-qtSdGulSP5A-1
X-Mimecast-MFC-AGG-ID: MXXfm3ZgNZ-qtSdGulSP5A_1761733474
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC6FB19540DF;
	Wed, 29 Oct 2025 10:24:33 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 315FC1800579;
	Wed, 29 Oct 2025 10:24:30 +0000 (UTC)
Date: Wed, 29 Oct 2025 11:24:25 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, 
    LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on
 bdev_logical_block_size
In-Reply-To: <aQDCmAPfpIGZiceo@milan>
Message-ID: <b791d8e8-5e30-b50c-04ca-e823c0a06747@redhat.com>
References: <20251020123350.2671495-1-urezki@gmail.com> <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com> <aQCDLBie3fGwMDW2@milan> <aQDCmAPfpIGZiceo@milan>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Tue, 28 Oct 2025, Uladzislau Rezki wrote:

> On Tue, Oct 28, 2025 at 09:47:40AM +0100, Uladzislau Rezki wrote:
> > Hello!
> > 
> > Sorry i have missed you email for unknown reason to me. It is
> > probably because you answered to email with different subject
> > i sent initially.
> > 
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
> > > users would also benefit from the fix. Please try this patch - does it fix 
> > > it?
> > > 
> > If it solves what i describe i do not mind :)
> > 
> > > 
> > > 
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
> >
> Should it be physical_block_size of device? It is a min_io the device
> can perform. The point is, a user sets "ubs" size which should correspond
> to the smallest I/O the device can write, i.e. physically.

physical_block_size is unreliable - some SSDs report physical block size 
512 bytes, some 4k. Regardless of what they report, all current SSDs have 
4k sector size internally and they do slow read-modify-write cycle on 
requests that are not aligned on 4k boundary.

Mikulas

> --
> Uladzislau Rezki
> 

