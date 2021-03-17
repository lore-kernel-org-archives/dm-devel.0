Return-Path: <SRS0=F0YI=IP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADC3C433E6
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 02:55:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF89764F89
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 02:55:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF89764F89
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615949746;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ESPK/r9OlNkAm2USW+uh1Rh4FIAtpijon4QK+WHHdYM=;
	b=XFM/atPwDIjjtlpVpxnVhws+AAE5F93x+0QHp+e1DZreM7CvjpoLfpDvWeLpgHv1de3Bbx
	1RlMaQoajLppzV+zvGqbTvPqyvL3vaMfDmHGDBcuiKeC6rY6fcH4WrP+OoCu1qp30TtcGo
	tgABlkI6rDRlBLQzPx8UCUeevMnONog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-H9-a4ku6PsCaPZZcylW3fQ-1; Tue, 16 Mar 2021 22:55:44 -0400
X-MC-Unique: H9-a4ku6PsCaPZZcylW3fQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 722521850602;
	Wed, 17 Mar 2021 02:55:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1370710013C1;
	Wed, 17 Mar 2021 02:55:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E727F4EA69;
	Wed, 17 Mar 2021 02:55:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12H2shkF009249 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 22:54:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 25363629DA; Wed, 17 Mar 2021 02:54:43 +0000 (UTC)
