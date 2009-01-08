From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 3/4] dm-core: Process barrier request with
	payload in device-mapper
Date: Thu, 08 Jan 2009 17:13:36 +0100
Message-ID: <49662630.0@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Process barrier request with payload in device-mapper.

Because mapping of device can be generic, device-mapper
cannot process barriers containing data directly.

To emulate the same effect of barrier, process bio
like normal request and subsequently inject to all mapped
targets zero-sized barrier (whilst incoming bios are queued).

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d2f7e0b..f3d1ee5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -536,7 +536,7 @@ static int __noflush_suspending(struct mapped_device *md)
 static void dec_pending(struct dm_io *io, int error)
 {
 	unsigned long flags;
-	int barrier = bio_empty_barrier(io->bio);
+	int barrier = bio_barrier(io->bio);
 
 	/* Push-back supersedes any I/O errors */
 	if (error && !(io->error > 0 && __noflush_suspending(io->md)))
@@ -708,6 +708,7 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 	clone->bi_sector = sector;
 	clone->bi_bdev = bio->bi_bdev;
 	clone->bi_rw = bio->bi_rw;
+	clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
 	clone->bi_vcnt = 1;
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
@@ -734,6 +735,7 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 	clone->bi_vcnt = idx + bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
+	clone->bi_rw &= ~(1 << BIO_RW_BARRIER);
 
 	return clone;
 }
@@ -893,11 +895,15 @@ static int __split_bio(struct mapped_device *md, struct bio *bio)
 
 	start_io_acct(ci.io);
 
-	if (unlikely(bio_empty_barrier(ci.bio)))
-		error = __clone_and_map_barrier(&ci);
-	else
-		while (ci.sector_count && !error)
-			error = __clone_and_map(&ci);
+	while (ci.sector_count && !error)
+		error = __clone_and_map(&ci);
+
+	/*
+	 * Barrier with payload is converted to normal bio
+	 * and subsequent zero-size barrier requests.
+	 */
+ 	if (unlikely(bio_barrier(ci.bio)) && !error)
+ 		error = __clone_and_map_barrier(&ci);
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, error);
@@ -1531,12 +1537,6 @@ static void __merge_pushback_list(struct mapped_device *md)
 
 static void __request_barrier(struct mapped_device *md, struct bio *bio)
 {
-	/* Only barriers without payload are supported */
-	if (bio->bi_size) {
-		bio_endio(bio, -EOPNOTSUPP);
-		return;
-	}
-
 	smp_mb();
 	if (!test_bit(DMF_BLOCK_IO, &md->flags))
 		__submit_barrier(md, bio);
