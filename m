Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D55CC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 02:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649211004;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a2V3vUlUjM8zvvVGdAM2lU75yLUB2HwqbqNPUEjPuUc=;
	b=BDgc7nE3ubg9LeQOHmrc+5XcnI3sKvPXQ0hXSZ0krGxEcRiXzcsVSDVdLp3k7+QC9U+Lkf
	wpaH7IlZSv5CS+sherm3rA4NdU13z0y6FMq82kgkogGGINRaZKma59F1kaCwuJQCTh84lZ
	0pWXkfPn/yohBtlbb7rWvOVfbnaH5OY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-6WomRGECNySVLwGvqbStrA-1; Tue, 05 Apr 2022 22:10:01 -0400
X-MC-Unique: 6WomRGECNySVLwGvqbStrA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7489E3803906;
	Wed,  6 Apr 2022 02:09:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A31CF492D89;
	Wed,  6 Apr 2022 02:09:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59BDA194036B;
	Wed,  6 Apr 2022 02:09:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9A0931940369
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 02:09:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C47C401DAC; Wed,  6 Apr 2022 02:09:55 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BB1A492C14;
 Wed,  6 Apr 2022 02:09:49 +0000 (UTC)
Date: Wed, 6 Apr 2022 10:09:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <Ykz2aF3VgyyVG46m@T590>
References: <20220403114532.180945-1-ming.lei@redhat.com>
 <YksiEk+G5QuPG6o8@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YksiEk+G5QuPG6o8@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [RFC PATCH] io_uring: reissue in case -EAGAIN is
 returned after io issue returns
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, io-uring@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 04, 2022 at 12:51:30PM -0400, Mike Snitzer wrote:
> On Sun, Apr 03 2022 at  7:45P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > -EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
> > set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
> > io_iopoll_check doesn't handle this situation, and io hang can be caused.
> > 
> > Current dm io polling may return -EAGAIN after bio submission is
> > returned, also blk-throttle might trigger this situation too.
> > 
> > Cc: Mike Snitzer <snitzer@kernel.org>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> I first reverted commit 5291984004ed ("dm: fix bio polling to handle
> possibile BLK_STS_AGAIN") then applied this patch and verified this
> fixes the DM bio polling hangs.  Nice work!
> 
> But interestingly with this fio test (against dm-linear ontop of
> null_blk with queue_mode=2 submit_queues=8 poll_queues=2 bs=4096 gb=16):
> 
> fio --bs=4096 --ioengine=io_uring --fixedbufs --registerfiles --hipri=1 \
> --iodepth=16 --iodepth_batch_submit=16 --iodepth_batch_complete_min=16 \
> --filename=/dev/mapper/linear --direct=1 --runtime=20 --numjobs=16 \
> --rw=randread --name=test --group_reporting --norandommap

16jobs in io_uring/aio test is overkill.

> 
> I get 3186k IOPS with your patch to have io_uring retry (and commit
> 5291984004ed reverted), but 4305k IOPS if leave commit 5291984004ed
> applied (and DM resorts to retrying any -EAGAIN _without_ polling).

IMO, commit 5291984004ed shouldn't be reverted, which is reasonable to
retry on underlying IO for dm.

This patch is for making io_uring more reliable, since the current
io_uring code only handles -EAGAIN from submission code path, and
-EAGAIN/REISSUE isn't handled if it is returned during ->poll(),
then the io hang is caused.

Jens, what do you think of this patch? Does io_uring need to handle
-EAGAIN in this case?

> 
> Jens rightly pointed out to me that polling tests that exhaust tags
> are bogus anyway (because such unbounded IO defeats the point of
> polling).  Jens also thinks my result, with commit 5291984004ed
> applied, is somehow bogus and not to be trusted ;)  He is very likely
> correct, and the failing likely in the null_blk driver -- I'm
> skeptical of that driver given it cannot pass fio verify testing
> (e.g. --do_verify=1 --verify=crc32c --verify_async=1) with or without
> polling.

Because it is null block...

