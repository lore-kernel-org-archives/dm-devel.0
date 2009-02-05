From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2]: save/restore bio vector
Date: Wed, 4 Feb 2009 21:47:59 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902042146170.8695@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This patch should fix bug 472796 in upstream kernel.

---

Bio layer modifies the vector list when the request partially succeeds.

Device mapper saves and restores various fields in the bio, but it doesn't save
the vector. So, when the block driver modifies the vector on partially succeeded
request, dm-raid1 and dm-multipath will attempt to resubmit a bio that has
mismatching bi_size and the size of vector. That will cause BUG() in the block
layer.

To make requests resubmittable in dm-raid1 and dm-multipath, we must save
and restore the bio vector as well.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bio-record.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.29-rc3-devel/drivers/md/dm-bio-record.h
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm-bio-record.h	2009-02-05 03:10:49.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm-bio-record.h	2009-02-05 03:12:52.000000000 +0100
@@ -22,6 +22,7 @@ struct dm_bio_details {
 	unsigned int bi_size;
 	unsigned short bi_idx;
 	unsigned long bi_flags;
+	struct bio_vec bi_io_vec[BIO_MAX_PAGES];
 };
 
 static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
@@ -31,6 +32,7 @@ static inline void dm_bio_record(struct 
 	bd->bi_size = bio->bi_size;
 	bd->bi_idx = bio->bi_idx;
 	bd->bi_flags = bio->bi_flags;
+	memcpy(bd->bi_io_vec, bio->bi_io_vec, bio->bi_vcnt * sizeof(struct bio_vec));
 }
 
 static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
@@ -40,6 +42,7 @@ static inline void dm_bio_restore(struct
 	bio->bi_size = bd->bi_size;
 	bio->bi_idx = bd->bi_idx;
 	bio->bi_flags = bd->bi_flags;
+	memcpy(bio->bi_io_vec, bd->bi_io_vec, bio->bi_vcnt * sizeof(struct bio_vec));
 }
 
 #endif
