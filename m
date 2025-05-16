Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84F481C4
	for <dm-devel@lists.linux.dev>; Fri, 16 May 2025 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747395354; cv=none; b=d0I7cDw4m5GJJrwREQX28N8NjwEn4uy1CU6H1dFO6/BC5gLGx1SYisbUWDqZHl1ntz/6S9PNMEG9WTbzyncq4fEjGXx3G7op6Hmddbz7n6hWwocxRWjP0litnBNSloGFQELjztjTsabGZhf6+0QIC0xIdgs044pBNioLBsZ0E/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747395354; c=relaxed/simple;
	bh=KkGNtxIJLlF/QicJH4xpvHo9W2vIPVm4pezlZZv16LQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jBbnhOG+CnIU/MU1rHSBj+dOosK/AbYnjrWKWR29sHaLkd5TZ4VpGUNQh+e3qNCA0TAR1ZMhwVIarYPCV/tQCaWSMgQSsJuV5sFLtk2KPgqoKZ2aDPPs+qzlYOWJ1f1zRmaDizn59+bYEU5X97hmKa3tPBOQiY/pBfls6iCHHk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KW8FMUBl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KW8FMUBl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747395351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C5l1IYC9pd5QVCIVLSP2w/lABP27hCP+0t91dbvZ0C8=;
	b=KW8FMUBl3G/15vUWVvCC1E96fW3uRwNUmI96YPrgo4HbpTOoZahh7hEihAmD/uNk6R68vk
	W9tqZGG5fTdPak3UQFESa3jelt70hPUfvF2u6qR7hDRF/Rc5wNAQSSJXVQybJfi3dOAx1T
	2eyMNb+dIvNZbjn1+W9sBJNWtAYEq1U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-PU8jsaZVPIOdwxlPYcL0_w-1; Fri,
 16 May 2025 07:35:48 -0400
X-MC-Unique: PU8jsaZVPIOdwxlPYcL0_w-1
X-Mimecast-MFC-AGG-ID: PU8jsaZVPIOdwxlPYcL0_w_1747395347
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FDEA195609D;
	Fri, 16 May 2025 11:35:47 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D638F1956094;
	Fri, 16 May 2025 11:35:43 +0000 (UTC)
Date: Fri, 16 May 2025 13:35:39 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Kevin Wolf <kwolf@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, 
    Martin Wilck <martin.wilck@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
    Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: Don't grab work_mutex while probing paths
In-Reply-To: <20250516015530.4146175-1-bmarzins@redhat.com>
Message-ID: <a6bbd5ee-492e-7a19-d884-52485e412a63@redhat.com>
References: <20250516015530.4146175-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 04MkDdetSyZwY8uL8pv390ssGhZifZ_7HjDuOy-w4aE_1747395347
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 15 May 2025, Benjamin Marzinski wrote:

> @@ -2077,35 +2095,55 @@ static int probe_path(struct pgpath *pgpath)
>  static int probe_active_paths(struct multipath *m)
>  {
>  	struct pgpath *pgpath;
> -	struct priority_group *pg;
> +	struct priority_group *pg = NULL;
>  	unsigned long flags;
>  	int r = 0;
>  
> -	mutex_lock(&m->work_mutex);
> -
>  	spin_lock_irqsave(&m->lock, flags);

Hi

I suggest replacing spin_lock_irqsave/spin_unlock_irqrestore with 
spin_lock_irq/spin_unlock_irq here and in some other places where it is 
known that interrupts are enabled (for example __map_bio, 
process_queued_bios, multipath_ctr, flush_multipath_work, 
multipath_resume, multipath_status, multipath_prepare_ioctl, ...).

I accepted this patch, so you can send the spinlock changes in a follow-up 
patch.

Mikulas

