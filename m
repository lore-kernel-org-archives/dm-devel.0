From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] DM Block integrity support
Date: Wed, 7 Jan 2009 19:31:23 +0000
Message-ID: <20090107193123.GQ3512@agk.fab.redhat.com>
References: <yq1aba75wkr.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1aba75wkr.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

New additions merged back into the original cleaned-up patch and
unresolved header comments updated.

Alasdair.

From: Martin K. Petersen <martin.petersen@oracle.com>

This patch provides support for data integrity passthrough in the device
mapper.

 - If one or more component devices support integrity an integrity
   profile is preallocated for the DM device.

[FIXME: Looks as if that will hit BUG_ON(template == NULL) - maybe there's
an undocumented dependency on some other patch?  Does this handle table swaps
correctly? i.e. NULL must leave any existing (live) setting unchanged.]

 - If all component devices have compatible profiles the DM device is
   flagged as capable.

 - Handle integrity metadata when splitting and cloning bios.

[FIXME: Does this cope with integrity profile needing removing after
a table swap?]

[FIXME: blk_integrity_register() allocating & manipulating kobjects
needs moving outside __bind().  - Does the preallocation address this
now, with the exception of some unimportant races we'll ignore but
should document?  E.g. If integrity profile appears on an
underlying device between the reload and the table swap.  Would it be
better for the table swap to fail in that particular case?]

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
 drivers/md/dm-ioctl.c |   21 +++++++++++++++++++++
 drivers/md/dm-table.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |   15 +++++++++++++++
 3 files changed, 75 insertions(+)

Index: linux-2.6.28/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-ioctl.c	2009-01-06 21:36:12.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-ioctl.c	2009-01-07 18:34:15.000000000 +0000
@@ -1047,6 +1047,19 @@ static int populate_table(struct dm_tabl
 	return dm_table_complete(table);
 }
 
+static int table_prealloc_integrity(struct dm_table *t,
+				    struct mapped_device *md)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *dd;
+
+	list_for_each_entry(dd, devices, list)
+		if (bdev_get_integrity(dd->dm_dev.bdev))
+			return blk_integrity_register(dm_disk(md), NULL);
+
+	return 0;
+}
+
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
@@ -1068,6 +1081,14 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	r = table_prealloc_integrity(t, md);
+	if (r) {
+		DMERR("%s: could not register integrity profile.",
+		      dm_device_name(md));
+		dm_table_destroy(t);
+		goto out;
+	}
+
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
Index: linux-2.6.28/drivers/md/dm-table.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-table.c	2009-01-07 15:38:20.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-table.c	2009-01-07 18:56:59.000000000 +0000
@@ -877,6 +877,44 @@ struct dm_target *dm_table_find_target(s
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+/*
+ * Set the integrity profile for this device if all devices used have
+ * matching profiles.
+ */
+static void dm_table_set_integrity(struct dm_table *t)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *prev = NULL, *dd = NULL;
+	struct blk_integrity *bi;
+
+	list_for_each_entry(dd, devices, list) {
+		if (prev &&
+		    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
+					  dd->dm_dev.bdev->bd_disk) < 0) {
+			DMWARN("%s: integrity not set: %s and %s mismatch",
+			       dm_device_name(t->md),
+			       prev->dm_dev.bdev->bd_disk->disk_name,
+			       dd->dm_dev.bdev->bd_disk->disk_name);
+			return;
+		}
+		prev = dd;
+	}
+
+	if (!prev)
+		return;
+
+	bi = bdev_get_integrity(prev->dm_dev.bdev);
+	if (!bi)
+		return;
+
+	/* Register dm device as being integrity capable */
+	if (blk_integrity_register(dm_disk(t->md), bi))
+		DMERR("%s: %s: blk_integrity_register failed.",
+		       __func__, dm_device_name(t->md));
+	else
+		DMDEBUG("%s: Enabling data integrity.", dm_device_name(t->md));
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
@@ -897,6 +935,7 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	dm_table_set_integrity(t);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
Index: linux-2.6.28/drivers/md/dm.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm.c	2009-01-07 15:38:20.000000000 +0000
+++ linux-2.6.28/drivers/md/dm.c	2009-01-07 18:43:17.000000000 +0000
@@ -703,6 +703,12 @@ static struct bio *split_bvec(struct bio
 	clone->bi_io_vec->bv_len = clone->bi_size;
 	clone->bi_flags |= 1 << BIO_CLONED;
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_trim(clone,
+				   bio_sector_offset(bio, idx, offset), len);
+	}
+
 	return clone;
 }
 
@@ -724,6 +730,14 @@ static struct bio *clone_bio(struct bio 
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone,
+					   bio_sector_offset(bio, idx, 0), len);
+	}
+
 	return clone;
 }
 
@@ -1191,6 +1205,7 @@ static void free_dev(struct mapped_devic
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
