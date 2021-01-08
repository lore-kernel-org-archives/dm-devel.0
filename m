Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AC8C433DB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:33:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A0B62333E
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A0B62333E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610127219;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JjoqFxRUke2L7E2hq0JdboAi15/AS3X6miXXeGdOlTw=;
	b=gwyTUTXsIMe0WXHrPWlGcqZXLTLCDRIGCYMqMNETYhEcfdKqLerd9CrQ3S0L9v7VO0zGJb
	DhA8QiyXbefTcn/uz7D6Fg2OOrqUuQTtKuqOjSazCzrA4BYiukRSnFDArsJU58ODuDcGSq
	eC8I2gCWQSra0d+ntomh5BXj90UqYL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-8_Wi4qXDNgm7q20uAVRz8g-1; Fri, 08 Jan 2021 12:33:37 -0500
X-MC-Unique: 8_Wi4qXDNgm7q20uAVRz8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B9001005504;
	Fri,  8 Jan 2021 17:33:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5ACD10013BD;
	Fri,  8 Jan 2021 17:33:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 05A86180954D;
	Fri,  8 Jan 2021 17:33:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108HXS80026098 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 12:33:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 20FF5101B871; Fri,  8 Jan 2021 17:33:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C82D112D165
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 17:33:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DEDE1010431
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 17:33:25 +0000 (UTC)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com
	[209.85.222.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-528-5lYINAx-MI2SsT5QjNH1aQ-1; Fri, 08 Jan 2021 12:33:23 -0500
X-MC-Unique: 5lYINAx-MI2SsT5QjNH1aQ-1
Received: by mail-qk1-f173.google.com with SMTP id v126so9086846qkd.11
	for <dm-devel@redhat.com>; Fri, 08 Jan 2021 09:33:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=niCrEzZ4Zwb/AmCjiCKG8IO1Lknv6I/uxlNpmIn2B8s=;
	b=pdLgnFgCTT9rGFuqQhTaBC14Eo7Zxt+cfj5eFNgkrwkZc7661TqJ5xiHo84CT6mLIj
	QJT+mN07T3EHMFbMPPc9cAu3tUt8C2f7r0OYdHxSGWx8+0z6HR+uZShOJS9tpFa3EfZM
	AjSA9fNSRsdkne3OkzAzxXi5lfl6zMBeVpG8TzQrY9vkFemmIf3biq4CdHb/rqqA7b54
	hYOMtcofcPaszROZcfGDwssbZmzA0NWIP6y4VelQPEjOy/4TaTTauDQAJ3vWNeMUh3Lx
	0DlbMyZzMqIpARtPlbCorSXF0LtbAM9tr6ePU8GYabIE2Rj8eloXNyJPf8hbBNiVTnKc
	xHkA==
X-Gm-Message-State: AOAM531fnIjwLjmB+nimih+JoQmmgLG4s4e15XuO2+ZGLXIyQZ+X0dNZ
	qqPRgN5LqxJ2AUdTaX3Cmx9QcOlCpzs=
X-Google-Smtp-Source: ABdhPJxj7c8wIBkEzVGUVgEwDiWQq0r77+LRdemzPoh7f3yF2CAg0W6rbK0iizbA9aGmN+YqKTJvhw==
X-Received: by 2002:ae9:ed41:: with SMTP id c62mr4855441qkg.111.1610127202932; 
	Fri, 08 Jan 2021 09:33:22 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	m64sm5145000qkb.90.2021.01.08.09.33.21
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 08 Jan 2021 09:33:21 -0800 (PST)
Date: Fri, 8 Jan 2021 12:33:20 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20210108173320.GA6584@lobo>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
	<20201223112624.78955-4-jefflexu@linux.alibaba.com>
	<20210107214758.GC21239@redhat.com>
	<b081f3bd-fc6f-f7c1-80eb-c8380fc8e8b9@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <b081f3bd-fc6f-f7c1-80eb-c8380fc8e8b9@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC 3/7] block: add iopoll method for non-mq
	device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Thu, Jan 07 2021 at 10:24pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> 
