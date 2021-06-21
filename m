Return-Path: <SRS0=G5ov=LP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F15BC49EA3
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 07:25:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C9D360C3D
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 07:25:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C9D360C3D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-T7WIHsFnMiyhVBMqGfWgCA-1; Mon, 21 Jun 2021 03:25:21 -0400
X-MC-Unique: T7WIHsFnMiyhVBMqGfWgCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B2FF804140;
	Mon, 21 Jun 2021 07:25:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DC085D9DD;
	Mon, 21 Jun 2021 07:25:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E20AC4EA2A;
	Mon, 21 Jun 2021 07:25:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15L7PCHD016097 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Jun 2021 03:25:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6E76B1112840; Mon, 21 Jun 2021 07:25:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66DA0111286A
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 07:25:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6396108C0A0
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 07:25:09 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-292-cEtyx5fDNpCXT92TLFV7TA-1;
	Mon, 21 Jun 2021 03:25:05 -0400
X-MC-Unique: cEtyx5fDNpCXT92TLFV7TA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7EA6368BEB; Mon, 21 Jun 2021 09:25:02 +0200 (CEST)
Date: Mon, 21 Jun 2021 09:25:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20210621072502.GC6651@lst.de>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-3-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210617103549.930311-3-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 2/3] block: add ->poll_bio to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +	struct gendisk *disk = bio->bi_bdev->bd_disk;
> +	struct request_queue *q = disk->queue;
>  	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
>  	int ret;
>  
> -	if (cookie == BLK_QC_T_NONE || !blk_queue_poll(q))
> +	if ((queue_is_mq(q) && cookie == BLK_QC_T_NONE) ||
> +			!blk_queue_poll(q))
>  		return 0;

How does polling for a bio without a cookie make sense even when
polling bio based?

But if we come up for a good rationale for this I'd really
split the conditions to make them more readable:

	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
		return 0;
	if (queue_is_mq(q) && cookie == BLK_QC_T_NONE)
		return 0;

> +	if (!queue_is_mq(q)) {
> +		if (disk->fops->poll_bio) {
> +			ret = disk->fops->poll_bio(bio, flags);
> +		} else {
> +			WARN_ON_ONCE(1);
> +			ret = 0;
> +		}
> +	} else {
>  		ret = blk_mq_poll(q, cookie, flags);

I'd go for someting like:

	if (queue_is_mq(q))
		ret = blk_mq_poll(q, cookie, flags);
	else if (disk->fops->poll_bio)
		ret = disk->fops->poll_bio(bio, flags);
	else
		WARN_ON_ONCE(1);

with ret initialized to 0 at declaration time.

>  struct block_device_operations {
>  	void (*submit_bio)(struct bio *bio);
> +	/* ->poll_bio is for bio driver only */

I'd drop the comment, this is already nicely documented in add_disk
together with the actual check.  We also don't note this for submit_bio
here.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

