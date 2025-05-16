Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBC62AEFE
	for <dm-devel@lists.linux.dev>; Fri, 16 May 2025 19:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747422989; cv=none; b=s8uZlTMduMArjEHNuqGVH6gepyhOQVcQqDW3bPGJlk28R4vimpckilTtXP4ByhYI44NRy4xXgDFitl6YyGdyWgS7+z0xK1QbMtpPLNQrcoXL8IVatE1p+q8OSdFIKINKDWO9bJ3GVA0U7nKrUFHI95sy51N46PYneDUPCW1qsrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747422989; c=relaxed/simple;
	bh=M7GlP23Hpnuk7eM/Y7/XncFMBrq3C4TfZSimGAP9qZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=CtEcQXmtUDKPBNUNk35H8PT4ctmseqR6Jg8k2Nc3mi6855xEi0zdFat+qRB0WiCxZAkmkMQKovxCxfvaamf/kiGATe3C8GGVAe5z7/bQDlxVIK2dyIt1Kcs/1W7brpXXCHvs/t1asdEEbnQ9e4GlbqxnNU+Du20FtPfN12PWkHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDLR+hcc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDLR+hcc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747422986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4k5g9AINviUwNi7YVgHr9iuLK01oECDz59wc70kVlf0=;
	b=cDLR+hccdgPKvfXAVoR272AsCEFQv4uK6S3e2m2CtRqv21XS5SpCR3IoqKILYYHIXDNvlG
	hljguFSjiD6UIc/WX+iF9zsKlDGXGdYr1TzXQ+rva/5FzCLIlD6EgM3WSLhqzzBKtV5m64
	eTp2anMZGOsZF3xXO28EVUHXZ8caqiU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-26Yx89PWNDyqwGrg0mw4GA-1; Fri,
 16 May 2025 15:16:19 -0400
X-MC-Unique: 26Yx89PWNDyqwGrg0mw4GA-1
X-Mimecast-MFC-AGG-ID: 26Yx89PWNDyqwGrg0mw4GA_1747422978
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EC4719560AE;
	Fri, 16 May 2025 19:16:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E68F230075D5;
	Fri, 16 May 2025 19:16:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54GJGGJu003859
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 15:16:16 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54GJGCsE003858;
	Fri, 16 May 2025 15:16:12 -0400
Date: Fri, 16 May 2025 15:16:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev,
        Kevin Wolf <kwolf@redhat.com>, Hanna Czenczek <hreitz@redhat.com>,
        Martin Wilck <martin.wilck@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: Don't grab work_mutex while probing paths
Message-ID: <aCeO_NeVLIrM0R-4@redhat.com>
References: <20250516015530.4146175-1-bmarzins@redhat.com>
 <a6bbd5ee-492e-7a19-d884-52485e412a63@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a6bbd5ee-492e-7a19-d884-52485e412a63@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BBZNAu9XYcxLKsbSbjIy2y0wo9H9DY44aQmn1OoFWjU_1747422978
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 16, 2025 at 01:35:39PM +0200, Mikulas Patocka wrote:
> 
> 
> On Thu, 15 May 2025, Benjamin Marzinski wrote:
> 
> > @@ -2077,35 +2095,55 @@ static int probe_path(struct pgpath *pgpath)
> >  static int probe_active_paths(struct multipath *m)
> >  {
> >  	struct pgpath *pgpath;
> > -	struct priority_group *pg;
> > +	struct priority_group *pg = NULL;
> >  	unsigned long flags;
> >  	int r = 0;
> >  
> > -	mutex_lock(&m->work_mutex);
> > -
> >  	spin_lock_irqsave(&m->lock, flags);
> 
> Hi
> 
> I suggest replacing spin_lock_irqsave/spin_unlock_irqrestore with 
> spin_lock_irq/spin_unlock_irq here and in some other places where it is 
> known that interrupts are enabled (for example __map_bio, 
> process_queued_bios, multipath_ctr, flush_multipath_work, 
> multipath_resume, multipath_status, multipath_prepare_ioctl, ...).
> 
> I accepted this patch, so you can send the spinlock changes in a follow-up 
> patch.

Sure. I can do that.

-Ben

> 
> Mikulas

