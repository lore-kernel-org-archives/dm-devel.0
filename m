Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CDC2DE6F1
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751557019; cv=none; b=kON7WdsOklCR/ciCCEVcFngAA5GWvXfwuptw4Lk62jcuT6qEMugWdHziznSqCdZ5WddzBZJvDLA7V0kNJPjSD2jJvV1d2dnPnTi/c6odlgdQDAwzg703tqHAZAAqDZPvmOrEU/P1xQwR6MA/WV9LL710V+/KVGXMtWYWhN8xAj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751557019; c=relaxed/simple;
	bh=HjhLvZ/H1P2qjBwChvmJUpJrRBCOZ7tQGFPyGBSuZ7E=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Xv61Ls/xmgDKfLLqQjtCL2KMXFVLKewzloQxdU8ljZ9It7mB+K5YaOx2dHwkdXLpNF4vT2DKjTpmWuBYJB3uIm2AUxVdqpYibaRrudq05scebioH83YOSKrng8NXJ6ppj92AAOZUH3sqotf8c/71EraYPcZflzbOWnkozyIWPuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXhAWMgP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXhAWMgP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751557016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ZIDgAzyBTQUEBiTF8A+c8zCA7OsCfb4nYut225EcXo=;
	b=CXhAWMgPQIBxqAbpUzw0sxjKHa41d5B4VRmol+1s+cztszwzZK94eLAWbChAUgjQHZM7no
	rGsDRtyCqoYjZU9l9+/zzfLveCW0ca0ETEDWiCs9ga4WgQ9hUE/62CBbQ713je6QWZrXtF
	ajntyP459w2PCIedWb9AgO341yTwBww=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-xJKfPUenPTaLJA_uasGIVw-1; Thu,
 03 Jul 2025 11:36:53 -0400
X-MC-Unique: xJKfPUenPTaLJA_uasGIVw-1
X-Mimecast-MFC-AGG-ID: xJKfPUenPTaLJA_uasGIVw_1751557011
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 918041955D4E;
	Thu,  3 Jul 2025 15:36:50 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 333D11956087;
	Thu,  3 Jul 2025 15:36:45 +0000 (UTC)
Date: Thu, 3 Jul 2025 17:36:38 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, song@kernel.org, 
    yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
    ojaswin@linux.ibm.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
In-Reply-To: <f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
Message-ID: <8b5e009a-9e2a-4542-69fb-fc6d47287255@redhat.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com> <20250703114613.9124-6-john.g.garry@oracle.com> <b7bd63a0-7aa6-2fb3-0a2b-23285b9fc5fc@redhat.com> <f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Thu, 3 Jul 2025, John Garry wrote:

> > >   -/* Check stacking of first bottom device */
> > > -static bool blk_stack_atomic_writes_head(struct queue_limits *t,
> > > -				struct queue_limits *b)
> > > +static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
> > >   {
> > > -	if (b->atomic_write_hw_boundary &&
> > > -	    !blk_stack_atomic_writes_boundary_head(t, b))
> > > -		return false;
> > > +	unsigned int chunk_bytes = t->chunk_sectors << SECTOR_SHIFT;
> > 
> > What about integer overflow?
> 
> I suppose theoretically it could happen, and I'm happy to change.
> 
> However there seems to be precedent in assuming it won't:
> 
> - in stripe_op_hints(), we hold chunk_size in an unsigned int
> - in raid0_set_limits(), we hold mddev->chunk_sectors << 9 in lim.io_min,
> which is an unsigned int type.
> 
> Please let me know your thoughts on also changing these sort of instances. Is
> it realistic to expect chunk_bytes > UINT_MAX?
> 
> Thanks,
> John

dm-stripe can be created with a stripe size that is more than 0xffffffff 
bytes.

Though, the integer overflow already exists in the existing dm-stripe 
target:
static void stripe_io_hints(struct dm_target *ti,
                            struct queue_limits *limits)
{
        struct stripe_c *sc = ti->private;
        unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;

        limits->io_min = chunk_size;
        limits->io_opt = chunk_size * sc->stripes;
}
What should we set there as io_min and io_opt if sc->chunk_size << 
SECTOR_SHIFT overflows? Should we set nothing?

Mikulas

