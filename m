Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85704C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 06:13:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-siroDy-_PSOdLLgutJ7KdA-1; Fri, 28 Jan 2022 01:13:27 -0500
X-MC-Unique: siroDy-_PSOdLLgutJ7KdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5223E814243;
	Fri, 28 Jan 2022 06:13:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B098410246EB;
	Fri, 28 Jan 2022 06:13:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0BADB1809CB8;
	Fri, 28 Jan 2022 06:13:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20S6DFZL016427 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 01:13:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 23F1E48FB06; Fri, 28 Jan 2022 06:13:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 201244021B4
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 06:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 079273C121D8
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 06:13:15 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-458-hq--04QLOMqfVdC26OniHg-1; Fri, 28 Jan 2022 01:13:12 -0500
X-MC-Unique: hq--04QLOMqfVdC26OniHg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id C703668AA6; Fri, 28 Jan 2022 07:13:08 +0100 (CET)
Date: Fri, 28 Jan 2022 07:13:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20220128061308.GA1477@lst.de>
References: <20220128041753.32195-1-snitzer@redhat.com>
	<20220128041753.32195-2-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220128041753.32195-2-snitzer@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
	hch@lst.de
Subject: Re: [dm-devel] [PATCH v3 1/3] block: add bio_start_io_acct_time()
 to control start_time
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 27, 2022 at 11:17:51PM -0500, Mike Snitzer wrote:
> +	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> +			     bio_op(bio), start_time);
>  }
> +EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
>  
>  /**
>   * bio_start_io_acct - start I/O accounting for bio based drivers
> @@ -1084,14 +1096,15 @@ static unsigned long __part_start_io_acct(struct block_device *part,
>   */
>  unsigned long bio_start_io_acct(struct bio *bio)
>  {
> -	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio), bio_op(bio));
> +	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> +				    bio_op(bio), jiffies);

Is droppingthe READ_ONCE safe here?  This is a honest question as these
helpers still confuse me.

The rest looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

