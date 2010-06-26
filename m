From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 2/2] dm: add support for splitting discard
	requests
Date: Sat, 26 Jun 2010 16:31:25 -0400
Message-ID: <1277584285-13774-2-git-send-email-snitzer@redhat.com>
References: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
List-Id: dm-devel.ids

Enable the striped target to support discard requests by splitting a
single discard into N discards on a stripe chunk size boundary.

Follow on core block layer work to merge discards would be helpful.

This work relies on DM's clone_bio() always having BIO_RW_BARRIER set
for discard requests.  Without BIO_RW_BARRIER the block layer will spew
"blk: request botched" warnings for discards that were split by DM.
- this clearly needs further investigation!

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-stripe.c |    1 +
 drivers/md/dm-table.c  |    6 ------
 drivers/md/dm.c        |   37 +++++++++++++++++++++++++++++++++----
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index e610725..052f254 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -349,6 +349,7 @@ static struct target_type stripe_target = {
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
+	.features = DM_TARGET_SUPPORTS_DISCARDS,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a825a7b..b38fdb3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -911,12 +911,6 @@ int dm_table_complete(struct dm_table *t)
 	int r = 0;
 	unsigned int leaf_nodes;
 
-	/*
-	 * We only support discards if there is exactly one underlying device.
-	 */
-	if (!list_is_singular(&t->devices))
-		t->discards_supported = 0;
-
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 232332a..a08b1d3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1137,7 +1137,12 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 
 	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
 	__bio_clone(clone, bio);
-	clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
+	if (!bio_rw_flagged(bio, BIO_RW_DISCARD))
+		clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
+	else if (!bio_rw_flagged(bio, BIO_RW_BARRIER)) {
+		/* discard w/o barrier results in "blk: request botched" */
+		clone->bi_rw |= (1 << BIO_RW_BARRIER);
+	}
 	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
@@ -1217,7 +1222,7 @@ static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 static int __clone_and_map_discard(struct clone_info *ci)
 {
 	struct dm_target *ti;
-	sector_t max;
+	sector_t len = 0, max;
 
 	if (!dm_table_supports_discards(ci->map))
 		return -EOPNOTSUPP;
@@ -1232,9 +1237,33 @@ static int __clone_and_map_discard(struct clone_info *ci)
 		__clone_and_map_simple(ci, ti);
 	else {
 		/*
-		 * FIXME: Handle a discard that spans two or more targets.
+		 * Handle a discard that spans two or more targets.
 		 */
-		return -EOPNOTSUPP;
+		struct bio *clone;
+		struct dm_target_io *tio;
+		sector_t remaining = ci->sector_count;
+		unsigned int offset = 0;
+
+		do {
+			if (offset) {
+				ti = dm_table_find_target(ci->map, ci->sector);
+				if (!dm_target_is_valid(ti))
+					return -EIO;
+
+				max = max_io_len(ci->md, ci->sector, ti);
+			}
+
+			len = min(remaining, max);
+
+			tio = alloc_tio(ci, ti);
+			clone = clone_bio(ci->bio, ci->sector, 0,
+					  0, len, ci->md->bs);
+			__map_bio(ti, clone, tio);
+
+			ci->sector += len;
+			ci->sector_count -= len;
+			offset += to_bytes(len);
+		} while (remaining -= len);
 	}
 
 	return 0;
-- 
1.6.5.rc2
