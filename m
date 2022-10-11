Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACF4C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665515429;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DW0+ibgsKYwZqJpuje6XQBqs4YMt/ubpvllFSchnVr4=;
	b=Bas1WHC+jw02UWmox5HkU+boGXSb5QDGsgDGgcxI/KUzymv86X2NzbhwV78RhOGnoK447T
	TyPPRNvju0lK0+MGHGu90uEb9lwnHCTEu+CpR8vzO6q5Fe42/PrpfSrmguVi/i0AZXOth8
	gMlRMQtSn/U77eOcAS3gSoU+UnLGWCc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-C1XTIwIhMBSJD-ZvLHn9hg-1; Tue, 11 Oct 2022 15:10:25 -0400
X-MC-Unique: C1XTIwIhMBSJD-ZvLHn9hg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 368511C05AAD;
	Tue, 11 Oct 2022 19:10:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98C61207B36F;
	Tue, 11 Oct 2022 19:10:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DEA01946594;
	Tue, 11 Oct 2022 19:10:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8FB7C194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Oct 2022 19:10:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 205E14B4019; Tue, 11 Oct 2022 19:10:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 12F954B4018;
 Tue, 11 Oct 2022 19:10:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29BJAJ4j018470; Tue, 11 Oct 2022 15:10:19 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29BJAJ5U018466; Tue, 11 Oct 2022 15:10:19 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 11 Oct 2022 15:10:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <alpine.LRH.2.02.2210111505160.18298@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 4/4 v2] persistent-data: reduce lock contention
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

Here I'm sending updated patch 4 that fixes hang on discard. We must not 
do the optimization in dm_btree_lookup_next.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

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
 drivers/md/persistent-data/dm-block-manager.c       |   32 +++++++++++++++
 drivers/md/persistent-data/dm-block-manager.h       |    6 ++
 drivers/md/persistent-data/dm-btree-internal.h      |    4 +
 drivers/md/persistent-data/dm-btree-spine.c         |   41 ++++++++++++++++++--
 drivers/md/persistent-data/dm-btree.c               |    6 +-
 drivers/md/persistent-data/dm-transaction-manager.c |   17 ++++++++
 drivers/md/persistent-data/dm-transaction-manager.h |    6 ++
 7 files changed, 104 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-block-manager.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.c
+++ linux-2.6/drivers/md/persistent-data/dm-block-manager.c
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
--- linux-2.6.orig/drivers/md/persistent-data/dm-block-manager.h
+++ linux-2.6/drivers/md/persistent-data/dm-block-manager.h
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
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-internal.h
+++ linux-2.6/drivers/md/persistent-data/dm-btree-internal.h
@@ -64,9 +64,11 @@ struct ro_spine {
 	struct dm_btree_info *info;
 
 	struct dm_block *node;
+	bool fast_locked;
+	bool fast_lock_failed;
 };
 
-void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
+void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info, bool disable_fast_access);
 void exit_ro_spine(struct ro_spine *s);
 int ro_step(struct ro_spine *s, dm_block_t new_child);
 struct btree_node *ro_node(struct ro_spine *s);
Index: linux-2.6/drivers/md/persistent-data/dm-btree-spine.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-spine.c
+++ linux-2.6/drivers/md/persistent-data/dm-btree-spine.c
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
 
-void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info)
+void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info, bool disable_fast_access)
 {
 	s->info = info;
 	s->node = NULL;
+	s->fast_locked = false;
+	s->fast_lock_failed = disable_fast_access;
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
--- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.c
+++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c
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
--- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.h
+++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.h
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
Index: linux-2.6/drivers/md/persistent-data/dm-btree.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree.c
+++ linux-2.6/drivers/md/persistent-data/dm-btree.c
@@ -377,7 +377,7 @@ int dm_btree_lookup(struct dm_btree_info
 	__le64 internal_value_le;
 	struct ro_spine spine;
 
-	init_ro_spine(&spine, info);
+	init_ro_spine(&spine, info, false);
 	for (level = 0; level < info->levels; level++) {
 		size_t size;
 		void *value_p;
@@ -472,7 +472,7 @@ int dm_btree_lookup_next(struct dm_btree
 	__le64 internal_value_le;
 	struct ro_spine spine;
 
-	init_ro_spine(&spine, info);
+	init_ro_spine(&spine, info, true);
 	for (level = 0; level < info->levels - 1u; level++) {
 		r = btree_lookup_raw(&spine, root, keys[level],
 				     lower_bound, rkey,
@@ -1369,7 +1369,7 @@ static int dm_btree_find_key(struct dm_b
 	int r = 0, count = 0, level;
 	struct ro_spine spine;
 
-	init_ro_spine(&spine, info);
+	init_ro_spine(&spine, info, false);
 	for (level = 0; level < info->levels; level++) {
 		r = find_key(&spine, root, find_highest, result_keys + level,
 			     level == info->levels - 1 ? NULL : &root);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

