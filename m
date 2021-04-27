Return-Path: <SRS0=s6iH=JY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51392C433B4
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 15:59:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4D50613E8
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 15:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4D50613E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619539153;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6q6LKWezR0I/vEmk53z8N7Yaj2h7xm4C4Pp9JiSIGro=;
	b=UR8VaYSok362fOZIwf+fXEwjXeVV9xB4Haga0UZ3Al6a7f+ZR5nWJ8Ie25xjv9ESIxgRJv
	jkkEQLXIn3JwSK1M01Y2UbFmz4zHTCqRkDpwgy4meJoEGAHDsyHdVU36fN8I+H7AwmMvpT
	Z+zZ5wTjM1Xqrp/4fuWNAyZ924ua4kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-f_GO_YZqN4e9J-8WcOn9MA-1; Tue, 27 Apr 2021 11:59:11 -0400
X-MC-Unique: f_GO_YZqN4e9J-8WcOn9MA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72955809DEA;
	Tue, 27 Apr 2021 15:59:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5447960C0F;
	Tue, 27 Apr 2021 15:59:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F05F81806D1B;
	Tue, 27 Apr 2021 15:59:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13RFx3Dl005443 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 11:59:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 99C8461008; Tue, 27 Apr 2021 15:59:03 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76E7061140;
	Tue, 27 Apr 2021 15:58:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 13RFwsxc029961; Tue, 27 Apr 2021 11:58:54 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 13RFwsuN029958; Tue, 27 Apr 2021 11:58:54 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 27 Apr 2021 11:58:54 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Message-ID: <alpine.LRH.2.02.2104271157490.29188@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Melvin Vermeeren <vermeeren@vermwa.re>
Subject: [dm-devel] [PATCH] dm-integrity: if we have discard support,
 use it when recalculating
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If we have discard support, we don't have to recalculate hash - we can
just fill the metadata with the discard pattern.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -2690,26 +2690,30 @@ next_chunk:
 	if (unlikely(dm_integrity_failed(ic)))
 		goto err;
 
-	io_req.bi_op = REQ_OP_READ;
-	io_req.bi_op_flags = 0;
-	io_req.mem.type = DM_IO_VMA;
-	io_req.mem.ptr.addr = ic->recalc_buffer;
-	io_req.notify.fn = NULL;
-	io_req.client = ic->io;
-	io_loc.bdev = ic->dev->bdev;
-	io_loc.sector = get_data_sector(ic, area, offset);
-	io_loc.count = n_sectors;
-
-	r = dm_io(&io_req, 1, &io_loc, NULL);
-	if (unlikely(r)) {
-		dm_integrity_io_error(ic, "reading data", r);
-		goto err;
-	}
-
-	t = ic->recalc_tags;
-	for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
-		integrity_sector_checksum(ic, logical_sector + i, ic->recalc_buffer + (i << SECTOR_SHIFT), t);
-		t += ic->tag_size;
+	if (!ic->discard) {
+		io_req.bi_op = REQ_OP_READ;
+		io_req.bi_op_flags = 0;
+		io_req.mem.type = DM_IO_VMA;
+		io_req.mem.ptr.addr = ic->recalc_buffer;
+		io_req.notify.fn = NULL;
+		io_req.client = ic->io;
+		io_loc.bdev = ic->dev->bdev;
+		io_loc.sector = get_data_sector(ic, area, offset);
+		io_loc.count = n_sectors;
+
+		r = dm_io(&io_req, 1, &io_loc, NULL);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "reading data", r);
+			goto err;
+		}
+
+		t = ic->recalc_tags;
+		for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
+			integrity_sector_checksum(ic, logical_sector + i, ic->recalc_buffer + (i << SECTOR_SHIFT), t);
+			t += ic->tag_size;
+		}
+	} else {
+		t = ic->recalc_tags + (n_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_size;
 	}
 
 	metadata_block = get_metadata_sector_and_offset(ic, area, offset, &metadata_offset);
@@ -4364,11 +4368,13 @@ try_smaller_buffer:
 			goto bad;
 		}
 		INIT_WORK(&ic->recalc_work, integrity_recalc);
-		ic->recalc_buffer = vmalloc(RECALC_SECTORS << SECTOR_SHIFT);
-		if (!ic->recalc_buffer) {
-			ti->error = "Cannot allocate buffer for recalculating";
-			r = -ENOMEM;
-			goto bad;
+		if (!ic->discard) {
+			ic->recalc_buffer = vmalloc(RECALC_SECTORS << SECTOR_SHIFT);
+			if (!ic->recalc_buffer) {
+				ti->error = "Cannot allocate buffer for recalculating";
+				r = -ENOMEM;
+				goto bad;
+			}
 		}
 		ic->recalc_tags = kvmalloc_array(RECALC_SECTORS >> ic->sb->log2_sectors_per_block,
 						 ic->tag_size, GFP_KERNEL);
@@ -4377,6 +4383,8 @@ try_smaller_buffer:
 			r = -ENOMEM;
 			goto bad;
 		}
+		if (ic->discard)
+			memset(ic->recalc_tags, DISCARD_FILLER, (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size);
 	} else {
 		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
 			ti->error = "Recalculate can only be specified with internal_hash";

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

