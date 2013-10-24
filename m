From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 02/24] dm space map disk: optimise
	sm_disk_dec_block
Date: Thu, 24 Oct 2013 14:30:15 -0400
Message-ID: <1382639437-27007-3-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Don't waste time spotting blocks that have been allocated and then freed
in the same transaction.

The extra lookup is expensive, and I don't think it really gives us much.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-disk.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index e735a6d..cfbf961 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -140,26 +140,10 @@ static int sm_disk_inc_block(struct dm_space_map *sm, dm_block_t b)
 
 static int sm_disk_dec_block(struct dm_space_map *sm, dm_block_t b)
 {
-	int r;
-	uint32_t old_count;
 	enum allocation_event ev;
 	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
 
-	r = sm_ll_dec(&smd->ll, b, &ev);
-	if (!r && (ev == SM_FREE)) {
-		/*
-		 * It's only free if it's also free in the last
-		 * transaction.
-		 */
-		r = sm_ll_lookup(&smd->old_ll, b, &old_count);
-		if (r)
-			return r;
-
-		if (!old_count)
-			smd->nr_allocated_this_transaction--;
-	}
-
-	return r;
+	return sm_ll_dec(&smd->ll, b, &ev);
 }
 
 static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
-- 
1.8.1.4
