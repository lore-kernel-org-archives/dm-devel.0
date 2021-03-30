Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3333FC433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:22:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61D2A61983
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61D2A61983
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-5mmNcXhvMqORyXS9MO-zUw-1; Tue, 30 Mar 2021 04:22:42 -0400
X-MC-Unique: 5mmNcXhvMqORyXS9MO-zUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A67F1922025;
	Tue, 30 Mar 2021 08:22:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3A816A904;
	Tue, 30 Mar 2021 08:22:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F0C751809C83;
	Tue, 30 Mar 2021 08:22:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U3qU3s024302 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 23:52:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 37B022026D60; Tue, 30 Mar 2021 03:52:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3217F2026D64
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 03:52:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AB78101A52C
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 03:52:25 +0000 (UTC)
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-571-Hribux-aP-WEadgxbos3kw-1;
	Mon, 29 Mar 2021 23:52:19 -0400
X-MC-Unique: Hribux-aP-WEadgxbos3kw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UTonS2y_1617076333
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UTonS2y_1617076333) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 30 Mar 2021 11:52:14 +0800
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-9-ming.lei@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <407e4f92-3bac-8c4f-5b94-cc3803912119@linux.alibaba.com>
Date: Tue, 30 Mar 2021 11:52:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329152622.173035-9-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 30 Mar 2021 04:22:10 -0400
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/29/21 11:26 PM, Ming Lei wrote:
> Currently bio based IO polling needs to poll all hw queue blindly, this
> way is very inefficient, and one big reason is that we can't pass any
> bio submission result to blk_poll().
> 
> In IO submission context, track associated underlying bios by per-task
> submission queue and store returned 'cookie' in
> bio->bi_iter.bi_private_data, and return current->pid to caller of
> submit_bio() for any bio based driver's IO, which is submitted from FS.
> 
> In IO poll context, the passed cookie tells us the PID of submission
> context, then we can find bios from the per-task io pull context of
> submission context. Moving bios from submission queue to poll queue of
> the poll context, and keep polling until these bios are ended. Remove
> bio from poll queue if the bio is ended. Add bio flags of BIO_DONE and
> BIO_END_BY_POLL for such purpose.
> 
> In was found in Jeffle Xu's test that kfifo doesn't scale well for a
> submission queue as queue depth is increased, so a new mechanism for
> tracking bios is needed. So far bio's size is close to 2 cacheline size,
> and it may not be accepted to add new field into bio for solving the
> scalability issue by tracking bios via linked list, switch to bio group
> list for tracking bio, the idea is to reuse .bi_end_io for linking bios
> into a linked list for all sharing same .bi_end_io(call it bio group),
> which is recovered before ending bio really, since BIO_END_BY_POLL is
> added for enhancing this point. Usually .bi_end_bio is same for all
> bios in same layer, so it is enough to provide very limited groups, such
> as 16 or less for fixing the scalability issue.
> 
> Usually submission shares context with io poll. The per-task poll context
> is just like stack variable, and it is cheap to move data between the two
> per-task queues.
> 
> Also when the submission task is exiting, drain pending IOs in the context
> until all are done.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>


Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>


FYI Following is the performance test results:

3-threads dm-linear-3-targets (4k randread IOPS, iopoll=1, iodepth=128,
unit K)
5.12-rc1: 652
this patchset: 639 ->835, ~30%


3-threads dm-stripe-3-targets (stripe=4k) (12k randread IOPS, iopoll=1,
iodepth=128, unit K)
5.12-rc1: 321
lieming-new: 314 -> 408, ~30%


