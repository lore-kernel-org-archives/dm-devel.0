Return-Path: <SRS0=6/GL=PA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E364C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Oct 2021 16:50:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2903860F21
	for <dm-devel@archiver.kernel.org>; Tue, 12 Oct 2021 16:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2903860F21
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-JujZmaiuN1mGkNMlb-Np4A-1; Tue, 12 Oct 2021 12:50:26 -0400
X-MC-Unique: JujZmaiuN1mGkNMlb-Np4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AF42100CC85;
	Tue, 12 Oct 2021 16:50:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FE585D9C6;
	Tue, 12 Oct 2021 16:50:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CDCD94EA2A;
	Tue, 12 Oct 2021 16:50:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19CGoJG1026843 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 12 Oct 2021 12:50:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 54A9F40CFD10; Tue, 12 Oct 2021 16:50:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F34B40CFD05
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 16:50:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36535800C00
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 16:50:19 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
	[209.85.215.176]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-36-xHMXLRkPPA65Yw_aPuOD-w-1; Tue, 12 Oct 2021 12:50:15 -0400
X-MC-Unique: xHMXLRkPPA65Yw_aPuOD-w-1
Received: by mail-pg1-f176.google.com with SMTP id m21so14397561pgu.13;
	Tue, 12 Oct 2021 09:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=pyFv6DRp7mj/TLzrQIpVommdcoXtzdvra+rup/vPgR4=;
	b=oyvUYaKmw3ob7f+KkEWzFs16qZelYyNsY3Tr8mMFyj0OGBwHV7aUKazOPNU77tlowX
	gOllRLTBUnC2/OQPPTRqRZAFL/PEOhxRRG00Mc/i007soiSIuadK2w3stxcpdQ7BJry4
	7fKSPyJ+C4XdbhBVT06B2Jt/xh4BOQ8HoA44OcFBaxNhJC/dpaCnhWzr0riQdspWIA5b
	2ZZSW2b37lUxNbvu/USerhCky2T1vCo+fLGYNiZ5AWQCLt4CRhP8s+m+1Ld9s+XpsXmT
	pKhsmEPnS7BcyAD6w2FfEfQ0B2jcqLrMl9kwiGYgNIFJ+3NEDy7pz+L+Z+XTWu8QGRKg
	DfZA==
X-Gm-Message-State: AOAM530ft5VsJJ8NS61DyQ+DkQBHuYbWqY8vamdaURWg4u9aIKOG2mZP
	KZyWSbHjopP0ekhrhi1QXTfzqGZO5z4=
X-Google-Smtp-Source: ABdhPJwTpBGjULlYiKlbOfc5N6o7DtsijNW+l2r5Ip5ZBV/isIjOmuv6AyEfJPmCNZ7NpziTdyvuTA==
X-Received: by 2002:a05:6a00:26dd:b0:44d:2531:9f46 with SMTP id
	p29-20020a056a0026dd00b0044d25319f46mr10473312pfw.46.1634057413516;
	Tue, 12 Oct 2021 09:50:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
	([2620:15c:211:201:8c1a:acb2:4eff:5d13])
	by smtp.gmail.com with ESMTPSA id k22sm3734836pji.2.2021.10.12.09.50.12
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 12 Oct 2021 09:50:12 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20211012163613.994933-1-hch@lst.de>
	<20211012163613.994933-2-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <d5273d1f-dbf1-8921-b03d-0f61d08dbfdc@acm.org>
Date: Tue, 12 Oct 2021 09:50:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012163613.994933-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/5] block: factor out a chunk_size_left
	helper
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

On 10/12/21 9:36 AM, Christoph Hellwig wrote:
> +/*
> + * Return how much of the chunk sectors is left to be used for an I/O at the
> + * given offset.
> + */
> +static inline unsigned int chunk_size_left(sector_t offset,
> +		unsigned int chunk_sectors)
> +{
> +	if (unlikely(!is_power_of_2(chunk_sectors)))
> +		return chunk_sectors - sector_div(offset, chunk_sectors);
> +	return chunk_sectors - (offset & (chunk_sectors - 1));
> +}

No "blk_" prefix for the function name? I think most other functions 
declared or defined in this header file have such a prefix.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

