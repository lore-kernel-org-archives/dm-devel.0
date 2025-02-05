Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238E420CCDD
	for <dm-devel@lists.linux.dev>; Wed,  5 Feb 2025 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738786828; cv=none; b=g04FZoQyrACZ4QmzuItk5okO03Zh2myLuMYO9LF6IsrUEweL4LGCdun/pEVnqJlBOkNWy1+eXfhu1mFOBEHKlexYiEiyJ7JpgUHOAMkcTuHlxvzQrKlBcuAV2wwTzXfvpfTXAs0bgnbZZtlemZz0pSVqCdH+3CCxmiNNO3JWKwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738786828; c=relaxed/simple;
	bh=fnTAqM3D/83qeGP69un7O8D6chMjRT+BZtI6vSyZYjM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oeaiqn78elINR7lJKbBaMsKVGnxNvo6U9IG7LE4+a0nzjNjuLHSKzg8Bhfs61sMVWjCBzw4ND3qEdcQl+og4iFbAte53WzX1gMcKkrw9WK6Cfx+SwrP4EnLVTvzFY4OvkgX2jiUVwPAp7js0WmHfllsNq9wBtCVIyc7QXklh6YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YdlIUmjo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdlIUmjo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738786825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i6tgDU57Mg8+mA/Pkg4w2tDko2vpEndFX/IjtOXl5rI=;
	b=YdlIUmjoLy9/AdL/lOw8ayoio7y7uVvr+mIrYT1E+v/KFQCSxTeNoeLbu3EoBXus6HrKP6
	EUB3U5tsRXEVoh0vp4Rvqv1rS/0W5oun04Bl5WNvFj6yiLd31WBWH0jnhLuSczwnuETI2D
	U8hzxoBhppukUmVPSqz1MhxqDM1FP20=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-6gAnFY5BOh2AhJHb60SCGw-1; Wed,
 05 Feb 2025 15:20:21 -0500
X-MC-Unique: 6gAnFY5BOh2AhJHb60SCGw-1
X-Mimecast-MFC-AGG-ID: 6gAnFY5BOh2AhJHb60SCGw
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B22021956095;
	Wed,  5 Feb 2025 20:20:19 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B04FE1800267;
	Wed,  5 Feb 2025 20:20:16 +0000 (UTC)
Date: Wed, 5 Feb 2025 21:20:12 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, agk@redhat.com, 
    snitzer@kernel.org, linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, 
    herbert@gondor.apana.org.au, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 2/2] dm-integrity: introduce ahash support for the
 internal hash
In-Reply-To: <50719156cbdb7621cfc141a3c64b56a7@linux.ibm.com>
Message-ID: <dea23d80-31be-605a-0c37-6ae185fd4fa5@redhat.com>
References: <20250131100304.932064-1-freude@linux.ibm.com> <20250131100304.932064-3-freude@linux.ibm.com> <1743b5fc-f401-c416-5733-6757bda963ca@redhat.com> <50719156cbdb7621cfc141a3c64b56a7@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Tue, 4 Feb 2025, Harald Freudenberger wrote:

> Thanks Mikulas for your feedback.
> As of now all this looks like a dead end to our attempt on trying to
> provide a phmac-shaxxx digest for use with dm-integrity. Thanks for
> your effort. Don't expect another version of this patch as I can't
> fullfill the requirements.

Hi

I think that it is possible to make it work for you with async-only 
hashes.

As for calling integrity_sector_checksum from dm_integrity_end_io - we can 
offload this operation to a workqueue when using an async hash.

As for memory allocation in the I/O path - we can move the sector_le and 
ahash_request fields to the structure dm_integrity_io. So, that there is 
no allocation in the I/O path.

I fixed your patches and I'll send them in the next email - please test 
them.

I tested them with the cryptsetup testsuite (and I hacked the code so that 
it prefers ahash over shash) and it passed.

Mikulas

