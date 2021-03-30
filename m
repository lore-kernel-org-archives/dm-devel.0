Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A576C433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:33:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4ECC61983
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4ECC61983
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617093205;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KuBxp1nBQtHegytFmKXxbeEmTzJhOmynO0vTkdNmAfk=;
	b=XSVrlfepYNDIY15qUUqjR9BrUiZcuawT14sjdQCP7LLZG40WuSf72/V4MVp+qyQnfy07SJ
	C2IOYq6XVwvu2CsCwb8GNO94CzzgIRt1Sle8YBmPbYD4QRdGfRhnBSCXSJddYykkZIG77g
	DD1faBvSXAwd5Kk73VoAhW67B5zSM5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-SCfkAkrEMkKUMq3Z5i7r-g-1; Tue, 30 Mar 2021 04:33:23 -0400
X-MC-Unique: SCfkAkrEMkKUMq3Z5i7r-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 018DC801FCE;
	Tue, 30 Mar 2021 08:33:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF8861865D;
	Tue, 30 Mar 2021 08:33:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6879B1809C83;
	Tue, 30 Mar 2021 08:33:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U8XGUr020606 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 04:33:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E4D2100239A; Tue, 30 Mar 2021 08:33:16 +0000 (UTC)
Received: from T590 (ovpn-13-69.pek2.redhat.com [10.72.13.69])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CEDC10016DB;
	Tue, 30 Mar 2021 08:33:01 +0000 (UTC)
Date: Tue, 30 Mar 2021 16:32:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <YGLiOQUEsWw57pKO@T590>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-9-ming.lei@redhat.com>
	<0a4829ae-a590-c058-a0ec-060eba48c102@suse.de>
