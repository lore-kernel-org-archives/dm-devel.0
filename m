From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 2 of 8] device failure tolerance
Date: Wed, 29 Jun 2005 13:11:12 -0500
Message-ID: <38d8d3826e021270e5f3f05f5da2196f@redhat.com>
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

This patch adds the ability to detect log device failures.

  brassow

diff -urN linux-2.6.12-001/drivers/md/dm-log.c 
linux-2.6.12-002/drivers/md/dm-log.c
--- linux-2.6.12-001/drivers/md/dm-log.c	2005-06-28 14:38:40.349390239 
-0500
+++ linux-2.6.12-002/drivers/md/dm-log.c	2005-06-28 15:26:47.916480356 
-0500
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
@@ -472,15 +474,27 @@
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
+	if(!lc->log_dev_failed){
+		r = read_header(lc);
+		if (r) {
+			DMERR("A read failure has occurred on a mirror log device.");
+			lc->log_dev_failed = 1;
+			dm_table_event(lc->ti->table);
+			lc->header.nr_regions = 0;
+		} else {
+			/* read the bits */
+			r = read_bits(lc);
+			if (r){
+				DMERR("A read failure has occurred on a mirror log device.");
+				lc->log_dev_failed = 1;
+				dm_table_event(lc->ti->table);
+				lc->header.nr_regions = 0;
+			}
+		}
+	}

  	/* set or clear any new bits */
  	if (lc->sync == NOSYNC)
@@ -496,16 +510,28 @@
  	memcpy(lc->sync_bits, lc->clean_bits, size);
  	lc->sync_count = count_bits32(lc->clean_bits, 
lc->bitset_uint32_count);

+	/* set the correct number of regions in the header */
+	lc->header.nr_regions = lc->region_count;
+
  	/* write the bits */
  	r = write_bits(lc);
-	if (r)
+	if (r) {
+		DMERR("A write failure has occurred on a mirror log device.");
+		lc->log_dev_failed = 1;
+		dm_table_event(lc->ti->table);
  		return r;
-
-	/* set the correct number of regions in the header */
-	lc->header.nr_regions = lc->region_count;
+	}

  	/* write the new header */
-	return write_header(lc);
+	r = write_header(lc);
+	if (r) {
+		DMERR("A write failure has occurred on a mirror log device.");
+		lc->log_dev_failed = 1;
+		dm_table_event(lc->ti->table);
+	} else
+		lc->log_dev_failed = 0;
+
+	return r;
  }

  static uint32_t core_get_region_size(struct dirty_log *log)
@@ -541,9 +567,29 @@
  	if (!lc->touched)
  		return 0;

+	/*
+	 * Could be dangerous if the write fails.
+	 * If the machine dies while the on-disk log is different from the 
core,
+	 * and the device is readalbe when the machine comes back, it may be
+	 * possible that not all regions will be recovered.
+	 *
+	 * The event is raised so that dmeventd can suspend the device for a
+	 * moment while it removes the log device.
+	 *
+	 * So, not running dmeventd and having a machine fail after a log has
+	 * failed and having the device available when the machine reboots is
+	 * a bad thing.
+	 */
  	r = write_bits(lc);
-	if (!r)
+	if (!r) {
  		lc->touched = 0;
+		lc->log_dev_failed = 0;
+	} else {
+		DMERR("A write failure has occurred on a mirror log device.");
+		DMERR("Log device is now not in-sync with the core.");
+		lc->log_dev_failed = 1;
+		dm_table_event(lc->ti->table);
+	}

  	return r;
  }
