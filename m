From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v7 4/9] pktcdvd: Switch to bio_kmalloc()
Date: Tue, 28 Aug 2012 10:37:31 -0700
Message-ID: <1346175456-1572-5-git-send-email-koverstreet@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1346175456-1572-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com, Peter Osterlund <petero2@telia.com>
List-Id: dm-devel.ids

This is prep work for killing bi_destructor - previously, pktcdvd had
its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
necessitating its own bi_destructor implementation.

v5: Un-reorder some functions, to make the patch easier to review

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Peter Osterlund <petero2@telia.com>
---
 drivers/block/pktcdvd.c | 52 +++++++------------------------------------------
 1 file changed, 7 insertions(+), 45 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ba66e44..2e7de7a 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -522,38 +522,6 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
 	}
 }
 
-static void pkt_bio_destructor(struct bio *bio)
-{
-	kfree(bio->bi_io_vec);
-	kfree(bio);
-}
-
-static struct bio *pkt_bio_alloc(int nr_iovecs)
-{
-	struct bio_vec *bvl = NULL;
-	struct bio *bio;
-
-	bio = kmalloc(sizeof(struct bio), GFP_KERNEL);
-	if (!bio)
-		goto no_bio;
-	bio_init(bio);
-
-	bvl = kcalloc(nr_iovecs, sizeof(struct bio_vec), GFP_KERNEL);
-	if (!bvl)
-		goto no_bvl;
-
-	bio->bi_max_vecs = nr_iovecs;
-	bio->bi_io_vec = bvl;
-	bio->bi_destructor = pkt_bio_destructor;
-
-	return bio;
-
- no_bvl:
-	kfree(bio);
- no_bio:
-	return NULL;
-}
-
 /*
  * Allocate a packet_data struct
  */
@@ -567,7 +535,7 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 		goto no_pkt;
 
 	pkt->frames = frames;
-	pkt->w_bio = pkt_bio_alloc(frames);
+	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);
 	if (!pkt->w_bio)
 		goto no_bio;
 
@@ -581,9 +549,10 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	bio_list_init(&pkt->orig_bios);
 
 	for (i = 0; i < frames; i++) {
-		struct bio *bio = pkt_bio_alloc(1);
+		struct bio *bio = bio_kmalloc(GFP_KERNEL, 1);
 		if (!bio)
 			goto no_rd_bio;
+
 		pkt->r_bios[i] = bio;
 	}
 
@@ -1111,21 +1080,17 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	 * Schedule reads for missing parts of the packet.
 	 */
 	for (f = 0; f < pkt->frames; f++) {
-		struct bio_vec *vec;
-
 		int p, offset;
+
 		if (written[f])
 			continue;
+
 		bio = pkt->r_bios[f];
-		vec = bio->bi_io_vec;
-		bio_init(bio);
-		bio->bi_max_vecs = 1;
+		bio_reset(bio);
 		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
 		bio->bi_bdev = pd->bdev;
 		bio->bi_end_io = pkt_end_io_read;
 		bio->bi_private = pkt;
-		bio->bi_io_vec = vec;
-		bio->bi_destructor = pkt_bio_destructor;
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
@@ -1418,14 +1383,11 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	}
 
 	/* Start the write request */
-	bio_init(pkt->w_bio);
-	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
+	bio_reset(pkt->w_bio);
 	pkt->w_bio->bi_sector = pkt->sector;
 	pkt->w_bio->bi_bdev = pd->bdev;
 	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
 	pkt->w_bio->bi_private = pkt;
-	pkt->w_bio->bi_io_vec = bvec;
-	pkt->w_bio->bi_destructor = pkt_bio_destructor;
 	for (f = 0; f < pkt->frames; f++)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
-- 
1.7.12
