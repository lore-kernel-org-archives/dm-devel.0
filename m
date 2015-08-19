From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm btree: add ref counting ops for the leaves of top level
 btrees
Date: Wed, 19 Aug 2015 14:45:43 -0400
Message-ID: <20150819184542.GA11505@redhat.com>
References: <1440000907540@kroah.com>
 <20150819163309.GA25908@redhat.com>
 <20150819164255.GA19661@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150819164255.GA19661@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: ejt@redhat.com, stable@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This stable@ backport drops the dm-btree-remove.c:remove_one() hunk
from the original commit because it isn't relevant for stable.

Upstream linux.git commit b0dc3c8bc157c60b1d470163882be8c13e1950af
Author: Joe Thornber <ejt@redhat.com>
Date:   Wed Aug 12 15:12:09 2015 +0100

    dm btree: add ref counting ops for the leaves of top level btrees

    When using nested btrees, the top leaves of the top levels contain
    block addresses for the root of the next tree down.  If we shadow a
    shared leaf node the leaf values (sub tree roots) should be incremented
    accordingly.

    This is only an issue if there is metadata sharing in the top levels.
    Which only occurs if metadata snapshots are being used (as is possible
    with dm-thinp).  And could result in a block from the thinp metadata
    snap being reused early, thus corrupting the thinp metadata snap.

    Signed-off-by: Joe Thornber <ejt@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org
---
 drivers/md/persistent-data/dm-btree-internal.h |  6 +++++
 drivers/md/persistent-data/dm-btree-remove.c   | 12 +++------
 drivers/md/persistent-data/dm-btree-spine.c    | 37 ++++++++++++++++++++++++++
 drivers/md/persistent-data/dm-btree.c          |  7 +----
 4 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index bf2b80d..8731b6e 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -138,4 +138,10 @@ int lower_bound(struct btree_node *n, uint64_t key);
 
 extern struct dm_block_validator btree_node_validator;
 
+/*
+ * Value type for upper levels of multi-level btrees.
+ */
+extern void init_le64_type(struct dm_transaction_manager *tm,
+			   struct dm_btree_value_type *vt);
+
 #endif	/* DM_BTREE_INTERNAL_H */
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index b88757c..ff96197 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -544,14 +544,6 @@ static int remove_raw(struct shadow_spine *s, struct dm_btree_info *info,
 	return r;
 }
 
-static struct dm_btree_value_type le64_type = {
-	.context = NULL,
-	.size = sizeof(__le64),
-	.inc = NULL,
-	.dec = NULL,
-	.equal = NULL
-};
-
 int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 		    uint64_t *keys, dm_block_t *new_root)
 {
@@ -559,12 +551,14 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 	int index = 0, r = 0;
 	struct shadow_spine spine;
 	struct btree_node *n;
+	struct dm_btree_value_type le64_vt;
 
+	init_le64_type(info->tm, &le64_vt);
 	init_shadow_spine(&spine, info);
 	for (level = 0; level < info->levels; level++) {
 		r = remove_raw(&spine, info,
 			       (level == last_level ?
-				&info->value_type : &le64_type),
+				&info->value_type : &le64_vt),
 			       root, keys[level], (unsigned *)&index);
 		if (r < 0)
 			break;
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index 1b5e13e..0dee514 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -249,3 +249,40 @@ int shadow_root(struct shadow_spine *s)
 {
 	return s->root;
 }
+
+static void le64_inc(void *context, const void *value_le)
+{
+	struct dm_transaction_manager *tm = context;
+	__le64 v_le;
+
+	memcpy(&v_le, value_le, sizeof(v_le));
+	dm_tm_inc(tm, le64_to_cpu(v_le));
+}
+
+static void le64_dec(void *context, const void *value_le)
+{
+	struct dm_transaction_manager *tm = context;
+	__le64 v_le;
+
+	memcpy(&v_le, value_le, sizeof(v_le));
+	dm_tm_dec(tm, le64_to_cpu(v_le));
+}
+
+static int le64_equal(void *context, const void *value1_le, const void *value2_le)
+{
+	__le64 v1_le, v2_le;
+
+	memcpy(&v1_le, value1_le, sizeof(v1_le));
+	memcpy(&v2_le, value2_le, sizeof(v2_le));
+	return v1_le == v2_le;
+}
+
+void init_le64_type(struct dm_transaction_manager *tm,
+		    struct dm_btree_value_type *vt)
+{
+	vt->context = tm;
+	vt->size = sizeof(__le64);
+	vt->inc = le64_inc;
+	vt->dec = le64_dec;
+	vt->equal = le64_equal;
+}
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 200ac12..41e1ab2 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -667,12 +667,7 @@ static int insert(struct dm_btree_info *info, dm_block_t root,
 	struct btree_node *n;
 	struct dm_btree_value_type le64_type;
 
-	le64_type.context = NULL;
-	le64_type.size = sizeof(__le64);
-	le64_type.inc = NULL;
-	le64_type.dec = NULL;
-	le64_type.equal = NULL;
-
+	init_le64_type(info->tm, &le64_type);
 	init_shadow_spine(&spine, info);
 
 	for (level = 0; level < (info->levels - 1); level++) {
-- 
2.3.2 (Apple Git-55)
