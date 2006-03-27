From: Kevin Corry <kevcorry@us.ibm.com>
Subject: [RFC,
	PATCH] dm-log.c: Work with devices with hard-sector-size > 512 bytes
Date: Mon, 27 Mar 2006 15:46:24 -0600
Message-ID: <200603271546.25508.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: DevMapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

Some testing here revealed that on-disk logs for dm-mirror devices don't
work properly on devices with a hard-sector-size greater than 512 bytes
(many zSeries/s390 systems have disks with a hard-sector-size of 4k).

This patch is suprisingly simple, and primarily changes from using hard-
coded values of 1 sector to using the hard-sector-size reported in the
target's "limits" structure.

Unfortunately, the on-disk bitset is hardcoded to be at sector 2, which
is too small for any device with hard-sector-size > 1k. I've changed
this offset to sector 64 (32k from start of device), which should be a
safer choice. However, this necessitated a change of the disk-log version
from 2 to 3, meaning the new code would not be compatible with any
existing disk-logs. At the moment, I haven't added any code to deal with
this scenario - I wanted to get some opinions on how to best handle this.

Thanks,
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/



On-disk logs for dm-mirror devices are currently hard-coded to use 512 byte
hard-sector-sizes. This patch fixes the disk-log code to use the log device's
hard-sector-size where appropriate instead of 512.

This also moves the actual bitset to offset 32k. As such, the log version
has been incremented to 3, which is not backwards compatible with existing
disk-logs.

This also reallocates the clean_bits buffer. It's originally allocated in
the core_ctr() routine, but is only as big as the actual bitset. Since we
may read more from disk than just the size of the bitset, we need to
reallocate the buffer to the appropriate size.

Signed-Off-By: Kevin Corry <kevcorry@us.ibm.com>

Index: 2.6.16-perfmon2-2/drivers/md/dm-log.c
===================================================================
--- 2.6.16-perfmon2-2.orig/drivers/md/dm-log.c
+++ 2.6.16-perfmon2-2/drivers/md/dm-log.c
@@ -112,8 +112,8 @@ void dm_destroy_dirty_log(struct dirty_l
 /*
  * The on-disk version of the metadata.
  */
-#define MIRROR_DISK_VERSION 2
-#define LOG_OFFSET 2
+#define MIRROR_DISK_VERSION 3
+#define LOG_OFFSET 64
 
 struct log_header {
 	uint32_t magic;
@@ -376,6 +376,8 @@ static int disk_ctr(struct dirty_log *lo
 	size_t size;
 	struct log_c *lc;
 	struct dm_dev *dev;
+	unsigned int hardsect_size;
+	uint32_t *new_clean_bits;
 
 	if (argc < 2 || argc > 3) {
 		DMWARN("wrong number of arguments to disk mirror log");
@@ -393,19 +395,21 @@ static int disk_ctr(struct dirty_log *lo
 		return r;
 	}
 
+	hardsect_size = ti->limits.hardsect_size;
+
 	lc = (struct log_c *) log->context;
 	lc->log_dev = dev;
 
 	/* setup the disk header fields */
 	lc->header_location.bdev = lc->log_dev->bdev;
 	lc->header_location.sector = 0;
-	lc->header_location.count = 1;
+	lc->header_location.count = hardsect_size >> SECTOR_SHIFT;
 
 	/*
 	 * We can't read less than this amount, even though we'll
 	 * not be using most of this space.
 	 */
-	lc->disk_header = vmalloc(1 << SECTOR_SHIFT);
+	lc->disk_header = vmalloc(hardsect_size);
 	if (!lc->disk_header)
 		goto bad;
 
@@ -414,11 +418,23 @@ static int disk_ctr(struct dirty_log *lo
 	lc->bits_location.sector = LOG_OFFSET;
 
 	size = dm_round_up(lc->bitset_uint32_count * sizeof(uint32_t),
-			   1 << SECTOR_SHIFT);
+			   hardsect_size);
 	lc->bits_location.count = size >> SECTOR_SHIFT;
+
+	/* Realloc the clean_bits buffer, since we may read more
+	 * from disk than just the minimum size of the bitset.
+	 */
+	new_clean_bits = vmalloc(size);
+	if (!new_clean_bits)
+		goto bad;
+	vfree(lc->clean_bits);
+	lc->clean_bits = new_clean_bits;
+	memset(lc->clean_bits, -1, size);
+
 	return 0;
 
  bad:
+	vfree(lc->disk_header);
 	dm_put_device(ti, lc->log_dev);
 	core_dtr(log);
 	return -ENOMEM;
