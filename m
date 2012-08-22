From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Tue, 21 Aug 2012 21:03:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208212102550.1653@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
	<20120821163329.GA21395@freewill.lab.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120821163329.GA21395@freewill.lab.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Ramsay <jim_ramsay@dell.com>
Cc: dm-devel@redhat.com, Jason_Shamberger@dell.com, agk@redhat.com, Kevin_OKelley@dell.com
List-Id: dm-devel.ids

This is a new version that uses hex numbers.

---

This is simplified dm-switch target, originally written by Jim Ramsay.

Changes from the original:

Removed netlink interface and added dm message interface to change
mapping table because the message interface is noticeably simpler.
The table is changed by sending dm message:
"dmsetup message <device-name> 0 set-table <commands...>"
The mesage can have multiple commands, each command has format
"<page>:<device index>" (sets specified page) or ":<device index>" (sets
previous page plus 1 to the specified index). <page> and <device index>
are in hexadecimal format.
For example "dmsetup message switch 0 set-table 3:0 :2 :7 F:4"
sets page 3 to device 0, page 4 to device 2, page 5 to device 7, page 15
to device 4.

The dm-switch.h file was removed (if the netlink was removed, there is
no need for this file).

Page table is allocated using vmalloc instead of kmalloc. kmalloc
allocates physically contiguous memory and it can fail if memory is
fragmented. vmalloc allocates discontiguous memory and maps it to a
contiguous virtual address range using MMU.

RCU and page table reallocation was removed. The page table is allocated
in the constructor and stays the same for the lifetime of the device.
The page table can be read and modified at the same time, so there is no
need to use RCU.

The page table is initialized with a repetitive pattern that uses all
the devices.

One page table entry has 64-bit size on 64-bit processors and 32-bit
size on 32-bit processors (in the original it was always 32-bit). Making
it 64-bit makes it consume slightly less space in some cases.

Removed dm status:
- ios_remapped/ios_unmapped counting was removed because all the IOs are
  mapped when statically allocated page table is used.
- Userspace-supplied numbers that are reported in the status were
  removed because it is not clear what were they used for.
- The device list with 'A' statuses was removed (it could be added back
  if we implement device error tracking); there was just mock code that
  returned 'A' for all devices.

Device limit check was simplified to use i_size_read and fixed to take
account of 'start' value as well.

do_div was replaced with sector_div - if we have 32-bit sectors, we
don't need to do slow 64-bit math.

The divisions were optimized if the divisor is a power of two.

Set dm_set_target_max_io_len. The original code didn't set it, so it
could issue IOs that span page boundaries.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/Kconfig     |   11 +
 drivers/md/Makefile    |    1 
 drivers/md/dm-switch.c |  485 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 497 insertions(+)

Index: linux-3.5.2-fast/drivers/md/Kconfig
===================================================================
--- linux-3.5.2-fast.orig/drivers/md/Kconfig	2012-08-22 02:03:19.000000000 +0200
+++ linux-3.5.2-fast/drivers/md/Kconfig	2012-08-22 02:04:01.000000000 +0200
@@ -417,4 +417,15 @@ config DM_VERITY2
 
 source "drivers/md/enhanceio/Kconfig"
 
+config DM_SWITCH
+	tristate "Switch target support (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Help text needs writing
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-switch.
+
+	  If unsure, say N.
+
 endif # MD
Index: linux-3.5.2-fast/drivers/md/Makefile
===================================================================
--- linux-3.5.2-fast.orig/drivers/md/Makefile	2012-08-22 02:03:19.000000000 +0200
+++ linux-3.5.2-fast/drivers/md/Makefile	2012-08-22 02:04:01.000000000 +0200
@@ -48,6 +48,7 @@ obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 obj-$(CONFIG_DM_ZEROED)		+= dm-zeroed.o
 obj-$(CONFIG_DM_ENHANCEIO)	+= enhanceio/
