Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B8BC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:21:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C245564E0F
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C245564E0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612434073;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hZT27bqSovztwLbfO33iu962+1Nnj3t2ONodbGI9FoI=;
	b=M/ElBISqwijmlMm77NDaQcUkqIRQHbGtkhFTmC0llUGrAUN0xgJBjdeOjSQ5ElJ+zVUi4G
	3jcJOgS6DCQE9uH2cV51jEyTkzmWIDME3n7tGCjeIQlOd199ysoCieIw0JA0st98sQjXcY
	lkLQ4Z5ZNB5iFhOdOhEDualBHE5vAg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-YWp2uMWcM-u6Vzv0DJkGsQ-1; Thu, 04 Feb 2021 05:21:06 -0500
X-MC-Unique: YWp2uMWcM-u6Vzv0DJkGsQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC015100CA87;
	Thu,  4 Feb 2021 10:21:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 108795B695;
	Thu,  4 Feb 2021 10:21:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 03B5E18095CB;
	Thu,  4 Feb 2021 10:20:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114AKuSF030601 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 05:20:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6281760C73; Thu,  4 Feb 2021 10:20:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E6AD60C13;
	Thu,  4 Feb 2021 10:20:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 114AKqla006761; Thu, 4 Feb 2021 05:20:52 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 114AKqe4006758; Thu, 4 Feb 2021 05:20:52 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 4 Feb 2021 05:20:52 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, David Teigland <teigland@redhat.com>
Message-ID: <alpine.LRH.2.02.2102040519550.3912@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm writecache: return the exact values that were
	set
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

LVM doesn't like it when the target returns different values from what was
set in the constructor. This patch fixes dm-writecache, so that the
returned values are exactly the same as requested values.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.18+

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -159,14 +159,22 @@ struct dm_writecache {
 	bool overwrote_committed:1;
 	bool memory_vmapped:1;
 
+	bool start_sector_set:1;
 	bool high_wm_percent_set:1;
 	bool low_wm_percent_set:1;
 	bool max_writeback_jobs_set:1;
 	bool autocommit_blocks_set:1;
 	bool autocommit_time_set:1;
+	bool max_age_set:1;
 	bool writeback_fua_set:1;
 	bool flush_on_suspend:1;
 	bool cleaner:1;
+	bool cleaner_set:1;
+
+	unsigned high_wm_percent_value;
+	unsigned low_wm_percent_value;
+	unsigned autocommit_time_value;
+	unsigned max_age_value;
 
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
@@ -2205,6 +2213,7 @@ static int writecache_ctr(struct dm_targ
 			if (sscanf(string, "%llu%c", &start_sector, &dummy) != 1)
 				goto invalid_optional;
 			wc->start_sector = start_sector;
+			wc->start_sector_set = true;
 			if (wc->start_sector != start_sector ||
 			    wc->start_sector >= wc->memory_map_size >> SECTOR_SHIFT)
 				goto invalid_optional;
@@ -2214,6 +2223,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (high_wm_percent < 0 || high_wm_percent > 100)
 				goto invalid_optional;
+			wc->high_wm_percent_value = high_wm_percent;
 			wc->high_wm_percent_set = true;
 		} else if (!strcasecmp(string, "low_watermark") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2221,6 +2231,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (low_wm_percent < 0 || low_wm_percent > 100)
 				goto invalid_optional;
+			wc->low_wm_percent_value = low_wm_percent;
 			wc->low_wm_percent_set = true;
 		} else if (!strcasecmp(string, "writeback_jobs") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2240,6 +2251,7 @@ static int writecache_ctr(struct dm_targ
 			if (autocommit_msecs > 3600000)
 				goto invalid_optional;
 			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
+			wc->autocommit_time_value = autocommit_msecs;
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
 			unsigned max_age_msecs;
@@ -2249,7 +2261,10 @@ static int writecache_ctr(struct dm_targ
 			if (max_age_msecs > 86400000)
 				goto invalid_optional;
 			wc->max_age = msecs_to_jiffies(max_age_msecs);
+			wc->max_age_set = true;
+			wc->max_age_value = max_age_msecs;
 		} else if (!strcasecmp(string, "cleaner")) {
+			wc->cleaner_set = true;
 			wc->cleaner = true;
 		} else if (!strcasecmp(string, "fua")) {
 			if (WC_MODE_PMEM(wc)) {
@@ -2455,7 +2470,6 @@ static void writecache_status(struct dm_
 	struct dm_writecache *wc = ti->private;
 	unsigned extra_args;
 	unsigned sz = 0;
-	uint64_t x;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2467,11 +2481,11 @@ static void writecache_status(struct dm_
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
 				wc->dev->name, wc->ssd_dev->name, wc->block_size);
 		extra_args = 0;
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			extra_args += 2;
-		if (wc->high_wm_percent_set && !wc->cleaner)
+		if (wc->high_wm_percent_set)
 			extra_args += 2;
-		if (wc->low_wm_percent_set && !wc->cleaner)
+		if (wc->low_wm_percent_set)
 			extra_args += 2;
 		if (wc->max_writeback_jobs_set)
 			extra_args += 2;
@@ -2479,37 +2493,29 @@ static void writecache_status(struct dm_
 			extra_args += 2;
 		if (wc->autocommit_time_set)
 			extra_args += 2;
-		if (wc->max_age != MAX_AGE_UNSPECIFIED)
+		if (wc->max_age_set)
 			extra_args += 2;
-		if (wc->cleaner)
+		if (wc->cleaner_set)
 			extra_args++;
 		if (wc->writeback_fua_set)
 			extra_args++;
 
 		DMEMIT("%u", extra_args);
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			DMEMIT(" start_sector %llu", (unsigned long long)wc->start_sector);
-		if (wc->high_wm_percent_set && !wc->cleaner) {
-			x = (uint64_t)wc->freelist_high_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" high_watermark %u", 100 - (unsigned)x);
-		}
-		if (wc->low_wm_percent_set && !wc->cleaner) {
-			x = (uint64_t)wc->freelist_low_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" low_watermark %u", 100 - (unsigned)x);
-		}
+		if (wc->high_wm_percent_set)
+			DMEMIT(" high_watermark %u", wc->high_wm_percent_value);
+		if (wc->low_wm_percent_set)
+			DMEMIT(" low_watermark %u", wc->low_wm_percent_value);
 		if (wc->max_writeback_jobs_set)
 			DMEMIT(" writeback_jobs %u", wc->max_writeback_jobs);
 		if (wc->autocommit_blocks_set)
 			DMEMIT(" autocommit_blocks %u", wc->autocommit_blocks);
 		if (wc->autocommit_time_set)
-			DMEMIT(" autocommit_time %u", jiffies_to_msecs(wc->autocommit_jiffies));
-		if (wc->max_age != MAX_AGE_UNSPECIFIED)
-			DMEMIT(" max_age %u", jiffies_to_msecs(wc->max_age));
-		if (wc->cleaner)
+			DMEMIT(" autocommit_time %u", wc->autocommit_time_value);
+		if (wc->max_age_set)
+			DMEMIT(" max_age %u", wc->max_age_value);
+		if (wc->cleaner_set)
 			DMEMIT(" cleaner");
 		if (wc->writeback_fua_set)
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
@@ -2519,7 +2525,7 @@ static void writecache_status(struct dm_
 
 static struct target_type writecache_target = {
 	.name			= "writecache",
-	.version		= {1, 3, 0},
+	.version		= {1, 4, 0},
 	.module			= THIS_MODULE,
 	.ctr			= writecache_ctr,
 	.dtr			= writecache_dtr,

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

