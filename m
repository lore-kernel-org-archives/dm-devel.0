Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A431CCEC8
	for <dm-devel@lists.linux.dev>; Wed, 15 Jan 2025 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736962422; cv=none; b=McPQ3FuX7AgL07PVOKjOw5xm0ZQ/EJtBjkSAhuThjDaH57b1Nq6PUAqappMNdK3ajQwtAkOJJWubHNNwpm9/QzsYjObXcrX7cF/dr0LKI1ZaiIWYO1t6FqflyNB5BdKzy9pLWJI+Dikr1mx+Jk170ZPYIuC5Z4vvYCT1BwOb8DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736962422; c=relaxed/simple;
	bh=aYAZ5kNi6yRr6CQl70BMOaOmrPKzSxzr5E2u6gwuLzg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=fiXxTOQXV0JvREfG3fAmBTMCAqkvLsvNOSqIRHwMuFviSQcRVeXQCrZRuYGU/tX3+pzCbo0sr6H0H1GNOHxBs7IbTUjDcRs3DNUT6oqLCKyHxsQCwspw+hykCLvOblhzLci9yDm7oR9Rvif7ZEp2NwTotvWyvS6Q1hj74GFwAH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X5jJ+PWt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X5jJ+PWt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736962419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=JnfG6IENZZpfcMk2VeV8dyc8aI9HbqUzEJjj5TWh+Hw=;
	b=X5jJ+PWtY8XltitdMvHuGiBksXVG07AcBVHHrmeQ2VyCxmS94JO+Mybl3JqxK1WlQAWuTC
	48eNnUMZK5Cg2gx/dAPEP261ZqwVA7z2MxXFEIanhXDf0JT+nR/WIPahXarDpmpbjV4opN
	N8gAaVUOqOEBe/dMZpBztUQqBBPJYYk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-XQr7vHhGO5aPeetSbwWKYg-1; Wed,
 15 Jan 2025 12:33:36 -0500
X-MC-Unique: XQr7vHhGO5aPeetSbwWKYg-1
X-Mimecast-MFC-AGG-ID: XQr7vHhGO5aPeetSbwWKYg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B13A19560BB;
	Wed, 15 Jan 2025 17:33:35 +0000 (UTC)
