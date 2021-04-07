Return-Path: <SRS0=vA/q=JE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AA4C433ED
	for <dm-devel@archiver.kernel.org>; Wed,  7 Apr 2021 13:44:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C588B611C9
	for <dm-devel@archiver.kernel.org>; Wed,  7 Apr 2021 13:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C588B611C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-3rV9zvTLOguz5psFO-7n_A-1; Wed, 07 Apr 2021 09:44:26 -0400
X-MC-Unique: 3rV9zvTLOguz5psFO-7n_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A96D8189D7;
	Wed,  7 Apr 2021 13:44:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7757819C46;
	Wed,  7 Apr 2021 13:44:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BEBD41C8F;
	Wed,  7 Apr 2021 13:44:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 137DiDHO022616 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 7 Apr 2021 09:44:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A3EF9114B9DD; Wed,  7 Apr 2021 13:44:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0DF3114B9DC
	for <dm-devel@redhat.com>; Wed,  7 Apr 2021 13:44:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCC5B185A7B6
	for <dm-devel@redhat.com>; Wed,  7 Apr 2021 13:44:09 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-209-msuriHu9OICAPjmc2Ah4bA-1; Wed, 07 Apr 2021 09:44:07 -0400
X-MC-Unique: msuriHu9OICAPjmc2Ah4bA-1
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lU8BT-00EWKg-51; Wed, 07 Apr 2021 13:25:41 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Date: Wed,  7 Apr 2021 14:25:22 +0100
Message-Id: <20210407132523.3460814-1-willy@infradead.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	"Matthew Wilcox \(Oracle\)" <willy@infradead.org>
Subject: [dm-devel] [PATCH] dm: Remove dm_vcalloc
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

Use kvcalloc or kvmalloc_array instead (depending whether zeroing is
useful).

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/dm-snap-persistent.c |  6 +++---
 drivers/md/dm-snap.c            |  5 +++--
 drivers/md/dm-table.c           | 30 ++++++------------------------
 include/linux/device-mapper.h   |  5 -----
 4 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 8e329c3f3a78..8e5775b5bd96 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -596,7 +596,7 @@ static void persistent_dtr(struct dm_exception_store *store)
 	free_area(ps);
 
 	/* Allocated in persistent_read_metadata */
-	vfree(ps->callbacks);
+	kvfree(ps->callbacks);
 
 	kfree(ps);
 }
@@ -621,8 +621,8 @@ static int persistent_read_metadata(struct dm_exception_store *store,
 	 */
 	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
 				  sizeof(struct disk_exception);
-	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
-				   sizeof(*ps->callbacks));
+	ps->callbacks = kvcalloc(ps->exceptions_per_area,
+				   sizeof(*ps->callbacks), GFP_KERNEL);
 	if (!ps->callbacks)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 11890db71f3f..8f3ad87e6117 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -663,7 +663,8 @@ static int dm_exception_table_init(struct dm_exception_table *et,
 
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
-	et->table = dm_vcalloc(size, sizeof(struct hlist_bl_head));
+	et->table = kvmalloc_array(size, sizeof(struct hlist_bl_head),
+			GFP_KERNEL);
 	if (!et->table)
 		return -ENOMEM;
 
@@ -689,7 +690,7 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 			kmem_cache_free(mem, ex);
 	}
 
-	vfree(et->table);
+	kvfree(et->table);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e5f0f1703c5d..2f38d00d125f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -94,24 +94,6 @@ static int setup_btree_index(unsigned int l, struct dm_table *t)
 	return 0;
 }
 
-void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size)
-{
-	unsigned long size;
-	void *addr;
-
-	/*
-	 * Check that we're not going to overflow.
-	 */
-	if (nmemb > (ULONG_MAX / elem_size))
-		return NULL;
-
-	size = nmemb * elem_size;
-	addr = vzalloc(size);
-
-	return addr;
-}
-EXPORT_SYMBOL(dm_vcalloc);
-
 /*
  * highs, and targets are managed as dynamic arrays during a
  * table load.
@@ -124,15 +106,15 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 	/*
 	 * Allocate both the target array and offset array at once.
 	 */
-	n_highs = (sector_t *) dm_vcalloc(num, sizeof(struct dm_target) +
-					  sizeof(sector_t));
+	n_highs = kvcalloc(num, sizeof(struct dm_target) + sizeof(sector_t),
+				GFP_KERNEL);
 	if (!n_highs)
 		return -ENOMEM;
 
 	n_targets = (struct dm_target *) (n_highs + num);
 
 	memset(n_highs, -1, sizeof(*n_highs) * num);
-	vfree(t->highs);
+	kvfree(t->highs);
 
 	t->num_allocated = num;
 	t->highs = n_highs;
@@ -198,7 +180,7 @@ void dm_table_destroy(struct dm_table *t)
 
 	/* free the indexes */
 	if (t->depth >= 2)
-		vfree(t->index[t->depth - 2]);
+		kvfree(t->index[t->depth - 2]);
 
 	/* free the targets */
 	for (i = 0; i < t->num_targets; i++) {
@@ -210,7 +192,7 @@ void dm_table_destroy(struct dm_table *t)
 		dm_put_target_type(tgt->type);
 	}
 
-	vfree(t->highs);
+	kvfree(t->highs);
 
 	/* free the device list */
 	free_devices(&t->devices, t->md);
@@ -1077,7 +1059,7 @@ static int setup_indexes(struct dm_table *t)
 		total += t->counts[i];
 	}
 
-	indexes = (sector_t *) dm_vcalloc(total, (unsigned long) NODE_SIZE);
+	indexes = kvcalloc(total, NODE_SIZE, GFP_KERNEL);
 	if (!indexes)
 		return -ENOMEM;
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 5c641f930caf..ff700fb6ce1d 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -574,11 +574,6 @@ struct dm_table *dm_swap_table(struct mapped_device *md,
  */
 void dm_destroy_keyslot_manager(struct blk_keyslot_manager *ksm);
 
-/*
- * A wrapper around vmalloc.
- */
-void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
-
 /*-----------------------------------------------------------------
  * Macros.
  *---------------------------------------------------------------*/
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

