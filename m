Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C0FC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:54:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F4A36101E
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F4A36101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618840476;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3XXhGbMhR+blyiI0IXflrpnsNIHX3r9HXGGRe5WcEP0=;
	b=TIGnJHExloU1iIkBHVo3MeGYLv5dGOG8ow4vqYLAZHgI6UL6zl8dre1SYa1yN0XPXkzp03
	v66cuIoe8PE9GpeNryb4EsbCMu5rJJykbkSRkD2oj46qnX1tGtgLQt09U+CHq1zWimQ4Lx
	iBE2XY64M56aUJVXrI0cs9iwy60ckH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-g43F11EAMquf0i2Lput6TQ-1; Mon, 19 Apr 2021 09:54:34 -0400
X-MC-Unique: g43F11EAMquf0i2Lput6TQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 076FACC632;
	Mon, 19 Apr 2021 13:54:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E26E18E53;
	Mon, 19 Apr 2021 13:54:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 084CB4EA30;
	Mon, 19 Apr 2021 13:54:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13JDokTO029403 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 09:50:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E3B6219C66; Mon, 19 Apr 2021 13:50:46 +0000 (UTC)
Received: from T590 (ovpn-12-222.pek2.redhat.com [10.72.12.222])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02A6017A81;
	Mon, 19 Apr 2021 13:50:41 +0000 (UTC)
Date: Mon, 19 Apr 2021 21:50:39 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YH2Kr8ZIn2fWKFyl@T590>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
	<20210415103310.1513841-3-ming.lei@redhat.com>
	<b1db72f3-f0a1-72f2-be12-6fd50c29e231@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <b1db72f3-f0a1-72f2-be12-6fd50c29e231@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 19, 2021 at 08:05:46PM +0800, JeffleXu wrote:
> 
> 
> On 4/15/21 6:33 PM, Ming Lei wrote:
> > For bio based request queue, the queue usage refcnt is only grabbed
> > during submission, which isn't consistent with request base queue.
> > 
> > Queue freezing has been used widely, and turns out it is very useful
> > to quiesce queue activity.
> > 
> > Support to freeze bio based request queue by the following approach:
> > 
> > 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> > bio, one is for bio, anther is for request;
> 
> 
> Hi, I can't understand the sense of grabbing two refcounts on the
> @q_usage_count of the underlying blk-mq device, while
> @q_usage_count of the MD/DM device is kept untouched.

Follows the point:

1) for blk-mq, we hold one refcount for bio and another for request, and
release one after ending bio or completing request.

2) for bio based queue, just holding one refcount for bio, and release it
after the bio is ended.

As I mentioned to you, the current in-tree code only grabs the refcount
during submitting bio for bio base queue, and the refcount is released
after returning from submission, see __submit_bio().

> 
> In the following calling stack
> 
> ```
> queue_poll_store
> 	blk_mq_freeze_queue(q)
> ```
> 
> Is the input @q still the request queue of MD/DM device?

It can be either one after bio based io polling is supported,
queue/io_poll is exposed for both blk-mq and bio based queue.

However, I guess bio based polling doesn't need such strict bio queue
freezing, cause QUEUE_FLAG_POLL is only read in submission path, so
looks current freezing just during submission is enough.


Thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