> ---
>  block/bio.c               |   5 +
>  block/blk-core.c          | 153 +++++++++++++++++++++++-
>  block/blk-ioc.c           |   3 +
>  block/blk-mq.c            | 240 +++++++++++++++++++++++++++++++++++++-
>  block/blk.h               |  10 ++
>  include/linux/blk_types.h |  18 ++-
>  6 files changed, 425 insertions(+), 4 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 26b7f721cda8..04c043dc60fc 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1402,6 +1402,11 @@ static inline bool bio_remaining_done(struct bio *bio)
>   **/
>  void bio_endio(struct bio *bio)
>  {
> +	/* BIO_END_BY_POLL has to be set before calling submit_bio */
> +	if (bio_flagged(bio, BIO_END_BY_POLL)) {
> +		bio_set_flag(bio, BIO_DONE);
> +		return;
> +	}
>  again:
>  	if (!bio_remaining_done(bio))
>  		return;
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a777ba4fe06f..939730440693 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -805,6 +805,81 @@ static inline unsigned int bio_grp_list_size(unsigned int nr_grps)
>  		sizeof(struct bio_grp_list_data);
>  }
>  
> +static inline void *bio_grp_data(struct bio *bio)
> +{
> +	return bio->bi_poll;
> +}
> +
> +/* add bio into bio group list, return true if it is added */
> +static bool bio_grp_list_add(struct bio_grp_list *list, struct bio *bio)
> +{
> +	int i;
> +	struct bio_grp_list_data *grp;
> +
> +	for (i = 0; i < list->nr_grps; i++) {
> +		grp = &list->head[i];
> +		if (grp->grp_data == bio_grp_data(bio)) {
> +			__bio_grp_list_add(&grp->list, bio);
> +			return true;
> +		}
> +	}
> +
> +	if (i == list->max_nr_grps)
> +		return false;
> +
> +	/* create a new group */
> +	grp = &list->head[i];
> +	bio_list_init(&grp->list);
> +	grp->grp_data = bio_grp_data(bio);
> +	__bio_grp_list_add(&grp->list, bio);
> +	list->nr_grps++;
> +
> +	return true;
> +}
> +
> +static int bio_grp_list_find_grp(struct bio_grp_list *list, void *grp_data)
> +{
> +	int i;
> +	struct bio_grp_list_data *grp;
> +
> +	for (i = 0; i < list->nr_grps; i++) {
> +		grp = &list->head[i];
> +		if (grp->grp_data == grp_data)
> +			return i;
> +	}
> +
> +	if (i < list->max_nr_grps) {
> +		grp = &list->head[i];
> +		bio_list_init(&grp->list);
> +		return i;
> +	}
> +
> +	return -1;
> +}
> +
> +/* Move as many as possible groups from 'src' to 'dst' */
> +void bio_grp_list_move(struct bio_grp_list *dst, struct bio_grp_list *src)
> +{
> +	int i, j, cnt = 0;
> +	struct bio_grp_list_data *grp;
> +
> +	for (i = src->nr_grps - 1; i >= 0; i--) {
> +		grp = &src->head[i];
> +		j = bio_grp_list_find_grp(dst, grp->grp_data);
> +		if (j < 0)
> +			break;
> +		if (bio_grp_list_grp_empty(&dst->head[j])) {
> +			dst->head[j].grp_data = grp->grp_data;
> +			dst->nr_grps++;
> +		}
> +		__bio_grp_list_merge(&dst->head[j].list, &grp->list);
> +		bio_list_init(&grp->list);
> +		cnt++;
> +	}
> +
> +	src->nr_grps -= cnt;
> +}
> +
>  static void bio_poll_ctx_init(struct blk_bio_poll_ctx *pc)
>  {
>  	pc->sq = (void *)pc + sizeof(*pc);
> @@ -866,6 +941,45 @@ static inline void blk_bio_poll_preprocess(struct request_queue *q,
>  		bio->bi_opf |= REQ_POLL_CTX;
>  }
>  
> +static inline void blk_bio_poll_mark_queued(struct bio *bio, bool queued)
> +{
> +	/*
> +	 * The bio has been added to per-task poll queue, mark it as
> +	 * END_BY_POLL, so that this bio is always completed from
> +	 * blk_poll() which is provided with cookied from this bio's
> +	 * submission.
> +	 */
> +	if (!queued)
> +		bio->bi_opf &= ~(REQ_HIPRI | REQ_POLL_CTX);
> +	else
> +		bio_set_flag(bio, BIO_END_BY_POLL);
> +}
> +
> +static bool blk_bio_poll_prep_submit(struct io_context *ioc, struct bio *bio)
> +{
> +	struct blk_bio_poll_ctx *pc = ioc->data;
> +	unsigned int queued;
> +
> +	/*
> +	 * We rely on immutable .bi_end_io between blk-mq bio submission
> +	 * and completion. However, bio crypt may update .bi_end_io during
> +	 * submission, so simply don't support bio based polling for this
> +	 * setting.
> +	 */
> +	if (likely(!bio_has_crypt_ctx(bio))) {
> +		/* track this bio via bio group list */
> +		spin_lock(&pc->sq_lock);
> +		queued = bio_grp_list_add(pc->sq, bio);
> +		blk_bio_poll_mark_queued(bio, queued);
> +		spin_unlock(&pc->sq_lock);
> +	} else {
> +		queued = false;
> +		blk_bio_poll_mark_queued(bio, false);
> +	}
> +
> +	return queued;
> +}
> +
>  static noinline_for_stack bool submit_bio_checks(struct bio *bio)
>  {
>  	struct block_device *bdev = bio->bi_bdev;
> @@ -1024,7 +1138,7 @@ static blk_qc_t __submit_bio(struct bio *bio)
>   * bio_list_on_stack[1] contains bios that were submitted before the current
>   *	->submit_bio_bio, but that haven't been processed yet.
>   */
> -static blk_qc_t __submit_bio_noacct(struct bio *bio)
> +static blk_qc_t __submit_bio_noacct_ctx(struct bio *bio, struct io_context *ioc)
>  {
>  	struct bio_list bio_list_on_stack[2];
>  	blk_qc_t ret = BLK_QC_T_NONE;
> @@ -1047,7 +1161,15 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>  		bio_list_init(&bio_list_on_stack[0]);
>  
> -		ret = __submit_bio(bio);
> +		if (ioc && queue_is_mq(q) && (bio->bi_opf & REQ_HIPRI)) {
> +			bool queued = blk_bio_poll_prep_submit(ioc, bio);
> +
> +			ret = __submit_bio(bio);
> +			if (queued)
> +				bio_set_private_data(bio, ret);
> +		} else {
> +			ret = __submit_bio(bio);
> +		}
>  
>  		/*
>  		 * Sort new bios into those for a lower level and those for the
> @@ -1073,6 +1195,33 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  	return ret;
>  }
>  
> +static inline blk_qc_t __submit_bio_noacct_poll(struct bio *bio,
> +		struct io_context *ioc)
> +{
> +	struct blk_bio_poll_ctx *pc = ioc->data;
> +
> +	__submit_bio_noacct_ctx(bio, ioc);
> +
> +	/* bio submissions queued to per-task poll context */
> +	if (READ_ONCE(pc->sq->nr_grps))
> +		return current->pid;
> +
> +	/* swapper's pid is 0, but it can't submit poll IO for us */
> +	return BLK_QC_T_BIO_NONE;
> +}
> +
> +static inline blk_qc_t __submit_bio_noacct(struct bio *bio)
> +{
> +	struct io_context *ioc = current->io_context;
> +
> +	if (ioc && ioc->data && (bio->bi_opf & REQ_HIPRI))
> +		return __submit_bio_noacct_poll(bio, ioc);
> +
> +	__submit_bio_noacct_ctx(bio, NULL);
> +
> +	return BLK_QC_T_BIO_NONE;
> +}
> +
>  static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
>  {
>  	struct bio_list bio_list[2] = { };
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 5574c398eff6..c1fd7c593a54 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -211,6 +211,9 @@ void exit_io_context(struct task_struct *task)
>  	task->io_context = NULL;
>  	task_unlock(task);
>  
> +	/* drain io poll submissions */
> +	blk_bio_poll_io_drain(ioc);
> +
>  	atomic_dec(&ioc->nr_tasks);
>  	put_io_context_active(ioc);
>  }
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0cb88c719916..b65f2c170fb0 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3865,14 +3865,252 @@ static inline int blk_mq_poll_hctx(struct request_queue *q,
>  	return ret;
>  }
>  
> +static int blk_mq_poll_io(struct bio *bio)
> +{
> +	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> +	blk_qc_t cookie = bio_get_private_data(bio);
> +	int ret = 0;
> +
> +	if (!bio_flagged(bio, BIO_DONE) && blk_qc_t_valid(cookie)) {
> +		struct blk_mq_hw_ctx *hctx =
> +			q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> +
> +		ret += blk_mq_poll_hctx(q, hctx);
> +	}
> +	return ret;
> +}
> +
> +static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
> +{
> +	int ret = 0;
> +	int i;
> +
> +	/*
> +	 * Poll hw queue first.
> +	 *
> +	 * TODO: limit max poll times and make sure to not poll same
> +	 * hw queue one more time.
> +	 */
> +	for (i = 0; i < grps->nr_grps; i++) {
> +		struct bio_grp_list_data *grp = &grps->head[i];
> +		struct bio *bio;
> +
> +		if (bio_grp_list_grp_empty(grp))
> +			continue;
> +
> +		for (bio = grp->list.head; bio; bio = bio->bi_poll)
> +			ret += blk_mq_poll_io(bio);
> +	}
> +
> +	/* reap bios */
> +	for (i = 0; i < grps->nr_grps; i++) {
> +		struct bio_grp_list_data *grp = &grps->head[i];
> +		struct bio *bio;
> +		struct bio_list bl;
> +
> +		if (bio_grp_list_grp_empty(grp))
> +			continue;
> +
> +		bio_list_init(&bl);
> +
> +		while ((bio = __bio_grp_list_pop(&grp->list))) {
> +			if (bio_flagged(bio, BIO_DONE)) {
> +				/* now recover original data */
> +				bio->bi_poll = grp->grp_data;
> +
> +				/* clear BIO_END_BY_POLL and end me really */
> +				bio_clear_flag(bio, BIO_END_BY_POLL);
> +				bio_endio(bio);
> +			} else {
> +				__bio_grp_list_add(&bl, bio);
> +			}
> +		}
> +		__bio_grp_list_merge(&grp->list, &bl);
> +	}
> +	return ret;
> +}
> +
> +static void blk_bio_poll_pack_groups(struct bio_grp_list *grps)
> +{
> +	int i, j, k = 0;
> +	int cnt = 0;
> +
> +	for (i = grps->nr_grps - 1; i >= 0; i--) {
> +		struct bio_grp_list_data *grp = &grps->head[i];
> +		struct bio_grp_list_data *hole = NULL;
> +
> +		if (bio_grp_list_grp_empty(grp)) {
> +			cnt++;
> +			continue;
> +		}
> +
> +		for (j = k; j < i; j++) {
> +			if (bio_grp_list_grp_empty(&grps->head[j])) {
> +				hole = &grps->head[j];
> +				break;
> +			}
> +		}
> +		if (hole == NULL)
> +			break;
> +		*hole = *grp;
> +		cnt++;
> +		k = j;
> +	}
> +
> +	grps->nr_grps -= cnt;
> +}
> +
> +#define  MAX_BIO_GRPS_ON_STACK  8
> +struct bio_grp_list_stack {
> +	unsigned int max_nr_grps, nr_grps;
> +	struct bio_grp_list_data head[MAX_BIO_GRPS_ON_STACK];
> +};
> +
> +static int blk_bio_poll_io(struct io_context *submit_ioc,
> +		struct io_context *poll_ioc)
> +
> +{
> +	struct bio_grp_list_stack _bio_grps = {
> +		.max_nr_grps	= ARRAY_SIZE(_bio_grps.head),
> +		.nr_grps	= 0
> +	};
> +	struct bio_grp_list *bio_grps = (struct bio_grp_list *)&_bio_grps;
> +	struct blk_bio_poll_ctx *submit_ctx = submit_ioc->data;
> +	struct blk_bio_poll_ctx *poll_ctx = poll_ioc ?
> +		poll_ioc->data : NULL;
> +	int ret = 0;
> +
> +	/*
> +	 * Move IO submission result from submission queue in submission
> +	 * context to poll queue of poll context.
> +	 */
> +	if (READ_ONCE(submit_ctx->sq->nr_grps) > 0) {
> +		spin_lock(&submit_ctx->sq_lock);
> +		bio_grp_list_move(bio_grps, submit_ctx->sq);
> +		spin_unlock(&submit_ctx->sq_lock);
> +	}
> +
> +	/* merge new bios first, then start to poll bios from pq */
> +	if (poll_ctx) {
> +		spin_lock(&poll_ctx->pq_lock);
> +		bio_grp_list_move(poll_ctx->pq, bio_grps);
> +		bio_grp_list_move(bio_grps, poll_ctx->pq);
> +		spin_unlock(&poll_ctx->pq_lock);
> +	}
> +
> +	do {
> +		ret += blk_bio_poll_and_end_io(bio_grps);
> +		blk_bio_poll_pack_groups(bio_grps);
> +
> +		if (bio_grps->nr_grps) {
> +			/*
> +			 * move back, and keep polling until all can be
> +			 * held in either poll queue or submission queue.
> +			 */
> +			if (poll_ctx) {
> +				spin_lock(&poll_ctx->pq_lock);
> +				bio_grp_list_move(poll_ctx->pq, bio_grps);
> +				spin_unlock(&poll_ctx->pq_lock);
> +			} else {
> +				spin_lock(&submit_ctx->sq_lock);
> +				bio_grp_list_move(submit_ctx->sq, bio_grps);
> +				spin_unlock(&submit_ctx->sq_lock);
> +			}
> +		}
> +	} while (bio_grps->nr_grps > 0);
> +
> +	return ret;
> +}
> +
> +void blk_bio_poll_io_drain(struct io_context *submit_ioc)
> +{
> +	struct blk_bio_poll_ctx *submit_ctx = submit_ioc->data;
> +
> +	if (!submit_ctx)
> +		return;
> +
> +	spin_lock(&submit_ctx->sq_lock);
> +	while (READ_ONCE(submit_ctx->sq->nr_grps) > 0) {
> +		blk_bio_poll_and_end_io(submit_ctx->sq);
> +		blk_bio_poll_pack_groups(submit_ctx->sq);
> +		cpu_relax();
> +	}
> +	spin_unlock(&submit_ctx->sq_lock);
> +}
> +
> +static bool blk_bio_ioc_valid(struct task_struct *t)
> +{
> +	if (!t)
> +		return false;
> +
> +	if (!t->io_context)
> +		return false;
> +
> +	if (!t->io_context->data)
> +		return false;
> +
> +	return true;
> +}
> +
> +static int __blk_bio_poll(blk_qc_t cookie)
> +{
> +	struct io_context *poll_ioc = current->io_context;
> +	pid_t pid;
> +	struct task_struct *submit_task;
> +	int ret;
> +
> +	pid = (pid_t)cookie;
> +
> +	/* io poll often share io submission context */
> +	if (likely(current->pid == pid && blk_bio_ioc_valid(current)))
> +		return blk_bio_poll_io(poll_ioc, poll_ioc);
> +
> +	submit_task = find_get_task_by_vpid(pid);
> +	if (likely(blk_bio_ioc_valid(submit_task)))
> +		ret = blk_bio_poll_io(submit_task->io_context, poll_ioc);
> +	else
> +		ret = 0;
> +	if (likely(submit_task))
> +		put_task_struct(submit_task);
> +
> +	return ret;
> +}
> +
>  static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  {
> +	long state;
> +
> +	/* no need to poll */
> +	if (cookie == BLK_QC_T_BIO_NONE)
> +		return 0;
> +
>  	/*
>  	 * Create poll queue for storing poll bio and its cookie from
>  	 * submission queue
>  	 */
>  	blk_create_io_poll_context(q);
>  
> +	state = current->state;
> +	do {
> +		int ret;
> +
> +		ret = __blk_bio_poll(cookie);
> +		if (ret > 0) {
> +			__set_current_state(TASK_RUNNING);
> +			return ret;
> +		}
> +
> +		if (signal_pending_state(state, current))
> +			__set_current_state(TASK_RUNNING);
> +
> +		if (current->state == TASK_RUNNING)
> +			return 1;
> +		if (ret < 0 || !spin)
> +			break;
> +		cpu_relax();
> +	} while (!need_resched());
> +
> +	__set_current_state(TASK_RUNNING);
>  	return 0;
>  }
>  
> @@ -3893,7 +4131,7 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  	struct blk_mq_hw_ctx *hctx;
>  	long state;
>  
> -	if (!blk_qc_t_valid(cookie) || !blk_queue_poll(q))
> +	if (!blk_queue_poll(q) || (queue_is_mq(q) && !blk_qc_t_valid(cookie)))
>  		return 0;
>  
>  	if (current->plug)
> diff --git a/block/blk.h b/block/blk.h
> index c1d8456656df..c0216f2e6293 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -381,6 +381,7 @@ struct blk_bio_poll_ctx {
>  #define BLK_BIO_POLL_SQ_SZ		16U
>  #define BLK_BIO_POLL_PQ_SZ		(BLK_BIO_POLL_SQ_SZ * 2)
>  
> +void blk_bio_poll_io_drain(struct io_context *submit_ioc);
>  void bio_poll_ctx_alloc(struct io_context *ioc);
>  
>  static inline void blk_create_io_poll_context(struct request_queue *q)
> @@ -405,4 +406,13 @@ static inline void bio_set_private_data(struct bio *bio, unsigned int data)
>  	bio->bi_iter.bi_private_data = data;
>  }
>  
> +BIO_LIST_HELPERS(__bio_grp_list, poll);
> +
> +static inline bool bio_grp_list_grp_empty(struct bio_grp_list_data *grp)
> +{
> +	return bio_list_empty(&grp->list);
> +}
> +
> +void bio_grp_list_move(struct bio_grp_list *dst, struct bio_grp_list *src);
> +
>  #endif /* BLK_INTERNAL_H */
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 99160d588c2d..beaeb3729f11 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -235,7 +235,18 @@ struct bio {
>  
>  	struct bvec_iter	bi_iter;
>  
> -	bio_end_io_t		*bi_end_io;
> +	union {
> +		bio_end_io_t		*bi_end_io;
> +		/*
> +		 * bio based io polling needs to track bio via bio group
> +		 * list which groups bios by their .bi_end_io, and original
> +		 * .bi_end_io is saved into the group head. Will recover
> +		 * .bi_end_io before really ending bio. BIO_END_BY_POLL
> +		 * will make sure that this bio won't be ended before
> +		 * recovering .bi_end_io.
> +		 */
> +		struct bio		*bi_poll;
> +	};
>  
>  	void			*bi_private;
>  #ifdef CONFIG_BLK_CGROUP
> @@ -304,6 +315,9 @@ enum {
>  	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
>  	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
>  	BIO_REMAPPED,
> +	BIO_END_BY_POLL,	/* end by blk_bio_poll() explicitly */
> +	/* set when bio can be ended, used for bio with BIO_END_BY_POLL */
> +	BIO_DONE,
>  	BIO_FLAG_LAST
>  };
>  
> @@ -513,6 +527,8 @@ typedef unsigned int blk_qc_t;
>  #define BLK_QC_T_NONE		-1U
>  #define BLK_QC_T_SHIFT		16
>  #define BLK_QC_T_INTERNAL	(1U << 31)
> +/* only used for bio based submission, has to be defined as 0 */
> +#define BLK_QC_T_BIO_NONE	0
>  
>  static inline bool blk_qc_t_valid(blk_qc_t cookie)
>  {
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

