From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3/5] [dm-thin] [btree-remove] break up
	__rebalance3 function.
Date: Tue, 24 Jan 2012 11:50:38 +0000
Message-ID: <1327405840-19750-4-git-send-email-ejt@redhat.com>
References: <1327405840-19750-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1327405840-19750-1-git-send-email-ejt@redhat.com>
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

This function was getting too big.  Two functions are factored out
delete_center_node() and redistribute3().  No functional changes.
---
 drivers/md/persistent-data/dm-btree-remove.c |  109 +++++++++++++------------
 1 files changed, 57 insertions(+), 52 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 8d6f958..9480fcc 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -269,6 +269,57 @@ static int rebalance2(struct shadow_spine *s, struct dm_btree_info *info,
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
+		BUG_ON((nr_right + shift) >= max_entries);
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
+	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
+	unsigned target = (nr_left + nr_center + nr_right) / 3;
+	BUG_ON(target > max_entries);
+
+	shift(left, center, nr_left - target);
+	shift(center, right, target - nr_right);
+	*key_ptr(parent, c->index) = center->keys[0];
+	*key_ptr(parent, r->index) = right->keys[0];
+}
+
 static void __rebalance3(struct dm_btree_info *info, struct node *parent,
 			 struct child *l, struct child *c, struct child *r)
 {
@@ -279,62 +330,16 @@ static void __rebalance3(struct dm_btree_info *info, struct node *parent,
 	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_center = le32_to_cpu(center->header.nr_entries);
 	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
-	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
-
-	unsigned target;
 
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
+	if (((nr_left + nr_center + nr_right) / 2) < merge_threshold(center))
+		delete_center_node(info, parent, l, c, r, left, center, right,
+				   nr_left, nr_center, nr_right);
+	else
+		redistribute3(info, parent, l, c, r, left, center, right,
+			      nr_left, nr_center, nr_right);
 }
 
 static int rebalance3(struct shadow_spine *s, struct dm_btree_info *info,
-- 
1.7.5.4
