Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1DC12C819
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713274248; cv=none; b=Dys2AeqyQl/K8X2aLydanBdPhLnxaDfX7uEJB+sE9fKouG4vFUiKnPwF+0fkGZ5pW3VA2LbXjE8p4t6XOzCy1qgWNpIXEmT3LhKGQRyXljKWy0E79kVL8fsfAwYohy5GBz4pe4brVBc3fbmGTyDKNcm4yIn/hpC74VkNXGt0D58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713274248; c=relaxed/simple;
	bh=4o3jbPGF5aLP95zMfmUFigJWBB+90uNzS65Y2AN+b6Y=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=npQW3iX3iQc9clS2u3/t5MRV3iG0KsVqXAQj4jrO96FUUDZUyhBAOQamjWj20fe9DENtTUIfJBuNvot2Fm31VO9/FX3TCsAozR6fN49QmN/tKO0zZU68+NiYqMwGoBj+yXkKVcyfW3cE9CH3aj+MlQ9xbnXM08/l4/THyYdrlf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i2DBkE9k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i2DBkE9k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713274245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UH03/5nBsMN52IqYQjlbBdBJW2F80V+mTlh1m4rzE68=;
	b=i2DBkE9kGywZnSDOFDA8nUzi25y/dKKZaZ1kKxhcpy17ntmvq9KCoZw4yLfwjt68zbA3+w
	MoJ6oigk1Xj5iY/ZAS7VS71uuCV6oL3E8D3e3AtSvQ+pdXOvzVaLjYGxqa8vwSpnE6XKZX
	iLR4exPop0XdDPsobPSVcUGgtDXpxMs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-i4j1sbJaPIiRMXw0Rnxx7g-1; Tue,
 16 Apr 2024 09:30:42 -0400
X-MC-Unique: i4j1sbJaPIiRMXw0Rnxx7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 059723C0ED4B;
	Tue, 16 Apr 2024 13:30:42 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28B4A1C06666;
	Tue, 16 Apr 2024 13:30:41 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 06DD930C2BF7; Tue, 16 Apr 2024 13:30:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 033D43FB54;
	Tue, 16 Apr 2024 15:30:41 +0200 (CEST)
Date: Tue, 16 Apr 2024 15:30:40 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Eric Biggers <ebiggers@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, 
    Daniel Lee <chullee@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] dm: Change the default value of rq_affinity from 0 into
 1
In-Reply-To: <c107bba4-03a1-4121-af9e-7c93f40c24a0@acm.org>
Message-ID: <1494d512-9eb0-2091-8e9f-fbb28d2441d1@redhat.com>
References: <20240415194921.6404-1-bvanassche@acm.org> <20cf8b38-6c5b-9a10-6a7b-5d587a19eed@redhat.com> <c107bba4-03a1-4121-af9e-7c93f40c24a0@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7



On Mon, 15 Apr 2024, Bart Van Assche wrote:

> On 4/15/24 12:56, Mikulas Patocka wrote:
> > I am wondering how should QUEUE_FLAG_SAME_COMP work for bio-based
> > devices.
> > 
> > I grepped the kernel for QUEUE_FLAG_SAME_COMP and it is tested in
> > block/blk-mq.c in blk_mq_complete_need_ipi (this code path is taken only
> > for request-based devices) and in block/blk-sysfs.c in
> > queue_rq_affinity_show (this just displays the value in sysfs). There are
> > no other places where QUEUE_FLAG_SAME_COMP is tested, so I don't see what
> > effect is it supposed to have.
> 
> I think the answer depends on whether or not the underlying device
> defines the .submit_bio() callback. From block/blk-core.c:
> 
> static void __submit_bio(struct bio *bio)
> {
> 	if (unlikely(!blk_crypto_bio_prep(&bio)))
> 		return;
> 
> 	if (!bio->bi_bdev->bd_has_submit_bio) {
> 		blk_mq_submit_bio(bio);
> 	} else if (likely(bio_queue_enter(bio) == 0)) {
> 		struct gendisk *disk = bio->bi_bdev->bd_disk;
> 
> 		disk->fops->submit_bio(bio);
> 		blk_queue_exit(disk->queue);
> 	}
> }
> 
> In other words, if the .submit_bio() callback is defined, that function
> is called. If it is not defined, blk_mq_submit_bio() converts the bio
> into a request. QUEUE_FLAG_SAME_COMP affects the request completion
> path. On my test setup there are multiple dm instances defined on top of
> SCSI devices. The SCSI core does not implement the .submit_bio()
> callback.
> 
> Thanks,
> 
> Bart.

Yes, setting the flag QUEUE_FLAG_SAME_COMP for bio-based drivers (those 
that define .submit_bio) has no effect. So, I think that you patch doesn't 
have any effect too.

Mikulas

