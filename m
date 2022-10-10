Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11270C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 10 Oct 2022 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665405455;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QzqJNOoyv1KLI8/ZtK/ot91yyOCJ3noGA279gM+1Y7I=;
	b=T/xIx/XqhFIY+vV4/2U4IPeyKr0Bm5WMUa6+vaGMCYwBxKdQAcx8uDP6/58bXCLmFdyNZy
	ThLvA15bKaBwiFgKDQlLiuyQP04cZ/3ZuMYR/z7nmPQYJllOOlyJPQ4K7PthAbYSP0EbUc
	mezFCibl+XsrId6JgkSF2dBbOOLycqg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-UvR4B9IzOQGQtdspXvh7rw-1; Mon, 10 Oct 2022 08:37:34 -0400
X-MC-Unique: UvR4B9IzOQGQtdspXvh7rw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86F1F811E87;
	Mon, 10 Oct 2022 12:37:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 76271492B07;
	Mon, 10 Oct 2022 12:37:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4305C19465A0;
	Mon, 10 Oct 2022 12:37:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 67C681946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Oct 2022 12:37:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 487A440E992D; Mon, 10 Oct 2022 12:37:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 388AC40E992A;
 Mon, 10 Oct 2022 12:37:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29ACbVno026797; Mon, 10 Oct 2022 08:37:31 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29ACbV8t026793; Mon, 10 Oct 2022 08:37:31 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 10 Oct 2022 08:37:31 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2210100811400.25650@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2210100836570.25650@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2210100811400.25650@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 4/4] persistent-data: reduce lock contention
 while walking the btree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch reduces lock contention in btree walks. We modify the
functions init_ro_wpin, exit_ro_spine and ro_step so that they use
dm_bufio_lock_read/dm_bufio_get_unlocked/dm_bufio_unlock_read. If
dm_bm_fast_get_block fails, we fallback to normal locking.

When doing tests on pmem and fully provisioned thin volume, it improves
thoughput from 286MiB/s to 442MiB/s.

fio --ioengine=psync --iodepth=1 --rw=randrw --bs=4k --direct=1 --numjobs=12 --time_based --runtime=10 --group_reporting --name=/dev/vg/thin
before:
READ: bw=286MiB/s
WRITE: bw=286MiB/s
after:
READ: bw=442MiB/s
WRITE: bw=442MiB/s

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/persistent-data/dm-block-manager.c       |   32 ++++++++++++++++
 drivers/md/persistent-data/dm-block-manager.h       |    6 +++
 drivers/md/persistent-data/dm-btree-internal.h      |    2 +
 drivers/md/persistent-data/dm-btree-spine.c         |   39 ++++++++++++++++++--
 drivers/md/persistent-data/dm-transaction-manager.c |   17 ++++++++
 drivers/md/persistent-data/dm-transaction-manager.h |    6 +++
 6 files changed, 99 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-block-manager.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.c	2022-10-10 11:26:03.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-block-manager.c	2022-10-10 11:32:20.000000000 +0200
@@ -601,6 +601,38 @@ void dm_bm_unlock(struct dm_block *b)
 }
 EXPORT_SYMBOL_GPL(dm_bm_unlock);
 
