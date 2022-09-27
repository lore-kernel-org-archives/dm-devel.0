Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB006C54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664287177;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kNo+MqpSu949cbknP2yDQUZnG2PRnV5lqhNsXbye6Rc=;
	b=Y4MDMMFX0Hc/fO5GXU10j/OpFepz1LIFNkRpbYHHz6IyFLaht3iH9sQZ2gUp6pdEMhUZs5
	NOLi8xA21N1iBF45uIEFXtnUFtMBqAyXLPYijRUwgCKxtpeL7+e1f2HVRJGTs35n8zpg5R
	Y/dStHSdTIz5dKGafk4PsO4LETiPQTU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-raE4PcvuNlKAgtpG3vYn6w-1; Tue, 27 Sep 2022 09:59:36 -0400
X-MC-Unique: raE4PcvuNlKAgtpG3vYn6w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64D463C01E13;
	Tue, 27 Sep 2022 13:59:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86CED40C2064;
	Tue, 27 Sep 2022 13:59:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C60719465B1;
	Tue, 27 Sep 2022 13:59:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBEFC1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 13:59:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC5BB40C6E14; Tue, 27 Sep 2022 13:59:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BBFFD40C6EC2;
 Tue, 27 Sep 2022 13:59:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28RDxVYn029160; Tue, 27 Sep 2022 09:59:31 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28RDxVxJ029156; Tue, 27 Sep 2022 09:59:31 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 27 Sep 2022 09:59:31 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <alpine.LRH.2.02.2209270943360.28431@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] A patch to reduce dm-bufio locking
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

Regarding that dm-bufio overhead, I created this patch.

The patch exports dm_bufio_lock, dm_bufio_trylock and dm_bufio_unlock and 
introduces a new function dm_bufio_get_unlocked.

dm_bufio_get_unlocked is like dm_bufio_get, except that it doesn't take 
the lock and it assumes that the client structure is already locked with 
dm_bufio_lock.

When you walk the thinp metadata, it is recommended that you call 
dm_bufio_lock, then you call dm_bufio_get_unlocked repeatedly for each 
b-tree level and finally you call dm_bufio_unlock. So, you can walk the 
b-tree with just one lock/unlock pair.

When dm_bufio_get_unlocked returns NULL (the block is not in cache), you 
must call dm_bufio_unlock and then read the data with dm_bufio_read as 
usual - in this situation, the I/O will be bottleneck rather than locking.

Mikulas



Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c    |   29 ++++++++++++++++++++++-------
 include/linux/dm-bufio.h |   15 +++++++++++++++
 2 files changed, 37 insertions(+), 7 deletions(-)

Index: linux-dm/drivers/md/dm-bufio.c
===================================================================
--- linux-dm.orig/drivers/md/dm-bufio.c	2022-09-05 13:29:52.000000000 +0200
+++ linux-dm/drivers/md/dm-bufio.c	2022-09-27 15:43:18.000000000 +0200
@@ -169,29 +169,32 @@ static DEFINE_STATIC_KEY_FALSE(no_sleep_
 
 #define dm_bufio_in_request()	(!!current->bio_list)
 
-static void dm_bufio_lock(struct dm_bufio_client *c)
+void dm_bufio_lock(struct dm_bufio_client *c)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_lock_bh(&c->spinlock);
 	else
 		mutex_lock_nested(&c->lock, dm_bufio_in_request());
 }
+EXPORT_SYMBOL_GPL(dm_bufio_lock);
 
-static int dm_bufio_trylock(struct dm_bufio_client *c)
+int dm_bufio_trylock(struct dm_bufio_client *c)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		return spin_trylock_bh(&c->spinlock);
 	else
 		return mutex_trylock(&c->lock);
 }
+EXPORT_SYMBOL_GPL(dm_bufio_trylock);
 
-static void dm_bufio_unlock(struct dm_bufio_client *c)
+void dm_bufio_unlock(struct dm_bufio_client *c)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		spin_unlock_bh(&c->spinlock);
 	else
 		mutex_unlock(&c->lock);
 }
+EXPORT_SYMBOL_GPL(dm_bufio_unlock);
 
 /*----------------------------------------------------------------*/
 
@@ -870,7 +873,8 @@ enum new_flag {
 	NF_FRESH = 0,
 	NF_READ = 1,
 	NF_GET = 2,
-	NF_PREFETCH = 3
+	NF_GET_UNLOCKED = 3,
+	NF_PREFETCH = 4
 };
 
 /*
@@ -1013,7 +1017,7 @@ static struct dm_buffer *__bufio_new(str
 	if (b)
 		goto found_buffer;
 
-	if (nf == NF_GET)
+	if (nf == NF_GET || nf == NF_GET_UNLOCKED)
 		return NULL;
 
 	new_b = __alloc_buffer_wait(c, nf);
@@ -1058,10 +1062,11 @@ found_buffer:
 	 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 	 * the same buffer, it would deadlock if we waited.
 	 */
-	if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
+	if ((nf == NF_GET || nf == NF_GET_UNLOCKED) && unlikely(test_bit(B_READING, &b->state)))
 		return NULL;
 
-	b->hold_count++;
+	b->hold_count += nf != NF_GET_UNLOCKED;
+
 	__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
 		     test_bit(B_WRITING, &b->state));
 	return b;
@@ -1154,6 +1159,16 @@ void *dm_bufio_new(struct dm_bufio_clien
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
Index: linux-dm/include/linux/dm-bufio.h
===================================================================
--- linux-dm.orig/include/linux/dm-bufio.h	2022-09-05 13:29:56.000000000 +0200
+++ linux-dm/include/linux/dm-bufio.h	2022-09-27 15:36:49.000000000 +0200
@@ -38,6 +38,14 @@ dm_bufio_client_create(struct block_devi
 void dm_bufio_client_destroy(struct dm_bufio_client *c);
 
 /*
+ * Lock and unlock the bufio client - this is needed if we want to call
+ * dm_bufio_get_unlocked.
+ */
+void dm_bufio_lock(struct dm_bufio_client *c);
+int dm_bufio_trylock(struct dm_bufio_client *c);
+void dm_bufio_unlock(struct dm_bufio_client *c);
+
+/*
  * Set the sector range.
  * When this function is called, there must be no I/O in progress on the bufio
  * client.
@@ -76,6 +84,13 @@ void *dm_bufio_new(struct dm_bufio_clien
 		   struct dm_buffer **bp);
 
 /*
+ * Like dm_bufio_get, but assume that the client is already locked with
+ * dm_bufio_lock/dm_bufio_unlock. dm_bufio_release should not be called;
+ * the caller should call dm_bufio_unlock to release the buffer.
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

