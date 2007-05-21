From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 3/10]
	dm-raid1-handle-recovery-write-failures.patch
Date: Mon, 21 May 2007 17:02:07 -0500
Message-ID: <1179784927.13913.22.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

 brassow

This patch gives mirror the ability to handle write failures
during recovery.

We check over the bits in 'write_err' and call a new function,
fail_mirror, on those devices whose bit is set.  'fail_mirror'
increments the error_count on the mirror device, and will
switch the primary device pointer for the mirror set if the
mirror is in-sync.

To maintain backwards compatibility, fail_mirror does nothing
if the DM_FEATURES_HANDLE_ERRORS flag is not present.

Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -113,6 +113,7 @@ struct region {
  *---------------------------------------------------------------*/
 struct mirror {
 	atomic_t error_count;
+	struct mirror_set *ms;
 	struct dm_dev *dev;
 	sector_t offset;
 };
@@ -653,19 +654,37 @@ static void bio_set_ms(struct bio *bio, 
  * are in the no-sync state.  We have to recover these by
  * recopying from the default mirror to all the others.
  *---------------------------------------------------------------*/
+static void fail_mirror(struct mirror *m);
 static void recovery_complete(int read_err, unsigned int write_err,
 			      void *context)
 {
 	struct region *reg = (struct region *) context;
+	struct mirror_set *ms = reg->rh->ms;
+	int m, bit = 0;
 
 	if (read_err)
 		/* Read error means the failure of default mirror. */
 		DMERR_LIMIT("Unable to read primary mirror during recovery");
 
-	if (write_err)
+	if (write_err) {
 		DMERR_LIMIT("Write error during recovery (error = 0x%x)",
 			    write_err);
 
+		/*
+		 * Bits correspond to devices (excluding default mirror).
+		 * The default mirror cannot change during recovery.
+		 */
+		for (m = 0; m < ms->nr_mirrors; m++) {
+			if (&ms->mirror[m] == ms->default_mirror)
+				continue;
+
+			/* FIXME: does write_err need to be 'unsigned long'? */
+			if (test_bit(bit, &write_err))
+				fail_mirror(ms->mirror + m);
+			bit++;
+		}
+	}
+
 	rh_recovery_end(reg, !(read_err || write_err));
 }
 
@@ -752,6 +771,55 @@ static struct mirror *choose_mirror(stru
 	return ms->default_mirror;
 }
 
+/* fail_mirror
+ * @m: mirror device to fail
+ *
+ * If the device is valid, mark it invalid.  Also,
+ * if this is the default mirror device (i.e. the primary
+ * device) and the mirror set is in-sync, choose an
+ * alternate primary device.
+ *
+ * This function must not block
+ */
+static void fail_mirror(struct mirror *m)
+{
+	struct mirror_set *ms = m->ms;
+	struct mirror *new;
+
+	/* Are we handling or ignoring device failures */
+	if (!(ms->features & DM_RAID1_HANDLE_ERRORS))
+		return;
+
+	atomic_inc(&m->error_count);
+
+	if (atomic_read(&m->error_count) > 1)
+		return;
+
+	if (m != ms->default_mirror)
+		return;
+
+	/* If the default mirror fails, change it. */
+	if (!ms->in_sync) {
+		/*
+		 * Can not switch primary.  Better to issue requests
+		 * to same failing device than to risk returning
+		 * corrupt data.
+		 */
+		DMERR("Primary mirror device has failed while mirror is not in-sync");
+		DMERR("Unable to choose alternative primary device");
+		return;
+	}
+
+	for (new = ms->mirror; new < ms->mirror + ms->nr_mirrors; new++)
+		if (!atomic_read(&new->error_count)) {
+			ms->default_mirror = new;
+			break;
+		}
+
+	if (unlikely(new == ms->mirror + ms->nr_mirrors))
+		DMWARN("All sides of mirror have failed.");
+}
+
 /*
  * remap a buffer to a particular mirror.
  */
@@ -1020,6 +1088,8 @@ static int get_mirror(struct mirror_set 
 	}
 
 	ms->mirror[mirror].offset = offset;
+	atomic_set(&(ms->mirror[mirror].error_count), 0);
+	ms->mirror[mirror].ms = ms;
 
 	return 0;
 }
