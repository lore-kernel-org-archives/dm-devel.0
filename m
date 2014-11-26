From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] dm-bufio: fix memleak when using a dm_buffer's inline bio
Date: Tue, 25 Nov 2014 17:45:15 -0800
Message-ID: <20141126014515.GE10050@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

When dm-bufio sets out to use the bio built into a struct dm_buffer to
issue an IO, it needs to call bio_reset after it's done with the bio
so that we can free things attached to the bio such as the integrity
payload.  Therefore, inject our own endio callback to take care of
the bio_reset after calling submit_io's end_io callback.

Test case:
1. modprobe scsi_debug delay=0 dif=1 dix=199 ato=1 dev_size_mb=300
2. Set up a dm-bufio client, e.g. dm-verity, on the scsi_debug device
3. Repeatedly read metadata and watch kmalloc-192 leak!

Fix is against 3.18-rc6.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/dm-bufio.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index afe7971..2967ecc 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -532,6 +532,16 @@ static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
 		end_io(&b->bio, r);
 }
 
+/* Reset the bio to free attached bio integrity profiles when we're done */
+static void inline_endio(struct bio *bio, int error)
+{
+	bio_end_io_t *end_fn;
+
+	end_fn = bio->bi_private;
+	end_fn(bio, error);
+	bio_reset(bio);
+}
+
 static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 			   bio_end_io_t *end_io)
 {
@@ -543,7 +553,8 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
 	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
 	b->bio.bi_bdev = b->c->bdev;
-	b->bio.bi_end_io = end_io;
+	b->bio.bi_end_io = inline_endio;
+	b->bio.bi_private = end_io;
 
 	/*
 	 * We assume that if len >= PAGE_SIZE ptr is page-aligned.
