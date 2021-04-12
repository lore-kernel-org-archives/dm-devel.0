Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B63C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 10:23:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 450B96109F
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 10:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 450B96109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618223009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qZUFNTj5gdS2EvMRNRMAF7ZT1Vcj98J0v2mkcFySRVQ=;
	b=LpErXAqNI63lWXhK0qqHAdyuLeOn2Ij+WeMjWJuqsrMHESq30APtK06EVjcmKN9t+JQGph
	+ft8iddVjwXi4o/IOl8YIU/Q8P0+jP5kLC3AGq0mAUP40rS2AmReEJ0d1ArhMiUHCtsYP6
	zcWW0J40RMQyFKJ6Qz1uIe04Zo9v884=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-BnnLpdmGNLa0aZTDHULXwg-1; Mon, 12 Apr 2021 06:23:27 -0400
X-MC-Unique: BnnLpdmGNLa0aZTDHULXwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 539956D246;
	Mon, 12 Apr 2021 10:23:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 26C2719C59;
	Mon, 12 Apr 2021 10:23:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A46721806D0E;
	Mon, 12 Apr 2021 10:23:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13CALF64030194 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Apr 2021 06:21:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CE3A41037E81; Mon, 12 Apr 2021 10:21:15 +0000 (UTC)
Received: from T590 (ovpn-12-111.pek2.redhat.com [10.72.12.111])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EF63101E663;
	Mon, 12 Apr 2021 10:20:59 +0000 (UTC)
Date: Mon, 12 Apr 2021 18:20:55 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YHQfB83n8dQSwD3O@T590>
References: <20210401021927.343727-1-ming.lei@redhat.com>
	<20210401021927.343727-9-ming.lei@redhat.com>
	<20210412095427.GA987123@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210412095427.GA987123@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [dm-devel] [PATCH V5 08/12] block: use per-task poll context to
 implement bio based io polling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 12, 2021 at 10:54:27AM +0100, Christoph Hellwig wrote:
> On Thu, Apr 01, 2021 at 10:19:23AM +0800, Ming Lei wrote:
> > Currently bio based IO polling needs to poll all hw queue blindly, this
> > way is very inefficient, and one big reason is that we can't pass any
> > bio submission result to blk_poll().
> > 
> > In IO submission context, track associated underlying bios by per-task
> > submission queue and store returned 'cookie' in
> > bio->bi_iter.bi_private_data, and return current->pid to caller of
> > submit_bio() for any bio based driver's IO, which is submitted from FS.
> > 
> > In IO poll context, the passed cookie tells us the PID of submission
> > context, then we can find bios from the per-task io pull context of
> > submission context. Moving bios from submission queue to poll queue of
> > the poll context, and keep polling until these bios are ended. Remove
> > bio from poll queue if the bio is ended. Add bio flags of BIO_DONE and
> > BIO_END_BY_POLL for such purpose.
> > 
> > In was found in Jeffle Xu's test that kfifo doesn't scale well for a
> > submission queue as queue depth is increased, so a new mechanism for
> > tracking bios is needed. So far bio's size is close to 2 cacheline size,
> > and it may not be accepted to add new field into bio for solving the
> > scalability issue by tracking bios via linked list, switch to bio group
> > list for tracking bio, the idea is to reuse .bi_end_io for linking bios
> > into a linked list for all sharing same .bi_end_io(call it bio group),
> > which is recovered before ending bio really, since BIO_END_BY_POLL is
> > added for enhancing this point. Usually .bi_end_bio is same for all
> > bios in same layer, so it is enough to provide very limited groups, such
> > as 16 or less for fixing the scalability issue.
> > 
> > Usually submission shares context with io poll. The per-task poll context
> > is just like stack variable, and it is cheap to move data between the two
> > per-task queues.
> > 
> > Also when the submission task is exiting, drain pending IOs in the context
> > until all are done.
> > 
> > Tested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> > Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/bio.c               |   5 +
> >  block/blk-core.c          | 155 +++++++++++++++++++++++-
> >  block/blk-ioc.c           |   3 +
> >  block/blk-mq.c            | 244 +++++++++++++++++++++++++++++++++++++-
> >  block/blk.h               |  10 ++
> >  include/linux/blk_types.h |  26 +++-
> >  6 files changed, 439 insertions(+), 4 deletions(-)
> > 
> > diff --git a/block/bio.c b/block/bio.c
> > index 26b7f721cda8..04c043dc60fc 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -1402,6 +1402,11 @@ static inline bool bio_remaining_done(struct bio *bio)
> >   **/
> >  void bio_endio(struct bio *bio)
> >  {
> > +	/* BIO_END_BY_POLL has to be set before calling submit_bio */
> > +	if (bio_flagged(bio, BIO_END_BY_POLL)) {
> > +		bio_set_flag(bio, BIO_DONE);
> > +		return;
> > +	}
> 
> Why can't driver that implements bio based polling call a separate
> bio_endio_polled instead?

This bio is blk-mq IO which is underlying bio of DM or bio based driver, so
they doesn't belong to DM or bio based driver. Actually the bio_endio()
is called by blk_update_request().

The patch just tracks underlying bio-mq bios in current context, then
poll them until all are done.

> 
> > +static inline void *bio_grp_data(struct bio *bio)
> > +{
> > +	return bio->bi_poll;
> > +}
> 
> What is the purpose of this helper?  And why does it have to lose the
> type information?

This patch stores bio->bi_end_io(shared with ->bi_poll) into one per-task
data structure, and links all bios sharing same .bi_end_io into one list
via ->bi_end_io. And their ->bi_end_io is recovered before calling
bio_endio().

The helper is used for checking if one bio can be added to bio group,
and storing the data. The helper just serves for document purpose.

And the type info doesn't matter.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

