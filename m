From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: cleanup compiler warning
Date: Wed, 13 Jun 2012 15:58:28 -0400
Message-ID: <1339617508-21992-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Cleanup "warning: dubious: !x & y".  Also make it clear that
__snapshotted_since() returns a bool and that dm_thin_lookup_result's
'shared' member is a flag.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c |    2 +-
 drivers/md/dm-thin-metadata.h |    2 +-
 drivers/md/dm-thin.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 3e2907f..c858931 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1262,7 +1262,7 @@ dm_thin_id dm_thin_dev_id(struct dm_thin_device *td)
 	return td->id;
 }
 
-static int __snapshotted_since(struct dm_thin_device *td, uint32_t time)
+static bool __snapshotted_since(struct dm_thin_device *td, uint32_t time)
 {
 	return td->snapshotted_time > time;
 }
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index b88918c..7b47c0a 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -119,7 +119,7 @@ dm_thin_id dm_thin_dev_id(struct dm_thin_device *td);
 
 struct dm_thin_lookup_result {
 	dm_block_t block;
-	int shared;
+	unsigned shared:1;
 };
 
 /*
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 37fdaf8..b142428 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1218,7 +1218,7 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			 */
 			m = get_next_mapping(pool);
 			m->tc = tc;
-			m->pass_discard = (!lookup_result.shared) & pool->pf.discard_passdown;
+			m->pass_discard = (!lookup_result.shared) && pool->pf.discard_passdown;
 			m->virt_block = block;
 			m->data_block = lookup_result.block;
 			m->cell = cell;
-- 
1.7.4.4
