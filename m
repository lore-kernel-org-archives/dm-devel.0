From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 10/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 04:00:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-stripe-flush.patch

Flush support for the stripe target.

This sets ti->num_flush_requests to the number of stripes and
remaps individual flushr requests to the appropriate stripe devices.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-stripe.c	2009-04-10 06:08:40.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-stripe.c	2009-04-10 06:33:40.000000000 +0200
@@ -167,6 +167,7 @@ static int stripe_ctr(struct dm_target *
 	sc->stripes = stripes;
 	sc->stripe_width = width;
 	ti->split_io = chunk_size;
+	ti->num_flush_requests = stripes;
 
 	sc->chunk_mask = ((sector_t) chunk_size) - 1;
 	for (sc->chunk_shift = 0; chunk_size; sc->chunk_shift++)
@@ -211,10 +212,18 @@ static int stripe_map(struct dm_target *
 		      union map_info *map_context)
 {
 	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	sector_t offset, chunk;
+	uint32_t stripe;
 
-	sector_t offset = bio->bi_sector - ti->begin;
-	sector_t chunk = offset >> sc->chunk_shift;
-	uint32_t stripe = sector_div(chunk, sc->stripes);
+	if (unlikely(bio_empty_barrier(bio))) {
+		BUG_ON(map_context->flush_request >= sc->stripes);
+		bio->bi_bdev = sc->stripe[map_context->flush_request].dev->bdev;
+		return DM_MAPIO_REMAPPED;
+	}
+
+	offset = bio->bi_sector - ti->begin;
+	chunk = offset >> sc->chunk_shift;
+	stripe = sector_div(chunk, sc->stripes);
 
 	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
 	bio->bi_sector = sc->stripe[stripe].physical_start +
