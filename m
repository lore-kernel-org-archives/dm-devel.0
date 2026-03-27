Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F62372B27
	for <dm-devel@lists.linux.dev>; Fri, 27 Mar 2026 21:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774646726; cv=none; b=X+U7OmcY2CacfeJRMA/y8A61gDlZEwRT1nCknP0X9Wfx6hx9yOugyi1U6htk7jlIC1cl26kROuJ+E3uy5U8msKV4jRHcvxGUvrJKGZJWJLVwOGug6pcNpBvcR8dyYqKrBiy+CGw4uBUF6cYDRfVBAnGfTmF+DLXWan1/Of/gWEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774646726; c=relaxed/simple;
	bh=l3fzqsH4aifEmSyDkfAAYp8D/jPSaBMZpZEFPsRJ708=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tWxTC8gezpvcTm+oMPbfd9KNtyHXDIGSCTESDxTJ2grqxAlpwnZssfKxS4z3lqPxzXCmcrXkKG+gD0DMB4bHcwVEa9L0aPiv7XA29YdZD7gMRFXXADwLympDYQDrCCIgru7lgP/eTsvChY87lpvyMEefnWCXorufS/DJMBEJPBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GUgyvTGV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUgyvTGV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774646723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgi8FFnPmkcDsXlSAGqSodANmiFT4ICLHURD88NSqyU=;
	b=GUgyvTGVUfntglHonvrEcqIObW3Io8M/g2cDwWuronhn+6cj1a8CT+dcTk+Jww7EvijbRl
	2Er8NPGHkbv7sgX4RUeBYbBxfYX+385YbevZ7rygyn0s+D03iWxIxtqZAdzPFS93xD+YBS
	AcXFbqE573ZaBOeFp6bH7BguhodBhFk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-5i7yA0ajMce5QkxN1PjT3w-1; Fri,
 27 Mar 2026 17:25:20 -0400
X-MC-Unique: 5i7yA0ajMce5QkxN1PjT3w-1
X-Mimecast-MFC-AGG-ID: 5i7yA0ajMce5QkxN1PjT3w_1774646720
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5D39195609E;
	Fri, 27 Mar 2026 21:25:19 +0000 (UTC)
Received: from [10.44.32.26] (unknown [10.44.32.26])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 682EB1800361;
	Fri, 27 Mar 2026 21:25:18 +0000 (UTC)
Date: Fri, 27 Mar 2026 22:25:15 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@meta.com>
cc: dm-devel@lists.linux.dev, snitzer@kernel.org, 
    Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/3] dm-integrity: fix mismatched queue limits
In-Reply-To: <20260325193608.2827042-1-kbusch@meta.com>
Message-ID: <15431321-ad02-2f11-9538-222a922081c0@redhat.com>
References: <20260325193608.2827042-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vbHXi5tkNkMs7DhdRR8luw2-tyylZKFxsh-TWcxbjXA_1774646720
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I accepted all three patches.

Mikulas



On Wed, 25 Mar 2026, Keith Busch wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> A user can integritysetup a device with a backing device using a 4k
> logical block size, but request the dm device use 1k or 2k. This
> mismatch creates an inconsistency such that the dm device would report
> limits for IO that it can't actually execute. Fix this by using the
> backing device's limits if they are larger.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/md/dm-integrity.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 06e805902151c..8dfd498ed1ffd 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -4047,9 +4047,15 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
>  	struct dm_integrity_c *ic = ti->private;
>  
>  	if (ic->sectors_per_block > 1) {
> -		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> -		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> -		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
> +		limits->logical_block_size =
> +				max(limits->logical_block_size,
> +				    ic->sectors_per_block << SECTOR_SHIFT);
> +		limits->physical_block_size =
> +				max(limits->physical_block_size,
> +				    ic->sectors_per_block << SECTOR_SHIFT);
> +		limits->io_min =
> +				max(limits->io_min,
> +				    ic->sectors_per_block << SECTOR_SHIFT);
>  		limits->dma_alignment = limits->logical_block_size - 1;
>  		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
>  	}
> -- 
> 2.52.0
> 

