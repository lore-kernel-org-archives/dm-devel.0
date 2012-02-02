From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 05/11] [dm-thin] btree-remove - fix rebalancing
	of 3 nodes.
Date: Thu,  2 Feb 2012 16:39:08 +0000
Message-ID: <1328200754-13642-6-git-send-email-ejt@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1328200754-13642-1-git-send-email-ejt@redhat.com>
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

When we remove an entry from a node we sometimes rebalance with it's
neighbours.  This wasn't being done correctly.
---
 drivers/md/persistent-data/dm-btree-remove.c |  174 +++++++++++++++-----------
 1 files changed, 99 insertions(+), 75 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 8576d56..aa71e23 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -128,18 +128,9 @@ static void delete_at(struct node *n, unsigned index)
 	n->header.nr_entries = cpu_to_le32(nr_entries - 1);
 }
 
-static unsigned del_threshold(struct node *n)
-{
-	return le32_to_cpu(n->header.max_entries) / 3;
-}
-
 static unsigned merge_threshold(struct node *n)
 {
-	/*
-	 * The extra one is because we know we're potentially going to
-	 * delete an entry.
-	 */
-	return 2 * (le32_to_cpu(n->header.max_entries) / 3) + 1;
+	return le32_to_cpu(n->header.max_entries) / 3;
 }
 
 struct child {
@@ -188,6 +179,15 @@ static int exit_child(struct dm_btree_info *info, struct child *c)
 
 static void shift(struct node *left, struct node *right, int count)
 {
+	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
+	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
+	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
+	uint32_t r_max_entries = le32_to_cpu(right->header.max_entries);
+
+	BUG_ON(max_entries != r_max_entries);
+	BUG_ON(nr_left - count > max_entries);
+	BUG_ON(nr_right + count > max_entries);
+
 	if (!count)
 		return;
 
@@ -199,13 +199,8 @@ static void shift(struct node *left, struct node *right, int count)
 		node_shift(right, count);
 	}
 
-	left->header.nr_entries =
-		cpu_to_le32(le32_to_cpu(left->header.nr_entries) - count);
-	BUG_ON(le32_to_cpu(left->header.nr_entries) > le32_to_cpu(left->header.max_entries));
-
-	right->header.nr_entries =
-		cpu_to_le32(le32_to_cpu(right->header.nr_entries) + count);
-	BUG_ON(le32_to_cpu(right->header.nr_entries) > le32_to_cpu(right->header.max_entries));
+	left->header.nr_entries = cpu_to_le32(nr_left - count);
+	right->header.nr_entries = cpu_to_le32(nr_right + count);
 }
 
 static void __rebalance2(struct dm_btree_info *info, struct node *parent,
@@ -215,8 +210,9 @@ static void __rebalance2(struct dm_btree_info *info, struct node *parent,
 	struct node *right = r->n;
 	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
+	unsigned threshold = 2 * merge_threshold(left) + 1;
 
-	if (nr_left + nr_right <= merge_threshold(left)) {
+	if (nr_left + nr_right < threshold) {
 		/*
 		 * Merge
 		 */
@@ -234,9 +230,6 @@ static void __rebalance2(struct dm_btree_info *info, struct node *parent,
 		 * Rebalance.
 		 */
 		unsigned target_left = (nr_left + nr_right) / 2;
-		unsigned shift_ = nr_left - target_left;
-		BUG_ON(le32_to_cpu(left->header.max_entries) <= nr_left - shift_);
-		BUG_ON(le32_to_cpu(right->header.max_entries) <= nr_right + shift_);
 		shift(left, right, nr_left - target_left);
 		*key_ptr(parent, r->index) = right->keys[0];
 	}
@@ -272,6 +265,84 @@ static int rebalance2(struct shadow_spine *s, struct dm_btree_info *info,
 	return exit_child(info, &right);
 }
 
+/*
+ * We dump as many entries from center as possible into left, then the rest
+ * in right, then rebalance2.  This wastes some cpu, but I want something
+ * simple atm.
+ */
+static void delete_center_node(struct dm_btree_info *info, struct node *parent,
+			       struct child *l, struct child *c, struct child *r,
+			       struct node *left, struct node *center, struct node *right,
+			       uint32_t nr_left, uint32_t nr_center, uint32_t nr_right)
+{
+	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
+	unsigned shift = min(max_entries - nr_left, nr_center);
+
+	BUG_ON(nr_left + shift > max_entries);
+	node_copy(left, center, -shift);
+	left->header.nr_entries = cpu_to_le32(nr_left + shift);
+
+	if (shift != nr_center) {
+		shift = nr_center - shift;
+		BUG_ON((nr_right + shift) > max_entries);
+		node_shift(right, shift);
+		node_copy(center, right, shift);
+		right->header.nr_entries = cpu_to_le32(nr_right + shift);
+	}
+	*key_ptr(parent, r->index) = right->keys[0];
+
+	delete_at(parent, c->index);
+	r->index--;
+
+	dm_tm_dec(info->tm, dm_block_location(c->block));
+	__rebalance2(info, parent, l, r);
+}
+
+/*
+ * Redistributes entries among 3 sibling nodes.
+ */
+static void redistribute3(struct dm_btree_info *info, struct node *parent,
+			  struct child *l, struct child *c, struct child *r,
+			  struct node *left, struct node *center, struct node *right,
+			  uint32_t nr_left, uint32_t nr_center, uint32_t nr_right)
+{
+	int s;
+	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
+	unsigned target = (nr_left + nr_center + nr_right) / 3;
+	BUG_ON(target > max_entries);
+
+	if (nr_left < nr_right) {
+		s = nr_left - target;
+
+		if (s < 0 && nr_center < -s) {
+			/* not enough in central node */
+			shift(left, center, nr_center);
+			s = nr_center - target;
+			shift(left, right, s);
+			nr_right += s;
+		} else
+			shift(left, center, s);
+
+		shift(center, right, target - nr_right);
+
+	} else {
+		s = target - nr_right;
+		if (s > 0 && nr_center < s) {
+			/* not enough in central node */
+			shift(center, right, nr_center);
+			s = target - nr_center;
+			shift(left, right, s);
+			nr_left -= s;
+		} else
+			shift(center, right, s);
+
+		shift(left, center, nr_left - target);
+	}
+
+	*key_ptr(parent, c->index) = center->keys[0];
+	*key_ptr(parent, r->index) = right->keys[0];
+}
+
 static void __rebalance3(struct dm_btree_info *info, struct node *parent,
 			 struct child *l, struct child *c, struct child *r)
 {
@@ -282,62 +353,18 @@ static void __rebalance3(struct dm_btree_info *info, struct node *parent,
 	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_center = le32_to_cpu(center->header.nr_entries);
 	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
-	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
 
-	unsigned target;
+	unsigned threshold = merge_threshold(left) * 4 + 1;
 
 	BUG_ON(left->header.max_entries != center->header.max_entries);
 	BUG_ON(center->header.max_entries != right->header.max_entries);
 
-	if (((nr_left + nr_center + nr_right) / 2) < merge_threshold(center)) {
-		/*
-		 * Delete center node:
-		 *
-		 * We dump as many entries from center as possible into
-		 * left, then the rest in right, then rebalance2.  This
-		 * wastes some cpu, but I want something simple atm.
-		 */
-		unsigned shift = min(max_entries - nr_left, nr_center);
-
-		BUG_ON(nr_left + shift > max_entries);
-		node_copy(left, center, -shift);
-		left->header.nr_entries = cpu_to_le32(nr_left + shift);
-
-		if (shift != nr_center) {
-			shift = nr_center - shift;
-			BUG_ON((nr_right + shift) >= max_entries);
-			node_shift(right, shift);
-			node_copy(center, right, shift);
-			right->header.nr_entries = cpu_to_le32(nr_right + shift);
-		}
-		*key_ptr(parent, r->index) = right->keys[0];
-
-		delete_at(parent, c->index);
-		r->index--;
-
-		dm_tm_dec(info->tm, dm_block_location(c->block));
-		__rebalance2(info, parent, l, r);
-
-		return;
-	}
-
-	/*
-	 * Rebalance
-	 */
-	target = (nr_left + nr_center + nr_right) / 3;
-	BUG_ON(target > max_entries);
-
-	/*
-	 * Adjust the left node
-	 */
-	shift(left, center, nr_left - target);
-
-	/*
-	 * Adjust the right node
-	 */
-	shift(center, right, target - nr_right);
-	*key_ptr(parent, c->index) = center->keys[0];
-	*key_ptr(parent, r->index) = right->keys[0];
+	if ((nr_left + nr_center + nr_right) < threshold)
+		delete_center_node(info, parent, l, c, r, left, center, right,
+				   nr_left, nr_center, nr_right);
+	else
+		redistribute3(info, parent, l, c, r, left, center, right,
+			      nr_left, nr_center, nr_right);
 }
 
 static int rebalance3(struct shadow_spine *s, struct dm_btree_info *info,
@@ -441,9 +468,6 @@ static int rebalance_children(struct shadow_spine *s,
 	if (r)
 		return r;
 
-	if (child_entries > del_threshold(n))
-		return 0;
-
 	has_left_sibling = i > 0;
 	has_right_sibling = i < (le32_to_cpu(n->header.nr_entries) - 1);
 
-- 
1.7.5.4
