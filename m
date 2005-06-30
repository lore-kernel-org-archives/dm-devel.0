From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 1 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 02:33:14 -0500
Message-ID: <9c5e9901e6e1e5f064cd64a5b855b503@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Kergon Alasdair <agk@redhat.com>
List-Id: dm-devel.ids

Thanks to some great feedback from agk and alewis, I've reworked the 
patches.  I moved away from creating new LOG_<state> defines and from 
forcing functions to do what they probably weren't meant to.  In the 
process though, I have added more log functions.  I think this makes 
things cleaner and clearer.  These 6 patches completely replace the old 
set of 8.

This first patch handles log device failures.

  brassow

diff -urN linux-2.6.12-orig/drivers/md/dm-log.c 
linux-2.6.12-00001/drivers/md/dm-log.c
--- linux-2.6.12-orig/drivers/md/dm-log.c	2005-06-17 14:48:29.000000000 
-0500
+++ linux-2.6.12-00001/drivers/md/dm-log.c	2005-06-29 
19:23:58.371949200 -0500
@@ -150,6 +150,7 @@
  	/*
  	 * Disk log fields
  	 */
+	int log_dev_failed;
  	struct dm_dev *log_dev;
  	struct log_header header;

@@ -412,6 +413,7 @@

  	lc = (struct log_c *) log->context;
  	lc->log_dev = dev;
+	lc->log_dev_failed = 0;

  	/* setup the disk header fields */
  	lc->header_location.bdev = lc->log_dev->bdev;
@@ -465,6 +467,17 @@
  	return count;
  }

+static void fail_log_device(struct log_c *lc)
+{
+	lc->log_dev_failed = 1;
+	dm_table_event(lc->ti->table);
+}
+
+static void restore_log_device(struct log_c *lc)
+{
+	lc->log_dev_failed = 0;
+}
+
  static int disk_resume(struct dirty_log *log)
  {
  	int r;
@@ -472,15 +485,16 @@
  	struct log_c *lc = (struct log_c *) log->context;
  	size_t size = lc->bitset_uint32_count * sizeof(uint32_t);

-	/* read the disk header */
-	r = read_header(lc);
-	if (r)
-		return r;
-
-	/* read the bits */
-	r = read_bits(lc);
-	if (r)
-		return r;
+	/*
+	 * Read the disk header, but only if we know it is good.
+	 */
+	if (!lc->log_dev_failed) {
+		if (read_header(lc) || read_bits(lc)) {
+			DMERR("A read failure has occurred on a mirror log device.");
+			fail_log_device(lc);
+			lc->header.nr_regions = 0;
+		}
+	}

  	/* set or clear any new bits */
  	if (lc->sync == NOSYNC)
@@ -496,16 +510,17 @@
  	memcpy(lc->sync_bits, lc->clean_bits, size);
  	lc->sync_count = count_bits32(lc->clean_bits, 
lc->bitset_uint32_count);

-	/* write the bits */
-	r = write_bits(lc);
-	if (r)
-		return r;
-
  	/* set the correct number of regions in the header */
  	lc->header.nr_regions = lc->region_count;

-	/* write the new header */
-	return write_header(lc);
+	/* write out the log */
+	if ((r = write_bits(lc)) || (r = write_header(lc))){
+		DMERR("A write failure has occurred on a mirror log device.");
+		fail_log_device(lc);
+	} else {
+		restore_log_device(lc);
+	}
+	return r;
  }

  static uint32_t core_get_region_size(struct dirty_log *log)
@@ -541,9 +556,29 @@
  	if (!lc->touched)
  		return 0;

+	/*
+	 * Could be dangerous if the write fails.
+	 * If the machine dies while the on-disk log is different from the 
core,
+	 * and the device is readable when the machine comes back, it may be
+	 * possible that not all regions will be recovered.
+	 *
+	 * The event is raised so that a user-land program 'waiting' on the
+	 * device can choose stop the mirror, remap the mirror using a
+	 * different log device, or switch to core.
+	 *
+	 * So, not taking action in user-space AND having a machine fail
+	 * after a log has failed AND having the device available when the
+	 * machine reboots is a bad thing.
+	 */
  	r = write_bits(lc);
-	if (!r)
+	if (!r) {
  		lc->touched = 0;
+		restore_log_device(lc);
+	} else {
+		DMERR("A write failure has occurred on a mirror log device.");
+		DMERR("Log device is now not in-sync with the core.");
+		fail_log_device(lc);
+	}

  	return r;
  }
