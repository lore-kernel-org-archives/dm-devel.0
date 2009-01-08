From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] DM Block integrity support
Date: Thu, 08 Jan 2009 04:00:34 -0500
Message-ID: <yq1aba2xjd9.fsf@sermon.lab.mkp.net>
References: <yq1aba75wkr.fsf@sermon.lab.mkp.net>
	<20090107193123.GQ3512@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090107193123.GQ3512@agk.fab.redhat.com> (Alasdair G. Kergon's
	message of "Wed\, 7 Jan 2009 19\:31\:23 +0000")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Alasdair" == Alasdair G Kergon <agk@redhat.com> writes:

Alasdair> [FIXME: Looks as if that will hit BUG_ON(template == NULL) -
Alasdair> maybe there's an undocumented dependency on some other patch?

Sorry, yes.  That note got lost in the noise when I sliced and diced the
patch set.  There's a patch in Jens' tree that uses NULL to indicate the
default (empty) profile.  Subsequent calls to register will simply
update the already allocated profile.


Alasdair> [FIXME: Does this cope with integrity profile needing removing
Alasdair> after a table swap?]

Massaged version below.  I incorporated your changes.


Alasdair> [FIXME: blk_integrity_register() allocating & manipulating
Alasdair> kobjects needs moving outside __bind().  - Does the
Alasdair> preallocation address this now,

Yep.


Alasdair> with the exception of some unimportant races we'll ignore but
Alasdair> should document?  E.g. If integrity profile appears on an
Alasdair> underlying device between the reload and the table swap.
Alasdair> Would it be better for the table swap to fail in that
Alasdair> particular case?]

An integrity profile doesn't just appear out of the blue.  It takes
several hours to reformat a SCSI disk to turn it on (and the drive is
offline in the meantime).  So I think this is mostly in the academic
interest department.  I guess a runtime state transition could occur if
you have a DM device on top of a mirror with one drive with integrity
enabled and one without.  And you then swap the legacy disk out with an
integrity device in causing the RAID1 to suddenly be flagged as capable.
But at least from a physical storage device perspective the integrity
capability is a persistent state.

There's another corner case, though.  If you go from all legacy devices
to all integrity ditto no profile will be registered.  That's an
unfortunate side-effect of doing preallocation.  But also an unlikely
scenario, I'd say.


dm: Add support for data integrity to DM

This patch provides support for data integrity passthrough in the device
mapper.

 - If one or more component devices support integrity an integrity
   profile is preallocated for the DM device.

 - If all component devices have compatible profiles the DM device is
   flagged as capable.

 - Handle integrity metadata when splitting and cloning bios.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1046,6 +1046,19 @@ static int populate_table(struct dm_tabl
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
@@ -1064,6 +1077,14 @@ static int table_load(struct dm_ioctl *p
 	r = populate_table(t, param, param_size);
 	if (r) {
 		dm_table_put(t);
+		goto out;
+	}
+
+	r = table_prealloc_integrity(t, md);
+	if (r) {
+		DMERR("%s: could not register integrity profile.",
+		      dm_device_name(md));
+		dm_table_destroy(t);
 		goto out;
 	}
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -877,6 +877,45 @@ struct dm_target *dm_table_find_target(s
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
+
+	if (!blk_get_integrity(dm_disk(t->md)))
+		return;
+
+	list_for_each_entry(dd, devices, list) {
+		if (prev &&
+		    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
+					  dd->dm_dev.bdev->bd_disk) < 0) {
+			DMWARN("%s: integrity not set: %s and %s mismatch",
+			       dm_device_name(t->md),
+			       prev->dm_dev.bdev->bd_disk->disk_name,
+			       dd->dm_dev.bdev->bd_disk->disk_name);
+			goto no_integrity;
+		}
+		prev = dd;
+	}
+
+	if (!prev || !bdev_get_integrity(prev->dm_dev.bdev))
+		goto no_integrity;
+
+	blk_integrity_register(dm_disk(t->md),
+			       bdev_get_integrity(prev->dm_dev.bdev));
+
+	return;
+
+no_integrity:
+	blk_integrity_register(dm_disk(t->md), NULL);
+
+	return;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
@@ -897,6 +936,7 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	dm_table_set_integrity(t);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
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
 
@@ -723,6 +729,14 @@ static struct bio *clone_bio(struct bio 
 	clone->bi_vcnt = idx + bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone,
+					   bio_sector_offset(bio, idx, 0), len);
+	}
 
 	return clone;
 }
@@ -1191,6 +1205,7 @@ static void free_dev(struct mapped_devic
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
