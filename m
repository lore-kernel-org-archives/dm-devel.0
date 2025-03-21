Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558BA1D5AC0
	for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742579571; cv=none; b=i8PvDoSi3sqDuT8eiWHtWWf7fpN6OqLtMrSCwgYc3XX+w1e0faGkxbmXACMe/Xp5etCGc/aH2wReg35C9WW+GGnkQ4WBDsgbkQ3NHribCbhUPDMM+R6sQP4WZ3jTKGCCcTNs9TiPi9gT4Ygq+k0swhjOjdQEcvCUrh5o21mSGwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742579571; c=relaxed/simple;
	bh=1HdSIUxaImN2PYK57cFpSj9OOlDA1flV2+2uojAU2mM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=FyTVAI5YHH6pWnd+mkWCbRT+ALbWG8Raj1jry/CYwz2vxjTRzQpjHoGZMPoPJZoztFcJjrYbJm7f+CznzTwGeM1vhsLC/CbOEgriwUtffxr9D4wepz36P997ZRsIXWn8B0+v4ZP0nIl7CK0b67qdsccyEgJ0CJWHyNJhOvHmccw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8MmCm0m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8MmCm0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742579568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CV9ZSdUaDo/xoqLVPnWPg8T46jqpMqD2t6AqtDicwG4=;
	b=C8MmCm0mMUbjYG4+R3CVV1AxYBfymvmMoSz8Q7LfUBFMha6/0zAOKwjP/m4myN2zWqLGoS
	1kx5h/+agVQCm9CPMqAq0psWIyBh4kVWvQ5yF9TSVnnzPW2FnXlIl4ak6Qdtd06UpdBUqB
	EIWMOF+xsF/oPH77YdojYGwmo9/BTAA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-m89Zc-lBNn6mABpItwYsLQ-1; Fri,
 21 Mar 2025 13:52:45 -0400
X-MC-Unique: m89Zc-lBNn6mABpItwYsLQ-1
X-Mimecast-MFC-AGG-ID: m89Zc-lBNn6mABpItwYsLQ_1742579564
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A67F91903081;
	Fri, 21 Mar 2025 17:52:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 131F319373C4;
	Fri, 21 Mar 2025 17:52:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52LHqfVT2395877
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 21 Mar 2025 13:52:41 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52LHqfD82395876;
	Fri, 21 Mar 2025 13:52:41 -0400
Date: Fri, 21 Mar 2025 13:52:41 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
        Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm-delay: support zoned devices
Message-ID: <Z92naQRO2DrpMnXE@redhat.com>
References: <20250321071816.1674943-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250321071816.1674943-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KvUzIKIhn6i1WmVDFyomcLckdHmhoC8Fh--4IxrQfsg_1742579564
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2025 at 08:18:16AM +0100, Christoph Hellwig wrote:
> Add support for zoned device by passing through report_zoned to the
> underlying read device.
> 
> This is required to make enable xfstests xfs/311 on zoned devices.

On suspend, delay_presuspend() stops delaying and it doesn't guarantee
that new bios coming in will always be submitted after the delayed bios
it is flushing. That can mess things up for zoned devices. I didn't
check if that matters for the specific test. Setting

ti->emulate_zone_append = true;

would enforce write ordering, at the expense of adding a whole other
layer of delays to zoned dm-delay devices. Since this isn't really
useful outside of testing, I think that could be acceptable if necessary
(it would require us to support table reloads of zoned devices with
emulated zone append, since tests often want to change the delay).
However it would probably be better to see if we can just make dm-delay
preserve write ordering during a suspend.

-Ben

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-delay.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index 08f6387620c1..d4cf0ac2a7aa 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -369,6 +369,21 @@ static int delay_map(struct dm_target *ti, struct bio *bio)
>  	return delay_bio(dc, c, bio);
>  }
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static int delay_report_zones(struct dm_target *ti,
> +		struct dm_report_zones_args *args, unsigned int nr_zones)
> +{
> +	struct delay_c *dc = ti->private;
> +	struct delay_class *c = &dc->read;
> +
> +	return dm_report_zones(c->dev->bdev, c->start,
> +			c->start + dm_target_offset(ti, args->next_sector),
> +			args, nr_zones);
> +}
> +#else
> +#define delay_report_zones	NULL
> +#endif
> +
>  #define DMEMIT_DELAY_CLASS(c) \
>  	DMEMIT("%s %llu %u", (c)->dev->name, (unsigned long long)(c)->start, (c)->delay)
>  
> @@ -424,11 +439,12 @@ static int delay_iterate_devices(struct dm_target *ti,
>  static struct target_type delay_target = {
>  	.name	     = "delay",
>  	.version     = {1, 4, 0},
> -	.features    = DM_TARGET_PASSES_INTEGRITY,
> +	.features    = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
>  	.module      = THIS_MODULE,
>  	.ctr	     = delay_ctr,
>  	.dtr	     = delay_dtr,
>  	.map	     = delay_map,
> +	.report_zones = delay_report_zones,
>  	.presuspend  = delay_presuspend,
>  	.resume	     = delay_resume,
>  	.status	     = delay_status,
> -- 
> 2.45.2
> 

