Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862E3FEB28
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 16:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773850795; cv=none; b=Poxt0BacaHTj8pCqvlobN/QISCJSCMk5XHzK6XC+0MLFDXBCLX+PNEEcmeH2flJARSLMKETxp30z1Uz15SQHi8PkeEDxpSV83nX1De7LYXrE9FttlApBtrbiVUFmWmwzbiDw95bRbM8ZoJ69FGWD7deu3EtUOAH5sovIfj682Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773850795; c=relaxed/simple;
	bh=kzRONgv2jUIvFEv5Wuazr/ErBR6PBl89Ps0oxtmZR+o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MUCxu/Wuz3kJ6OjfdzqVTDMZhkAgyWSnPXe+pcnyH2dw3MGKMf85kFmX7jWwSGwIkaA2THtsUp7uR0pjck54lwRPD+bnXgepWBEuDx2L5yacqeYzSEtbqRGvSs8g4GtAIylsnnixBxO58ln6vWqEJDcZRnX659j9rtfRxJ+T4hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y0K+4KWd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0K+4KWd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773850788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C6R/1YLyLICQ4z9VxUYSZ+F3e/Wff1qaA0xIe7nH7oc=;
	b=Y0K+4KWdn3MMBr1Vjy9ar2m4OCND5BtZxDwmzBur4VkhQcvmurTnHAWAMjkvUlQ0kIbadV
	z3L2wtbd/oc+yJm5Mg/k17c/O1uLQ8tvt25cK11zTPCjl9PjIgwiDPvCYDXu2+0xFxPpH5
	vVX8vcxzFGz2UIh7oDeJ9Ih9IQ3jE0Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-fpSoWRztMr2aBEgMv_Sraw-1; Wed,
 18 Mar 2026 12:19:45 -0400
X-MC-Unique: fpSoWRztMr2aBEgMv_Sraw-1
X-Mimecast-MFC-AGG-ID: fpSoWRztMr2aBEgMv_Sraw_1773850784
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65FD41955D61;
	Wed, 18 Mar 2026 16:19:44 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4671F1800761;
	Wed, 18 Mar 2026 16:19:42 +0000 (UTC)
Date: Wed, 18 Mar 2026 17:19:39 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@meta.com>
cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, snitzer@kernel.org, 
    Keith Busch <kbusch@kernel.org>
Subject: Re: [RESEND PATCHv3 1/2] dm-crypt: allow unaligned bio_vecs for
 direct io
In-Reply-To: <20260316150229.1771884-1-kbusch@meta.com>
Message-ID: <7cc4892a-5a2f-09b7-1f32-320acac4c797@redhat.com>
References: <20260316150229.1771884-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: R6PqJ-LRWM540nvGbC5p1_cIIG2URUPJcnI-HQL2MDw_1773850784
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi


On Mon, 16 Mar 2026, Keith Busch wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> Many storage devices can handle DMA for data that is not aligned to the
> sector block size. The block and filesystem layers have introduced
> updates to allow that kind of memory alignment flexibility when
> possible.
> 
> dm-crypt, however, currently constrains itself to aligned memory because
> it sends a single scatterlist element for the in/out list to the encrypt
> and decrypt algorithms. This forces applications that have unaligned
> data to copy through a bounce buffer, increasing CPU and memory
> utilization.
> 
> Use multiple scatterlist elements to relax the memory alignment
> requirement. To keep this simple, this more flexible constraint is
> enabled only for certain encryption and initialization vector types,
> specifically the ones that don't have additional use for the request
> base scatterlist elements beyond holding decrypted data.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
>  
> +	if (!unaligned_allowed) {
> +		cc->io_alignment = cc->sector_size - 1;
> +	} else {
> +		set_bit(CRYPT_DISCONTIGUOUS_SEGS, &cc->cipher_flags);
> +		cc->io_alignment = 3;
> +	}
>  	return 0;
>  }

Why is "3" there? Should there be the dma_alignment of the underlying 
block device instead?

> @@ -3722,7 +3761,11 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	limits->physical_block_size =
>  		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
>  	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
> -	limits->dma_alignment = limits->logical_block_size - 1;
> +
> +	if (test_bit(CRYPT_DISCONTIGUOUS_SEGS, &cc->cipher_flags))
> +		limits->dma_alignment = cc->io_alignment;
> +	else
> +		limits->dma_alignment = limits->logical_block_size - 1;
>  
>  	/*
>  	 * For zoned dm-crypt targets, there will be no internal splitting of
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index dc2eff6b739df..aecb19a6913db 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1767,6 +1767,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
>  	bool zoned = false;
>  
>  	dm_set_stacking_limits(limits);
> +	limits->dma_alignment = 0;
>  
>  	t->integrity_supported = true;
>  	for (unsigned int i = 0; i < t->num_targets; i++) {

dm-integrity doesn't set dma_alignment if it is using 512-byte sector size 
(assuming that there is default 511). This should be fixed in dm-integrity 
before making this change.

Other device mapper targets should also be reviewed to make sure that this 
change doens't break them.

Mikulas

