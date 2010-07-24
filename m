From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 04/12] dm: use common __issue_target_request
	for flush and discard support
Date: Sat, 24 Jul 2010 12:09:20 -0400
Message-ID: <1279987768-13275-5-git-send-email-snitzer@redhat.com>
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

Rename __flush_target to __issue_target_request now that it is used to
issue both flush and discard requests.

Introduce __issue_target_requests as a convenient wrapper to
__issue_target_request 'num_flush_requests' or 'num_discard_requests'
times per target.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

Index: linux-2.6-block/drivers/md/dm.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.c
+++ linux-2.6-block/drivers/md/dm.c
@@ -1181,30 +1181,42 @@ static struct dm_target_io *alloc_tio(st
 	return tio;
 }
 
-static void __flush_target(struct clone_info *ci, struct dm_target *ti,
-			  unsigned request_nr)
+static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
+				   unsigned request_nr)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti);
 	struct bio *clone;
 
 	tio->info.target_request_nr = request_nr;
 
-	clone = bio_alloc_bioset(GFP_NOIO, 0, ci->md->bs);
+	/*
+	 * Discard requests require the bio's inline iovecs be initialized.
+	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
+	 * and discard, so no need for concern about wasted bvec allocations.
+	 */
+	clone = bio_alloc_bioset(GFP_NOIO, ci->bio->bi_max_vecs, ci->md->bs);
 	__bio_clone(clone, ci->bio);
 	clone->bi_destructor = dm_bio_destructor;
 
 	__map_bio(ti, clone, tio);
 }
 
+static void __issue_target_requests(struct clone_info *ci, struct dm_target *ti,
+				    unsigned num_requests)
+{
+	unsigned request_nr;
+
+	for (request_nr = 0; request_nr < num_requests; request_nr++)
+		__issue_target_request(ci, ti, request_nr);
+}
+
 static int __clone_and_map_empty_barrier(struct clone_info *ci)
 {
-	unsigned target_nr = 0, request_nr;
+	unsigned target_nr = 0;
 	struct dm_target *ti;
 
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		for (request_nr = 0; request_nr < ti->num_flush_requests;
-		     request_nr++)
-			__flush_target(ci, ti, request_nr);
+		__issue_target_requests(ci, ti, ti->num_flush_requests);
 
 	ci->sector_count = 0;
 
@@ -1253,7 +1265,9 @@ static int __clone_and_map_discard(struc
 		 */
 		return -EOPNOTSUPP;
 
-	__clone_and_map_simple(ci, ti);
+	__issue_target_requests(ci, ti, ti->num_discard_requests);
+
+	ci->sector_count = 0;
 
 	return 0;
 }
