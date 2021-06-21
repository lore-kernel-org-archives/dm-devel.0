Return-Path: <SRS0=G5ov=LP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E94C48BE5
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 08:42:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 417BB611C1
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 08:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 417BB611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624264933;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XmSvTwtfzKhxUdd+NornCQSSbOXisOtXe4myobwwkbA=;
	b=PMVWcAqAjlZSztKpO9ZJc2/T7pFHwccANR++V9EY/DHoJL9qjK3jOkVp9R38ryRfxxKub9
	qOnxvctvuGfi2mhg/v8BWB1+g56IYprL7/6tYE+G3pbYI3NiAlgxY2pHYD2qPcWC4l4hWg
	ObRDVuPf6mlUirlNXiSICH/z0nTjaKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-VI3wRXaSNTGeFXrDO-wyNQ-1; Mon, 21 Jun 2021 04:42:11 -0400
X-MC-Unique: VI3wRXaSNTGeFXrDO-wyNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7B8F802C88;
	Mon, 21 Jun 2021 08:42:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ED5060938;
	Mon, 21 Jun 2021 08:42:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 374C14EA29;
	Mon, 21 Jun 2021 08:42:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15L8g3tF023891 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Jun 2021 04:42:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EF4085D703; Mon, 21 Jun 2021 08:42:03 +0000 (UTC)
Received: from T590 (ovpn-13-237.pek2.redhat.com [10.72.13.237])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 514791ABD4;
	Mon, 21 Jun 2021 08:41:50 +0000 (UTC)
Date: Mon, 21 Jun 2021 16:41:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YNBQvSR3glgt59J9@T590>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-3-ming.lei@redhat.com>
	<20210621072502.GC6651@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210621072502.GC6651@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 21, 2021 at 09:25:02AM +0200, Christoph Hellwig wrote:
> > +	struct gendisk *disk = bio->bi_bdev->bd_disk;
> > +	struct request_queue *q = disk->queue;
> >  	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
> >  	int ret;
> >  
> > -	if (cookie == BLK_QC_T_NONE || !blk_queue_poll(q))
> > +	if ((queue_is_mq(q) && cookie == BLK_QC_T_NONE) ||
> > +			!blk_queue_poll(q))
> >  		return 0;
> 
> How does polling for a bio without a cookie make sense even when
> polling bio based?

It isn't necessary to use bio->bi_cookie, that is why I doesn't use it,
which actually provides one free 32bit in bio for bio based driver.

> 
> But if we come up for a good rationale for this I'd really
> split the conditions to make them more readable:
> 
> 	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> 		return 0;
> 	if (queue_is_mq(q) && cookie == BLK_QC_T_NONE)
> 		return 0;

OK.

> 
> > +	if (!queue_is_mq(q)) {
> > +		if (disk->fops->poll_bio) {
> > +			ret = disk->fops->poll_bio(bio, flags);
> > +		} else {
> > +			WARN_ON_ONCE(1);
> > +			ret = 0;
> > +		}
> > +	} else {
> >  		ret = blk_mq_poll(q, cookie, flags);
> 
> I'd go for someting like:
> 
> 	if (queue_is_mq(q))
> 		ret = blk_mq_poll(q, cookie, flags);
> 	else if (disk->fops->poll_bio)
> 		ret = disk->fops->poll_bio(bio, flags);
> 	else
> 		WARN_ON_ONCE(1);
> 
> with ret initialized to 0 at declaration time.

Fine.

> 
> >  struct block_device_operations {
> >  	void (*submit_bio)(struct bio *bio);
> > +	/* ->poll_bio is for bio driver only */
> 
> I'd drop the comment, this is already nicely documented in add_disk
> together with the actual check.  We also don't note this for submit_bio
> here.

OK.



thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

