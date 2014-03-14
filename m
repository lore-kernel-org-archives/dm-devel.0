From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/6] dm origin: split only write bios
Date: Fri, 14 Mar 2014 18:43:07 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403141842170.31047@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141841290.31047@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1403141841290.31047@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Change the dm origin target so that only write bios are split on chunk
boundary. Read bios are passed unchanged to the underlying device, so they
don't have to be split.

Later, we could change the target so that it accepts a larger write bio if
it spans an area that is completely covered by the snapshots.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

Index: linux-3.14-rc6/drivers/md/dm-snap.c
===================================================================
--- linux-3.14-rc6.orig/drivers/md/dm-snap.c	2014-03-14 04:37:54.000000000 +0100
+++ linux-3.14-rc6/drivers/md/dm-snap.c	2014-03-14 05:23:42.000000000 +0100
@@ -2143,6 +2143,7 @@ static int origin_write_extent(struct dm
 
 struct dm_origin {
 	struct dm_dev *dev;
+	unsigned split_boundary;
 };
 
 /*
@@ -2194,13 +2195,24 @@ static void origin_dtr(struct dm_target 
 static int origin_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dm_origin *o = ti->private;
+	unsigned available_sectors;
+
 	bio->bi_bdev = o->dev->bdev;
 
-	if (bio->bi_rw & REQ_FLUSH)
+	if (unlikely(bio->bi_rw & REQ_FLUSH))
+		return DM_MAPIO_REMAPPED;
+
+	if (bio_rw(bio) != WRITE)
 		return DM_MAPIO_REMAPPED;
 
+	available_sectors = o->split_boundary -
+		((unsigned)bio->bi_iter.bi_sector & (o->split_boundary - 1));
+
+	if (bio_sectors(bio) > available_sectors)
+		dm_accept_partial_bio(bio, available_sectors);
+
 	/* Only tell snapshots if this is a write */
-	return (bio_rw(bio) == WRITE) ? do_origin(o->dev, bio) : DM_MAPIO_REMAPPED;
+	return do_origin(o->dev, bio);
 }
 
 /*
@@ -2211,7 +2223,7 @@ static void origin_resume(struct dm_targ
 {
 	struct dm_origin *o = ti->private;
 
-	ti->max_io_len = get_origin_minimum_chunksize(o->dev->bdev);
+	o->split_boundary = get_origin_minimum_chunksize(o->dev->bdev);
 }
 
 static void origin_status(struct dm_target *ti, status_type_t type,
