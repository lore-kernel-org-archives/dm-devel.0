Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5270D8C0B
	for <dm-devel@lists.linux.dev>; Wed, 19 Mar 2025 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742347365; cv=none; b=OhX87t0RfVZjt9LZnUYL59NwmAEAKdwNSyire+ZtdGBhhTgmzQCVKWb7k0dl1KVvBQKmKEqjrVu+H+i+vBgprOLV8kQsEd3PtHXLyRAD6EqkfQNqB6rLXgLhmYDeqLMPIkJQg2ocZRqjCmNxv5GQIzISx3h455Q4CtwDjEgO7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742347365; c=relaxed/simple;
	bh=Og5gMBu4yQLJLoNKB1vsd7hr6ai+Ji3bwLNoeb7EOtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkGMlhem/aHaKdMiZIaoQbA8UwxECGM8QpFFzOcasXjaWlHKteYvYIMdMxb1SrtlQYV3YWHmCR3jJmOt6XMHt0qfqhIUHiSRGPdZ+BlSZ99AEebdiBYmkmEIF2DrQPBxgQ08RqX27G6E3x51syLEuTmEcmY4P0A6scHqSbc8YgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3kKF0RL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3kKF0RL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742347360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YVnEpY4FTtltB2PlWR8iztmvBuYLVfPF3J9cZ6Q3XiQ=;
	b=J3kKF0RLlrpm3DQWjZzSL6bY2pMJ3CPlRniMYA7iMZOtSPDvYoUke5jKXR3p+Nnex3x8El
	XYCLAaAVwm7Oi7Is0aJRz4EvijYbe7s39aEIRjywX1Ub+fupQ0xJIwwqdjBpshx46iiVUu
	zFChgdowPDLupj6/+JFtttoFcoBnnhw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-z5KcS8DVPjuHgEndG4_DqQ-1; Tue,
 18 Mar 2025 21:22:36 -0400
X-MC-Unique: z5KcS8DVPjuHgEndG4_DqQ-1
X-Mimecast-MFC-AGG-ID: z5KcS8DVPjuHgEndG4_DqQ_1742347355
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B37ED180049D;
	Wed, 19 Mar 2025 01:22:34 +0000 (UTC)
Received: from fedora (unknown [10.72.120.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 201F03001D13;
	Wed, 19 Mar 2025 01:22:29 +0000 (UTC)
Date: Wed, 19 Mar 2025 09:22:24 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
Message-ID: <Z9ocUCrvXQRJHFVY@fedora>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
 <Z9mJmlhmZwnOlnqT@fedora>
 <d5193df0-5944-8cf6-7eb6-26adf191269e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5193df0-5944-8cf6-7eb6-26adf191269e@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Mar 18, 2025 at 04:31:35PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 18 Mar 2025, Ming Lei wrote:
> 
> > On Tue, Mar 18, 2025 at 03:26:10PM +0100, Mikulas Patocka wrote:
> > > The block limits may be read while they are being modified. The statement
> > 
> > It is supposed to not be so for IO path, that is why queue is usually down
> > or frozen when updating limit.
> 
> The limits are read at some points when constructing a bio - for example 
> bio_integrity_add_page, bvec_try_merge_hw_page, bio_integrity_map_user.

For request based code path, there isn't such issue because queue usage
counter is grabbed.

I should be one device mapper specific issue because the above interface
may not be called from dm_submit_bio().

One fix is to make sure that queue usage counter is grabbed in dm's bio/clone
submission code path.

> 
> > For other cases, limit lock can be held for sync the read/write.
> > 
> > Or you have cases not covered by both queue freeze and limit lock?
> 
> For example, device mapper reads the limits of the underlying devices 
> without holding any lock (dm_set_device_limits,

dm_set_device_limits() need to be fixed by holding limit lock.


> __process_abnormal_io, 
> __max_io_len).

The two is called with queue usage counter grabbed, so it should be fine.


> It also writes the limits in the I/O path - 
> disable_discard, disable_write_zeroes - you couldn't easily lock it here 
> because it happens in the interrupt contex.

IMO it is one bad implementation, why does device mapper have to clear
it in bio->end_io() or request's blk_mq_ops->complete()?

> 
> I'm not sure how many other kernel subsystems do it and whether they could 
> all be converted to locking.

Most request based driver should have been converted to new API.

I guess only device mapper / raid / other bio based driver should have such
kind of risk.

> 
> > > "q->limits = *lim" is not really atomic. The compiler may turn it into
> > > memcpy (clang does).
> > > 
> > > On x86-64, the kernel uses the "rep movsb" instruction for memcpy - it is
> > > optimized on modern CPUs, but it is not atomic, it may be interrupted at
> > > any byte boundary - and if it is interrupted, the readers may read
> > > garbage.
> > > 
> > > On sparc64, there's an instruction that zeroes a cache line without
> > > reading it from memory. The kernel memcpy implementation uses it (see
> > > b3a04ed507bf) to avoid loading the destination buffer from memory. The
> > > problem is that if we copy a block of data to q->limits and someone reads
> > > it at the same time, the reader may read zeros.
> > > 
> > > This commit changes it to use WRITE_ONCE, so that individual words are
> > > updated atomically.
> > 
> > It isn't necessary, for this particular problem, it is also fragile to
> > provide atomic word update in this low level way, such as, what if
> > sizeof(struct queue_limits) isn't 8byte aligned?
> 
> struct queue_limits contains two "unsigned long" fields, so it must be 
> aligned on "unsigned long" boundary.
> 
> In order to make it future-proof, we could use __alignof__(struct 
> queue_limits) to determine the size of the update step.

Yeah, it looks fine, but I feel it is still fragile, and not sure it is one
accepted solution.



Thanks,
Ming

