Return-Path: <SRS0=YvnR=ON=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7009C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:11:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7A62160F39
	for <dm-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7A62160F39
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1632388313;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8YLNWor9k2vgiaOH5qQ67MTvKjJev78ljoG5XnCDpjs=;
	b=SHhjzvwMqBHsNJELBTVRsGI2QV8gLmw1C3zukC2Sw0c46o9e2DPKxE4qKy0KHoMvzFRU1C
	g47OALJqsVtUwPz09Mk6ccRsTbVSvqIMih2bsuTsUyV/XmlOln9fwgHHx757D6fM6Ro7y1
	cSRzA/ZmQrvROnjWhHt4WliJyHlrMFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-uGwp2WtZNkCyGHRqBkS5vA-1; Thu, 23 Sep 2021 05:11:46 -0400
X-MC-Unique: uGwp2WtZNkCyGHRqBkS5vA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47B1410151E3;
	Thu, 23 Sep 2021 09:11:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A32D11017E28;
	Thu, 23 Sep 2021 09:11:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89F994E58F;
	Thu, 23 Sep 2021 09:11:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18N9Bbwb030498 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 23 Sep 2021 05:11:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 80ABB970E1; Thu, 23 Sep 2021 09:11:37 +0000 (UTC)
Received: from localhost (ovpn-8-34.pek2.redhat.com [10.72.8.34])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A28C3970E5;
	Thu, 23 Sep 2021 09:11:20 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Date: Thu, 23 Sep 2021 17:11:31 +0800
Message-Id: <20210923091131.1463013-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [dm-devel] [PATCH] dm-rq: don't queue request during suspend
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

DM uses blk-mq's quiesce/unquiesce to stop/start device mapper queue.

But blk-mq's unquiesce may come from outside events, such as elevator
switch, updating nr_requests or others, and request may come during
suspend, so simply ask for blk-mq to requeue it.

Fixes one kernel panic issue when running updating nr_requests and
dm-mpath suspend/resume stress test.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 5b95eea517d1..a896dea9750e 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -490,6 +490,14 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct mapped_device *md = tio->md;
 	struct dm_target *ti = md->immutable_target;
 
+	/*
+	 * blk-mq's unquiesce may come from outside events, such as
+	 * elevator switch, updating nr_requests or others, and request may
+	 * come during suspend, so simply ask for blk-mq to requeue it.
+	 */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)))
+		return BLK_STS_RESOURCE;
+
 	if (unlikely(!ti)) {
 		int srcu_idx;
 		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

