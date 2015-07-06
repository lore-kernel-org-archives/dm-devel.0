From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/2] dm-btree-remove: Remove function
	get_nr_entries()
Date: Mon,  6 Jul 2015 11:55:41 -0400
Message-ID: <1436198141-19730-3-git-send-email-vgoyal@redhat.com>
References: <1436198141-19730-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1436198141-19730-1-git-send-email-vgoyal@redhat.com>
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
Cc: thornber@redhat.com, Vivek Goyal <vgoyal@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

Looks like get_nr_entries() returns results in local variable child_entries
which is never used. Remove the call as well function as there are no more
users of it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/md/persistent-data/dm-btree-remove.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index e04cfd2..0ef78a5 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -409,29 +409,11 @@ static int rebalance3(struct shadow_spine *s, struct dm_btree_info *info,
 	return 0;
 }
 
-static int get_nr_entries(struct dm_transaction_manager *tm,
-			  dm_block_t b, uint32_t *result)
-{
-	int r;
-	struct dm_block *block;
-	struct btree_node *n;
-
-	r = dm_tm_read_lock(tm, b, &btree_node_validator, &block);
-	if (r)
-		return r;
-
-	n = dm_block_data(block);
-	*result = le32_to_cpu(n->header.nr_entries);
-
-	return dm_tm_unlock(tm, block);
-}
-
 static int rebalance_children(struct shadow_spine *s,
 			      struct dm_btree_info *info,
 			      struct dm_btree_value_type *vt, uint64_t key)
 {
 	int i, r, has_left_sibling, has_right_sibling;
-	uint32_t child_entries;
 	struct btree_node *n;
 
 	n = dm_block_data(shadow_current(s));
@@ -458,10 +440,6 @@ static int rebalance_children(struct shadow_spine *s,
 	if (i < 0)
 		return -ENODATA;
 
-	r = get_nr_entries(info->tm, value64(n, i), &child_entries);
-	if (r)
-		return r;
-
 	has_left_sibling = i > 0;
 	has_right_sibling = i < (le32_to_cpu(n->header.nr_entries) - 1);
 
-- 
2.1.0
