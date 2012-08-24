From: Jim Ramsay <jim_ramsay@dell.com>
Subject: RFC: dm-switch target [v4]
Date: Fri, 24 Aug 2012 13:16:51 -0400
Message-ID: <20120824171650.GA27819@freewill.lab.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patock <mpatocka@redhat.com>, "Shamberger,
	Jason" <Jason_Shamberger@dell.com>, Alasdair G Kergon <agk@redhat.com>, "OKelley,
	Kevin" <Kevin_OKelley@dell.com>
List-Id: dm-devel.ids

Note: This is a repost with a few important implementation improvements.  The
first 3 versions were posted as follows:
  http://www.redhat.com/archives/dm-devel/2011-October/msg00109.html
  http://www.redhat.com/archives/dm-devel/2011-August/msg00146.html
  http://www.redhat.com/archives/dm-devel/2011-March/msg00131.html

Changes from the latest 'v3' version:

- Implements 'discard' support (needed for UNMAP support)
- Implements device 'flush' support
- Version number is now "1.1.0", was "1.0"
- Removed arbitrary page table size limit
- Allocate the page table data structures on the heap to avoid stack overflow
  warnings on some platforms
- Internal reorganization and cleanup
- Minor corner-case bug fixes

And with apologies to Mikulas and Alasdair, this intentionally does not
represent our recent discussions on changing the memory allocation method to
vmalloc or change the message format to use dm message instead of netlink -
This is simply a posting of our current code to be used as a basis of
comparison against that discussion.

