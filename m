Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79ECAC07E9D
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664294658;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KZHxTUZWbn3kLyCWKqeCxhBZWn8EV67aU6qFrIKsj38=;
	b=TfDO9f+oW3dvvA0/PnpGmep3t29vo+7uhAx+94vQLTUMidzbTnZQ9BgXQu6C3lKQ/KdQVY
	epCuiK0IBtFSP4zg1U4qhZIvJwHmef1Dwcm0PJ0o487KKLXXnfzZLzO5xDoTN8mP6xQXIe
	5J3yrWPWiDxRLhV1qQUOA0AOq1GmeaA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-hcyn05fFMQeU9UfuW-ChDg-1; Tue, 27 Sep 2022 12:04:16 -0400
X-MC-Unique: hcyn05fFMQeU9UfuW-ChDg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA0BC85A5A6;
	Tue, 27 Sep 2022 16:04:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95F27492B04;
	Tue, 27 Sep 2022 16:04:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 621EB19465B1;
	Tue, 27 Sep 2022 16:04:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 78B5C1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 16:04:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6446117582; Tue, 27 Sep 2022 16:04:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3835317595;
 Tue, 27 Sep 2022 16:04:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28RG4CkK005089; Tue, 27 Sep 2022 12:04:12 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28RG4CSf005085; Tue, 27 Sep 2022 12:04:12 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 27 Sep 2022 12:04:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2209270943360.28431@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2209271151120.1541@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209270943360.28431@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] A patch to reduce dm-bufio locking (version 2)
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

Hi

Here I'm sending the second version of the patch that takes only read lock 
and that allows parallel btree searches - so there will be only two 
cacheline bounces per bio (on down_read and up_read).

If nf == NF_GET_UNLOCKED, the patch only sets b->accessed, it doesn't 
relink lru or manipulate hold count, so it can be executed concurrently.

Mikulas


Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c    |   54 ++++++++++++++++++++++++++++++++++-------------
 include/linux/dm-bufio.h |   14 ++++++++++++
 2 files changed, 54 insertions(+), 14 deletions(-)

Index: linux-dm/drivers/md/dm-bufio.c
===================================================================
--- linux-dm.orig/drivers/md/dm-bufio.c	2022-09-27 17:41:50.000000000 +0200
+++ linux-dm/drivers/md/dm-bufio.c	2022-09-27 17:58:49.000000000 +0200
@@ -81,7 +81,7 @@
  *	context.
  */
 struct dm_bufio_client {
-	struct mutex lock;
+	struct rw_semaphore lock;
 	spinlock_t spinlock;
 	bool no_sleep;
 
@@ -145,7 +145,7 @@ struct dm_buffer {
 	unsigned char list_mode;		/* LIST_* */
 	blk_status_t read_error;
 	blk_status_t write_error;
-	unsigned accessed;
+	volatile unsigned accessed;
 	unsigned hold_count;
 	unsigned long state;
 	unsigned long last_accessed;
@@ -174,7 +174,7 @@ static void dm_bufio_lock(struct dm_bufi
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_lock_bh(&c->spinlock);
 	else
-		mutex_lock_nested(&c->lock, dm_bufio_in_request());
+		down_write_nested(&c->lock, dm_bufio_in_request());
 }
 
 static int dm_bufio_trylock(struct dm_bufio_client *c)
@@ -182,7 +182,7 @@ static int dm_bufio_trylock(struct dm_bu
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		return spin_trylock_bh(&c->spinlock);
 	else
-		return mutex_trylock(&c->lock);
+		return down_write_trylock(&c->lock);
 }
 
 static void dm_bufio_unlock(struct dm_bufio_client *c)
@@ -190,9 +190,21 @@ static void dm_bufio_unlock(struct dm_bu
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_unlock_bh(&c->spinlock);
 	else
-		mutex_unlock(&c->lock);
+		up_write(&c->lock);
 }
 
+void dm_bufio_lock_read(struct dm_bufio_client *c)
+{
+	down_read(&c->lock);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_lock_read);
+
+void dm_bufio_unlock_read(struct dm_bufio_client *c)
+{
+	up_read(&c->lock);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_unlock_read);
+
 /*----------------------------------------------------------------*/
 
 /*
@@ -870,7 +882,8 @@ enum new_flag {
 	NF_FRESH = 0,
 	NF_READ = 1,
 	NF_GET = 2,
-	NF_PREFETCH = 3
+	NF_GET_UNLOCKED = 3,
+	NF_PREFETCH = 4
 };
 
 /*
@@ -1013,7 +1026,7 @@ static struct dm_buffer *__bufio_new(str
 	if (b)
 		goto found_buffer;
 
-	if (nf == NF_GET)
+	if (nf == NF_GET || nf == NF_GET_UNLOCKED)
 		return NULL;
 
 	new_b = __alloc_buffer_wait(c, nf);
@@ -1058,12 +1071,17 @@ found_buffer:
 	 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 	 * the same buffer, it would deadlock if we waited.
 	 */
-	if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
+	if ((nf == NF_GET || nf == NF_GET_UNLOCKED) && unlikely(test_bit(B_READING, &b->state)))
 		return NULL;
 
-	b->hold_count++;
-	__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
-		     test_bit(B_WRITING, &b->state));
+	if (nf == NF_GET_UNLOCKED) {
+		if (!b->accessed)
+			b->accessed = 1;
+	} else {
+		b->hold_count++;
+		__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
+			     test_bit(B_WRITING, &b->state));
+	}
 	return b;
 }
 
