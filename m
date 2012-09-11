From: Jim Ramsay <jim_ramsay@dell.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Tue, 11 Sep 2012 09:14:46 -0400
Message-ID: <20120911131446.GB12315@freewill.lab.equallogic.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
	<20120821163329.GA21395@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208212026500.1653@file.rdu.redhat.com>
	<20120824181444.GC27819@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208292038560.17228@file.rdu.redhat.com>
	<20120907195851.GA30209@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1209081219070.13731@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209081219070.13731@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Jason_Shamberger@dell.com, agk@redhat.com, Kevin_OKelley@dell.com
List-Id: dm-devel.ids

On Sat, Sep 08, 2012 at 12:35:22PM -0400, Mikulas Patocka wrote:
> Another thing - please resend your code with "Signed-off-by". Read the 
> meaning of "Signed-off-by" in Documentation/SubmittingPatches, agree to 
> the terms and append "Signed-off-by: Jim Ramsay <jim_ramsay@dell.com>" to 
> the code. It is a legal requirement, so that you certify that the code is 
> under the open source license and that you have the right to distribute 
> the code.

I am attaching below an updated version of your 'dm-switch.c' file,
based on your latest post in
http://www.redhat.com/archives/dm-devel/2012-August/msg00224.html that
makes the following changes:

 1. Support for FLUSH and DISCARD operations by implementing
    target_type.iterate_devices and handling (bio->bi_rw & REQ_FLUSH) in
    switch_map.  Sends DISCARD to one path, FLUSH to each path.

 2. Send IOCTLs to the device who owns sector 0, instead of
    pctx->dev_list[0]

 3. Copyright notice update in header, plus adding myself to
    MODULE_AUTHOR

Signed-off-by: Jim Ramsay <jim_ramsay@dell.com>

------ dm-switch.c ------
/*
 * Copyright (c) 2010-2012 by Dell Inc.  All rights reserved.
 *
 * This file is released under the GPL.
 *
 * Description:
 *
 *     file:    dm-switch.c
 *     authors: Kevin_OKelley@dell.com
 *              Jim_Ramsay@dell.com
 *              Narendran_Ganapathy@dell.com
 *		mpatocka@redhat.com
 *
 * This file implements a "switch" target which efficiently implements a
 * mapping of IOs to underlying block devices in scenarios where there are:
 *   (1) a large number of address regions
 *   (2) a fixed size equal across all address regions
 *   (3) no pattern than allows for a compact description with something like
 *       the dm-stripe target.
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/device-mapper.h>
#include <linux/vmalloc.h>

#define DM_MSG_PREFIX "switch"

/*
 * Switch device context block: A new one is created for each dm device.
 * Contains an array of devices from which we have taken references.
 */
struct switch_dev {
	struct dm_dev *dmdev;
	sector_t start;
};

typedef unsigned long pt_entry;

/* Switch context header */
struct switch_ctx {
	unsigned dev_count;		/* Number of devices */
	unsigned page_size;		/* Page size in 512B sectors */
	unsigned long n_pages;		/* Number of pages */
	signed char page_size_bits;	/* log2 of page_size or -1 */

	unsigned char pte_size;		/* Page table entry size in bits */
	unsigned char pte_fields;	/* Number of entries per pt_entry */
	signed char pte_fields_bits;	/* log2 of pte_fields or -1 */
	pt_entry *page_table;		/* Page table */

	/* Array of dm devices to switch between */
	struct switch_dev dev_list[0];
};

static inline void switch_get_position(struct switch_ctx *pctx,
				       unsigned long page,
				       unsigned long *index,
				       unsigned *bit)

{
	if (pctx->pte_fields_bits >= 0) {
		*index = page >> pctx->pte_fields_bits;
		*bit = page & (pctx->pte_fields - 1);
	} else {
		*index = page / pctx->pte_fields;
		*bit = page % pctx->pte_fields;
	}
	*bit *= pctx->pte_size;

}

