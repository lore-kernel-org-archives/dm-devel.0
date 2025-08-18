Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD65A270EC3
	for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755546574; cv=none; b=qsOy4nhJqiiIGTLxyR0h+oY+X29G2njP8WCOJTCIqCsPQ9ptNNrk8Sfn853DIxiZQ9zFYXyItYV78RpriNcN3MVklFRux+5jwg8X7mCj9HzxEOblx9O94bjACnwITxgODAqGjTzJo5iakaJRwJOpx/IjppdNg5Yv+hVSyUJNF/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755546574; c=relaxed/simple;
	bh=cprxfOc+eVtACcryEFDk+QBR8PINRf8kj+GwKv/0Lao=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=V9YeqsTmIFW1zoeDKdKnSi7Jl1uIM56sNvRqCubtkL+98MYot3VsGqePvB4WSkNlNTfGvsphgTlepe1MGbek6qN7gFBtPunXEBeMrViwtbE7ee38rjnCaSPi9eRRsh2oVtnFJaIpjRCva/4jDSnOLGYLcpHL3qo3b9FkcqObZlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oqr15B9m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oqr15B9m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755546571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RiY+4IGQeTE+5ct8Gxi/it/2AEj7Q2K6a7U9csc5po=;
	b=Oqr15B9mTJ2Fkr2QE0wgANb7n+2YH9oDw3iMSkvWDd4A+wMqDrnQVT03QKZItxP8XtBMYz
	LTvU2C2zA863AUXY33jRAQsklGI9ZzNUdxygqTtwkwR5/SetEmyMYuw8aTGh7BFxhirzNH
	xbJ+OiIMo4IXaGc+7NxRBPIFSqG3Ph4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-HL0xeEWbM3aMD2FSLau9mQ-1; Mon,
 18 Aug 2025 15:49:27 -0400
X-MC-Unique: HL0xeEWbM3aMD2FSLau9mQ-1
X-Mimecast-MFC-AGG-ID: HL0xeEWbM3aMD2FSLau9mQ_1755546566
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AAC51956086;
	Mon, 18 Aug 2025 19:49:26 +0000 (UTC)
Received: from [10.22.80.227] (unknown [10.22.80.227])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B5E0195419F;
	Mon, 18 Aug 2025 19:49:22 +0000 (UTC)
Date: Mon, 18 Aug 2025 21:49:13 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, 
    ifranzki@linux.ibm.com, agk@redhat.com, snitzer@kernel.org, 
    gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
In-Reply-To: <7e1362bfc8180f3cef4dd9f8c0f0ff02@linux.ibm.com>
Message-ID: <320f8393-179f-aba9-de8b-d08f98c0b7c1@redhat.com>
References: <20250722133832.319226-1-freude@linux.ibm.com> <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com> <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com> <20250725173811.GA3642931@google.com> <dbe165f661d11a4bed8d7c806a9eeb5e@linux.ibm.com>
 <51dc2ccd-c06d-e719-9568-35a8d3a1010f@redhat.com> <7e1362bfc8180f3cef4dd9f8c0f0ff02@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Thu, 14 Aug 2025, Harald Freudenberger wrote:

> On 2025-07-28 23:24, Mikulas Patocka wrote:
> > On Mon, 28 Jul 2025, Harald Freudenberger wrote:
> > 
> > > > > > > Mikulas Patocka (2):
> > > > > > >   dm-integrity: use internal variable for digestsize
> > > > > > >   dm-integrity: introduce ahash support for the internal hash
> > > > > > >
> > > > > > >  drivers/md/dm-integrity.c | 370
> > > > > > > +++++++++++++++++++++++++++-----------
> > > > > > >  1 file changed, 265 insertions(+), 105 deletions(-)
> > 
> > Hi
> > 
> > I reviewed the code and unfortunatelly I found out that it is buggy (I
> > didn't notice the bugs before, when I was working on it).
> > 
> > integrity_ahash_sector_checksum uses sg_set_buf and sg_set_buf needs
> > directly mapped memory. It doesn't work with vmalloc memory and it doesn't
> > work with memory obtained from kmap.
> > 
> > The result buffer may be vmallocated memory (if we have
> > CONFIG_VMAP_STACK).
> > 
> > I'd like to ask the maintainers of crypto-api - Herbert or David - what if
> > I pass vmalloc-allocated memory (or possibly stack memory) as "result" to
> > ahash_request_set_crypt(req, sg, result, nbytes);? Is it legal or not?
> > 
> > Mikulas
> 
> Hi Mikulas, what is the state of the dm-itegrity asynch digest support?
> If you have a newer version or maybe if you need some more code coverage,
> I do offer some worktime for this and a s390 machine...
> 
> Thanks for your work
> Harald

Hi

I'm trying to find a way how to implement it without bloating the code too 
much. Maybe I'll have it this week (if it passes the tests).

Mikulas

