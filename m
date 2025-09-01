Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F58D254B09
	for <dm-devel@lists.linux.dev>; Mon,  1 Sep 2025 12:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756728292; cv=none; b=S5tDYW6DiIiyqPgfYyaYnQNra55Fzt2i7Jem0VEHBpVLnLy5w4Yyb0FzVuEoCZS8d9Z/VtkItCJ+L3npnBZYAENudRirRPdMAa1xKl1u4wAan0iwEhJM/Y+NFzt7HhAlEDWpuaI7ZpzWw43CIWltH3mGTZQMVXeSrdxlOl1zgKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756728292; c=relaxed/simple;
	bh=RkdIGOasiN/G4T1FxY1sOGjNpqGU9h85OHCFSJBYtXs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UWIKbDVzuBYrvY9B6blihMluHjHNPT86pejGlsKxPkm3dmZb1v24c2W1dY3gU0P/y5ob9lK3n3jfJBzg0hM3HAGA8fQMn2fYSE5DGO5FXLIgYGP/3zGgVtgZmAQYSptwtqCOTeLQwQSqWa8caLM+b038WmcDUccV76Z7jG7GAKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fq/BqLQK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fq/BqLQK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756728289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YGw8Ab/OXgFUAJW0OAtWC6mI8zMQxjJeIWEK5dKTXMg=;
	b=Fq/BqLQKIN2IX7dKuRgTKbc+i7I9p6C6VmeO3BDTwHogJ2CK6uo4xABZhtTzdbNmAibOeh
	JsRwBcXxHJbET6JbjJjLUm2gAs5PZUDHoSNFkeoRC6hWUQkrmlEVZkJdANfCRkHI0bcYvy
	q48VE6gn46IHvmn3tPPkajWWYlQiKOo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-8L_Z16kkMPmA7xVODBVWnA-1; Mon,
 01 Sep 2025 08:04:47 -0400
X-MC-Unique: 8L_Z16kkMPmA7xVODBVWnA-1
X-Mimecast-MFC-AGG-ID: 8L_Z16kkMPmA7xVODBVWnA_1756728286
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 403D3180034D;
	Mon,  1 Sep 2025 12:04:45 +0000 (UTC)
Received: from [10.22.80.6] (unknown [10.22.80.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29E4430001B5;
	Mon,  1 Sep 2025 12:04:41 +0000 (UTC)
Date: Mon, 1 Sep 2025 14:04:38 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>, 
    Harald Freudenberger <freude@linux.ibm.com>, linux-crypto@vger.kernel.org, 
    dm-devel@lists.linux.dev, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>, 
    linux-parisc@vger.kernel.org
Subject: Re: crypto ahash requests on the stack
In-Reply-To: <aK7Rl7YC1bTlZWcL@gondor.apana.org.au>
Message-ID: <90c8cedd-cdad-c528-2771-829a66e08e33@redhat.com>
References: <94b8648b-5613-d161-3351-fee1f217c866@redhat.com> <aK7Rl7YC1bTlZWcL@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Wed, 27 Aug 2025, Herbert Xu wrote:

> On Mon, Aug 25, 2025 at 04:23:59PM +0200, Mikulas Patocka wrote:
> > 
> > I'd like to ask about this condition in crypto_ahash_digest:
> > 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> > 		return -EAGAIN;
> > 
> > Can it be removed? Or, is there some reason why you can't have 
> > asynchronous requests on the stack (such as inability of doing DMA to 
> > virtually mapped stack)?
> 
> Right, in general you can't use stack requests for async hash
> because they may DMA to the request memory.

Thanks for the confirmation.

BTW. what happens if you have an architecture that needs cacheline-aligned 
DMA accesses? For example, on parisc, some microarchitectures have 
128-byte cache line. As caches on parisc are not DMA-coherent, you must 
not touch the 128-byte region around the area where you are doing DMA.

Normally, this problem is solved by tweaking kmalloc, so that the minimum 
allocation size and alignment is 128 bytes. But if you do DMA into struct 
ahash_request, and struct ahash_request may be embedded in other 
structures, and doesn't have 128-byte alignment, it could break.

> So what I can do is bypass the ahash_req_on_stack for Harald's
> driver by changing the ahash_is_async test to something more
> specific about DMA.  Let me write that up and I'll have something
> for you to test in a couple of days.
> 
> Cheers,

I reworked my patchset so that it places asynchronous requests after the 
dm_integrity_io structure (that is allocated in directly mapped memory), 
so there are no longer any needs to change the crypto code.

Maybe I should allocate the ahash requests with kmalloc, to solve the 
DMA-into-request problem.

Mikulas

