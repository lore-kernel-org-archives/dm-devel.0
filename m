Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92B9C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 16:16:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 679B62333E
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 16:16:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 679B62333E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610122594;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aORLnmlJQtzubKiPcMryEWUe+kpyR0DffFuJGY3j7hY=;
	b=dOBrGj9Y0fwY9hL0rSaQGlxGk058ochy85AaofUJCJDMlep+OAiHH6hPE4369sQ/RegwdY
	DmkIubHd7djoGLTPpZAI3vQjqdVYd6BYllXjjltfax7LritM3LQAzkirh7OxSNHk0ODVUx
	ANceMr2h1j6AcUoFbcJEkrYSEbQRap4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-TYU6z47AP76EtI5eMTN-FQ-1; Fri, 08 Jan 2021 11:16:30 -0500
X-MC-Unique: TYU6z47AP76EtI5eMTN-FQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D937801AA3;
	Fri,  8 Jan 2021 16:16:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBE526D036;
	Fri,  8 Jan 2021 16:16:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 599DF4BB7B;
	Fri,  8 Jan 2021 16:16:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108GGCZ4017656 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 11:16:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 61C3A5D9E2; Fri,  8 Jan 2021 16:16:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B4FE5D9F1;
	Fri,  8 Jan 2021 16:15:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 108GFuM0027253; Fri, 8 Jan 2021 11:15:56 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 108GFuNT027249; Fri, 8 Jan 2021 11:15:56 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 8 Jan 2021 11:15:56 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2101081104490.17896@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2101081112090.17896@file01.intranet.prod.int.rdu2.redhat.com>
References: <20201220140222.2f341344@gecko.fritz.box>
	<20210104203042.GB3721@redhat.com>
	<alpine.LRH.2.02.2101081104490.17896@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: dm-devel <dm-devel@redhat.com>, Lukas Straub <lukasstraub2@web.de>
Subject: [dm-devel] [PATCH] dm-integrity: Fix flush with external metadata
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With external metadata device, flush requests are not passed down to the
data device.

Fix this by submitting the flush request in dm_integrity_flush_buffers. In
order to not degrade performance, we overlap the data device flush with
the metadata device flush.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Lukas Straub <lukasstraub2@web.de>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c     |    6 ++++
 drivers/md/dm-integrity.c |   60 +++++++++++++++++++++++++++++++++++++---------
 include/linux/dm-bufio.h  |    1 
 3 files changed, 56 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2021-01-07 17:22:39.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2021-01-08 15:51:19.000000000 +0100
@@ -1379,12 +1379,52 @@ thorough_test:
 #undef MAY_BE_HASH
 }
 
-static void dm_integrity_flush_buffers(struct dm_integrity_c *ic)
+struct flush_request {
+	struct dm_io_request io_req;
+	struct dm_io_region io_reg;
+	struct dm_integrity_c *ic;
+	struct completion comp;
+};
+
+static void flush_notify(unsigned long error, void *fr_)
+{
+	struct flush_request *fr = fr_;
+	if (unlikely(error != 0))
+		dm_integrity_io_error(fr->ic, "flusing disk cache", -EIO);
+	complete(&fr->comp);
+}
+
+static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_data)
 {
 	int r;
+
+	struct flush_request fr;
+
+	if (!ic->meta_dev)
+		flush_data = false;
+	if (flush_data) {
+		fr.io_req.bi_op = REQ_OP_WRITE,
+		fr.io_req.bi_op_flags = REQ_PREFLUSH | REQ_SYNC,
+		fr.io_req.mem.type = DM_IO_KMEM,
+		fr.io_req.mem.ptr.addr = NULL,
+		fr.io_req.notify.fn = flush_notify,
+		fr.io_req.notify.context = &fr;
+		fr.io_req.client = dm_bufio_get_dm_io_client(ic->bufio),
+		fr.io_reg.bdev = ic->dev->bdev,
+		fr.io_reg.sector = 0,
+		fr.io_reg.count = 0,
+		fr.ic = ic;
+		init_completion(&fr.comp);
+		r = dm_io(&fr.io_req, 1, &fr.io_reg, NULL);
+		BUG_ON(r);
+	}
+
 	r = dm_bufio_write_dirty_buffers(ic->bufio);
 	if (unlikely(r))
 		dm_integrity_io_error(ic, "writing tags", r);
+
+	if (flush_data)
+		wait_for_completion(&fr.comp);
 }
 
 static void sleep_on_endio_wait(struct dm_integrity_c *ic)
@@ -2110,7 +2150,7 @@ offload_to_thread:
 
 	if (unlikely(dio->op == REQ_OP_DISCARD) && likely(ic->mode != 'D')) {
 		integrity_metadata(&dio->work);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, false);
 
 		dio->in_flight = (atomic_t)ATOMIC_INIT(1);
 		dio->completion = NULL;
@@ -2195,7 +2235,7 @@ static void integrity_commit(struct work
 	flushes = bio_list_get(&ic->flush_bio_list);
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 		goto release_flush_bios;
 	}
 
@@ -2409,7 +2449,7 @@ skip_io:
 	complete_journal_op(&comp);
 	wait_for_completion_io(&comp.comp);
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, true);
 }
 
 static void integrity_writer(struct work_struct *w)
@@ -2451,7 +2491,7 @@ static void recalc_write_super(struct dm
 {
 	int r;
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, false);
 	if (dm_integrity_failed(ic))
 		return;
 
@@ -2654,7 +2694,7 @@ static void bitmap_flush_work(struct wor
 	unsigned long limit;
 	struct bio *bio;
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, false);
 
 	range.logical_sector = 0;
 	range.n_sectors = ic->provided_data_sectors;
@@ -2663,9 +2703,7 @@ static void bitmap_flush_work(struct wor
 	add_new_range_and_wait(ic, &range);
 	spin_unlock_irq(&ic->endio_wait.lock);
 
-	dm_integrity_flush_buffers(ic);
-	if (ic->meta_dev)
-		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
+	dm_integrity_flush_buffers(ic, true);
 
 	limit = ic->provided_data_sectors;
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
@@ -2934,11 +2972,11 @@ static void dm_integrity_postsuspend(str
 		if (ic->meta_dev)
 			queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 	}
 
 	if (ic->mode == 'B') {
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 #if 1
 		/* set to 0 to test bitmap replay code */
 		init_journal(ic, 0, ic->journal_sections, 0);
Index: linux-2.6/include/linux/dm-bufio.h
===================================================================
--- linux-2.6.orig/include/linux/dm-bufio.h	2020-09-05 10:01:42.000000000 +0200
+++ linux-2.6/include/linux/dm-bufio.h	2021-01-08 15:12:31.000000000 +0100
@@ -150,6 +150,7 @@ void dm_bufio_set_minimum_buffers(struct
 
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
 void *dm_bufio_get_block_data(struct dm_buffer *b);
 void *dm_bufio_get_aux_data(struct dm_buffer *b);
Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2021-01-08 15:11:20.000000000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2021-01-08 15:12:25.000000000 +0100
@@ -1534,6 +1534,12 @@ sector_t dm_bufio_get_device_size(struct
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get_device_size);
 
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c)
+{
+	return c->dm_io;
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_dm_io_client);
+
 sector_t dm_bufio_get_block_number(struct dm_buffer *b)
 {
 	return b->block;

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

