Return-Path: <SRS0=pJ9r=IR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37043C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 00:31:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C967C64F18
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 00:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C967C64F18
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616113880;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mjo5oW/S7X/gKj2A99bFc4FDW63EcVwwfE0ANbZDOX0=;
	b=XHNFaeuWlecf605TqruS/wdjTXKLKpyc2u/HkOS7I73Fgn3GJ4zJyjuioYvc8gTm5PmuLK
	iRN9qXK6tGBkpn8fz+j6Ff02jt7qvvXwxwYwagtV3xEKdjGzidWur0sWjD/4q5hlWmxUTg
	i5u3X3WcauDXbHdrP8/hV7RS2XGBRL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-BZ7Dr4liPkqT2rd6hehgMQ-1; Thu, 18 Mar 2021 20:31:18 -0400
X-MC-Unique: BZ7Dr4liPkqT2rd6hehgMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED9A0871377;
	Fri, 19 Mar 2021 00:31:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE0AD60C13;
	Fri, 19 Mar 2021 00:31:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA9AA1809C83;
	Fri, 19 Mar 2021 00:31:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12J0V7dp000316 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 20:31:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A95B35C582; Fri, 19 Mar 2021 00:31:07 +0000 (UTC)
Received: from T590 (ovpn-12-90.pek2.redhat.com [10.72.12.90])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77DAF5C1D1;
	Fri, 19 Mar 2021 00:30:51 +0000 (UTC)
Date: Fri, 19 Mar 2021 08:30:47 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YFPwt6+sNa6SD+m/@T590>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-10-ming.lei@redhat.com>
	<20210318172622.GA3871@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210318172622.GA3871@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 09/13] block: use per-task poll
 context to implement bio based io poll
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

