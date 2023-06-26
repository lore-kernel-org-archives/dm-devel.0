Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6432BEB64D7
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687790777;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yQAUX64Ptp7AyBbWF4UNIxfDPI6UDgMR+yc4xWOGAow=;
	b=bAXun2bE6VZB0WBxHC1/6LNcziM5WzmUaa9BBU1uTU2uHbI82jW5mgILVro2cEP+M3i2CP
	FJ228k+JJRPpru/yREB6MApkyMWTSFqOz4ycy7ES7JbphuH0/WwSD2NjtHuGHiv+LBK1TX
	udDFh/xhI6oATIXQf21O/ijFp76CgHc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-55genxhHOtm-xOZNQhJFlg-1; Mon, 26 Jun 2023 10:46:13 -0400
X-MC-Unique: 55genxhHOtm-xOZNQhJFlg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3798D10504AE;
	Mon, 26 Jun 2023 14:46:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25D47112132D;
	Mon, 26 Jun 2023 14:46:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D83DC1946588;
	Mon, 26 Jun 2023 14:46:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5354B1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 14:46:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B41A1121333; Mon, 26 Jun 2023 14:46:00 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 341341121339;
 Mon, 26 Jun 2023 14:46:00 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 299D030C0457; Mon, 26 Jun 2023 14:46:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 279253F7CF; Mon, 26 Jun 2023 16:46:00 +0200 (CEST)
Date: Mon, 26 Jun 2023 16:46:00 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <bd3359fd-c360-68c-256f-56146f6ba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 2/3] dm-integrity: allocate recalculate buffer
 only when needed
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-integrity preallocated 8MiB buffer for recalculating in the constructor
and freed it in the destructor. This wastes memory when the user has many
dm-integrity devices.

This patch changes dm-integrity so that it allocates the buffer in the
begining of the function integrity_recalc and free it in the end - so,
the buffer is only allocated when recalculation is in progress.

Note that the function integrity_recalc doesn't hold any locks when
allocating the buffer, so it shouldn't cause low-memory deadlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   52 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -251,8 +251,6 @@ struct dm_integrity_c {
 
 	struct workqueue_struct *recalc_wq;
 	struct work_struct recalc_work;
-	u8 *recalc_buffer;
-	u8 *recalc_tags;
 
 	struct bio_list flush_bio_list;
 
@@ -2661,6 +2659,9 @@ static void recalc_write_super(struct dm
 static void integrity_recalc(struct work_struct *w)
 {
 	struct dm_integrity_c *ic = container_of(w, struct dm_integrity_c, recalc_work);
+	size_t recalc_tags_size;
+	u8 *recalc_buffer = NULL;
+	u8 *recalc_tags = NULL;
 	struct dm_integrity_range range;
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
@@ -2673,6 +2674,20 @@ static void integrity_recalc(struct work
 	int r;
 	unsigned int super_counter = 0;
 
+	recalc_buffer = __vmalloc(RECALC_SECTORS << SECTOR_SHIFT, GFP_NOIO);
+	if (!recalc_buffer) {
+		DMCRIT("out of memory for recalculate buffer - recalculation disabled");
+		goto free_ret;
+	}
+	recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+	if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
+		recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+	recalc_tags = kvmalloc(recalc_tags_size, GFP_NOIO);
+	if (!recalc_tags) {
+		DMCRIT("out of memory for recalculate buffer - recalculation disabled");
+		goto free_ret;
+	}
+
 	DEBUG_print("start recalculation... (position %llx)\n", le64_to_cpu(ic->sb->recalc_sector));
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2735,7 +2750,7 @@ next_chunk:
 
 	io_req.bi_opf = REQ_OP_READ;
 	io_req.mem.type = DM_IO_VMA;
-	io_req.mem.ptr.addr = ic->recalc_buffer;
+	io_req.mem.ptr.addr = recalc_buffer;
 	io_req.notify.fn = NULL;
 	io_req.client = ic->io;
 	io_loc.bdev = ic->dev->bdev;
@@ -2748,15 +2763,15 @@ next_chunk:
 		goto err;
 	}
 
-	t = ic->recalc_tags;
+	t = recalc_tags;
 	for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
-		integrity_sector_checksum(ic, logical_sector + i, ic->recalc_buffer + (i << SECTOR_SHIFT), t);
+		integrity_sector_checksum(ic, logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
 		t += ic->tag_size;
 	}
 
 	metadata_block = get_metadata_sector_and_offset(ic, area, offset, &metadata_offset);
 
-	r = dm_integrity_rw_tag(ic, ic->recalc_tags, &metadata_block, &metadata_offset, t - ic->recalc_tags, TAG_WRITE);
+	r = dm_integrity_rw_tag(ic, recalc_tags, &metadata_block, &metadata_offset, t - recalc_tags, TAG_WRITE);
 	if (unlikely(r)) {
 		dm_integrity_io_error(ic, "writing tags", r);
 		goto err;
@@ -2784,12 +2799,16 @@ advance_and_next:
 
 err:
 	remove_range(ic, &range);
-	return;
+	goto free_ret;
 
 unlock_ret:
 	spin_unlock_irq(&ic->endio_wait.lock);
 
 	recalc_write_super(ic);
+
+free_ret:
+	vfree(recalc_buffer);
+	kvfree(recalc_tags);
 }
 
 static void bitmap_block_work(struct work_struct *w)
@@ -4454,8 +4473,6 @@ try_smaller_buffer:
 	}
 
 	if (ic->internal_hash) {
-		size_t recalc_tags_size;
-
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq) {
 			ti->error = "Cannot allocate workqueue";
@@ -4463,21 +4480,6 @@ try_smaller_buffer:
 			goto bad;
 		}
 		INIT_WORK(&ic->recalc_work, integrity_recalc);
-		ic->recalc_buffer = vmalloc(RECALC_SECTORS << SECTOR_SHIFT);
-		if (!ic->recalc_buffer) {
-			ti->error = "Cannot allocate buffer for recalculating";
-			r = -ENOMEM;
-			goto bad;
-		}
-		recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
-		if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
-			recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
-		ic->recalc_tags = kvmalloc(recalc_tags_size, GFP_KERNEL);
-		if (!ic->recalc_tags) {
-			ti->error = "Cannot allocate tags for recalculating";
-			r = -ENOMEM;
-			goto bad;
-		}
 	} else {
 		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
 			ti->error = "Recalculate can only be specified with internal_hash";
@@ -4621,8 +4623,6 @@ static void dm_integrity_dtr(struct dm_t
 		destroy_workqueue(ic->writer_wq);
 	if (ic->recalc_wq)
 		destroy_workqueue(ic->recalc_wq);
-	vfree(ic->recalc_buffer);
-	kvfree(ic->recalc_tags);
 	kvfree(ic->bbs);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