+void dm_bm_fast_lock(struct dm_block_manager *bm)
+{
+	dm_bufio_lock_read(bm->bufio);
+}
+
+void dm_bm_fast_unlock(struct dm_block_manager *bm)
+{
+	dm_bufio_unlock_read(bm->bufio);
+}
+
+int dm_bm_fast_get_block(struct dm_block_manager *bm,
+			 dm_block_t b, struct dm_block_validator *v,
+			 struct dm_block **result)
+{
+	int r;
+	struct buffer_aux *aux;
+	void *p;
+
+	p = dm_bufio_get_unlocked(bm->bufio, b, (struct dm_buffer **) result);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+	if (unlikely(!p))
+		return -EWOULDBLOCK;
+
+	aux = dm_bufio_get_aux_data(to_buffer(*result));
+	r = dm_bm_validate_buffer(bm, to_buffer(*result), aux, v);
+	if (unlikely(r))
+		return r;
+
+	return 0;
+}
+
 int dm_bm_flush(struct dm_block_manager *bm)
 {
 	if (dm_bm_is_read_only(bm))
Index: linux-2.6/drivers/md/persistent-data/dm-block-manager.h
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.h	2022-10-10 11:26:03.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-block-manager.h	2022-10-10 11:31:24.000000000 +0200
@@ -96,6 +96,12 @@ int dm_bm_write_lock_zero(struct dm_bloc
 
 void dm_bm_unlock(struct dm_block *b);
 
+void dm_bm_fast_lock(struct dm_block_manager *bm);
+void dm_bm_fast_unlock(struct dm_block_manager *bm);
+int dm_bm_fast_get_block(struct dm_block_manager *bm,
+			 dm_block_t b, struct dm_block_validator *v,
+			 struct dm_block **result);
+
 /*
  * It's a common idiom to have a superblock that should be committed last.
  *
Index: linux-2.6/drivers/md/persistent-data/dm-btree-internal.h
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-internal.h	2022-10-10 11:26:03.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-btree-internal.h	2022-10-10 11:26:03.000000000 +0200
@@ -64,6 +64,8 @@ struct ro_spine {
 	struct dm_btree_info *info;
 
 	struct dm_block *node;
+	bool fast_locked;
+	bool fast_lock_failed;
 };
 
 void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
Index: linux-2.6/drivers/md/persistent-data/dm-btree-spine.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-spine.c	2022-10-10 11:26:03.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-btree-spine.c	2022-10-10 11:38:00.000000000 +0200
@@ -118,27 +118,60 @@ void unlock_block(struct dm_btree_info *
 	dm_tm_unlock(info->tm, b);
 }
 
+static void bn_fast_lock(struct dm_btree_info *info)
+{
+	dm_tm_fast_lock(info->tm);
+}
+
+static void bn_fast_unlock(struct dm_btree_info *info)
+{
+	dm_tm_fast_unlock(info->tm);
+}
+
+static int bn_fast_get_block(struct dm_btree_info *info, dm_block_t b,
+		      struct dm_block **result)
+{
+	return dm_tm_fast_get_block(info->tm, b, &btree_node_validator, result);
+}
+
 /*----------------------------------------------------------------*/
 
 void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info)
 {
 	s->info = info;
 	s->node = NULL;
+	s->fast_locked = false;
+	s->fast_lock_failed = false;
 }
 
 void exit_ro_spine(struct ro_spine *s)
 {
-	if (s->node)
+	if (s->fast_locked)
+		bn_fast_unlock(s->info);
+	else if (s->node)
 		unlock_block(s->info, s->node);
 }
 
 int ro_step(struct ro_spine *s, dm_block_t new_child)
 {
 	if (s->node) {
-		unlock_block(s->info, s->node);
+		if (unlikely(!s->fast_locked))
+			unlock_block(s->info, s->node);
 		s->node = NULL;
 	}
-
+	if (likely(!s->fast_lock_failed)) {
+		int r;
+		if (!s->fast_locked) {
+			bn_fast_lock(s->info);
+			s->fast_locked = true;
+		}
+		r = bn_fast_get_block(s->info, new_child, &s->node);
+		if (likely(!r))
+			return 0;
+		s->fast_lock_failed = true;
+		s->fast_locked = false;
+		bn_fast_unlock(s->info);
+	}
 	return bn_read_lock(s->info, new_child, &s->node);
 }
 
Index: linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.c	2022-10-10 11:26:03.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c	2022-10-10 11:50:50.000000000 +0200
@@ -348,6 +348,23 @@ void dm_tm_unlock(struct dm_transaction_
 }
 EXPORT_SYMBOL_GPL(dm_tm_unlock);
 
+void dm_tm_fast_lock(struct dm_transaction_manager *tm)
+{
+	dm_bm_fast_lock(tm->is_clone ? tm->real->bm : tm->bm);
+}
+
+void dm_tm_fast_unlock(struct dm_transaction_manager *tm)
+{
+	dm_bm_fast_unlock(tm->is_clone ? tm->real->bm : tm->bm);
+}
+
+int dm_tm_fast_get_block(struct dm_transaction_manager *tm, dm_block_t b,
+			 struct dm_block_validator *v,
+			 struct dm_block **blk)
+{
+	return dm_bm_fast_get_block(tm->is_clone ? tm->real->bm : tm->bm, b, v, blk);
+}
+
 void dm_tm_inc(struct dm_transaction_manager *tm, dm_block_t b)
 {
 	/*
Index: linux-2.6/drivers/md/persistent-data/dm-transaction-manager.h
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.h	2022-10-10 11:26:03.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.h	2022-10-10 11:30:17.000000000 +0200
@@ -96,6 +96,12 @@ int dm_tm_read_lock(struct dm_transactio
 
 void dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b);
 
+void dm_tm_fast_lock(struct dm_transaction_manager *tm);
+void dm_tm_fast_unlock(struct dm_transaction_manager *tm);
+int dm_tm_fast_get_block(struct dm_transaction_manager *tm, dm_block_t b,
+			 struct dm_block_validator *v,
+			 struct dm_block **blk);
+
 /*
  * Functions for altering the reference count of a block directly.
  */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

