From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] block: Inline blk_integrity in struct
	gendisk
Date: Mon, 21 Sep 2015 16:45:07 -0400
Message-ID: <20150921204506.GA36289@redhat.com>
References: <20150721120102.GB1654@infradead.org>
	<1440103314-31610-1-git-send-email-martin.petersen@oracle.com>
	<1440103314-31610-6-git-send-email-martin.petersen@oracle.com>
	<20150916010720.GA21398@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150916010720.GA21398@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: dm-devel.ids

On Tue, Sep 15 2015 at  9:07P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> Long story short, DM changes that eliminate the checks/code for
> allocating the blk_integrity structure should be all that is needed for
> this patch.
> 
> I'll work through this further.  Hope to send an incremental patch that
> fixes things up in the next day or so.

Here is what I came up with.  Leaves something to be desired given the
integrity profile is being established on first table load (as opposed
to during resume like the old DM and block integrity code did).. but we
can iterate on this as needed.

Feel free to fold it into your last patch and add my Signed-off-by.

From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 21 Sep 2015 14:58:44 -0400
Subject: [PATCH] dm table: fixup block integrity profile processing

Not very different from what Martin originally proposed but subtle
changes include:

. only register the integrity profile on first table load; subsequent
  loads must have a matching integrity profile
  - if profile is already registered, verify new table's profile matches

. resume only verifies that the DM device's integrity profile matches
  all the underlying devices' profiles.
  - if they don't match the DM device's integrity profile is unregistered

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c | 77 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e2f98fc..061152a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1014,6 +1014,11 @@ static int dm_table_build_index(struct dm_table *t)
 	return r;
 }
 
+static bool integrity_profile_exists(struct gendisk *disk)
+{
+	return !!blk_get_integrity(disk);
+}
+
 /*
  * Get a disk whose integrity profile reflects the table's profile.
  * Returns NULL if integrity support was inconsistent or unavailable.
@@ -1026,10 +1031,10 @@ static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t)
 
 	list_for_each_entry(dd, devices, list) {
 		template_disk = dd->dm_dev->bdev->bd_disk;
-		if (!blk_get_integrity(template_disk))
+		if (!integrity_profile_exists(template_disk))
 			goto no_integrity;
-		if (prev_disk &&
-		    blk_integrity_compare(prev_disk, template_disk) < 0)
+		else if (prev_disk &&
+			 blk_integrity_compare(prev_disk, template_disk) < 0)
 			goto no_integrity;
 		prev_disk = template_disk;
 	}
@@ -1055,23 +1060,40 @@ no_integrity:
  * profile validation: First pass during table load, final pass during
  * resume.
  */
-static int dm_table_set_integrity(struct dm_table *t)
+static int dm_table_register_integrity(struct dm_table *t)
 {
+	struct mapped_device *md = t->md;
 	struct gendisk *template_disk = NULL;
-	bool existing_profile = blk_get_integrity(dm_disk(t->md));
 
 	template_disk = dm_table_get_integrity_disk(t);
-	if (template_disk) {
-		blk_integrity_register(dm_disk(t->md),
-				       blk_get_integrity(template_disk));
+	if (!template_disk)
+		return 0;
+
+	if (!integrity_profile_exists(dm_disk(md))) {
 		t->integrity_supported = 1;
-	} else if (existing_profile) {
-		blk_integrity_unregister(dm_disk(t->md));
-		DMWARN("%s: device no longer has a valid integrity profile",
-		       dm_device_name(t->md));
+		/*
+		 * Register integrity profile during table load; we can do
+		 * this because the final profile must match during resume.
+		 */
+		blk_integrity_register(dm_disk(md),
+				       blk_get_integrity(template_disk));
+		return 0;
+	}
+
+	/*
+	 * If DM device already has an initialized integrity
+	 * profile the new profile should not conflict.
+	 */
+	if (blk_integrity_compare(dm_disk(md), template_disk) < 0) {
+		DMWARN("%s: conflict with existing integrity profile: "
+		       "%s profile mismatch",
+		       dm_device_name(t->md),
+		       template_disk->disk_name);
 		return 1;
 	}
 
+	/* Preserve existing integrity profile */
+	t->integrity_supported = 1;
 	return 0;
 }
 
@@ -1095,7 +1117,7 @@ int dm_table_complete(struct dm_table *t)
 		return r;
 	}
 
-	r = dm_table_set_integrity(t);
+	r = dm_table_register_integrity(t);
 	if (r) {
 		DMERR("could not register integrity profile.");
 		return r;
@@ -1260,6 +1282,33 @@ combine_limits:
 	return validate_hardware_logical_block_alignment(table, limits);
 }
 
+/*
+ * Verify that all devices have an integrity profile that matches the
+ * DM device's registered integrity profile.  If the profiles don't
+ * match then unregister the DM device's integrity profile.
+ */
+static void dm_table_verify_integrity(struct dm_table *t)
+{
+	struct gendisk *template_disk = NULL;
+
+	if (t->integrity_supported) {
+		/*
+		 * Verify that the original integrity profile
+		 * matches all the devices in this table.
+		 */
+		template_disk = dm_table_get_integrity_disk(t);
+		if (template_disk &&
+		    blk_integrity_compare(dm_disk(t->md), template_disk) >= 0)
+			return;
+	}
+
+	if (integrity_profile_exists(dm_disk(t->md))) {
+		DMWARN("%s: unable to establish an integrity profile",
+		       dm_device_name(t->md));
+		blk_integrity_unregister(dm_disk(t->md));
+	}
+}
+
 static int device_flush_capable(struct dm_target *ti, struct dm_dev *dev,
 				sector_t start, sector_t len, void *data)
 {
@@ -1457,7 +1506,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
 
-	dm_table_set_integrity(t);
+	dm_table_verify_integrity(t);
 
 	/*
 	 * Determine whether or not this queue's I/O timings contribute
-- 
2.3.8 (Apple Git-58)
