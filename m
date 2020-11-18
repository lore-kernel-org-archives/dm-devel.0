Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FC4C6369E
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 15:38:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4510124779
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 15:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LoVaqlQ8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4510124779
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605713901;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f8bi3Yl1nk3woyN9qIbrePzOohRPGux7nhx5WP/09qQ=;
	b=LoVaqlQ8edrgGN47xfFz4vKmymYUTuaSitbtm/bK1hzYz1iGXFkprDGH5jmh7S5OW0Vmlr
	rSRTqsFvANLoERT/uCRmfP2zFgWicW291pjd4fuqcE0ptNJb5knVGiJ9y+gg17RxHKUFgQ
	8RTWowMHHVKc2qLQkfmUqM6gyaWY+No=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-M_KCktz4NPOkckkyMYi_RA-1; Wed, 18 Nov 2020 10:38:18 -0500
X-MC-Unique: M_KCktz4NPOkckkyMYi_RA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A852919251AA;
	Wed, 18 Nov 2020 15:38:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E482D60853;
	Wed, 18 Nov 2020 15:38:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 349258C7A1;
	Wed, 18 Nov 2020 15:38:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AIFc8qi022445 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 10:38:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CB58D1F0; Wed, 18 Nov 2020 15:38:08 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E22A34D;
	Wed, 18 Nov 2020 15:38:04 +0000 (UTC)
Date: Wed, 18 Nov 2020 10:38:04 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20201118153803.GA545@redhat.com>
References: <20201110065558.22694-1-jefflexu@linux.alibaba.com>
	<20201113020551.55716-1-jefflexu@linux.alibaba.com>
	<7f63a06c-137f-bb6a-92da-bcf477dc8ffe@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <7f63a06c-137f-bb6a-92da-bcf477dc8ffe@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com, koct9i@gmail.com
Subject: Re: [dm-devel] [PATCH v2] dm: add support for DM_TARGET_NOWAIT for
 various targets
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I just staged this for 5.11, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.11&id=373ce365b756bf6fec237461a0bbe65f33f201f6

I tweaked your patch header just a bit.

Thanks,
Mike


On Tue, Nov 17 2020 at  9:01pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> Hi Mike,
> 
> How about this patch? I just tweaks the commit message in this v2
> patch to make
> 
> the purpose clearer, while keep the code unstained.
> 
> 
> Thanks,
> 
> Jeffle
> 
> 
> On 11/13/20 10:05 AM, Jeffle Xu wrote:
> >commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") adds a new queue
> >flag QUEUE_FLAG_NOWAIT to advertise if the bdev supports handling of
> >REQ_NOWAIT or not. DM core supports this in commit 6abc49468eea ("dm:
> >add support for REQ_NOWAIT and enable it for linear target"), in which
> >only dm-linear is enabled.
> >
> >This patch also enables several dm-linear likely dm targets, the mapping
> >algorithm of which is just simple remapping.
> >
> >Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >---
> >  drivers/md/dm-stripe.c   | 2 +-
> >  drivers/md/dm-switch.c   | 1 +
> >  drivers/md/dm-unstripe.c | 1 +
> >  drivers/md/dm-zero.c     | 1 +
> >  4 files changed, 4 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> >index 151d022b032d..df359d33cda8 100644
> >--- a/drivers/md/dm-stripe.c
> >+++ b/drivers/md/dm-stripe.c
> >@@ -496,7 +496,7 @@ static void stripe_io_hints(struct dm_target *ti,
> >  static struct target_type stripe_target = {
> >  	.name   = "striped",
> >  	.version = {1, 6, 0},
> >-	.features = DM_TARGET_PASSES_INTEGRITY,
> >+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT,
> >  	.module = THIS_MODULE,
> >  	.ctr    = stripe_ctr,
> >  	.dtr    = stripe_dtr,
> >diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
> >index bff4c7fa1cd2..262e2b0fd975 100644
> >--- a/drivers/md/dm-switch.c
> >+++ b/drivers/md/dm-switch.c
> >@@ -550,6 +550,7 @@ static int switch_iterate_devices(struct dm_target *ti,
> >  static struct target_type switch_target = {
> >  	.name = "switch",
> >  	.version = {1, 1, 0},
> >+	.features = DM_TARGET_NOWAIT,
> >  	.module = THIS_MODULE,
> >  	.ctr = switch_ctr,
> >  	.dtr = switch_dtr,
> >diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
> >index e673dacf6418..7357c1bd5863 100644
> >--- a/drivers/md/dm-unstripe.c
> >+++ b/drivers/md/dm-unstripe.c
> >@@ -178,6 +178,7 @@ static void unstripe_io_hints(struct dm_target *ti,
> >  static struct target_type unstripe_target = {
> >  	.name = "unstriped",
> >  	.version = {1, 1, 0},
> >+	.features = DM_TARGET_NOWAIT,
> >  	.module = THIS_MODULE,
> >  	.ctr = unstripe_ctr,
> >  	.dtr = unstripe_dtr,
> >diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
> >index b65ca8dcfbdc..faa1dbffc8b4 100644
> >--- a/drivers/md/dm-zero.c
> >+++ b/drivers/md/dm-zero.c
> >@@ -59,6 +59,7 @@ static int zero_map(struct dm_target *ti, struct bio *bio)
> >  static struct target_type zero_target = {
> >  	.name   = "zero",
> >  	.version = {1, 1, 0},
> >+	.features = DM_TARGET_NOWAIT,
> >  	.module = THIS_MODULE,
> >  	.ctr    = zero_ctr,
> >  	.map    = zero_map,
> 
> -- 
> Thanks,
> Jeffle
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

