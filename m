From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 06/12] dm: split discard requests on target
	boundaries
Date: Fri, 23 Jul 2010 19:23:57 -0400
Message-ID: <1279927443-1780-7-git-send-email-snitzer@redhat.com>
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

Update __clone_and_map_discard to loop across all targets in a DM
device's table when it processes a discard bio.  If a discard crosses a
target boundary it must be split accordingly.

Update __issue_target_requests and __issue_target_request to allow a
cloned discard bio to have a custom start sector and size.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8723572..539d820 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1184,7 +1184,7 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci,
 }
 
 static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
-				   unsigned request_nr)
+				   unsigned request_nr, sector_t len)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti);
 	struct bio *clone;
@@ -1199,17 +1199,21 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
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
@@ -1218,7 +1222,7 @@ static int __clone_and_map_empty_barrier(struct clone_info *ci)
 	struct dm_target *ti;
 
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		__issue_target_requests(ci, ti, ti->num_flush_requests);
+		__issue_target_requests(ci, ti, ti->num_flush_requests, 0);
 
 	ci->sector_count = 0;
 
@@ -1244,24 +1248,26 @@ static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 static int __clone_and_map_discard(struct clone_info *ci)
 {
 	struct dm_target *ti;
-	sector_t max;
+	sector_t max, len, remaining = ci->sector_count;
+	unsigned offset = 0;
 
-	ti = dm_table_find_target(ci->map, ci->sector);
-	if (!dm_target_is_valid(ti))
-		return -EIO;
+	do {
+		ti = dm_table_find_target(ci->map, ci->sector);
+		if (!dm_target_is_valid(ti))
+			return -EIO;
 
-	if (!ti->num_discard_requests)
-		return -EOPNOTSUPP;
+		if (!ti->num_discard_requests)
+			return -EOPNOTSUPP;
 
-	max = max_io_len(ci->sector, ti);
+		max = max_io_len_target_boundary(ci->sector, ti, NULL);
+		len = min(remaining, max);
 
-	if (ci->sector_count > max)
-		/*
-		 * FIXME: Handle a discard that spans two or more targets.
-		 */
-		return -EOPNOTSUPP;
+		__issue_target_requests(ci, ti, ti->num_discard_requests, len);
 
-	__issue_target_requests(ci, ti, ti->num_discard_requests);
+		ci->sector += len;
+		ci->sector_count -= len;
+		offset += to_bytes(len);
+	} while (remaining -= len);
 
 	ci->sector_count = 0;
 
-- 
1.6.6.1
