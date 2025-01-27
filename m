Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF98B18C337
	for <dm-devel@lists.linux.dev>; Mon, 27 Jan 2025 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738000657; cv=none; b=Xor/q7So3SX309kHOaQ2f88wZVp6f/Gnh4iOK4IyYxolCA8uQmWCkfezw0hUOP0LVEFV2ghecvQ7VtZ5uaTE64iWNNe+rZ0rjG4LFEbNm1PnLt7fcRPLamhvhgEsNIcqKbE5SAa3PyILMboR6IYLlRGz/H110lW01evtUBU5feA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738000657; c=relaxed/simple;
	bh=Da/Mo6lc9KrmvCQJHGNrMkn9XdDwOdxWpBKxPrOgGA0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ovnhfzJuYHAOqR6j+mxJdnYy4u3pHh//8cd2oWUU7shnVHQL4wSF53dQN8rlFvckJlhgqqQXhtLZkD1ulbGrCmcoyJoOWpI4bSUprQF+ybGiTYowrb3bQYladz/7pUhnwnqKO44w07W5+sWxMrP6J0zwTkgiZ7XH8DzgxThqgBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rke8+kCu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rke8+kCu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738000655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6FkhrzKrV06UD8gv8drmi1i5znhVKcH4EdaDtq7gHPQ=;
	b=Rke8+kCuBoOi7O0bMPhg2bFff8SfeRTuGfszLr84PUoR82kHldSeB5EOnHyFIHjyAYVEJw
	RpXTYuZR2cDv0qbfOpWX/IFowI3jFf57E9CEOW4UN6vrBpZNPuz8mjvsbAP6D6d+2HsiOI
	yx1SsmqeWYQmWTBu9MP9/QnuFICdpp4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-rBQa59sANb6K_EgZ4fXOUg-1; Mon,
 27 Jan 2025 12:57:32 -0500
X-MC-Unique: rBQa59sANb6K_EgZ4fXOUg-1
X-Mimecast-MFC-AGG-ID: rBQa59sANb6K_EgZ4fXOUg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2ABC41801F16;
	Mon, 27 Jan 2025 17:57:31 +0000 (UTC)
Received: from [10.45.224.57] (unknown [10.45.224.57])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EC7E195608A;
	Mon, 27 Jan 2025 17:57:28 +0000 (UTC)
Date: Mon, 27 Jan 2025 18:57:24 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
cc: agk@redhat.com, snitzer@kernel.org, ifranzki@linux.ibm.com, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, 
    herbert@gondor.apana.org.au, dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
In-Reply-To: <5a8a09387c0fef59629707937297a0a4@linux.ibm.com>
Message-ID: <1f3c94f0-1149-70cf-8bb8-756a5c3e8a2d@redhat.com>
References: <20250115164657.84650-1-freude@linux.ibm.com> <20250115164657.84650-2-freude@linux.ibm.com> <b541f1bb-5287-7600-77ce-ceed5903e554@redhat.com> <5a8a09387c0fef59629707937297a0a4@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi


On Wed, 22 Jan 2025, Harald Freudenberger wrote:

> 
> 6.13.0-rc7 with dm-integrity using shash:
> 
> sha256
>   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 45.5 s, 94.4 MB/s
>   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 19.2137 s, 224 MB/s
> hmac-sha256
>   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 45.2026 s, 95.0 MB/s
>   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 19.2082 s, 224 MB/s
> 
> 6.13.0-rc7 with dm-integrity with my ahash patch:
> 
> sha256
>   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 41.5273 s, 103 MB/s
>   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 16.2558 s, 264 MB/s
> hmac-sha256
>   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 44.063 s, 97.5 MB/s
>   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 16.5381 s, 260 MB/s
> 
> I checked these results several times. They vary but always the dm-integrity
> with the ahash patch gives the better figures. I ran some measurements with
> an isolated cpu and used this cpu to pin the format or the dd task to this
> cpu. Pinning is not a good idea as very much of the work is done via
> workqueues
> in dm-integrity and so the communication overhead between the cpus increases.
> However, I would have expected a slight penalty with the ahash patch like
> it is to see with the dm-integrity format but read and write seem to benefit
> from this simple ahash patch. It would be very interesting how a real asynch
> implementation of dm-integrity really performs.
> 
> If someone is interested, I can share my scripts for these measurements.
> 
> Harald Freudenberger

If ahash helps for you, you can add it in a similar way to the dm-verity 
target - so that it is only used when it makes sense - see the function 
verity_setup_hash_alg.

Mikulas

