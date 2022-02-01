Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A772C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 19:19:05 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-uXLrCH3jN4K2XYsQKJPcdw-1; Tue, 01 Feb 2022 14:19:00 -0500
X-MC-Unique: uXLrCH3jN4K2XYsQKJPcdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEB93839A53;
	Tue,  1 Feb 2022 19:18:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC278C2E07;
	Tue,  1 Feb 2022 19:18:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6C1361809CB9;
	Tue,  1 Feb 2022 19:18:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211JIr6o007581 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 14:18:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1A461121324; Tue,  1 Feb 2022 19:18:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA6E2112132C
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 19:18:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF1BD811E7F
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 19:18:49 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
	[209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-511-IJQJxgSBMVmkPvIgdq_XAQ-1; Tue, 01 Feb 2022 14:18:46 -0500
X-MC-Unique: IJQJxgSBMVmkPvIgdq_XAQ-1
Received: by mail-pf1-f175.google.com with SMTP id v74so16759919pfc.1;
	Tue, 01 Feb 2022 11:18:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=NRC1O6LjHoTRFcyJrr+TbaOvQh6OliquRDaYmBL6vQo=;
	b=yt+bP+o5ZH/BRLFueymPd5P/UM/1Ac4oiF3jZXiX1ruv4IiYyCAOg2uya0pC0o+uTh
	sGTy+KIhiqQbpe/ITY9do/WQv/B8+lAnDvL5yMTB+pOPifZdb2YrvyuOng+2Ht//ekbp
	QsRZz508WyXRDwXEE4S4Zzc+XrCn542Vbl3bPM+8r3A9FULMJz33AyXy95QEQbtFL6aI
	ofGdD+gAH0IhKwB54ARpFdmz+tsL1Xu/LXiAbDHrhTamfWLn4egRtjB5Az6HUpkV/zdd
	Upre9KTY27cqoQ5U/qZXddd1ng0ni9ndssFkYQ0KDclJeZBCKsc8vrmrBwPNFhdaaHLL
	gu3A==
X-Gm-Message-State: AOAM531F/jyrS9qwR1Sz0IVan7QHHb1SOhGEZiNKbYFzySL60ujUEDbd
	ze356lcjp51yux8xI9HNid91Gl5pVrE=
X-Google-Smtp-Source: ABdhPJzdZuuT3zl/4KWMi39wXS4EFCvsDMKJDeuJ1g6HI0TEGyb2bJY3A35suFFqhBI5SCopxvLvag==
X-Received: by 2002:a63:9307:: with SMTP id b7mr22131054pge.616.1643743123461; 
	Tue, 01 Feb 2022 11:18:43 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	nv13sm4083647pjb.17.2022.02.01.11.18.41
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 01 Feb 2022 11:18:42 -0800 (PST)
Message-ID: <efd2e976-4d2d-178e-890d-9bde1a89c47f@acm.org>
Date: Tue, 1 Feb 2022 11:18:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Mikulas Patocka <mpatocka@redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011331570.22481@file01.intranet.prod.int.rdu2.redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <alpine.LRH.2.02.2202011331570.22481@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 1/3] block: add copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2/1/22 10:32, Mikulas Patocka wrote:
>   /**
> + * blk_queue_max_copy_sectors - set maximum copy offload sectors for the queue
> + * @q:  the request queue for the device
> + * @size:  the maximum copy offload sectors
> + */
> +void blk_queue_max_copy_sectors(struct request_queue *q, unsigned int size)
> +{
> +	q->limits.max_copy_sectors = size;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors);

Please either change the unit of 'size' into bytes or change its type 
into sector_t.

> +extern int blkdev_issue_copy(struct block_device *bdev1, sector_t sector1,
> +		      struct block_device *bdev2, sector_t sector2,
> +		      sector_t nr_sects, sector_t *copied, gfp_t gfp_mask);
> +

Only supporting copying between contiguous LBA ranges seems restrictive 
to me. I expect garbage collection by filesystems for UFS devices to 
perform better if multiple LBA ranges are submitted as a single SCSI 
XCOPY command.

A general comment about the approach: encoding the LBA range information 
in a bio payload is not compatible with bio splitting. How can the dm 
driver implement copy offloading without the ability to split copy 
offload bio's?

> +int blkdev_issue_copy(struct block_device *bdev1, sector_t sector1,
> +		      struct block_device *bdev2, sector_t sector2,
> +		      sector_t nr_sects, sector_t *copied, gfp_t gfp_mask)
> +{
> +	struct page *token;
> +	sector_t m;
> +	int r = 0;
> +	struct completion comp;

Consider using DECLARE_COMPLETION_ONSTACK() instead of a separate 
declaration and init_completion() call.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

