From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: PATCH - pvmove doesn't terminate sometimes on 64-bit
	bigendian machines
Date: Wed, 28 Sep 2005 18:48:27 +0100
Message-ID: <20050928174827.GS18976@agk.surrey.redhat.com>
References: <17191.43003.616513.15285@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <17191.43003.616513.15285@cse.unsw.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: dm-devel@redhat.com, Patrick Caulfield <pcaulfie@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 14, 2005 at 02:32:59PM +1000, Neil Brown wrote:
>  It is worth noting that the code uses the same bitsets for in-memory
>  and on-disk logs.  As these bitsets are host-endian and host-sized,
>  this means that they cannot safely be moved between computers with
>  different architectures.  I don't know if the dm doco makes this
>  clear...
 
Are you able to try out the (untested) patch from Patrick below?
Since the current implementation is broken for 64-bit BE we might
as well fix both problems at the same time.

Alasdair


From: Patrick Caulfield <pcaulfie@redhat.com>

The solution seems to be to use to set_le_bit test_le_bit functions that ext2
uses. That makes the BE machines keep the bitmap internally in LE order - it
does mean you can't use any other type of operations on the bitmap words but
that looks to be OK in this instance. The efficiency tradeoff is very minimal as
you would expect for something that ext2 uses.

The nice thing about this way is that there is no on-disk format change for
32bit LE boxes at least, and even nicer is that it removes code and data
structures because log->disk_bits disappears.


Index: linux-2.6.14-rc2/drivers/md/dm-log.c
===================================================================
--- linux-2.6.14-rc2.orig/drivers/md/dm-log.c	2005-09-28 18:32:53.000000000 +0100
+++ linux-2.6.14-rc2/drivers/md/dm-log.c	2005-09-28 18:33:30.000000000 +0100
@@ -157,7 +157,6 @@
 	struct log_header *disk_header;
 
 	struct io_region bits_location;
-	uint32_t *disk_bits;
 };
 
 /*
@@ -166,20 +165,20 @@
  */
 static  inline int log_test_bit(uint32_t *bs, unsigned bit)
 {
-	return test_bit(bit, (unsigned long *) bs) ? 1 : 0;
+	return ext2_test_bit(bit, (unsigned long *) bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
 			       uint32_t *bs, unsigned bit)
 {
-	set_bit(bit, (unsigned long *) bs);
+	ext2_set_bit(bit, (unsigned long *) bs);
 	l->touched = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
-	clear_bit(bit, (unsigned long *) bs);
+	ext2_clear_bit(bit, (unsigned long *) bs);
 	l->touched = 1;
 }
 
@@ -239,45 +238,24 @@
 /*----------------------------------------------------------------
  * Bits IO
  *--------------------------------------------------------------*/
-static inline void bits_to_core(uint32_t *core, uint32_t *disk, unsigned count)
-{
-	unsigned i;
-
-	for (i = 0; i < count; i++)
-		core[i] = le32_to_cpu(disk[i]);
-}
-
-static inline void bits_to_disk(uint32_t *core, uint32_t *disk, unsigned count)
-{
-	unsigned i;
-
-	/* copy across the clean/dirty bitset */
-	for (i = 0; i < count; i++)
-		disk[i] = cpu_to_le32(core[i]);
-}
-
 static int read_bits(struct log_c *log)
 {
 	int r;
 	unsigned long ebits;
 
 	r = dm_io_sync_vm(1, &log->bits_location, READ,
-			  log->disk_bits, &ebits);
+			  log->clean_bits, &ebits);
 	if (r)
 		return r;
 
-	bits_to_core(log->clean_bits, log->disk_bits,
-		     log->bitset_uint32_count);
 	return 0;
 }
 
 static int write_bits(struct log_c *log)
 {
 	unsigned long ebits;
-	bits_to_disk(log->clean_bits, log->disk_bits,
-		     log->bitset_uint32_count);
 	return dm_io_sync_vm(1, &log->bits_location, WRITE,
-			     log->disk_bits, &ebits);
+			     log->clean_bits, &ebits);
 }
 
 /*----------------------------------------------------------------
@@ -433,11 +411,6 @@
 	size = dm_round_up(lc->bitset_uint32_count * sizeof(uint32_t),
 			   1 << SECTOR_SHIFT);
 	lc->bits_location.count = size >> SECTOR_SHIFT;
-	lc->disk_bits = vmalloc(size);
-	if (!lc->disk_bits) {
-		vfree(lc->disk_header);
-		goto bad;
-	}
 	return 0;
 
  bad:
@@ -451,7 +424,6 @@
 	struct log_c *lc = (struct log_c *) log->context;
 	dm_put_device(lc->ti, lc->log_dev);
 	vfree(lc->disk_header);
-	vfree(lc->disk_bits);
 	core_dtr(log);
 }
 
