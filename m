Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20C8346766
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 19:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774900494; cv=none; b=VbtSt/KKuOJNsVgHXLR/AFhEyodCzxTCHRLjE+q9Hu2PsRW5KmWiPbmy18fVz9/umf8h1XIKHg6ylQv3kjnqYRwT/m6o5ZHz3W3QKasjgi0D4KzaBuQC+nJp2J96K3qANtvV131yUxJ3Hww2E0TGCrIOlHQzJW7SxAGd5mbe7BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774900494; c=relaxed/simple;
	bh=NTeyu2/2ovt5OkhXlgOc7EWHAxms6bLIouJ/Qf+e1Pg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qYVBfDsycKV3hFgeYKaxnJUIgd7aG8SWtyOP+KJaJr6ePrUFiZXP5F6DeE2foQMnXkdEp4dTGLRiVxLN14OcutM+cVWXSVi51xSjdCcWwYjfYki+eZNQFuSmNuYPJRkqfPdEU+1Nv0k8/NdWJsvA7AxYzazvtOtqtyuqOjR0I8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SO3szgVA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SO3szgVA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774900491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Cb6GB3usENC+e12lBc6u6jAAteqxjt6kqxe/KsLX1Q=;
	b=SO3szgVAz2zHysnlU2Y2mK8pyZ8P+31RSZ71gOpfRSP+yUXaNKc9fdNJAT6dj3wjUKTODI
	suYqrcN0pQ36uAPNcxLI3FZZdDerpU8tnXzB2UnG6s/WDU+zR4/d/T83oJkG2OUwnmJ+1e
	qNjZpvIJpJfkqrmsse/BGc3YF/5YHck=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-63LonLTbMiG184Y-66YG3A-1; Mon,
 30 Mar 2026 15:54:49 -0400
X-MC-Unique: 63LonLTbMiG184Y-66YG3A-1
X-Mimecast-MFC-AGG-ID: 63LonLTbMiG184Y-66YG3A_1774900488
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81F64180044D;
	Mon, 30 Mar 2026 19:54:48 +0000 (UTC)
Received: from [10.44.35.168] (unknown [10.44.35.168])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E8A8300019F;
	Mon, 30 Mar 2026 19:54:46 +0000 (UTC)
Date: Mon, 30 Mar 2026 21:54:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@meta.com>
cc: dm-devel@lists.linux.dev, snitzer@kernel.org, 
    Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 0/2] dm: finer grained memory alignment
In-Reply-To: <20260330170114.764606-1-kbusch@meta.com>
Message-ID: <96d098d4-b162-89e7-67b3-f194528bd122@redhat.com>
References: <20260330170114.764606-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9GkSBMCF42YbxxIr0duFLaAL9HwLIMKpfZaAApwl9Is_1774900488
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I accepted the patches. I just changed the mempool sizes from 1 to 
MIN_IOS, so that the requests are not serialized when the system is out of 
memory.

Mikulas


On Mon, 30 Mar 2026, Keith Busch wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> This is the updated series for allowing arbitrary memory alignment,
> enabling direct-io without bounce buffers for dm-crypt.
> 
> The previous version was posted here:
> 
>   https://lore.kernel.org/dm-devel/20260114154954.3282207-2-kbusch@meta.com/
> 
> And is based on the current dm-7.1 branch, which has the necessary
> dm-integrity updates that make patch 1 a no-op.
> 
> Changes from v3:
> 
>  * Split off the generic dm-table queue limits update into its own prep
>    patch.
> 
>  * Squashed the rest into a single patch just so it doesn't introduce a
>    temporary commit point where the reported limits can't always be
>    executed.
> 
>  * Do not report a dma_alignment lower than the backing device's; this
>    is necessary as the incoming buffers are used directly for READ
>    rather than bounced like WRITE. 
> 
>  * Fallback to a mempool if we can't allocate the scatterlist with
>    kmalloc and updated gfp_t flags accordingly.
> 
>  * Various cleanups.
> 
> Keith Busch (2):
>   dm: initialize dma_alignment to 0
>   dm-crypt: allow unaligned bio_vecs for direct io
> 
>  drivers/md/dm-crypt.c | 147 ++++++++++++++++++++++++++++++++++++------
>  drivers/md/dm-table.c |   1 +
>  2 files changed, 128 insertions(+), 20 deletions(-)
> 
> -- 
> 2.52.0
> 

