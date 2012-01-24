From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 4/5] [dm-thin] [btree-remove] Fix bug that
	allowed the nr of entries in a btree node to drop below 1/3.
Date: Tue, 24 Jan 2012 11:50:39 +0000
Message-ID: <1327405840-19750-5-git-send-email-ejt@redhat.com>
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

For performance reasons we try and keep all btree nodes at least 1/3
full.

Doing so requires spotting when we should delete a node and move it's
entries to it's neighbours.  Sometimes this deletion wasn't occuring.
---
 drivers/md/persistent-data/dm-btree-remove.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 9480fcc..9eca1af 100644
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
@@ -215,8 +206,9 @@ static void __rebalance2(struct dm_btree_info *info, struct node *parent,
 	struct node *right = r->n;
 	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
+	unsigned threshold = 2 * merge_threshold(left) + 1;
 
-	if (nr_left + nr_right <= merge_threshold(left)) {
+	if (nr_left + nr_right < threshold) {
 		/*
 		 * Merge
 		 */
@@ -331,10 +323,12 @@ static void __rebalance3(struct dm_btree_info *info, struct node *parent,
 	uint32_t nr_center = le32_to_cpu(center->header.nr_entries);
 	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
 
+	unsigned threshold = merge_threshold(left) * 4 + 1;
+
 	BUG_ON(left->header.max_entries != center->header.max_entries);
 	BUG_ON(center->header.max_entries != right->header.max_entries);
 
-	if (((nr_left + nr_center + nr_right) / 2) < merge_threshold(center))
+	if ((nr_left + nr_center + nr_right) / 2 < threshold)
 		delete_center_node(info, parent, l, c, r, left, center, right,
 				   nr_left, nr_center, nr_right);
 	else
@@ -443,9 +437,6 @@ static int rebalance_children(struct shadow_spine *s,
 	if (r)
 		return r;
 
-	if (child_entries > del_threshold(n))
-		return 0;
-
 	has_left_sibling = i > 0;
 	has_right_sibling = i < (le32_to_cpu(n->header.nr_entries) - 1);
 
-- 
1.7.5.4
