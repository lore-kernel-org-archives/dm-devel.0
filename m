From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2]: save/restore bio vector (version 2)
Date: Sun, 15 Feb 2009 21:23:39 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902152118330.18362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0902042146170.8695@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902042146170.8695@hs20-bc2-1.build.redhat.com>
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
Cc: Pete Zaitcev <zaitcev@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I've made an update on this patch that consumes 4 times less memory.

This is accomplished by not saving the page (as suggested by Pete Zaitcev 
<zaitcev@redhat.com>) and using 16-bit entries if the page size is less 
than 16 bits.

Mikulas

On Wed, 4 Feb 2009, Mikulas Patocka wrote:

> Hi
> 
> This patch should fix bug 472796 in upstream kernel.
> 
> ---

Bio layer modifies the vector list when the request partially succeeds.

Device mapper saves and restores various fields in the bio, but it doesn't save
the vector. So, when the block driver modifies the vector on partially succeeded
request, dm-raid1 and dm-multipath will attempt to resubmit a bio that has
mismatching bi_size and the size of vector. That will cause BUG() in the block
layer.

To make requests resubmittable in dm-raid1 and dm-multipath, we must save
and restore the bio vector as well.

To consume per-request memory, do not save the pages in a vector.
Also, use only 16-bit field size if the page size is less than 65536.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bio-record.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

Index: linux-2.6.29-rc3-devel/drivers/md/dm-bio-record.h
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm-bio-record.h	2009-02-05 03:55:56.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm-bio-record.h	2009-02-16 03:13:07.000000000 +0100
@@ -16,30 +16,52 @@
  * functions in this file help the target record and restore the
  * original bio state.
  */
+
+struct dm_bio_vec_details {
+#if PAGE_SIZE < 65536
+	__u16 bv_len;
+	__u16 bv_offset;
+#else
+	unsigned int bv_len;
+	unsigned int bv_offset;
+#endif
+};
+
 struct dm_bio_details {
 	sector_t bi_sector;
 	struct block_device *bi_bdev;
 	unsigned int bi_size;
 	unsigned short bi_idx;
 	unsigned long bi_flags;
+	struct dm_bio_vec_details bi_io_vec[BIO_MAX_PAGES];
 };
 
 static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
+	unsigned i;
 	bd->bi_sector = bio->bi_sector;
 	bd->bi_bdev = bio->bi_bdev;
 	bd->bi_size = bio->bi_size;
 	bd->bi_idx = bio->bi_idx;
 	bd->bi_flags = bio->bi_flags;
+	for (i = 0; i < bio->bi_vcnt; i++) {
+		bd->bi_io_vec[i].bv_len = bio->bi_io_vec[i].bv_len;
+		bd->bi_io_vec[i].bv_offset = bio->bi_io_vec[i].bv_offset;
+	}
 }
 
 static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
+	unsigned i;
 	bio->bi_sector = bd->bi_sector;
 	bio->bi_bdev = bd->bi_bdev;
 	bio->bi_size = bd->bi_size;
 	bio->bi_idx = bd->bi_idx;
 	bio->bi_flags = bd->bi_flags;
+	for (i = 0; i < bio->bi_vcnt; i++) {
+		bio->bi_io_vec[i].bv_len = bd->bi_io_vec[i].bv_len;
+		bio->bi_io_vec[i].bv_offset = bd->bi_io_vec[i].bv_offset;
+	}
 }
 
 #endif