> 
> Review comments inlined below.
> 
> > ---
> >  fs/io-wq.h    |  13 +++++
> >  fs/io_uring.c | 128 ++++++++++++++++++++++++++++----------------------
> >  2 files changed, 86 insertions(+), 55 deletions(-)
> > 
> > diff --git a/fs/io-wq.h b/fs/io-wq.h
> > index dbecd27656c7..4ca4863664fb 100644
> > --- a/fs/io-wq.h
> > +++ b/fs/io-wq.h
> > @@ -96,6 +96,19 @@ static inline void wq_list_add_head(struct io_wq_work_node *node,
> >  	WRITE_ONCE(list->first, node);
> >  }
> >  
> > +static inline void wq_list_remove(struct io_wq_work_list *list,
> > +				  struct io_wq_work_node *prev,
> > +				  struct io_wq_work_node *node)
> > +{
> > +	if (!prev)
> > +		WRITE_ONCE(list->first, node->next);
> > +	else
> > +		prev->next = node->next;
> > +
> > +	if (node == list->last)
> > +		list->last = prev;
> > +}
> > +
> >  static inline void wq_list_cut(struct io_wq_work_list *list,
> >  			       struct io_wq_work_node *last,
> >  			       struct io_wq_work_node *prev)
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 59e54a6854b7..6db5514e10ca 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -2759,6 +2759,65 @@ static inline bool io_run_task_work(void)
> >  	return false;
> >  }
> >  
> > +#ifdef CONFIG_BLOCK
> > +static bool io_resubmit_prep(struct io_kiocb *req)
> > +{
> > +	struct io_async_rw *rw = req->async_data;
> > +
> > +	if (!req_has_async_data(req))
> > +		return !io_req_prep_async(req);
> > +	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
> > +	return true;
> > +}
> > +
> > +static bool io_rw_should_reissue(struct io_kiocb *req)
> > +{
> > +	umode_t mode = file_inode(req->file)->i_mode;
> > +	struct io_ring_ctx *ctx = req->ctx;
> > +
> > +	if (!S_ISBLK(mode) && !S_ISREG(mode))
> > +		return false;
> > +	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
> > +	    !(ctx->flags & IORING_SETUP_IOPOLL)))
> > +		return false;
> > +	/*
> > +	 * If ref is dying, we might be running poll reap from the exit work.
> > +	 * Don't attempt to reissue from that path, just let it fail with
> > +	 * -EAGAIN.
> > +	 */
> > +	if (percpu_ref_is_dying(&ctx->refs))
> > +		return false;
> > +	/*
> > +	 * Play it safe and assume not safe to re-import and reissue if we're
> > +	 * not in the original thread group (or in task context).
> > +	 */
> > +	if (!same_thread_group(req->task, current) || !in_task())
> > +		return false;
> > +	return true;
> > +}
> > +#else
> > +static bool io_resubmit_prep(struct io_kiocb *req)
> > +{
> > +	return false;
> > +}
> > +static bool io_rw_should_reissue(struct io_kiocb *req)
> > +{
> > +	return false;
> > +}
> > +#endif
> > +
> > +static void do_io_reissue(struct io_kiocb *req, int ret)
> > +{
> > +	if (req->flags & REQ_F_REISSUE) {
> > +		req->flags &= ~REQ_F_REISSUE;
> > +		if (io_resubmit_prep(req))
> > +			io_req_task_queue_reissue(req);
> > +		else
> > +			io_req_task_queue_fail(req, ret);
> > +	}
> > +}
> 
> Minor nit but: I'd leave caller to check for REQ_F_REISSUE.
> 
> > +
> > +
> >  static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> >  {
> >  	struct io_wq_work_node *pos, *start, *prev;
> > @@ -2786,6 +2845,13 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> >  		if (READ_ONCE(req->iopoll_completed))
> >  			break;
> >  
> > +		/*
> > +		 * Once REISSUE flag is set, the req has been done, and we
> > +		 * have to retry
> > +		 */
> > +		if (req->flags & REQ_F_REISSUE)
> > +			break;
> > +
> >  		ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob, poll_flags);
> >  		if (unlikely(ret < 0))
> >  			return ret;
> > @@ -2807,6 +2873,12 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> >  	wq_list_for_each_resume(pos, prev) {
> >  		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
> >  
> > +		if (req->flags & REQ_F_REISSUE) {
> > +			wq_list_remove(&ctx->iopoll_list, prev, pos);
> > +			do_io_reissue(req, -EIO);
> > +			break;
> > +		}
> > +
> 
> That way you'll avoid redundant checks for REQ_F_REISSUE here.

Another do_io_reissue() needn't to remove req from ->iopoll_list, that
is why the check is done here.


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

