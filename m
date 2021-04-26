Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1166C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 08:00:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 65EF361041
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 08:00:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65EF361041
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619424046;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VAiCMM0dzkJIYWqJbT5V08LZA38VzhxUyCk/WTD0Xfs=;
	b=gIcl6q51O5tTDpFqKJJe6NT6nayfwUhxAf8KaiUd+LIBxm3Y6uL6uEz9vaxAONgIRlVEXb
	fAxA8TML5G6qApzgHzMrzblp0u4fgZVKI6uXaoBWok57hsioRUE+Qv9e2xXVFMw5c4mlYZ
	0nLlg5wU4cevKFjzFwqS/he2CBDyvQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-ZXYLMEnJOiCp6rT1ylRNqg-1; Mon, 26 Apr 2021 04:00:42 -0400
X-MC-Unique: ZXYLMEnJOiCp6rT1ylRNqg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C8AE1926DA0;
	Mon, 26 Apr 2021 08:00:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B1155C1CF;
	Mon, 26 Apr 2021 08:00:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E1CE44A58;
	Mon, 26 Apr 2021 08:00:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13Q80Zbm016041 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 04:00:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8E3BC1992D; Mon, 26 Apr 2021 08:00:35 +0000 (UTC)
Received: from T590 (ovpn-13-194.pek2.redhat.com [10.72.13.194])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7C4A1A86A;
	Mon, 26 Apr 2021 08:00:19 +0000 (UTC)
Date: Mon, 26 Apr 2021 16:00:24 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <YIZzGAxaNnNE0Ipa@T590>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-11-ming.lei@redhat.com>
	<b6a1f1fa-bad2-e072-6292-363510fc7017@suse.de>
MIME-Version: 1.0
In-Reply-To: <b6a1f1fa-bad2-e072-6292-363510fc7017@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V6 10/12] block: limit hw queues to be polled
 in each blk_poll()
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 26, 2021 at 09:19:20AM +0200, Hannes Reinecke wrote:
> On 4/22/21 2:20 PM, Ming Lei wrote:
> > Limit at most 8 queues are polled in each blk_pull(), avoid to
> > add extra latency when queue depth is high.
> > 
> > Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-poll.c | 78 ++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 55 insertions(+), 23 deletions(-)
> > 
> > diff --git a/block/blk-poll.c b/block/blk-poll.c
> > index 249d73ff6f81..20e7c47cc984 100644
> > --- a/block/blk-poll.c
> > +++ b/block/blk-poll.c
> > @@ -288,36 +288,32 @@ static void bio_grp_list_move(struct bio_grp_list *dst,
> >  	src->nr_grps -= cnt;
> >  }
> >  
> > -static int blk_mq_poll_io(struct bio *bio)
> > +#define POLL_HCTX_MAX_CNT 8
> > +
> > +static bool blk_add_unique_hctx(struct blk_mq_hw_ctx **data, int *cnt,
> > +		struct blk_mq_hw_ctx *hctx)
> >  {
> > -	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> > -	blk_qc_t cookie = bio_get_poll_data(bio);
> > -	int ret = 0;
> > +	int i;
> >  
> > -	/* wait until the bio is submitted really */
> > -	if (!blk_qc_t_ready(cookie))
> > -		return 0;
> >  
> > -	if (!bio_flagged(bio, BIO_DONE) && blk_qc_t_valid(cookie)) {
> > -		struct blk_mq_hw_ctx *hctx =
> > -			q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> > +	for (i = 0; i < *cnt; i++) {
> > +		if (data[i] == hctx)
> > +			goto exit;
> > +	}
> >  
> > -		ret += blk_mq_poll_hctx(q, hctx);
> > +	if (i < POLL_HCTX_MAX_CNT) {
> > +		data[i] = hctx;
> > +		(*cnt)++;
> >  	}
> > -	return ret;
> > + exit:
> > +	return *cnt == POLL_HCTX_MAX_CNT;
> >  }
> >  
> > -static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
> > +static void blk_build_poll_queues(struct bio_grp_list *grps,
> > +		struct blk_mq_hw_ctx **data, int *cnt)
> >  {
> > -	int ret = 0;
> >  	int i;
> >  
> > -	/*
> > -	 * Poll hw queue first.
> > -	 *
> > -	 * TODO: limit max poll times and make sure to not poll same
> > -	 * hw queue one more time.
> > -	 */
> >  	for (i = 0; i < grps->nr_grps; i++) {
> >  		struct bio_grp_list_data *grp = &grps->head[i];
> >  		struct bio *bio;
> > @@ -325,11 +321,31 @@ static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
> >  		if (bio_grp_list_grp_empty(grp))
> >  			continue;
> >  
> > -		for (bio = grp->list.head; bio; bio = bio->bi_poll)
> > -			ret += blk_mq_poll_io(bio);
> > +		for (bio = grp->list.head; bio; bio = bio->bi_poll) {
> > +			blk_qc_t  cookie;
> > +			struct blk_mq_hw_ctx *hctx;
> > +			struct request_queue *q;
> > +
> > +			if (bio_flagged(bio, BIO_DONE))
> > +				continue;
> > +
> > +			/* wait until the bio is submitted really */
> > +			cookie = bio_get_poll_data(bio);
> > +			if (!blk_qc_t_ready(cookie) || !blk_qc_t_valid(cookie))
> > +				continue;
> > +
> > +			q = bio->bi_bdev->bd_disk->queue;
> > +			hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> > +			if (blk_add_unique_hctx(data, cnt, hctx))
> > +				return;
> > +		}
> >  	}
> > +}
> > +
> > +static void blk_bio_poll_reap_ios(struct bio_grp_list *grps)
> > +{
> > +	int i;
> >  
> > -	/* reap bios */
> >  	for (i = 0; i < grps->nr_grps; i++) {
> >  		struct bio_grp_list_data *grp = &grps->head[i];
> >  		struct bio *bio;
> > @@ -354,6 +370,22 @@ static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
> >  		}
> >  		__bio_grp_list_merge(&grp->list, &bl);
> >  	}
> > +}
> > +
> > +static int blk_bio_poll_and_end_io(struct bio_grp_list *grps)
> > +{
> > +	int ret = 0;
> > +	int i;
> > +	struct blk_mq_hw_ctx *hctx[POLL_HCTX_MAX_CNT];
> > +	int cnt = 0;
> > +
> > +	blk_build_poll_queues(grps, hctx, &cnt);
> > +
> > +	for (i = 0; i < cnt; i++)
> > +		ret += blk_mq_poll_hctx(hctx[i]->queue, hctx[i]);
> > +
> > +	blk_bio_poll_reap_ios(grps);
> > +
> >  	return ret;
> >  }
> >  
> > 
> Can't we make it a sysfs attribute instead of hard-coding it?
> '8' seems a bit arbitrary to me, I'd rather have the ability to modify it...

I'd rather not add such code in the feature 'enablement' stage since I doesn't
observe the number plays a big role yet. It is added for holding hw queues to
be polled on stack variables, also avoid to add too much latency if there is
too many bios from too many hw queues to be reaped.

Also the actual polled hw queues can be observed easily via bpftrace, so debug
purpose from sysfs isn't necessary too.


Thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

