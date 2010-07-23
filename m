From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 05/12] dm: factor max_io_len for code reuse
Date: Fri, 23 Jul 2010 19:23:56 -0400
Message-ID: <1279927443-1780-6-git-send-email-snitzer@redhat.com>
References: <1279927443-1780-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279927443-1780-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Split max_io_len_target_boundary out of max_io_len so that the discard
support can make use of it without duplicating max_io_len code.

Avoiding max_io_len's split_io logic enables DM's discard support to
submit the entire discard request to a target.  But discards must still
be split on target boundaries.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a9a0625..8723572 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1022,11 +1022,20 @@ static void end_clone_request(struct request *clone, int error)
 	dm_complete_request(clone, error);
 }
 
-static sector_t max_io_len(struct mapped_device *md,
-			   sector_t sector, struct dm_target *ti)
+static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti,
+					   sector_t *offset_p)
 {
 	sector_t offset = sector - ti->begin;
-	sector_t len = ti->len - offset;
+	if (offset_p)
+		*offset_p = offset;
+
+	return ti->len - offset;
+}
+
+static sector_t max_io_len(sector_t sector, struct dm_target *ti)
+{
+	sector_t offset;
+	sector_t len = max_io_len_target_boundary(sector, ti, &offset);
 
 	/*
 	 * Does the target need to split even further ?
@@ -1244,7 +1253,7 @@ static int __clone_and_map_discard(struct clone_info *ci)
 	if (!ti->num_discard_requests)
 		return -EOPNOTSUPP;
 
-	max = max_io_len(ci->md, ci->sector, ti);
+	max = max_io_len(ci->sector, ti);
 
 	if (ci->sector_count > max)
 		/*
@@ -1276,7 +1285,7 @@ static int __clone_and_map(struct clone_info *ci)
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
-	max = max_io_len(ci->md, ci->sector, ti);
+	max = max_io_len(ci->sector, ti);
 
 	if (ci->sector_count <= max) {
 		/*
@@ -1327,7 +1336,7 @@ static int __clone_and_map(struct clone_info *ci)
 				if (!dm_target_is_valid(ti))
 					return -EIO;
 
-				max = max_io_len(ci->md, ci->sector, ti);
+				max = max_io_len(ci->sector, ti);
 			}
 
 			len = min(remaining, max);
@@ -1414,7 +1423,7 @@ static int dm_merge_bvec(struct request_queue *q,
 	/*
 	 * Find maximum amount of I/O that won't need splitting
 	 */
-	max_sectors = min(max_io_len(md, bvm->bi_sector, ti),
+	max_sectors = min(max_io_len(bvm->bi_sector, ti),
 			  (sector_t) BIO_MAX_SECTORS);
 	max_size = (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
 	if (max_size < 0)
-- 
1.6.6.1
