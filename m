Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8DB2FBDEE
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 14:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763475358; cv=none; b=b1ZdGIy+YuST89uS4cx/emWI04omJH9enc8NBIo+mdFOHtG6abJUbDBbKkNaiArvvu5KlubVOMJH3qh+eShNKmiSxPijFHRhGWFCVOdw2e6PKB5Fa+6WGAdKSIGbFx1MVZa4ubDitBMotF+5mGqddE3cp6NxqFNoyy5zI94r6AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763475358; c=relaxed/simple;
	bh=3VanFUlwtJCYOKC06q6D9TNpy7f+Dce6HXVOIAC3gxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icSKA1dTryu9oD+2001bd98scI5C+AWcyi/X6zFhUETQltqO870PH7UuNk9kSC2mAubCRX0Ds8OXJ3fFuraUrD3BgbYfWk5vk3KQElGkE9MiZZbjIV/1kWW/pxFiMU7CT9jtjTz5/sPIzBqTaNR31Rx4hEHZvOvcrmlb8Z12k7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P4zQceOU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4zQceOU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763475356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FLeb0aSO6ShBdk/++whJBy+ffTiwQTO0U5adLdiKgNQ=;
	b=P4zQceOUg8X9KvijVolZwULoEqhVOEp5CG0JXIepIGLqyeLoDi9yUBrswcHaZOOPcMTacf
	X18H8+qoU6diJoH/JAorollSLTeTGz97Om7UmA6QII4O6wSo44WlXEeBRKnd0IlYcjobkd
	YvGcf1vpbp87XOEONVV9OLKhk62SsY0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-MOQUcxvwOTqAxvQNmARXgA-1; Tue,
 18 Nov 2025 09:15:52 -0500
X-MC-Unique: MOQUcxvwOTqAxvQNmARXgA-1
X-Mimecast-MFC-AGG-ID: MOQUcxvwOTqAxvQNmARXgA_1763475351
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C3A71956054;
	Tue, 18 Nov 2025 14:15:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A0AE3003754;
	Tue, 18 Nov 2025 14:15:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5AIEFmT5888889
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 09:15:48 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5AIEFmhJ888888;
	Tue, 18 Nov 2025 09:15:48 -0500
Date: Tue, 18 Nov 2025 09:15:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        DMML <dm-devel@lists.linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aRx_lCimJco5BPKA@redhat.com>
References: <20251117105945.10179-1-urezki@gmail.com>
 <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Nov 18, 2025 at 01:00:36PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 18 Nov 2025, Uladzislau Rezki wrote:
> 
> > Hello, Mikulas!
> > 
> > > Hi
> > > 
> > > What is the logical_block_size of the underlying nvme device? - i.e. 
> > > what's the content of this file 
> > > /sys/block/nvme0n1/queue/logical_block_size in the virtual machine?
> > > 
> > It is 512. Whereas a physical is bigger, i.e. my device can not perform
> > I/O by 512 granularity.
> 
> And what is physical block size? Is it 8192?
> 
> > As for virtual machine, i just simulated the problem so people can set
> > it up and check. The commit message describes how it can be reproduced.
> > 
> > The dm-ebs target which i setup does ebs to ubs conversion, so the NVME
> > driver gets BIOs are in size and aligned to ubs size. The ubs size
> > corresponds to the underlying physical device I/O size.
> > 
> > So your patch does not work if logical < physical. Therefore it does
> > not help my project.
> 
> Logical block size is the granularity at which the device can accept I/O. 
> Physical block size is the block size on the medium.
> 
> If logical < physical, then the device performs read-modify-write cycle 
> when writing blocks that are not aligned at physical block size.
> 
> So, your setup is broken, because it advertises logical block size 512, 
> but it is not able to perform I/O at this granularity.

This emulated nvme device is broken, but the question still remains,
"should dm-ebs enfore writing at the alignment that was specified in its
table line?" If you don't specify a ubs in the table line, it defaults
to the logical block size. So, if you do specify a ubs, it stands to
reason that you want IO at that alignment, instead of the logical-block
size (perhaps because your device is broken, and advertises the wrong
logical block size).  

So, I think that Uladzislau's patch makes sense, in addition to your
own.

-Ben
 
> There is this piece of code in include/linux/blkdev.h:
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> /*
>  * We should strive for 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER)
>  * however we constrain this to what we can validate and test.
>  */
> #define BLK_MAX_BLOCK_SIZE      SZ_64K
> #else
> #define BLK_MAX_BLOCK_SIZE      PAGE_SIZE
> #endif
> 
> /* blk_validate_limits() validates bsize, so drivers don't usually need to */
> static inline int blk_validate_block_size(unsigned long bsize)
> {
>         if (bsize < 512 || bsize > BLK_MAX_BLOCK_SIZE || !is_power_of_2(bsize))
>                 return -EINVAL;
> 
>         return 0;
> }
> 
> What happens when you define CONFIG_TRANSPARENT_HUGEPAGE in your .config? 
> Does it fix the problem with small logical block size for you?
> 
> Mikulas
> 
> > --
> > Uladzislau Rezki
> > 
> 

