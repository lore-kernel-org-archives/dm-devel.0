Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F77EE7AD72
	for <dm-devel@archiver.kernel.org>; Tue,  3 Oct 2023 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696347408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pFeFpmdVbX0I9fOLd+L3Y+rixakKIEYdqy8FrJCLLp4=;
	b=W3MTRtep583lHC2i5s7cTpqTlMpUh1rn8YrgzHvWU/4oedtP/tysUzqc+tya/IFIjADcMQ
	NFRWlOK75N71T/foSYWnjfFVzTdEUuRe34DPe9GnGrgnzwzg3lhrLSVDdu0ryHtMCYZTkj
	wivZZ3/9/Pl+AbvhU3PLuHFBoEyKqzc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-sN8Zc2yoMVKRXGmLeMxQoA-1; Tue, 03 Oct 2023 11:36:44 -0400
X-MC-Unique: sN8Zc2yoMVKRXGmLeMxQoA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30C8D802D38;
	Tue,  3 Oct 2023 15:36:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F9BD4026FB;
	Tue,  3 Oct 2023 15:36:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD42C194734E;
	Tue,  3 Oct 2023 15:33:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F345A194734C
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 Oct 2023 15:30:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A15F92026D17; Tue,  3 Oct 2023 15:30:32 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 997EC2026D4B;
 Tue,  3 Oct 2023 15:30:32 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 7919130C1C0A; Tue,  3 Oct 2023 15:30:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 754D23FB77; Tue,  3 Oct 2023 17:30:32 +0200 (CEST)
Date: Tue, 3 Oct 2023 17:30:32 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <15ca26cc-174a-d4e8-9780-d09f8e5a6ea5@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] Respect REQ_NOWATI bios
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

Here I'm sending that patch for REQ_NOWAIT for review.

It is not tested, except for some trivial tests that involve logical 
volume activation.

I found out that it seems easier to propagate the error using bits in 
clone_info rather than changing return codes for each affected function.

Mikulas


Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   51 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -87,6 +87,8 @@ struct clone_info {
 	unsigned int sector_count;
 	bool is_abnormal_io:1;
 	bool submit_as_polled:1;
+	bool is_nowait:1;
+	bool nowait_failed:1;
 };
 
 static inline struct dm_target_io *clone_to_tio(struct bio *clone)
@@ -570,13 +572,21 @@ static void dm_end_io_acct(struct dm_io
 	dm_io_acct(io, true);
 }
 
-static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
+static struct dm_io *alloc_io(struct clone_info *ci, struct mapped_device *md, struct bio *bio)
 {
 	struct dm_io *io;
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
+	if (unlikely(ci->is_nowait)) {
+		clone = bio_alloc_clone(NULL, bio, GFP_NOWAIT, &md->mempools->io_bs);
+		if (!clone) {
+			ci->nowait_failed = true;
+			return NULL;
+		}
+	} else {
+		clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
+	}
 	tio = clone_to_tio(clone);
 	tio->flags = 0;
 	dm_tio_set_flag(tio, DM_TIO_INSIDE_DM_IO);
@@ -1503,6 +1513,11 @@ static void alloc_multiple_bios(struct b
 
 		while ((bio = bio_list_pop(blist)))
 			free_tio(bio);
+
+		if (ci->is_nowait) {
+			ci->nowait_failed = true;
+			return;
+		}
 	}
 }
 
@@ -1519,7 +1534,15 @@ static unsigned int __send_duplicate_bio
 	case 1:
 		if (len)
 			setup_split_accounting(ci, *len);
-		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
+		if (unlikely(ci->is_nowait)) {
+			clone = alloc_tio(ci, ti, 0, len, GFP_NOWAIT);
+			if (!clone) {
+				ci->nowait_failed = true;
+				return 0;
+			}
+		} else {
+			clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
+		}
 		__map_bio(clone);
 		ret = 1;
 		break;
@@ -1656,7 +1679,7 @@ static blk_status_t __process_abnormal_i
 
 	__send_changing_extent_only(ci, ti, num_bios,
 				    max_granularity, max_sectors);
-	return BLK_STS_OK;
+	return likely(!ci->nowait_failed) ? BLK_STS_OK : BLK_STS_AGAIN;
 }
 
 /*
@@ -1729,7 +1752,15 @@ static blk_status_t __split_and_process_
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 	setup_split_accounting(ci, len);
-	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+	if (unlikely(ci->is_nowait)) {
+		clone = alloc_tio(ci, ti, 0, &len, GFP_NOWAIT);
+		if (unlikely(!clone)) {
+			ci->nowait_failed = true;
+			return BLK_STS_AGAIN;
+		}
+	} else {
+		clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+	}
 	__map_bio(clone);
 
 	ci->sector += len;
@@ -1741,8 +1772,10 @@ static blk_status_t __split_and_process_
 static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 			    struct dm_table *map, struct bio *bio, bool is_abnormal)
 {
+	ci->is_nowait = !!(bio->bi_opf & REQ_NOWAIT);
+	ci->nowait_failed = false;
 	ci->map = map;
-	ci->io = alloc_io(md, bio);
+	ci->io = alloc_io(ci, md, bio);
 	ci->bio = bio;
 	ci->is_abnormal_io = is_abnormal;
 	ci->submit_as_polled = false;
@@ -1778,10 +1811,16 @@ static void dm_split_and_process_bio(str
 	}
 
 	init_clone_info(&ci, md, map, bio, is_abnormal);
+	if (unlikely(ci.nowait_failed)) {
+		error = BLK_STS_AGAIN;
+		goto out;
+	}
 	io = ci.io;
 
 	if (bio->bi_opf & REQ_PREFLUSH) {
 		__send_empty_flush(&ci);
+		if (unlikely(ci.nowait_failed))
+			error = BLK_STS_AGAIN;
 		/* dm_io_complete submits any data associated with flush */
 		goto out;
 	}
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

