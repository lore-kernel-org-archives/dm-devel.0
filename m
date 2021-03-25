Return-Path: <SRS0=/8Bn=IX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDCCC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 09:17:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD79261A13
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 09:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD79261A13
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-ClA7zZQ6PQOiWkJA5YFKsQ-1; Thu, 25 Mar 2021 05:17:13 -0400
X-MC-Unique: ClA7zZQ6PQOiWkJA5YFKsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B1FE107ACCD;
	Thu, 25 Mar 2021 09:17:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7078D10016FC;
	Thu, 25 Mar 2021 09:17:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A089180213A;
	Thu, 25 Mar 2021 09:17:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12P6uA7K024396 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 02:56:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5743221CAC6D; Thu, 25 Mar 2021 06:56:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5211F21CAC6C
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 06:56:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9888B185A7B4
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 06:56:06 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-452-sINoVskzNSGZ78j6GB6ImQ-1;
	Thu, 25 Mar 2021 02:56:01 -0400
X-MC-Unique: sINoVskzNSGZ78j6GB6ImQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R391e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UTFNVua_1616655357
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UTFNVua_1616655357) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 25 Mar 2021 14:55:57 +0800
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210324121927.362525-1-ming.lei@redhat.com>
	<20210324121927.362525-6-ming.lei@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <c9e0383e-144b-e7cb-3b30-f50ee2f3d98a@linux.alibaba.com>
Date: Thu, 25 Mar 2021 14:55:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210324121927.362525-6-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 25 Mar 2021 05:16:51 -0400
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V3 05/13] block: add req flag of REQ_POLL_CTX
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/24/21 8:19 PM, Ming Lei wrote:
> Add one req flag REQ_POLL_CTX which will be used in the following patch for
> supporting bio based IO polling.
> 
> Exactly this flag can help us to do:
> 
> 1) request flag is cloned in bio_fast_clone(), so if we mark one FS bio
> as REQ_POLL_CTX, all bios cloned from this FS bio will be marked as
> REQ_POLL_CTX too.
> 
> 2) create per-task io polling context if the bio based queue supports
> polling and the submitted bio is HIPRI. Per-task io poll context will be
> created during submit_bio() before marking this HIPRI bio as REQ_POLL_CTX.
> Then we can avoid to create such io polling context if one cloned bio with
> REQ_POLL_CTX is submitted from another kernel context.
> 
> 3) for supporting bio based io polling, we need to poll IOs from all
> underlying queues of the bio device, this way help us to recognize which
> IO needs to polled in bio based style, which will be applied in
> following patch.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>


> ---
>  block/blk-core.c          | 25 ++++++++++++++++++++++++-
>  include/linux/blk_types.h |  4 ++++
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4671bbf31fd3..eb07d61cfdc2 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -840,11 +840,30 @@ static inline bool blk_queue_support_bio_poll(struct request_queue *q)
>  static inline void blk_bio_poll_preprocess(struct request_queue *q,
>  		struct bio *bio)
>  {
> +	bool mq;
> +
>  	if (!(bio->bi_opf & REQ_HIPRI))
>  		return;
>  
> -	if (!blk_queue_poll(q) || (!queue_is_mq(q) && !blk_get_bio_poll_ctx()))
> +	/*
> +	 * Can't support bio based IO polling without per-task poll ctx
> +	 *
> +	 * We have created per-task io poll context, and mark this
> +	 * bio as REQ_POLL_CTX, so: 1) if any cloned bio from this bio is
> +	 * submitted from another kernel context, we won't create bio
> +	 * poll context for it, and that bio can be completed by IRQ;
> +	 * 2) If such bio is submitted from current context, we will
> +	 * complete it via blk_poll(); 3) If driver knows that one
> +	 * underlying bio allocated from driver is for FS bio, meantime
> +	 * it is submitted in current context, driver can mark such bio
> +	 * as REQ_HIPRI & REQ_POLL_CTX manually, so the bio can be completed
> +	 * via blk_poll too.
> +	 */
> +	mq = queue_is_mq(q);
> +	if (!blk_queue_poll(q) || (!mq && !blk_get_bio_poll_ctx()))
>  		bio->bi_opf &= ~REQ_HIPRI;
> +	else if (!mq)
> +		bio->bi_opf |= REQ_POLL_CTX;
>  }
>  
>  static noinline_for_stack bool submit_bio_checks(struct bio *bio)
> @@ -894,8 +913,12 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
>  	/*
>  	 * Create per-task io poll ctx if bio polling supported and HIPRI
>  	 * set.
> +	 *
> +	 * If REQ_POLL_CTX isn't set for this HIPRI bio, we think it originated
> +	 * from FS and allocate io polling context.
>  	 */
>  	blk_create_io_context(q, blk_queue_support_bio_poll(q) &&
> +			!(bio->bi_opf & REQ_POLL_CTX) &&
>  			(bio->bi_opf & REQ_HIPRI));
>  
>  	blk_bio_poll_preprocess(q, bio);
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index db026b6ec15a..99160d588c2d 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -394,6 +394,9 @@ enum req_flag_bits {
>  
>  	__REQ_HIPRI,
>  
> +	/* for marking IOs originated from same FS bio in same context */
> +	__REQ_POLL_CTX,
> +
>  	/* for driver use */
>  	__REQ_DRV,
>  	__REQ_SWAP,		/* swapping request. */
> @@ -418,6 +421,7 @@ enum req_flag_bits {
>  
>  #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
>  #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
> +#define REQ_POLL_CTX			(1ULL << __REQ_POLL_CTX)
>  
>  #define REQ_DRV			(1ULL << __REQ_DRV)
>  #define REQ_SWAP		(1ULL << __REQ_SWAP)
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

