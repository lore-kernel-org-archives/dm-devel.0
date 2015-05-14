From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 13/14] dm thin: cleanup schedule_zero()
	to read more logically
Date: Thu, 14 May 2015 17:05:11 -0400
Message-ID: <1431637512-64245-14-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The overwrite has only ever about optimizing away the need to zero a
block if the entire block was being overwritten.  As such it is only
relevant when zeroing is enabled.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index b316450..4aea876 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1209,16 +1209,14 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	 * zeroing pre-existing data, we can issue the bio immediately.
 	 * Otherwise we use kcopyd to zero the data first.
 	 */
-	if (!pool->pf.zero_new_blocks)
+	if (pool->pf.zero_new_blocks) {
+		if (io_overwrites_block(pool, bio))
+			remap_and_issue_overwrite(tc, bio, data_block, m);
+		else
+			ll_zero(tc, m, data_block * pool->sectors_per_block,
+				(data_block + 1) * pool->sectors_per_block);
+	} else
 		process_prepared_mapping(m);
-
-	else if (io_overwrites_block(pool, bio))
-		remap_and_issue_overwrite(tc, bio, data_block, m);
-
-	else
-		ll_zero(tc, m,
-			data_block * pool->sectors_per_block,
-			(data_block + 1) * pool->sectors_per_block);
 }
 
 static void schedule_external_copy(struct thin_c *tc, dm_block_t virt_block,
-- 
2.3.2 (Apple Git-55)