MIME-Version: 1.0
In-Reply-To: <0a4829ae-a590-c058-a0ec-060eba48c102@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 08/12] block: use per-task poll context to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 30, 2021 at 08:40:22AM +0200, Hannes Reinecke wrote:
> On 3/29/21 5:26 PM, Ming Lei wrote:
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
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   block/bio.c               |   5 +
> >   block/blk-core.c          | 153 +++++++++++++++++++++++-
> >   block/blk-ioc.c           |   3 +
> >   block/blk-mq.c            | 240 +++++++++++++++++++++++++++++++++++++-
> >   block/blk.h               |  10 ++
> >   include/linux/blk_types.h |  18 ++-
> >   6 files changed, 425 insertions(+), 4 deletions(-)
> > 
> > diff --git a/block/bio.c b/block/bio.c
> > index 26b7f721cda8..04c043dc60fc 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -1402,6 +1402,11 @@ static inline bool bio_remaining_done(struct bio *bio)
> >    **/
> >   void bio_endio(struct bio *bio)
> >   {
> > +	/* BIO_END_BY_POLL has to be set before calling submit_bio */
> > +	if (bio_flagged(bio, BIO_END_BY_POLL)) {
> > +		bio_set_flag(bio, BIO_DONE);
> > +		return;
> > +	}
> >   again:
> >   	if (!bio_remaining_done(bio))
> >   		return;
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index a777ba4fe06f..939730440693 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -805,6 +805,81 @@ static inline unsigned int bio_grp_list_size(unsigned int nr_grps)
> >   		sizeof(struct bio_grp_list_data);
> >   }
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
> > +	for (i = 0; i < list->nr_grps; i++) {
> > +		grp = &list->head[i];
> > +		if (grp->grp_data == grp_data)
> > +			return i;
> > +	}
> > +
> > +	if (i < list->max_nr_grps) {
> > +		grp = &list->head[i];
> > +		bio_list_init(&grp->list);
> > +		return i;
> > +	}
> > +
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
> > +		if (bio_grp_list_grp_empty(&dst->head[j])) {
> > +			dst->head[j].grp_data = grp->grp_data;
> > +			dst->nr_grps++;
> > +		}
> > +		__bio_grp_list_merge(&dst->head[j].list, &grp->list);
> > +		bio_list_init(&grp->list);
> > +		cnt++;
> > +	}
> > +
> > +	src->nr_grps -= cnt;
> > +}
> > +
> >   static void bio_poll_ctx_init(struct blk_bio_poll_ctx *pc)
> >   {
> >   	pc->sq = (void *)pc + sizeof(*pc);
> > @@ -866,6 +941,45 @@ static inline void blk_bio_poll_preprocess(struct request_queue *q,
> >   		bio->bi_opf |= REQ_POLL_CTX;
> >   }
> > +static inline void blk_bio_poll_mark_queued(struct bio *bio, bool queued)
> > +{
> > +	/*
> > +	 * The bio has been added to per-task poll queue, mark it as
> > +	 * END_BY_POLL, so that this bio is always completed from
> > +	 * blk_poll() which is provided with cookied from this bio's
> > +	 * submission.
> > +	 */
> > +	if (!queued)
> > +		bio->bi_opf &= ~(REQ_HIPRI | REQ_POLL_CTX);
> > +	else
> > +		bio_set_flag(bio, BIO_END_BY_POLL);
> > +}
> > +
> > +static bool blk_bio_poll_prep_submit(struct io_context *ioc, struct bio *bio)
> > +{
> > +	struct blk_bio_poll_ctx *pc = ioc->data;
> > +	unsigned int queued;
> > +
> > +	/*
> > +	 * We rely on immutable .bi_end_io between blk-mq bio submission
> > +	 * and completion. However, bio crypt may update .bi_end_io during
> > +	 * submission, so simply don't support bio based polling for this
> > +	 * setting.
> > +	 */
> > +	if (likely(!bio_has_crypt_ctx(bio))) {
> > +		/* track this bio via bio group list */
> > +		spin_lock(&pc->sq_lock);
> > +		queued = bio_grp_list_add(pc->sq, bio);
> > +		blk_bio_poll_mark_queued(bio, queued);
> > +		spin_unlock(&pc->sq_lock);
> > +	} else {
> > +		queued = false;
> > +		blk_bio_poll_mark_queued(bio, false);
> > +	}
> > +
> > +	return queued;
> > +}
> > +
> >   static noinline_for_stack bool submit_bio_checks(struct bio *bio)
> >   {
> >   	struct block_device *bdev = bio->bi_bdev;
> > @@ -1024,7 +1138,7 @@ static blk_qc_t __submit_bio(struct bio *bio)
> >    * bio_list_on_stack[1] contains bios that were submitted before the current
> >    *	->submit_bio_bio, but that haven't been processed yet.
> >    */
> > -static blk_qc_t __submit_bio_noacct(struct bio *bio)
> > +static blk_qc_t __submit_bio_noacct_ctx(struct bio *bio, struct io_context *ioc)
> >   {
> >   	struct bio_list bio_list_on_stack[2];
> >   	blk_qc_t ret = BLK_QC_T_NONE;
> > @@ -1047,7 +1161,15 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >   		bio_list_on_stack[1] = bio_list_on_stack[0];
> >   		bio_list_init(&bio_list_on_stack[0]);
> > -		ret = __submit_bio(bio);
> > +		if (ioc && queue_is_mq(q) && (bio->bi_opf & REQ_HIPRI)) {
> > +			bool queued = blk_bio_poll_prep_submit(ioc, bio);
> > +
> > +			ret = __submit_bio(bio);
> > +			if (queued)
> > +				bio_set_private_data(bio, ret);
> 
> Isn't this racy?
> I was under the impression that the bio might have been completed before
> __submit_bio() returns, which would mean the call to bio_set_private_data()
> would be executed on a completed bio (and the bio won't have the private
> data set at completion time).
> Hmm?

If 'queued' is true, the bio is guaranteed to be completed via blk_poll(),
which will be called with current task's pid, so this bio shouldn't be
completed before calling bio_set_private_data(bio, ret) if both
submission and polling share same context.

However, if polling is run on another standalone context, and previous
returned 'pid' may point to the current context too, the polling task
may complete this bio before bio_set_private_data(bio, ret).

It can be fixed by adding one new cookie value of BLK_QC_T_NOT_READY,
and let blk_poll() not complete any bios which private data is
BLK_QC_T_NOT_READY.

Will fix it in next version.

> 
> 
> > +		} else {
> > +			ret = __submit_bio(bio);
> > +		}
> >   		/*
> >   		 * Sort new bios into those for a lower level and those for the
> > @@ -1073,6 +1195,33 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >   	return ret;
> >   }
> > +static inline blk_qc_t __submit_bio_noacct_poll(struct bio *bio,
> > +		struct io_context *ioc)
> > +{
> > +	struct blk_bio_poll_ctx *pc = ioc->data;
> > +
> > +	__submit_bio_noacct_ctx(bio, ioc);
> > +
> > +	/* bio submissions queued to per-task poll context */
> > +	if (READ_ONCE(pc->sq->nr_grps))
> > +		return current->pid;
> > +
> > +	/* swapper's pid is 0, but it can't submit poll IO for us */
> > +	return BLK_QC_T_BIO_NONE;
> > +}
> > +
> > +static inline blk_qc_t __submit_bio_noacct(struct bio *bio)
> > +{
> > +	struct io_context *ioc = current->io_context;
> > +
> > +	if (ioc && ioc->data && (bio->bi_opf & REQ_HIPRI))
> > + > +	return __submit_bio_noacct_poll(bio, ioc);
> > +
> > +	__submit_bio_noacct_ctx(bio, NULL);
> > +
> > +	return BLK_QC_T_BIO_NONE;
> 
> Shouldn't you return the return value from __submit_bio_noacct_ctx() here?

We return BLK_QC_T_BIO_NONE here deliberately since the bio will be
completed from underlying queue's irq handler finally, so we have to
return one invalid cookie to blk_poll().

Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

