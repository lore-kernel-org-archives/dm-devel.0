Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDEEC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 21:39:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-mJ1RHofWN2ObkkEcXeaesQ-1; Fri, 04 Mar 2022 16:39:38 -0500
X-MC-Unique: mJ1RHofWN2ObkkEcXeaesQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2272C80EDA1;
	Fri,  4 Mar 2022 21:39:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1F2B794A3;
	Fri,  4 Mar 2022 21:39:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 35A4B46F98;
	Fri,  4 Mar 2022 21:39:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 224LdVx3011900 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 16:39:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B2B394538B9; Fri,  4 Mar 2022 21:39:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE3F14538B6
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 21:39:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C75B3C01C19
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 21:39:31 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
	[209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-508-Y5UAFzJKNRGPAjRSgVz8hg-1; Fri, 04 Mar 2022 16:39:29 -0500
X-MC-Unique: Y5UAFzJKNRGPAjRSgVz8hg-1
Received: by mail-pj1-f48.google.com with SMTP id
	mr24-20020a17090b239800b001bf0a375440so6270525pjb.4
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 13:39:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=O2BKVFUTad+h47EmFlT3Bh2Xc7VKQTN55LWHpLjCMzE=;
	b=ECEtCB67NtW02W3/yxyFRQL5isoO7MTYR88UbF/Kh4xQibniYvgquUUCkZtjNdALnI
	dEE0nRwkgdlELFJh6HbZxMxJ+VtrmRpSAJ3jOsldpXN2pOsO/VtMrVUgCiXlYhzuU0UB
	VzL9zAjjw63trLhzyW8iWgHNSxrKEJIoOD/S1Q1ZI5GNjMRMDnbp+uy7ifV45vwcEjl4
	yffgpWmmxAxjk4qvnPZaPLl3OIlhToX19RzLfm/DAvzJkTRucfMhNKsN0XSyxdEoHczj
	JHg5j1kken0IUjdI5BNso/aUgXeOqdmHAuvv3f/dTbITIkvAo1GvhRvxtDzjjEOVyNHX
	mtfw==
X-Gm-Message-State: AOAM532RhT8PlO8lxfZKW8rGTN8z8XDXo4ZwtEZ973dUVy+WUg9ib+56
	PHWDyAHMSFwnCiPSxh7DEiRY+nMMgBuYmQ==
X-Google-Smtp-Source: ABdhPJz5FHUK82tjeB+aKmTy086tidKwDieQF9SxD+R88XPh37jukK6Rn+E4hcwg9ys6QT20CruiIA==
X-Received: by 2002:a17:90b:390c:b0:1bf:2d83:c70c with SMTP id
	ob12-20020a17090b390c00b001bf2d83c70cmr3837445pjb.217.1646429968664;
	Fri, 04 Mar 2022 13:39:28 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
	by smtp.gmail.com with ESMTPSA id
	y39-20020a056a00182700b004e19980d6cbsm6748783pfa.210.2022.03.04.13.39.27
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 04 Mar 2022 13:39:28 -0800 (PST)
Message-ID: <68dc8fb0-86df-effe-4ef2-8ed9c350d836@kernel.dk>
Date: Fri, 4 Mar 2022 14:39:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
	Thunderbird/91.6.1
To: Mike Snitzer <snitzer@redhat.com>
References: <20220304212623.34016-1-snitzer@redhat.com>
	<20220304212623.34016-2-snitzer@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220304212623.34016-2-snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
	ming.lei@redhat.com
Subject: Re: [dm-devel] [PATCH v4 1/2] block: add ->poll_bio to
	block_device_operations
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 2:26 PM, Mike Snitzer wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 94bf37f8e61d..e739c6264331 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -985,10 +985,16 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
>  
>  	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
>  		return 0;
> -	if (WARN_ON_ONCE(!queue_is_mq(q)))
> -		ret = 0;	/* not yet implemented, should not happen */
> -	else
> +	if (queue_is_mq(q)) {
>  		ret = blk_mq_poll(q, cookie, iob, flags);
> +	} else {
> +		struct gendisk *disk = q->disk;
> +
> +		if (disk && disk->fops->poll_bio)
> +			ret = disk->fops->poll_bio(bio, iob, flags);
> +		else
> +			ret = !WARN_ON_ONCE(1);

This is an odd way to do it, would be a lot more readable as

	ret = 0;
	WARN_ON_ONCE(1);

if we even need that WARN_ON?

> diff --git a/block/genhd.c b/block/genhd.c
> index e351fac41bf2..eb43fa63ba47 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -410,6 +410,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
>  	struct device *ddev = disk_to_dev(disk);
>  	int ret;
>  
> +	WARN_ON_ONCE(queue_is_mq(disk->queue) && disk->fops->poll_bio);

Also seems kind of useless, maybe at least combine it with failing to
add the disk. This is a "I'm developing some new driver or feature"
failure, and would be more visible that way. And if you do that, then
the WARN_ON_ONCE() seems pointless anyway, and I'd just do:

	if (queue_is_mq(disk->queue) && disk->fops->poll_bio)
		return -EINVAL;

or something like that, with a comment saying why that doesn't make any
sense.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

