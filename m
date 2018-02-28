From: Qu Wenruo <wqu@suse.com>
Subject: [PATCH] dm: log-writes: record metadata flag for better
	flags record
Date: Wed, 28 Feb 2018 15:32:47 +0800
Message-ID: <20180228073247.30020-1-wqu@suse.com>
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
To: dm-devel@redhat.com, jbacik@fb.com
List-Id: dm-devel.ids

So developer could distinguish data and metadata bios easier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 drivers/md/dm-log-writes.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 189badbeddaf..c7f4a592d14d 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -52,10 +52,11 @@
  * in fact we want to do the data and the discard in the order that they
  * completed.
  */
-#define LOG_FLUSH_FLAG (1 << 0)
-#define LOG_FUA_FLAG (1 << 1)
-#define LOG_DISCARD_FLAG (1 << 2)
-#define LOG_MARK_FLAG (1 << 3)
+#define LOG_FLUSH_FLAG		(1 << 0)
+#define LOG_FUA_FLAG		(1 << 1)
+#define LOG_DISCARD_FLAG	(1 << 2)
+#define LOG_MARK_FLAG		(1 << 3)
+#define LOG_METADATA_FLAG	(1 << 4)
 
 #define WRITE_LOG_VERSION 1ULL
 #define WRITE_LOG_MAGIC 0x6a736677736872ULL
@@ -699,6 +700,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	bool flush_bio = (bio->bi_opf & REQ_PREFLUSH);
 	bool fua_bio = (bio->bi_opf & REQ_FUA);
 	bool discard_bio = (bio_op(bio) == REQ_OP_DISCARD);
+	bool meta_bio = (bio->bi_opf & REQ_META);
 
 	pb->block = NULL;
 
@@ -743,6 +745,8 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 		block->flags |= LOG_FUA_FLAG;
 	if (discard_bio)
 		block->flags |= LOG_DISCARD_FLAG;
+	if (meta_bio)
+		block->flags |= LOG_METADATA_FLAG;
 
 	block->sector = bio_to_dev_sectors(lc, bio->bi_iter.bi_sector);
 	block->nr_sectors = bio_to_dev_sectors(lc, bio_sectors(bio));
-- 
2.16.2