+obj-$(CONFIG_DM_SWITCH)		+= dm-switch.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
Index: linux-3.5.2-fast/drivers/md/dm-switch.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.5.2-fast/drivers/md/dm-switch.c	2012-08-22 03:00:50.000000000 +0200
@@ -0,0 +1,485 @@
+/*
+ * Copyright (c) 2010-2011 by Dell, Inc.  All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Description:
+ *
+ *     file:    dm-switch.c
+ *     authors: Kevin_OKelley@dell.com
+ *              Jim_Ramsay@dell.com
+ *              Narendran_Ganapathy@dell.com
+ *		mpatocka@redhat.com
+ *
+ * This file implements a "switch" target which efficiently implements a
+ * mapping of IOs to underlying block devices in scenarios where there are:
+ *   (1) a large number of address regions
+ *   (2) a fixed size equal across all address regions
+ *   (3) no pattern than allows for a compact description with something like
+ *       the dm-stripe target.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device-mapper.h>
+#include <linux/vmalloc.h>
+
+#define DM_MSG_PREFIX "switch"
+
+/*
+ * Switch device context block: A new one is created for each dm device.
+ * Contains an array of devices from which we have taken references.
+ */
+struct switch_dev {
+	struct dm_dev *dmdev;
+	sector_t start;
+};
+
+typedef unsigned long pt_entry;
+
+/* Switch context header */
+struct switch_ctx {
+	unsigned dev_count;		/* Number of devices */
+	unsigned page_size;		/* Page size in 512B sectors */
+	unsigned long n_pages;		/* Number of pages */
+	signed char page_size_bits;	/* log2 of page_size or -1 */
+
+	unsigned char pte_size;		/* Page table entry size in bits */
+	unsigned char pte_fields;	/* Number of entries per pt_entry */
+	signed char pte_fields_bits;	/* log2 of pte_fields or -1 */
+	pt_entry *page_table;		/* Page table */
+
+	/* Array of dm devices to switch between */
+	struct switch_dev dev_list[0];
+};
+
+static inline void switch_get_position(struct switch_ctx *pctx,
+				       unsigned long page,
+				       unsigned long *index,
+				       unsigned *bit)
+
+{
+	if (pctx->pte_fields_bits >= 0) {
+		*index = page >> pctx->pte_fields_bits;
+		*bit = page & (pctx->pte_fields - 1);
+	} else {
+		*index = page / pctx->pte_fields;
+		*bit = page % pctx->pte_fields;
+	}
+	*bit *= pctx->pte_size;
+
+}
+
+static void switch_page_table_write(struct switch_ctx *pctx, unsigned long page,
+				    unsigned value)
+{
+	unsigned long index;
+	unsigned bit;
+	pt_entry pte;
+
+	switch_get_position(pctx, page, &index, &bit);
+
+	pte = pctx->page_table[index];
+	pte &= ~((((pt_entry)1 << pctx->pte_size) - 1) << bit);
+	pte |= (pt_entry)value << bit;
+	pctx->page_table[index] = pte;
+}
+
+/*
+ * Constructor: Called each time a dmsetup command creates a dm device.  The
+ * target parameter will already have the table, type, begin and len fields
+ * filled in.  Arguments are in pairs: <dev_path> <offset>.  Therefore, we get
+ * multiple constructor calls, but we will need to build a list of switch_ctx
+ * blocks so that the page table information gets matched to the correct
+ * device.
+ */
+static int switch_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	unsigned a;
+	int n;
+	int r;
+	unsigned dev_count;
+	struct switch_ctx *pctx;
+	sector_t dev_size;
+	unsigned long e;
+
+	if (argc < 4) {
+		ti->error = "Insufficient arguments";
+		r = -EINVAL;
+		goto error;
+	}
+	if (kstrtouint(argv[0], 10, &dev_count) ||
+	    !dev_count ||
+	    dev_count > (KMALLOC_MAX_SIZE - sizeof(struct switch_ctx)) / sizeof(struct switch_dev)) {
+		ti->error = "Invalid device count";
+		r = -EINVAL;
+		goto error;
+	}
+	if (dev_count != (argc - 2) / 2) {
+		ti->error = "Invalid argument count";
+		r = -EINVAL;
+		goto error;
+	}
+	pctx = kmalloc(sizeof(struct switch_ctx) + (dev_count * sizeof(struct switch_dev)),
+		       GFP_KERNEL);
+	if (!pctx) {
+		ti->error = "Cannot allocate redirect context";
+		r = -ENOMEM;
+		goto error;
+	}
+	pctx->dev_count = dev_count;
+	if (kstrtouint(argv[1], 10, &pctx->page_size) ||
+	    !pctx->page_size) {
+		ti->error = "Invalid page size";
+		r = -EINVAL;
+		goto error_kfree;
+	}
+
+	if (!(pctx->page_size & (pctx->page_size - 1)))
+		pctx->page_size_bits = __ffs(pctx->page_size);
+	else
+		pctx->page_size_bits = -1;
+
+	pctx->pte_size = 1;
+	while (pctx->pte_size < sizeof(pt_entry) * 8 &&
+	       (pt_entry)1 << pctx->pte_size < pctx->dev_count)
+		pctx->pte_size++;
+
+	pctx->pte_fields = (sizeof(pt_entry) * 8) / pctx->pte_size;
+	if (!(pctx->pte_fields & (pctx->pte_fields - 1)))
+		pctx->pte_fields_bits = __ffs(pctx->pte_fields);
+	else
+		pctx->pte_fields_bits = -1;
+
+	dev_size = ti->len;
+	if (sector_div(dev_size, pctx->page_size))
+		dev_size++;
+
+	pctx->n_pages = dev_size;
+	if (pctx->n_pages != dev_size || pctx->n_pages >= ULONG_MAX) {
+		ti->error = "Too long page table";
+		r = -EINVAL;
+		goto error_kfree;
+	}
+
+	if (sector_div(dev_size, pctx->pte_fields))
+		dev_size++;
+
+	if (dev_size > ULONG_MAX / sizeof(pt_entry)) {
+		ti->error = "Too long page table";
+		r = -EINVAL;
+		goto error_kfree;
+	}
+
+	r = dm_set_target_max_io_len(ti, pctx->page_size);
+	if (r)
+		goto error_kfree;
+
+	pctx->page_table = vmalloc(dev_size * sizeof(pt_entry));
+	if (!pctx->page_table) {
+		ti->error = "Cannot allocate page table";
+		r = -ENOMEM;
+		goto error_kfree;
+	}
+
+	a = 0;
+	for (e = 0; e < pctx->n_pages; e++) {
+		switch_page_table_write(pctx, e, a);
+		a++;
+		if (a >= pctx->dev_count)
+			a = 0;
+	}
+
+	/*
+	 * Check each device beneath the target to ensure that the limits are
+	 * consistent.
+	 */
+	for (n = 0, a = 2; n < pctx->dev_count; n++, a += 2) {
+		struct dm_dev *dm;
+		sector_t dev_size;
+		unsigned long long start;
+
+		if (kstrtoull(argv[a + 1], 10, &start) ||
+		    start != (sector_t)start) {
+			ti->error = "Invalid device starting offset";
+			r = -EINVAL;
+			n--;
+			goto error_release_n;
+		}
+		r = dm_get_device
+		    (ti, argv[a], dm_table_get_mode(ti->table), &dm);
+		if (r) {
+			ti->error = "Device lookup failed";
+			n--;
+			goto error_release_n;
+		}
+		pctx->dev_list[n].dmdev = dm;
+		pctx->dev_list[n].start = start;
+
+		dev_size = i_size_read(dm->bdev->bd_inode) >> SECTOR_SHIFT;
+
+		if (ti->len > start + dev_size) {
+			ti->error = "Device is too small";
+			r = -EINVAL;
+			goto error_release_n;
+		}
+	}
+
+	ti->private = pctx;
+
+	return 0;
+
+error_release_n:		/* De-reference all devices  */
+	for (; n >= 0; n--)
+		dm_put_device(ti, pctx->dev_list[n].dmdev);
+
+	vfree(pctx->page_table);
+error_kfree:
+	kfree(pctx);
+
+error:
+	return r;
+}
+
+/*
+ * Destructor: Don't free the dm_target, just the ti->private data (if any).
+ */
+static void switch_dtr(struct dm_target *ti)
+{
+	int n;
+	struct switch_ctx *pctx = ti->private;
+
+	for (n = 0; n < pctx->dev_count; n++)
+		dm_put_device(ti, pctx->dev_list[n].dmdev);
+
+	vfree(pctx->page_table);
+	kfree(pctx);
+}
+
+static int switch_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context)
+{
+	struct switch_ctx *pctx = ti->private;
+
+	sector_t offset = bio->bi_sector - ti->begin;
+	sector_t p;
+	unsigned long index;
+	unsigned bit, idev;
+
+	p = offset;
+	if (pctx->page_size_bits >= 0)
+		p >>= pctx->page_size_bits;
+	else
+		sector_div(p, pctx->page_size);
+
+	switch_get_position(pctx, p, &index, &bit);
+
+	idev = (ACCESS_ONCE(pctx->page_table[index]) >> bit) & ((1 << pctx->pte_size) - 1);
+	/* This can only happen if the processor uses non-atomic stores. */
+	if (unlikely(idev >= pctx->dev_count))
+		idev = 0;
+
+	bio->bi_bdev = pctx->dev_list[idev].dmdev->bdev;
+	bio->bi_sector = pctx->dev_list[idev].start + offset;
+
+	return DM_MAPIO_REMAPPED;
+}
+
+/*
+ * We need to parse hex numbers as fast as possible.
+ * Message is used to load the whole table.
+ *
+ * This table-based hex parser improves performance.
+ * It improves a time to load 1000000 entries compared to the condition-based
+ * parser.
+ *		table-based parser	condition-based parser
+ * PA-RISC	0.29s			0.31s
+ * Opteron	0.0495s			0.0498s
+ */
+
+static const unsigned char hex_table[256] = {
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+0,1,2,3,4,5,6,7,8,9,255,255,255,255,255,255,
+255,10,11,12,13,14,15,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,10,11,12,13,14,15,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
+255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
+};
+
+static inline void parse_hex(const char *string, sector_t *result, const char **end)
+{
+	unsigned char d;
+	sector_t r = 0;
+#if 1
+	while ((d = hex_table[(unsigned char)*string]) < 16) {
+		r = (r << 4) | d;
+		string++;
+	}
+#else
+	while (1) {
+		d = *string;
+		if (d >= '0' && d <= '9')
+			d -= '0';
+		else if (d >= 'A' && d <= 'F')
+			d -= 'A' - 10;
+		else if (d >= 'a' && d <= 'f')
+			d -= 'a' - 10;
+		else
+			break;
+		r = (r << 4) | d;
+		string++;
+	}
+#endif
+	*end = string;
+	*result = r;
+}
+
+static int switch_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	static DEFINE_MUTEX(message_mutex);
+
+	struct switch_ctx *pctx = ti->private;
+	int r;
+
+	mutex_lock(&message_mutex);
+
+	if (!argc) {
+		goto invalid_message;
+	} else if (!strcasecmp(argv[0], "set-table")) {
+		unsigned i;
+		sector_t table_index = 0;
+		for (i = 1; i < argc; i++) {
+			sector_t device;
+			const char *string = argv[i];
+			if (*string == ':')
+				table_index++;
+			else {
+				parse_hex(string, &table_index, &string);
+				if (unlikely(*string != ':')) {
+invalid_table:
+					DMWARN("invalid set-table argument");
+					r = -EINVAL;
+					goto ret;
+				}
+			}
+			string++;
+			if (unlikely(!*string))
+				goto invalid_table;
+			parse_hex(string, &device, &string);
+			if (unlikely(*string))
+				goto invalid_table;
+			if (unlikely(table_index >= pctx->n_pages)) {
+				DMWARN("invalid set-table page");
+				r = -EINVAL;
+				goto ret;
+			}
+			if (unlikely(device >= pctx->dev_count)) {
+				DMWARN("invalid set-table device");
+				r = -EINVAL;
+				goto ret;
+			}
+			switch_page_table_write(pctx, table_index, device);
+		}
+		r = 0;
+	} else {
+invalid_message:
+		DMWARN("unrecognised message received.");
+		r = -EINVAL;
+	}
+ret:
+	mutex_unlock(&message_mutex);
+	return r;
+}
+
+static int switch_status(struct dm_target *ti, status_type_t type,
+			 unsigned status_flags, char *result, unsigned maxlen)
+{
+	struct switch_ctx *pctx = ti->private;
+	unsigned sz = 0;
+	int n;
+
+	result[0] = '\0';
+	switch (type) {
+	case STATUSTYPE_INFO:
+		result[0] = 0;
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%u %u", pctx->dev_count, pctx->page_size);
+		for (n = 0; n < pctx->dev_count; n++) {
+			DMEMIT(" %s %llu", pctx->dev_list[n].dmdev->name,
+			       (unsigned long long)pctx->dev_list[n].start);
+		}
+		break;
+
+	default:
+		return 0;
+	}
+	return 0;
+}
+
+/*
+ * Switch ioctl:
+ *
+ * Passthrough all ioctls to the first path.
+ */
+static int switch_ioctl(struct dm_target *ti, unsigned cmd,
+			unsigned long arg)
+{
+	struct switch_ctx *pctx = ti->private;
+	struct block_device *bdev;
+	fmode_t mode;
+
+	bdev = pctx->dev_list[0].dmdev->bdev;
+	mode = pctx->dev_list[0].dmdev->mode;
+
+	return __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+}
+
+static struct target_type switch_target = {
+	.name = "switch",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = switch_ctr,
+	.dtr = switch_dtr,
+	.map = switch_map,
+	.message = switch_message,
+	.status = switch_status,
+	.ioctl = switch_ioctl,
+};
+
+int __init dm_switch_init(void)
+{
+	int r;
+
+	r = dm_register_target(&switch_target);
+	if (r) {
+		DMERR("dm_register_target() failed %d", r);
+		return r;
+	}
+
+	return 0;
+}
+
+void dm_switch_exit(void)
+{
+	dm_unregister_target(&switch_target);
+}
+
+module_init(dm_switch_init);
+module_exit(dm_switch_exit);
+
+MODULE_DESCRIPTION(DM_NAME " fixed-size address-region-mapping throughput-oriented path selector");
+MODULE_AUTHOR("Kevin D. O'Kelley <Kevin_OKelley@dell.com>");
+MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
+MODULE_LICENSE("GPL");
