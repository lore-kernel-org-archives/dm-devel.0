Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0341EE033
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744308658; cv=none; b=lnmrZgO20AdvDyIC8a9DO9m/LhHWBJM810qOW7brkIhAXFXci0NehcdxUFZcEHo5KMDS+ZKm5ZA8YLMqzOJeHMjj9p6TlC77bphhWJxRrSSAHgVtrNtneiSmbw2QP8pMhBT3sjpJOLfd1wuL2dYGYAaSmR8umARe+KubZKNAD5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744308658; c=relaxed/simple;
	bh=VY+kh4i0NaMJ296V4U4P9Wf5/7qGa6zJe+KKx3uXt/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HLG6PeayrUPBVjs13WqaZ14lRDxxV6uf3sy3SJR+9aQ6y2qsIq+RQd64lTZ3uGZnqDUsfVSLlV2yVuur8X4uTS7HlmfGE8b++5yRp+b/4C2hgR3WT2I3JFQrZFRgB57jGlsrtXgA0QMgkuUCgccPldZgqcMtUIX5t6JxFzMHi0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cvih5Lwn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cvih5Lwn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744308654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PsDp/SZ+2euRkn//rSSyAtaKTcyBnvRnVRXUXdrzOfg=;
	b=Cvih5LwnXmMTUdD8Kh/NRz3d2I/kS6Y2lWO6B+pvvzegBA5/gM4fPaMqKA2tDMg5VjRim2
	txqzTwq8hCR7y00VUAzZy8cJMAHaJawLf+tXMoK4gQXRM0pD0C0wwd4nWWNXPI29T94oVs
	Kr8Movhrfapz5e2RIx4lan4aOjFDOPw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-PGXZeYw3N32JWgQ7szPFug-1; Thu,
 10 Apr 2025 14:10:51 -0400
X-MC-Unique: PGXZeYw3N32JWgQ7szPFug-1
X-Mimecast-MFC-AGG-ID: PGXZeYw3N32JWgQ7szPFug_1744308650
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93690195609F;
	Thu, 10 Apr 2025 18:10:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29DDD1828A9E;
	Thu, 10 Apr 2025 18:10:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53AIAnvi005372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 14:10:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53AIAmh5005371;
	Thu, 10 Apr 2025 14:10:48 -0400
Date: Thu, 10 Apr 2025 14:10:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-delay: Prevent zoned write reordering on suspend
Message-ID: <Z_gJqBqsmg-ZB3_w@redhat.com>
References: <20250410043311.990675-1-dlemoal@kernel.org>
 <20250410075431.GA763@lst.de>
 <df1c183b-3228-4785-ab31-a21d8165abcf@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <df1c183b-3228-4785-ab31-a21d8165abcf@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jBLE-Gyfe8pikFQKED2Er_tPzbVIB_qfuMC13PecHPE_1744308650
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 10, 2025 at 05:02:00PM +0900, Damien Le Moal wrote:
> On 4/10/25 4:54 PM, Christoph Hellwig wrote:
> > On Thu, Apr 10, 2025 at 01:33:11PM +0900, Damien Le Moal wrote:
> >> When a dm-delay devie is being suspended, the .presuspend() operation is
> > 
> > s/devie/device/
> > 
> >> first executed (delay_presuspend()) to immediately issue all the BIOs
> >> present in the delayed list of the device and also sets the device
> >> may_delay boolean to false. At the same time, any new BIO is issued to
> >> the device will not be delayed and immediately issued with delay_bio()
> >> returning DM_MAPIO_REMAPPED. This creates a situation where potentially
> >> 2 different contexts may be issuing write BIOs to the same zone of a
> >> zone device without respecting the issuing order from the user, that is,
> >> a newly issued write BIO may be issued before other write BIOs for the
> >> same target zone that are in the device delayed list. If such situation
> >> occurs, write BIOs may be failed by the underlying zoned device due to
> >> an unaligned write error.
> >>
> >> Prevent this situation from happening by always handling newly issued
> >> write BIOs using the delayed list of BIOs, even when the device is being
> >> suspended. This is done by forcing the use of the worker kthread for
> >> zoned devices, and by modifying flush_worker_fn() to always flush all
> >> delayed BIOs if the device may_delay boolean is false.
> > 
> > Is that scenario specific to dm-delay?  I think the same applies to
> > any other target that supports passing on bios to zoned devices.
> 
> Don't think so. The delayed BIO list is a dm-delay thing only. dm-linear,
> dm-error or dm-crypt do not delay BIOs like dm-delay so we do not have BIOs
> being issued in the pre-suspend context.
> 
> > 
> >>  	spin_lock(&dc->delayed_bios_lock);
> >>  	if (unlikely(!dc->may_delay)) {
> >> -		spin_unlock(&dc->delayed_bios_lock);
> >> -		return DM_MAPIO_REMAPPED;
> >> +		/*
> >> +		 * Issue the BIO immediately if the device is not zoned. FOr a
> >> +		 * zoned device, preserver the ordering of write operations by
> >> +		 * using the delay list.
> >> +		 */
> >> +		if (!bdev_is_zoned(c->dev->bdev) || c != &dc->write) {
> >> +			spin_unlock(&dc->delayed_bios_lock);
> >> +			return DM_MAPIO_REMAPPED;
> > 
> > Don't we only need to do that if anything is queued up due to a
> > suspension?  Then again having a different patch might be premature
> > optimization, it's not like anyone cares about dm-delay performance
> > almost by definition :)
> 
> True. I can add a list_empty check here. Will send a v2 with that.

I may be pointing out the obvious, but we can't just check if
dc->delayed_bios is empty, since we pull the bios off the list before we
submit them. We can only skip adding the bios if the list is empty and
flush_delay_bios() isn't currently processing any bios.

-Ben

> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

