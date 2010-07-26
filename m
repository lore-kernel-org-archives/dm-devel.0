From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 05/12] dm: factor max_io_len for code reuse
Date: Mon, 26 Jul 2010 17:36:54 -0400
Message-ID: <20100726213654.GB20849@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
	<1279987768-13275-6-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1279987768-13275-6-git-send-email-snitzer@redhat.com>
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
 drivers/md/dm.c               |   22 ++++++++++++++--------
 include/linux/device-mapper.h |    2 ++
 2 files changed, 16 insertions(+), 8 deletions(-)

Index: linux-2.6-block/drivers/md/dm.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.c
+++ linux-2.6-block/drivers/md/dm.c
@@ -1029,17 +1029,23 @@ static void end_clone_request(struct req
 	dm_complete_request(clone, error);
 }
 
-static sector_t max_io_len(struct mapped_device *md,
-			   sector_t sector, struct dm_target *ti)
+static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti)
 {
-	sector_t offset = sector - ti->begin;
-	sector_t len = ti->len - offset;
+	sector_t target_offset = dm_target_offset(ti, sector);
+
+	return ti->len - target_offset;
+}
+
+static sector_t max_io_len(sector_t sector, struct dm_target *ti)
+{
+	sector_t len = max_io_len_target_boundary(sector, ti);
 
 	/*
 	 * Does the target need to split even further ?
 	 */
 	if (ti->split_io) {
 		sector_t boundary;
+		sector_t offset = dm_target_offset(ti, sector);
 		boundary = ((offset + ti->split_io) & ~(ti->split_io - 1))
 			   - offset;
 		if (len > boundary)
@@ -1257,7 +1263,7 @@ static int __clone_and_map_discard(struc
 	if (!ti->num_discard_requests)
 		return -EOPNOTSUPP;
 
-	max = max_io_len(ci->md, ci->sector, ti);
+	max = max_io_len(ci->sector, ti);
 
 	if (ci->sector_count > max)
 		/*
@@ -1289,7 +1295,7 @@ static int __clone_and_map(struct clone_
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
-	max = max_io_len(ci->md, ci->sector, ti);
+	max = max_io_len(ci->sector, ti);
 
 	if (ci->sector_count <= max) {
 		/*
@@ -1340,7 +1346,7 @@ static int __clone_and_map(struct clone_
 				if (!dm_target_is_valid(ti))
 					return -EIO;
 
-				max = max_io_len(ci->md, ci->sector, ti);
+				max = max_io_len(ci->sector, ti);
 			}
 
 			len = min(remaining, max);
@@ -1427,7 +1433,7 @@ static int dm_merge_bvec(struct request_
 	/*
 	 * Find maximum amount of I/O that won't need splitting
 	 */
-	max_sectors = min(max_io_len(md, bvm->bi_sector, ti),
+	max_sectors = min(max_io_len(bvm->bi_sector, ti),
 			  (sector_t) BIO_MAX_SECTORS);
 	max_size = (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
 	if (max_size < 0)
Index: linux-2.6-block/include/linux/device-mapper.h
===================================================================
--- linux-2.6-block.orig/include/linux/device-mapper.h
+++ linux-2.6-block/include/linux/device-mapper.h
@@ -398,6 +398,8 @@ void *dm_vcalloc(unsigned long nmemb, un
 #define dm_array_too_big(fixed, obj, num) \
 	((num) > (UINT_MAX - (fixed)) / (obj))
 
+#define dm_target_offset(ti, sector) ((sector) - (ti)->begin)
+
 static inline sector_t to_sector(unsigned long n)
 {
 	return (n >> SECTOR_SHIFT);
