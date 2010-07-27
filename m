From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-stripe: move sector translation to a
	function
Date: Tue, 27 Jul 2010 17:38:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Abstract sector translation in dm-stripe

Abstract sector -> stripe, sector translation to a function.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6.35-rc6-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.35-rc6-fast.orig/drivers/md/dm-stripe.c	2010-07-27 22:43:40.000000000 +0200
+++ linux-2.6.35-rc6-fast/drivers/md/dm-stripe.c	2010-07-27 23:08:28.000000000 +0200
@@ -207,11 +207,19 @@ static void stripe_dtr(struct dm_target 
 	kfree(sc);
 }
 
+static void stripe_map_sector(struct stripe_c *sc, sector_t sector,
+			      uint32_t *stripe, sector_t *result)
+{
+	sector_t offset = sector - sc->ti->begin;
+	sector_t chunk = offset >> sc->chunk_shift;
+	*stripe = sector_div(chunk, sc->stripes);
+	*result = (chunk << sc->chunk_shift) | (offset & sc->chunk_mask);
+}
+
 static int stripe_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
 	struct stripe_c *sc = (struct stripe_c *) ti->private;
-	sector_t offset, chunk;
 	uint32_t stripe;
 
 	if (unlikely(bio_empty_barrier(bio))) {
@@ -220,13 +228,11 @@ static int stripe_map(struct dm_target *
 		return DM_MAPIO_REMAPPED;
 	}
 
-	offset = bio->bi_sector - ti->begin;
-	chunk = offset >> sc->chunk_shift;
-	stripe = sector_div(chunk, sc->stripes);
+	stripe_map_sector(sc, bio->bi_sector, &stripe, &bio->bi_sector);
 
+	bio->bi_sector += sc->stripe[stripe].physical_start;
 	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
-	bio->bi_sector = sc->stripe[stripe].physical_start +
-	    (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
+
 	return DM_MAPIO_REMAPPED;
 }
 