On Thu, Mar 18, 2021 at 01:26:22PM -0400, Mike Snitzer wrote:
> On Thu, Mar 18 2021 at 12:48pm -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > Currently bio based IO poll needs to poll all hw queue blindly, this way
> > is very inefficient, and the big reason is that we can't pass bio
> > submission result to io poll task.
> > 
> > In IO submission context, track associated underlying bios by per-task
> > submission queue and save 'cookie' poll data in bio->bi_iter.bi_private_data,
> > and return current->pid to caller of submit_bio() for any bio based
> > driver's IO, which is submitted from FS.
> > 
> > In IO poll context, the passed cookie tells us the PID of submission
> > context, and we can find the bio from that submission context. Moving
> > bio from submission queue to poll queue of the poll context, and keep
> > polling until these bios are ended. Remove bio from poll queue if the
> > bio is ended. Add BIO_DONE and BIO_END_BY_POLL for such purpose.
> > 
> > In previous version, kfifo is used to implement submission queue, and
> > Jeffle Xu found that kfifo can't scale well in case of high queue depth.
> > So far bio's size is close to 2 cacheline size, and it may not be
> > accepted to add new field into bio for solving the scalability issue by
> > tracking bios via linked list, switch to bio group list for tracking bio,
> > the idea is to reuse .bi_end_io for linking bios into a linked list for
> > all sharing same .bi_end_io(call it bio group), which is recovered before
> > really end bio, since BIO_END_BY_POLL is added for enhancing this point.
> > Usually .bi_end_bio is same for all bios in same layer, so it is enough to
> > provide very limited groups, such as 32 for fixing the scalability issue.
> > 
> > Usually submission shares context with io poll. The per-task poll context
> > is just like stack variable, and it is cheap to move data between the two
> > per-task queues.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/bio.c               |   5 ++
> >  block/blk-core.c          | 149 +++++++++++++++++++++++++++++++-
> >  block/blk-mq.c            | 173 +++++++++++++++++++++++++++++++++++++-
> >  block/blk.h               |   9 ++
> >  include/linux/blk_types.h |  16 +++-
> >  5 files changed, 348 insertions(+), 4 deletions(-)
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
> >  again:
> >  	if (!bio_remaining_done(bio))
> >  		return;
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index efc7a61a84b4..778d25a7e76c 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -805,6 +805,77 @@ static inline unsigned int bio_grp_list_size(unsigned int nr_grps)
> >  		sizeof(struct bio_grp_list_data);
> >  }
> >  
> > +static inline void *bio_grp_data(struct bio *bio)
> > +{
> > +	return bio->bi_poll;
> > +}
> > +
> > +/* add bio into bio group list, return true if it is added */
> > +static bool bio_grp_list_add(struct bio_grp_list *list, struct bio *bio)
> > +{
> > +	int i;
> > +	struct bio_grp_list_data *grp;
> > +
> > +	for (i = 0; i < list->nr_grps; i++) {
> > +		grp = &list->head[i];
> > +		if (grp->grp_data == bio_grp_data(bio)) {
> > +			__bio_grp_list_add(&grp->list, bio);
> > +			return true;
> > +		}
> > +	}
> > +
> > +	if (i == list->max_nr_grps)
> > +		return false;
> > +
> > +	/* create a new group */
> > +	grp = &list->head[i];
> > +	bio_list_init(&grp->list);
> > +	grp->grp_data = bio_grp_data(bio);
> > +	__bio_grp_list_add(&grp->list, bio);
> > +	list->nr_grps++;
> > +
> > +	return true;
> > +}
> > +
> > +static int bio_grp_list_find_grp(struct bio_grp_list *list, void *grp_data)
> > +{
> > +	int i;
> > +	struct bio_grp_list_data *grp;
> > +
> > +	for (i = 0; i < list->max_nr_grps; i++) {
> > +		grp = &list->head[i];
> > +		if (grp->grp_data == grp_data)
> > +			return i;
> > +	}
> > +	for (i = 0; i < list->max_nr_grps; i++) {
> > +		grp = &list->head[i];
> > +		if (bio_grp_list_grp_empty(grp))
> > +			return i;
> > +	}
> > +	return -1;
> > +}
> > +
> > +/* Move as many as possible groups from 'src' to 'dst' */
> > +void bio_grp_list_move(struct bio_grp_list *dst, struct bio_grp_list *src)
> > +{
> > +	int i, j, cnt = 0;
> > +	struct bio_grp_list_data *grp;
> > +
> > +	for (i = src->nr_grps - 1; i >= 0; i--) {
> > +		grp = &src->head[i];
> > +		j = bio_grp_list_find_grp(dst, grp->grp_data);
> > +		if (j < 0)
> > +			break;
> > +		if (bio_grp_list_grp_empty(&dst->head[j]))
> > +			dst->head[j].grp_data = grp->grp_data;
> > +		__bio_grp_list_merge(&dst->head[j].list, &grp->list);
> > +		bio_list_init(&grp->list);
> > +		cnt++;
> > +	}
> > +
> > +	src->nr_grps -= cnt;
> > +}
> > +
> >  static void bio_poll_ctx_init(struct blk_bio_poll_ctx *pc)
> >  {
> >  	pc->sq = (void *)pc + sizeof(*pc);
> > @@ -866,6 +937,46 @@ static inline void blk_bio_poll_preprocess(struct request_queue *q,
> >  		bio->bi_opf |= REQ_TAG;
> >  }
> >  
> > +static bool blk_bio_poll_prep_submit(struct io_context *ioc, struct bio *bio)
> > +{
> > +	struct blk_bio_poll_ctx *pc = ioc->data;
> > +	unsigned int queued;
> > +
> > +	/*
> > +	 * We rely on immutable .bi_end_io between blk-mq bio submission
> > +	 * and completion. However, bio crypt may update .bi_end_io during
> > +	 * submitting, so simply not support bio based polling for this
> > +	 * setting.
> > +	 */
> > +	if (likely(!bio_has_crypt_ctx(bio))) {
> > +		/* track this bio via bio group list */
> > +		spin_lock(&pc->sq_lock);
> > +		queued = bio_grp_list_add(pc->sq, bio);
> > +		spin_unlock(&pc->sq_lock);
> > +	} else {
> > +		queued = false;
> > +	}
> > +
> > +	/*
> > +	 * Now the bio is added per-task fifo, mark it as END_BY_POLL,
> > +	 * and the bio is always completed from the pair poll context.
> > +	 *
> > +	 * One invariant is that if bio isn't completed, blk_poll() will
> > +	 * be called by passing cookie returned from submitting this bio.
> > +	 */
> > +	if (!queued)
> > +		bio->bi_opf &= ~(REQ_HIPRI | REQ_TAG);
> > +	else
> > +		bio_set_flag(bio, BIO_END_BY_POLL);
> > +
> > +	return queued;
> > +}
> > +
> > +static void blk_bio_poll_post_submit(struct bio *bio, blk_qc_t cookie)
> > +{
> > +	bio->bi_iter.bi_private_data = cookie;
> > +}
> > +
> >  static noinline_for_stack bool submit_bio_checks(struct bio *bio)
> >  {
> >  	struct block_device *bdev = bio->bi_bdev;
> > @@ -1020,7 +1131,7 @@ static blk_qc_t __submit_bio(struct bio *bio)
> >   * bio_list_on_stack[1] contains bios that were submitted before the current
> >   *	->submit_bio_bio, but that haven't been processed yet.
> >   */
> > -static blk_qc_t __submit_bio_noacct(struct bio *bio)
> > +static blk_qc_t __submit_bio_noacct_int(struct bio *bio, struct io_context *ioc)
> >  {
> >  	struct bio_list bio_list_on_stack[2];
> >  	blk_qc_t ret = BLK_QC_T_NONE;
> > @@ -1043,7 +1154,16 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >  		bio_list_on_stack[1] = bio_list_on_stack[0];
> >  		bio_list_init(&bio_list_on_stack[0]);
> >  
> > -		ret = __submit_bio(bio);
> > +		if (ioc && queue_is_mq(q) &&
> > +				(bio->bi_opf & (REQ_HIPRI | REQ_TAG))) {
> > +			bool queued = blk_bio_poll_prep_submit(ioc, bio);
> > +
> > +			ret = __submit_bio(bio);
> > +			if (queued)
> > +				blk_bio_poll_post_submit(bio, ret);
> > +		} else {
> > +			ret = __submit_bio(bio);
> > +		}
> 
> So you're only supporting bio-based polling if the bio-based device is
> stacked _directly_ ontop of blk-mq?  Severely limits the utility of
> bio-based IO polling support if such shallow stacking is required.

No, not directly ontop of blk-mq, and it can be any descendant blk-mq
device, so far only blk-mq can provide direct polling support, see
blk_poll():

                ret = q->mq_ops->poll(hctx);

If not any descendant blk-mq device is involved in this bio based
device, we can't support polling so far.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