(That discussion begins here: http://www.redhat.com/archives/dm-devel/2012-August/msg00144.html)

I will be posting a sample userland application that demonstrates how to upload
a page table via the netlink interface in a later message.

--- dm-switch.h ---
/*
 * Copyright (c) 2010-2012 by Dell Inc.  All rights reserved.
 *
 * This file is released under the GPL.
 *
 * Description:
 *
 *     file:    dm-switch.h
 *     authors: Kevin_OKelley@dell.com
 *              Jim_Ramsay@dell.com
 *              Narendran_Ganapathy@dell.com
 *
 * This file contains the netlink message definitions for the "switch" target.
 *
 * The only defined message at this time is for uploading the mapping page
 * table.
 */

#ifndef __DM_SWITCH_H
#define __DM_SWITCH_H

/* 
 * Module version numbers, reported by 'dmsetup targets' and
 * /sys/module/dm_switch/version.
 *
 * The first two (MAJ.MIN) define the communication protocol between userland
 * and kernel.  The third (REV) is for minor revisions that do not affect
 * userland<->kernel communication.
 *
 * SWITCH_VERSION_MAJ -> Bump only for major rewrites
 * SWITCH_VERSION_MIN -> Bump if the userland-to-kernel netlink interface or DM
 *                       table syntax changes in an incompatible way.
 * SWITCH_VERSION_REV -> Bump for any other (communication-compatible) changes
 */
#define SWITCH_VERSION_MAJ 1
#define SWITCH_VERSION_MIN 1
#define SWITCH_VERSION_REV 0

/*
 * By dividing the page table into chunks, we avoid having to do the allocation
 * in one huge contiguous chunk at the minor cost of a 2-stage lookup.
 *
 * Using 1<<13 (0x2000) means that the size in KB that will be allocated for
 * each chunk is reasonably small:
 *   0x2000 * 1bit/PTE = 1KB
 *   0x2000 * 4bit/PTE = 4KB
 */
#define CHUNK_PTE_SHIFT (13)

/* Number of Page Table Entries per chunk */
#define CHUNK_PTE_COUNT  (1LL << CHUNK_PTE_SHIFT)

/* An arbitrary limit which should allow for devices with up to 2097152 pages */
#define MAX_NUMBER_OF_CHUNKS 256

#define MAX_IPC_MSG_LEN 65480	/* dictated by netlink socket */
#define MAX_ERR_STR_LEN 255	/* maximum length of the error string */

enum Opcode {
	OPCODE_PAGE_TABLE_UPLOAD = 1,
};

/*
 * IPC Page Table message
 *
 * ptbl_buff must be sent in full 32-bit words, bit-packed for fast lookup
 * with the least significant fields in the low-order bytes.
 *
 * If the entire page table cannot be sent in a single netlink message, this
 * message may be sent in multiple windows provided that the page_total,
 * dev_count, and pte_bits do not change.
 *
 * As a special case, if page_count is 0 and page_offset is chunk-aligned (ie,
 * and even multiple of CHUNK_PTE_COUNT), the chunk will be deallocated.
 */
struct IpcPgTable {
	uint32_t total_len;	/* Total length of this IPC message */
	enum Opcode opcode;
	uint32_t userland[2];	/* Userland optional data (dmsetup status) */
	uint32_t dev_major;	/* DM device major */
	uint32_t dev_minor;	/* DM device minor */
	uint32_t page_total;	/* Total pages in the volume */
	uint32_t page_offset;	/* Starting page offset for this IPC */
	uint32_t page_count;	/* Number of page table entries in this IPC */
	uint16_t dev_count;	/* Number of devices */
	uint8_t pte_bits;	/* Page Table Entry field size in bits */
	uint8_t reserved;	/* Integer alignment  */
	uint32_t ptbl_buff[1];	/* Page table entries (variable length) */
};

/*
 * IPC Response message
 */
struct IpcResponse {
	uint32_t total_len;	/* total length of the IPC */
	enum Opcode opcode;
	uint32_t userland[2];	/* Userland optional data */
	uint32_t dev_major;	/* DM device major */
	uint32_t dev_minor;	/* DM device minor */
	uint32_t status;	/* 0 on success; errno on failure */
	char err_str[MAX_ERR_STR_LEN + 1];
	/* If status != 0, contains an informative error message */
};

/* Generic Netlink family attributes: used to define the family */
enum {
	NETLINK_ATTR_UNSPEC,
	NETLINK_ATTR_MSG,
	NETLINK_ATTR__MAX,
};
#define NETLINK_ATTR_MAX (NETLINK_ATTR__MAX - 1)

/* Netlink commands (operations) */
enum {
	NETLINK_CMD_UNSPEC,
	NETLINK_CMD_GET_PAGE_TBL,
	NETLINK_CMD__MAX,
};
#define NETLINK_CMD_MAX (NETLINK_CMD__MAX - 1)

#endif /* __DM_SWITCH_H */

--- dm-switch.c ---
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
#include <linux/blkdev.h>
#include <linux/bio.h>
#include <linux/slab.h>
#include <linux/device.h>
#include <linux/version.h>
#include <linux/dm-ioctl.h>
#include <linux/device-mapper.h>
#include <linux/mutex.h>
#include <net/genetlink.h>
#include <asm/div64.h>

#include "dm-switch.h"
#define DM_MSG_PREFIX "switch"
MODULE_DESCRIPTION(DM_NAME
		   " fixed-size address-region-mapping throughput-oriented path selector");
MODULE_AUTHOR("Kevin D. O'Kelley <Kevin_OKelley@dell.com>");
MODULE_LICENSE("GPL");

#define DEBUG
#if defined(DEBUG) || defined(_DEBUG)
#define DBGPRINT(args...)  printk(KERN_DEBUG args)
#else
#define DBGPRINT(args...)
#endif

#undef DEBUGVERBOSE
#if defined(DEBUGVERBOSE)
#define DBGPRINTV(args...)  printk(KERN_DEBUG args)
#undef DEBUG_HEXDUMP
#else
#define DBGPRINTV(args...)
#undef DEBUG_HEXDUMP
#endif

/* Chunk operations */
#define CHUNK_PTE_IDX(entry) ((entry) >> CHUNK_PTE_SHIFT)
#define CHUNK_PTE_REM(entry) ((entry) & (CHUNK_PTE_COUNT - 1))

/*
 * Switch device context block: A new one is created for each dm device.
 * Contains an array of devices from which we have taken references.
 */
struct switch_dev {
	struct dm_dev *dmdev;
	sector_t start;
	atomic_t error_count;
};

/* Switch page table chunk */
struct ptbl_chunk {
	uint32_t ptbl_num;	/* Page table size in entries */
	uint64_t ios_mapped;	/* Number of IOs mapped into this chunk */
	uint32_t *ptbl_buff;	/* page to device map (bit-packed array) */
};

/* Switch page table block */
struct switch_ptbl {
	uint32_t pte_bits;	/* Page Table Entry field size in bits */
	uint32_t pte_mask;	/* Page Table Entry field mask */
	uint32_t pte_fields;	/* Number of Page Table Entries per uint32_t */
	uint32_t ptbl_max;	/* Page table maximum size in entries */
	uint32_t num_chunks;	/* Number of Page Table Chunks */
	struct ptbl_chunk chunk[0];	/* Page Table Chunk headers */
};

/* Switch context header */
struct switch_ctx {
	struct list_head list;
	dev_t dev_this;		/* Device serviced by this target */
	uint32_t dev_count;	/* Number of devices */
	uint32_t page_size;	/* Page size in 512B sectors */
	uint32_t userland[2];	/* Userland optional data (dmsetup status) */
	uint64_t ios_remapped;	/* I/Os remapped */
	uint64_t ios_unmapped;	/* I/Os not remapped */
	spinlock_t spinlock;	/* Control access to counters */

	struct switch_ptbl *ptbl;	/* Page table (if loaded) */
	struct switch_dev dev_list[0];
	/* Array of dm devices to switch between */
};

/*
 * Global variables
 */
static LIST_HEAD(__g_context_list);	/* Linked list of context blocks */
static DEFINE_MUTEX(__g_context_lock);	/* Control access to __g_context_list */

/*
 * Allocate a switch_ptbl structure for the number of chunks given Zeros all
 * fields except for num_chunks which is set to the number of chunks allocated.
 */
static struct switch_ptbl *ptbl_alloc(size_t num_chunks, gfp_t flags)
{
	size_t size = offsetof(struct switch_ptbl, chunk) +
	    (sizeof(struct ptbl_chunk) * num_chunks);
	struct switch_ptbl *pnew = kzalloc(size, flags);
	if (pnew)
		pnew->num_chunks = num_chunks;
	return pnew;
}

/*
 * Free a switch_ptbl structure and any chunk buffers still attached to it.
 *
 * Also calls synchronize_rcu() if either ptbl or one of the chunk buffers
 * therein is freed, and returns 1 if synchronize_rcu() was called.
 */
static bool ptbl_free_sync_rcu(struct switch_ptbl *ptbl)
{
	bool did_sync_rcu = 0;
	if (ptbl) {
		size_t i;
		uint32_t *ptbl_free_list[MAX_NUMBER_OF_CHUNKS];
		unsigned ptbl_free_count = 0;
		for (i = 0; i < ptbl->num_chunks; ++i) {
			if (ptbl->chunk[i].ptbl_buff)
				ptbl_free_list[ptbl_free_count++] =
				    ptbl->chunk[i].ptbl_buff;
			rcu_assign_pointer(ptbl->chunk[i].ptbl_buff, NULL);
		}

		did_sync_rcu = 1;
		synchronize_rcu();
		if (ptbl_free_count > 0) {
			for (i = 0; i < ptbl_free_count; ++i)
				kfree(ptbl_free_list[i]);
		}
		kfree(ptbl);
	}
	return did_sync_rcu;
}

/* Limit check for the switch constructor */
static int switch_ctr_limits(struct dm_target *ti, struct dm_dev *dm)
{
	struct block_device *sd = dm->bdev;
	struct hd_struct *hd = sd->bd_part;
	if (hd != NULL) {
		DBGPRINT("%s sd=0x%p (%d:%d), hd=0x%p, start=%llu, "
			 "size=%llu\n", __func__, sd, MAJOR(sd->bd_dev),
			 MINOR(sd->bd_dev), hd,
			 (unsigned long long)hd->start_sect,
			 (unsigned long long)hd->nr_sects);
		if (ti->len <= hd->nr_sects)
			return true;
		ti->error = "Device too small for target";
		return false;
	}
	ti->error = "Missing device limits";
	printk(KERN_WARNING "%s %s\n", __func__, ti->error);
	return true;
}

/*
 * Constructor: Called each time a dmsetup command creates a dm device.  The
 * target parameter will already have the table, type, begin and len fields
 * filled in.  Arguments are in pairs: <dev_path> <offset>.  Therefore, we get
 * multiple constructor calls, but we will need to build a list of switch_ctx
 * blocks so that the page table information gets matched to the correct
 * device.
 */
static int switch_ctr(struct dm_target *ti, unsigned int argc, char **argv)
{
	int n;
	uint32_t dev_count;
	unsigned long major, minor;
	unsigned long long start;
	struct switch_ctx *pctx;
	struct mapped_device *md = NULL;
	struct dm_dev *dm;
	const char *dm_devname;

	DBGPRINTV("%s\n", __func__);
	if (argc < 4) {
		ti->error = "Insufficient arguments";
		return -EINVAL;
	}
	if (kstrtou32(argv[0], 10, &dev_count) != 0) {
		ti->error = "Invalid device count";
		return -EINVAL;
	}
	if (dev_count != (argc - 2) / 2) {
		ti->error = "Invalid argument count";
		return -EINVAL;
	}
	pctx = kzalloc(sizeof(*pctx) + (dev_count * sizeof(struct switch_dev)),
		       GFP_KERNEL);
	if (pctx == NULL) {
		ti->error = "Cannot allocate redirect context";
		return -ENOMEM;
	}
	pctx->dev_count = dev_count;
	if ((kstrtou32(argv[1], 10, &pctx->page_size) != 0) ||
	    (pctx->page_size == 0)) {
		ti->error = "Invalid page size";
		goto failed_kfree;
	}
	spin_lock_init(&pctx->spinlock);

	/*
	 * Find the device major and minor for the device that is being served
	 * by this target.
	 */
	md = dm_table_get_md(ti->table);
	if (md == NULL) {
		ti->error = "Cannot locate dm device";
		goto failed_kfree;
	}
	dm_devname = dm_device_name(md);
	if (dm_devname == NULL) {
		ti->error = "Cannot acquire dm device name";
		goto failed_kfree;
	}
	if (sscanf(dm_devname, "%lu:%lu", &major, &minor) != 2) {
		ti->error = "Invalid dm device name";
		goto failed_kfree;
	}
	pctx->dev_this = MKDEV(major, minor);
	DBGPRINT("%s ctx=0x%p (%d:%d): type=\"%s\", count=%d, "
		 "start=%llu, size=%llu\n",
		 __func__, pctx, MAJOR(pctx->dev_this),
		 MINOR(pctx->dev_this), ti->type->name, pctx->dev_count,
		 (unsigned long long)ti->begin, (unsigned long long)ti->len);

	/*
	 * Check each device beneath the target to ensure that the limits are
	 * consistent.
	 */
	for (n = 0, argc = 2; n < pctx->dev_count; n++, argc += 2) {
		DBGPRINTV("%s #%d 0x%p, %s, %s\n", __func__, n,
			  &pctx->dev_list[n], argv[argc], argv[argc + 1]);
		if (sscanf(argv[argc + 1], "%llu", &start) != 1) {
			ti->error = "Invalid device starting offset";
			goto failed_dev_list_prev;
		}
		if (dm_get_device
		    (ti, argv[argc], dm_table_get_mode(ti->table), &dm)) {
			ti->error = "Device lookup failed";
			goto failed_dev_list_prev;
		}
		pctx->dev_list[n].dmdev = dm;
		pctx->dev_list[n].start = start;
		atomic_set(&(pctx->dev_list[n].error_count), 0);
		if (!switch_ctr_limits(ti, dm))
			goto failed_dev_list_all;
	}
	/* For UNMAP, sending the request down any path is sufficient */
	ti->num_discard_requests = 1;
	/* For FLUSH, we should flush each path */
	ti->num_flush_requests = pctx->dev_count;
	mutex_lock(&__g_context_lock);
	list_add_tail(&pctx->list, &__g_context_list);
	mutex_unlock(&__g_context_lock);
	ti->private = pctx;
	return 0;

failed_dev_list_prev:		/* De-reference previous devices */
	n--;			/*   (i.e. don't include this one) */

failed_dev_list_all:		/* De-reference all devices  */
	printk(KERN_WARNING "%s device=%s, start=%s\n", __func__,
	       argv[argc], argv[argc + 1]);
	for (; n >= 0; n--)
		dm_put_device(ti, pctx->dev_list[n].dmdev);

failed_kfree:
	printk(KERN_WARNING "%s %s\n", __func__, ti->error);
	kfree(pctx);
	return -EINVAL;
}

/*
 * Destructor: Don't free the dm_target, just the ti->private data (if any).
 */
static void switch_dtr(struct dm_target *ti)
{
	int n;
	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
	void *ptbl;

	DBGPRINT("%s ctx=0x%p (%d:%d)\n", __func__, pctx,
		 MAJOR(pctx->dev_this), MINOR(pctx->dev_this));
	mutex_lock(&__g_context_lock);
	ptbl = pctx->ptbl;
	rcu_assign_pointer(pctx->ptbl, NULL);
	list_del(&pctx->list);
	mutex_unlock(&__g_context_lock);
	for (n = 0; n < pctx->dev_count; n++) {
		DBGPRINTV("%s dm_put_device(%s)\n", __func__,
			  pctx->dev_list[n].dmdev->name);
		dm_put_device(ti, pctx->dev_list[n].dmdev);
	}
	ptbl_free_sync_rcu(ptbl);
	kfree(pctx);
}

static int switch_map_sector(struct switch_ctx *pctx, sector_t sector,
			     uint32_t * devidx)
{
	struct switch_ptbl *ptbl;
	struct ptbl_chunk *pchunk = NULL;
	uint32_t *ptbl_buff;
	uint64_t ichunk, itbl;
	uint32_t idev = 0, irem;
	int result = ENOENT;

	BUG_ON(pctx == NULL || devidx == NULL);

	rcu_read_lock();
	ptbl = rcu_dereference(pctx->ptbl);
	if (ptbl == NULL) {
		/* No table allocated */
		goto unlock;
	}

	/*
	 * Convert the offset (in sectors) to the page table offset
	 * (based on page_size, which is not guaranteed to be a power-of-2)
	 *
	 * NOTE: If CONFIG_LBD is disabled, sector_t types are uint32_t.  Therefore, in
	 * this routine, we use uint64_t instead of sector_t so that all of the
	 * remaining arithmetic is correct, including the do_div() calls.
	 */
	itbl = sector;
	do_div(itbl, pctx->page_size);
	DBGPRINTV("%s sector:0x%llx pteidx:0x%llx\n", __func__,
		  (uint64_t) sector, itbl);
	/* Lookup 1: The Chunk Index */
	ichunk = CHUNK_PTE_IDX(itbl);
	if (ichunk > ptbl->num_chunks) {
		printk(KERN_WARNING "%s WARNING: Page Table Chunk "
		       "%lld >= %d\n", __func__, ichunk, ptbl->num_chunks);
		goto unlock;
	}
	pchunk = &(ptbl->chunk[ichunk]);

	/*
	 * Increment the hit counter for this chunk, regardless of whether or
	 * not the associated page table buffer is allocated.
	 */
	spin_lock(&pctx->spinlock);
	pchunk->ios_mapped++;
	spin_unlock(&pctx->spinlock);

	ptbl_buff = rcu_dereference(pchunk->ptbl_buff);
	DBGPRINTV("%s chunk:0x%llx buffer:0x%p\n", __func__, ichunk, ptbl_buff);

	if (ptbl_buff == NULL) {
		/*
		 * No page table allocated for this chunk.  This is not an
		 * error - the table may be sparsely populated.
		 */
		goto unlock;
	}

	/* Lookup 2: The remainder is the offset within the chunk */
	itbl = CHUNK_PTE_REM(itbl);
	if (unlikely(itbl >= pchunk->ptbl_num)) {
		printk(KERN_WARNING "%s WARNING: Page Table Entry "
		       "%lld >= %d\n", __func__, itbl, pchunk->ptbl_num);
		goto unlock;
	}

	irem = do_div(itbl, ptbl->pte_fields);
	idev = (ptbl_buff[itbl] >> (irem * ptbl->pte_bits))
	    & ptbl->pte_mask;
	DBGPRINTV("%s bufidx:0x%0llx irem:0x%0x bits:%d idev:0x%0x\n",
		  __func__, itbl, irem, ptbl->pte_bits, idev);
#ifdef DEBUG_HEXDUMP
	DBGPRINTV("   0x%08x\n", ptbl_buff[itbl]);
	DBGPRINTV(" & 0x%08x\n", (ptbl->pte_mask << (irem * ptbl->pte_bits)));
	DBGPRINTV(" -------------\n");
	DBGPRINTV("   0x%08x -> 0x%02x\n",
		  ptbl_buff[itbl] & (ptbl->pte_mask << (irem * ptbl->pte_bits)),
		  idev);
#endif
	if (likely(idev < pctx->dev_count)) {
		/* Device is in range: This IO has been successfully remapped */
		result = 0;
	} else {
		printk(KERN_WARNING "%s WARNING: dev=%d, "
		       "sector=%lld\n", __func__, idev, (uint64_t) sector);
		idev = 0;
		result = ENOENT;
	}

unlock:
	rcu_read_unlock();
	*devidx = idev;
	return result;
}

static int switch_map(struct dm_target *ti, struct bio *bio,
		      union map_info *map_context)
{
	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
	sector_t offset = bio->bi_sector - ti->begin;
	uint32_t idev;
	int result;
	if (bio->bi_rw & REQ_FLUSH) {
		/* Send the flush request down each path */
		int request_nr = map_context->target_request_nr;
		BUG_ON(request_nr >= pctx->dev_count);
		bio->bi_bdev = pctx->dev_list[request_nr].dmdev->bdev;
		DBGPRINTV("%s REQ_FLUSH %d", __func__, request_nr);
		return DM_MAPIO_REMAPPED;
	}
	/* Map the sector to the device index */
	result = switch_map_sector(pctx, offset, &idev);

	/* Increment counters */
	spin_lock(&pctx->spinlock);
	if (likely(result == 0))
		pctx->ios_remapped++;
	else
		pctx->ios_unmapped++;
	spin_unlock(&pctx->spinlock);

	/* Remap the IO */
	bio->bi_bdev = pctx->dev_list[idev].dmdev->bdev;
	bio->bi_sector = pctx->dev_list[idev].start + offset;
	return DM_MAPIO_REMAPPED;
}

/*
 * Switch status:
 *
 * INFO: #dev_count device [device] 5 'A'['A' ...] userland[0] userland[1]
 *       #remapped #unmapped
 *
 * where:
 *   "'A'['A']" is a single word with an 'A' (active) or 'D' for each device
 *   The userland values are set by the last userland message to load the page
 *   table
 *   "#remapped" is the number of remapped I/Os
 *   "#unmapped" is the number of I/Os that could not be remapped
 *
 * TABLE: #page_size #dev_count device start [device start ...]
 */
static int switch_status(struct dm_target *ti, status_type_t type, char
			 *result, unsigned int maxlen)
{
	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
	char buffer[pctx->dev_count + 1];
	unsigned int sz = 0;
	int n;
	uint64_t remapped, unmapped;

	result[0] = '\0';
	switch (type) {
	case STATUSTYPE_INFO:
		DMEMIT("%d", pctx->dev_count);
		for (n = 0; n < pctx->dev_count; n++) {
			DMEMIT(" %s", pctx->dev_list[n].dmdev->name);
			buffer[n] = 'A';
		}
		buffer[n] = '\0';
		spin_lock(&pctx->spinlock);
		remapped = pctx->ios_remapped;
		unmapped = pctx->ios_unmapped;
		spin_unlock(&pctx->spinlock);
		DMEMIT(" 5 %s %08x %08x %lld %lld", buffer, pctx->userland[0],
		       pctx->userland[1], remapped, unmapped);
		break;

	case STATUSTYPE_TABLE:
		DMEMIT("%d %d", pctx->dev_count, pctx->page_size);
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
 * Passthrough all ioctls to the first path.
 */
static int switch_ioctl(struct dm_target *ti, unsigned int cmd,
			unsigned long arg)
{
	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
	struct block_device *bdev;
	fmode_t mode = 0;

	/* Sanity check */
	if (unlikely(!pctx || !pctx->dev_list[0].dmdev ||
		     !pctx->dev_list[0].dmdev->bdev))
		return -EIO;

	bdev = pctx->dev_list[0].dmdev->bdev;
	mode = pctx->dev_list[0].dmdev->mode;
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

static struct target_type __g_switch_target = {
	.name = "switch",
	.version = {SWITCH_VERSION_MAJ, SWITCH_VERSION_MIN, SWITCH_VERSION_REV},
	.module = THIS_MODULE,
	.ctr = switch_ctr,
	.dtr = switch_dtr,
	.map = switch_map,
	.status = switch_status,
	.iterate_devices = switch_iterate_devices,
	.ioctl = switch_ioctl,
};

/* Generic Netlink attribute policy (single attribute, NETLINK_ATTR_MSG) */
static struct nla_policy __g_attr_policy[NETLINK_ATTR_MAX + 1] = {
	[NETLINK_ATTR_MSG] = {.type = NLA_BINARY,.len = MAX_IPC_MSG_LEN},
};

/* Define the Generic Netlink family */
static struct genl_family __g_family = {
	.id = GENL_ID_GENERATE,	/* Assign channel when family is registered */
	.hdrsize = 0,
	.name = "DM_SWITCH",
	.version = 1,
	.maxattr = NETLINK_ATTR_MAX,
};

#ifdef DEBUG_HEXDUMP
#define DEBUG_HEXDUMP_WORDS 8
#define DEBUG_HEXDUMP_BYTES (DEBUG_HEXDUMP_WORDS * sizeof(uint32_t))

static inline void debug_hexdump_line(void *ibuff, size_t offset, size_t isize,
				      const char *func)
{
	static const char *hex = "0123456789abcdef";
	unsigned char *iptr = &((unsigned char *)ibuff)[offset];
	char *optr, obuff[DEBUG_HEXDUMP_BYTES * 3];
	int osize;

	while (isize > 0) {
		optr = obuff;
		for (osize = 0; osize < DEBUG_HEXDUMP_BYTES; osize++) {
			if (((osize & 3) == 0) && (osize != 0))
				*optr++ = ' ';
			*optr++ = hex[(*iptr) >> 4];
			*optr++ = hex[(*iptr++) & 15];
			if (--isize <= 0)
				break;
		}
		*optr = '\0';
		DBGPRINT("%s %04x %s\n", func, (unsigned int)offset, obuff);
		offset += DEBUG_HEXDUMP_BYTES;
	}
}

static inline void debug_hexdump(void *ibuff, size_t isize, const char *func)
{
	size_t iline = isize / DEBUG_HEXDUMP_BYTES;
	size_t irem = isize % DEBUG_HEXDUMP_BYTES;
	size_t offset = isize;

	if (iline < 6) {
		debug_hexdump_line(ibuff, 0, isize, func);
		return;
	}
	debug_hexdump_line(ibuff, 0, (3 * DEBUG_HEXDUMP_BYTES), func);
	isize = (irem == 0) ? (3 * DEBUG_HEXDUMP_BYTES)
	    : ((2 * DEBUG_HEXDUMP_BYTES) + irem);
	offset -= isize;
	debug_hexdump_line(ibuff, offset, isize, func);
}
#else
static inline void debug_hexdump(void *ibuff, size_t isize, const char *func)
{
}
#endif

/*
 * Calculate the number of bytes needed to house the given number of page table
 * entries, rounded up to the next full word
 */
static inline size_t pte_size(unsigned count, unsigned pte_fields)
{
	return ((count + pte_fields - 1) / pte_fields) * sizeof(uint32_t);
}

/*
 * Generic Netlink socket read function that handles communication from the
 * userland for downloading the page table.
 */
static int get_page_tbl(struct sk_buff *skb_2, struct genl_info *info)
{
	uint32_t rc, pte_mask, pte_fields;
	uint32_t status = 0;
	char *mydata;
	void *msg_head;
	struct nlattr *na;
	struct sk_buff *skb;
	struct switch_ctx *pctx = NULL, *next;
	struct switch_ptbl *ptbl, *pnew, *ptbl_to_free = NULL;
	struct ptbl_chunk *chunk;
	size_t msg_pte_size, total_pte_size, num_chunks, src_pte_offset,
	    chunk_pte_size;
	struct IpcPgTable *pgp;
	struct IpcResponse resp;
	dev_t dev;
	static const char *invmsg = "Invalid Page Table message";
	bool ptbl_realloc_needed;
	unsigned pbuff_list_to_free = 0;
	uint32_t **pbuff_free_list;

	/*
	 * For each attribute there is an index in info->attrs which points to
	 * a nlattr structure in this structure the data is given
	 */
	if (info == NULL) {
		printk(KERN_WARNING "%s missing genl_info parameter\n",
		       __func__);
		return 0;
	}
	na = info->attrs[NETLINK_ATTR_MSG];
	if (na == NULL) {
		printk(KERN_WARNING "%s no info->attrs %i\n", __func__,
		       NETLINK_ATTR_MSG);
		return 0;
	}
	mydata = (char *)nla_data(na);
	if (mydata == NULL) {
		printk(KERN_WARNING "%s error while receiving data\n",
		       __func__);
		return 0;
	}
	DBGPRINTV("%s seq=%d, pid=%d, type=%d, flags=0x%x, data=0x%p "
		  "(0x%x, %d)\n",
		  __func__, info->snd_seq, info->snd_pid,
		  info->nlhdr->nlmsg_type, info->nlhdr->nlmsg_flags,
		  mydata, na->nla_len, na->nla_len);
	debug_hexdump(mydata,
		      ((offsetof(struct IpcPgTable, ptbl_buff)<na->nla_len)
		       ? offsetof(struct IpcPgTable, ptbl_buff)
		       : na->nla_len), __func__);

	/*
	 * Format the reply message.  Return positve error codes to userland.
	 */
	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
	if (skb == NULL) {
		printk(KERN_WARNING "%s cannot allocate reply message\n",
		       __func__);
		return 0;
	}
	msg_head = genlmsg_put(skb, 0, info->snd_seq, &__g_family, 0,
			       NETLINK_CMD_GET_PAGE_TBL);
	if (skb == NULL) {
		printk(KERN_WARNING "%s cannot format reply message header\n",
		       __func__);
		return 0;
	}
	pgp = (struct IpcPgTable *)mydata;
	pbuff_free_list =
	    kmalloc(MAX_NUMBER_OF_CHUNKS * sizeof(uint32_t *), GFP_KERNEL);
	if (pbuff_free_list == NULL) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "%s: Could not allocate enough in-kernel memory",
			 invmsg);
		status = ENOMEM;
		goto failed_respond;
	}

	if (na->nla_len < sizeof(struct IpcPgTable)) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "%s: too short (%d)", invmsg, na->nla_len);
		status = EINVAL;
		goto failed_respond;
	}
	if ((pgp->page_offset + pgp->page_count) > pgp->page_total) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "%s: too many page table entries (%d > %d)",
			 invmsg, (pgp->page_offset + pgp->page_count),
			 pgp->page_total);
		status = EINVAL;
		goto failed_respond;
	}
	pte_mask = (1 << pgp->pte_bits) - 1;
	if (((pgp->dev_count - 1) & (~pte_mask)) != 0) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "%s: invalid mask 0x%x for %d devices",
			 invmsg, pte_mask, pgp->dev_count);
		status = EINVAL;
		goto failed_respond;
	}
	pte_fields = (sizeof(uint32_t) * 8) / pgp->pte_bits;
	if (pgp->page_offset % pte_fields != 0) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "%s: Unaligned message (Beginning offset %u must be an even multiple of %u)",
			 invmsg, pgp->page_offset, pte_fields);
		status = EINVAL;
		goto failed_respond;
	}
	msg_pte_size = pte_size(pgp->page_count, pte_fields);
	if ((sizeof(*pgp) - 1 + msg_pte_size) > na->nla_len) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "%s: incomplete messsage (data %zu > nl_len %d)",
			 invmsg, (size_t) (sizeof(*pgp) - 1 + msg_pte_size),
			 na->nla_len);
		status = EINVAL;
		goto failed_respond;
	}
	if (pgp->page_total == 0) {
		/* 
		 * TODO: page_total == 0 could mean "deallocate all chunks and ptbl for
		 * this device".  For now, this is just an invalid message.
		 */
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "Number of page table entries (%u) must be greater than 0",
			 pgp->page_total);
		status = EINVAL;
		goto failed_unlock;
	}
	num_chunks = CHUNK_PTE_IDX(pgp->page_total - 1) + 1;
	/*
	 * Note: This is an artificial limit, but makes the RCU Reclamation
	 * code simpler since we can just use a static buffer of
	 * MAX_NUMBER_OF_CHUNKS size.
	 */
	if (num_chunks > MAX_NUMBER_OF_CHUNKS) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "More page table entries than maximum allowed (%u > %llu)",
			 pgp->page_total,
			 (MAX_NUMBER_OF_CHUNKS * CHUNK_PTE_COUNT));
		status = EINVAL;
		goto failed_unlock;
	}
	debug_hexdump(&pgp->ptbl_buff, msg_pte_size, __func__);

	/*
	 * Look for the corresponding switch context block to create or update
	 * the page table.
	 */
	rc = 0;
	dev = MKDEV(pgp->dev_major, pgp->dev_minor);
	mutex_lock(&__g_context_lock);
	list_for_each_entry_safe(pctx, next, &__g_context_list, list) {
		if (dev == pctx->dev_this) {
			rc = 1;
			break;
		}
	}
	if (rc == 0) {
		snprintf(resp.err_str, sizeof(resp.err_str),
			 "%s: invalid target device %d:%d",
			 invmsg, pgp->dev_major, pgp->dev_minor);
		status = EINVAL;
		goto failed_unlock;
	}
	DBGPRINT("%s ctx=0x%p (%d:%d): Received %u pages (%zu bytes)\n",
		 __func__, pctx, pgp->dev_major, pgp->dev_minor,
		 pgp->page_count, msg_pte_size);

	ptbl = pctx->ptbl;

	ptbl_realloc_needed = false;
	if (ptbl != NULL) {
		if ((pgp->dev_count != pctx->dev_count) ||
		    (pgp->pte_bits != ptbl->pte_bits) ||
		    (pgp->page_total != ptbl->ptbl_max)) {
			ptbl_realloc_needed = true;
			printk(KERN_WARNING
			       "Reallocating page table due to change in parameters: Existing page table entries will be freed\n");
		}
	}

	/*
	 * Create a Page Table if needed.  Most of the time, the context of
	 * the underlying device doesn't change.  In that case, re-use the
	 * existing table and chunks.
	 */
	total_pte_size = pte_size(pgp->page_total, pte_fields);
	DBGPRINTV
	    ("%s ctx=0x%p (%d:%d): PageTotal: %u (%zu bytes) fits in "
	     "%zu chunks\n",
	     __func__, pctx, MAJOR(pctx->dev_this), MINOR(pctx->dev_this),
	     pgp->page_total, total_pte_size, num_chunks);

	if ((ptbl == NULL) || ptbl_realloc_needed) {
		pnew = ptbl_alloc(num_chunks, GFP_KERNEL);
		if (pnew == NULL) {
			snprintf(resp.err_str, sizeof(resp.err_str),
				 "Cannot allocate Page Table metadata");
			status = ENOMEM;
			goto failed_unlock;
		}
	} else {
		pnew = ptbl;
	}
	DBGPRINT
	    ("%s ctx=0x%p (%d:%d): Page table header 0x%p (chunks=%zu) %s\n",
	     __func__, pctx, MAJOR(pctx->dev_this), MINOR(pctx->dev_this), pnew,
	     num_chunks, pnew == ptbl ? "Reused" : "Allocated");
	pnew->pte_bits = pgp->pte_bits;
	pnew->pte_mask = pte_mask;
	pnew->pte_fields = pte_fields;
	pnew->ptbl_max = pgp->page_total;

	/*
	 * Metadata is set up, allocate and copy page table mappings
	 * into appropriate chunks.
	 */
	if (pgp->page_count == 0) {
		/*
		 * Special case: page_count 0 with a chunk-aligned page_offset:
		 * Deallocate that chunk
		 */
		size_t ichunk = CHUNK_PTE_IDX(pgp->page_offset);
		if (CHUNK_PTE_REM(pgp->page_offset) != 0) {
			snprintf(resp.err_str, sizeof(resp.err_str),
				 "Cannot deallocate chunk if page_offset (0x%0x) is not aligned to a chunk boundary (0x%0llx)",
				 pgp->page_offset, CHUNK_PTE_COUNT);
			status = EINVAL;
			goto failed_unlock;
		}
		chunk = &(pnew->chunk[ichunk]);
		if (chunk->ptbl_buff != NULL) {
			uint32_t *tmpbuf = chunk->ptbl_buff;
			DBGPRINT
			    ("%s ctx=0x%p (%d:%d): Deallocating chunk %zu\n",
			     __func__, pctx, MAJOR(pctx->dev_this),
			     MINOR(pctx->dev_this), ichunk);
			chunk->ptbl_num = 0;
			rcu_assign_pointer(chunk->ptbl_buff, NULL);
			/*
			 * Do not free yet (need to synchronize_rcu() first);
			 * save the old buffer for freeing later
			 */
			if (tmpbuf)
				pbuff_free_list[pbuff_list_to_free++] = tmpbuf;
		}
	}
	/* Else (pgp->page_count > 0): */
	chunk_pte_size = pte_size(CHUNK_PTE_COUNT, pte_fields);
	src_pte_offset = 0;
	while (src_pte_offset < pgp->page_count) {
		uint32_t *ptbl_buff, *ptbl_new;
		size_t abs_pte_offset = (pgp->page_offset + src_pte_offset);
		size_t ichunk = CHUNK_PTE_IDX(abs_pte_offset);
		size_t dst_pte_offset = CHUNK_PTE_REM(abs_pte_offset);

		/*
		 * These offsets are guaranteed to be uint32-aligned since
		 * src_pte_offset begins at 0 and is incremented in
		 * uint32-sized steps, and dst_pte_offset is based on
		 * src_pte_offset and pgp->page_offset which has already been
		 * checked
		 */
		size_t src_byte_offset = (src_pte_offset / pte_fields) *
		    sizeof(uint32_t);
		size_t dst_byte_offset = (dst_pte_offset / pte_fields) *
		    sizeof(uint32_t);

		size_t xfer_byte_count = chunk_pte_size - dst_byte_offset;
		size_t xfer_pte_count = (xfer_byte_count / sizeof(uint32_t)) *
		    pte_fields;

		if ((src_pte_offset + xfer_pte_count) > pgp->page_count) {
			/* End of the page table */
			xfer_pte_count = pgp->page_count - src_pte_offset;
			/* Round up to next full uint32_t word */
			xfer_byte_count = pte_size(xfer_pte_count, pte_fields);
		}

		chunk = &(pnew->chunk[ichunk]);
		ptbl_buff = chunk->ptbl_buff;
		if (ptbl_buff != NULL) {
			/* Reuse existing buffer */
			ptbl_new = ptbl_buff;
		} else {
			/* Allocate a new buffer */
			ptbl_new = kzalloc(chunk_pte_size, GFP_KERNEL);
			if (ptbl_new == NULL) {
				printk(KERN_WARNING
				       "%s: Cannot allocate new chunk %zu (%zu bytes), continuing with sparsely mapped device\n",
				       __func__, ichunk, chunk_pte_size);
			}
		}

		DBGPRINT
		    ("%s ctx=0x%p (%d:%d): Chunk %zu ptbl_buff 0x%p "
		     "(0x%0zx bytes) %s\n",
		     __func__, pctx, MAJOR(pctx->dev_this),
		     MINOR(pctx->dev_this), ichunk, ptbl_new, chunk_pte_size,
		     (ptbl_buff == ptbl_new ? "Reused" :
		      (ptbl_new ? "Allocated" : "Not Allocated")));

		if (ptbl_new != NULL) {
			DBGPRINTV
			    ("%s ctx=0x%p (%d:%d): Transferring 0x%0zx bytes "
			     "(0x%0zx pte) from 0x%p+0x%0zx (0x%p) to "
			     "0x%p+0x%0zx (0x%p)\n",
			     __func__, pctx, MAJOR(pctx->dev_this),
			     MINOR(pctx->dev_this), xfer_byte_count,
			     xfer_pte_count, pgp->ptbl_buff, src_byte_offset,
			     ((void *)pgp->ptbl_buff + src_byte_offset),
			     ptbl_new, dst_byte_offset,
			     ((void *)ptbl_new + dst_byte_offset));
			memcpy((void *)ptbl_new + dst_byte_offset,
			       (void *)pgp->ptbl_buff + src_byte_offset,
			       xfer_byte_count);
		} else {
			DBGPRINTV
			    ("%s ctx=0x%p (%d:%d): Skipping 0x%0zx bytes "
			     "(0%0zx pte) from 0x%p+0x%0zx "
			     "(no buffer available)\n",
			     __func__, pctx, MAJOR(pctx->dev_this),
			     MINOR(pctx->dev_this), xfer_byte_count,
			     xfer_pte_count, pgp->ptbl_buff, src_byte_offset);
		}
		debug_hexdump((void *)pgp->ptbl_buff + src_byte_offset,
			      xfer_byte_count, __func__);
		src_pte_offset += xfer_pte_count;

		/* Reset the buffer count */
		if (ptbl_new != NULL)
			chunk->ptbl_num = dst_pte_offset + xfer_pte_count;
		else
			chunk->ptbl_num = 0;

		/* Assign the new buffer */
		if (ptbl_new != ptbl_buff) {
			rcu_assign_pointer(chunk->ptbl_buff, ptbl_new);
			/*
			 * Do not free yet (need to synchronize_rcu() first);
			 * save the old buffer for freeing later
			 */
			if (ptbl_buff)
				pbuff_free_list[pbuff_list_to_free++] =
				    ptbl_buff;
		}
	}

	/* Copy complete, update userland data members */
	pctx->userland[0] = pgp->userland[0];
	pctx->userland[1] = pgp->userland[1];

	if (pnew != ptbl) {
		rcu_assign_pointer(pctx->ptbl, pnew);
		/*
		 * Do not free yet (need to synchronize_rcu() first);
		 * save the old buffer for freeing later
		 */
		ptbl_to_free = ptbl;
	}

