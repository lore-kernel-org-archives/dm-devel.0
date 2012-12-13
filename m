From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 2/8] [persistent-data] dm_btree_walk
Date: Thu, 13 Dec 2012 20:19:10 +0000
Message-ID: <1355429956-22785-3-git-send-email-ejt@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355429956-22785-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

Iterates the contents of a btree.
---
 drivers/md/persistent-data/dm-btree-internal.h |    1 +
 drivers/md/persistent-data/dm-btree-spine.c    |    7 ++++
 drivers/md/persistent-data/dm-btree.c          |   52 ++++++++++++++++++++++++
 drivers/md/persistent-data/dm-btree.h          |    3 ++
 4 files changed, 63 insertions(+)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index accbb05..37d367b 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -64,6 +64,7 @@ struct ro_spine {
 void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
 int exit_ro_spine(struct ro_spine *s);
 int ro_step(struct ro_spine *s, dm_block_t new_child);
+void ro_pop(struct ro_spine *s);
 struct btree_node *ro_node(struct ro_spine *s);
 
 struct shadow_spine {
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index f199a0c..cf9fd67 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -164,6 +164,13 @@ int ro_step(struct ro_spine *s, dm_block_t new_child)
 	return r;
 }
 
+void ro_pop(struct ro_spine *s)
+{
+	BUG_ON(!s->count);
+	--s->count;
+	unlock_block(s->info, s->nodes[s->count]);
+}
+
 struct btree_node *ro_node(struct ro_spine *s)
 {
 	struct dm_block *block;
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 4caf669..776512f 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -807,3 +807,55 @@ int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
 	return r ? r : count;
 }
 EXPORT_SYMBOL_GPL(dm_btree_find_highest_key);
+
+/*
+ * FIXME: we shouldn't use a recursive algorithm when we have limited stack
+ * space.  Also this only works for single level trees.
+ */
+static int walk_node(struct ro_spine *s, dm_block_t block,
+		     int (*fn)(void *, uint64_t *keys, void *leaf),
+		     void *context)
+{
+	int r;
+	unsigned i, nr;
+	struct btree_node *n;
+	uint64_t keys;
+
+	r = ro_step(s, block);
+	n = ro_node(s);
+
+	nr = le32_to_cpu(n->header.nr_entries);
+	for (i = 0; i < nr; i++) {
+		if (le32_to_cpu(n->header.flags) & INTERNAL_NODE) {
+			r = walk_node(s, value64(n, i), fn, context);
+			if (r)
+				goto out;
+		} else {
+			keys = le64_to_cpu(*key_ptr(n, i));
+			r = fn(context, &keys, value_ptr(n, i));
+			if (r)
+				goto out;
+		}
+	}
+
+out:
+	ro_pop(s);
+	return r;
+}
+
+
+int dm_btree_walk(struct dm_btree_info *info, dm_block_t root,
+		  int (*fn)(void *, uint64_t *keys, void *leaf), void *context)
+{
+	int r;
+	struct ro_spine spine;
+
+	BUG_ON(info->levels > 1);
+
+	init_ro_spine(&spine, info);
+	r = walk_node(&spine, root, fn, context);
+	exit_ro_spine(&spine);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_btree_walk);
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index b2a1e04..6c4cf7c 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -142,4 +142,7 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
 			      uint64_t *result_keys);
 
+int dm_btree_walk(struct dm_btree_info *info, dm_block_t root,
+		  int (*fn)(void *, uint64_t *keys, void *leaf), void *context);
+
 #endif	/* _LINUX_DM_BTREE_H */
-- 
1.7.10.4
