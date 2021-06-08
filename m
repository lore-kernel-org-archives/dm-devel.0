Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E64C4743E
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:31:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E07761380
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:31:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E07761380
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-C_4ZonqzMuiRtbIfpJq-Xg-1; Tue, 08 Jun 2021 12:31:16 -0400
X-MC-Unique: C_4ZonqzMuiRtbIfpJq-Xg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED3576F310;
	Tue,  8 Jun 2021 16:31:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B32F19CA8;
	Tue,  8 Jun 2021 16:31:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D6FC244A59;
	Tue,  8 Jun 2021 16:31:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158GV79M022104 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 12:31:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3C7E2208C196; Tue,  8 Jun 2021 16:31:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38503208C177
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:31:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DEAE800B29
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:31:03 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
	[209.85.210.179]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-8-3hTa6WjOP1uISxCnhAGcyg-1; Tue, 08 Jun 2021 12:31:00 -0400
X-MC-Unique: 3hTa6WjOP1uISxCnhAGcyg-1
Received: by mail-pf1-f179.google.com with SMTP id z26so16096024pfj.5;
	Tue, 08 Jun 2021 09:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=c/oBlFBZpymRmok4+Br5HKJTKzk4izKuifiUtNGmmMU=;
	b=WqUF7zWUM4epNuNEeGpXXucyGXcEjJx0nE9+GZdrIcRu165mnGNMgeTukS6Nwanmzh
	KoQjTXTF0KFOhjM8ccWKN+YRMsAcBl7pmP35i54gTGeCAp9NIdZa8brEcMyUJsGgf2fj
	jv5cvx+EEJfqdzcLaSj5OmqXNhgi7w7I60MUw0Qn1V3q24UC3Er6p+8mdFeKSJUOVhpE
	xywCIvJeh5o1gg0//qMpKo/9QUkOZ4TW9Sv/ypvX/8kED9AnyxeIOfZASEF3cnBQONVW
	YSApo9lpHz8S341L8dtkyAZPeRE+nC8+YGW0QgfwRIk9uJeCf+lNzFrmO1VIghN7qMSH
	86GQ==
X-Gm-Message-State: AOAM532ee/Gpw7I0aIkHpM/haXZ47eWDjjBIqA1Jgt8Zgd/i7FCMcvqK
	G0I3P52sWaIH4VHG1/Z9+BY=
X-Google-Smtp-Source: ABdhPJxAnY1ILuuUidoa80Is797vj32J19rnEPL6OqbB3/VUdrwY9tRxfOHxegyAC+CunZFhbY6BTQ==
X-Received: by 2002:a65:6243:: with SMTP id q3mr23851189pgv.297.1623169859346; 
	Tue, 08 Jun 2021 09:30:59 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	c5sm9194629pfn.144.2021.06.08.09.30.57
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 08 Jun 2021 09:30:58 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-9-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <4c248453-713f-9da8-04e8-7939388be49a@acm.org>
Date: Tue, 8 Jun 2021 09:30:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608160603.1535935-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 08/16] dm-writecache: use bvec_kmap_local
 instead of bvec_kmap_irq
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/8/21 9:05 AM, Christoph Hellwig wrote:
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index aecc246ade26..93ca454eaca9 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -1205,14 +1205,13 @@ static void memcpy_flushcache_optimized(void *dest, void *source, size_t size)
>  static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data)
>  {
>  	void *buf;
> -	unsigned long flags;
>  	unsigned size;
>  	int rw = bio_data_dir(bio);
>  	unsigned remaining_size = wc->block_size;
>  
>  	do {
>  		struct bio_vec bv = bio_iter_iovec(bio, bio->bi_iter);
> -		buf = bvec_kmap_irq(&bv, &flags);
> +		buf = bvec_kmap_local(&bv);
>  		size = bv.bv_len;
>  		if (unlikely(size > remaining_size))
>  			size = remaining_size;
> @@ -1230,7 +1229,7 @@ static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data
>  			memcpy_flushcache_optimized(data, buf, size);
>  		}
>  
> -		bvec_kunmap_irq(buf, &flags);
> +		kunmap_local(buf);
>  
>  		data = (char *)data + size;
>  		remaining_size -= size;

>From one of the functions called by kunmap_local():

unsigned long addr = (unsigned long) vaddr & PAGE_MASK;

This won't work well if bvec->bv_offset >= PAGE_SIZE I assume?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