Received: from T590 (ovpn-13-81.pek2.redhat.com [10.72.13.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75C4A629BF;
	Wed, 17 Mar 2021 02:54:29 +0000 (UTC)
Date: Wed, 17 Mar 2021 10:54:24 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YFFvYH6dRBoqARF6@T590>
References: <20210316031523.864506-1-ming.lei@redhat.com>
	<20210316031523.864506-9-ming.lei@redhat.com>
	<b4dce8c6-61dd-9524-0a55-41db63eb084d@linux.alibaba.com>
	<YFBbjY+oDpjIHI3P@T590>
	<3848e80d-e7ad-9372-c96f-d32bfb9f0ae5@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <3848e80d-e7ad-9372-c96f-d32bfb9f0ae5@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [RFC PATCH 08/11] block: use per-task poll context
 to implement bio based io poll
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

On Tue, Mar 16, 2021 at 04:52:36PM +0800, JeffleXu wrote:
> 
> 
> On 3/16/21 3:17 PM, Ming Lei wrote:
> > On Tue, Mar 16, 2021 at 02:46:08PM +0800, JeffleXu wrote:
> >> It is a giant progress to gather all split bios that need to be polled
> >> in a per-task queue. Still some comments below.
> >>
> >>
> >> On 3/16/21 11:15 AM, Ming Lei wrote:
> >>> Currently bio based IO poll needs to poll all hw queue blindly, this way
> >>> is very inefficient, and the big reason is that we can't pass bio
> >>> submission result to io poll task.
> >>>
> >>> In IO submission context, store associated underlying bios into the
> >>> submission queue and save 'cookie' poll data in bio->bi_iter.bi_private_data,
> >>> and return current->pid to caller of submit_bio() for any DM or bio based
> >>> driver's IO, which is submitted from FS.
> >>>
> >>> In IO poll context, the passed cookie tells us the PID of submission
> >>> context, and we can find the bio from that submission context. Moving
> >>> bio from submission queue to poll queue of the poll context, and keep
> >>> polling until these bios are ended. Remove bio from poll queue if the
> >>> bio is ended. Add BIO_DONE and BIO_END_BY_POLL for such purpose.
> >>>
> >>> Usually submission shares context with io poll. The per-task poll context
> >>> is just like stack variable, and it is cheap to move data between the two
> >>> per-task queues.
> >>>
> >>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >>> ---
> >>>  block/bio.c               |   5 ++
> >>>  block/blk-core.c          |  74 +++++++++++++++++-
> >>>  block/blk-mq.c            | 156 +++++++++++++++++++++++++++++++++++++-
> >>>  include/linux/blk_types.h |   3 +
> >>>  4 files changed, 235 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/block/bio.c b/block/bio.c
> >>> index a1c4d2900c7a..bcf5eca0e8e3 100644
> >>> --- a/block/bio.c
> >>> +++ b/block/bio.c
> >>> @@ -1402,6 +1402,11 @@ static inline bool bio_remaining_done(struct bio *bio)
> >>>   **/
> >>>  void bio_endio(struct bio *bio)
> >>>  {
> >>> +	/* BIO_END_BY_POLL has to be set before calling submit_bio */
> >>> +	if (bio_flagged(bio, BIO_END_BY_POLL)) {
> >>> +		bio_set_flag(bio, BIO_DONE);
> >>> +		return;
> >>> +	}
> >>>  again:
> >>>  	if (!bio_remaining_done(bio))
> >>>  		return;
> >>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>> index a082bbc856fb..970b23fa2e6e 100644
> >>> --- a/block/blk-core.c
> >>> +++ b/block/blk-core.c
> >>> @@ -854,6 +854,40 @@ static inline void blk_bio_poll_preprocess(struct request_queue *q,
> >>>  		bio->bi_opf |= REQ_TAG;
> >>>  }
> >>>  
> >>> +static bool blk_bio_poll_prep_submit(struct io_context *ioc, struct bio *bio)
> >>> +{
> >>> +	struct blk_bio_poll_data data = {
> >>> +		.bio	=	bio,
> >>> +	};
> >>> +	struct blk_bio_poll_ctx *pc = ioc->data;
> >>> +	unsigned int queued;
> >>> +
> >>> +	/* lock is required if there is more than one writer */
> >>> +	if (unlikely(atomic_read(&ioc->nr_tasks) > 1)) {
> >>> +		spin_lock(&pc->lock);
> >>> +		queued = kfifo_put(&pc->sq, data);
> >>> +		spin_unlock(&pc->lock);
> >>> +	} else {
> >>> +		queued = kfifo_put(&pc->sq, data);
> >>> +	}
> >>> +
> >>> +	/*
> >>> +	 * Now the bio is added per-task fifo, mark it as END_BY_POLL,
> >>> +	 * so we can save cookie into this bio after submit_bio().
> >>> +	 */
> >>> +	if (queued)
> >>> +		bio_set_flag(bio, BIO_END_BY_POLL);
> >>> +	else
> >>> +		bio->bi_opf &= ~(REQ_HIPRI | REQ_TAG);
> >>> +
> >>> +	return queued;
> >>> +}
> >>
> >> The size of kfifo is limited, and it seems that once the sq of kfifio is
> >> full, REQ_HIPRI flag is cleared and the corresponding bio is actually
> >> enqueued into the default hw queue, which is IRQ driven.
> > 
> > Yeah, this patch starts with 64 queue depth, and we can increase it to
> > 128, which should cover most of cases.
> 
> It seems that the queue depth of kfifo will affect the performance as I
> did a fast test.
> 
> 
> 
> Test Result:
> 
> BLK_BIO_POLL_SQ_SZ | iodepth | IOPS
> ------------------ | ------- | ----
> 64                 | 128     | 301k (IRQ) -> 340k (iopoll)
> 64                 | 16      | 304k (IRQ) -> 392k (iopoll)
> 128                | 128     | 204k (IRQ) -> 317k (iopoll)
> 256                | 128     | 241k (IRQ) -> 391k (iopoll)
> 
> It seems that BLK_BIO_POLL_SQ_SZ need to be increased accordingly when
> iodepth is quite large. But I don't know why the performance in IRQ mode
> decreases when BLK_BIO_POLL_SQ_SZ is increased.

This patchset is supposed to not affect IRQ mode because HIPRI isn't set
at IRQ mode. Or you mean '--hipri' & io_uring is setup but setting
nvme.poll_queues as 0 at your 'IRQ' mode test?

Thanks for starting to run performance test, and so far I just run test
in KVM, not start performance test yet.



thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

