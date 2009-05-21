From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [RFC PATCH] dm-csum: A new device mapper target that
	checks data integrity
Date: Thu, 21 May 2009 13:13:17 -0300
Message-ID: <20090521161317.GU1376@blitiri.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dgjlcl3Tl+kb3YDk"
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
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi!

I'm writing this device mapper target that stores checksums on writes and
verifies them on reads.

It's not widely tested, but you can run mke2fs on it and do basic file
operations. The to-do list is still large, and most of it can be found within
the code.

To test it, you will need to format the device using the (very rough) attached
tool, and then create the dm device with something like:

	echo 0 $SIZE csum $REALDEVICE 0 | dmsetup create $NAME


I think it can be useful for people who want to detect data corruption and are
either using the block layer directly or a filesystem that doesn't check data
integrity (which are most, if not all, of the popular ones today). Maybe it
could also be used for testing the bio-integrity extensions, although at the
moment it's completely independent and I haven't looked much, but it's on my
to-do list.

It does NOT pretend to be useful for consistency checks for security purposes.
Use something else if you do not want someone evil tampering with your data.


Comments are obviously welcome. There are also some questions embedded in the
code, if anyone cares to answer any of them, I'd really appreciate it.

Thanks a lot,
		Alberto


--dgjlcl3Tl+kb3YDk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="dm-csum-1.patch"

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 36e0675..081e9bc 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -258,6 +258,16 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_CSUM
+	tristate "Checksumming target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	select CRC_CCITT
+	---help---
+	  A target that stores checksums on writes, and verifies
+	  them on reads.
+
+	  If unsure, say N.
+
 config DM_UEVENT
 	bool "DM uevents (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 45cc595..f938787 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_CSUM)		+= dm-csum.o
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
diff --git a/drivers/md/dm-csum.c b/drivers/md/dm-csum.c
new file mode 100644
index 0000000..c77e1e6
--- /dev/null
+++ b/drivers/md/dm-csum.c
@@ -0,0 +1,1281 @@
+/*
+ * A target that stores checksums on writes, and verifies them on reads.
+ * Alberto Bertogli <albertito@blitiri.com.ar>
+ *
+ * This device-mapper module provides data integrity verification by storing
+ * checksums on writes, and verifying them on reads.
+ *
+ *
+ * On-disk format
+ * --------------
+ *
+ * It stores an 8-byte "integrity metadata" ("imd", from now on) structure for
+ * each 512-byte data sector. imd structures are clustered in groups of 62
+ * plus a small header, so they fit a sector (referred to as an "imd sector").
+ * Every imd sector has a "brother", another adjacent imd sector, for
+ * consistency purposes (explained below). That means we devote two sectors to
+ * imd storage for every 62 data sectors.
+ *
+ * The imd structure consists of:
+ *   - 16 bit CRC (CCITT) (big endian)
+ *   - 16 bit flags (big endian)
+ *   - 32 bit tag
+ *
+ * The CRC is, obviously, the CRC of the sector this structure refers to. The
+ * flags are unused at the moment. The tag is not used by this module, but
+ * made available to the upper layers through the integrity framework (TODO:
+ * not implemented yet).
+ *
+ * The imd sector header contains a mark of the last update, so given two
+ * brothers we can determine which one is younger.
+ *
+ *
+ * We can either use the same device to store data sectors and imd sectors, or
+ * store each in different devices. If only one device is used, the sectors
+ * are interleaved: 1 sector is used to contain the imd for the following 62.
+ *
+ *
+ * Write procedure
+ * ---------------
+ *
+ * To guarantee consistency, two imd sectors (named M1 and M2) are kept for
+ * every 62 data sectors, and the following procedure is used to update them
+ * when a write to a given sector is required:
+ *
+ *  - Read both M1 and M2.
+ *  - Find out (using information stored in their headers) which one is newer.
+ *    Let's assume M1 is newer than M2.
+ *  - Update the M2 buffer to mark it's newer, and update the new data's CRC.
+ *  - Submit the write to M2, and then the write to the data, using a barrier
+ *    to make sure the metadata is updated _after_ the data.
+ *
+ * Accordingly, the read operations are handled as follows:
+ *
+ *  - Read both the data, M1 and M2.
+ *  - Find out which one is newer. Let's assume M1 is newer than M2.
+ *  - Calculate the data's CRC, and compare it to the one found in M1. If they
+ *    match, the reading is successful. If not, compare it to the one found in
+ *    M2. If they match, the reading is successful; otherwise, fail. If
+ *    the read involves multiple sectors, it is possible that some of the
+ *    correct CRCs are in M1 and some in M2.
+ *
+ * This scheme assumes that writes to a given sector can fail without
+ * affecting other sectors.
+ *
+ * TODO: would it be better to have M1 and M2 apart, to improve the chances of
+ * recovery in case of a failure?
+ *
+ * A simple locking structure is used to prevent simultaneous changes to the
+ * imd sectors.
+ *
+ * A last_accessed counter is stored in the imd sector header and used to
+ * find out if the given sector is newer than its brother. When writing out an
+ * imd sector, we will increase its count by 2.
+ * TODO: complete this comment.
+ *
+ *
+ * Code overview
+ * -------------
+ *
+ * The code uses the term "nice bio" to refer to a bio if all its sectors are
+ * covered by a single imd sector. Otherwise, the bio is "evil".
+ *
+ * The bulk of the code is the read and write handling, which is only designed
+ * to work with nice bios for simplicity. There's additional
+ * direction-independent code to split evil bios into nice ones.
+ *
+ * The rest is mostly concerned with device-mapper and module stuff.
+ *
+ * The code is divided in the following sections:
+ *
+ *  - Generic and miscellaneous code, including the csum_c structured used to
+ *    track a single csum device, and the functions used to manipulate sector
+ *    numbers.
+ *  - Code to handle the integrity metadata information, such as loading from
+ *    a buffer and validation.
+ *  - Read handling (remember: only for nice bios).
+ *  - Write handling (idem).
+ *  - Work queue.
+ *  - Evil bios handling.
+ *  - Device mapper constructor, destructor and mapper functions.
+ *  - DM target registration and module stuff.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/bio.h>
+#include <linux/slab.h>
+#include <linux/crc-ccitt.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <asm/atomic.h>
+#include <linux/device-mapper.h>
+#include <linux/workqueue.h>
+
+#define DM_MSG_PREFIX "csum"
+
+#if 1
+  #define dprint(...) printk(KERN_DEBUG __VA_ARGS__)
+#else
+  #define dprint(...)
+#endif
+
+
+/* Context information for device mapper */
+
+typedef sector_t (map_data_sector_fn) (struct dm_target *ti, sector_t data);
+typedef sector_t (get_imd_sector_fn) (struct dm_target *ti, sector_t data);
+
+struct csum_c {
+	/* data backing device */
+	struct dm_dev *data_dev;
+	sector_t data_start;
+
+	/* imd backing device (can be the same as data_dev) */
+	struct dm_dev *imd_dev;
+	sector_t imd_start;
+	sector_t imd_len;
+
+	map_data_sector_fn *map_data_sector;
+	get_imd_sector_fn *get_imd_sector;
+};
+
+
+/* TODO: use decent locking. At the moment, this semaphore is locked prior to
+ * submission to the work queue, and gets released after the work has been
+ * processed. This is needed to avoid concurrent accesses to the imd sectors.
+ * In the future, fine grained locking will be implemented. */
+static DECLARE_MUTEX(wq_lock);
+
+
+/*
+ * Utility functions for disk data manipulation
+ */
+
+/* How many sectors we reserve at the beginning of the data device for
+ * identification and device metadata */
+#define RESERVED_INITIAL_SECTORS_D 1
+
+/* If the metadata is on a different device, how many sectors we reserve at
+ * the beginning for identification and device metadata */
+#define RESERVED_INITIAL_SECTORS_M 1
+
+/* How many data sectors for each metadata sector. See the initial comment for
+ * a rationale on the value. */
+#define SECTORS_PER_IMD 62
+
+
+/* Return how many sectors are needed to store the imd information for the
+ * given amount of data sectors */
+static sector_t imd_sectors_needed(sector_t sectors)
+{
+	return dm_sector_div_up(sectors, SECTORS_PER_IMD) * 2;
+}
+
+/* Given a dm device sector, return the corresponding data device sector to
+ * find it from. We have one function to use when data and metadata are stored
+ * in different devices, and one to use when they're in the same device. Which
+ * one to use will be determined via function pointers in the context
+ * structure.  */
+static sector_t map_data_sector_diff(struct dm_target *ti, sector_t data)
+{
+	struct csum_c *cc = ti->private;
+
+	/* When stored in different devices, data is stored directly at the
+	 * given offset */
+	return cc->data_start + RESERVED_INITIAL_SECTORS_D +
+		(data - ti->begin);
+}
+
+static sector_t map_data_sector_same(struct dm_target *ti, sector_t data)
+{
+	struct csum_c *cc = ti->private;
+
+	/* When stored in the same device, interleaving makes things a little
+	 * more complicated. The offset will be the same as if there was no
+	 * interleaving, plus the number of imd sectors.
+	 * We call imd_sectors_needed with (data - ti->begin + 1) because it
+	 * receives a number of sectors, so 0 means no sectors and not an
+	 * offset. */
+	return cc->data_start + RESERVED_INITIAL_SECTORS_D +
+		(data - ti->begin) + imd_sectors_needed(data - ti->begin + 1);
+}
+
+/* Return the imd sector that holds the tuple for the given data sector. Its
+ * brother imd sector will be the result + 1, as they're always adjacent. */
+static sector_t get_imd_sector_diff(struct dm_target *ti, sector_t data)
+{
+	return RESERVED_INITIAL_SECTORS_M +
+		imd_sectors_needed(data - ti->begin + 1);
+}
+
+static sector_t get_imd_sector_same(struct dm_target *ti, sector_t data)
+{
+	sector_t isn = imd_sectors_needed(data - ti->begin + 1);
+
+	return RESERVED_INITIAL_SECTORS_D + SECTORS_PER_IMD * ((isn - 2) / 2)
+		+ (isn - 2);
+}
+
+
+/*
+ * Integrity metadata manipulation
+ */
+
+/* Each sector's integrity metadata. We only use crc at the moment. */
+struct imd_tuple {
+	__be16 crc;
+	__be16 flags;
+	__be32 tag;
+} __attribute__ ((packed));
+
+/* imd sector header, holds internal metadata */
+struct imd_sector_header {
+	/* 8 bits is enough for last_updated,  */
+	u8 last_updated;
+	u8 unused1;
+	__be16 crc;
+	__be32 unused3;
+} __attribute__ ((packed));
+
+/* Return the older of m1 and m2, or NULL if it was impossible to determine */
+static struct imd_sector_header *older_imd(struct imd_sector_header *m1,
+		struct imd_sector_header *m2)
+{
+	int l1, l2;
+
+	/* we get the values into something signed so we can subtract them */
+	l1 = m1->last_updated;
+	l2 = m2->last_updated;
+
+	if (abs(l1 - l2) > 1) {
+		//dprint("wrap-around: %d %d %u\n", l1, l2, abs(l1 - l2));
+		if (l1 == 0) {
+			return m2;
+		} else if (l2 == 0) {
+			return m1;
+		} else {
+			return NULL;
+		}
+	} else {
+		if (l1 > l2) {
+			return m2;
+		} else if (l1 < l2) {
+			return m1;
+		} else {
+			return NULL;
+		}
+	}
+}
+
+/* Return a bio that reads the given imd sectors (both M1 and M2), setting
+ * the bi_bdev to bdev, bi_end_io callback to cb, and bi_private to private.
+ * The returned bio will have a single page allocated, that must be freed. */
+static struct bio *prepare_imd_read(struct block_device *bdev, sector_t sector,
+		bio_end_io_t *cb, void *private)
+{
+	struct page *page = NULL;
+	struct bio *bio = NULL;
+
+	page = alloc_page(GFP_NOIO);
+	if (page == NULL)
+		goto error;
+
+	bio = bio_alloc(GFP_NOIO, 1);
+	if (bio == NULL)
+		goto error;
+
+	bio->bi_bdev = bdev;
+	bio->bi_sector = sector;
+	bio->bi_size = 1024;
+	bio->bi_rw |= READ;
+	bio->bi_end_io = cb;
+	bio->bi_private = private;
+	if (bio_add_page(bio, page, 1024, 0) != 1024)
+		goto error;
+
+	return bio;
+
+error:
+	if (page)
+		__free_page(page);
+	if (bio) {
+		bio->bi_end_io = NULL;
+		bio_put(bio);
+	}
+
+	return NULL;
+}
+
+/* Calculate the CRCs for the sectors in given bio. It assumes there is enough
+ * space in crc for all the sectors (i.e. crc can hold at least
+ * bio_sectors(bio) 16 bit integers). */
+static void crc_sectors_from_bio(const struct bio *bio, u16 *crc)
+{
+	int segno;
+	struct bio_vec *bvec;
+	unsigned long flags;
+	unsigned int sectors;
+	size_t len;
+	u16 current_crc;
+
+	/* bytes needed to complete the current CRC */
+	unsigned int bytes_needed;
+
+	/* bytes left in the current bvec */
+	unsigned int left_in_bvec;
+
+	sectors = bio_sectors(bio);
+
+	/* XXX: is there really no other way than using bvec_kmap_irq()? */
+	current_crc = 0;
+	bytes_needed = 512;
+	bio_for_each_segment(bvec, bio, segno) {
+		unsigned char *data = bvec_kmap_irq(bvec, &flags);
+		left_in_bvec = bvec->bv_len;
+
+start:
+		len = min(left_in_bvec, bytes_needed);
+		current_crc = crc_ccitt(current_crc, data, len);
+
+		bytes_needed -= len;
+		left_in_bvec -= len;
+
+		if (unlikely(bytes_needed)) {
+			/* we need to go through the next bvec */
+			bvec_kunmap_irq(data, &flags);
+			continue;
+		}
+
+		sectors--;
+		*crc = current_crc;
+		crc++;
+		current_crc = 0;
+		bytes_needed = 512;
+
+		if (left_in_bvec && sectors) {
+			/* this bvec still has some data left; if we still
+			 * have crcs to calculate, use it for the next one */
+			data += len;
+			goto start;
+		}
+
+		bvec_kunmap_irq(data, &flags);
+	}
+}
+
+/* Update the imd information for the given data bio. The function deals with
+ * the imd bio directly, that holds one page with both imd sectors (M1 and
+ * M2), as returned from prepare_imd_read(), and assumes it's been read from
+ * disk (so it will only update what's needed).
+ *
+ * Returns:
+ *  - 0 on success
+ *  - -1 if there was a memory error
+ *  - -2 if there was a consistency error
+ *
+ * TODO: make imd_bio write just the sector we need
+ */
+static int update_imd_bio(const struct bio *data_bio, struct bio *imd_bio)
+{
+	int i;
+	u16 *crc;
+	unsigned long flags;
+	unsigned char *imd_buf;
+	struct imd_sector_header *m1, *m2, *older;
+	struct imd_tuple *t;
+
+	crc = kmalloc(sizeof(u16) * bio_sectors(data_bio), GFP_NOIO);
+	if (crc == NULL)
+		return -1;
+
+	crc_sectors_from_bio(data_bio, crc);
+
+	imd_buf = bvec_kmap_irq(bio_iovec(imd_bio), &flags);
+
+	m1 = (struct imd_sector_header *) imd_buf;
+	m2 = (struct imd_sector_header *) (imd_buf + 512);
+
+	older = older_imd(m1, m2);
+	if (older == NULL) {
+		bvec_kunmap_irq(imd_buf, &flags);
+		kfree(crc);
+		return -2;
+	}
+
+	t = (struct imd_tuple *) (older + 1);
+	t = t + data_bio->bi_sector % SECTORS_PER_IMD;
+
+	for (i = 0; i < bio_sectors(data_bio); i++) {
+		t->crc = *(crc + i);
+		t++;
+	}
+
+	older->last_updated += 2;
+	older->crc = crc_ccitt(0, (unsigned char *) (older + 1),
+			512 - sizeof(struct imd_sector_header));
+
+	bvec_kunmap_irq(imd_buf, &flags);
+
+	kfree(crc);
+
+	return 0;
+}
+
+/* Verify that the CRCs from data_bio match the ones stored in imd_bio (which
+ * contains both M1 and M2) */
+static int verify_crc(struct bio *data_bio, struct bio *imd_bio)
+{
+	int i, r;
+	u16 *crc;
+	unsigned long flags;
+	unsigned char *imd_buf;
+	struct imd_sector_header *m1, *m2;
+	struct imd_tuple *m1t, *m2t;
+
+	crc = kmalloc(sizeof(u16) * bio_sectors(data_bio), GFP_NOIO);
+	if (crc == NULL)
+		return -ENOMEM;
+
+	crc_sectors_from_bio(data_bio, crc);
+
+	imd_buf = bvec_kmap_irq(bio_iovec(imd_bio), &flags);
+
+	m1 = (struct imd_sector_header *) imd_buf;
+	m2 = (struct imd_sector_header *) (imd_buf + 512);
+
+	m1t = (struct imd_tuple *) (m1 + 1);
+	m1t = m1t + data_bio->bi_sector % SECTORS_PER_IMD;
+
+	m2t = (struct imd_tuple *) (m2 + 1);
+	m2t = m2t + data_bio->bi_sector % SECTORS_PER_IMD;
+
+	r = 0;
+
+	for (i = 0; i < bio_sectors(data_bio); i++) {
+		WARN_ON(i >= SECTORS_PER_IMD);
+		if (m1t->crc != *(crc + i) && m2t->crc != *(crc + i)) {
+			printk(KERN_WARNING
+				"dm-csum: CRC error at sector %lld\n",
+				(unsigned long long)
+					(data_bio->bi_sector + i));
+			/*
+			dprint("CRC: %llu m1:%x m2:%x r:%x\n",
+					(unsigned long long)
+						(data_bio->bi_sector + i),
+					m1t->crc, m2t->crc, *(crc + i));
+			*/
+			r = -EIO;
+			break;
+		} else {
+			/*
+			dprint("OK : %llu m1:%x m2:%x r:%x\n",
+				(unsigned long long) (data_bio->bi_sector + i),
+				m1t->crc, m2t->crc, *(crc + i));
+			*/
+		}
+		m1t++;
+		m2t++;
+	}
+
+	/* TODO: validate the imd sector CRC */
+
+	bvec_kunmap_irq(imd_buf, &flags);
+
+	kfree(crc);
+
+	return r;
+}
+
+
+/*
+ * READ handling (nice bios only)
+ *
+ * Reads are handled by reading the requested data, and the imd sector
+ * associated with it. When both requests are completed, the data checksum is
+ * calculated and compared against what's in the imd sector.
+ */
+
+/* Used to track pending reads */
+struct pending_read {
+	spinlock_t lock;
+
+	struct dm_target *ti;
+	struct csum_c *cc;
+	struct bio *orig_bio;
+
+	struct bio *data_bio;
+	struct bio *imd_bio;
+
+	bool data_error;
+	bool imd_error;
+
+	/* number of operations pending */
+	unsigned int nr_pending;
+};
+
+#define pr_lock(pr) spin_lock(&((pr)->lock))
+#define pr_unlock(pr) spin_unlock(&((pr)->lock))
+
+static void read_nice_bio(struct dm_target *ti, struct bio *bio);
+static struct bio *prepare_data_read(struct bio *orig_bio,
+		struct block_device *bdev, sector_t sector, bio_end_io_t *cb,
+		void *private);
+static void read_complete(struct bio *bio, int error);
+
+/* Read a nice bio */
+static void read_nice_bio(struct dm_target *ti, struct bio *bio)
+{
+	struct csum_c *cc = ti->private;
+	struct pending_read *pr;
+
+	pr = kmalloc(sizeof(*pr), GFP_NOIO);
+	if (pr == NULL)
+		goto error;
+
+	spin_lock_init(&pr->lock);
+	pr->ti = ti;
+	pr->cc = cc;
+	pr->orig_bio = bio;
+	pr->data_error = false;
+	pr->imd_error = false;
+
+	pr->data_bio = prepare_data_read(pr->orig_bio, cc->data_dev->bdev,
+			cc->map_data_sector(ti, pr->orig_bio->bi_sector),
+			read_complete, pr);
+	if (pr->data_bio == NULL)
+		goto error;
+
+	pr->imd_bio = prepare_imd_read(cc->imd_dev->bdev,
+			cc->get_imd_sector(ti, pr->orig_bio->bi_sector),
+			read_complete, pr);
+	if (pr->imd_bio == NULL)
+		goto error;
+
+	pr->nr_pending = 2;
+
+	submit_bio(pr->data_bio->bi_rw, pr->data_bio);
+	submit_bio(pr->imd_bio->bi_rw, pr->imd_bio);
+	return;
+
+error:
+	bio_endio(bio, -ENOMEM);
+	return;
+}
+
+/* Prepare a new bio to read the data requested in orig_bio */
+static struct bio *prepare_data_read(struct bio *orig_bio,
+		struct block_device *bdev, sector_t sector, bio_end_io_t *cb,
+		void *private)
+{
+	struct bio *bio;
+
+	/* clone the bio so we don't override the original's bi_private and
+	 * bi_end_io */
+	bio = bio_clone(orig_bio, GFP_NOIO);
+	if (bio == NULL)
+		return NULL;
+
+	bio->bi_bdev = bdev;
+	bio->bi_sector = sector;
+	bio->bi_end_io = cb;
+	bio->bi_private = private;
+
+	return bio;
+}
+
+/* Read completion callback */
+static void read_complete(struct bio *bio, int error)
+{
+	int result = -EIO;
+	struct pending_read *pr = bio->bi_private;
+
+	pr_lock(pr);
+
+	pr->nr_pending--;
+
+	if (pr->nr_pending > 0) {
+		pr_unlock(pr);
+		return;
+	}
+
+	/* we know we have exclusive access to the pr, no need to lock
+	 * around it anymore */
+	pr_unlock(pr);
+
+	if (pr->data_error) {
+		printk(KERN_WARNING "dm-csum: error reading data\n");
+		goto exit;
+	} else if (pr->imd_error) {
+		printk(KERN_WARNING "dm-csum: error reading imd\n");
+		goto exit;
+	}
+
+	/* TODO: add an option for those who do not want the bio to fail on
+	 * CRC errors */
+	result = verify_crc(pr->orig_bio, pr->imd_bio);
+
+exit:
+	/* TODO: use decent locking */
+	up(&wq_lock);
+
+	/* free the page allocated in prepare_imd_read() */
+	__free_page(pr->imd_bio->bi_io_vec->bv_page);
+
+	/* XXX: is the ordering between this and bio_put(pr->data_bio)
+	 * important? I think not, but confirmation wouldn't hurt */
+	bio_endio(pr->orig_bio, result);
+
+	bio_put(pr->data_bio);
+	bio_put(pr->imd_bio);
+
+	kfree(pr);
+}
+
+#undef pr_lock
+#undef pr_unlock
+
+
+/*
+ * WRITE handling (nice bios only)
+ */
+
+/* Used to track pending writes */
+struct pending_write {
+	spinlock_t lock;
+
+	struct dm_target *ti;
+	struct csum_c *cc;
+
+	struct bio *orig_bio;
+	struct bio *imd_bio;
+	struct bio *data_bio;
+
+	bool error;
+	unsigned int nr_pending;
+};
+
+#define pw_lock(pw) spin_lock(&((pw)->lock))
+#define pw_unlock(pw) spin_unlock(&((pw)->lock))
+
+/* Writes begin with write_nice_bio(), that queues the imd bio read. When that
+ * bio is done, write_stage1() gets called, which updates the imd data and
+ * then queues both the imd write and the data write. When those are
+ * completed, write_stage2() gets called, which finishes up and ends the
+ * original bio. */
+static void write_nice_bio(struct dm_target *ti, struct bio *bio);
+static void write_stage1(struct bio *bio, int error);
+static void write_stage2(struct bio *bio, int error);
+
+/* Write a nice bio */
+static void write_nice_bio(struct dm_target *ti, struct bio *bio)
+{
+	struct csum_c *cc = ti->private;
+	struct pending_write *pw;
+
+	pw = kmalloc(sizeof(*pw), GFP_NOIO);
+	if (pw == NULL) {
+		bio_endio(bio, -ENOMEM);
+		return;
+	}
+
+	spin_lock_init(&pw->lock);
+	pw->ti = ti;
+	pw->cc = cc;
+	pw->orig_bio = bio;
+	pw->data_bio = NULL;
+	pw->error = false;
+	pw->nr_pending = 0;
+
+	pw->imd_bio = prepare_imd_read(cc->imd_dev->bdev,
+			cc->get_imd_sector(ti, pw->orig_bio->bi_sector),
+			write_stage1, pw);
+	if (pw->imd_bio == NULL) {
+		kfree(pw);
+		bio_endio(bio, -ENOMEM);
+		return;
+	}
+
+	submit_bio(pw->imd_bio->bi_rw, pw->imd_bio);
+}
+
+/* Called when the imd bio has been read */
+static void write_stage1(struct bio *imd_bio, int error)
+{
+	int r;
+	int err = -EIO;
+	struct pending_write *pw = imd_bio->bi_private;
+	struct csum_c *cc = pw->cc;
+	struct dm_target *ti = pw->ti;
+	struct bio *data_bio;
+
+	r = update_imd_bio(pw->orig_bio, imd_bio);
+	if (r == -1) {
+		err = -ENOMEM;
+		goto error;
+	} else if (r == -2) {
+		printk(KERN_WARNING "dm-csum: consistency error updating"
+				" imd sector\n");
+		err = -EIO;
+		goto error;
+	}
+
+	/* prepare bio for reuse */
+	imd_bio->bi_rw |= WRITE;
+	imd_bio->bi_end_io = write_stage2;
+
+	data_bio = bio_clone(pw->orig_bio, GFP_NOIO);
+	if (data_bio == NULL) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	data_bio->bi_private = pw;
+	data_bio->bi_end_io = write_stage2;
+	data_bio->bi_bdev = cc->data_dev->bdev;
+	data_bio->bi_sector = cc->map_data_sector(ti, pw->orig_bio->bi_sector);
+
+	/* data bio takes a barrier, so we know the imd write will have
+	 * completed before it hits the disk */
+	data_bio->bi_rw |= (1 << BIO_RW_BARRIER);
+
+	pw->data_bio = data_bio;
+
+	/* TODO: when data and imd are on separate devices, the barrier trick
+	 * is no longer useful */
+
+	/* submit both bios at the end to simplify error handling; remember
+	 * the order is very important because of the barrier */
+	pw->nr_pending = 2;
+	submit_bio(imd_bio->bi_rw, imd_bio);
+	submit_bio(data_bio->bi_rw, data_bio);
+	return;
+
+error:
+	bio_endio(pw->orig_bio, err);
+	__free_page(imd_bio->bi_io_vec->bv_page);
+	bio_put(imd_bio);
+	kfree(pw);
+	return;
+}
+
+static void write_stage2(struct bio *bio, int error)
+{
+	struct pending_write *pw = bio->bi_private;
+
+	pw_lock(pw);
+	pw->nr_pending--;
+	if (error)
+		pw->error = true;
+
+	if (pw->nr_pending) {
+		pw_unlock(pw);
+		//dprint(" w s2 -\n");
+		return;
+	}
+
+	/* if we got here, there's no need to lock pw anymore as we know we
+	 * have exclusive access */
+	pw_unlock(pw);
+
+	/* TODO: use decent locking */
+	up(&wq_lock);
+
+	/* free the imd_bio resources */
+	__free_page(pw->imd_bio->bi_io_vec->bv_page);
+	bio_put(pw->imd_bio);
+
+	/* XXX: like read_complete(): is the order between this and
+	 * bio_put(pw->data_bio) important? */
+	bio_endio(pw->orig_bio, pw->error ? -EIO : 0);
+
+	bio_put(pw->data_bio);
+
+	kfree(pw);
+}
+
+#undef pw_lock
+#undef pw_unlock
+
+
+/*
+ * Work queue to process bios.
+ *
+ * It is created in dm_csum_init().
+ *
+ * TODO: handle more than one pending bio, and dispatch more than one as long
+ * as they don't overlap. Maybe one worqueue per ctx? Or maybe delay the
+ * creation of the workqueue until the first ctx?
+ */
+
+static struct workqueue_struct *wq;
+
+struct pending_work {
+	struct dm_target *ti;
+	struct bio *bio;
+	struct work_struct w;
+};
+
+static void process_nice_bio(struct work_struct *work)
+{
+	struct pending_work *pending;
+	struct dm_target *ti;
+	struct bio *bio;
+
+	pending = container_of(work, struct pending_work, w);
+
+	ti = pending->ti;
+	bio = pending->bio;
+
+	/* TODO: use decent locking
+	 * At the moment, this lock is up()ed at the final stage of the
+	 * read/write code, when the bio has been processed */
+	down(&wq_lock);
+
+	switch (bio_data_dir(bio)) {
+	case READ:
+		read_nice_bio(ti, bio);
+		break;
+	case WRITE:
+		write_nice_bio(ti, bio);
+		break;
+	default:
+		dprint("Unknown direction\n");
+		BUG();
+		break;
+	}
+
+	kfree(pending);
+}
+
+static int queue_nice_bio(struct dm_target *ti, struct bio *bio)
+{
+	struct pending_work *pending;
+
+	pending = kmalloc(sizeof(struct pending_work), GFP_NOIO);
+	if (pending == NULL)
+		return -ENOMEM;
+
+	pending->ti = ti;
+	pending->bio = bio;
+
+	INIT_WORK(&(pending->w), process_nice_bio);
+
+	queue_work(wq, &(pending->w));
+
+	return 0;
+}
+
+
+/*
+ * Evil bio handling
+ *
+ * Evil bios are split into nice ones in a direction-independant way, and then
+ * go through the direction-dependant code (which is prepared to deal with
+ * nice bios only, because it makes the code much simpler).
+ *
+ * When all the nice bios are completed, we end the original, evil bio.
+ */
+
+/* Determines if a bio is evil */
+static int bio_is_evil(struct dm_target *ti, struct bio *bio)
+{
+	sector_t mapped_first, mapped_last;
+
+	/* TODO: add a comment on why we do this */
+	mapped_first = map_data_sector_same(ti, bio->bi_sector);
+	mapped_last = map_data_sector_same(ti,
+			bio->bi_sector + bio_sectors(bio) - 1);
+
+	return (mapped_last - mapped_first) != (bio_sectors(bio) - 1);
+}
+
+
+/* Used to track pending evil bios */
+struct pending_evil_bio {
+	spinlock_t lock;
+
+	struct csum_c *cc;
+
+	/* original evil bio */
+	struct bio *orig_bio;
+
+	/* number of bios pending */
+	unsigned int nr_pending;
+
+	/* were there any errors? */
+	bool error;
+
+};
+
+#define peb_lock(peb) spin_lock(&((peb)->lock))
+#define peb_unlock(peb) spin_unlock(&((peb)->lock))
+
+static int handle_evil_bio(struct dm_target *ti, struct bio *bio);
+static struct bio *prepare_nice_bio(struct pending_evil_bio *peb,
+		struct bio *bio, sector_t begin, sector_t size);
+static void evil_bio_complete(struct bio *bio, int error);
+
+/* Handle an evil bio, by splitting it into nice ones and processing them */
+static int handle_evil_bio(struct dm_target *ti, struct bio *bio)
+{
+	int i, r;
+	sector_t first, last, prelude, postlude;
+	unsigned int nmiddle, submitted_bios;
+	struct pending_evil_bio *peb;
+	struct bio *new;
+
+	/*
+	dprint("evil bio! s:%lu n:%lu l:%lu d:%d \ti:%lu o:%lu\t\tp:%p\n",
+			bio->bi_sector, bio_sectors(bio), bio->bi_size,
+			bio_data_dir(bio),
+			bio->bi_idx, bio_iovec(bio)->bv_offset,
+			bio_iovec(bio)->bv_page);
+	*/
+
+	peb = kmalloc(sizeof(*peb), GFP_NOIO);
+	if (peb == NULL)
+		return -ENOMEM;
+
+	spin_lock_init(&peb->lock);
+	peb->orig_bio = bio;
+	peb->error = false;
+	peb->cc = ti->private;
+
+	/* We will split the bio in:
+	 *  - optionally a "prelude bio" of sectors <= SECTORS_PER_IMD
+	 *  - 0 or more "middle bios" sectors == SECTORS_PER_IMD
+	 *  - a "postlude bio" <= SECTORS_PER_IMD
+	 *
+	 * TODO: there's room to simplify this math, we're keeping it simple
+	 * for now
+	 */
+	first = bio->bi_sector;
+	last = bio->bi_sector + bio_sectors(bio);
+
+	/* How many sectors until the first cut */
+	prelude = dm_sector_div_up(first, SECTORS_PER_IMD)
+		* SECTORS_PER_IMD - first;
+
+	/* How many sectors from the last cut until last */
+	postlude = last - (dm_sector_div_up(last, SECTORS_PER_IMD) - 1)
+		* SECTORS_PER_IMD;
+
+	/* How many SECTORS_PER_IMD are between the first and last cuts */
+	nmiddle = ( (last - postlude) - (first + prelude) ) / SECTORS_PER_IMD;
+
+	peb->nr_pending = 1 + nmiddle + 1;
+
+	/*
+	dprint("  first:%lu last:%lu pre:%lu nm:%lu post:%lu pending:%lu\n",
+			first, last, prelude, nmiddle, postlude,
+			peb->nr_pending);
+	*/
+
+	submitted_bios = 0;
+
+	/* From now on, access to peb will be locked to avoid races with
+	 * evil_bio_complete() */
+
+	/* Submit the prelude bio */
+	if (prelude) {
+		new = prepare_nice_bio(peb, bio, first, prelude);
+		if (new == NULL) {
+			kfree(peb);
+			return -ENOMEM;
+		}
+
+		r = queue_nice_bio(ti, new);
+		if (r < 0)
+			goto prepare_error;
+
+		submitted_bios++;
+	}
+
+	/* Submit the middle bios */
+	for (i = 0; i < nmiddle; i++) {
+		new = prepare_nice_bio(peb, bio,
+				first + prelude + i * SECTORS_PER_IMD,
+				SECTORS_PER_IMD);
+		if (new == NULL)
+			goto prepare_error;
+
+		r = queue_nice_bio(ti, new);
+		if (r < 0)
+			goto prepare_error;
+
+		submitted_bios++;
+	}
+
+	/* Submit the postlude bio */
+	new = prepare_nice_bio(peb, bio, (last - postlude), postlude);
+	if (new == NULL) {
+		goto prepare_error;
+	}
+	r = queue_nice_bio(ti, new);
+	if (r < 0)
+		goto prepare_error;
+
+	submitted_bios++;
+
+	return 0;
+
+prepare_error:
+	/* There was an error in prepare_nice_bio(), but we already have some
+	 * in-flight bios that have been submitted and will call
+	 * evil_bio_complete() when they're done; decrement the expected
+	 * number of bios, and check if we're already done */
+	peb_lock(peb);
+	peb->nr_pending -= peb->nr_pending - submitted_bios;
+	peb->error = true;
+
+	if (peb->nr_pending == 0) {
+		peb_unlock(peb);
+		kfree(peb);
+		return -ENOMEM;
+	}
+
+	peb_unlock(peb);
+
+	return 0;
+}
+
+/* Prepare a new nice bio cloned from the original one */
+static struct bio *prepare_nice_bio(struct pending_evil_bio *peb,
+		struct bio *bio, sector_t begin, sector_t size)
+{
+	int segno, advance, sofar;
+	struct bio *new;
+	struct bio_vec *bvec;
+
+	new = bio_clone(bio, GFP_NOIO);
+	if (new == NULL)
+		return NULL;
+
+	new->bi_sector = begin;
+	new->bi_size = size * 512;
+
+	WARN_ON(bio_sectors(new) != size);
+
+	/* Make the new bio start in the right idx and offset
+	 * TODO: this can be optimized because we're walking the same thing
+	 * over and over */
+
+	advance = (begin - bio->bi_sector) * 512;
+	sofar = 0;
+	segno = 0; /* will be set to bio->bi_idx by bio_for_each_segment */
+	bio_for_each_segment(bvec, new, segno) {
+		if (sofar + bvec->bv_len > advance) {
+			break;
+		}
+
+		sofar += bvec->bv_len;
+	}
+
+	new->bi_idx = segno;
+	bio_iovec(new)->bv_offset += advance - sofar;
+	bio_iovec(new)->bv_len =
+		min(new->bi_size, bio_iovec(new)->bv_len - advance - sofar);
+
+	new->bi_private = peb;
+	new->bi_end_io = evil_bio_complete;
+
+	return new;
+}
+
+static void evil_bio_complete(struct bio *bio, int error)
+{
+	struct pending_evil_bio *peb = bio->bi_private;
+
+	peb_lock(peb);
+
+	peb->nr_pending--;
+	if (error)
+		peb->error = true;
+
+	if (peb->nr_pending == 0) {
+		bio_endio(peb->orig_bio, peb->error ? -EIO : 0);
+		peb_unlock(peb);
+		kfree(peb);
+	} else {
+		peb_unlock(peb);
+	}
+
+	/* put the bio created with bio_clone() because we don't longer care
+	 * about it */
+	bio_put(bio);
+}
+
+#undef peb_lock
+#undef peb_unlock
+
+
+/*
+ * Device mapper
+ */
+
+/* Constructor: <data dev path> <data dev offset> \
+ * 	[ <integrity dev path> <integrity dev offset> ] */
+static int csum_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int err;
+	fmode_t mode;
+	unsigned long long data_offset, imd_offset;
+	sector_t data_dev_len;
+	struct csum_c *cc;
+
+	if (argc != 2 && argc != 4) {
+		ti->error = "Incorrect number of arguments";
+		return -EINVAL;
+	}
+
+	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
+	if (cc == NULL) {
+		ti->error = "Cannot allocate context information";
+		return -ENOMEM;
+	}
+	cc->data_dev = cc->imd_dev = NULL;
+	cc->data_start = cc->imd_start = cc->imd_len = 0;
+
+	err = -EINVAL;
+
+	if (sscanf(argv[1], "%llu", &data_offset) != 1) {
+		ti->error = "Invalid data dev offset";
+		goto error;
+	}
+	cc->data_start = data_offset;
+
+	/* If we have both data and metadata on the same device, the
+	 * advertised size of the dm device will be slightly less than the
+	 * total, to account for the space dedicated to the metadata */
+	if (argc == 2) {
+		data_dev_len = ti->len + imd_sectors_needed(ti->len);
+	} else {
+		data_dev_len = ti->len;
+	}
+
+	mode = dm_table_get_mode(ti->table);
+	if (dm_get_device(ti, argv[0], cc->data_start, data_dev_len, mode,
+			&(cc->data_dev))) {
+		ti->error = "data device lookup failed";
+		goto error;
+	}
+
+	if (argc == 2) {
+		cc->map_data_sector = map_data_sector_same;
+		cc->get_imd_sector = get_imd_sector_same;
+		cc->imd_dev = cc->data_dev;
+	} else if (argc == 4) {
+		if (sscanf(argv[3], "%llu", &imd_offset) != 1) {
+			ti->error = "Invalid integrity dev offset";
+			goto error;
+		}
+		cc->imd_start = imd_offset;
+		cc->imd_len = imd_sectors_needed(ti->len);
+
+		if (dm_get_device(ti, argv[2], cc->imd_start,
+				cc->imd_len, mode, &(cc->imd_dev))) {
+			ti->error = "Integrity device lookup failed";
+			goto error;
+		}
+
+		cc->map_data_sector = map_data_sector_diff;
+		cc->get_imd_sector = get_imd_sector_diff;
+	}
+
+	ti->private = cc;
+
+	return 0;
+
+error:
+	if (cc->data_dev) {
+		if (cc->data_dev == cc->imd_dev) {
+			dm_put_device(ti, cc->data_dev);
+		} else {
+			dm_put_device(ti, cc->data_dev);
+			dm_put_device(ti, cc->imd_dev);
+		}
+	}
+	kfree(cc);
+	return err;
+}
+
+/* Destructor, undoes what was done in the constructor */
+static void csum_dtr(struct dm_target *ti)
+{
+	struct csum_c *cc = ti->private;
+
+	if (cc->data_dev == cc->imd_dev) {
+		dm_put_device(ti, cc->data_dev);
+	} else {
+		dm_put_device(ti, cc->data_dev);
+		dm_put_device(ti, cc->imd_dev);
+	}
+
+	kfree(cc);
+}
+
+/* Operation mapping */
+static int csum_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context)
+{
+	int rv;
+
+	if (bio_is_evil(ti, bio))
+		rv = handle_evil_bio(ti, bio);
+	else
+		rv = queue_nice_bio(ti, bio);
+
+	if (rv < 0)
+		return rv;
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+
+/*
+ * Target registration and module stuff
+ */
+
+static struct target_type csum_target = {
+	.name   = "csum",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr    = csum_ctr,
+	.dtr	= csum_dtr,
+	.map    = csum_map,
+};
+
+static int __init dm_csum_init(void)
+{
+	int dm_rv;
+
+	wq = create_workqueue("dm-csum");
+	if (wq == NULL)
+		return -ENOMEM;
+
+	dm_rv = dm_register_target(&csum_target);
+	if (dm_rv < 0) {
+		DMERR("register failed: %d", dm_rv);
+		destroy_workqueue(wq);
+		return dm_rv;
+	}
+
+	return 0;
+}
+
+static void __exit dm_csum_exit(void)
+{
+	dm_unregister_target(&csum_target);
+	destroy_workqueue(wq);
+}
+
+module_init(dm_csum_init)
+module_exit(dm_csum_exit)
+
+MODULE_AUTHOR("Alberto Bertogli <albertito@blitiri.com.ar>");
+MODULE_DESCRIPTION(DM_NAME " checksumming I/O target");
+MODULE_LICENSE("GPL v2");
+

--dgjlcl3Tl+kb3YDk
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="mk-dm-csum.c"


/* Formats the given file for use by dm-csum */

/* Needed to use pwrite() */
#define _XOPEN_SOURCE 500

#include <stdio.h>		/* printf() */
#include <stdlib.h>		/* malloc() */
#include <unistd.h>		/* pwrite() and friends */
#include <sys/types.h>		/* open() */
#include <sys/stat.h>		/* open() */
#include <fcntl.h>		/* open() */
#include <stdint.h>		/* uint8_t and friends */
#include <string.h>		/* memset() */


/* simple definitions so we can copy-paste the structs from the kernel */
#define u8 uint8_t
#define __be16 uint16_t
#define __be32 uint32_t

/*
 * Copied from the kernel definition, MUST match
 */

#define RESERVED_INITIAL_SECTORS_D 1
#define RESERVED_INITIAL_SECTORS_M 1
#define SECTORS_PER_IMD 62

struct imd_tuple {
        __be16 crc;
        __be16 flags;
        __be32 tag;
} __attribute__ ((packed));

struct imd_sector_header {
        u8 last_updated;
        u8 unused1;
        __be16 crc;
        __be32 unused3;
} __attribute__ ((packed));


/* Format function to use when imd and data are on the same device */
int format_same(int fd, off_t total_size) {
	int r;
	off_t off;
	unsigned char buf[1024];
	struct imd_sector_header *m1, *m2;

	memset(buf, 0, sizeof(buf));

	m1 = (struct imd_sector_header *) buf;
	m2 = (struct imd_sector_header *) (buf + 512);

	m1->last_updated = 2;
	m2->last_updated = 1;

	off = RESERVED_INITIAL_SECTORS_D * 512;

	while (off < total_size) {
		r = pwrite(fd, buf, 1024, off);
		if (r != 1024)
			return -1;
		off += 1024 + SECTORS_PER_IMD * 512;
	}

	return 0;
}

int format_diff(int data_fd, int imd_fd, off_t total_size)
{
	printf("Not implemented yet\n");
	return 0;
}

void usage()
{
	printf("Use: mk-dm-csum same <device>\n");
	printf(" or: mk-dm-csum diff <data device> <imd device>\n");
}

int main(int argc, char **argv)
{
	int fd, imd_fd;
	off_t total_size;
	int same;

	if (argc < 3) {
		usage();
		return 1;
	}

	if (strcmp(argv[1], "same") == 0) {
		same = 1;
	} else if (strcmp(argv[1], "diff") == 0) {
		same = 0;
	} else {
		usage();
		return 1;
	}

	fd = open(argv[2], O_WRONLY);
	if (fd < 0) {
		perror("Error opening device");
		return 1;
	}

	/* TODO: diff */

	total_size = lseek(fd, 0, SEEK_END);
	if (total_size == -1) {
		perror("Error finding out the size");
		return 1;
	}

	/* round down to a multiple of SECTORS_PER_IMD */
	total_size -= total_size % SECTORS_PER_IMD;

	if (same) {
		if (format_same(fd, total_size) != 0) {
			perror("Error formatting");
			return 2;
		}
	} else {
		if (format_diff(fd, imd_fd, total_size) != 0) {
			perror("Error formatting");
			return 2;
		}
	}

	if (fsync(fd) != 0) {
		perror("Error syncing data to disk");
		return 3;
	}

	return 0;
}


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--dgjlcl3Tl+kb3YDk--