static inline unsigned switch_get_deviceidx(struct switch_ctx *pctx,
					    sector_t sector)
{
	unsigned long index;
	unsigned bit, idev;
	sector_t p;

	p = sector;
	if (pctx->page_size_bits >= 0)
		p >>= pctx->page_size_bits;
	else
		sector_div(p, pctx->page_size);

	switch_get_position(pctx, p, &index, &bit);
	idev = (ACCESS_ONCE(pctx->page_table[index]) >> bit) &
	       ((1 << pctx->pte_size) - 1);

	/* This can only happen if the processor uses non-atomic stores. */
	if (unlikely(idev >= pctx->dev_count))
		idev = 0;

	return idev;
}

static void switch_page_table_write(struct switch_ctx *pctx, unsigned long page,
				    unsigned value)
{
	unsigned long index;
	unsigned bit;
	pt_entry pte;

	switch_get_position(pctx, page, &index, &bit);

	pte = pctx->page_table[index];
	pte &= ~((((pt_entry)1 << pctx->pte_size) - 1) << bit);
	pte |= (pt_entry)value << bit;
	pctx->page_table[index] = pte;
}

/*
 * Constructor: Called each time a dmsetup command creates a dm device.  The
 * target parameter will already have the table, type, begin and len fields
 * filled in.  Arguments are in pairs: <dev_path> <offset>.  Therefore, we get
 * multiple constructor calls, but we will need to build a list of switch_ctx
 * blocks so that the page table information gets matched to the correct
 * device.
 */
static int switch_ctr(struct dm_target *ti, unsigned argc, char **argv)
{
	unsigned a;
	int n;
	int r;
	unsigned dev_count;
	struct switch_ctx *pctx;
	sector_t dev_size;
	unsigned long e;

	if (argc < 4) {
		ti->error = "Insufficient arguments";
		r = -EINVAL;
		goto error;
	}
	if (kstrtouint(argv[0], 10, &dev_count) ||
	    !dev_count ||
	    dev_count > (KMALLOC_MAX_SIZE - sizeof(struct switch_ctx)) / sizeof(struct switch_dev)) {
		ti->error = "Invalid device count";
		r = -EINVAL;
		goto error;
	}
	if (dev_count != (argc - 2) / 2) {
		ti->error = "Invalid argument count";
		r = -EINVAL;
		goto error;
	}
	pctx = kmalloc(sizeof(struct switch_ctx) + (dev_count * sizeof(struct switch_dev)),
		       GFP_KERNEL);
	if (!pctx) {
		ti->error = "Cannot allocate redirect context";
		r = -ENOMEM;
		goto error;
	}
	pctx->dev_count = dev_count;
	if (kstrtouint(argv[1], 10, &pctx->page_size) ||
	    !pctx->page_size) {
		ti->error = "Invalid page size";
		r = -EINVAL;
		goto error_kfree;
	}

	if (!(pctx->page_size & (pctx->page_size - 1)))
		pctx->page_size_bits = __ffs(pctx->page_size);
	else
		pctx->page_size_bits = -1;

	pctx->pte_size = 1;
	while (pctx->pte_size < sizeof(pt_entry) * 8 &&
	       (pt_entry)1 << pctx->pte_size < pctx->dev_count)
		pctx->pte_size++;

	pctx->pte_fields = (sizeof(pt_entry) * 8) / pctx->pte_size;
	if (!(pctx->pte_fields & (pctx->pte_fields - 1)))
		pctx->pte_fields_bits = __ffs(pctx->pte_fields);
	else
		pctx->pte_fields_bits = -1;

	dev_size = ti->len;
	if (sector_div(dev_size, pctx->page_size))
		dev_size++;

	pctx->n_pages = dev_size;
	if (pctx->n_pages != dev_size || pctx->n_pages >= ULONG_MAX) {
		ti->error = "Too long page table";
		r = -EINVAL;
		goto error_kfree;
	}

	if (sector_div(dev_size, pctx->pte_fields))
		dev_size++;

	if (dev_size > ULONG_MAX / sizeof(pt_entry)) {
		ti->error = "Too long page table";
		r = -EINVAL;
		goto error_kfree;
	}

	r = dm_set_target_max_io_len(ti, pctx->page_size);
	if (r)
		goto error_kfree;

	pctx->page_table = vmalloc(dev_size * sizeof(pt_entry));
	if (!pctx->page_table) {
		ti->error = "Cannot allocate page table";
		r = -ENOMEM;
		goto error_kfree;
	}

	a = 0;
	for (e = 0; e < pctx->n_pages; e++) {
		switch_page_table_write(pctx, e, a);
		a++;
		if (a >= pctx->dev_count)
			a = 0;
	}

	/*
	 * Check each device beneath the target to ensure that the limits are
	 * consistent.
	 */
	for (n = 0, a = 2; n < pctx->dev_count; n++, a += 2) {
		struct dm_dev *dm;
		sector_t dev_size;
		unsigned long long start;

		if (kstrtoull(argv[a + 1], 10, &start) ||
		    start != (sector_t)start) {
			ti->error = "Invalid device starting offset";
			r = -EINVAL;
			n--;
			goto error_release_n;
		}
		r = dm_get_device
		    (ti, argv[a], dm_table_get_mode(ti->table), &dm);
		if (r) {
			ti->error = "Device lookup failed";
			n--;
			goto error_release_n;
		}
		pctx->dev_list[n].dmdev = dm;
		pctx->dev_list[n].start = start;

		dev_size = i_size_read(dm->bdev->bd_inode) >> SECTOR_SHIFT;

		if (ti->len > start + dev_size) {
			ti->error = "Device is too small";
			r = -EINVAL;
			goto error_release_n;
		}
	}

	/* For UNMAP, sending the request down any path is sufficient */
	ti->num_discard_requests = 1;
	/* For FLUSH, we should flush each path */
	ti->num_flush_requests = pctx->dev_count;

	ti->private = pctx;

	return 0;

error_release_n:		/* De-reference all devices  */
	for (; n >= 0; n--)
		dm_put_device(ti, pctx->dev_list[n].dmdev);

	vfree(pctx->page_table);
error_kfree:
	kfree(pctx);

error:
	return r;
}

