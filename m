From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/7] dm: return value definition of target
	map/end_io
Date: Tue, 10 Oct 2006 17:30:25 -0400 (EDT)
Message-ID: <20061010.173025.08316466.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch explicitly defines the use of return values from
target map/end_io functions.
Values more than 1 are reserved for future use.

I have confirmed existing upstream target drivers don't use
the reserved values.
Should have no effect on the behavior.
Corresponding changes in target drivers will follow.

Details are below.

o Reserve return values more than 1 from target map function.
  Current target drivers can use more than 0 to tell map complete
  to the dm core, but all target drivers are using 1 for that now.
  So reserve more than 1 explicitly so that target drivers can tell
  other things to the dm core in the future.  New definition is below.
      < 0 : error
      = 0 : The target will handle the io (symbol: DM_MAPIO_SUBMITTED)
      = 1 : map complete (symbol: DM_MAPIO_REMAPPED)
      > 1 : reserved (undefined)

o Reserve return values more than 1 from target end_io function.
  More than 1 is not defined and actually target drivers can use
  more than 1 instead of 1.  So reserve it explicitly.


Test results:
I have tested by using multipath target.
I/Os succeed when valid paths are existing.
I/Os are queued in the multipath target when no valid paths and
queue_if_no_path is set.
I/Os fail when no valid paths and no queue_if_no_path setting.


The patch is for:
    2.6.18-mm2 + patch 1-2

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 2-susp-iface-change/drivers/md/dm.c 3-core-rval-iface-change/drivers/md/dm.c
--- 2-susp-iface-change/drivers/md/dm.c	2006-10-05 10:26:33.000000000 -0400
+++ 3-core-rval-iface-change/drivers/md/dm.c	2006-10-05 13:48:34.000000000 -0400
@@ -482,9 +482,13 @@ static int clone_endio(struct bio *bio, 
 		r = endio(tio->ti, bio, error, &tio->info);
 		if (r < 0)
 			error = r;
-		else if (r > 0)
-			/* the target wants another shot at the io */
+		else if (r == DM_ENDIO_INCOMPLETE)
+			/* The target will handle the io */
 			return 1;
+		else if (r) {
+			DMWARN("unimplemented target endio return value: %d", r);
+			BUG();
+		}
 	}
 
 	dec_pending(tio->io, error);
@@ -542,7 +546,7 @@ static void __map_bio(struct dm_target *
 	atomic_inc(&tio->io->io_count);
 	sector = clone->bi_sector;
 	r = ti->type->map(ti, clone, &tio->info);
-	if (r > 0) {
+	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
 
 		blk_add_trace_remap(bdev_get_queue(clone->bi_bdev), clone,
@@ -560,6 +564,9 @@ static void __map_bio(struct dm_target *
 		clone->bi_private = md->bs;
 		bio_put(clone);
 		free_tio(md, tio);
+	} else if (r) {
+		DMWARN("unimplemented target map return value: %d", r);
+		BUG();
 	}
 }
 
diff -rupN 2-susp-iface-change/drivers/md/dm.h 3-core-rval-iface-change/drivers/md/dm.h
--- 2-susp-iface-change/drivers/md/dm.h	2006-10-05 10:26:33.000000000 -0400
+++ 3-core-rval-iface-change/drivers/md/dm.h	2006-10-05 10:45:08.000000000 -0400
@@ -33,6 +33,17 @@
 #define SECTOR_SHIFT 9
 
 /*
+ * Definitions of return values from target end_io function.
+ */
+#define DM_ENDIO_INCOMPLETE	1
+
+/*
+ * Definitions of return values from target map function.
+ */
+#define DM_MAPIO_SUBMITTED	0
+#define DM_MAPIO_REMAPPED	1
+
+/*
  * Suspend feature flags
  */
 #define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
diff -rupN 2-susp-iface-change/include/linux/device-mapper.h 3-core-rval-iface-change/include/linux/device-mapper.h
--- 2-susp-iface-change/include/linux/device-mapper.h	2006-10-05 10:26:33.000000000 -0400
+++ 3-core-rval-iface-change/include/linux/device-mapper.h	2006-10-05 10:41:27.000000000 -0400
@@ -39,7 +39,7 @@ typedef void (*dm_dtr_fn) (struct dm_tar
  * The map function must return:
  * < 0: error
  * = 0: The target will handle the io by resubmitting it later
- * > 0: simple remap complete
+ * = 1: simple remap complete
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
