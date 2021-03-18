Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1100C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 17:38:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 45D1964F24
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 17:38:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45D1964F24
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-0JGqE_sCOImU2NV7SdjEgw-1; Thu, 18 Mar 2021 13:38:28 -0400
X-MC-Unique: 0JGqE_sCOImU2NV7SdjEgw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D41C9801817;
	Thu, 18 Mar 2021 17:38:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DBD45C239;
	Thu, 18 Mar 2021 17:38:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A9191809C83;
	Thu, 18 Mar 2021 17:38:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12IHcJpt010508 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 13:38:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B5F952026D6A; Thu, 18 Mar 2021 17:38:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B069B2026D64
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 17:38:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD9C0800883
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 17:38:16 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
	[209.85.214.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-55-Y_mhrcDnNjWaRESKhP2UvQ-1; Thu, 18 Mar 2021 13:38:14 -0400
X-MC-Unique: Y_mhrcDnNjWaRESKhP2UvQ-1
Received: by mail-pl1-f171.google.com with SMTP id w11so1658686ply.6;
	Thu, 18 Mar 2021 10:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=68E1cDZixPgMLY4FrQ5EaomLpW3X7x8IB0bvEiCoHvs=;
	b=k8kzhsdwOfJXYeQtRheH3D35XfVDqtY8xxhj58tan1saGWoMXBffmSCnYr/scitPIB
	gio3ZfTC994hlQ0htjMXX5WAi6E20Gyfzu70w1XEOo4zwAgwoB+r1scshRDPwK4Gn+Ow
	4V9ffzA/2WsWO2iXVR3ce4A5IL6AoF4mvRz8SWSguKfu2QNVu5OaMIFU5xPfwzhv5+IL
	tQdWgA1+t/ktNLJYAc3AFGxnwZVB0t+61O+2uBiNOIx0KCQdSmHgD9yvKNZN4ISvhBWU
	Krr6aYc2TiYpiQZc/LzH7KUG1fwjNLjyrPIUbWwTMUoMZH0IOJXTXQKw0zChMEwsmiRJ
	qI5g==
X-Gm-Message-State: AOAM533gRPabXScmFYdeZoY0v+DcdvzTciiSeynQwS60OG1x3SudQrF2
	doPRMpxQ1JbNExNm3JYMCwGinw6wKCxxJ50XOkdW4nv7kamOqA==
X-Google-Smtp-Source: ABdhPJwm3zn3lrbX6RZ7o+mQNtwjI0dtEX6fJeVOtnK8ErdP6Ls3g8dUm0KqRP7qdmfJJALmC4/ENE5fhpPivzyRumg=
X-Received: by 2002:a17:90b:b0d:: with SMTP id
	bf13mr5465381pjb.7.1616089092711; 
	Thu, 18 Mar 2021 10:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-10-ming.lei@redhat.com>
	<20210318172622.GA3871@redhat.com>
In-Reply-To: <20210318172622.GA3871@redhat.com>
From: Mike Snitzer <snitzer@gmail.com>
Date: Thu, 18 Mar 2021 13:38:01 -0400
Message-ID: <CAMM=eLf628ua2oq1rB+3dV9sPW0qyiwJKVsO2PqbUWTC7jSXVw@mail.gmail.com>
To: Ming Lei <ming.lei@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 18, 2021 at 1:26 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
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
> > +     /* BIO_END_BY_POLL has to be set before calling submit_bio */
> > +     if (bio_flagged(bio, BIO_END_BY_POLL)) {
> > +             bio_set_flag(bio, BIO_DONE);
> > +             return;
> > +     }
> >  again:
> >       if (!bio_remaining_done(bio))
> >               return;
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index efc7a61a84b4..778d25a7e76c 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -805,6 +805,77 @@ static inline unsigned int bio_grp_list_size(unsigned int nr_grps)
> >               sizeof(struct bio_grp_list_data);
> >  }
> >
> > +static inline void *bio_grp_data(struct bio *bio)
> > +{
> > +     return bio->bi_poll;
> > +}
> > +
> > +/* add bio into bio group list, return true if it is added */
> > +static bool bio_grp_list_add(struct bio_grp_list *list, struct bio *bio)
> > +{
> > +     int i;
> > +     struct bio_grp_list_data *grp;
> > +
> > +     for (i = 0; i < list->nr_grps; i++) {
> > +             grp = &list->head[i];
> > +             if (grp->grp_data == bio_grp_data(bio)) {
> > +                     __bio_grp_list_add(&grp->list, bio);
> > +                     return true;
> > +             }
> > +     }
> > +
> > +     if (i == list->max_nr_grps)
> > +             return false;
> > +
> > +     /* create a new group */
> > +     grp = &list->head[i];
> > +     bio_list_init(&grp->list);
> > +     grp->grp_data = bio_grp_data(bio);
> > +     __bio_grp_list_add(&grp->list, bio);
> > +     list->nr_grps++;
> > +
> > +     return true;
> > +}
> > +
> > +static int bio_grp_list_find_grp(struct bio_grp_list *list, void *grp_data)
> > +{
> > +     int i;
> > +     struct bio_grp_list_data *grp;
> > +
> > +     for (i = 0; i < list->max_nr_grps; i++) {
> > +             grp = &list->head[i];
> > +             if (grp->grp_data == grp_data)
> > +                     return i;
> > +     }
> > +     for (i = 0; i < list->max_nr_grps; i++) {
> > +             grp = &list->head[i];
> > +             if (bio_grp_list_grp_empty(grp))
> > +                     return i;
> > +     }
> > +     return -1;
> > +}
> > +
> > +/* Move as many as possible groups from 'src' to 'dst' */
> > +void bio_grp_list_move(struct bio_grp_list *dst, struct bio_grp_list *src)
> > +{
> > +     int i, j, cnt = 0;
> > +     struct bio_grp_list_data *grp;
> > +
> > +     for (i = src->nr_grps - 1; i >= 0; i--) {
> > +             grp = &src->head[i];
> > +             j = bio_grp_list_find_grp(dst, grp->grp_data);
> > +             if (j < 0)
> > +                     break;
> > +             if (bio_grp_list_grp_empty(&dst->head[j]))
> > +                     dst->head[j].grp_data = grp->grp_data;
> > +             __bio_grp_list_merge(&dst->head[j].list, &grp->list);
> > +             bio_list_init(&grp->list);
> > +             cnt++;
> > +     }
> > +
> > +     src->nr_grps -= cnt;
> > +}
> > +
> >  static void bio_poll_ctx_init(struct blk_bio_poll_ctx *pc)
> >  {
> >       pc->sq = (void *)pc + sizeof(*pc);
> > @@ -866,6 +937,46 @@ static inline void blk_bio_poll_preprocess(struct request_queue *q,
> >               bio->bi_opf |= REQ_TAG;
> >  }
> >
> > +static bool blk_bio_poll_prep_submit(struct io_context *ioc, struct bio *bio)
> > +{
> > +     struct blk_bio_poll_ctx *pc = ioc->data;
> > +     unsigned int queued;
> > +
> > +     /*
> > +      * We rely on immutable .bi_end_io between blk-mq bio submission
> > +      * and completion. However, bio crypt may update .bi_end_io during
> > +      * submitting, so simply not support bio based polling for this
> > +      * setting.
> > +      */
> > +     if (likely(!bio_has_crypt_ctx(bio))) {
> > +             /* track this bio via bio group list */
> > +             spin_lock(&pc->sq_lock);
> > +             queued = bio_grp_list_add(pc->sq, bio);
> > +             spin_unlock(&pc->sq_lock);
> > +     } else {
> > +             queued = false;
> > +     }
> > +
> > +     /*
> > +      * Now the bio is added per-task fifo, mark it as END_BY_POLL,
> > +      * and the bio is always completed from the pair poll context.
> > +      *
> > +      * One invariant is that if bio isn't completed, blk_poll() will
> > +      * be called by passing cookie returned from submitting this bio.
> > +      */
> > +     if (!queued)
> > +             bio->bi_opf &= ~(REQ_HIPRI | REQ_TAG);
> > +     else
> > +             bio_set_flag(bio, BIO_END_BY_POLL);
> > +
> > +     return queued;
> > +}
> > +
> > +static void blk_bio_poll_post_submit(struct bio *bio, blk_qc_t cookie)
> > +{
> > +     bio->bi_iter.bi_private_data = cookie;
> > +}
> > +
> >  static noinline_for_stack bool submit_bio_checks(struct bio *bio)
> >  {
> >       struct block_device *bdev = bio->bi_bdev;
> > @@ -1020,7 +1131,7 @@ static blk_qc_t __submit_bio(struct bio *bio)
> >   * bio_list_on_stack[1] contains bios that were submitted before the current
> >   *   ->submit_bio_bio, but that haven't been processed yet.
> >   */
> > -static blk_qc_t __submit_bio_noacct(struct bio *bio)
> > +static blk_qc_t __submit_bio_noacct_int(struct bio *bio, struct io_context *ioc)
> >  {
> >       struct bio_list bio_list_on_stack[2];
> >       blk_qc_t ret = BLK_QC_T_NONE;
> > @@ -1043,7 +1154,16 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >               bio_list_on_stack[1] = bio_list_on_stack[0];
> >               bio_list_init(&bio_list_on_stack[0]);
> >
> > -             ret = __submit_bio(bio);
> > +             if (ioc && queue_is_mq(q) &&
> > +                             (bio->bi_opf & (REQ_HIPRI | REQ_TAG))) {
> > +                     bool queued = blk_bio_poll_prep_submit(ioc, bio);
> > +
> > +                     ret = __submit_bio(bio);
> > +                     if (queued)
> > +                             blk_bio_poll_post_submit(bio, ret);
> > +             } else {
> > +                     ret = __submit_bio(bio);
> > +             }
>
> So you're only supporting bio-based polling if the bio-based device is
> stacked _directly_ ontop of blk-mq?  Severely limits the utility of
> bio-based IO polling support if such shallow stacking is required.

Sorry, I was too focused on this core change, I didn't look far enough
to see you're returning current->pid for all the intermediate
bio-based layers in an arbitrarily deep bio-based IO device stack.

I think I understand it now, but I _do_ think we need a better name
than "__submit_bio_noacct_int"

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

