Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12AEC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:26:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5487B61983
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5487B61983
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-WMhFZJNfNfalcn1ipGnzLQ-1; Tue, 30 Mar 2021 04:26:30 -0400
X-MC-Unique: WMhFZJNfNfalcn1ipGnzLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7004781625;
	Tue, 30 Mar 2021 08:26:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4930519706;
	Tue, 30 Mar 2021 08:26:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E338E4BB7C;
	Tue, 30 Mar 2021 08:26:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U3rPZL024384 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 23:53:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D8A5E2026D60; Tue, 30 Mar 2021 03:53:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3D282026D64
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 03:53:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A208805F43
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 03:53:23 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-65-W2dPD9geNHqHdqjw1QXUjQ-1;
	Mon, 29 Mar 2021 23:53:18 -0400
X-MC-Unique: W2dPD9geNHqHdqjw1QXUjQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R481e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UTp7.TS_1617076393
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UTp7.TS_1617076393) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 30 Mar 2021 11:53:14 +0800
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-10-ming.lei@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <0730c7f4-963c-7ac3-26ad-ccf66b6179ad@linux.alibaba.com>
Date: Tue, 30 Mar 2021 11:53:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329152622.173035-10-ming.lei@redhat.com>
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
Subject: Re: [dm-devel] [PATCH V4 09/12] blk-mq: limit hw queues to be
 polled in each blk_poll()
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/29/21 11:26 PM, Ming Lei wrote:
> Limit at most 8 queues are polled in each blk_pull(), avoid to
> add extra latency when queue depth is high.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>

> ---
>  block/blk-mq.c | 73 ++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 53 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b65f2c170fb0..414f5d99d9de 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3865,32 +3865,31 @@ static inline int blk_mq_poll_hctx(struct request_queue *q,
>  	return ret;
>  }
>  
> -static int blk_mq_poll_io(struct bio *bio)
> +#define POLL_HCTX_MAX_CNT 8
> +
> +static bool blk_add_unique_hctx(struct blk_mq_hw_ctx **data, int *cnt,
> +		struct blk_mq_hw_ctx *hctx)
>  {
> -	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> -	blk_qc_t cookie = bio_get_private_data(bio);
> -	int ret = 0;
> +	int i;
>  
> -	if (!bio_flagged(bio, BIO_DONE) && blk_qc_t_valid(cookie)) {
> -		struct blk_mq_hw_ctx *hctx =
> -			q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> +	for (i = 0; i < *cnt; i++) {
> +		if (data[i] == hctx)
> +			goto exit;
> +	}
>  
> -		ret += blk_mq_poll_hctx(q, hctx);
> +	if (i < POLL_HCTX_MAX_CNT) {
> +		data[i] = hctx;
> +		(*cnt)++;
>  	}
> -	return ret;
> + exit:
> +	return *cnt == POLL_HCTX_MAX_CNT;
>  }
>  
> -static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
> +static void blk_build_poll_queues(struct bio_grp_list *grps,
> +		struct blk_mq_hw_ctx **data, int *cnt)
>  {
> -	int ret = 0;
>  	int i;
>  
> -	/*
> -	 * Poll hw queue first.
> -	 *
> -	 * TODO: limit max poll times and make sure to not poll same
> -	 * hw queue one more time.
> -	 */
>  	for (i = 0; i < grps->nr_grps; i++) {
>  		struct bio_grp_list_data *grp = &grps->head[i];
>  		struct bio *bio;
> @@ -3898,11 +3897,29 @@ static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
>  		if (bio_grp_list_grp_empty(grp))
>  			continue;
>  
> -		for (bio = grp->list.head; bio; bio = bio->bi_poll)
> -			ret += blk_mq_poll_io(bio);
> +		for (bio = grp->list.head; bio; bio = bio->bi_poll) {
> +			blk_qc_t  cookie;
> +			struct blk_mq_hw_ctx *hctx;
> +			struct request_queue *q;
> +
> +			if (bio_flagged(bio, BIO_DONE))
> +				continue;
> +			cookie = bio_get_private_data(bio);
> +			if (!blk_qc_t_valid(cookie))
> +				continue;
> +
> +			q = bio->bi_bdev->bd_disk->queue;
> +			hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> +			if (blk_add_unique_hctx(data, cnt, hctx))
> +				return;
> +		}
>  	}
> +}
> +
> +static void blk_bio_poll_reap_ios(struct bio_grp_list *grps)
> +{
> +	int i;
>  
> -	/* reap bios */
>  	for (i = 0; i < grps->nr_grps; i++) {
>  		struct bio_grp_list_data *grp = &grps->head[i];
>  		struct bio *bio;
> @@ -3927,6 +3944,22 @@ static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
>  		}
>  		__bio_grp_list_merge(&grp->list, &bl);
>  	}
> +}
> +
> +static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
> +{
> +	int ret = 0;
> +	int i;
> +	struct blk_mq_hw_ctx *hctx[POLL_HCTX_MAX_CNT];
> +	int cnt = 0;
> +
> +	blk_build_poll_queues(grps, hctx, &cnt);
> +
> +	for (i = 0; i < cnt; i++)
> +		ret += blk_mq_poll_hctx(hctx[i]->queue, hctx[i]);
> +
> +	blk_bio_poll_reap_ios(grps);
> +
>  	return ret;
>  }
>  
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

