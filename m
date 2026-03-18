Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38ED3B8943
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857788; cv=none; b=Hm3U8GZha0RcOrbprtCOqzNazNU2XbzFtLC9II6BmWCowG1QwLaTSBKjFnWKTMxo/1URSV69CSW1IlDmhfAMXGW75xxtT/ubztYWhb07IgPQnEzQe5qXrEEOfK41LZXq1xdoiKFKsA7mkPdeAv55GxRuYiHwLWB4t27ZX6eOdqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857788; c=relaxed/simple;
	bh=5t690l5w4V9bUXKcSncDHYvWNb6MeODfVUnoE4SKNdE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=u/HK1/0TOQX1b11WldwCkdKqg8RGf1q6rMPYsdwfEIW770aCbvqpA4+lqrvV2a96o3revTP8PfE8nTUiFjRcINBYDIvuKp9nMKKyAIvn6uCTEgVNlYoHdmiedLvo+grsL8NhlSQFz3iAI7hCEnDqnLfxkDv7qwrqvwNsl0KBgjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ek3dKnqv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ek3dKnqv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773857785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h2lA1u0R6rz7PUxf8aqGlpy3AhbNG5laNIpf/HrXV5M=;
	b=ek3dKnqv58P7LB53l6IQqt/xAmsZeiAsu5m1v2UIwQD+SgKaY6Fu1Xgt6jvMaHzb9Tmpz3
	XF1qpcoX+H1fnLa5zEbzUMO/JyOlKsHpffgCJ4sCXaNiOtaaa2kKUilfKF9KuT9gENTquz
	e37LFxONDU5wAKFW9qXW+q5q3t3IqIw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-lcezdONzP_2wIHod0Ew7xg-1; Wed,
 18 Mar 2026 14:16:22 -0400
X-MC-Unique: lcezdONzP_2wIHod0Ew7xg-1
X-Mimecast-MFC-AGG-ID: lcezdONzP_2wIHod0Ew7xg_1773857781
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 446DF1800372;
	Wed, 18 Mar 2026 18:16:21 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACB5D19560AB;
	Wed, 18 Mar 2026 18:16:18 +0000 (UTC)
Date: Wed, 18 Mar 2026 19:16:15 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@kernel.org>
cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many
 segments
In-Reply-To: <abrmlumkhOQEBk-Z@kbusch-mbp>
Message-ID: <d8cc89c8-be4c-3d62-5855-2c6021d77b56@redhat.com>
References: <20260316150229.1771884-1-kbusch@meta.com> <20260316150941.1813568-1-kbusch@meta.com> <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com> <abraWvuLlTjHF-9q@kbusch-mbp> <7cdd50b4-afcf-aa5a-af0b-a00a35b88bdf@redhat.com>
 <abrmlumkhOQEBk-Z@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: xYq9eYnMNOYlNw8DywOnzQVvv5ynwQLdiXdqz0-wCP0_1773857781
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 18 Mar 2026, Keith Busch wrote:

> On Wed, Mar 18, 2026 at 06:40:52PM +0100, Mikulas Patocka wrote:
> > On Wed, 18 Mar 2026, Keith Busch wrote:
> > 
> > > But even then, the only thing I know of that really wants this has an
> > > offset that straddles two pages per block, so I never need more than 2
> > > segments, and the inline scatterlist has four. There's just currently no
> > > way for the block layer to report a max-segments-per-block limit, so I'm
> > > including this patch to be consistent with the reportable limits.
> > 
> > Can userspace use preadv/pwritev with many small iovecs on a file opened 
> > for direct I/O?
> 
> Yes, I have several patches that were accepted last year to block and
> iomap that align direct-io memory requirements to the backing device's
> dma constraints. You can do dword aligned and sized vectored IO to a
> block device today if the block limits say its okay.

So, we must support worst-case scenario - "cc->sector_size / 4" segments. 

sector_size can be up to 4096, so there may be up to 1024 segments. Each 
segment consumes sizeof(struct scatterlist) bytes - that's 32 bytes. So, 
we allocate up to 32768 bytes.

kmalloc with size greater than 32768 is unreliable - so we are just on 
this limit.

Mikulas

