From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: [RFC,
	=?iso-8859-1?q?=09PATCH=5D_dm-log=2Ec=3A_Work_with_devices_with?=
	=?iso-8859-1?q?_hard-sector-size?= > 512 bytes
Date: Tue, 28 Mar 2006 08:42:58 -0600
Message-ID: <200603280842.58248.kevcorry@us.ibm.com>
References: <OFF9070A97.1B2B4FBF-ONC125713F.0043348E-C125713F.0043C3DD@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OFF9070A97.1B2B4FBF-ONC125713F.0043348E-C125713F.0043C3DD@de.ibm.com>
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
List-Id: dm-devel.ids

Hi Stefan,

On Tue March 28 2006 6:20 am, Stefan Bader wrote:
> > Unfortunately, the on-disk bitset is hardcoded to be at sector 2, which
> > is too small for any device with hard-sector-size > 1k. I've changed
> > this offset to sector 64 (32k from start of device), which should be a
> > safer choice. However, this necessitated a change of the disk-log version
> > from 2 to 3, meaning the new code would not be compatible with any
> > existing disk-logs. At the moment, I haven't added any code to deal with
> > this scenario - I wanted to get some opinions on how to best handle this.
>
> Would it really hurt to leave the sector offset just at 2?

Do you mean 2 * hard-sector-size? As it's coded now, it will always be at
offset 1k.

> That way the bitset data starts at different byte offsets but that would be
> consistent  with the device. A fix byte offset would only be needed if a
> device could change its hardsector size without loosing data, wouldn't it?

Yes, that would work. I guess I'm just not keen on placing metadata in a
location that's dependent on some unrecorded property of the device. Having
the log always start at a well-known location seems a lot simpler to me.

But, so we can compare, here's an updated patch that changes the bitset
offset to (2 * hard-sector-size), which should be backwards compatible
with existing mirror logs (assuming that almost all disks have 512
hard-sector-sizes).

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/



On-disk logs for dm-mirror devices are currently hard-coded to use 512 byte
hard-sector-sizes. This patch fixes the disk-log code to use the log device's
hard-sector-size where appropriate instead of 512.

This also reallocates the clean_bits buffer. It's originally allocated in
the core_ctr() routine, but is only as big as the actual bitset. Since we
may read more from disk than just the size of the bitset, we need to
reallocate the buffer to the appropriate size.

Signed-Off-By: Kevin Corry <kevcorry@us.ibm.com>

Index: 2.6.16-perfmon2-2/drivers/md/dm-log.c
===================================================================
--- 2.6.16-perfmon2-2.orig/drivers/md/dm-log.c
+++ 2.6.16-perfmon2-2/drivers/md/dm-log.c
@@ -376,6 +376,8 @@ static int disk_ctr(struct dirty_log *lo
 	size_t size;
 	struct log_c *lc;
 	struct dm_dev *dev;
+	unsigned int hardsect_size;
+	uint32_t *new_clean_bits;
 
 	if (argc < 2 || argc > 3) {
 		DMWARN("wrong number of arguments to disk mirror log");
@@ -393,32 +395,46 @@ static int disk_ctr(struct dirty_log *lo
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
 
 	/* setup the disk bitset fields */
 	lc->bits_location.bdev = lc->log_dev->bdev;
-	lc->bits_location.sector = LOG_OFFSET;
+	lc->bits_location.sector = LOG_OFFSET * (hardsect_size >> SECTOR_SHIFT);
 
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
