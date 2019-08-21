From: Zhang Tao <kontais@zoho.com>
Subject: [PATCH] dm table: fix a potential array out of bounds
Date: Wed, 21 Aug 2019 09:33:31 +0800
Message-ID: <1566351211-13280-1-git-send-email-kontais@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Zhang Tao <zhangtao27@lenovo.com>
List-Id: dm-devel.ids

From: Zhang Tao <zhangtao27@lenovo.com>

allocate num + 1 for target and offset array, n_highs need num + 1
elements, the last element will be used for node lookup in function
dm_table_find_target.

Signed-off-by: Zhang Tao <zhangtao27@lenovo.com>
---
 drivers/md/dm-table.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 7b6c3ee..fd7f604 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -160,20 +160,22 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 {
 	sector_t *n_highs;
 	struct dm_target *n_targets;
+	unsigned int alloc_num;
 
 	/*
 	 * Allocate both the target array and offset array at once.
 	 * Append an empty entry to catch sectors beyond the end of
 	 * the device.
 	 */
-	n_highs = (sector_t *) dm_vcalloc(num + 1, sizeof(struct dm_target) +
+	alloc_num = num + 1;
+	n_highs = (sector_t *) dm_vcalloc(alloc_num, sizeof(struct dm_target) +
 					  sizeof(sector_t));
 	if (!n_highs)
 		return -ENOMEM;
 
-	n_targets = (struct dm_target *) (n_highs + num);
+	n_targets = (struct dm_target *) (n_highs + alloc_num);
 
-	memset(n_highs, -1, sizeof(*n_highs) * num);
+	memset(n_highs, -1, sizeof(*n_highs) * alloc_num);
 	vfree(t->highs);
 
 	t->num_allocated = num;
-- 
1.8.3.1
