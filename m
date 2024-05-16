Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E4D2576F
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715851195; cv=none; b=AnkPmtApHaWV9uJbhY9cyTljTRfBBu8F3Lfhw+oENrbisiOsl4fdCp5R84/GdV8Fd0DpWb2HQ++97Vb3OQjom+cCyz9473K6wFyFRy1Giszq/OfEjUVPxrbV1poYb8HkMQU7uwWJb0uBARWovr8tV3iguf1p3LZu/C3MqQIkGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715851195; c=relaxed/simple;
	bh=MW11cO4BeB8U+sqPvY8EooHfM3HxwniD0Sw4+63mwj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=F+xes8tngjEGg9sX1ru4V5jMO/XYZ/MRO9QOU8eNWJOYmJwSRTsG3ZxzQxD+zZtrnD0NhA05QbMcrq4eEpjKm0OfqehZuvqoRgvrrSeBjvefCPvsgszcHFi4a+YK9CwbsjulHhquDIKIR4OlvkS7BVVWIg+Q3wiiP17UWZvmWSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9fynMOF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9fynMOF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715851192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ndXbuU3oiKSgMwTp2iq4pVhNfA3VGtgozTjCsxLy9BM=;
	b=J9fynMOFAaZmLETh96ofcCUrlscAyD+kxNyyhYZJXFJvbXI9YKr8XJ+vRhwNC/2AlnpBPb
	yi2Luf6hrXTIniwzXwjneus1QBtPp24fYrrbtxRHk1v0qK3x/+oP+WF30k2XZdVRsLtnDs
	sYl5J33mKGL4JEMKyjG1w3kw3Dgx1zU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-Ah9nQrhsON6PfnKkfoUlEQ-1; Thu, 16 May 2024 05:19:48 -0400
X-MC-Unique: Ah9nQrhsON6PfnKkfoUlEQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8702480066E;
	Thu, 16 May 2024 09:19:48 +0000 (UTC)
Received: from fedora (unknown [10.72.116.57])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C3240105B;
	Thu, 16 May 2024 09:19:45 +0000 (UTC)
Date: Thu, 16 May 2024 17:19:41 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	ming.lei@redhat.com
Subject: Re: Useless test in alloc_multiple_bios
Message-ID: <ZkXPrY+pWG0cHPAB@fedora>
References: <ec2ba8a0-5a8-6dd0-eb56-33c8e7a389ea@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ec2ba8a0-5a8-6dd0-eb56-33c8e7a389ea@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2024 at 08:15:20PM +0200, Mikulas Patocka wrote:
> Hi
> 
> I found this piece of code in alloc_multiple_bios:
> int try = (gfp_flag & GFP_NOWAIT) ? 0 : 1;

I guess the above check is supposed to be (gfp_flag == GFP_NOWAIT)?

> 
> The problem is that GFP_NOWAIT includes __GFP_KSWAPD_RECLAIM and GFP_IO 
> also includes __GFP_KSWAPD_RECLAIM - so the test always returns true and 
> we always start with try = 0. This code was introduced by the commit 
> 4a2fe2960891f1ccd7805d0973284fd44c2f12b4.
> 
> I am inclined to remove this logic at all and always start with try = 0; 
> - trying to allocate bios first with GFP_NOWAIT makes no harm (and it 
> improves performance because we don't need to grab the lock) and if the 
> allocation fails, it is retried with GFP_NOIO.

I think it is fine to simplify the logic in this way, and now GFP_NOWAIT is
only for sending empty flush, which could be from fast path, and abnormal IO
is supposed to be in slow path.

Thanks,
Ming

