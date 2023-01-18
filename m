Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 340C8C32793
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674046090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eTyYcffuwG+KRg+gZYszfLUOw+0PjAW01oFi3FPVT+A=;
	b=OOlZAmUCR91fiXql0KXJwyqLY3qiyrxfkjE4VnzqxtAtFpE4uS3c9cs6W3DCH3HPAyNl9V
	BbDtW5rUWxl4WedLpQGnBZ72fA80FMl2nd8oS7kQYdR/ads8FWhvgZkjOpRcC41F5gr6bU
	OnjTrtfwpZViaRLX3mDsSYqyZIZ+5xA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-_6P-62W0OiSlit6bsnoKMA-1; Wed, 18 Jan 2023 07:48:06 -0500
X-MC-Unique: _6P-62W0OiSlit6bsnoKMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7CDB100F903;
	Wed, 18 Jan 2023 12:48:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9428F1400AFC;
	Wed, 18 Jan 2023 12:48:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5447B1946A6B;
	Wed, 18 Jan 2023 12:48:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77BA419465B7
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Jan 2023 12:29:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D0112026FFB; Wed, 18 Jan 2023 12:29:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6304E2026D76
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 12:29:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44DEC85C6E1
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 12:29:59 +0000 (UTC)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-UVeWbd4xM-qskLZ3UpG-Xg-1; Wed, 18 Jan 2023 07:29:57 -0500
X-MC-Unique: UVeWbd4xM-qskLZ3UpG-Xg-1
Received: by mail-wm1-f44.google.com with SMTP id
 f12-20020a7bc8cc000000b003daf6b2f9b9so1286260wml.3
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 04:29:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=BvVmoN6/yrQXLLAxB1qU+VaJPP6puzpFYPAhDzjAYDo=;
 b=c+dPa5f53sbJSxcIB/4UOchgHMJG6fXIe7YF2y9seLKkwpQ2MV+EmS/qIx2reHhapa
 9KxK2lxeYkOdQVURSUcvmXvJeeXnKp8Bh5/nBKbesGpt3/mIBepoZ3kkIgnFO6/3ng2U
 kg1g2FbH63z1V4DN3MsuXOefFOkAmWV1EEHatc21MRHaghh3vCbIqtOvqkkx9fe73iCD
 s0N+kSe7oU2TPyS+IBjMt7spmgd5P929t0yI/04XX1SOZt8daeBHoU+Xpcr7UOuQfxsh
 ngyXo2yKPJkgcx3J5n4ur3XbFA1nO3giFKpWM+o7VwJgJxw/YUcmARSb6TIVrNhHw1rd
 Sc+w==
X-Gm-Message-State: AFqh2kpv+5xE7O0baJblx1iPN4btgogvWWWK7a/SvqTwhJS0jPxt4NBz
 PcaUb32SH6W3VP0fjzhPV9ucaKlbH4aiYEOg
X-Google-Smtp-Source: AMrXdXuEJkC/jBjOa9DzjiUDNIDEl9pJF2a9EYMTg39Adp19O4osTnWlFyKafsHZg+8UtKSh7pJv5Q==
X-Received: by 2002:a05:600c:34ce:b0:3db:25f:be9e with SMTP id
 d14-20020a05600c34ce00b003db025fbe9emr6496648wmq.33.1674044996390; 
 Wed, 18 Jan 2023 04:29:56 -0800 (PST)
Received: from marvin.hq.arr ([185.109.18.135])
 by smtp.gmail.com with ESMTPSA id
 n42-20020a05600c3baa00b003d9f14e9085sm2099344wms.17.2023.01.18.04.29.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Jan 2023 04:29:55 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@kernel.org,
	agk@redhat.com,
	dm-devel@redhat.com
Date: Wed, 18 Jan 2023 14:29:46 +0200
Message-Id: <20230118122946.20435-3-ntsironis@arrikto.com>
In-Reply-To: <20230118122946.20435-1-ntsironis@arrikto.com>
References: <20230118122946.20435-1-ntsironis@arrikto.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 2/2] dm era: avoid deadlock when swapping table
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
Cc: ejt@redhat.com, ntsironis@arrikto.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Under certain conditions, swapping a table, that includes a dm-era
target, with a new table, causes a deadlock.

This happens when a status (STATUSTYPE_INFO) or message IOCTL is blocked
in the suspended dm-era target.

dm-era executes all metadata operations in a worker thread, which stops
processing requests when the target is suspended, and resumes again when
the target is resumed.

So, running 'dmsetup status' or 'dmsetup message' for a suspended dm-era
device blocks, until the device is resumed.

If we then load a new table to the device, while the aforementioned
dmsetup command is blocked in dm-era, and resume the device, we
deadlock.

The problem is that the 'dmsetup status' and 'dmsetup message' commands
hold a reference to the live table, i.e., they hold an SRCU read lock on
md->io_barrier, while they are blocked.

When the device is resumed, the old table is replaced with the new one
by dm_swap_table(), which ends up calling synchronize_srcu() on
md->io_barrier.

Since the blocked dmsetup command is holding the SRCU read lock, and the
old table is never resumed, 'dmsetup resume' blocks too, and we have a
deadlock.

The only way to recover is by rebooting.

Fix this by allowing metadata operations triggered by user space to run
in the corresponding user space thread, instead of queueing them for
execution by the dm-era worker thread.

