From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 6/9] dm: add per-bio-data support to noclone
	bio
Date: Wed, 20 Feb 2019 16:44:33 -0500
Message-ID: <20190220214436.38476-7-snitzer@redhat.com>
References: <20190220214436.38476-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190220214436.38476-1-snitzer@redhat.com>
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

From: Mikulas Patocka <mpatocka@redhat.com>

Allocate additional space after the 'struct dm_clone' for the target
requested per_io_data_size and place DM_NOCLONE_MAGIC at the end.

Update both dm_per_bio_data() and dm_bio_from_per_bio_data() to branch
accordingly based on whether bio/data is from clone or noclone.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d84735be6927..7e022f840419 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -26,6 +26,8 @@
 #include <linux/pr.h>
 #include <linux/refcount.h>
 
+#include <asm/unaligned.h>
+
 #define DM_MSG_PREFIX "core"
 
 /*
@@ -105,16 +107,29 @@ struct dm_io {
 /*
  * One of these is allocated per noclone bio.
  */
+#define DM_NOCLONE_MAGIC 9693664
 struct dm_noclone {
 	struct mapped_device *md;
+	struct bio *bio;
 	bio_end_io_t *orig_bi_end_io;
 	void *orig_bi_private;
 	unsigned long start_time;
+	/* ... per-bio-data ... */
+	/* DM_NOCLONE_MAGIC */
 };
 
+static void noclone_endio(struct bio *bio);
+
 void *dm_per_bio_data(struct bio *bio, size_t data_size)
 {
-	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	struct dm_target_io *tio;
+
+	if (bio->bi_end_io == noclone_endio) {
+		struct dm_noclone *noclone = bio->bi_private;
+		return noclone + 1;
+	}
+
+	tio = container_of(bio, struct dm_target_io, clone);
 	if (!tio->inside_dm_io)
 		return (char *)bio - offsetof(struct dm_target_io, clone) - data_size;
 	return (char *)bio - offsetof(struct dm_target_io, clone) - offsetof(struct dm_io, tio) - data_size;
@@ -124,9 +139,14 @@ EXPORT_SYMBOL_GPL(dm_per_bio_data);
 struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size)
 {
 	struct dm_io *io = (struct dm_io *)((char *)data + data_size);
-	if (io->magic == DM_IO_MAGIC)
+	unsigned magic = get_unaligned(&io->magic);
+	if (magic == DM_NOCLONE_MAGIC) {
+		struct dm_noclone *noclone = (struct dm_noclone *)data - 1;
+		return noclone->bio;
+	}
+	if (magic == DM_IO_MAGIC)
 		return (struct bio *)((char *)io + offsetof(struct dm_io, tio) + offsetof(struct dm_target_io, clone));
-	BUG_ON(io->magic != DM_TIO_MAGIC);
+	BUG_ON(magic != DM_TIO_MAGIC);
 	return (struct bio *)((char *)io + offsetof(struct dm_target_io, clone));
 }
 EXPORT_SYMBOL_GPL(dm_bio_from_per_bio_data);
@@ -1793,14 +1813,18 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 
 		/* Already been here if bio->bi_end_io is noclone_endio, reentered via dm_wq_work() */
 		if (bio->bi_end_io != noclone_endio) {
-			noclone = kmalloc_node(sizeof(*noclone), GFP_NOWAIT, md->numa_node_id);
+			noclone = kmalloc_node(sizeof(*noclone) + ti->per_io_data_size + sizeof(unsigned),
+					       GFP_NOWAIT, md->numa_node_id);
 			if (unlikely(!noclone))
 				goto no_fast_path;
 
 			noclone->md = md;
 			noclone->start_time = jiffies;
+			noclone->bio = bio;
 			noclone->orig_bi_end_io = bio->bi_end_io;
 			noclone->orig_bi_private = bio->bi_private;
+			put_unaligned(DM_NOCLONE_MAGIC,
+				      (unsigned *)((char *)noclone + sizeof(*noclone) + ti->per_io_data_size));
 			bio->bi_end_io = noclone_endio;
 			bio->bi_private = noclone;
 		} else
-- 
2.15.0
