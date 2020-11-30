Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72730C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 17:18:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C1D272076E
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 17:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TZmfJ8a3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1D272076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606756706;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NOrjrVQYSRlR1xMxAGXRm881AlP4T1aaQ5rg/K6xyw8=;
	b=TZmfJ8a3T2Fg26iMV7cm/0LzXNpOkdop9r+ef7nxxPzTK32uQ7W5rsLUPqqP0Tsnn9EgYc
	UDRxDcKxEz0qy7ZfQdcksdqAdQvw2tj7DLQ0PWzAnf9ZmkBKlGvpOzSXVCdMvn4EwKKTBB
	41XA9xmm7/iovic7KStJEarDjryPTzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-OrS33YPFO0KXflsJoD9AOA-1; Mon, 30 Nov 2020 12:18:23 -0500
X-MC-Unique: OrS33YPFO0KXflsJoD9AOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4A191009462;
	Mon, 30 Nov 2020 17:18:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A11A10023B4;
	Mon, 30 Nov 2020 17:18:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 51A9B4A7C6;
	Mon, 30 Nov 2020 17:18:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUHICmv003073 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 12:18:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E21061111A6B; Mon, 30 Nov 2020 17:18:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDBE61111A68
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 17:18:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91CB6185A794
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 17:18:10 +0000 (UTC)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
	[209.85.222.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-263-GT4P5g3fMlOOoQ9S8kkPww-1; Mon, 30 Nov 2020 12:18:08 -0500
X-MC-Unique: GT4P5g3fMlOOoQ9S8kkPww-1
Received: by mail-qk1-f193.google.com with SMTP id i199so11537171qke.5;
	Mon, 30 Nov 2020 09:18:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
	bh=eopvHkHgFi7txMRG0JsShqxJBrxyoLD4siq5oMAfwmA=;
	b=Xzd0p3VjfabT3maSNO/ovsDaXQMHpfe2vXl5EcM1mQCsuF84D5COaUHgZ3WInXVz8W
	WcwmQzDPEYI0XWYj8SzC7Z/KoHaW8OdS7LP8YC4FXXaqBmKhh2kOHBg7SYRauHQiLN4H
	D3p9QEGhMSOrNWxSvfWMNbtEwWSavLkqhgTpmLYEp6cSlVUmL+qV7yAMQil5nohVXH9x
	WzNyrSdoqTIjKCSXGBOgqMA6/IZTWxUOEUVdyVLIT4Cdnhj5bhJZ1MWUPhl0MrqA/8ce
	owozJBrTqRTDha2e3jCjfqmgo2tHL5PmcTVSCVkXzGjnfL3irCZaAFqczhcnm5lltBB/
	V0JQ==
X-Gm-Message-State: AOAM533yG47R31PaBRApHXVDo4OJws81BmsJBZ9rdksrMvqqbuZC7WMF
	b7bC1Pr3vQpRvtccj7zjGps=
X-Google-Smtp-Source: ABdhPJyT0JR+r4IdN1HDWZkIkAJ3zWPo9AyvbM2QcZs8QmdiSIdOxosGmwfe2PpeLVhCs5Y2xH7z/g==
X-Received: by 2002:a05:620a:887:: with SMTP id
	b7mr23988892qka.270.1606756687623; 
	Mon, 30 Nov 2020 09:18:07 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id o4sm6738419qta.26.2020.11.30.09.18.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 30 Nov 2020 09:18:06 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: linux-block@vger.kernel.org
Date: Mon, 30 Nov 2020 12:18:05 -0500
Message-Id: <20201130171805.77712-1-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, bjohnsto@redhat.com, jdorminy@redhat.com
Subject: [dm-devel] [PATCH] block: revert to using min_not_zero() when
	stacking chunk_sectors
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

chunk_sectors must reflect the most limited of all devices in the IO
stack.

Otherwise malformed IO may result. E.g.: prior to this fix,
->chunk_sectors = lcm_not_zero(8, 128) would result in
blk_max_size_offset() splitting IO at 128 sectors rather than the
required more restrictive 8 sectors.

Fixes: 22ada802ede8 ("block: use lcm_not_zero() when stacking chunk_sectors")
Cc: stable@vger.kernel.org
Reported-by: John Dorminy <jdorminy@redhat.com>
Reported-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-settings.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9741d1d83e98..1d9decd4646e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -547,7 +547,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
-	t->chunk_sectors = lcm_not_zero(t->chunk_sectors, b->chunk_sectors);
+
+	if (b->chunk_sectors)
+		t->chunk_sectors = min_not_zero(t->chunk_sectors,
+						b->chunk_sectors);
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