/*
 * Destructor: Don't free the dm_target, just the ti->private data (if any).
 */
static void switch_dtr(struct dm_target *ti)
{
	int n;
	struct switch_ctx *pctx = ti->private;

	for (n = 0; n < pctx->dev_count; n++)
		dm_put_device(ti, pctx->dev_list[n].dmdev);

	vfree(pctx->page_table);
	kfree(pctx);
}

static int switch_map(struct dm_target *ti, struct bio *bio,
		      union map_info *map_context)
{
	struct switch_ctx *pctx = ti->private;

	sector_t offset = bio->bi_sector - ti->begin;
	unsigned idev;

	if (bio->bi_rw & REQ_FLUSH) {
		int request_nr = map_context->target_request_nr;
		BUG_ON(request_nr >= pctx->dev_count);
		bio->bi_bdev = pctx->dev_list[request_nr].dmdev->bdev;
		return DM_MAPIO_REMAPPED;
	}

	idev = switch_get_deviceidx(pctx, offset);

	bio->bi_bdev = pctx->dev_list[idev].dmdev->bdev;
	bio->bi_sector = pctx->dev_list[idev].start + offset;

	return DM_MAPIO_REMAPPED;
}

/*
 * We need to parse hex numbers as fast as possible.
 * Message is used to load the whole table.
 *
 * This table-based hex parser improves performance.
 * It improves a time to load 1000000 entries compared to the condition-based
 * parser.
 *		table-based parser	condition-based parser
 * PA-RISC	0.29s			0.31s
 * Opteron	0.0495s			0.0498s
 */

static const unsigned char hex_table[256] = {
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
0,1,2,3,4,5,6,7,8,9,255,255,255,255,255,255,
255,10,11,12,13,14,15,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,10,11,12,13,14,15,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
};

static inline void parse_hex(const char *string, sector_t *result, const char **end)
{
	unsigned char d;
	sector_t r = 0;
#if 1
	while ((d = hex_table[(unsigned char)*string]) < 16) {
		r = (r << 4) | d;
		string++;
	}
#else
	while (1) {
		d = *string;
		if (d >= '0' && d <= '9')
			d -= '0';
		else if (d >= 'A' && d <= 'F')
			d -= 'A' - 10;
		else if (d >= 'a' && d <= 'f')
			d -= 'a' - 10;
		else
			break;
		r = (r << 4) | d;
		string++;
	}
#endif
	*end = string;
	*result = r;
}

