Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E272C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644591807;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uJah5WItIXeGGCr9x8ZJqodNxQCmvEK39IiiufQiWqU=;
	b=fzJnnXEPZl7OJV+Mqjuy63q6qrCWYy7LAeM5bqN0OAXWjZxug/XCQhNXKBuo0R/uYDj8hP
	+xPnigf3UsJxuLt+499+PF7tXQSQVc/bEJoWn63F8WaC5iSuwYkmix7MzHLApFzvGv8B/M
	9FIxeq7JKY9Dt4NmIg1xFMt1mmDmgy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-NPsmy-yrMbaYGHa_3BTT7g-1; Fri, 11 Feb 2022 10:03:26 -0500
X-MC-Unique: NPsmy-yrMbaYGHa_3BTT7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 693D51091DAA;
	Fri, 11 Feb 2022 15:03:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 448585B280;
	Fri, 11 Feb 2022 15:03:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE1A44BB7C;
	Fri, 11 Feb 2022 15:03:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BF3JTF025452 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 10:03:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6DF588049C; Fri, 11 Feb 2022 15:03:19 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A28E7D93E;
	Fri, 11 Feb 2022 15:03:19 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 21BF3IOB032122; Fri, 11 Feb 2022 10:03:18 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 21BF3IcO032118; Fri, 11 Feb 2022 10:03:18 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 11 Feb 2022 10:03:18 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2202111001560.30005@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm: account statistics correctly in case of bio
	split
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

If a bio was split to multiple targets, only one target's sub-range was
counted. This patch changes it so that all the targets' ranges are
counted.

Note that calls to bio_start_io_acct_remapped and bio_end_io_acct must
match, so we maintain a counter how many times we have called
bio_start_io_acct_remapped. When the io finishes, we call end_io_acct
repeatedly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h |    2 +-
 drivers/md/dm.c      |   39 ++++++++++++++++++++-------------------
 2 files changed, 21 insertions(+), 20 deletions(-)

Index: linux-dm/drivers/md/dm-core.h
===================================================================
--- linux-dm.orig/drivers/md/dm-core.h	2022-02-11 15:44:33.000000000 +0100
+++ linux-dm/drivers/md/dm-core.h	2022-02-11 15:44:33.000000000 +0100
@@ -230,7 +230,7 @@ struct dm_io {
 	atomic_t io_count;
 	struct bio *orig_bio;
 	unsigned long start_time;
-	int was_accounted;
+	atomic_t n_accounted;
 	spinlock_t lock;
 	struct dm_stats_aux stats_aux;
 	/* last member of dm_target_io is 'struct bio' */
Index: linux-dm/drivers/md/dm.c
===================================================================
--- linux-dm.orig/drivers/md/dm.c	2022-02-11 15:44:33.000000000 +0100
+++ linux-dm/drivers/md/dm.c	2022-02-11 15:52:04.000000000 +0100
@@ -487,27 +487,30 @@ EXPORT_SYMBOL_GPL(dm_start_time_ns_from_
 
 static void start_io_acct(struct dm_io *io, struct bio *bio)
 {
-	struct bio *orig_bio;
-
-	/* Ensure IO accounting is only ever started once */
-	if (xchg(&io->was_accounted, 1) == 1)
-		return;
-
-	orig_bio = io->orig_bio;
+	struct bio *orig_bio = io->orig_bio;
 
 	bio_start_io_acct_remapped(bio, io->start_time,
 				   orig_bio->bi_bdev);
 
-	if (unlikely(dm_stats_used(&io->md->stats)))
+	if (unlikely(dm_stats_used(&io->md->stats))) {
+		if (unlikely(atomic_inc_return(&io->n_accounted) != 1))
+			return;
 		dm_stats_account_io(&io->md->stats, bio_data_dir(orig_bio),
 				    orig_bio->bi_iter.bi_sector, bio_sectors(orig_bio),
 				    false, 0, &io->stats_aux);
+	} else {
+		atomic_inc(&io->n_accounted);
+	}
 }
 
-static void end_io_acct(struct mapped_device *md, struct bio *bio,
+static void end_io_acct(struct mapped_device *md, unsigned n_accounted, struct bio *bio,
 			unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
-	bio_end_io_acct(bio, start_time);
+	if (unlikely(!n_accounted))
+		return;
+	do {
+		bio_end_io_acct(bio, start_time);
+	} while (unlikely(--n_accounted));
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
@@ -536,7 +539,7 @@ static struct dm_io *alloc_io(struct map
 	spin_lock_init(&io->lock);
 
 	io->start_time = jiffies;
-	io->was_accounted = 0;
+	io->n_accounted = (atomic_t)ATOMIC_INIT(0);
 
 	return io;
 }
@@ -793,7 +796,7 @@ void dm_io_dec_pending(struct dm_io *io,
 	blk_status_t io_error;
 	struct bio *bio;
 	struct mapped_device *md = io->md;
-	bool was_accounted = false;
+	int n_accounted;
 	unsigned long start_time = 0;
 	struct dm_stats_aux stats_aux;
 
@@ -827,14 +830,12 @@ void dm_io_dec_pending(struct dm_io *io,
 		}
 
 		io_error = io->status;
-		if (io->was_accounted) {
-			was_accounted = true;
-			start_time = io->start_time;
-			stats_aux = io->stats_aux;
-		}
+		n_accounted = atomic_read(&io->n_accounted);
+		start_time = io->start_time;
+		stats_aux = io->stats_aux;
+
 		free_io(io);
-		if (was_accounted)
-			end_io_acct(md, bio, start_time, &stats_aux);
+		end_io_acct(md, n_accounted, bio, start_time, &stats_aux);
 
 		/* nudge anyone waiting on suspend queue */
 		if (unlikely(wq_has_sleeper(&md->wait)))

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

