From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 11/26] dm log: fault detection
Date: Tue, 8 May 2007 20:46:34 +0100
Message-ID: <20070508194634.GR24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan E Brassow <jbrassow@redhat.com>

This patch gives the disk logging code the ability to store the fact
that an error occured on the log device.  In addition, an event is
raised when an error is encountered during I/O to the log device.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-log.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

Index: linux-2.6.21/drivers/md/dm-log.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-log.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-log.c	2007-05-01 17:40:51.000000000 +0100
@@ -152,6 +152,7 @@ struct log_c {
 	/*
 	 * Disk log fields
 	 */
+	int log_dev_failed;
 	struct dm_dev *log_dev;
 	struct log_header header;
 
@@ -315,6 +316,7 @@ static int create_log_context(struct dir
 		lc->disk_header = NULL;
 	} else {
 		lc->log_dev = dev;
+		lc->log_dev_failed = 0;
 		lc->header_location.bdev = lc->log_dev->bdev;
 		lc->header_location.sector = 0;
 
@@ -437,6 +439,15 @@ static int count_bits32(uint32_t *addr, 
 	return count;
 }
 
+static void fail_log_device(struct log_c *lc)
+{
+	if (lc->log_dev_failed)
+		return;
+
+	lc->log_dev_failed = 1;
+	dm_table_event(lc->ti->table);
+}
+
 static int disk_resume(struct dirty_log *log)
 {
 	int r;
@@ -446,8 +457,12 @@ static int disk_resume(struct dirty_log 
 
 	/* read the disk header */
 	r = read_header(lc);
-	if (r)
+	if (r) {
+		DMWARN("%s: Failed to read header on mirror log device",
+		       lc->log_dev->name);
+		fail_log_device(lc);
 		return r;
+	}
 
 	/* set or clear any new bits -- device has grown */
 	if (lc->sync == NOSYNC)
@@ -472,7 +487,14 @@ static int disk_resume(struct dirty_log 
 	lc->header.nr_regions = lc->region_count;
 
 	/* write the new header */
-	return write_header(lc);
+	r = write_header(lc);
+	if (r) {
+		DMWARN("%s: Failed to write header on mirror log device",
+		       lc->log_dev->name);
+		fail_log_device(lc);
+	}
+
+	return r;
 }
 
 static uint32_t core_get_region_size(struct dirty_log *log)
@@ -516,7 +538,9 @@ static int disk_flush(struct dirty_log *
 		return 0;
 
 	r = write_header(lc);
-	if (!r)
+	if (r)
+		fail_log_device(lc);
+	else
 		lc->touched = 0;
 
 	return r;
