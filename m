Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C8E25777
	for <dm-devel@lists.linux.dev>; Mon, 11 Nov 2024 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731340274; cv=none; b=XgaRCr/8O9GiqO3cwFoQskg1YNfcUA91zwzq9iO89AUlnIZDMJWrNhnfTs0vyJNMzo1k9IpY7wsvacB9gBqf3DUTO72E5h9gvdX4it/eGhe2d8F7nO9YEHg7/IQsq1hZllYoMdRmu9Cxe5iL1bG3UvQOlkcmVSuHvSwLiXnqBps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731340274; c=relaxed/simple;
	bh=nuWQz96HwDzIgjwxI8pqyzb9RBzxzXnVHZte4zg1fBM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=bQ8Tng9MBBmpvAedeKtcW3hBKEaxN2YmtX1/1f96oUT3uIUg5leiiBFhgyR5zdEidZG1IbCecdjvW1yJtP3jEB74FFtDvkto4Y8FOfzrxHVVR4/D02/rW4tkpoLC0Hi0HC0SvA3RdkZ0TCKa3MOrDZu5yucbGYD2dQfPIykBtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NNEXKmA0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NNEXKmA0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731340271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=z6Q+ir5N6eJu90qu2K4VX7P3M5083H2BO+bWPATa7qs=;
	b=NNEXKmA0XLCXBc1EcsKDaRLoPmwjg5IASWTCY+ucvmJ61jVNo35i1qkVCF8lnpmDbEBSPJ
	HVgqvX7M4ysdWAs3PI7pHX+FMZhmFcTz6PVc8YulQB+AlLmRYl0zGc0rOc7vT4Ju0jgAGk
	wqqAqIM1snykQFP5XY8RPbXiz+zy+ig=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-bw2fbYPEM7m8E7CTTOAkrQ-1; Mon,
 11 Nov 2024 10:51:08 -0500
X-MC-Unique: bw2fbYPEM7m8E7CTTOAkrQ-1
X-Mimecast-MFC-AGG-ID: bw2fbYPEM7m8E7CTTOAkrQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E6B01955F41;
	Mon, 11 Nov 2024 15:51:07 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AABBA1956086;
	Mon, 11 Nov 2024 15:51:05 +0000 (UTC)
Date: Mon, 11 Nov 2024 16:51:02 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    thornber@redhat.com
cc: dm-devel@lists.linux.dev
Subject: dm-cache: fix warnings about duplicate slab caches
Message-ID: <43a07711-2055-a3c1-62b1-dfa6b3b324f3@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2Yahblww1gsxgD8qGBy8KKCWCT_LotOAagPJhrvIu2U_1731340267
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The commit 4c39529663b9 adds a warning about duplicate cache names if
CONFIG_DEBUG_VM is selected. These warnings are triggered by the dm-cache
code.

The dm-cache code allocates a slab cache for each device. This commit
changes it to allocate just one slab cache in the module init function.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 4c39529663b9 ("slab: Warn on duplicate cache names when DEBUG_VM=y")

---
 drivers/md/dm-cache-background-tracker.c |   25 ++++++-------------------
 drivers/md/dm-cache-background-tracker.h |    8 ++++++++
 drivers/md/dm-cache-target.c             |   25 ++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 24 deletions(-)

Index: linux-2.6/drivers/md/dm-cache-background-tracker.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-background-tracker.c	2023-09-05 14:45:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-cache-background-tracker.c	2024-11-07 15:54:05.000000000 +0100
@@ -11,12 +11,6 @@
 
 #define DM_MSG_PREFIX "dm-background-tracker"
 
