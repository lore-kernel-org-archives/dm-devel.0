Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 441A0C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 20:01:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-IiLiGRtLNI2piAO3drPznw-1; Thu, 27 Jan 2022 15:01:46 -0500
X-MC-Unique: IiLiGRtLNI2piAO3drPznw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5007E8143E5;
	Thu, 27 Jan 2022 20:01:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 227D218BA7;
	Thu, 27 Jan 2022 20:01:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6FD3E1809CB8;
	Thu, 27 Jan 2022 20:01:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RK1d3D008708 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 15:01:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0120A2026612; Thu, 27 Jan 2022 20:01:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F09672026609
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 20:01:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B35B802814
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 20:01:36 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-642-JwNcikaxOl6slUxbIPI2sg-1; Thu, 27 Jan 2022 15:01:32 -0500
X-MC-Unique: JwNcikaxOl6slUxbIPI2sg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nDAxW-00H0Y1-CQ; Thu, 27 Jan 2022 20:01:30 +0000
Date: Thu, 27 Jan 2022 12:01:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YfL6GgqQPqj7jxbF@infradead.org>
References: <20220127190742.12776-1-snitzer@redhat.com>
	<20220127190742.12776-2-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220127190742.12776-2-snitzer@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/3] block: add __bio_start_io_acct() to
 control start_time
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -static unsigned long __part_start_io_acct(struct block_device *part,
> -					  unsigned int sectors, unsigned int op)
> +static void __part_start_io_acct(struct block_device *part, unsigned int sectors,
> +				 unsigned int op, unsigned long start_time)

Please avoid the overly long line.

> +/**
> + * __bio_start_io_acct - start I/O accounting for bio based drivers
> + * @bio:	bio to start account for
> + * @start_time:	start time that should be passed back to bio_end_io_acct().
> + */
> +void __bio_start_io_acct(struct bio *bio, unsigned long start_time)

I'd name this something like bio_start_io_acct_time to be a little more
descriptive

> +	unsigned long now = READ_ONCE(jiffies);
> +	__bio_start_io_acct(bio, now);
> +	return now;

Plase add an empty line after the variable declaration.

>  }
>  EXPORT_SYMBOL_GPL(bio_start_io_acct);
>  
>  unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
>  				 unsigned int op)
>  {
> -	return __part_start_io_acct(disk->part0, sectors, op);
> +	unsigned long now = READ_ONCE(jiffies);
> +	__part_start_io_acct(disk->part0, sectors, op, now);
> +	return now;

I wonder if just returning the passed in time from __part_start_io_acct
wouldn't be a bit cleaner to avoid all the extra local variables.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

