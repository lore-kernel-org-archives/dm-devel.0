Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03AEC2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 14:00:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4EC6F61C76
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 14:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EC6F61C76
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624888806;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LHUQidSkNENf7GSgzphT90OC7/XDQ2/W0rPIQYx0lbs=;
	b=fesrQzXG4UZy3mGTzzSEik4N87PlGbWEimxZAmryBFsDQi8ZDfSRsoI9aJVOe3IZ86shAX
	qc+y8vWyGPa10bIAKbQPDIBmNEHLz6Wy3uqvkjZgybX03tXgiKqnVTHDh5Me6pstA5CDTS
	tvclqkRU2vgkGlnGPfpf1vHEEJEn2UM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-ANzXsPa_OOG3cfkMBsHiuA-1; Mon, 28 Jun 2021 10:00:04 -0400
X-MC-Unique: ANzXsPa_OOG3cfkMBsHiuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D88E91966321;
	Mon, 28 Jun 2021 13:59:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BED4D272C8;
	Mon, 28 Jun 2021 13:59:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 948314E9F4;
	Mon, 28 Jun 2021 13:59:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15SDxsEj032511 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Jun 2021 09:59:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 65ED910372FD; Mon, 28 Jun 2021 13:59:54 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 547FB1036D28;
	Mon, 28 Jun 2021 13:59:38 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 15SDxb6A029379; Mon, 28 Jun 2021 09:59:37 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 15SDxblW029376; Mon, 28 Jun 2021 09:59:37 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Mon, 28 Jun 2021 09:59:37 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2106280815200.21188@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com,
	Joe Thornber <thornber@redhat.com>
