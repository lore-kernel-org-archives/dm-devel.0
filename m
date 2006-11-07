From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 4 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:01:27 -0600
Message-ID: <1162915287.17899.41.camel@hydrogen.msp.redhat.com>
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
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

This patch gives the disk logging code the ability to store the fact
that an error occured on the log device.  This allows us to print
the status of the device - something that userspace requires to take
appropriate action.

In addition, an event is raised when an error is encountered during
I/O to the log device.  Coupled with the above, this gives userspace
the ability to detect the error and understand what went wrong.

Index: linux-2.6.18.1/drivers/md/dm-log.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-log.c	2006-11-01 13:51:10.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-log.c	2006-11-01 14:37:19.000000000 -0600
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
+		DMWARN("Failed to read header on mirror log device, %s",
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
+		DMWARN("Failed to write header on mirror log device, %s",
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
@@ -591,6 +615,7 @@ static int core_status(struct dirty_log 
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("1 core");
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -611,6 +636,8 @@ static int disk_status(struct dirty_log 
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("3 disk %s %c", lc->log_dev->name,
+		       lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-01 13:51:32.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-01 14:34:56.000000000 -0600
@@ -1222,11 +1222,9 @@ static void mirror_resume(struct dm_targ
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	unsigned int m, sz;
+	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 
-	sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
-
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
@@ -1240,6 +1238,7 @@ static int mirror_status(struct dm_targe
 		break;
 
 	case STATUSTYPE_TABLE:
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
 		DMEMIT("%d ", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT("%s %llu ", ms->mirror[m].dev->name,
