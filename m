Return-Path: <SRS0=/8Bn=IX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07800C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 09:57:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5B91861A14
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 09:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B91861A14
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616666226;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KSBMKf3g0HpN+z+AlJ7uKVcPW5Tx38ashYm5EJnEy0Q=;
	b=Iyxbhh4U8QAJ8KEyC+HhrctyQOR8vPxU+oiuqj4KUuBzu71aADNgiCVAZzMHJmd9lWLnig
	x8dU0qivfu9uCMZMWpRGKQWFhHMB7c83R3OqngqdonIpbW2tZtE+GIkATnH/aMdlZ3iaFL
	QGjCFCgmX0S1TRP//fQKn0HFTNDHVTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-pLPRtxxOMAm41VRSpEu2sA-1; Thu, 25 Mar 2021 05:57:01 -0400
X-MC-Unique: pLPRtxxOMAm41VRSpEu2sA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54BB68189C8;
	Thu, 25 Mar 2021 09:56:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 340B3709B7;
	Thu, 25 Mar 2021 09:56:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C1A5C4BB7C;
	Thu, 25 Mar 2021 09:56:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12P9uqDk011468 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 05:56:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 739A11F7; Thu, 25 Mar 2021 09:56:52 +0000 (UTC)
Received: from T590 (ovpn-13-215.pek2.redhat.com [10.72.13.215])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4FE25D9D0;
	Thu, 25 Mar 2021 09:56:38 +0000 (UTC)
Date: Thu, 25 Mar 2021 17:56:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YFxeUeSxi43tsVPw@T590>
References: <20210324121927.362525-1-ming.lei@redhat.com>
	<20210324121927.362525-10-ming.lei@redhat.com>
	<48b34bad-ee08-7c49-a89a-1614d13cdd9a@linux.alibaba.com>
	<YFxD4BvPTNC1y63w@T590>
	<a132abc6-cdc9-cbce-f194-081beb07e229@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <a132abc6-cdc9-cbce-f194-081beb07e229@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V3 09/13] block: use per-task poll context to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 25, 2021 at 05:18:41PM +0800, JeffleXu wrote:
