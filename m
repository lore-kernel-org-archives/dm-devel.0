Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0033AC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 22:01:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 89DBD64FC8
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 22:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89DBD64FC8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615413700;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FRvg7xLocAdNN6pRVG0qa3j0mWQToEWzPXInyqMBvAI=;
	b=JY4Zu7D/JayBt1hyHmyYBvq/5df1f1bSpfleouEEqn30qBR2vt5NoMxmHrRbTcthhvXQwB
	VcSGG+AV86MuNzaX+pt9+zvOA/fPeyMBfjs2CHvPl7NpcivyO1OcQDB4kSozOnja99wmSF
	h20cV0HdXYEQ9RSAkp7kB6sp7BnUqOg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-uBPcQL-9PuCggTxuzQsaOg-1; Wed, 10 Mar 2021 17:01:37 -0500
X-MC-Unique: uBPcQL-9PuCggTxuzQsaOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E02A61923763;
	Wed, 10 Mar 2021 22:01:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBEAB10013D6;
	Wed, 10 Mar 2021 22:01:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 80DB71809C86;
	Wed, 10 Mar 2021 22:01:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12AM1Qso020737 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 17:01:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D5D0719725; Wed, 10 Mar 2021 22:01:26 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CF1D19C48;
	Wed, 10 Mar 2021 22:01:23 +0000 (UTC)
Date: Wed, 10 Mar 2021 17:01:22 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210310220122.GB23410@redhat.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
	<20210303115740.127001-4-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20210303115740.127001-4-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, caspar@linux.alibaba.com, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 03/12] block: add poll method to support
 bio-based IO polling
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

On Wed, Mar 03 2021 at  6:57am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> ->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
> callback to struct request_queue") to support bio-based queues such as
> nvme multipath, but was later removed in commit 529262d56dbe ("block:
> remove ->poll_fn").
> 
> Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
> block_device_operations") restore the possibility of bio-based IO
> polling support by adding an ->poll method to gendisk->fops.
> 
> Make blk_mq_poll() specific to blk-mq, while blk_bio_poll() is
> originally a copy from blk_mq_poll(), and is specific to bio-based
> polling. Currently hybrid polling is not supported by bio-based polling.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  block/blk-core.c       | 58 ++++++++++++++++++++++++++++++++++++++++++
>  block/blk-mq.c         | 22 +---------------
>  include/linux/blk-mq.h |  1 +
>  include/linux/blkdev.h |  1 +
>  4 files changed, 61 insertions(+), 21 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index fc60ff208497..6d7d53030d7c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1119,6 +1119,64 @@ blk_qc_t submit_bio(struct bio *bio)
>  }
>  EXPORT_SYMBOL(submit_bio);
>  
> +

Minor nit: Extra empty new line here? ^

Otherwise, looks good (I like the end result of blk-mq and bio-based
polling being decoupled like hch suggested).

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

> +static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> +{
> +	long state;
> +	struct gendisk *disk = queue_to_disk(q);
> +
> +	state = current->state;
> +	do {
> +		int ret;
> +
> +		ret = disk->fops->poll(q, cookie);
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
> +	return 0;
> +}
> +
> +/**
> + * blk_poll - poll for IO completions
> + * @q:  the queue
> + * @cookie: cookie passed back at IO submission time
> + * @spin: whether to spin for completions
> + *
> + * Description:
> + *    Poll for completions on the passed in queue. Returns number of
> + *    completed entries found. If @spin is true, then blk_poll will continue
> + *    looping until at least one completion is found, unless the task is
> + *    otherwise marked running (or we need to reschedule).
> + */
> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> +{
> +	if (!blk_qc_t_valid(cookie) ||
> +	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> +		return 0;
> +
> +	if (current->plug)
> +		blk_flush_plug_list(current->plug, false);
> +
> +	if (queue_is_mq(q))
> +		return blk_mq_poll(q, cookie, spin);
> +	else
> +		return blk_bio_poll(q, cookie, spin);
> +}
> +EXPORT_SYMBOL_GPL(blk_poll);
> +
>  /**
>   * blk_cloned_rq_check_limits - Helper function to check a cloned request
>   *                              for the new queue limits
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index d4d7c1caa439..214fa30b460a 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3852,30 +3852,11 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
>  	return blk_mq_poll_hybrid_sleep(q, rq);
>  }
>  
> -/**
> - * blk_poll - poll for IO completions
> - * @q:  the queue
> - * @cookie: cookie passed back at IO submission time
> - * @spin: whether to spin for completions
> - *
> - * Description:
> - *    Poll for completions on the passed in queue. Returns number of
> - *    completed entries found. If @spin is true, then blk_poll will continue
> - *    looping until at least one completion is found, unless the task is
> - *    otherwise marked running (or we need to reschedule).
> - */
> -int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  {
>  	struct blk_mq_hw_ctx *hctx;
>  	long state;
>  
> -	if (!blk_qc_t_valid(cookie) ||
> -	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> -		return 0;
> -
> -	if (current->plug)
> -		blk_flush_plug_list(current->plug, false);
> -
>  	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
>  
>  	/*
> @@ -3917,7 +3898,6 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  	__set_current_state(TASK_RUNNING);
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(blk_poll);
>  
>  unsigned int blk_mq_rq_cpu(struct request *rq)
>  {
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 2c473c9b8990..6a7b693b9917 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -615,6 +615,7 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
>  }
>  
>  blk_qc_t blk_mq_submit_bio(struct bio *bio);
> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
>  void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
>  		struct lock_class_key *key);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b81a9fe015ab..9dc83c30e7bc 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1866,6 +1866,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>  
>  struct block_device_operations {
>  	blk_qc_t (*submit_bio) (struct bio *bio);
> +	int (*poll)(struct request_queue *q, blk_qc_t cookie);
>  	int (*open) (struct block_device *, fmode_t);
>  	void (*release) (struct gendisk *, fmode_t);
>  	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
> -- 
> 2.27.0
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

