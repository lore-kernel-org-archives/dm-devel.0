Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF0F28688F
	for <dm-devel@lists.linux.dev>; Thu, 24 Jul 2025 14:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753368042; cv=none; b=JPXz3gjUbhn/krTaVI9IdNna+G0PBEQtfHsg1fNHl2Le8iQAZKUoEhvdIdhC4qUgOpEX8ByfgmCNlNwN5EjKLK+yIq0FRSjkKN67ItRz9aZf+KM+YD8vZy28NB/FI3PlxIOfyER455T7LfdaYpbNtgHrUYtiVEeT5WfOLTSooaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753368042; c=relaxed/simple;
	bh=57lOd1JZ7a4Rq2tPeSY7qHYO52MW0nszJeiflVv1lOc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EHBQExnywthgcPoqLr99ZETRLEH0gXgf3Ne0UoLscWRm0Ypj51qWixpm+4M1StUY3cN7nbB7VU7ZC7jpd3dVZRAC25wCC+Amy0Bxai0KN0YNXgu33mJ1GQPTY87DmSIOeD3u2yAV2nMffVlzJtel2v91Vu4s7M29hTKKJucsuLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PkUQRe/F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkUQRe/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753368039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HhM/GT6t5SOa29Ew2UrFOO/jGtEVRMmkxpx+0rBbbvk=;
	b=PkUQRe/FUC1qvJ+l3Ac+1dlBVSbsI/e4IHkMP2Xqcx8fY+qx0Lik3oZE7OJ/uVqCqDmhiM
	7KUzFgDNjrntDavNjSWxGO93xkrRF98Pny1Fnrmp+Nv1AW4nyTfOr2V+Nlk15Xh21vvz/F
	7hBCM0X2mM2F2s1HYp9d9eIp9nrmdW0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-vkwsahbsPJSV2t6uAng1bA-1; Thu,
 24 Jul 2025 10:40:34 -0400
X-MC-Unique: vkwsahbsPJSV2t6uAng1bA-1
X-Mimecast-MFC-AGG-ID: vkwsahbsPJSV2t6uAng1bA_1753368032
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52741180044F;
	Thu, 24 Jul 2025 14:40:32 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 430DB1800298;
	Thu, 24 Jul 2025 14:40:29 +0000 (UTC)
Date: Thu, 24 Jul 2025 16:40:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
cc: dengler@linux.ibm.com, Eric Biggers <ebiggers@kernel.org>, 
    linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, 
    herbert@gondor.apana.org.au, ifranzki@linux.ibm.com, agk@redhat.com, 
    snitzer@kernel.org, gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
In-Reply-To: <20250722133832.319226-1-freude@linux.ibm.com>
Message-ID: <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com>
References: <20250722133832.319226-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Tue, 22 Jul 2025, Harald Freudenberger wrote:

> Support for ahashes in dm-integrity.
> 
> Changelog:
> 
> v1: First implementation. Tested with crc32, sha256, hmac-sha256 and
>     the s390 specific implementations for hmac-sha256 and protected
>     key phmac-sha256. Also ran with some instrumented code (in the digest
>     implementation) to verify that in fact now the code runs asynchronous.
> v2: Support shash and ahash. Based on Mikulas' idea about implementing
>     ahash support similar to dm-verity this version now adds support
>     for ahash but does not replace the shash support. For more details
>     see the text of the patch header.
> v3: The line to store the digestsize into the new internal variable
>     did not make it into the patch set which was sent out. So now
>     this important code piece is also there. Also rebuilded, sparse
>     checked and tested to make sure the patches are ok.
> v4: Thanks to Mikulas a total new implementation of the ahash support
>     for the dm-integrity layer :-)
> v5: Slight rework around the allocation and comparing of ahash and
>     shash algorithm.
>     V5 has been tested with the new introduced ahash phmac which is a
>     protected key ("hardware key") version of a hmac for s390. As of now
>     phmac is only available in Herbert Xu's cryptodev-2.6 kernel tree
>     but will be merged into mainline with the next merge window for
>     the 6.17 development kernel.
> 
> Mikulas Patocka (2):
>   dm-integrity: use internal variable for digestsize
>   dm-integrity: introduce ahash support for the internal hash
> 
>  drivers/md/dm-integrity.c | 370 +++++++++++++++++++++++++++-----------
>  1 file changed, 265 insertions(+), 105 deletions(-)
> 
> 
> base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> --
> 2.43.0
> 

Hi

Eric Biggers recently removed ahash support from dm-verity - see this 
commit:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/device-mapper/linux-dm/+/f43309c6743257244f11f14d31c297ee6a410ded

Should I revert Eric's patch? - would you need dm-verity with asynchronous 
hashes on zseries too?

Is this patch series needed for performance (does it perform better than 
the in-cpu instructions)? Or is it need because of better security (the 
keys are hidden in the hardware)?

Mikulas

