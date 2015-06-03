From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3.10,3.14] dm snapshot: allocate a per-target structure for
 snapshot-origin target
Date: Wed, 3 Jun 2015 11:00:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506031056520.14129@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is backport of 599cdf3bfbe21fe94f4416c9e54363b285c9532a for 3.10 and 
3.14 kernels. The patch doesn't fix any bug but it is needed for other 
backported patches.


commit 599cdf3bfbe21fe94f4416c9e54363b285c9532a
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Fri Mar 14 18:42:12 2014 -0400

    dm snapshot: allocate a per-target structure for snapshot-origin target
    
    Allocate a per-target dm_origin structure.  This is a prerequisite for
    the next commit ("dm snapshot: do not split read bios sent to
    snapshot-origin target") which adds a new member to this structure.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ebddef5..220a06b 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2141,6 +2141,10 @@ static int origin_write_extent(struct dm_snapshot *merging_snap,
  * Origin: maps a linear range of a device, with hooks for snapshotting.
  */
 
+struct dm_origin {
+	struct dm_dev *dev;
+};
+
 /*
  * Construct an origin mapping: <dev_path>
  * The context for an origin is merely a 'struct dm_dev *'
@@ -2149,41 +2153,54 @@ static int origin_write_extent(struct dm_snapshot *merging_snap,
 static int origin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
-	struct dm_dev *dev;
+	struct dm_origin *o;
 
 	if (argc != 1) {
 		ti->error = "origin: incorrect number of arguments";
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &dev);
+	o = kmalloc(sizeof(struct dm_origin), GFP_KERNEL);
+	if (!o) {
+		ti->error = "Cannot allocate private origin structure";
+		r = -ENOMEM;
+		goto bad_alloc;
+	}
+
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &o->dev);
 	if (r) {
 		ti->error = "Cannot get target device";
-		return r;
+		goto bad_open;
 	}
 
-	ti->private = dev;
+	ti->private = o;
 	ti->num_flush_bios = 1;
 
 	return 0;
+
+bad_open:
+	kfree(o);
+bad_alloc:
+	return r;
 }
 
 static void origin_dtr(struct dm_target *ti)
 {
-	struct dm_dev *dev = ti->private;
-	dm_put_device(ti, dev);
+	struct dm_origin *o = ti->private;
+	dm_put_device(ti, o->dev);
+	kfree(o);
 }
 
 static int origin_map(struct dm_target *ti, struct bio *bio)
 {
-	struct dm_dev *dev = ti->private;
-	bio->bi_bdev = dev->bdev;
+	struct dm_origin *o = ti->private;
+	bio->bi_bdev = o->dev->bdev;
 
 	if (bio->bi_rw & REQ_FLUSH)
 		return DM_MAPIO_REMAPPED;
 
 	/* Only tell snapshots if this is a write */
-	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
+	return (bio_rw(bio) == WRITE) ? do_origin(o->dev, bio) : DM_MAPIO_REMAPPED;
 }
 
 /*
@@ -2192,15 +2209,15 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
  */
 static void origin_resume(struct dm_target *ti)
 {
-	struct dm_dev *dev = ti->private;
+	struct dm_origin *o = ti->private;
 
-	ti->max_io_len = get_origin_minimum_chunksize(dev->bdev);
+	ti->max_io_len = get_origin_minimum_chunksize(o->dev->bdev);
 }
 
 static void origin_status(struct dm_target *ti, status_type_t type,
 			  unsigned status_flags, char *result, unsigned maxlen)
 {
-	struct dm_dev *dev = ti->private;
+	struct dm_origin *o = ti->private;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2208,7 +2225,7 @@ static void origin_status(struct dm_target *ti, status_type_t type,
 		break;
 
 	case STATUSTYPE_TABLE:
-		snprintf(result, maxlen, "%s", dev->name);
+		snprintf(result, maxlen, "%s", o->dev->name);
 		break;
 	}
 }
@@ -2216,13 +2233,13 @@ static void origin_status(struct dm_target *ti, status_type_t type,
 static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
 			struct bio_vec *biovec, int max_size)
 {
-	struct dm_dev *dev = ti->private;
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct dm_origin *o = ti->private;
+	struct request_queue *q = bdev_get_queue(o->dev->bdev);
 
 	if (!q->merge_bvec_fn)
 		return max_size;
 
-	bvm->bi_bdev = dev->bdev;
+	bvm->bi_bdev = o->dev->bdev;
 
 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
 }
@@ -2230,9 +2247,9 @@ static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
 static int origin_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
-	struct dm_dev *dev = ti->private;
+	struct dm_origin *o = ti->private;
 
-	return fn(ti, dev, 0, ti->len, data);
+	return fn(ti, o->dev, 0, ti->len, data);
 }
 
 static struct target_type origin_target = {
