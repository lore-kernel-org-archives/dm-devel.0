From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2 v2] dm stripe: move sector translation to a
	function
Date: Wed, 28 Jul 2010 13:09:10 -0400
Message-ID: <20100728170909.GA9036@redhat.com>
References: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Abstract sector -> stripe translation to a function.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-stripe.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

v2: fix conflict with newly staged dm_target_offset changes

Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c
+++ linux-2.6/drivers/md/dm-stripe.c
@@ -207,11 +207,19 @@ static void stripe_dtr(struct dm_target 
 	kfree(sc);
 }
 
+static void stripe_map_sector(struct stripe_c *sc, sector_t sector,
+			      uint32_t *stripe, sector_t *result)
+{
+	sector_t offset = dm_target_offset(sc->ti, sector);
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
 	unsigned target_request_nr;
 
@@ -222,13 +230,11 @@ static int stripe_map(struct dm_target *
 		return DM_MAPIO_REMAPPED;
 	}
 
-	offset = dm_target_offset(ti, bio->bi_sector);
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
 