-struct bt_work {
-	struct list_head list;
-	struct rb_node node;
-	struct policy_work work;
-};
-
 struct background_tracker {
 	unsigned int max_work;
 	atomic_t pending_promotes;
@@ -26,10 +20,10 @@ struct background_tracker {
 	struct list_head issued;
 	struct list_head queued;
 	struct rb_root pending;
-
-	struct kmem_cache *work_cache;
 };
 
+struct kmem_cache *btracker_work_cache = NULL;
+
 struct background_tracker *btracker_create(unsigned int max_work)
 {
 	struct background_tracker *b = kmalloc(sizeof(*b), GFP_KERNEL);
@@ -48,12 +42,6 @@ struct background_tracker *btracker_crea
 	INIT_LIST_HEAD(&b->queued);
 
 	b->pending = RB_ROOT;
-	b->work_cache = KMEM_CACHE(bt_work, 0);
-	if (!b->work_cache) {
-		DMERR("couldn't create mempool for background work items");
-		kfree(b);
-		b = NULL;
-	}
 
 	return b;
 }
@@ -66,10 +54,9 @@ void btracker_destroy(struct background_
 	BUG_ON(!list_empty(&b->issued));
 	list_for_each_entry_safe (w, tmp, &b->queued, list) {
 		list_del(&w->list);
-		kmem_cache_free(b->work_cache, w);
+		kmem_cache_free(btracker_work_cache, w);
 	}
 
-	kmem_cache_destroy(b->work_cache);
 	kfree(b);
 }
 EXPORT_SYMBOL_GPL(btracker_destroy);
@@ -180,7 +167,7 @@ static struct bt_work *alloc_work(struct
 	if (max_work_reached(b))
 		return NULL;
 
-	return kmem_cache_alloc(b->work_cache, GFP_NOWAIT);
+	return kmem_cache_alloc(btracker_work_cache, GFP_NOWAIT);
 }
 
 int btracker_queue(struct background_tracker *b,
@@ -203,7 +190,7 @@ int btracker_queue(struct background_tra
 		 * There was a race, we'll just ignore this second
 		 * bit of work for the same oblock.
 		 */
-		kmem_cache_free(b->work_cache, w);
+		kmem_cache_free(btracker_work_cache, w);
 		return -EINVAL;
 	}
 
@@ -244,7 +231,7 @@ void btracker_complete(struct background
 	update_stats(b, &w->work, -1);
 	rb_erase(&w->node, &b->pending);
 	list_del(&w->list);
-	kmem_cache_free(b->work_cache, w);
+	kmem_cache_free(btracker_work_cache, w);
 }
 EXPORT_SYMBOL_GPL(btracker_complete);
 
Index: linux-2.6/drivers/md/dm-cache-background-tracker.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-background-tracker.h	2023-09-05 14:45:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-cache-background-tracker.h	2024-11-07 15:53:42.000000000 +0100
@@ -26,6 +26,14 @@
  * protected with a spinlock.
  */
 
+struct bt_work {
+	struct list_head list;
+	struct rb_node node;
+	struct policy_work work;
+};
+
+extern struct kmem_cache *btracker_work_cache;
+
 struct background_work;
 struct background_tracker;
 
Index: linux-2.6/drivers/md/dm-cache-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-target.c	2024-11-07 12:47:50.000000000 +0100
+++ linux-2.6/drivers/md/dm-cache-target.c	2024-11-07 15:58:34.000000000 +0100
@@ -10,6 +10,7 @@
 #include "dm-bio-record.h"
 #include "dm-cache-metadata.h"
 #include "dm-io-tracker.h"
+#include "dm-cache-background-tracker.h"
 
 #include <linux/dm-io.h>
 #include <linux/dm-kcopyd.h>
@@ -2263,7 +2264,7 @@ static int parse_cache_args(struct cache
 
 /*----------------------------------------------------------------*/
 
-static struct kmem_cache *migration_cache;
+static struct kmem_cache *migration_cache = NULL;
 
 #define NOT_CORE_OPTION 1
 
@@ -3445,22 +3446,36 @@ static int __init dm_cache_init(void)
 	int r;
 
 	migration_cache = KMEM_CACHE(dm_cache_migration, 0);
-	if (!migration_cache)
-		return -ENOMEM;
+	if (!migration_cache) {
+		r = -ENOMEM;
+		goto err;
+	}
+
+	btracker_work_cache = kmem_cache_create("dm_cache_bt_work",
+		sizeof(struct bt_work), __alignof__(struct bt_work), 0, NULL);
+	if (!btracker_work_cache) {
+		r = -ENOMEM;
+		goto err;
+	}
 
 	r = dm_register_target(&cache_target);
 	if (r) {
-		kmem_cache_destroy(migration_cache);
-		return r;
+		goto err;
 	}
 
 	return 0;
+
+err:
+	kmem_cache_destroy(migration_cache);
+	kmem_cache_destroy(btracker_work_cache);
+	return r;
 }
 
 static void __exit dm_cache_exit(void)
 {
 	dm_unregister_target(&cache_target);
 	kmem_cache_destroy(migration_cache);
+	kmem_cache_destroy(btracker_work_cache);
 }
 
 module_init(dm_cache_init);