@@ -1154,6 +1172,16 @@ void *dm_bufio_new(struct dm_bufio_clien
 }
 EXPORT_SYMBOL_GPL(dm_bufio_new);
 
+void *dm_bufio_get_unlocked(struct dm_bufio_client *c, sector_t block)
+{
+	int need_submit;
+	struct dm_buffer *b = __bufio_new(c, block, NF_GET_UNLOCKED, &need_submit, NULL);
+	if (b)
+		return b->data;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_unlocked);
+
 void dm_bufio_prefetch(struct dm_bufio_client *c,
 		       sector_t block, unsigned n_blocks)
 {
@@ -1777,7 +1805,7 @@ struct dm_bufio_client *dm_bufio_client_
 		c->n_buffers[i] = 0;
 	}
 
-	mutex_init(&c->lock);
+	init_rwsem(&c->lock);
 	spin_lock_init(&c->spinlock);
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
@@ -1856,7 +1884,6 @@ bad:
 	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
-	mutex_destroy(&c->lock);
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
@@ -1904,7 +1931,6 @@ void dm_bufio_client_destroy(struct dm_b
 	kmem_cache_destroy(c->slab_cache);
 	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
-	mutex_destroy(&c->lock);
 	if (c->no_sleep)
 		static_branch_dec(&no_sleep_enabled);
 	kfree(c);
Index: linux-dm/include/linux/dm-bufio.h
===================================================================
--- linux-dm.orig/include/linux/dm-bufio.h	2022-09-27 17:41:50.000000000 +0200
+++ linux-dm/include/linux/dm-bufio.h	2022-09-27 18:01:21.000000000 +0200
@@ -38,6 +38,13 @@ dm_bufio_client_create(struct block_devi
 void dm_bufio_client_destroy(struct dm_bufio_client *c);
 
 /*
+ * Lock and unlock the bufio client - this is needed if we want to call
+ * dm_bufio_get_unlocked.
+ */
+void dm_bufio_lock_read(struct dm_bufio_client *c);
+void dm_bufio_unlock_read(struct dm_bufio_client *c);
+
+/*
  * Set the sector range.
  * When this function is called, there must be no I/O in progress on the bufio
  * client.
@@ -76,6 +83,13 @@ void *dm_bufio_new(struct dm_bufio_clien
 		   struct dm_buffer **bp);
 
 /*
+ * Like dm_bufio_get, but assume that the client is already locked with
+ * dm_bufio_lock_read/dm_bufio_unlock_read. dm_bufio_release should not be
+ * called; the caller should call dm_bufio_unlock_read to release the buffer.
+ */
+void *dm_bufio_get_unlocked(struct dm_bufio_client *c, sector_t block);
+
+/*
  * Prefetch the specified blocks to the cache.
  * The function starts to read the blocks and returns without waiting for
  * I/O to finish.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