Received: from [10.45.224.117] (unknown [10.45.224.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6537730001BE;
	Wed, 15 Jan 2025 17:33:33 +0000 (UTC)
Date: Wed, 15 Jan 2025 18:33:30 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Meir Elisha <meir.elisha@volumez.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Joe Thornber <ejt@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-transaction-manager: use red-black trees instead of linear
 lists
Message-ID: <e23022ee-6ea9-a7b5-e05a-fed23150e617@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QszvahG_iLYhUA7Sv9c4duwve2C2JWw2swa9oHGrpXM_1736962415
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Meir

Could you test this patch, if it improves performance for your case?

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

There was reported performance degradation when the shadow map contained
too many entries [1]. The shadow map uses 256-bucket hash with linear
lists - when there are too many entries, it has quadratic complexity.

Meir Elisha proposed to add a module parameter that could configure the
size of the hash array - however, this is not ideal because users don't
know that they should increase the parameter when they get bad
performance.

This commit replaces the linear lists with rb-trees (so that there's a
hash of rb-trees), they have logarithmic complexity, so it solves the
performance degradation.

Link: https://patchwork.kernel.org/project/dm-devel/patch/20241014134944.1264991-1-meir.elisha@volumez.com/ [1]
Reported-by: Meir Elisha <meir.elisha@volumez.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/persistent-data/dm-transaction-manager.c |   54 +++++++++++++-------
 1 file changed, 37 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-transaction-manager.c	2024-11-05 12:11:40.000000000 +0100
+++ linux-2.6/drivers/md/persistent-data/dm-transaction-manager.c	2025-01-15 14:18:25.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/hash.h>
+#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/device-mapper.h>
 
@@ -77,7 +78,7 @@ static void prefetch_issue(struct prefet
 /*----------------------------------------------------------------*/
 
 struct shadow_info {
-	struct hlist_node hlist;
+	struct rb_node node;
 	dm_block_t where;
 };
 
@@ -95,7 +96,7 @@ struct dm_transaction_manager {
 	struct dm_space_map *sm;
 
 	spinlock_t lock;
-	struct hlist_head buckets[DM_HASH_SIZE];
+	struct rb_root buckets[DM_HASH_SIZE];
 
 	struct prefetch_set prefetches;
 };
@@ -106,14 +107,22 @@ static int is_shadow(struct dm_transacti
 {
 	int r = 0;
 	unsigned int bucket = dm_hash_block(b, DM_HASH_MASK);
-	struct shadow_info *si;
+	struct rb_node **node;
 
 	spin_lock(&tm->lock);
-	hlist_for_each_entry(si, tm->buckets + bucket, hlist)
-		if (si->where == b) {
+	node = &tm->buckets[bucket].rb_node;
+	while (*node) {
+		struct shadow_info *si =
+			rb_entry(*node, struct shadow_info, node);
+		if (b == si->where) {
 			r = 1;
 			break;
 		}
+		if (b < si->where)
+			node = &si->node.rb_left;
+		else
+			node = &si->node.rb_right;
+	}
 	spin_unlock(&tm->lock);
 
 	return r;
@@ -130,30 +139,41 @@ static void insert_shadow(struct dm_tran
 
 	si = kmalloc(sizeof(*si), GFP_NOIO);
 	if (si) {
+		struct rb_node **node, *parent;
 		si->where = b;
 		bucket = dm_hash_block(b, DM_HASH_MASK);
+
 		spin_lock(&tm->lock);
-		hlist_add_head(&si->hlist, tm->buckets + bucket);
+		node = &tm->buckets[bucket].rb_node;
+		parent = NULL;
+		while (*node) {
+			struct shadow_info *si =
+				rb_entry(*node, struct shadow_info, node);
+			parent = *node;
+			if (b < si->where)
+				node = &si->node.rb_left;
+			else
+				node = &si->node.rb_right;
+		}
+		rb_link_node(&si->node, parent, node);
+		rb_insert_color(&si->node, &tm->buckets[bucket]);
 		spin_unlock(&tm->lock);
 	}
 }
 
 static void wipe_shadow_table(struct dm_transaction_manager *tm)
 {
-	struct shadow_info *si;
-	struct hlist_node *tmp;
-	struct hlist_head *bucket;
-	int i;
+	unsigned int i;
 
 	spin_lock(&tm->lock);
 	for (i = 0; i < DM_HASH_SIZE; i++) {
-		bucket = tm->buckets + i;
-		hlist_for_each_entry_safe(si, tmp, bucket, hlist)
+		while (!RB_EMPTY_ROOT(&tm->buckets[i])) {
+			struct shadow_info *si =
+				rb_entry(tm->buckets[i].rb_node, struct shadow_info, node);
+			rb_erase(&si->node, &tm->buckets[i]);
 			kfree(si);
-
-		INIT_HLIST_HEAD(bucket);
+		}
 	}
-
 	spin_unlock(&tm->lock);
 }
 
@@ -162,7 +182,7 @@ static void wipe_shadow_table(struct dm_
 static struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
 						   struct dm_space_map *sm)
 {
-	int i;
+	unsigned int i;
 	struct dm_transaction_manager *tm;
 
 	tm = kmalloc(sizeof(*tm), GFP_KERNEL);
@@ -176,7 +196,7 @@ static struct dm_transaction_manager *dm
 
 	spin_lock_init(&tm->lock);
 	for (i = 0; i < DM_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(tm->buckets + i);
+		tm->buckets[i] = RB_ROOT;
 
 	prefetch_init(&tm->prefetches);
 

