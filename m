From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 06/12] dm: split discard requests on target
	boundaries
Date: Sat, 24 Jul 2010 12:09:22 -0400
Message-ID: <1279987768-13275-7-git-send-email-snitzer@redhat.com>
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

Update __clone_and_map_discard to loop across all targets in a DM
device's table when it processes a discard bio.  If a discard crosses a
target boundary it must be split accordingly.

Update __issue_target_requests and __issue_target_request to allow a
cloned discard bio to have a custom start sector and size.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |   51 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

Index: linux-2.6-block/drivers/md/dm.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.c
+++ linux-2.6-block/drivers/md/dm.c
@@ -1191,7 +1191,7 @@ static struct dm_target_io *alloc_tio(st
 }
 
 static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
-				   unsigned request_nr)
+				   unsigned request_nr, sector_t len)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti);
 	struct bio *clone;
@@ -1206,17 +1206,21 @@ static void __issue_target_request(struc
 	clone = bio_alloc_bioset(GFP_NOIO, ci->bio->bi_max_vecs, ci->md->bs);
 	__bio_clone(clone, ci->bio);
 	clone->bi_destructor = dm_bio_destructor;
+	if (len) {
+		clone->bi_sector = ci->sector;
+		clone->bi_size = to_bytes(len);
+	}
 
 	__map_bio(ti, clone, tio);
 }
 
 static void __issue_target_requests(struct clone_info *ci, struct dm_target *ti,
-				    unsigned num_requests)
+				    unsigned num_requests, sector_t len)
 {
 	unsigned request_nr;
 
 	for (request_nr = 0; request_nr < num_requests; request_nr++)
-		__issue_target_request(ci, ti, request_nr);
+		__issue_target_request(ci, ti, request_nr, len);
 }
 
 static int __clone_and_map_empty_barrier(struct clone_info *ci)
@@ -1225,7 +1229,7 @@ static int __clone_and_map_empty_barrier
 	struct dm_target *ti;
 
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		__issue_target_requests(ci, ti, ti->num_flush_requests);
+		__issue_target_requests(ci, ti, ti->num_flush_requests, 0);
 
 	ci->sector_count = 0;
 
@@ -1251,30 +1255,31 @@ static void __clone_and_map_simple(struc
 static int __clone_and_map_discard(struct clone_info *ci)
 {
 	struct dm_target *ti;
-	sector_t max;
-
-	ti = dm_table_find_target(ci->map, ci->sector);
-	if (!dm_target_is_valid(ti))
-		return -EIO;
-
-	/*
-	 * Even though the device advertised discard support,
-	 * reconfiguration might have changed that since the
-	 * check was performed.
-	 */
-
-	if (!ti->num_discard_requests)
-		return -EOPNOTSUPP;
+	sector_t max, len, remaining = ci->sector_count;
+	unsigned offset = 0;
 
-	max = max_io_len(ci->sector, ti);
+	do {
+		ti = dm_table_find_target(ci->map, ci->sector);
+		if (!dm_target_is_valid(ti))
+			return -EIO;
 
-	if (ci->sector_count > max)
 		/*
-		 * FIXME: Handle a discard that spans two or more targets.
+		 * Even though the device advertised discard support,
+		 * reconfiguration might have changed that since the
+		 * check was performed.
 		 */
-		return -EOPNOTSUPP;
+		if (!ti->num_discard_requests)
+			return -EOPNOTSUPP;
+
+		max = max_io_len_target_boundary(ci->sector, ti, NULL);
+		len = min(remaining, max);
 
-	__issue_target_requests(ci, ti, ti->num_discard_requests);
+		__issue_target_requests(ci, ti, ti->num_discard_requests, len);
+
+		ci->sector += len;
+		ci->sector_count -= len;
+		offset += to_bytes(len);
+	} while (remaining -= len);
 
 	ci->sector_count = 0;
 
