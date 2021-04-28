Return-Path: <SRS0=Tzat=JZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E85C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 21:01:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A146C61447
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 21:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A146C61447
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619643705;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RZyuU6vBVlKXO5hZctT98VSSLP5wYLnklf0BepnIfUk=;
	b=QWfL4mUTbhffrcswELT1Q5Npe3vf7PucAa/KR+tX1vfJV6PSdc+lPX9nLZEs2sB8rbDxe4
	xk+m246u8DPn8ImagZNDFWmZe+BkgLyattpB4nLqQi2y8ZnhfDJGqHMvXdfTvBCe20fwzl
	3Bs/MAxJedmL5P7oifS4LKYJvFlSOL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-TSFOjTSuPLW7lO25oIXC1A-1; Wed, 28 Apr 2021 17:01:43 -0400
X-MC-Unique: TSFOjTSuPLW7lO25oIXC1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6611310054F6;
	Wed, 28 Apr 2021 21:01:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 114A06A8FE;
	Wed, 28 Apr 2021 21:01:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 00B691809C82;
	Wed, 28 Apr 2021 21:01:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13SL0PmK005492 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Apr 2021 17:00:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 17240104C412; Wed, 28 Apr 2021 21:00:25 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCE621037E8A;
	Wed, 28 Apr 2021 21:00:23 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 13SL0NNH010489; Wed, 28 Apr 2021 17:00:23 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 13SL0N1V010485; Wed, 28 Apr 2021 17:00:23 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 28 Apr 2021 17:00:23 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Message-ID: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Melvin Vermeeren <vermeeren@vermwa.re>
Subject: [dm-devel] [PATCH v2] dm-integrity: if we have discard support,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

Here I'm sending version 2 of the patch - it increases version number of 
the target, so that userspace can test if this feature is present.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

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
 
-	r = dm_io(&io_req, 1, &io_loc, NULL);
-	if (unlikely(r)) {
-		dm_integrity_io_error(ic, "reading data", r);
-		goto err;
-	}
+		r = dm_io(&io_req, 1, &io_loc, NULL);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "reading data", r);
+			goto err;
+		}
 
-	t = ic->recalc_tags;
-	for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
-		integrity_sector_checksum(ic, logical_sector + i, ic->recalc_buffer + (i << SECTOR_SHIFT), t);
-		t += ic->tag_size;
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
@@ -4570,7 +4578,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 8, 0},
+	.version		= {1, 9, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