This way, even if the device is suspended, the metadata operations will
run and release the SRCU read lock, preventing a subsequent table reload
(dm_swap_table()) from deadlocking.

To make this possible use a mutex to serialize access to the metadata
between the worker thread and the user space threads.

Fixes: eec40579d8487 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 58 ++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 3332bed2f412..c57a19320dbf 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/mutex.h>
 
 #define DM_MSG_PREFIX "era"
 
@@ -1182,6 +1183,12 @@ struct era {
 	dm_block_t nr_blocks;
 	uint32_t sectors_per_block;
 	int sectors_per_block_shift;
+
+	/*
+	 * Serialize access to metadata between worker thread and user space
+	 * threads.
+	 */
+	struct mutex metadata_lock;
 	struct era_metadata *md;
 
 	struct workqueue_struct *wq;
@@ -1358,10 +1365,12 @@ static void do_work(struct work_struct *ws)
 {
 	struct era *era = container_of(ws, struct era, worker);
 
+	mutex_lock(&era->metadata_lock);
 	kick_off_digest(era);
 	process_old_eras(era);
 	process_deferred_bios(era);
 	process_rpc_calls(era);
+	mutex_unlock(&era->metadata_lock);
 }
 
 static void defer_bio(struct era *era, struct bio *bio)
@@ -1400,17 +1409,6 @@ static int in_worker0(struct era *era, int (*fn)(struct era_metadata *))
 	return perform_rpc(era, &rpc);
 }
 
-static int in_worker1(struct era *era,
-		      int (*fn)(struct era_metadata *, void *), void *arg)
-{
-	struct rpc rpc;
-	rpc.fn0 = NULL;
-	rpc.fn1 = fn;
-	rpc.arg = arg;
-
-	return perform_rpc(era, &rpc);
-}
-
 static void start_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 0);
@@ -1439,6 +1437,7 @@ static void era_destroy(struct era *era)
 	if (era->metadata_dev)
 		dm_put_device(era->ti, era->metadata_dev);
 
+	mutex_destroy(&era->metadata_lock);
 	kfree(era);
 }
 
@@ -1539,6 +1538,8 @@ static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	spin_lock_init(&era->rpc_lock);
 	INIT_LIST_HEAD(&era->rpc_calls);
 
+	mutex_init(&era->metadata_lock);
+
 	ti->private = era;
 	ti->num_flush_bios = 1;
 	ti->flush_supported = true;
@@ -1591,7 +1592,9 @@ static void era_postsuspend(struct dm_target *ti)
 
 	stop_worker(era);
 
+	mutex_lock(&era->metadata_lock);
 	r = metadata_commit(era->md);
+	mutex_unlock(&era->metadata_lock);
 	if (r) {
 		DMERR("%s: metadata_commit failed", __func__);
 		/* FIXME: fail mode */
@@ -1605,19 +1608,23 @@ static int era_preresume(struct dm_target *ti)
 	dm_block_t new_size = calc_nr_blocks(era);
 
 	if (era->nr_blocks != new_size) {
+		mutex_lock(&era->metadata_lock);
 		r = metadata_resize(era->md, &new_size);
 		if (r) {
 			DMERR("%s: metadata_resize failed", __func__);
+			mutex_unlock(&era->metadata_lock);
 			return r;
 		}
 
 		r = metadata_commit(era->md);
 		if (r) {
 			DMERR("%s: metadata_commit failed", __func__);
+			mutex_unlock(&era->metadata_lock);
 			return r;
 		}
 
 		era->nr_blocks = new_size;
+		mutex_unlock(&era->metadata_lock);
 	}
 
 	start_worker(era);
@@ -1648,7 +1655,9 @@ static void era_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		r = in_worker1(era, metadata_get_stats, &stats);
+		mutex_lock(&era->metadata_lock);
+		r = metadata_get_stats(era->md, &stats);
+		mutex_unlock(&era->metadata_lock);
 		if (r)
 			goto err;
 
@@ -1682,6 +1691,25 @@ static void era_status(struct dm_target *ti, status_type_t type,
 	DMEMIT("Error");
 }
 
+static int _process_message(struct era *era, int (*fn)(struct era_metadata *))
+{
+	int ret, r;
+
+	mutex_lock(&era->metadata_lock);
+	ret = fn(era->md);
+	r = metadata_commit(era->md);
+	mutex_unlock(&era->metadata_lock);
+
+	/* Handle return value the same way as process_rpc_calls() does */
+	if (r)
+		ret = r;
+
+	/* Wake worker to handle archived writesets */
+	wake_worker(era);
+
+	return ret;
+}
+
 static int era_message(struct dm_target *ti, unsigned argc, char **argv,
 		       char *result, unsigned maxlen)
 {
@@ -1693,13 +1721,13 @@ static int era_message(struct dm_target *ti, unsigned argc, char **argv,
 	}
 
 	if (!strcasecmp(argv[0], "checkpoint"))
-		return in_worker0(era, metadata_checkpoint);
+		return _process_message(era, metadata_checkpoint);
 
 	if (!strcasecmp(argv[0], "take_metadata_snap"))
-		return in_worker0(era, metadata_take_snap);
+		return _process_message(era, metadata_take_snap);
 
 	if (!strcasecmp(argv[0], "drop_metadata_snap"))
-		return in_worker0(era, metadata_drop_snap);
+		return _process_message(era, metadata_drop_snap);
 
 	DMERR("unsupported message '%s'", argv[0]);
 	return -EINVAL;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

