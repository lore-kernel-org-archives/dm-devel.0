From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/3] dm stripe: support for non power of 2
	chunksize
Date: Fri,  4 May 2012 23:57:10 -0400
Message-ID: <1336190230-11243-3-git-send-email-snitzer@redhat.com>
References: <1336190230-11243-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336190230-11243-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

Non power of 2 chunksize support is needed to properly align stripe IO
on storage that has non power of 2 optimal IO sizes (e.g. RAID6 10+2).

Use do_div wrappers to support non power of 2 chunksize for the pool's
data device.  do_div provides comparable performance to the power of 2
math that was performed until now (as tested on modern x86_64 hardware).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/striped.txt |    4 +--
 drivers/md/dm-stripe.c                  |   39 +++++++++++---------------------
 2 files changed, 16 insertions(+), 27 deletions(-)

Index: linux/Documentation/device-mapper/striped.txt
===================================================================
--- linux.orig/Documentation/device-mapper/striped.txt
+++ linux/Documentation/device-mapper/striped.txt
@@ -9,8 +9,8 @@ devices in parallel.
 
 Parameters: <num devs> <chunk size> [<dev path> <offset>]+
     <num devs>: Number of underlying devices.
-    <chunk size>: Size of each chunk of data. Must be a power-of-2 and at
-                  least as large as the system's PAGE_SIZE.
+    <chunk size>: Size of each chunk of data. Must be at least as
+                  large as the system's PAGE_SIZE.
     <dev path>: Full pathname to the underlying block-device, or a
                 "major:minor" device-number.
     <offset>: Starting sector within the device.
Index: linux/drivers/md/dm-stripe.c
===================================================================
--- linux.orig/drivers/md/dm-stripe.c
+++ linux/drivers/md/dm-stripe.c
@@ -31,9 +31,7 @@ struct stripe_c {
 	/* The size of this target / num. stripes */
 	sector_t stripe_width;
 
-	/* stripe chunk size */
-	uint32_t chunk_shift;
-	sector_t chunk_mask;
+	uint32_t chunk_size;
 
 	/* Needed for handling events */
 	struct dm_target *ti;
@@ -91,7 +89,7 @@ static int get_stripe(struct dm_target *
 
 /*
  * Construct a striped mapping.
- * <number of stripes> <chunk size (2^^n)> [<dev_path> <offset>]+
+ * <number of stripes> <chunk size> [<dev_path> <offset>]+
  */
 static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -115,21 +113,12 @@ static int stripe_ctr(struct dm_target *
 	}
 
 	chunk_size = simple_strtoul(argv[1], &end, 10);
-	if (*end) {
+	if (*end || (chunk_size < (PAGE_SIZE >> SECTOR_SHIFT))) {
 		ti->error = "Invalid chunk_size";
 		return -EINVAL;
 	}
 
-	/*
-	 * chunk_size is a power of two
-	 */
-	if (!is_power_of_2(chunk_size) ||
-	    (chunk_size < (PAGE_SIZE >> SECTOR_SHIFT))) {
-		ti->error = "Invalid chunk size";
-		return -EINVAL;
-	}
-
-	if (ti->len & (chunk_size - 1)) {
+	if (dm_do_mod(ti->len, chunk_size)) {
 		ti->error = "Target length not divisible by "
 		    "chunk size";
 		return -EINVAL;
@@ -178,8 +167,7 @@ static int stripe_ctr(struct dm_target *
 	ti->num_flush_requests = stripes;
 	ti->num_discard_requests = stripes;
 
-	sc->chunk_shift = ffs(chunk_size) - 1;
-	sc->chunk_mask = ((sector_t) chunk_size) - 1;
+	sc->chunk_size = chunk_size;
 
 	/*
 	 * Get the stripe destinations.
@@ -218,8 +206,8 @@ static void stripe_dtr(struct dm_target 
 static void stripe_map_sector(struct stripe_c *sc, sector_t sector,
 			      uint32_t *stripe, sector_t *result)
 {
-	sector_t offset = dm_target_offset(sc->ti, sector);
-	sector_t chunk = offset >> sc->chunk_shift;
+	sector_t chunk = dm_target_offset(sc->ti, sector);
+	sector_t chunk_offset = sector_div(chunk, sc->chunk_size);
 
 	if (sc->stripes_shift < 0)
 		*stripe = sector_div(chunk, sc->stripes);
@@ -228,7 +216,7 @@ static void stripe_map_sector(struct str
 		chunk >>= sc->stripes_shift;
 	}
 
-	*result = (chunk << sc->chunk_shift) | (offset & sc->chunk_mask);
+	*result = (chunk * sc->chunk_size) + chunk_offset;
 }
 
 static void stripe_map_range_sector(struct stripe_c *sc, sector_t sector,
@@ -239,9 +227,10 @@ static void stripe_map_range_sector(stru
 	stripe_map_sector(sc, sector, &stripe, result);
 	if (stripe == target_stripe)
 		return;
-	*result &= ~sc->chunk_mask;			/* round down */
+	/* round down */
+	*result = dm_do_div(*result, sc->chunk_size) * sc->chunk_size;
 	if (target_stripe < stripe)
-		*result += sc->chunk_mask + 1;		/* next chunk */
+		*result += sc->chunk_size;		/* next chunk */
 }
 
 static int stripe_map_discard(struct stripe_c *sc, struct bio *bio,
@@ -326,7 +315,7 @@ static int stripe_status(struct dm_targe
 
 	case STATUSTYPE_TABLE:
 		DMEMIT("%d %llu", sc->stripes,
-			(unsigned long long)sc->chunk_mask + 1);
+			(unsigned long long)sc->chunk_size);
 		for (i = 0; i < sc->stripes; i++)
 			DMEMIT(" %s %llu", sc->stripe[i].dev->name,
 			    (unsigned long long)sc->stripe[i].physical_start);
@@ -393,7 +382,7 @@ static void stripe_io_hints(struct dm_ta
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned chunk_size = (sc->chunk_mask + 1) << 9;
+	unsigned chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
 	blk_limits_io_min(limits, chunk_size);
 	blk_limits_io_opt(limits, chunk_size * sc->stripes);
@@ -421,7 +410,7 @@ static int stripe_merge(struct dm_target
 
 static struct target_type stripe_target = {
 	.name   = "striped",
-	.version = {1, 4, 0},
+	.version = {1, 5, 0},
 	.module = THIS_MODULE,
 	.ctr    = stripe_ctr,
 	.dtr    = stripe_dtr,