failed_unlock:
	mutex_unlock(&__g_context_lock);

failed_respond:
	if (status)
		printk(KERN_WARNING "%s WARNING: %s\n", __func__, resp.err_str);
	else
		resp.err_str[0] = '\0';

	/* Format the response message */
	resp.total_len = sizeof(struct IpcResponse);
	resp.opcode = OPCODE_PAGE_TABLE_UPLOAD;
	resp.userland[0] = pgp->userland[0];
	resp.userland[1] = pgp->userland[1];
	resp.dev_major = pgp->dev_major;
	resp.dev_minor = pgp->dev_minor;
	resp.status = status;
	rc = nla_put(skb, NLA_BINARY, sizeof(struct IpcResponse), &resp);
	if (rc != 0) {
		printk(KERN_WARNING
		       "%s WARNING: Cannot format reply message\n", __func__);
		goto reclaim_rcu;
	}
	genlmsg_end(skb, msg_head);
	rc = genlmsg_unicast(&init_net, skb, info->snd_pid);
	if (rc != 0)
		printk(KERN_WARNING "%s WARNING: Cannot send reply message\n",
		       __func__);

reclaim_rcu:
	/*
	 * Now that the response message has been sent, reclaim any
	 * RCU-protected memory (synchronize_rcu() may block, which is why we
	 * leave this till dead last)
	 */
	if (ptbl_to_free || pbuff_list_to_free) {
		unsigned i;
		bool sync_done;
		DBGPRINT
		    ("%s ctx=0x%p: Reclaiming RCU-protected memory.  "
		     "ptbl_to_free:0x%p pbuff_list_to_free:%u\n",
		     __func__, pctx, ptbl_to_free, pbuff_list_to_free);
		sync_done = ptbl_free_sync_rcu(ptbl_to_free);
		if (pbuff_list_to_free > 0 && !sync_done)
			synchronize_rcu();
		for (i = 0; i < pbuff_list_to_free; ++i)
			kfree(pbuff_free_list[i]);
	}
	kfree(pbuff_free_list);

	return 0;
}

