Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D36C33EE
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706322955; cv=none; b=H25byGVz/mhsvmHRR6wE5InA+oK+InITbpKTmYE2tPIB8DXaFZ+wCPITaFIXcZwtUGP8vQRroapqYxU9IvsEdxh07bzqee2Jo06YJy4ZrYsZ1DF8PkioiXWdJ1j3aq0laMRz0jedCq71HA84RDUW61oVOBm87v9sHuvo9c4EvPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706322955; c=relaxed/simple;
	bh=/LwGdOSjHMwSKkZwHxRLc2bV51QnBRPw/hUS43e2VEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJjCroNSgLrB4r6OOq04M4HnIY3SUXMQlj9BoQgJZgIuPKDsHbWUips/RUWZcpKOKIeddAIo0fL10haNU6Nuwh6ocaovyG2YCZbfpmsUVgnc+5hmnYOWVddJr6zdkXXjGGN/Kq9haTceoZjLTrmqz3eml5iUN5HwR2ZlNRcuR3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ccCS+grv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ccCS+grv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706322953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6lYxBgzEZRfE3DJpDSDNt+V4cAHJC9ou/tD0bVvlN0=;
	b=ccCS+grvQp7Rzc6WqeKbgcjWfCxaDc5s0xxA/nqiw1vSygfPLV9Aar36aqRR4/5wVGjBqq
	KLFPp1Lc8s61LPsNd0+/gR1CraTXWZqBXUS/QxBF9/r71ei8SO3CvTEGJas3b7lfhY7V+X
	p+ZKbZWmJfASbYId72/b/J5UXcyyqRA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-r3nWBIOgO96CXH_SFe2SQA-1; Fri, 26 Jan 2024 21:35:49 -0500
X-MC-Unique: r3nWBIOgO96CXH_SFe2SQA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BD7E1013767;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 67347492BFA;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 65C77560C9; Fri, 26 Jan 2024 21:35:49 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 5/5] dm vdo block-map: rename struct cursors member to 'completion'
Date: Fri, 26 Jan 2024 21:35:49 -0500
Message-ID: <3aef47736fad201d97e01e5284f0896916e02e81.1706322049.git.msakai@redhat.com>
In-Reply-To: <cover.1706322049.git.msakai@redhat.com>
References: <cover.1706322049.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

'completion' is more informative name for a 'struct vdo_completion'
than 'parent'.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 20 +++++++++-----------
 drivers/md/dm-vdo/block-map.h |  2 +-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 0ce136612869..50dda7ae7074 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -98,7 +98,7 @@ struct cursors {
 	struct block_map_zone *zone;
 	struct vio_pool *pool;
 	vdo_entry_callback_fn entry_callback;
-	struct vdo_completion *parent;
+	struct vdo_completion *completion;
 	root_count_t active_roots;
 	struct cursor cursors[];
 };
@@ -2501,7 +2501,7 @@ static void replace_forest(struct block_map *map)
 static void finish_cursor(struct cursor *cursor)
 {
 	struct cursors *cursors = cursor->parent;
-	struct vdo_completion *parent = cursors->parent;
+	struct vdo_completion *completion = cursors->completion;
 
 	return_vio_to_pool(cursors->pool, uds_forget(cursor->vio));
 	if (--cursors->active_roots > 0)
@@ -2509,7 +2509,7 @@ static void finish_cursor(struct cursor *cursor)
 
 	uds_free(cursors);
 
-	vdo_finish_completion(parent);
+	vdo_finish_completion(completion);
 }
 
 static void traverse(struct cursor *cursor);
@@ -2595,12 +2595,10 @@ static void traverse(struct cursor *cursor)
 
 			if (cursor->height < VDO_BLOCK_MAP_TREE_HEIGHT - 1) {
 				int result = cursor->parent->entry_callback(location.pbn,
-									    cursor->parent->parent);
-
+									    cursor->parent->completion);
 				if (result != VDO_SUCCESS) {
 					page->entries[level->slot] = UNMAPPED_BLOCK_MAP_ENTRY;
-					vdo_write_tree_page(tree_page,
-							    cursor->parent->zone);
+					vdo_write_tree_page(tree_page, cursor->parent->zone);
 					continue;
 				}
 			}
@@ -2676,10 +2674,10 @@ static struct boundary compute_boundary(struct block_map *map, root_count_t root
 /**
  * vdo_traverse_forest() - Walk the entire forest of a block map.
  * @callback: A function to call with the pbn of each allocated node in the forest.
- * @parent: The completion to notify on each traversed PBN, and when the traversal is complete.
+ * @completion: The completion to notify on each traversed PBN, and when traversal completes.
  */
 void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
-			 struct vdo_completion *parent)
+			 struct vdo_completion *completion)
 {
 	root_count_t root;
 	struct cursors *cursors;
@@ -2688,14 +2686,14 @@ void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
 	result = uds_allocate_extended(struct cursors, map->root_count,
 				       struct cursor, __func__, &cursors);
 	if (result != VDO_SUCCESS) {
-		vdo_fail_completion(parent, result);
+		vdo_fail_completion(completion, result);
 		return;
 	}
 
 	cursors->zone = &map->zones[0];
 	cursors->pool = cursors->zone->vio_pool;
 	cursors->entry_callback = callback;
-	cursors->parent = parent;
+	cursors->completion = completion;
 	cursors->active_roots = map->root_count;
 	for (root = 0; root < map->root_count; root++) {
 		struct cursor *cursor = &cursors->cursors[root];
diff --git a/drivers/md/dm-vdo/block-map.h b/drivers/md/dm-vdo/block-map.h
index cc98d19309ce..c574bd524bc2 100644
--- a/drivers/md/dm-vdo/block-map.h
+++ b/drivers/md/dm-vdo/block-map.h
@@ -313,7 +313,7 @@ physical_block_number_t vdo_find_block_map_page_pbn(struct block_map *map,
 void vdo_write_tree_page(struct tree_page *page, struct block_map_zone *zone);
 
 void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
-			 struct vdo_completion *parent);
+			 struct vdo_completion *completion);
 
 int __must_check vdo_decode_block_map(struct block_map_state_2_0 state,
 				      block_count_t logical_blocks, struct vdo *vdo,
-- 
2.42.0

