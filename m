From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: [RFC,
	PATCH] dm-log.c: Work with devices with hard-sector-size > 512 bytes
Date: Mon, 8 May 2006 22:28:32 -0500
Message-ID: <200605082228.33401.kevcorry@us.ibm.com>
References: <200603271546.25508.kevcorry@us.ibm.com>
	<20060328150100.GD2690@agk.surrey.redhat.com>
	<200603281658.36642.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200603281658.36642.kevcorry@us.ibm.com>
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue March 28 2006 4:58 pm, Kevin Corry wrote:
> On Tue March 28 2006 9:01 am, Alasdair G Kergon wrote:
> > A couple of options:
> >
> >   Retain the existing on-disk format exactly, but adjust the offsets and
> >   sizes used in the reads and writes to avoid the problems (pre-reading
> >   other data if necessary to extend a write).
>
> This method seems like it should be easy to implement. We could just extend
> the buffer for the disk-header and always read and write both the header
> and the log at the same time, and just point lc->clean_bits at the
> appropriate offset within that buffer. The log could then remain at offset
> 1k, and the version wouldn't have to change.

Sorry I haven't had a chance to get back to this in a while. I was finally 
able to finish up a new patch to fix this bug based on the above suggestions.

This patch maintains compatibility with the existing metadata layout by 
combining the disk-header buffer and clean-bits bitset buffer into a single 
buffer.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/


On-disk logs for dm-mirror devices are currently hard-coded to use 512 byte
hard-sector-sizes. This patch fixes dm-log so it will work with devices
with non-512-byte hard-sector-sizes.

To maintain full compatibility, instead of moving the clean-bits bitset to a
different location, this patch removes the separate buffer used for the
bitset, and enlarges the disk-header buffer to encompass both the header and
the bitset. The I/O routines for the bitset are removed, and the I/O routines
for the disk-header now also read/write the bitset.

Signed-Off-By: Kevin Corry <kevcorry@us.ibm.com>

Index: 2.6.17-rc1/drivers/md/dm-log.c
===================================================================
--- 2.6.17-rc1.orig/drivers/md/dm-log.c
+++ 2.6.17-rc1/drivers/md/dm-log.c
@@ -155,8 +155,6 @@ struct log_c {
 
 	struct io_region header_location;
 	struct log_header *disk_header;
-
-	struct io_region bits_location;
 };
 
 /*
@@ -241,29 +239,6 @@ static inline int write_header(struct lo
 }
 
 /*----------------------------------------------------------------
- * Bits IO
- *--------------------------------------------------------------*/
-static int read_bits(struct log_c *log)
-{
-	int r;
-	unsigned long ebits;
-
-	r = dm_io_sync_vm(1, &log->bits_location, READ,
-			  log->clean_bits, &ebits);
-	if (r)
-		return r;
-
-	return 0;
-}
-
-static int write_bits(struct log_c *log)
-{
-	unsigned long ebits;
-	return dm_io_sync_vm(1, &log->bits_location, WRITE,
-			     log->clean_bits, &ebits);
-}
-
-/*----------------------------------------------------------------
  * core log constructor/destructor
  *
  * argv contains region_size followed optionally by [no]sync
@@ -373,9 +348,11 @@ static int disk_ctr(struct dirty_log *lo
 		    unsigned int argc, char **argv)
 {
 	int r;
-	size_t size;
+	size_t size, bitset_size;
 	struct log_c *lc;
 	struct dm_dev *dev;
+	uint32_t *clean_bits;
+	unsigned int hardsect_size;
 
 	if (argc < 2 || argc > 3) {
 		DMWARN("wrong number of arguments to disk mirror log");
@@ -396,26 +373,30 @@ static int disk_ctr(struct dirty_log *lo
 	lc = (struct log_c *) log->context;
 	lc->log_dev = dev;
 
+	hardsect_size = ti->limits.hardsect_size;
+	bitset_size = lc->bitset_uint32_count * sizeof(uint32_t);
+
 	/* setup the disk header fields */
 	lc->header_location.bdev = lc->log_dev->bdev;
 	lc->header_location.sector = 0;
-	lc->header_location.count = 1;
 
-	/*
-	 * We can't read less than this amount, even though we'll
-	 * not be using most of this space.
-	 */
-	lc->disk_header = vmalloc(1 << SECTOR_SHIFT);
+	/* Include both the header and the bitset in one buffer. */
+	size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) + bitset_size,
+			   hardsect_size);
+	lc->header_location.count = size >> SECTOR_SHIFT;
+
+	lc->disk_header = vmalloc(size);
 	if (!lc->disk_header)
 		goto bad;
 
-	/* setup the disk bitset fields */
-	lc->bits_location.bdev = lc->log_dev->bdev;
-	lc->bits_location.sector = LOG_OFFSET;
-
-	size = dm_round_up(lc->bitset_uint32_count * sizeof(uint32_t),
-			   1 << SECTOR_SHIFT);
-	lc->bits_location.count = size >> SECTOR_SHIFT;
+	/* Deallocate the clean_bits buffer that was allocated in core_ctr()
+	 * and point it at the appropriate place in the disk_header buffer.
+	 */
+	clean_bits = lc->clean_bits;
+	lc->clean_bits = (void *)lc->disk_header + (LOG_OFFSET << SECTOR_SHIFT);
+	memcpy(lc->clean_bits, clean_bits, bitset_size);
+	vfree(clean_bits);
+
 	return 0;
 
  bad:
@@ -429,6 +410,7 @@ static void disk_dtr(struct dirty_log *l
 	struct log_c *lc = (struct log_c *) log->context;
 	dm_put_device(lc->ti, lc->log_dev);
 	vfree(lc->disk_header);
+	lc->clean_bits = NULL;
 	core_dtr(log);
 }
 
@@ -449,16 +431,11 @@ static int disk_resume(struct dirty_log 
 	struct log_c *lc = (struct log_c *) log->context;
 	size_t size = lc->bitset_uint32_count * sizeof(uint32_t);
 
-	/* read the disk header */
+	/* read the disk header and bitset */
 	r = read_header(lc);
 	if (r)
 		return r;
 
-	/* read the bits */
-	r = read_bits(lc);
-	if (r)
-		return r;
-
 	/* set or clear any new bits */
 	if (lc->sync == NOSYNC)
 		for (i = lc->header.nr_regions; i < lc->region_count; i++)
@@ -473,15 +450,10 @@ static int disk_resume(struct dirty_log 
 	memcpy(lc->sync_bits, lc->clean_bits, size);
 	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
 
-	/* write the bits */
-	r = write_bits(lc);
-	if (r)
-		return r;
-
 	/* set the correct number of regions in the header */
 	lc->header.nr_regions = lc->region_count;
 
-	/* write the new header */
+	/* write the new header and bitset */
 	return write_header(lc);
 }
 
@@ -518,7 +490,7 @@ static int disk_flush(struct dirty_log *
 	if (!lc->touched)
 		return 0;
 
-	r = write_bits(lc);
+	r = write_header(lc);
 	if (!r)
 		lc->touched = 0;
 
