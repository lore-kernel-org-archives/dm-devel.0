From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-stripe: discard support
Date: Tue, 27 Jul 2010 17:42:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

A simplified discard support.

Note --- it is untested (I tested only non-discard requests). Mike, please 
test.

Mikulas

---

Support discard request on stripe target

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux-2.6.35-rc6-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.35-rc6-fast.orig/drivers/md/dm-stripe.c	2010-07-27 23:32:57.000000000 +0200
+++ linux-2.6.35-rc6-fast/drivers/md/dm-stripe.c	2010-07-27 23:39:32.000000000 +0200
@@ -167,6 +167,7 @@ static int stripe_ctr(struct dm_target *
 	sc->stripe_width = width;
 	ti->split_io = chunk_size;
 	ti->num_flush_requests = stripes;
+	ti->num_discard_requests = stripes;
 
 	sc->chunk_mask = ((sector_t) chunk_size) - 1;
 	for (sc->chunk_shift = 0; chunk_size; sc->chunk_shift++)
@@ -216,6 +217,37 @@ static void stripe_map_sector(struct str
 	*result = (chunk << sc->chunk_shift) | (offset & sc->chunk_mask);
 }
 
+static void stripe_map_range_sector(struct stripe_c *sc, sector_t sector,
+				    uint32_t target_stripe, sector_t *result)
+{
+	uint32_t stripe;
+	stripe_map_sector(sc, sector, &stripe, result);
+	if (stripe == target_stripe)
+		return;
+	*result &= ~sc->chunk_mask;			/* round down */
+	if (target_stripe < stripe)
+		*result += sc->chunk_mask + 1;		/* next chunk */
+}
+
+static int stripe_map_discard(struct stripe_c *sc, struct bio *bio,
+			      uint32_t target_stripe)
+{
+	sector_t begin, end;
+	stripe_map_range_sector(sc, bio->bi_sector, target_stripe, &begin);
+	stripe_map_range_sector(sc, bio->bi_sector + bio_sectors(bio),
+				  target_stripe, &end);
+	if (begin < end) {
+		bio->bi_bdev = sc->stripe[target_stripe].dev->bdev;
+		bio->bi_sector = begin + sc->stripe[target_stripe].physical_start;
+		bio->bi_size = to_bytes(end - begin);
+		return DM_MAPIO_REMAPPED;
+	} else {
+		/* The range doesn't map to the target stripe */
+		bio_endio(bio, 0);
+		return DM_MAPIO_SUBMITTED;
+	}
+}
+
 static int stripe_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
@@ -227,6 +259,10 @@ static int stripe_map(struct dm_target *
 		bio->bi_bdev = sc->stripe[map_context->request_nr].dev->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
+	if (unlikely(bio_rw_flagged(bio, BIO_RW_DISCARD))) {
+		BUG_ON(map_context->request_nr >= sc->stripes);
+		return stripe_map_discard(sc, bio, map_context->request_nr);
+	}
 
 	stripe_map_sector(sc, bio->bi_sector, &stripe, &bio->bi_sector);
 