Subject: [dm-devel] [PATCH] dm writecache: make writeback pause configurable
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch 95b88f4d71cb953e02206be3c757083601391a0f ("dm writecache: pause
writeback if cache full and origin being written directly") introduced a
code that pauses cache flushing if we are issuing writes directly to the
origin.

This patch makes the timeout code configurable (via the option
"pause_writeback"). It also changes the default from 1s to 3s because it
performed better.

Fixes: 95b88f4d71cb ("dm writecache: pausewriteback if cache full and origin being written directly")

---
 Documentation/admin-guide/device-mapper/writecache.rst |    5 +
 drivers/md/dm-io-tracker.h                             |   12 ++++
 drivers/md/dm-writecache.c                             |   47 ++++++++++++++---
 3 files changed, 54 insertions(+), 10 deletions(-)

Index: linux-dm/drivers/md/dm-writecache.c
===================================================================
--- linux-dm.orig/drivers/md/dm-writecache.c	2021-06-28 14:13:15.000000000 +0200
+++ linux-dm/drivers/md/dm-writecache.c	2021-06-28 14:13:15.000000000 +0200
@@ -30,6 +30,7 @@
 #define AUTOCOMMIT_MSEC			1000
 #define MAX_AGE_DIV			16
 #define MAX_AGE_UNSPECIFIED		-1UL
+#define PAUSE_WRITEBACK			(HZ * 3)
 
 #define BITMAP_GRANULARITY	65536
 #if BITMAP_GRANULARITY < PAGE_SIZE
@@ -125,6 +126,7 @@ struct dm_writecache {
 	size_t freelist_high_watermark;
 	size_t freelist_low_watermark;
 	unsigned long max_age;
+	unsigned long pause;
 
 	unsigned uncommitted_blocks;
 	unsigned autocommit_blocks;
@@ -174,11 +176,13 @@ struct dm_writecache {
 	bool cleaner:1;
 	bool cleaner_set:1;
 	bool metadata_only:1;
+	bool pause_set:1;
 
 	unsigned high_wm_percent_value;
 	unsigned low_wm_percent_value;
 	unsigned autocommit_time_value;
 	unsigned max_age_value;
+	unsigned pause_value;
 
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
@@ -1470,9 +1474,11 @@ bio_copy:
 	}
 
 unlock_remap_origin:
-	if (bio_data_dir(bio) != READ) {
-		dm_iot_io_begin(&wc->iot, 1);
-		bio->bi_private = (void *)2;
+	if (likely(wc->pause != 0)) {
+		 if (bio_op(bio) == REQ_OP_WRITE) {
+			dm_iot_io_begin(&wc->iot, 1);
+			bio->bi_private = (void *)2;
+		}
 	}
 	bio_set_dev(bio, wc->dev->bdev);
 	wc_unlock(wc);
@@ -1837,10 +1843,18 @@ static void writecache_writeback(struct
 		dm_kcopyd_client_flush(wc->dm_kcopyd);
 	}
 
-	if (!wc->writeback_all && !dm_suspended(wc->ti)) {
-		while (!dm_iot_idle_for(&wc->iot, HZ)) {
-			cond_resched();
-			msleep(1000);
+	if (likely(wc->pause != 0)) {
+		while (1) {
+			unsigned long id;
+			if (unlikely(wc->cleaner) || unlikely(wc->writeback_all) || unlikely(dm_suspended(wc->ti)))
+				break;
+			id = dm_iot_idle_time(&wc->iot);
+			if (id >= wc->pause)
+				break;
+			id = wc->pause - id;
+			if (id > HZ)
+				id = HZ;
+			schedule_timeout_idle(id);
 		}
 	}
 
@@ -2113,7 +2127,7 @@ static int writecache_ctr(struct dm_targ
 	struct wc_memory_superblock s;
 
 	static struct dm_arg _args[] = {
-		{0, 17, "Invalid number of feature args"},
+		{0, 18, "Invalid number of feature args"},
 	};
 
 	as.argc = argc;
@@ -2206,6 +2220,7 @@ static int writecache_ctr(struct dm_targ
 			goto bad;
 		}
 	} else {
+		wc->pause = PAUSE_WRITEBACK;
 		r = mempool_init_kmalloc_pool(&wc->copy_pool, 1, sizeof(struct copy_struct));
 		if (r) {
 			ti->error = "Could not allocate mempool";
@@ -2344,6 +2359,18 @@ static int writecache_ctr(struct dm_targ
 			} else goto invalid_optional;
 		} else if (!strcasecmp(string, "metadata_only")) {
 			wc->metadata_only = true;
+		} else if (!strcasecmp(string, "pause_writeback") && opt_params >= 1) {
+			unsigned pause_msecs;
+			if (WC_MODE_PMEM(wc))
+				goto invalid_optional;
+			string = dm_shift_arg(&as), opt_params--;
+			if (sscanf(string, "%u%c", &pause_msecs, &dummy) != 1)
+				goto invalid_optional;
+			if (pause_msecs > 60000)
+				goto invalid_optional;
+			wc->pause = msecs_to_jiffies(pause_msecs);
+			wc->pause_set = true;
+			wc->pause_value = pause_msecs;
 		} else {
 invalid_optional:
 			r = -EINVAL;
@@ -2569,6 +2596,8 @@ static void writecache_status(struct dm_
 			extra_args++;
 		if (wc->metadata_only)
 			extra_args++;
+		if (wc->pause_set)
+			extra_args += 2;
 
 		DMEMIT("%u", extra_args);
 		if (wc->start_sector_set)
@@ -2591,6 +2620,8 @@ static void writecache_status(struct dm_
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
 		if (wc->metadata_only)
 			DMEMIT(" metadata_only");
+		if (wc->pause_set)
+			DMEMIT(" pause_writeback %u", wc->pause_value);
 		break;
 	}
 }
Index: linux-dm/drivers/md/dm-io-tracker.h
===================================================================
--- linux-dm.orig/drivers/md/dm-io-tracker.h	2021-06-28 14:13:15.000000000 +0200
+++ linux-dm/drivers/md/dm-io-tracker.h	2021-06-28 14:13:15.000000000 +0200
@@ -45,6 +45,18 @@ static inline bool dm_iot_idle_for(struc
 	return r;
 }
 
+static inline unsigned long dm_iot_idle_time(struct dm_io_tracker *iot)
+{
+	unsigned long r = 0;
+
+	spin_lock_irq(&iot->lock);
+	if (!iot->in_flight)
+		r = jiffies - iot->idle_time;
+	spin_unlock_irq(&iot->lock);
+
+	return r;
+}
+
 static inline void dm_iot_io_begin(struct dm_io_tracker *iot, sector_t len)
 {
 	spin_lock_irq(&iot->lock);
Index: linux-dm/Documentation/admin-guide/device-mapper/writecache.rst
===================================================================
--- linux-dm.orig/Documentation/admin-guide/device-mapper/writecache.rst	2021-06-28 14:12:30.000000000 +0200
+++ linux-dm/Documentation/admin-guide/device-mapper/writecache.rst	2021-06-28 14:19:55.000000000 +0200
@@ -12,7 +12,6 @@ first sector should contain valid superb
 Constructor parameters:
 
 1. type of the cache device - "p" or "s"
-
 	- p - persistent memory
 	- s - SSD
 2. the underlying device that will be cached
@@ -21,7 +20,6 @@ Constructor parameters:
    size)
 5. the number of optional parameters (the parameters with an argument
    count as two)
-
 	start_sector n		(default: 0)
 		offset from the start of cache device in 512-byte sectors
 	high_watermark n	(default: 50)
@@ -71,6 +69,9 @@ Constructor parameters:
 	metadata_only
 		only metadata is promoted to the cache. This option
 		improves performance for heavier REQ_META workloads.
+	pause_writeback n	(default: 3000)
+		pause writeback if there was some write I/O redirected to
+		the origin volume in the last n milliseconds
 
 Status:
 1. error indicator - 0 if there was no error, otherwise error number

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