static int switch_message(struct dm_target *ti, unsigned argc, char **argv)
{
	static DEFINE_MUTEX(message_mutex);

	struct switch_ctx *pctx = ti->private;
	int r;

	mutex_lock(&message_mutex);

	if (!argc) {
		goto invalid_message;
	} else if (!strcasecmp(argv[0], "set-table")) {
		unsigned i;
		sector_t table_index = 0;
		for (i = 1; i < argc; i++) {
			sector_t device;
			const char *string = argv[i];
			if (*string == ':')
				table_index++;
			else {
				parse_hex(string, &table_index, &string);
				if (unlikely(*string != ':')) {
invalid_table:
					DMWARN("invalid set-table argument");
					r = -EINVAL;
					goto ret;
				}
			}
			string++;
			if (unlikely(!*string))
				goto invalid_table;
			parse_hex(string, &device, &string);
			if (unlikely(*string))
				goto invalid_table;
			if (unlikely(table_index >= pctx->n_pages)) {
				DMWARN("invalid set-table page");
				r = -EINVAL;
				goto ret;
			}
			if (unlikely(device >= pctx->dev_count)) {
				DMWARN("invalid set-table device");
				r = -EINVAL;
				goto ret;
			}
			switch_page_table_write(pctx, table_index, device);
		}
		r = 0;
	} else {
invalid_message:
		DMWARN("unrecognised message received.");
		r = -EINVAL;
	}
ret:
	mutex_unlock(&message_mutex);
	return r;
}

static int switch_status(struct dm_target *ti, status_type_t type,
			 unsigned status_flags, char *result, unsigned maxlen)
{
	struct switch_ctx *pctx = ti->private;
	unsigned sz = 0;
	int n;

	result[0] = '\0';
	switch (type) {
	case STATUSTYPE_INFO:
		result[0] = 0;
		break;

	case STATUSTYPE_TABLE:
		DMEMIT("%u %u", pctx->dev_count, pctx->page_size);
		for (n = 0; n < pctx->dev_count; n++) {
			DMEMIT(" %s %llu", pctx->dev_list[n].dmdev->name,
			       (unsigned long long)pctx->dev_list[n].start);
		}
		break;

	default:
		return 0;
	}
	return 0;
}

/*
 * Switch ioctl:
 *
 * Passthrough all ioctls to the path for sector 0
 */
static int switch_ioctl(struct dm_target *ti, unsigned cmd,
			unsigned long arg)
{
	struct switch_ctx *pctx = ti->private;
	struct block_device *bdev;
	fmode_t mode;
	unsigned idev;

	idev = switch_get_deviceidx(pctx, 0);

	bdev = pctx->dev_list[idev].dmdev->bdev;
	mode = pctx->dev_list[idev].dmdev->mode;

	return __blkdev_driver_ioctl(bdev, mode, cmd, arg);
}

static int switch_iterate_devices(struct dm_target *ti,
				  iterate_devices_callout_fn fn, void *data)
{
	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
	int n, ret = 0;

	for (n = 0; n < pctx->dev_count; n++) {
		ret = fn(ti, pctx->dev_list[n].dmdev, ti->begin, ti->len, data);
		if (ret)
			goto out;
	}

out:
	return ret;
}

static struct target_type switch_target = {
	.name = "switch",
	.version = {1, 0, 0},
	.module = THIS_MODULE,
	.ctr = switch_ctr,
	.dtr = switch_dtr,
	.map = switch_map,
	.message = switch_message,
	.status = switch_status,
	.ioctl = switch_ioctl,
	.iterate_devices = switch_iterate_devices,
};

int __init dm_switch_init(void)
{
	int r;

	r = dm_register_target(&switch_target);
	if (r) {
		DMERR("dm_register_target() failed %d", r);
		return r;
	}

	return 0;
}

void dm_switch_exit(void)
{
	dm_unregister_target(&switch_target);
}

module_init(dm_switch_init);
module_exit(dm_switch_exit);

MODULE_DESCRIPTION(DM_NAME " fixed-size address-region-mapping throughput-oriented path selector");
MODULE_AUTHOR("Kevin D. O'Kelley <Kevin_OKelley@dell.com>");
MODULE_AUTHOR("Jim Ramsay <Jim_Ramsay@dell.com>");
MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
MODULE_LICENSE("GPL");
-------------------------

-- 
Jim Ramsay

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
-- 
Jim Ramsay
