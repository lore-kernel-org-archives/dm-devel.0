From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 12/12] dm stripe: enable efficient discard
	support
Date: Tue, 27 Jul 2010 16:32:55 -0400
Message-ID: <20100727203255.GA27792@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
	<1279987768-13275-13-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1279987768-13275-13-git-send-email-snitzer@redhat.com>
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

The DM core will submit a discard bio to the stripe target for each
stripe in a striped DM device.  The stripe target will determine
stripe-specific portions of the supplied bio to be remapped into
individual (at most 'num_discard_requests' extents).  If a given
stripe-specific discard bio doesn't touch a particular stripe the bio
will be dropped.

Various useful DMDEBUG messages will be printed if CONFIG_DM_DEBUG is
enabled and a discard is issued to a striped DM device.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-stripe.c |  171 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 165 insertions(+), 6 deletions(-)

v3: pass stripe to map_bio_to_stripe: eliminates 1 unnecessary
    sector_div from discard path

Index: linux-2.6-block/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-stripe.c
+++ linux-2.6-block/drivers/md/dm-stripe.c
@@ -167,11 +167,10 @@ static int stripe_ctr(struct dm_target *
 	sc->stripe_width = width;
 	ti->split_io = chunk_size;
 	ti->num_flush_requests = stripes;
+	ti->num_discard_requests = stripes;
 
 	sc->chunk_mask = ((sector_t) chunk_size) - 1;
-	for (sc->chunk_shift = 0; chunk_size; sc->chunk_shift++)
-		chunk_size >>= 1;
-	sc->chunk_shift--;
+	sc->chunk_shift = ffs(chunk_size) - 1;
 
 	/*
 	 * Get the stripe destinations.
@@ -207,6 +206,161 @@ static void stripe_dtr(struct dm_target 
 	kfree(sc);
 }
 
+static void map_bio_to_stripe(struct bio *bio, uint32_t stripe,
+			      struct stripe_c *sc, sector_t chunk,
+			      sector_t offset)
+{
+	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
+	bio->bi_sector = sc->stripe[stripe].physical_start +
+	    (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
+}
+
+/*
+ * Set the bio's bi_size based on only the space allocated to 'stripe'.
+ * - first_chunk and last_chunk belong to 'stripe'.
+ * - first_offset and last_offset are only relevant if non-zero.
+ */
+static void set_stripe_bio_size(struct bio *bio, uint32_t stripe,
+				struct stripe_c *sc,
+				sector_t first_chunk, sector_t last_chunk,
+				sector_t first_offset, sector_t last_offset)
+{
+	sector_t temp, stripe_chunks, unused_sectors = 0;
+
+	/*
+	 * Determine the number of chunks used from the specified 'stripe'.
+	 * stripe_chunks * chunk_size is the upper bound on the 'stripe'
+	 * specific bio->bi_size
+	 * - requires absolute first_chunk and last_chunk
+	 */
+	stripe_chunks = last_chunk - first_chunk + 1;
+	temp = sector_div(stripe_chunks, sc->stripes);
+	stripe_chunks += temp;
+	DMDEBUG("%s: stripe=%u stripe_chunks=%lu",
+		__func__, stripe, stripe_chunks);
+
+	/* Set bi_size based on only the space allocated to 'stripe' */
+	bio->bi_size = to_bytes(stripe_chunks * (sc->chunk_mask + 1));
+	/* must reduce bi_size if first and/or last chunk was partially used */
+	if (first_offset) {
+		unused_sectors += (first_offset & sc->chunk_mask);
+		DMDEBUG("%s: adjusting for first_stripe=%u, unused_sectors=%lu",
+			__func__, stripe, unused_sectors);
+	}
+	if (last_offset) {
+		temp = last_offset & sc->chunk_mask;
+		if (temp)
+			unused_sectors += ((sc->chunk_mask + 1) - temp);
+		DMDEBUG("%s: adjusting for last_stripe=%u, unused_sectors=%lu",
+			__func__, stripe, unused_sectors);
+	}
+	if (unused_sectors)
+		bio->bi_size -= to_bytes(unused_sectors);
+}
+
+/*
+ * Determine the chunk closest to 'chunk' that belongs to 'stripe':
+ * - return first chunk belonging to stripe if 'first_offset' was provided.
+ *   - also adjust 'first_offset' accordingly.
+ *   - returned chunk may exceed bio or target boundary; caller must check
+ *     the return and react accordingly (e.g. drop the bio).
+ * - otherwise return last chunk belonging to stripe
+ * Also return the 'chunk_stripe' associated with the original 'chunk'.
+ */
+static sector_t get_stripe_chunk(struct stripe_c *sc, uint32_t stripe,
+				 sector_t chunk, sector_t *first_offset,
+				 uint32_t *chunk_stripe)
+{
+	sector_t ret_chunk = chunk;
+	uint32_t stripe_chunk_offset;
+
+	*chunk_stripe = sector_div(chunk, sc->stripes);
+	/* Get absolute offset (in chunks) from 'chunk' to desired 'stripe' */
+	stripe_chunk_offset = abs((long)stripe - *chunk_stripe);
+
+	if (first_offset) {
+		/* first chunk */
+		if (stripe < *chunk_stripe)
+			stripe_chunk_offset = sc->stripes - stripe_chunk_offset;
+		if (stripe_chunk_offset) {
+			ret_chunk += stripe_chunk_offset;
+			*first_offset = ret_chunk << sc->chunk_shift;
+			DMDEBUG("%s: stripe=%u shifted first_offset=%lu",
+				__func__, stripe, *first_offset);
+		}
+	} else {
+		/* last chunk */
+		if (*chunk_stripe < stripe)
+			stripe_chunk_offset = sc->stripes - stripe_chunk_offset;
+		ret_chunk -= stripe_chunk_offset;
+	}
+
+	DMDEBUG("%s: stripe=%u stripe_chunk_offset=%u shifted %s_chunk=%lu",
+		__func__, stripe, stripe_chunk_offset,
+		(first_offset ? "first" : "last"), ret_chunk);
+
+	return ret_chunk;
+}
+
+/*
+ * Confine mapping a bio to an extent of the specified stripe.
+ * If bio doesn't touch stripe drop the bio and return immediately.
+ */
+static int map_stripe_extent(uint32_t stripe, struct bio *bio,
+			     struct dm_target *ti, struct stripe_c *sc)
+{
+	sector_t first_offset, last_offset, first_chunk, last_chunk;
+	uint32_t first_stripe, last_stripe;
+
+	DMDEBUG("%s: discard stripe=%u bi_sector=%lu bi_size=%u, bio_sectors=%u",
+		__func__, stripe, bio->bi_sector, bio->bi_size, bio_sectors(bio));
+
+	first_offset = bio->bi_sector - ti->begin;
+	first_chunk = first_offset >> sc->chunk_shift;
+	last_offset = first_offset + to_sector(bio->bi_size);
+	/* Get the last chunk associated with this bio (-1 required) */
+	last_chunk = (last_offset - 1) >> sc->chunk_shift;
+
+	DMDEBUG("%s: first_offset=%lu last_offset=%lu, "
+		"first_chunk=%lu last_chunk=%lu", __func__,
+		first_offset, last_offset, first_chunk, last_chunk);
+
+	/* Determine first_chunk (and first_offset) belonging to 'stripe' */
+	first_chunk = get_stripe_chunk(sc, stripe, first_chunk,
+				       &first_offset, &first_stripe);
+
+	if (first_chunk > last_chunk) {
+		/* Drop bio because it doesn't touch desired 'stripe' */
+		bio_endio(bio, 0);
+		DMDEBUG("%s: dropping bio because it doesn't touch stripe=%u\n",
+			__func__, stripe);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	/* Determine last_chunk belonging to 'stripe' */
+	last_chunk = get_stripe_chunk(sc, stripe, last_chunk,
+				      NULL, &last_stripe);
+	BUG_ON(last_chunk < first_chunk);
+
+	DMDEBUG("%s: BEFORE bi_sector=%lu, bi_size=%u, bio_sectors=%u",
+		__func__, bio->bi_sector, bio->bi_size, bio_sectors(bio));
+
+	map_bio_to_stripe(bio, stripe, sc, first_chunk, first_offset);
+
+	/* Only account for offsets that impact the 'stripe' bio->bi_size */
+	if (stripe != first_stripe)
+		first_offset = 0;
+	if (stripe != last_stripe)
+		last_offset = 0;
+	set_stripe_bio_size(bio, stripe, sc, first_chunk, last_chunk,
+			    first_offset, last_offset);
+
+	DMDEBUG("%s: AFTER bi_sector=%lu, bi_size=%u, bio_sectors=%u\n",
+		__func__, bio->bi_sector, bio->bi_size, bio_sectors(bio));
+
+	return DM_MAPIO_REMAPPED;
+}
+
 static int stripe_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
@@ -222,13 +376,18 @@ static int stripe_map(struct dm_target *
 		return DM_MAPIO_REMAPPED;
 	}
 
+	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+		target_request_nr = map_context->target_request_nr;
+		BUG_ON(target_request_nr >= sc->stripes);
+		return map_stripe_extent(target_request_nr, bio, ti, sc);
+	}
+
 	offset = bio->bi_sector - ti->begin;
 	chunk = offset >> sc->chunk_shift;
 	stripe = sector_div(chunk, sc->stripes);
 
-	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
-	bio->bi_sector = sc->stripe[stripe].physical_start +
-	    (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
+	map_bio_to_stripe(bio, stripe, sc, chunk, offset);
+
 	return DM_MAPIO_REMAPPED;
 }
 
