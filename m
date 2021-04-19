Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F155C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 02:23:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90CFF61073
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 02:23:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90CFF61073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618798981;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=knnn5RYwDhxpEnEdD+TLfMJBmO1Ve6dt0ES1CVqvp4Y=;
	b=boMof0nGzHjRpbDph64EugKVkzt6l7L9o6aqTMHjbeP7GfUAof3c/hHZpRKDMUdUaxWJ6k
	ahoiwlhXXY0lXycCJOZIMBA2G6Zo1SxJWsNClJpFC5jgvV5fEG/c4hULV5O9JS/XVFH7Yb
	TCTx1kDXH6EJObcI/ln1SY7m5f4BddQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-Pc2fUXmoP1SsAfUqPIpuNw-1; Sun, 18 Apr 2021 22:22:59 -0400
X-MC-Unique: Pc2fUXmoP1SsAfUqPIpuNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3B78501F0;
	Mon, 19 Apr 2021 02:22:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88CAA610F1;
	Mon, 19 Apr 2021 02:22:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 357BB1806D17;
	Mon, 19 Apr 2021 02:22:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13J2Likk024372 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 18 Apr 2021 22:21:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4C6DF610F1; Mon, 19 Apr 2021 02:21:44 +0000 (UTC)
Received: from T590 (ovpn-12-222.pek2.redhat.com [10.72.12.222])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72E50138FB;
	Mon, 19 Apr 2021 02:21:28 +0000 (UTC)
Date: Mon, 19 Apr 2021 10:21:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YHzpJsOYJL/AGC7k@T590>
References: <20210401021927.343727-12-ming.lei@redhat.com>
	<20210416080037.26335-1-jefflexu@linux.alibaba.com>
	<YHlTtVtTEBpxa8Gh@T590>
	<1fb6e15e-fb4d-a2bf-9f65-2ae2aa15a8a2@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <1fb6e15e-fb4d-a2bf-9f65-2ae2aa15a8a2@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
	snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH] block: introduce QUEUE_FLAG_POLL_CAP flag
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

On Sat, Apr 17, 2021 at 10:06:53PM +0800, JeffleXu wrote:
> 
> 
> On 4/16/21 5:07 PM, Ming Lei wrote:
> > On Fri, Apr 16, 2021 at 04:00:37PM +0800, Jeffle Xu wrote:
> >> Hi,
> >> How about this patch to remove the extra poll_capable() method?
> >>
> >> And the following 'dm: support IO polling for bio-based dm device' needs
> >> following change.
> >>
> >> ```
> >> +       /*
> >> +        * Check for request-based device is remained to
> >> +        * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
> >> +        * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
> >> +        * devices supporting polling.
> >> +        */
> >> +       if (__table_type_bio_based(t->type)) {
> >> +               if (dm_table_supports_poll(t)) {
> >> +                       blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
> >> +                       blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> >> +               }
> >> +               else {
> >> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
> >> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL_CAP, q);
> >> +               }
> >> +       }
> >> ```
> > 
> > Frankly speaking, I don't see any value of using QUEUE_FLAG_POLL_CAP for
> > DM, and the result is basically subset of treating DM as always being capable
> > of polling.
> > 
> > Also underlying queue change(either limits or flag) won't be propagated
> > to DM/MD automatically. Strictly speaking it doesn't matter if all underlying
> > queues are capable of supporting polling at the exact time of 'write sysfs/poll',
> > cause any of them may change in future.
> > 
> > So why not start with the simplest approach(always capable of polling)
> > which does meet normal bio based polling requirement?
> > 
> 
> I find one scenario where this issue may matter. Consider the scenario
> where HIPRI bios are submitted to DM device though **all** underlying
> devices has been disabled for polling. In this case, a **valid** cookie
> (pid of current submitting process) is still returned. Then if @spin of
> the following blk_poll() is true, blk_poll() will get stuck in dead loop
> because blk_mq_poll() always returns 0, since previously submitted bios
> are all enqueued into IRQ hw queue.
> 
> Maybe you need to re-remove the bio from the poll context if the
> returned cookie is BLK_QC_T_NONE?

It won't be one issue, see blk_bio_poll_preprocess() which is called
from submit_bio_checks(), so any bio's HIPRI will be cleared if the
queue doesn't support POLL, that code does cover underlying bios.

> 
> 
> Something like:
> 
> -static blk_qc_t __submit_bio_noacct(struct bio *bio)
> +static blk_qc_t __submit_bio_noacct_ctx(struct bio *bio, struct
> io_context *ioc)
>  {
>  	struct bio_list bio_list_on_stack[2];
>  	blk_qc_t ret = BLK_QC_T_NONE;
> @@ -1047,7 +1163,15 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>  		bio_list_init(&bio_list_on_stack[0]);
> 
> 		if (ioc && queue_is_mq(q) && (bio->bi_opf & REQ_HIPRI)) {

REQ_HIPRI won't be set for underlying bios which queue doesn't support
poll, so this branch won't be reached. And the submission queue will
be empty, and blk_poll() for DM/MD(bio based queue) checks nothing, but
the polling won't be stopped until the iocb is completed. And this
handling is actually same with current polling on IRQ based queue.

> 			bool queued = blk_bio_poll_prep_submit(ioc, bio);
> 
> 			ret = __submit_bio(bio);
> +			if (queued && !blk_qc_t_valid(ret))
> 				/* TODO:remove bio from poll_context */
> 				
> 				bio_set_private_data(bio, ret);
> 		} else {
> 			ret = __submit_bio(bio);
> 		}
> 
> 
> Then if you'd like fix this in this way, the returned value of
> .submit_bio() of DM/MD also needs to return BLK_QC_T_NONE now. Currently
> .submit_bio() of DM actually returns the cookie of the last split bio
> (to underlying mq deivice).

I am a bit confused, this patch requires .submit_bio() of DM/MD(bio
based queue) to return either 0 or pid of the submission task.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

