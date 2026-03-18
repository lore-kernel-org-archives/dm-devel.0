Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44823E51CB
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773859322; cv=none; b=Mnlb+1174EhiGVceSY+4vck9xhrKIlxbHHJajABhsohSFGvqqA6q3YE6dlCb5M8p7KX9jzw6UAsq63SumaoncN3qhjpfrfGuQ0GKE25DjLUDxXlXoM/RGHsdXwHDGc1vY79Iz9rcqG2Tnp7U8CX0dnGpEeE9JuANcwJZ5Pp4u2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773859322; c=relaxed/simple;
	bh=Hdzc/GbV7QiiRW4OrIKKZjIY8f47D48VYVO20JhFYj0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=R0wLWivmkG1XtxFSSxGqc8I5vXcbMr5UJIKAkdZPILZo94L6zDb2f9xsPal5ObzMZTGWHDIkFAi4cTJUHPtX3+hymNOX1er9Vh5l4mETUILfV8aKyDjPnlJXf3ctmQ2KEjAle1KUrxy54ZHcsl8TS+OzhEjKXsp48UPQWW4ceL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jIrmmglB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jIrmmglB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773859318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w3oJ/ODW3HPPfezRd+TABCd2AvVkjFfgcN5nkWdQTS0=;
	b=jIrmmglBEe6Z4yHgWQll/GBmrnDK7v4DsNGPVR4tBPVRHqYWAQEflW80aNnpRnXn++jvZU
	yycNAFAh2dLb+9Le5Fak2YpdcLkz7qWE8naYwv2N5u8aAL4s4slWsL1rRaWf/JrcA+x7bJ
	PG20N9+ja7uYyFHl0R7Rcj2QQwTh7eM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-q9Av6peBNVydUGBUMEeBeg-1; Wed,
 18 Mar 2026 14:41:56 -0400
X-MC-Unique: q9Av6peBNVydUGBUMEeBeg-1
X-Mimecast-MFC-AGG-ID: q9Av6peBNVydUGBUMEeBeg_1773859315
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 728C018005B4;
	Wed, 18 Mar 2026 18:41:55 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0268930001A1;
	Wed, 18 Mar 2026 18:41:53 +0000 (UTC)
Date: Wed, 18 Mar 2026 19:41:49 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@kernel.org>
cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many
 segments
In-Reply-To: <abrv1Zk_L8yoovW4@kbusch-mbp>
Message-ID: <3ce11c2d-2b97-621c-3fcd-4908a8fcc9d0@redhat.com>
References: <20260316150229.1771884-1-kbusch@meta.com> <20260316150941.1813568-1-kbusch@meta.com> <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com> <abraWvuLlTjHF-9q@kbusch-mbp> <7cdd50b4-afcf-aa5a-af0b-a00a35b88bdf@redhat.com> <abrmlumkhOQEBk-Z@kbusch-mbp>
 <d8cc89c8-be4c-3d62-5855-2c6021d77b56@redhat.com> <abrv1Zk_L8yoovW4@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: _oTOZAJqjbEPFcaww1iuug1haoZ9GqMPLbI2KVQs5o0_1773859315
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 18 Mar 2026, Keith Busch wrote:

> On Wed, Mar 18, 2026 at 07:16:15PM +0100, Mikulas Patocka wrote:
> > On Wed, 18 Mar 2026, Keith Busch wrote:
> > > On Wed, Mar 18, 2026 at 06:40:52PM +0100, Mikulas Patocka wrote:
> > > > On Wed, 18 Mar 2026, Keith Busch wrote:
> > > > 
> > > > > But even then, the only thing I know of that really wants this has an
> > > > > offset that straddles two pages per block, so I never need more than 2
> > > > > segments, and the inline scatterlist has four. There's just currently no
> > > > > way for the block layer to report a max-segments-per-block limit, so I'm
> > > > > including this patch to be consistent with the reportable limits.
> > > > 
> > > > Can userspace use preadv/pwritev with many small iovecs on a file opened 
> > > > for direct I/O?
> > > 
> > > Yes, I have several patches that were accepted last year to block and
> > > iomap that align direct-io memory requirements to the backing device's
> > > dma constraints. You can do dword aligned and sized vectored IO to a
> > > block device today if the block limits say its okay.
> > 
> > So, we must support worst-case scenario - "cc->sector_size / 4" segments. 
> > 
> > sector_size can be up to 4096, so there may be up to 1024 segments. Each 
> > segment consumes sizeof(struct scatterlist) bytes - that's 32 bytes. So, 
> > we allocate up to 32768 bytes.
> > 
> > kmalloc with size greater than 32768 is unreliable - so we are just on 
> > this limit.
> 
> Direct-io hits the BIO_VEC_MAX limit (256) first, so 8k for the
> scatterlist (not great, but less terrible). You can have some 4-byte
> segments in the user request, but the average segement size would have
> to be larger. The important part is that any segment can start at any
> memory address dword alignment offset.

Yes, that makes sense. So, you can preallocate two mempools (for the two 
sglists) with 8k-sized objects each.

Mikulas