/* Operation for getting the page table */
static struct genl_ops __g_op_get_page_tbl = {
	.cmd = NETLINK_CMD_GET_PAGE_TBL,
	.flags = 0,
	.policy = __g_attr_policy,
	.doit = get_page_tbl,
	.dumpit = NULL,
};

/*
 * Use the sysfs interface to inform the userland process of the family id to
 * be used by the Generic Netlink socket.
 */
static ssize_t sysfs_familyid_show(struct kobject *kobj,
				   struct attribute *attr, char *buff)
{
	return snprintf(buff, PAGE_SIZE, "%d\n", __g_family.id);
}

static ssize_t sysfs_familyid_store(struct kobject *kobj,
				    struct attribute *attr, const char *buff,
				    size_t size)
{
	return -EINVAL;
}

struct _sysfs_attr_ops {
	const struct attribute attr;
	const struct sysfs_ops ops;
};
static const struct _sysfs_attr_ops __g_sysfs_familyid = {
	.attr = {"familyid", 0444},
	.ops = {&sysfs_familyid_show, &sysfs_familyid_store}
};

static ssize_t sysfs_version_show(struct kobject *kobj,
				  struct attribute *attr, char *buff)
{
	return snprintf(buff, PAGE_SIZE, "%d.%d.%d\n",
			__g_switch_target.version[0],
			__g_switch_target.version[1],
			__g_switch_target.version[2]);
}

