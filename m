Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D311C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 01:28:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E8AB261132
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 01:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8AB261132
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618536532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=u43DqkNchS13wQGpQEl2iaBMuXLCWXcrl+YAjMDhUkk=;
	b=LFVU3zCwKv7sCajJJW+FuQeI1bkD2vBYKkc+acfbOHG+lynusmdpvtbWQBqYqOWDGg4CZJ
	6K2B0HZdWlrHBeLzG7iOoYb/9z0+Iswj3elasfsLRhcBN3gYw6834FQIJMoHNv06Qi5PXW
	4I5JiH9pfDVkcFlY0KwBVc4fuTrtuDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-QLJcf-P6NhauEpN4ywUP3A-1; Thu, 15 Apr 2021 21:28:50 -0400
X-MC-Unique: QLJcf-P6NhauEpN4ywUP3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 903761883520;
	Fri, 16 Apr 2021 01:28:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AAD85C3E4;
	Fri, 16 Apr 2021 01:28:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16C1244A5B;
	Fri, 16 Apr 2021 01:28:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G1Senp022046 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 21:28:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4412118B42; Fri, 16 Apr 2021 01:28:40 +0000 (UTC)
Received: from T590 (ovpn-12-36.pek2.redhat.com [10.72.12.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E718D59457;
	Fri, 16 Apr 2021 01:28:26 +0000 (UTC)
Date: Fri, 16 Apr 2021 09:28:22 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <YHjoNg/Z7KQ+4+YX@T590>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
	<20210415103310.1513841-3-ming.lei@redhat.com>
	<af8f41f4-74e8-450d-fa63-6feb6b745222@acm.org>
MIME-Version: 1.0
In-Reply-To: <af8f41f4-74e8-450d-fa63-6feb6b745222@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 2/2] block: support to freeze bio based
 request queue
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 15, 2021 at 01:16:42PM -0700, Bart Van Assche wrote:
> On 4/15/21 3:33 AM, Ming Lei wrote:
> > 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> > bio, one is for bio, anther is for request;
>                        ^^^^^^
>                        another?
> 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 09f774e7413d..f71e4b433030 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -431,12 +431,13 @@ EXPORT_SYMBOL(blk_cleanup_queue);
> >  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
> >  {
> >  	const bool pm = flags & BLK_MQ_REQ_PM;
> > +	const unsigned int nr = (flags & BLK_MQ_REQ_DOUBLE_REF) ? 2 : 1;
> 
> Please leave out the parentheses from around the condition in the above
> and in other ternary expressions. The ternary operator has a very low
> precedence so adding parentheses around the condition in a ternary
> operator is almost never necessary.
> 
> > @@ -480,8 +481,18 @@ static inline int bio_queue_enter(struct bio *bio)
> >  	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> >  	bool nowait = bio->bi_opf & REQ_NOWAIT;
> >  	int ret;
> > +	blk_mq_req_flags_t flags = nowait ? BLK_MQ_REQ_NOWAIT : 0;
> > +	bool reffed = bio_flagged(bio, BIO_QUEUE_REFFED);
> >  
> > -	ret = blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0);
> > +	if (!reffed)
> > +		bio_set_flag(bio, BIO_QUEUE_REFFED);
> > +
> > +	/*
> > +	 * Grab two queue references for blk-mq, one is for bio, and
> > +	 * another is for blk-mq request.
> > +	 */
> > +	ret = blk_queue_enter(q, q->mq_ops && !reffed ?
> > +			(flags | BLK_MQ_REQ_DOUBLE_REF) : flags);
> 
> Consider rewriting the above code as follows to make it easier to read:
> 
> 	if (q->mq_ops && !reffed)
> 		flags |= BLK_MQ_REQ_DOUBLE_REF;
> 	ret = blk_queue_enter(q, flags);
> 
> Please also expand the comment above this code. The comment only
> explains the reffed == false case but not the reffed == true case. I
> assume that the reffed == true case applies to stacked bio-based drivers?

'reffed == true' means we have got one queue usage count already for
this bio, so only need to grab one usage count for blk-mq request.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

