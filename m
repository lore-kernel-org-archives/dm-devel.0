Return-Path: <SRS0=pJ9r=IR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838FCC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 08:49:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B30464F40
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 08:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B30464F40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616143747;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j7XIoE5S2fUD20ifk/Oln5ciiRuqwuSIlKy7SGO3qCE=;
	b=iJCoh3/Uo6ORrhwOte4A823M8bt2PctaHAtJCoR5TJo3lWl0mmLuvEsfGxwyfwoJTYCMWe
	+Ys9SkaNeXHCKvw6HN9MIYOGDBoi/LGcLy0QaW4oVO0S9m7WJ2Ho6e9D9/M8tud0wUoUSj
	iDXEJ9XLdLuZkTMSuU+Epujk7S1o88I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-s2-9zz0oPYKN41-iLtQJlQ-1; Fri, 19 Mar 2021 04:49:05 -0400
X-MC-Unique: s2-9zz0oPYKN41-iLtQJlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AECE7817469;
	Fri, 19 Mar 2021 08:48:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1A185D740;
	Fri, 19 Mar 2021 08:48:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1F5961809C83;
	Fri, 19 Mar 2021 08:48:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12J8mqMa018936 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Mar 2021 04:48:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 52D485C3E5; Fri, 19 Mar 2021 08:48:52 +0000 (UTC)
Received: from T590 (ovpn-13-148.pek2.redhat.com [10.72.13.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AC155C1D1;
	Fri, 19 Mar 2021 08:48:39 +0000 (UTC)
Date: Fri, 19 Mar 2021 16:48:35 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YFRlYw0efpq/PfMu@T590>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-6-ming.lei@redhat.com>
	<50e454b9-2027-cf38-0be7-a4ecfdd54027@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <50e454b9-2027-cf38-0be7-a4ecfdd54027@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [RFC PATCH V2 05/13] block: add req flag of REQ_TAG
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 19, 2021 at 03:59:06PM +0800, JeffleXu wrote:
> 
> 
> On 3/19/21 12:48 AM, Ming Lei wrote:
> > Add one req flag REQ_TAG which will be used in the following patch for
> > supporting bio based IO polling.
> > 
> > Exactly this flag can help us to do:
> > 
> > 1) request flag is cloned in bio_fast_clone(), so if we mark one FS bio
> > as REQ_TAG, all bios cloned from this FS bio will be marked as REQ_TAG.
> > 
> > 2)create per-task io polling context if the bio based queue supports polling
> > and the submitted bio is HIPRI. This per-task io polling context will be
> > created during submit_bio() before marking this HIPRI bio as REQ_TAG. Then
> > we can avoid to create such io polling context if one cloned bio with REQ_TAG
> > is submitted from another kernel context.
> > 
> > 3) for supporting bio based io polling, we need to poll IOs from all
> > underlying queues of bio device/driver, this way help us to recognize which
> > IOs need to polled in bio based style, which will be implemented in next
> > patch.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-core.c          | 29 +++++++++++++++++++++++++++--
> >  include/linux/blk_types.h |  4 ++++
> >  2 files changed, 31 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 0b00c21cbefb..efc7a61a84b4 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -840,11 +840,30 @@ static inline bool blk_queue_support_bio_poll(struct request_queue *q)
> >  static inline void blk_bio_poll_preprocess(struct request_queue *q,
> >  		struct bio *bio)
> >  {
> > +	bool mq;
> > +
> >  	if (!(bio->bi_opf & REQ_HIPRI))
> >  		return;
> >  
> > -	if (!blk_queue_poll(q) || (!queue_is_mq(q) && !blk_get_bio_poll_ctx()))
> > +	/*
> > +	 * Can't support bio based IO poll without per-task poll queue
> > +	 *
> > +	 * Now we have created per-task io poll context, and mark this
> > +	 * bio as REQ_TAG, so: 1) if any cloned bio from this bio is
> > +	 * submitted from another kernel context, we won't create bio
> > +	 * poll context for it, so that bio will be completed by IRQ;
> > +	 * 2) If such bio is submitted from current context, we will
> > +	 * complete it via blk_poll(); 3) If driver knows that one
> > +	 * underlying bio allocated from driver is for FS bio, meantime
> > +	 * it is submitted in current context, driver can mark such bio
> > +	 * as REQ_TAG manually, so the bio can be completed via blk_poll
> > +	 * too.
> > +	 */
> 
> Sorry I can't understand case 3, could you please further explain it? If

I meant driver may allocate bio and submit it in current context, and this
allocated bio is for completing FS hipri bio too. So far, HIPRI won't be
set for this bio, but driver may mark this bio as HIPRI and TAG, so this
created bio can be polled.

> 'driver marks such bio as REQ_TAG manually', then per-task io poll
> context won't be created, and thus REQ_HIPRI will be cleared, in which
> case the bio will be completed by IRQ. How could it be completed by
> blk_poll()?

The io poll context is created when FS HIPRI bio on based queue(DM) is
submitted, at that time, bio based driver's ->submit_bio isn't called
yet. So when bio driver's ->submit_bio() allocates new bios and submits
them in current context, if driver marks this bio as HIPRI and TAG, they
can be polled too.

> 
> 
> > +	mq = queue_is_mq(q);
> > +	if (!blk_queue_poll(q) || (!mq && !blk_get_bio_poll_ctx()))
> >  		bio->bi_opf &= ~REQ_HIPRI;
> 
> 
> 
> 
> If the use cases are mixed, saying one kernel context may submit IO with
> and without REQ_TAG at the meantime (though I don't know if this
> situation exists), then the above code may not work as we expect.

Poll context shouldn't be created for kernel context.

So far, this patch won't cover bios submitted from kernel context, and
for any bios submitted from kernel context, their HIPRI will be cleared.

> 
> For example, dm-XXX will return DM_MAPIO_SUBMITTED and actually submits
> the cloned bio (with REQ_TAG) with internal kernel threads. Besides,
> dm-XXX will also allocate bio (without REQ_TAG) of itself for metadata
> logging or something. When submitting bios (without REQ_TAG), per-task

But HIPRI won't be set for this allocated bio.

> io poll context will be allocated. Later when submitting cloned bios
> (with REQ_TAG), the poll context already exists and thus REQ_HIPRI is
> kept for these bios and they are submitted to polling hw queues.

Originally I planed to add new helper of submit_poll_bio() for current
HIPRI uses, and only create poll context in this code path, this way can
decouple REQ_TAG a bit. But looks it is enough to re-use REQ_TAG for this
purpose. If not, it can be quite easy to address issue wrt. creating poll
context.


Thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

