From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 1/8] [persistent-data] Fix a bug in btree_del,
	and another bug that was compensating for it.
Date: Thu, 13 Dec 2012 20:19:09 +0000
Message-ID: <1355429956-22785-2-git-send-email-ejt@redhat.com>
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

When deleting nested btrees the inner most btree wasn't being deleted.

The thin-metadata code was serendipitously compensating for this by
claiming there was one extra layer in the tree.
---
 drivers/md/dm-thin-metadata.c         |    2 +-
 drivers/md/persistent-data/dm-btree.c |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 8a813a4..00cee02 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -408,7 +408,7 @@ static void __setup_btree_details(struct dm_pool_metadata *pmd)
 
 	pmd->tl_info.tm = pmd->tm;
 	pmd->tl_info.levels = 1;
-	pmd->tl_info.value_type.context = &pmd->info;
+	pmd->tl_info.value_type.context = &pmd->bl_info;
 	pmd->tl_info.value_type.size = sizeof(__le64);
 	pmd->tl_info.value_type.inc = subtree_inc;
 	pmd->tl_info.value_type.dec = subtree_dec;
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 371f3d4..4caf669 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -230,6 +230,11 @@ static void pop_frame(struct del_stack *s)
 	dm_tm_unlock(s->tm, f->b);
 }
 
+static bool is_internal_level(struct dm_btree_info *info, struct frame *f)
+{
+	return f->level < (info->levels - 1);
+}
+
 int dm_btree_del(struct dm_btree_info *info, dm_block_t root)
 {
 	int r;
@@ -241,7 +246,7 @@ int dm_btree_del(struct dm_btree_info *info, dm_block_t root)
 	s->tm = info->tm;
 	s->top = -1;
 
-	r = push_frame(s, root, 1);
+	r = push_frame(s, root, 0);
 	if (r)
 		goto out;
 
@@ -267,7 +272,7 @@ int dm_btree_del(struct dm_btree_info *info, dm_block_t root)
 			if (r)
 				goto out;
 
-		} else if (f->level != (info->levels - 1)) {
+		} else if (is_internal_level(info, f)) {
 			b = value64(f->n, f->current_child);
 			f->current_child++;
 			r = push_frame(s, b, f->level + 1);
-- 
1.7.10.4
