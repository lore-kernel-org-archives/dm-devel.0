From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 05/12] dm: factor max_io_len for code reuse
Date: Sat, 24 Jul 2010 12:09:21 -0400
Message-ID: <1279987768-13275-6-git-send-email-snitzer@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
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
 1 file changed, 16 insertions(+), 7 deletions(-)

Index: linux-2.6-block/drivers/md/dm.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.c
+++ linux-2.6-block/drivers/md/dm.c
@@ -1029,11 +1029,20 @@ static void end_clone_request(struct req
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
@@ -1257,7 +1266,7 @@ static int __clone_and_map_discard(struc
 	if (!ti->num_discard_requests)
 		return -EOPNOTSUPP;
 
-	max = max_io_len(ci->md, ci->sector, ti);
+	max = max_io_len(ci->sector, ti);
 
 	if (ci->sector_count > max)
 		/*
@@ -1289,7 +1298,7 @@ static int __clone_and_map(struct clone_
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
-	max = max_io_len(ci->md, ci->sector, ti);
+	max = max_io_len(ci->sector, ti);
 
 	if (ci->sector_count <= max) {
 		/*
@@ -1340,7 +1349,7 @@ static int __clone_and_map(struct clone_
 				if (!dm_target_is_valid(ti))
 					return -EIO;
 
-				max = max_io_len(ci->md, ci->sector, ti);
+				max = max_io_len(ci->sector, ti);
 			}
 
 			len = min(remaining, max);
@@ -1427,7 +1436,7 @@ static int dm_merge_bvec(struct request_
 	/*
 	 * Find maximum amount of I/O that won't need splitting
 	 */
-	max_sectors = min(max_io_len(md, bvm->bi_sector, ti),
+	max_sectors = min(max_io_len(bvm->bi_sector, ti),
 			  (sector_t) BIO_MAX_SECTORS);
 	max_size = (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
 	if (max_size < 0)