> On 1/8/21 5:47 AM, Mike Snitzer wrote:
> > On Wed, Dec 23 2020 at  6:26am -0500,
> > Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> > 
> >> ->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
> >> callback to struct request_queue") for supporting non-mq queues such as
> >> nvme multipath, but removed in commit 529262d56dbe ("block: remove
> >> ->poll_fn").
> >>
> >> To add support of IO polling for non-mq device, this method need to be
> >> back. Since commit c62b37d96b6e ("block: move ->make_request_fn to
> >> struct block_device_operations") has moved all callbacks into struct
> >> block_device_operations in gendisk, we also add the new method named
> >> ->iopoll in block_device_operations.
> > 
> > Please update patch subject and header to:
> > 
> > block: add iopoll method to support bio-based IO polling
> > 
> > ->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
> > callback to struct request_queue") to support bio-based queues such as
> > nvme multipath, but was later removed in commit 529262d56dbe ("block:
> > remove ->poll_fn").
> > 
> > Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
> > block_device_operations") restore the possibility of bio-based IO
> > polling support by adding an ->iopoll method to gendisk->fops.
> > Elevate bulk of blk_mq_poll() implementation to blk_poll() and reduce
> > blk_mq_poll() to blk-mq specific code that is called from blk_poll().
> > 
> >> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >> ---
> >>  block/blk-core.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
> >>  block/blk-mq.c         | 70 +++++--------------------------------
> >>  include/linux/blk-mq.h |  3 ++
> >>  include/linux/blkdev.h |  1 +
> >>  4 files changed, 92 insertions(+), 61 deletions(-)
> >>
> >> diff --git a/block/blk-core.c b/block/blk-core.c
> >> index 96e5fcd7f071..2f5c51ce32e3 100644
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -1131,6 +1131,85 @@ blk_qc_t submit_bio(struct bio *bio)
> >>  }
> >>  EXPORT_SYMBOL(submit_bio);
> >>  
> >> +static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
> >> +{
> >> +	struct blk_mq_hw_ctx *hctx;
> >> +
> >> +	/* TODO: bio-based device doesn't support hybrid poll. */
> >> +	if (!queue_is_mq(q))
> >> +		return false;
> >> +
> >> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> >> +	if (blk_mq_poll_hybrid(q, hctx, cookie))
> >> +		return true;
> >> +
> >> +	hctx->poll_considered++;
> >> +	return false;
> >> +}
> > 
> > I don't see where you ever backfill bio-based hybrid support (in
> > the following patches in this series, so it is lingering TODO).
> 
> Yes the hybrid polling is not implemented and thus bypassed for
> bio-based device currently.
> 
> > 
> >> +
> >> +/**
> >> + * blk_poll - poll for IO completions
> >> + * @q:  the queue
> >> + * @cookie: cookie passed back at IO submission time
> >> + * @spin: whether to spin for completions
> >> + *
> >> + * Description:
> >> + *    Poll for completions on the passed in queue. Returns number of
> >> + *    completed entries found. If @spin is true, then blk_poll will continue
> >> + *    looping until at least one completion is found, unless the task is
> >> + *    otherwise marked running (or we need to reschedule).
> >> + */
> >> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> >> +{
> >> +	long state;
> >> +
> >> +	if (!blk_qc_t_valid(cookie) ||
> >> +	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> >> +		return 0;
> >> +
> >> +	if (current->plug)
> >> +		blk_flush_plug_list(current->plug, false);
> >> +
> >> +	/*
> >> +	 * If we sleep, have the caller restart the poll loop to reset
> >> +	 * the state. Like for the other success return cases, the
> >> +	 * caller is responsible for checking if the IO completed. If
> >> +	 * the IO isn't complete, we'll get called again and will go
> >> +	 * straight to the busy poll loop. If specified not to spin,
> >> +	 * we also should not sleep.
> >> +	 */
> >> +	if (spin && blk_poll_hybrid(q, cookie))
> >> +		return 1;
> >> +
> >> +	state = current->state;
> >> +	do {
> >> +		int ret;
> >> +		struct gendisk *disk = queue_to_disk(q);
> >> +
> >> +		if (disk->fops->iopoll)
> >> +			ret = disk->fops->iopoll(q, cookie);
> >> +		else
> >> +			ret = blk_mq_poll(q, cookie);
> 
> The original code is indeed buggy. For bio-based device, ->iopoll() may
> not be implemented while QUEUE_FLAG_POLL flag is still set, in which
> case blk_mq_poll() will be called for this bio-based device.

Yes, here is the patch I created to capture my suggestions.  Provided it
looks good to you, please fold it into patch 3 when you rebase for
posting a v2 of your patchset:

From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 7 Jan 2021 20:45:17 -0500
Subject: [PATCH] fixup patch 3

---
 block/blk-core.c       | 51 +++++++++++++++++++++-----------------------------
 block/blk-mq.c         |  6 ++----
 include/linux/blk-mq.h |  3 ++-
 3 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e6671f6ce1a4..44f62dc0fa9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1212,22 +1212,6 @@ int blk_bio_poll(struct request_queue *q, blk_qc_t cookie)
 }
 EXPORT_SYMBOL(blk_bio_poll);
 
-static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
-{
-	struct blk_mq_hw_ctx *hctx;
-
-	/* TODO: bio-based device doesn't support hybrid poll. */
-	if (!queue_is_mq(q))
-		return false;
-
-	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
-	if (blk_mq_poll_hybrid(q, hctx, cookie))
-		return true;
-
-	hctx->poll_considered++;
-	return false;
-}
-
 /**
  * blk_poll - poll for IO completions
  * @q:  the queue
@@ -1243,6 +1227,8 @@ static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
 int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 {
 	long state;
+	struct blk_mq_hw_ctx *hctx = NULL;
+	struct gendisk *disk = NULL;
 
 	if (!blk_qc_t_valid(cookie) ||
 	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
@@ -1251,26 +1237,31 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	if (current->plug)
 		blk_flush_plug_list(current->plug, false);
 
-	/*
-	 * If we sleep, have the caller restart the poll loop to reset
-	 * the state. Like for the other success return cases, the
-	 * caller is responsible for checking if the IO completed. If
-	 * the IO isn't complete, we'll get called again and will go
-	 * straight to the busy poll loop. If specified not to spin,
-	 * we also should not sleep.
-	 */
-	if (spin && blk_poll_hybrid(q, cookie))
-		return 1;
+	if (queue_is_mq(q)) {
+		/*
+		 * If we sleep, have the caller restart the poll loop to reset
+		 * the state. Like for the other success return cases, the
+		 * caller is responsible for checking if the IO completed. If
+		 * the IO isn't complete, we'll get called again and will go
+		 * straight to the busy poll loop. If specified not to spin,
+		 * we also should not sleep.
+		 */
+		hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
+		if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
+			return 1;
+		hctx->poll_considered++;
+	} else
+		disk = queue_to_disk(q);
 
 	state = current->state;
 	do {
 		int ret;
-		struct gendisk *disk = queue_to_disk(q);
 
-		if (disk->fops->iopoll)
+		if (hctx)
+			ret = blk_mq_poll(q, hctx, cookie);
+		else if (disk->fops->iopoll)
 			ret = disk->fops->iopoll(q, cookie);
-		else
-			ret = blk_mq_poll(q, cookie);
+
 		if (ret > 0) {
 			__set_current_state(TASK_RUNNING);
 			return ret;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index fcb44604f806..90d8dead1da5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3826,12 +3826,10 @@ bool blk_mq_poll_hybrid(struct request_queue *q,
 	return blk_mq_poll_hybrid_sleep(q, rq);
 }
 
-int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
+int blk_mq_poll(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
 {
 	int ret;
-	struct blk_mq_hw_ctx *hctx;
-
-	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
 	hctx->poll_invoked++;
 	ret = q->mq_ops->poll(hctx);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2f3742207df5..b95f2ffa866f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -607,7 +607,8 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 }
 
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
-int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
+int blk_mq_poll(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
 bool blk_mq_poll_hybrid(struct request_queue *q,
 		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

