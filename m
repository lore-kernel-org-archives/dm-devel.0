From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: fix limits initialization when there are no data devices
Date: Thu,  7 Feb 2013 10:11:19 -0500
Message-ID: <1360249879-29636-1-git-send-email-snitzer@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org.#.v3.6+
List-Id: dm-devel.ids

From: Mike Christie <michaelc@cs.wisc.edu>

dm_calculate_queue_limits will first reset the provided limits to
defaults using blk_set_stacking_limits; whereby defeating the purpose of
retaining the original live table's limits -- as was intended via commit
3ae706561637331aa578e52bb89ecbba5edcb7a9 ("dm: retain table limits when
swapping to new table with no devices").

Fix this improper limits initialization (in the no data devices case) by
avoiding the call to dm_calculate_queue_limits.

[patch header was revised by Mike Snitzer]

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # v3.6+
---
 drivers/md/dm.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 314a0e2..21f294b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2421,7 +2421,7 @@ static void dm_queue_flush(struct mapped_device *md)
  */
 struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
-	struct dm_table *live_map, *map = ERR_PTR(-EINVAL);
+	struct dm_table *live_map = NULL, *map = ERR_PTR(-EINVAL);
 	struct queue_limits limits;
 	int r;
 
@@ -2444,10 +2444,12 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		dm_table_put(live_map);
 	}
 
-	r = dm_calculate_queue_limits(table, &limits);
-	if (r) {
-		map = ERR_PTR(r);
-		goto out;
+	if (!live_map) {
+		r = dm_calculate_queue_limits(table, &limits);
+		if (r) {
+			map = ERR_PTR(r);
+			goto out;
+		}
 	}
 
 	map = __bind(md, table, &limits);
-- 
1.7.4.4
