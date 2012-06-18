From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-stripe: Optimize chunk_size divisions and
	modulos
Date: Mon, 18 Jun 2012 09:21:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206180920070.17218@file.rdu.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch optimizes dm-stripe if chunk_size is a power of two. It should 
be applied after "dm-stripe-support-for-non-power-of-2-chunksize.patch".

Mikulas

---

dm-stripe: Optimize chunk_size divisions and modulos

dm-stripe is usually used with a chunk size that is a power of two.
Previous code used slow divide and modulo operations with a power-of-two
chunk size. This patch changes it to use faster shifts and bit masks.

stripe_width is already optimized in a similar way.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

Index: linux-3.4.2-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-3.4.2-fast.orig/drivers/md/dm-stripe.c	2012-06-18 11:39:36.000000000 +0200
+++ linux-3.4.2-fast/drivers/md/dm-stripe.c	2012-06-18 12:52:40.000000000 +0200
@@ -32,6 +32,7 @@ struct stripe_c {
 	sector_t stripe_width;
 
 	uint32_t chunk_size;
+	int chunk_size_shift;
 
 	/* Needed for handling events */
 	struct dm_target *ti;
@@ -170,6 +171,10 @@ static int stripe_ctr(struct dm_target *
 	ti->num_discard_requests = stripes;
 
 	sc->chunk_size = chunk_size;
+	if (chunk_size & (chunk_size - 1))
+		sc->chunk_size_shift = -1;
+	else
+		sc->chunk_size_shift = __ffs(chunk_size);
 
 	/*
 	 * Get the stripe destinations.
@@ -209,7 +214,14 @@ static void stripe_map_sector(struct str
 			      uint32_t *stripe, sector_t *result)
 {
 	sector_t chunk = dm_target_offset(sc->ti, sector);
-	sector_t chunk_offset = sector_div(chunk, sc->chunk_size);
+	sector_t chunk_offset;
+
+	if (sc->chunk_size_shift < 0)
+		chunk_offset = sector_div(chunk, sc->chunk_size);
+	else {
+		chunk_offset = chunk & (sc->chunk_size - 1);
+		chunk >>= sc->chunk_size_shift;
+	}
 
 	if (sc->stripes_shift < 0)
 		*stripe = sector_div(chunk, sc->stripes);
@@ -218,7 +230,12 @@ static void stripe_map_sector(struct str
 		chunk >>= sc->stripes_shift;
 	}
 
-	*result = (chunk * sc->chunk_size) + chunk_offset;
+	if (sc->chunk_size_shift < 0)
+		chunk *= sc->chunk_size;
+	else
+		chunk <<= sc->chunk_size_shift;
+
+	*result = chunk + chunk_offset;
 }
 
 static void stripe_map_range_sector(struct stripe_c *sc, sector_t sector,
@@ -232,7 +249,10 @@ static void stripe_map_range_sector(stru
 
 	/* round down */
 	sector = *result;
-	*result -= sector_div(sector, sc->chunk_size);
+	if (sc->chunk_size_shift < 0)
+		*result -= sector_div(sector, sc->chunk_size);
+	else
+		*result = sector & ~(sector_t)(sc->chunk_size - 1);
 
 	if (target_stripe < stripe)
 		*result += sc->chunk_size;		/* next chunk */
