Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB6125BF00
	for <dm-devel@lists.linux.dev>; Mon, 28 Jul 2025 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753737880; cv=none; b=cMykOT9WN8MYawDwCFczMokJGpq2KYrSzsFlPkRYlwL1GUmJtkSFsBb73RS9lpKGmPOhThMppiMOtkguyXfvB9ZELDmlxEwYa8KXbF45XQuRPnsQYWnYzRTwl8hIMiighsThb72dK1jM2UEuvr4b7jQiGP6xUzwfG8rXE2eH/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753737880; c=relaxed/simple;
	bh=8XiYl/24Fz8YluCXVGw1UZjSQjjU5nrgDvqyZkSFeMM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hEp7DOE8slsoZBtUFEI+sexLHhnFSlt6tcpWMpb+FvLeTOlpesL46BcBO+eq34RyGeQjOoXQOA82/6S7vTm5PKRQgx26dZQPBA8i1i6C65vS1kZoeKikSyYUsTu4Y1b64afPzJbyswnmumbsi28EAY8YV7SSU/Eo1ejKaLbbidk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dlyDoxsF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dlyDoxsF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753737878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yuIREg0vHg/P9bdPomjeuKcV8q9uTeEu4xskF9nTU4I=;
	b=dlyDoxsFrSpBIO3yf+wYfau2ng4/HQSWl5mo1EIHy1wX3lufYT0hawc5JctjInJ5eVspwj
	lO8A1UQ1OS4VwoawgSl9JuvkRMfhXl8SREMpMb+RqNT9kxvL9IU3YMaI5hpBJ41gpo36jb
	OTpFe2T67InJ6QE1DfKYgqwKooQxKr8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-N_iO1YcpMh-hne13Bdp-iw-1; Mon,
 28 Jul 2025 17:24:34 -0400
X-MC-Unique: N_iO1YcpMh-hne13Bdp-iw-1
X-Mimecast-MFC-AGG-ID: N_iO1YcpMh-hne13Bdp-iw_1753737872
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 403DE180034C;
	Mon, 28 Jul 2025 21:24:32 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E27B6180035E;
	Mon, 28 Jul 2025 21:24:28 +0000 (UTC)
Date: Mon, 28 Jul 2025 23:24:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>
cc: Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, 
    ifranzki@linux.ibm.com, agk@redhat.com, snitzer@kernel.org, 
    gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
In-Reply-To: <dbe165f661d11a4bed8d7c806a9eeb5e@linux.ibm.com>
Message-ID: <51dc2ccd-c06d-e719-9568-35a8d3a1010f@redhat.com>
References: <20250722133832.319226-1-freude@linux.ibm.com> <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com> <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com> <20250725173811.GA3642931@google.com> <dbe165f661d11a4bed8d7c806a9eeb5e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Mon, 28 Jul 2025, Harald Freudenberger wrote:

> > > > > Mikulas Patocka (2):
> > > > >   dm-integrity: use internal variable for digestsize
> > > > >   dm-integrity: introduce ahash support for the internal hash
> > > > >
> > > > >  drivers/md/dm-integrity.c | 370
> > > > > +++++++++++++++++++++++++++-----------
> > > > >  1 file changed, 265 insertions(+), 105 deletions(-)

Hi

I reviewed the code and unfortunatelly I found out that it is buggy (I 
didn't notice the bugs before, when I was working on it).

integrity_ahash_sector_checksum uses sg_set_buf and sg_set_buf needs 
directly mapped memory. It doesn't work with vmalloc memory and it doesn't 
work with memory obtained from kmap.

The result buffer may be vmallocated memory (if we have 
CONFIG_VMAP_STACK).

I'd like to ask the maintainers of crypto-api - Herbert or David - what if 
I pass vmalloc-allocated memory (or possibly stack memory) as "result" to 
ahash_request_set_crypt(req, sg, result, nbytes);? Is it legal or not?

Mikulas