> 
> 
> On 3/25/21 4:05 PM, Ming Lei wrote:
> > On Thu, Mar 25, 2021 at 02:34:18PM +0800, JeffleXu wrote:
> >>
> >>
> >> On 3/24/21 8:19 PM, Ming Lei wrote:
> >>> Currently bio based IO polling needs to poll all hw queue blindly, this
> >>> way is very inefficient, and one big reason is that we can't pass any
> >>> bio submission result to blk_poll().
> >>>
> >>> In IO submission context, track associated underlying bios by per-task
> >>> submission queue and store returned 'cookie' in
> >>> bio->bi_iter.bi_private_data, and return current->pid to caller of
> >>> submit_bio() for any bio based driver's IO, which is submitted from FS.
> >>>
> >>> In IO poll context, the passed cookie tells us the PID of submission
> >>> context, then we can find bios from the per-task io pull context of
> >>> submission context. Moving bios from submission queue to poll queue of
> >>> the poll context, and keep polling until these bios are ended. Remove
> >>> bio from poll queue if the bio is ended. Add bio flags of BIO_DONE and
> >>> BIO_END_BY_POLL for such purpose.
> >>>
> >>> In was found in Jeffle Xu's test that kfifo doesn't scale well for a
> >>> submission queue as queue depth is increased, so a new mechanism for
> >>> tracking bios is needed. So far bio's size is close to 2 cacheline size,
> >>> and it may not be accepted to add new field into bio for solving the
> >>> scalability issue by tracking bios via linked list, switch to bio group
> >>> list for tracking bio, the idea is to reuse .bi_end_io for linking bios
> >>> into a linked list for all sharing same .bi_end_io(call it bio group),
> >>> which is recovered before ending bio really, since BIO_END_BY_POLL is
> >>> added for enhancing this point. Usually .bi_end_bio is same for all
> >>> bios in same layer, so it is enough to provide very limited groups, such
> >>> as 16 or less for fixing the scalability issue.
> >>>
> >>> Usually submission shares context with io poll. The per-task poll context
> >>> is just like stack variable, and it is cheap to move data between the two
> >>> per-task queues.
> >>>
> >>> Also when the submission task is exiting, drain pending IOs in the context
> >>> until all are done.
> >>>
> >>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >>> ---
> >>>  block/bio.c               |   5 +
> >>>  block/blk-core.c          | 154 ++++++++++++++++++++++++-
> >>>  block/blk-ioc.c           |   2 +
> >>>  block/blk-mq.c            | 234 +++++++++++++++++++++++++++++++++++++-
> >>>  block/blk.h               |  10 ++
> >>>  include/linux/blk_types.h |  18 ++-
> >>>  6 files changed, 419 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/block/bio.c b/block/bio.c
> >>> index 26b7f721cda8..04c043dc60fc 100644
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
> >>> index eb07d61cfdc2..95f7e36c8759 100644
> >>> --- a/block/blk-core.c
> >>> +++ b/block/blk-core.c
> >>> @@ -805,6 +805,81 @@ static inline unsigned int bio_grp_list_size(unsigned int nr_grps)
> >>>  		sizeof(struct bio_grp_list_data);
> >>>  }
> >>>  
> >>> +static inline void *bio_grp_data(struct bio *bio)
> >>> +{
> >>> +	return bio->bi_poll;
> >>> +}
> >>> +
> >>> +/* add bio into bio group list, return true if it is added */
> >>> +static bool bio_grp_list_add(struct bio_grp_list *list, struct bio *bio)
> >>> +{
> >>> +	int i;
> >>> +	struct bio_grp_list_data *grp;
> >>> +
> >>> +	for (i = 0; i < list->nr_grps; i++) {
> >>> +		grp = &list->head[i];
> >>> +		if (grp->grp_data == bio_grp_data(bio)) {
> >>> +			__bio_grp_list_add(&grp->list, bio);
> >>> +			return true;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	if (i == list->max_nr_grps)
> >>> +		return false;
> >>> +
> >>> +	/* create a new group */
> >>> +	grp = &list->head[i];
> >>> +	bio_list_init(&grp->list);
> >>> +	grp->grp_data = bio_grp_data(bio);
> >>> +	__bio_grp_list_add(&grp->list, bio);
> >>> +	list->nr_grps++;
> >>> +
> >>> +	return true;
> >>> +}
> >>> +
> >>> +static int bio_grp_list_find_grp(struct bio_grp_list *list, void *grp_data)
> >>> +{
> >>> +	int i;
> >>> +	struct bio_grp_list_data *grp;
> >>> +
> >>> +	for (i = 0; i < list->nr_grps; i++) {
> >>> +		grp = &list->head[i];
> >>> +		if (grp->grp_data == grp_data)
> >>> +			return i;
> >>> +	}
> >>> +
> >>> +	if (i < list->max_nr_grps) {
> >>> +		grp = &list->head[i];
> >>> +		bio_list_init(&grp->list);
> >>> +		return i;
> >>> +	}
> >>> +
> >>> +	return -1;
> >>> +}
> >>> +
> >>> +/* Move as many as possible groups from 'src' to 'dst' */
> >>> +void bio_grp_list_move(struct bio_grp_list *dst, struct bio_grp_list *src)
> >>> +{
> >>> +	int i, j, cnt = 0;
> >>> +	struct bio_grp_list_data *grp;
> >>> +
> >>> +	for (i = src->nr_grps - 1; i >= 0; i--) {
> >>> +		grp = &src->head[i];
> >>> +		j = bio_grp_list_find_grp(dst, grp->grp_data);
> >>> +		if (j < 0)
> >>> +			break;
> >>> +		if (bio_grp_list_grp_empty(&dst->head[j])) {
> >>> +			dst->head[j].grp_data = grp->grp_data;
> >>> +			dst->nr_grps++;
> >>> +		}
> >>> +		__bio_grp_list_merge(&dst->head[j].list, &grp->list);
> >>> +		bio_list_init(&grp->list);
> >>> +		cnt++;
> >>> +	}
> >>> +
> >>> +	src->nr_grps -= cnt;
> >>> +}
> >>> +
> >>>  static void bio_poll_ctx_init(struct blk_bio_poll_ctx *pc)
> >>>  {
> >>>  	pc->sq = (void *)pc + sizeof(*pc);
> >>> @@ -866,6 +941,45 @@ static inline void blk_bio_poll_preprocess(struct request_queue *q,
> >>>  		bio->bi_opf |= REQ_POLL_CTX;
> >>>  }
> >>>  
> >>> +static inline void blk_bio_poll_mark_queued(struct bio *bio, bool queued)
> >>> +{
> >>> +	/*
> >>> +	 * The bio has been added to per-task poll queue, mark it as
> >>> +	 * END_BY_POLL, so that this bio is always completed from
> >>> +	 * blk_poll() which is provided with cookied from this bio's
> >>> +	 * submission.
> >>> +	 */
> >>> +	if (!queued)
> >>> +		bio->bi_opf &= ~(REQ_HIPRI | REQ_POLL_CTX);
> >>> +	else
> >>> +		bio_set_flag(bio, BIO_END_BY_POLL);
> >>> +}
> >>> +
> >>> +static bool blk_bio_poll_prep_submit(struct io_context *ioc, struct bio *bio)
> >>> +{
> >>> +	struct blk_bio_poll_ctx *pc = ioc->data;
> >>> +	unsigned int queued;
> >>> +
> >>> +	/*
> >>> +	 * We rely on immutable .bi_end_io between blk-mq bio submission
> >>> +	 * and completion. However, bio crypt may update .bi_end_io during
> >>> +	 * submission, so simply don't support bio based polling for this
> >>> +	 * setting.
> >>> +	 */
> >>> +	if (likely(!bio_has_crypt_ctx(bio))) {
> >>> +		/* track this bio via bio group list */
> >>> +		spin_lock(&pc->sq_lock);
> >>> +		queued = bio_grp_list_add(pc->sq, bio);
> >>> +		blk_bio_poll_mark_queued(bio, queued);
> >>> +		spin_unlock(&pc->sq_lock);
> >>> +	} else {
> >>> +		queued = false;
> >>> +		blk_bio_poll_mark_queued(bio, false);
> >>> +	}
> >>> +
> >>> +	return queued;
> >>> +}
> >>> +
> >>>  static noinline_for_stack bool submit_bio_checks(struct bio *bio)
> >>>  {
> >>>  	struct block_device *bdev = bio->bi_bdev;
> >>> @@ -1018,7 +1132,7 @@ static blk_qc_t __submit_bio(struct bio *bio)
> >>>   * bio_list_on_stack[1] contains bios that were submitted before the current
> >>>   *	->submit_bio_bio, but that haven't been processed yet.
> >>>   */
> >>> -static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >>> +static blk_qc_t __submit_bio_noacct_ctx(struct bio *bio, struct io_context *ioc)
> >>>  {
> >>>  	struct bio_list bio_list_on_stack[2];
> >>>  	blk_qc_t ret = BLK_QC_T_NONE;
> >>> @@ -1041,7 +1155,16 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >>>  		bio_list_on_stack[1] = bio_list_on_stack[0];
> >>>  		bio_list_init(&bio_list_on_stack[0]);
> >>>  
> >>> -		ret = __submit_bio(bio);
> >>> +		if (ioc && queue_is_mq(q) &&
> >>> +				(bio->bi_opf & (REQ_HIPRI | REQ_POLL_CTX))) {
> >>
> >>
> >> I can see no sense to enqueue the bio into the context->sq when
> >> REQ_HIPRI is cleared while REQ_POLL_CTX is set for the bio.
> >> BLK_QC_T_NONE is returned in this case. This is possible since commit
> >> cc29e1bf0d63 ("block: disable iopoll for split bio").
> > 
> > bio has to be enqueued before submission, and once it is enqueued, it has
> > to be ended by blk_poll(), this way actually simplifies polled bio lifetime
> > a lot, no matter if this bio is really completed via poll or irq.
> > 
> > When submit_bio() is returning BLK_QC_T_NONE, this bio may have been
> > completed already, and we shouldn't touch that bio any more, otherwise
> > things can become quite complicated.
> 
> I mean if the following is adequate?
> 
> if (ioc && queue_is_mq(q) &&(bio->bi_opf & REQ_HIPRI)) {
>     queued = blk_bio_poll_prep_submit(ioc, bio);
>     ret = __submit_bio(bio);
>     if (queued)
>         bio_set_private_data(bio, ret);
> }
> 
> 
> Only REQ_HIPRI is checked here, thus bios with REQ_POLL_CTX but without
> REQ_HIPRI needn't be enqueued into poll_context->sq.
> 
> For the original bio (with REQ_HIPRI | REQ_POLL_CTX), it's enqueued into
> poll_context->sq, while the following split bios (only with
> REQ_POLL_CTX, REQ_POLL_CTX is cleared by commit cc29e1bf0d63 ("block:
> disable iopoll for split bio")) needn't be enqueued into
> poll_context->sq. Since these bios (only with REQ_POLL_CTX) are not
> enqueued, you won't touch them anymore and you needn't care their lifetime.
> 
> Your original code works, and my optimization here could make the code
> be more clear and faster. However I'm not sure the effect of the
> optimization, since the scenario of commit cc29e1bf0d63 ("block: disable
> iopoll for split bio") should be rare.

OK, got it, and it should be fine to just check REQ_HIPRI here. But as
you mentioned, it should be rare, even though not, the cost is small
too.

If it isn't rare, one solution is to extend current bio based polling
for split bios.

> 
> 
> > 
> >>
> >>
> >>> +			bool queued = blk_bio_poll_prep_submit(ioc, bio);
> >>> +
> >>> +			ret = __submit_bio(bio);
> >>> +			if (queued)
> >>> +				bio_set_private_data(bio, ret);
> >>> +		} else {
> >>> +			ret = __submit_bio(bio);
> >>> +		}
> >>>  
> >>>  		/*
> >>>  		 * Sort new bios into those for a lower level and those for the
> >>> @@ -1067,6 +1190,33 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >>>  	return ret;
> >>>  }
> >>>  
> >>> +static inline blk_qc_t __submit_bio_noacct_poll(struct bio *bio,
> >>> +		struct io_context *ioc)
> >>> +{
> >>> +	struct blk_bio_poll_ctx *pc = ioc->data;
> >>> +
> >>> +	__submit_bio_noacct_ctx(bio, ioc);
> >>> +
> >>> +	/* bio submissions queued to per-task poll context */
> >>> +	if (READ_ONCE(pc->sq->nr_grps))
> >>> +		return current->pid;
> >>> +
> >>> +	/* swapper's pid is 0, but it can't submit poll IO for us */
> >>> +	return BLK_QC_T_BIO_NONE;
> >>> +}
> >>> +
> >>> +static inline blk_qc_t __submit_bio_noacct(struct bio *bio)
> >>> +{
> >>> +	struct io_context *ioc = current->io_context;
> >>> +
> >>> +	if (ioc && ioc->data && (bio->bi_opf & REQ_HIPRI))
> >>> +		return __submit_bio_noacct_poll(bio, ioc);
> >>> +
> >>> +	__submit_bio_noacct_ctx(bio, NULL);
> >>> +
> >>> +	return BLK_QC_T_BIO_NONE;
> >>> +}
> >>> +
> >>>  static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
> >>>  {
> >>>  	struct bio_list bio_list[2] = { };
> >>> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> >>> index 5574c398eff6..b9a512f066f8 100644
> >>> --- a/block/blk-ioc.c
> >>> +++ b/block/blk-ioc.c
> >>> @@ -19,6 +19,8 @@ static struct kmem_cache *iocontext_cachep;
> >>>  
> >>>  static inline void free_io_context(struct io_context *ioc)
> >>>  {
> >>> +	blk_bio_poll_io_drain(ioc);
> >>> +
> >>
> >> There may be a time window between the IO submission process detaches
> >> the io_context and the io_context's refcount finally decreased to zero,
> >> when there'are multiple processes sharing one io_context. I don't know
> >> if it is possible that the other process sharing the io_context won't
> >> submit any IO, in which case the bios remained in the io_context won't
> >> be reaped for a long time.
> >>
> >> If the above case is possible, then is it possible to drain the sq once
> >> the process detaches the io_context?
> > 
> > free_io_context() is called after the ioc's refcount drops to zero, so
> > any process sharing this ioc has to be exited.
> 
> Just like what I said, when the process, to which the returned cookie
> refers, has exited, while the corresponding io_context exist there for a
> long time (since it's shared by other processes and thus the refcount is
> greater than zero), the bios in io_context->sq have no chance be reaped,
> if the following two conditions are required at the same time
> 
> 1) the process, to which the returned cookie refers, has exited
> 2) the io_context is shared by other processes, while these processes
> dont's submit HIPRI IO, thus blk_poll() won't be called for this io_context.
> 
> Though the case may be rare.

OK, looks we can deal with that by simply calling blk_bio_poll_io_drain()
at the entry of exit_io_context()


Thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

