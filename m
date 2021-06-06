Return-Path: <SRS0=6M1r=LA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8516CC4743E
	for <dm-devel@archiver.kernel.org>; Sun,  6 Jun 2021 20:09:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2484B613AF
	for <dm-devel@archiver.kernel.org>; Sun,  6 Jun 2021 20:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2484B613AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623010163;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2XIfk2VAIctHO6TYphJyV72Gba1YlaDpWFNZzX6hah4=;
	b=JeI7J3QAfKN5OfZY8LSsSzwTl+Fan83ltO/40uculBI35iiDmfRz2C3wJfCIjAvLFHUIO0
	hfyBDocRXcbjtAuqm0Ut3Fl7YD08RPeVy+kcL0Mx5uj6g4YRNxmRUhgH+m12YQIrpFJfOt
	QvYpeOqvAgfPWZ9gnltcMTwMiqTCx+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-WedujjTVPr2y_Obs12-wKg-1; Sun, 06 Jun 2021 16:09:21 -0400
X-MC-Unique: WedujjTVPr2y_Obs12-wKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD414801B13;
	Sun,  6 Jun 2021 20:09:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8D535D9DC;
	Sun,  6 Jun 2021 20:09:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6785A1800BBE;
	Sun,  6 Jun 2021 20:09:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 156K9EaS031211 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Jun 2021 16:09:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 36E03101E24F; Sun,  6 Jun 2021 20:09:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2947510023AF;
	Sun,  6 Jun 2021 20:09:11 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 156K9A3o028156; Sun, 6 Jun 2021 16:09:10 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 156K9AxH028152; Sun, 6 Jun 2021 16:09:10 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Sun, 6 Jun 2021 16:09:10 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2106061608220.27406@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] dm-writecache: remove useless argument "gfp"
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove useless argument "gfp" in the function wc_add_block.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1663,7 +1663,7 @@ pop_from_list:
 	return 0;
 }
 
-static bool wc_add_block(struct writeback_struct *wb, struct wc_entry *e, gfp_t gfp)
+static bool wc_add_block(struct writeback_struct *wb, struct wc_entry *e)
 {
 	struct dm_writecache *wc = wb->wc;
 	unsigned block_size = wc->block_size;
@@ -1724,7 +1724,7 @@ static void __writecache_writeback_pmem(
 			max_pages = WB_LIST_INLINE;
 		}
 
-		BUG_ON(!wc_add_block(wb, e, GFP_NOIO));
+		BUG_ON(!wc_add_block(wb, e));
 
 		wb->wc_list[0] = e;
 		wb->wc_list_n = 1;
@@ -1734,7 +1734,7 @@ static void __writecache_writeback_pmem(
 			if (read_original_sector(wc, f) !=
 			    read_original_sector(wc, e) + (wc->block_size >> SECTOR_SHIFT))
 				break;
-			if (!wc_add_block(wb, f, GFP_NOWAIT | __GFP_NOWARN))
+			if (!wc_add_block(wb, f))
 				break;
 			wbl->size--;
 			list_del(&f->lru);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

