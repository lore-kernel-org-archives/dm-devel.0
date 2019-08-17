From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Subject: [PATCH] dm-btree: Fix the order of the block initialized
	on btree_split_beneath
Date: Sat, 17 Aug 2019 13:32:40 +0800
Message-ID: <1566019960-24788-1-git-send-email-zhangxiaoxu5@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com, zhangxiaoxu5@huawei.com
List-Id: dm-devel.ids

When splits a node to two new children, it will new two blocks: left
and right. If new right block failed, the left block will be unlocked
and mark it dirty. If this happened, the left blocks content is zero,
it won't be initialized with the btree struct. When flush the left
block to disk, the validator will failed when check this block. Then
BUG_ON will raised.

So, let's initialize the left block before new right block.

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
---
 drivers/md/persistent-data/dm-btree.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 58b3197..8aae062 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -628,39 +628,40 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
 
 	new_parent = shadow_current(s);
 
+	pn = dm_block_data(new_parent);
+	size = le32_to_cpu(pn->header.flags) & INTERNAL_NODE ?
+		sizeof(__le64) : s->info->value_type.size;
+
+	/* create & init the left block */
 	r = new_block(s->info, &left);
 	if (r < 0)
 		return r;
 
+	ln = dm_block_data(left);
+	nr_left = le32_to_cpu(pn->header.nr_entries) / 2;
+
+	ln->header.flags = pn->header.flags;
+	ln->header.nr_entries = cpu_to_le32(nr_left);
+	ln->header.max_entries = pn->header.max_entries;
+	ln->header.value_size = pn->header.value_size;
+	memcpy(ln->keys, pn->keys, nr_left * sizeof(pn->keys[0]));
+	memcpy(value_ptr(ln, 0), value_ptr(pn, 0), nr_left * size);
+
+	/* create & init the right block */
 	r = new_block(s->info, &right);
 	if (r < 0) {
 		unlock_block(s->info, left);
 		return r;
 	}
 
-	pn = dm_block_data(new_parent);
-	ln = dm_block_data(left);
 	rn = dm_block_data(right);
-
-	nr_left = le32_to_cpu(pn->header.nr_entries) / 2;
 	nr_right = le32_to_cpu(pn->header.nr_entries) - nr_left;
 
-	ln->header.flags = pn->header.flags;
-	ln->header.nr_entries = cpu_to_le32(nr_left);
-	ln->header.max_entries = pn->header.max_entries;
-	ln->header.value_size = pn->header.value_size;
-
 	rn->header.flags = pn->header.flags;
 	rn->header.nr_entries = cpu_to_le32(nr_right);
 	rn->header.max_entries = pn->header.max_entries;
 	rn->header.value_size = pn->header.value_size;
-
-	memcpy(ln->keys, pn->keys, nr_left * sizeof(pn->keys[0]));
 	memcpy(rn->keys, pn->keys + nr_left, nr_right * sizeof(pn->keys[0]));
-
-	size = le32_to_cpu(pn->header.flags) & INTERNAL_NODE ?
-		sizeof(__le64) : s->info->value_type.size;
-	memcpy(value_ptr(ln, 0), value_ptr(pn, 0), nr_left * size);
 	memcpy(value_ptr(rn, 0), value_ptr(pn, nr_left),
 	       nr_right * size);
 
-- 
2.7.4
