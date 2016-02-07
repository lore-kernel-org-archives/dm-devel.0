From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 03/15] dm: cleanup dm_any_congested()
Date: Sun,  7 Feb 2016 10:53:25 -0500
Message-ID: <1454860417-3203-4-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

The request-based DM support for checking queue congestion doesn't
require access to the live DM table.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 873512d..c92e356 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2135,19 +2135,18 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 	struct dm_table *map;
 
 	if (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
-		map = dm_get_live_table_fast(md);
-		if (map) {
+		if (dm_request_based(md)) {
 			/*
-			 * Request-based dm cares about only own queue for
-			 * the query about congestion status of request_queue
+			 * With request-based DM we only need to check the
+			 * top-level queue for congestion.
 			 */
-			if (dm_request_based(md))
-				r = md->queue->backing_dev_info.wb.state &
-				    bdi_bits;
-			else
+			r = md->queue->backing_dev_info.wb.state & bdi_bits;
+		} else {
+			map = dm_get_live_table_fast(md);
+			if (map)
 				r = dm_table_any_congested(map, bdi_bits);
+			dm_put_live_table_fast(md);
 		}
-		dm_put_live_table_fast(md);
 	}
 
 	return r;
-- 
2.5.4 (Apple Git-61)
