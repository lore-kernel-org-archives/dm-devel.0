From: heinzm@redhat.com
Subject: [PATCH] dm ebs: use new dm-bufo dm_bufio_issue_discard()
	API
Date: Wed, 29 Apr 2020 16:47:03 +0200
Message-ID: <976f321e48432fbb7ae4e3776a9eef1f1906fb79.1588171508.git.heinzm@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Enhance new dm-ebs target as of v4 submitted on 3/9/2020
to actually pass discarding blocks down to the underlying
device now that the new dm-bufio API is available.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 .../admin-guide/device-mapper/dm-ebs.rst      |  6 +++
 drivers/md/dm-ebs-target.c                    | 37 ++++++++++++++++---
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-ebs.rst b/Documentation/admin-guide/device-mapper/dm-ebs.rst
index 9e7abd3e0ae1..d42627e06924 100644
--- a/Documentation/admin-guide/device-mapper/dm-ebs.rst
+++ b/Documentation/admin-guide/device-mapper/dm-ebs.rst
@@ -49,3 +49,9 @@ offset 128 sectors, enforce 2KiB underlying device block size.
 This presumes 2KiB logical blocksize on /dev/sda or less to work:
 
 ebs /dev/sda 128 2 4
+
+Version History
+---------------
+
+V1.0.0 - initial version
+V1.0.1 - pass down discard requests
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 1ba45946d4a6..97703c31771f 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -128,7 +128,33 @@ static int __ebs_rw_bio(struct ebs_c *ec, int rw, struct bio *bio)
 	return r;
 }
 
-/* 'Discard' blocks, i.e. release them from the bufio cache. */
+/*
+ * Discard bio's blocks, i.e. pass discards down.
+ *
+ * Avoid discarding partial blocks at beginning and end;
+ * return 0 in case no blocks can be discarded as a result.
+ */
+static int __ebs_discard_bio(struct ebs_c *ec, struct bio *bio)
+{
+	sector_t block, blocks, sector = bio->bi_iter.bi_sector;;
+
+	block = __sector_to_block(ec, sector);
+	blocks = __nr_blocks(ec, bio);
+
+	/* Partial first underlying block (__nr_blocks() may have resulted in one block). */
+	if (__block_mod(sector, ec->u_bs)) {
+		block++;
+		blocks--;
+	}
+
+	/* Partial last underlying block if any. */
+	if (blocks && __block_mod(bio_end_sector(bio), ec->u_bs))
+		blocks--;
+
+	return blocks ? dm_bufio_issue_discard(ec->bufio, block, blocks) : 0;
+}
+
+/* Release blocks them from the bufio cache. */
 static int __ebs_forget_bio(struct ebs_c *ec, struct bio *bio)
 {
 	sector_t blocks, sector = bio->bi_iter.bi_sector;;
@@ -179,9 +205,10 @@ static void __ebs_process_bios(struct work_struct *ws)
 		else if (bio_op(bio) == REQ_OP_WRITE) {
 			write = true;
 			r = __ebs_rw_bio(ec, WRITE, bio);
-		} else if (bio_op(bio) == REQ_OP_DISCARD)
-			/* FIXME: (optionally) call dm_bufio_discard_buffers() once upstream. */
-			r = __ebs_forget_bio(ec, bio);
+		} else if (bio_op(bio) == REQ_OP_DISCARD) {
+			__ebs_forget_bio(ec, bio);
+			r = __ebs_discard_bio(ec, bio);
+		}
 
 		bio->bi_status = r;
 	}
@@ -404,7 +431,7 @@ static int ebs_iterate_devices(struct dm_target *ti,
 
 static struct target_type ebs_target = {
 	.name		 = "ebs",
-	.version	 = {1, 0, 0},
+	.version	 = {1, 0, 1},
 	.features	 = DM_TARGET_PASSES_INTEGRITY,
 	.module		 = THIS_MODULE,
 	.ctr		 = ebs_ctr,
-- 
2.25.4
