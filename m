Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952FA2E336E
	for <dm-devel@lists.linux.dev>; Fri, 14 Mar 2025 13:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741959980; cv=none; b=Sw6gEvjRsDaBv4ux7YNlWYDKsDUcYKR+o/d6r8Xw3b2i3nQFaxRWpc/WXSBrloilhRgD3b3uyV3dQXIAkaEYv6BYYpZsc/3/KaSc1rFaGMg+IDV4gxoN+sLtNNvkA1nmTsY4txn5s91a5K1FiOnvybX3Ox8jdPXURy53evhTC3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741959980; c=relaxed/simple;
	bh=CMosphvIKObhrydM+YJMtYd9w5/5+7A3bY1ZPhjerxk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lw5lSKb3Epq7Wgnb/2UdrZ1PAnP3MC92No9qJ2wbmAjNkwZs9zlaGj3TzaTUM8BhDATuwZOuUpaTjbp5Rpvk/poAQ6I+L/qMotujV+6INMONORH0yry/uDWwHBfGSHXgEerYZXDkYboK1yOd0Aww2Ni5VHNP6lr76w4gcD3zqbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4Knb+b8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4Knb+b8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741959977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bpaiR54VREhXZFyomjKr4V+aMQOgKWe9LPRjtR3j5E8=;
	b=X4Knb+b8zpQ2EtZxI+YzMS3W/YmO+2Gvuww7C5bQJcWghXyNdqLH0gRmGUmEGmZb007rvi
	U/P23OBTlIugQ9TlIi/3o2IH7LaIvBeLfWKHYaY+2RK3Qjh2eKFC6EvaoGegKj27VhOSdv
	QVTXJhK6Q5LFX7H9H2ic1Mq0TnH8ye4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-YdDR5skXPNehbMugQ1myXQ-1; Fri,
 14 Mar 2025 09:46:14 -0400
X-MC-Unique: YdDR5skXPNehbMugQ1myXQ-1
X-Mimecast-MFC-AGG-ID: YdDR5skXPNehbMugQ1myXQ_1741959973
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BD8619560B7;
	Fri, 14 Mar 2025 13:46:12 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A43981954B32;
	Fri, 14 Mar 2025 13:46:09 +0000 (UTC)
Date: Fri, 14 Mar 2025 14:46:06 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
    dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
    Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] dm: handle failures in dm_table_set_restrictions
In-Reply-To: <ad565ffc-d34e-7c24-ab2b-aad4774f92f1@redhat.com>
Message-ID: <260b3f5f-a58e-0815-6d27-7efff0e1fc76@redhat.com>
References: <20250309222904.449803-1-bmarzins@redhat.com> <20250309222904.449803-4-bmarzins@redhat.com> <9b5ff861-964d-472c-9267-5e5b10186ed3@kernel.org> <Z88jTxQqoLitl4ee@redhat.com> <Z88sP2WyotRbTd2E@redhat.com> <60f0f94c-3c80-4806-82aa-04ace428b4d4@kernel.org>
 <ad565ffc-d34e-7c24-ab2b-aad4774f92f1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Fri, 14 Mar 2025, Mikulas Patocka wrote:

> 
> 
> On Tue, 11 Mar 2025, Damien Le Moal wrote:
> 
> > Yes, for simple scalar limits, I do not think there is any issue. But there are
> > some cases where changing one limit implies a change to other limits when the
> > limits are committed (under the limits lock). So my concern was that if the
> > above runs simultaneously with a queue limits commit, we may endup with the
> > limits struct copy grabbing part of the new limits and thus resulting in an
> > inconsistent limits struct. Not entirely sure that can actually happen though.
> > But given that queue_limits_commit_update() does:
> > 
> > 	q->limits = *lim;
> > 
> > and this code does:
> > 
> > 	old_limits = q->limits;
> > 
> > we may endup depending on how the compiler handles the struct copy ?
> 
> There is no guarantee that struct copy will update the structure fields 
> atomically.
> 
> On some CPUs, a "rep movsb" instruction may be used, which may be 
> optimized by the CPU, but it may be also interrupted at any byte boundary.
> 
> I think it should be changed to the sequence of WRITE_ONCE statements, for 
> example:
> WRITE_ONCE(q->limits->file, lim->field);
> 
> Mikulas

BTW. some SPARC CPUs had an instruction that would zero a cache line 
without loading it from memory. The memcpy implementation on SPARC used 
this instruction to avoid loading data that would be soon overwritten.

The result was that if you read a region of memory concurrently with 
memcpy writing to it, you could read zeros produced by this instruction.

Mikulas

