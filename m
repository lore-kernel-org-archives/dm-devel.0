Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E242E5B09
	for <dm-devel@lists.linux.dev>; Tue,  8 Jul 2025 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993980; cv=none; b=C6J/0vI/5Pf9BMXjWqehawRJlXeCTLwkNcyvdedTFOnDe/I3cZE5ey8sKrPpbltFpCVc/m36wbHhu8FPSCwnUFYOx1q0ZVeDDbi9TncSCe5MnL4r6UxbNSyEWAoda/PytqkDEwQw9u5kbAn3kfLXVXso7UXYV2FCtQNsaZer9os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993980; c=relaxed/simple;
	bh=E8SMxKBRB9kxzDAXjp9QuVVcwFm86lamgTddZeM3ZM4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lwULgkf+mKa8tzcSt62EcagG6oleXG136HWUaZf8ws/QDQ6dFQkC3JrXqAf3UwWxCz7NZG49zgcF6/+RuVjxeCdDoy/QigqRQK03L9LSf8Ncz27OngeydyndnHD4AZvGPrC2Yg1/X2su28n9m9ts3l+OCVRvMCKLtSlPiNo8FkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0tAzL8A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0tAzL8A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751993977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5eadIydjygmdVrAvV3gcaJXEaiXTDN8BupiuAPwYI2k=;
	b=b0tAzL8A9SK3596Lsf8d9rr1rCVjpv+PWHGT5Vr4gglUwItVQT2aG3rrgDnIOwBzT+bdb9
	pf2fdpZJTUbjTEAqc5kzTT7949y+THWWvZJSpogm9Ugqiu2pDWNjhDOXOvjFky/uXNsQcp
	PFBxY2cHcGZihCQ4ujE2LY8tL3a4EUM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-Q7OICD-UN4GQCVEfevW_mA-1; Tue,
 08 Jul 2025 12:59:31 -0400
X-MC-Unique: Q7OICD-UN4GQCVEfevW_mA-1
X-Mimecast-MFC-AGG-ID: Q7OICD-UN4GQCVEfevW_mA_1751993969
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61BDB1955EC3;
	Tue,  8 Jul 2025 16:59:28 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E26230001B1;
	Tue,  8 Jul 2025 16:59:21 +0000 (UTC)
Date: Tue, 8 Jul 2025 18:59:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Nilay Shroff <nilay@linux.ibm.com>
cc: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org, 
    song@kernel.org, yukuai3@huawei.com, hch@lst.de, axboe@kernel.dk, 
    cem@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
    ojaswin@linux.ibm.com, martin.petersen@oracle.com, 
    akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v4 6/6] block: use chunk_sectors when evaluating stacked
 atomic write limits
In-Reply-To: <51e56dcf-6a64-42d1-b488-7043f880026e@linux.ibm.com>
Message-ID: <f5ddc161-5683-f008-4794-32eccf88af65@redhat.com>
References: <20250707131135.1572830-1-john.g.garry@oracle.com> <20250707131135.1572830-7-john.g.garry@oracle.com> <51e56dcf-6a64-42d1-b488-7043f880026e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Tue, 8 Jul 2025, Nilay Shroff wrote:

> 
> 
> On 7/7/25 6:41 PM, John Garry wrote:
> > The atomic write unit max value is limited by any stacked device stripe
> > size.
> > 
> > It is required that the atomic write unit is a power-of-2 factor of the
> > stripe size.
> > 
> > Currently we use io_min limit to hold the stripe size, and check for a
> > io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.
> > 
> > Nilay reports that this causes a problem when the physical block size is
> > greater than SECTOR_SIZE [0].
> > 
> > Furthermore, io_min may be mutated when stacking devices, and this makes
> > it a poor candidate to hold the stripe size. Such an example (of when
> > io_min may change) would be when the io_min is less than the physical
> > block size.
> > 
> > Use chunk_sectors to hold the stripe size, which is more appropriate.
> > 
> > [0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781
> > 
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > ---
> >  block/blk-settings.c | 58 ++++++++++++++++++++++++++------------------
> >  1 file changed, 35 insertions(+), 23 deletions(-)
> > 
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index 761c6ccf5af7..3259cfac5d0d 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -597,41 +597,52 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
> >  	return true;
> >  }
> >  
> > -
> > -/* Check stacking of first bottom device */
> > -static bool blk_stack_atomic_writes_head(struct queue_limits *t,
> > -				struct queue_limits *b)
> > +static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
> >  {
> > -	if (b->atomic_write_hw_boundary &&
> > -	    !blk_stack_atomic_writes_boundary_head(t, b))
> > -		return false;
> > +	unsigned int chunk_sectors = t->chunk_sectors, chunk_bytes;
> >  
> > -	if (t->io_min <= SECTOR_SIZE) {
> > -		/* No chunk sectors, so use bottom device values directly */
> > -		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
> > -		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
> > -		t->atomic_write_hw_max = b->atomic_write_hw_max;
> > -		return true;
> > -	}
> > +	if (!chunk_sectors)
> > +		return;
> > +
> > +	/*
> > +	 * If chunk sectors is so large that its value in bytes overflows
> > +	 * UINT_MAX, then just shift it down so it definitely will fit.
> > +	 * We don't support atomic writes of such a large size anyway.
> > +	 */
> > +	if ((unsigned long)chunk_sectors << SECTOR_SHIFT > UINT_MAX)
> > +		chunk_bytes = chunk_sectors;
> > +	else
> > +		chunk_bytes = chunk_sectors << SECTOR_SHIFT;

Why do we cast it to unsigned long? unsigned long is 32-bit on 32-bit 
machines, so the code will not detect the overflow in that case. We should 
cast it to unsigned long long (or uint64_t).

Mikulas