static ssize_t sysfs_version_store(struct kobject *kobj,
				   struct attribute *attr, const char *buff,
				   size_t size)
{
	return -EINVAL;
}

static const struct _sysfs_attr_ops __g_sysfs_version = {
	.attr = {"version", 0444},
	.ops = {&sysfs_version_show, &sysfs_version_store}
};

int __init dm_switch_init(void)
{
	int r;

	DBGPRINTV("%s\n", __func__);

	r = dm_register_target(&__g_switch_target);
	if (r) {
		DMERR("dm_register_target() failed %d", r);
		goto failed_dmreg;
	}

	/* Initialize Generic Netlink communications */
	r = genl_register_family(&__g_family);
	if (r) {
		DMERR("genl_register_family() failed");
		goto failed_genl_family;
	}
	r = genl_register_ops(&__g_family, &__g_op_get_page_tbl);
	if (r) {
		DMERR("genl_register_ops(get_page_tbl) failed %d", r);
		goto failed_genl_ops;
	}
	DBGPRINTV("%s Registered Generic Netlink group %d\n", __func__,
		  __g_family.id);
	r = sysfs_create_file(&__g_switch_target.module->mkobj.kobj,
			      &__g_sysfs_familyid.attr);
	if (r) {
		DMERR("/sys/module/.../familyid create failed %d", r);
		goto failed_familyid;
	}
	r = sysfs_create_file(&__g_switch_target.module->mkobj.kobj,
			      &__g_sysfs_version.attr);
	if (r) {
		DMERR("/sys/module/.../version create failed %d", r);
		goto failed_version;
	}
	return 0;
failed_version:
	sysfs_remove_file(&__g_switch_target.module->mkobj.kobj,
			  &__g_sysfs_familyid.attr);
failed_familyid:
	/* genl_unregister_ops() is not needed: genl_unregister_family does it */
failed_genl_ops:
	genl_unregister_family(&__g_family);
failed_genl_family:
	dm_unregister_target(&__g_switch_target);
failed_dmreg:
	return r;
}

void dm_switch_exit(void)
{
	int r;

	DBGPRINTV("%s\n", __func__);
	dm_unregister_target(&__g_switch_target);
	r = genl_unregister_family(&__g_family);
	if (r)
		DMWARN("genl_unregister_family() failed %d", r);
	return;
}

module_init(dm_switch_init);
module_exit(dm_switch_exit);
-------------------
