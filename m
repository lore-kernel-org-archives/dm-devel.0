From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: RFC: dm-switch target [v2]
Date: Fri, 2 Sep 2011 00:09:30 +0300
Message-ID: <20110901210930.GB12984@reaktio.net>
References: <20110831201919.GA27111@freewill.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110831201919.GA27111@freewill.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Shah, Parind" <Parind_Shah@dell.com>, "Shamberger,
	Jason" <Jason_Shamberger@dell.com>, "OKelley,
	Kevin" <Kevin_OKelley@dell.com>
List-Id: dm-devel.ids

On Wed, Aug 31, 2011 at 04:19:24PM -0400, Jim Ramsay wrote:
> Note: This is a repost with cleaned-up code, which was originally posted
> by Jason Shamberger.
>   http://www.redhat.com/archives/dm-devel/2011-March/msg00131.html
> 
> - The license in the headers has been cleared up - This is and always
>   has been GPL code.
> - Code formatting and style more closely match the Linux Kernel.
> 
> ---------------------------
> 
> We propose a new DM target, dm-switch, which can be used to efficiently
> implement a mapping of IOs to underlying block devices in scenarios
> where there are: (1) a large number of address regions, (2) a fixed size
> of these address regions, (3) no pattern than allows for a compact
> description with something like the dm-stripe target.
> 

Great, I've been waiting for this module :)

Do you guys have some userland tool/script to populate the page table
in dm-switch, or is there some other way to test this (with eql storage) ?

Thanks!

-- Pasi


> Motivation:
> 
> Dell EqualLogic and some other iSCSI storage arrays use a distributed
> frameless architecture.  In this architecture, the storage group
> consists of a number of distinct storage arrays ("members"), each having
> independent controllers, disk storage and network adapters.  When a LUN
> is created it is spread across multiple members.  The details of the
> spreading are hidden from initiators connected to this storage system.
> The storage group exposes a single target discovery portal, no matter
> how many members are being used.  When iSCSI sessions are created, each
> session is connected to an eth port on a single member.  Data to a LUN
> can be sent on any iSCSI session, and if the blocks being accessed are
> stored on another member the IO will be forwarded as required.  This
> forwarding is invisible to the initiator.  The storage layout is also
> dynamic, and the blocks stored on disk may be moved from member to
> member as needed to balance the load.
> 
> This architecture simplifies the management and configuration of both
> the storage group and initiators.  In a multipathing configuration, it
> is possible to set up multiple iSCSI sessions to use multiple network
> interfaces on both the host and target to take advantage of the
> increased network bandwidth.  An initiator can use a simple round robin
> algorithm to send IO on all paths and let the storage array members
> forward it as necessary.  However, there is a performance advantage to
> sending data directly to the correct member.  The Device Mapper table
> architecture supports designating different address regions with
> different targets.  However, in our architecture the LUN is spread with
> a chunk size on the order of 10s of MBs, which means the resulting DM
> table could have more than a million entries, which consumes too much
> memory.
> 
> Solution:
> 
> Based on earlier discussion with the dm-devel contributors, we have
> solved this problem by using Device Mapper to build a two-layer device
> hierarchy:
> 
>     Upper Tier ??? Determine which array member the IO should be sent to.
>     Lower Tier ??? Load balance amongst paths to a particular member.
> 
> The lower tier consists of a single multipath device for each member.
> Each of these multipath devices contains the set of paths directly to
> the array member in one priority group, and leverages existing path
> selectors to load balance amongst these paths.  We also build a
> non-preferred priority group containing paths to other array members for
> failover reasons.
> 
> The upper tier consists of a single switch device, using the new DM
> target module proposed here.  This device uses a bitmap to look up the
> location of the IO and choose the appropriate lower tier device to route
> the IO.  By using a bitmap we are able to use 4 bits for each address
> range in a 16 member group (which is very large for us).  This is a much
> denser representation than the DM table B-tree can achieve.
> 
> Though we have developed this target for a specific storage device, we
> have made an effort to keep it a general purpose as possible in hopes
> that others may benefit.  We welcome any feedback on the design or
> implementation.
> 
> --- dm-switch.h ---
> 
> /*
>  * Copyright (c) 2010-2011 by Dell, Inc.  All rights reserved.
>  *
>  * This file is released under the GPL.
>  *
>  * Description:
>  *
>  *     file:    dm-switch.h
>  *     authors: Kevin_OKelley@dell.com
>  *              Jim_Ramsay@dell.com
>  *              Narendran_Ganapathy@dell.com
>  *
>  * This file contains the netlink message definitions for the "switch" target.
>  *
>  * The only defined message at this time is for uploading the mapping page
>  * table.
>  */
> 
> #ifndef __DM_SWITCH_H
> #define __DM_SWITCH_H
> 
> #define MAX_IPC_MSG_LEN 65480	/* dictated by netlink socket */
> #define MAX_ERR_STR_LEN 255	/* maximum length of the error string */
> 
> enum Opcode {
> 	OPCODE_PAGE_TABLE_UPLOAD = 1,
> };
> 
> /*
>  * IPC Page Table message
>  */
> struct IpcPgTable {
> 	uint32_t total_len;	/* Total length of this IPC message */
> 	enum Opcode opcode;
> 	uint32_t userland[2];	/* Userland optional data (dmsetup status) */
> 	uint32_t dev_major;	/* DM device major */
> 	uint32_t dev_minor;	/* DM device minor */
> 	uint32_t page_total;	/* Total pages in the volume */
> 	uint32_t page_offset;	/* Starting page offset for this IPC */
> 	uint32_t page_count;	/* Number of page table entries in this IPC */
> 	uint32_t page_size;	/* Page size in 512B sectors */
> 	uint16_t dev_count;	/* Number of devices */
> 	uint8_t pte_bits;	/* Page Table Entry field size in bits */
> 	uint8_t reserved;	/* Integer alignment  */
> 	uint8_t ptbl_buff[1];	/* Page table entries (variable length) */
> };
> 
> /*
>  * IPC Response message
>  */
> struct IpcResponse {
> 	uint32_t total_len;	/* total length of the IPC */
> 	enum Opcode opcode;
> 	uint32_t userland[2];	/* Userland optional data */
> 	uint32_t dev_major;	/* DM device major */
> 	uint32_t dev_minor;	/* DM device minor */
> 	uint32_t status;	/* 0 on success; errno on failure */
> 	char err_str[MAX_ERR_STR_LEN + 1];
> 	/* If status != 0, contains an informative error message */
> };
> 
> /* Generic Netlink family attributes: used to define the family */
> enum {
> 	NETLINK_ATTR_UNSPEC,
> 	NETLINK_ATTR_MSG,
> 	NETLINK_ATTR__MAX,
> };
> #define NETLINK_ATTR_MAX (NETLINK_ATTR__MAX - 1)
> 
> /* Netlink commands (operations) */
> enum {
> 	NETLINK_CMD_UNSPEC,
> 	NETLINK_CMD_GET_PAGE_TBL,
> 	NETLINK_CMD__MAX,
> };
> #define NETLINK_CMD_MAX (NETLINK_CMD__MAX - 1)
> 
> #endif /* __DM_SWITCH_H */
> 
> --- dm-switch.c ---
> 
> /*
>  * Copyright (c) 2010-2011 by Dell, Inc.  All rights reserved.
>  *
>  * This file is released under the GPL.
>  *
>  * Description:
>  *
>  *     file:    dm-switch.c
>  *     authors: Kevin_OKelley@dell.com
>  *              Jim_Ramsay@dell.com
>  *              Narendran_Ganapathy@dell.com
>  *
>  * This file implements a "switch" target which efficiently implements a
>  * mapping of IOs to underlying block devices in scenarios where there are:
>  *   (1) a large number of address regions
>  *   (2) a fixed size equal across all address regions
>  *   (3) no pattern than allows for a compact description with something like
>  *       the dm-stripe target.
>  */
> 
> #include <linux/module.h>
> #include <linux/init.h>
> #include <linux/blkdev.h>
> #include <linux/bio.h>
> #include <linux/slab.h>
> #include <linux/device.h>
> #include <linux/version.h>
> #include <linux/dm-ioctl.h>
> #include <linux/device-mapper.h>
> #include <net/genetlink.h>
> #include <asm/div64.h>
> 
> #include "dm-switch.h"
> #define DM_MSG_PREFIX "switch"
> MODULE_DESCRIPTION(DM_NAME
> 		   " fixed-size address-region-mapping throughput-oriented path selector");
> MODULE_AUTHOR("Kevin D. O'Kelley <Kevin_OKelley@dell.com>");
> MODULE_LICENSE("GPL");
> 
> #if defined(DEBUG) || defined(_DEBUG)
> #define DBGPRINT(...)  printk(KERN_DEBUG #args)
> #define DBGPRINTV(...)
> /* #define DEBUG_HEXDUMP 1 */
> #else
> #define DBGPRINT(...)
> #define DBGPRINTV(...)
> #endif
> 
> /*
>  * Switch device context block: A new one is created for each dm device.
>  * Contains an array of devices from which we have taken references.
>  */
> struct switch_dev {
> 	struct dm_dev *dmdev;
> 	sector_t start;
> 	atomic_t error_count;
> };
> 
> /* Switch page table block */
> struct switch_ptbl {
> 	uint32_t pte_bits;	/* Page Table Entry field size in bits */
> 	uint32_t pte_mask;	/* Page Table Entry field mask */
> 	uint32_t pte_fields;	/* Number of Page Table Entries per uint32_t */
> 	uint32_t ptbl_bytes;	/* Page table size in bytes */
> 	uint32_t ptbl_num;	/* Page table size in entries */
> 	uint32_t ptbl_max;	/* Page table maximum size in entries; */
> 	uint32_t ptbl_buff[0];	/* Address of page table */
> };
> 
> /* Switch context header */
> struct switch_ctx {
> 	struct list_head list;
> 	dev_t dev_this;		/* Device serviced by this target */
> 	uint32_t dev_count;	/* Number of devices */
> 	uint32_t page_size;	/* Page size in 512B sectors */
> 	uint32_t userland[2];	/* Userland optional data (dmsetup status) */
> 	uint64_t ios_remapped;	/* I/Os remapped */
> 	uint64_t ios_unmapped;	/* I/Os not remapped */
> 	spinlock_t spinlock;	/* Control access to counters */
> 
> 	struct switch_ptbl *ptbl;	/* Page table (if loaded) */
> 	struct switch_dev dev_list[0];
> 	/* Array of dm devices to switch between */
> };
> 
> /*
>  * Global variables
>  */
> LIST_HEAD(__g_context_list);	/* Linked list of context blocks */
> static spinlock_t __g_spinlock;	/* Control access to list of context blocks */
> 
> /* Limit check for the switch constructor */
> static int switch_ctr_limits(struct dm_target *ti, struct dm_dev *dm)
> {
> 	struct block_device *sd = dm->bdev;
> 	struct hd_struct *hd = sd->bd_part;
> 	if (hd != NULL) {
> 		DBGPRINT("%s sd=0x%p (%d:%d), hd=0x%p, start=%llu, "
> 			 "size=%llu\n", __func__, sd, MAJOR(sd->bd_dev),
> 			 MINOR(sd->bd_dev), hd,
> 			 (unsigned long long)hd->start_sect,
> 			 (unsigned long long)hd->nr_sects);
> 		if (ti->len <= hd->nr_sects)
> 			return true;
> 		ti->error = "Device too small for target";
> 		return false;
> 	}
> 	ti->error = "Missing device limits";
> 	printk(KERN_WARNING "%s %s\n", __func__, ti->error);
> 	return true;
> }
> 
> /*
>  * Constructor: Called each time a dmsetup command creates a dm device.  The
>  * target parameter will already have the table, type, begin and len fields
>  * filled in.  Arguments are in pairs: <dev_path> <offset>.  Therefore, we get
>  * multiple constructor calls, but we will need to build a list of switch_ctx
>  * blocks so that the page table information gets matched to the correct
>  * device.
>  */
> static int switch_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> {
> 	int n;
> 	uint32_t dev_count;
> 	unsigned long flags, major, minor;
> 	unsigned long long start;
> 	struct switch_ctx *pctx;
> 	struct mapped_device *md = NULL;
> 	struct dm_dev *dm;
> 	const char *dm_devname;
> 
> 	DBGPRINTV("%s\n", __func__);
> 	if (argc < 4) {
> 		ti->error = "Insufficient arguments";
> 		return -EINVAL;
> 	}
> 	if (kstrtou32(argv[0], 10, &dev_count) != 0) {
> 		ti->error = "Invalid device count";
> 		return -EINVAL;
> 	}
> 	if (dev_count != (argc - 2) / 2) {
> 		ti->error = "Invalid argument count";
> 		return -EINVAL;
> 	}
> 	pctx = kmalloc(sizeof(*pctx) + (dev_count * sizeof(struct switch_dev)),
> 		       GFP_KERNEL);
> 	if (pctx == NULL) {
> 		ti->error = "Cannot allocate redirect context";
> 		return -ENOMEM;
> 	}
> 	pctx->dev_count = dev_count;
> 	if ((kstrtou32(argv[1], 10, &pctx->page_size) != 0) ||
> 	    (pctx->page_size == 0)) {
> 		ti->error = "Invalid page size";
> 		goto failed_kfree;
> 	}
> 	pctx->ptbl = NULL;
> 	pctx->userland[0] = pctx->userland[1] = 0;
> 	pctx->ios_remapped = pctx->ios_unmapped = 0;
> 	spin_lock_init(&pctx->spinlock);
> 
> 	/*
> 	 * Find the device major and minor for the device that is being served
> 	 * by this target.
> 	 */
> 	md = dm_table_get_md(ti->table);
> 	if (md == NULL) {
> 		ti->error = "Cannot locate dm device";
> 		goto failed_kfree;
> 	}
> 	dm_devname = dm_device_name(md);
> 	if (dm_devname == NULL) {
> 		ti->error = "Cannot acquire dm device name";
> 		goto failed_kfree;
> 	}
> 	if (sscanf(dm_devname, "%lu:%lu", &major, &minor) != 2) {
> 		ti->error = "Invalid dm device name";
> 		goto failed_kfree;
> 	}
> 	pctx->dev_this = MKDEV(major, minor);
> 	DBGPRINT("%s ctx=0x%p (%d:%d), type=\"%s\", count=%d, "
> 		 "start=%llu, size=%llu\n",
> 		 __func__, pctx, MAJOR(pctx->dev_this),
> 		 MINOR(pctx->dev_this), ti->type->name, pctx->dev_count,
> 		 (unsigned long long)ti->begin, (unsigned long long)ti->len);
> 
> 	/*
> 	 * Check each device beneath the target to ensure that the limits are
> 	 * consistent.
> 	 */
> 	for (n = 0, argc = 2; n < pctx->dev_count; n++, argc += 2) {
> 		DBGPRINTV("%s #%d 0x%p, %s, %s\n", __func__, n,
> 			  &pctx->dev_list[n], argv[argc], argv[argc + 1]);
> 		if (sscanf(argv[argc + 1], "%llu", &start) != 1) {
> 			ti->error = "Invalid device starting offset";
> 			goto failed_dev_list_prev;
> 		}
> 		if (dm_get_device
> 		    (ti, argv[argc], dm_table_get_mode(ti->table), &dm)) {
> 			ti->error = "Device lookup failed";
> 			goto failed_dev_list_prev;
> 		}
> 		pctx->dev_list[n].dmdev = dm;
> 		pctx->dev_list[n].start = start;
> 		atomic_set(&(pctx->dev_list[n].error_count), 0);
> 		if (!switch_ctr_limits(ti, dm))
> 			goto failed_dev_list_all;
> 	}
> 
> 	spin_lock_irqsave(&__g_spinlock, flags);
> 	list_add_tail(&pctx->list, &__g_context_list);
> 	spin_unlock_irqrestore(&__g_spinlock, flags);
> 	ti->private = pctx;
> 	return 0;
> 
> failed_dev_list_prev:		/* De-reference previous devices */
> 	n--;			/*   (i.e. don't include this one) */
> 
> failed_dev_list_all:		/* De-reference all devices  */
> 	printk(KERN_WARNING "%s device=%s, start=%s\n", __func__,
> 	       argv[argc], argv[argc + 1]);
> 	for (; n >= 0; n--)
> 		dm_put_device(ti, pctx->dev_list[n].dmdev);
> 
> failed_kfree:
> 	printk(KERN_WARNING "%s %s\n", __func__, ti->error);
> 	kfree(pctx);
> 	return -EINVAL;
> }
> 
> /*
>  * Destructor: Don't free the dm_target, just the ti->private data (if any).
>  */
> static void switch_dtr(struct dm_target *ti)
> {
> 	int n;
> 	unsigned long flags;
> 	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
> 	void *ptbl;
> 
> 	DBGPRINT("%s ctx=0x%p (%d:%d)\n", __func__, pctx,
> 		 MAJOR(pctx->dev_this), MINOR(pctx->dev_this));
> 	spin_lock_irqsave(&__g_spinlock, flags);
> 	ptbl = pctx->ptbl;
> 	rcu_assign_pointer(pctx->ptbl, NULL);
> 	list_del(&pctx->list);
> 	spin_unlock_irqrestore(&__g_spinlock, flags);
> 	for (n = 0; n < pctx->dev_count; n++) {
> 		DBGPRINTV("%s dm_put_device(%s)\n", __func__,
> 			  pctx->dev_list[n].dmdev->name);
> 		dm_put_device(ti, pctx->dev_list[n].dmdev);
> 	}
> 	synchronize_rcu();
> 	kfree(ptbl);
> 	kfree(pctx);
> }
> 
> /*
>  * NOTE: If CONFIG_LBD is disabled, sector_t types are uint32_t.  Therefore, in
>  * this routine, we convert the offset into a uint64_t instead of a sector_t so
>  * that all of the remaining arithmatic is correct, including the do_div()
>  * calls.
>  */
> static int switch_map(struct dm_target *ti, struct bio *bio,
> 		      union map_info *map_context)
> {
> 	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
> 	struct switch_ptbl *ptbl;
> 	unsigned long flags;
> 	uint64_t itbl, offset = bio->bi_sector - ti->begin;
> 	uint32_t idev = 0, irem;
> 	uint64_t *pinc = &pctx->ios_unmapped;
> 
> 	rcu_read_lock();
> 	ptbl = rcu_dereference(pctx->ptbl);
> 	if (ptbl != NULL) {
> 		itbl = offset;
> 		do_div(itbl, pctx->page_size);
> 		if (itbl < ptbl->ptbl_num) {
> 			irem = do_div(itbl, ptbl->pte_fields);
> 			idev =
> 			    (ptbl->ptbl_buff[itbl] >> (irem * ptbl->pte_bits))
> 			    & ptbl->pte_mask;
> 			if (idev <= pctx->dev_count) {
> 				pinc = &pctx->ios_remapped;
> 			} else {
> 				printk(KERN_WARNING "%s WARNING: dev=%d, "
> 				       "offset=%lld\n", __func__, idev, offset);
> 				idev = 0;
> 			}
> 		} else {
> 			printk(KERN_WARNING "%s WARNING: Page Table Entry "
> 			       "%lld >= %d\n", __func__, itbl, ptbl->ptbl_num);
> 		}
> 	}
> 	rcu_read_unlock();
> 	spin_lock_irqsave(&pctx->spinlock, flags);
> 	(*pinc)++;
> 	spin_unlock_irqrestore(&pctx->spinlock, flags);
> 	bio->bi_bdev = pctx->dev_list[idev].dmdev->bdev;
> 	bio->bi_sector = pctx->dev_list[idev].start + offset;
> 	return DM_MAPIO_REMAPPED;
> }
> 
> /*
>  * Switch status:
>  *
>  * INFO: #dev_count device [device] 5 'A'['A' ...] userland[0] userland[1]
>  *       #remapped #unmapped
>  *
>  * where:
>  *   "'A'['A']" is a single word with an 'A' (active) or 'D' for each device
>  *   The userland values are set by the last userland message to load the page
>  *   table
>  *   "#remapped" is the number of remapped I/Os
>  *   "#unmapped" is the number of I/Os that could not be remapped
>  *
>  * TABLE: #page_size #dev_count device start [device start ...]
>  */
> static int switch_status(struct dm_target *ti, status_type_t type, char
> 			 *result, unsigned int maxlen)
> {
> 	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
> 	char buffer[pctx->dev_count + 1];
> 	unsigned int sz = 0;
> 	int n;
> 	uint64_t remapped, unmapped;
> 	unsigned long flags;
> 
> 	result[0] = '\0';
> 	switch (type) {
> 	case STATUSTYPE_INFO:
> 		DMEMIT("%d", pctx->dev_count);
> 		for (n = 0; n < pctx->dev_count; n++) {
> 			DMEMIT(" %s", pctx->dev_list[n].dmdev->name);
> 			buffer[n] = 'A';
> 		}
> 		buffer[n] = '\0';
> 		spin_lock_irqsave(&pctx->spinlock, flags);
> 		remapped = pctx->ios_remapped;
> 		unmapped = pctx->ios_unmapped;
> 		spin_unlock_irqrestore(&pctx->spinlock, flags);
> 		DMEMIT(" 5 %s %08x %08x %lld %lld", buffer, pctx->userland[0],
> 		       pctx->userland[1], remapped, unmapped);
> 		break;
> 
> 	case STATUSTYPE_TABLE:
> 		DMEMIT("%d %d", pctx->dev_count, pctx->page_size);
> 		for (n = 0; n < pctx->dev_count; n++) {
> 			DMEMIT(" %s %llu", pctx->dev_list[n].dmdev->name,
> 			       (unsigned long long)pctx->dev_list[n].start);
> 		}
> 		break;
> 
> 	default:
> 		return 0;
> 	}
> 	return 0;
> }
> 
> /*
>  * Switch ioctl:
>  *
>  * Passthrough all ioctls to the first path.
>  */
> static int switch_ioctl(struct dm_target *ti, unsigned int cmd,
> 			unsigned long arg)
> {
> 	struct switch_ctx *pctx = (struct switch_ctx *)ti->private;
> 	struct block_device *bdev;
> 	fmode_t mode = 0;
> 
> 	/* Sanity check */
> 	if (unlikely(!pctx || !pctx->dev_list[0].dmdev ||
> 		     !pctx->dev_list[0].dmdev->bdev))
> 		return -EIO;
> 
> 	bdev = pctx->dev_list[0].dmdev->bdev;
> 	mode = pctx->dev_list[0].dmdev->mode;
> 	return __blkdev_driver_ioctl(bdev, mode, cmd, arg);
> }
> 
> static struct target_type __g_switch_target = {
> 	.name = "switch",
> 	.version = {1, 0, 0},
> 	.module = THIS_MODULE,
> 	.ctr = switch_ctr,
> 	.dtr = switch_dtr,
> 	.map = switch_map,
> 	.status = switch_status,
> 	.ioctl = switch_ioctl,
> };
> 
> /* Generic Netlink attribute policy (single attribute, NETLINK_ATTR_MSG) */
> static struct nla_policy __g_attr_policy[NETLINK_ATTR_MAX + 1] = {
> 	[NETLINK_ATTR_MSG] = {.type = NLA_BINARY,.len = MAX_IPC_MSG_LEN},
> };
> 
> /* Define the Generic Netlink family */
> static struct genl_family __g_family = {
> 	.id = GENL_ID_GENERATE,	/* Assign channel when family is registered */
> 	.hdrsize = 0,
> 	.name = "DM_SWITCH",
> 	.version = 1,
> 	.maxattr = NETLINK_ATTR_MAX,
> };
> 
> #ifdef DEBUG_HEXDUMP
> #define DEBUG_HEXDUMP_WORDS 8
> #define DEBUG_HEXDUMP_BYTES (DEBUG_HEXDUMP_WORDS * sizeof(uint32_t))
> 
> static inline void debug_hexdump_line(void *ibuff, size_t offset, size_t isize,
> 				      const char *func)
> {
> 	static const char *hex = "0123456789abcdef";
> 	unsigned char *iptr = &((unsigned char *)ibuff)[offset];
> 	char *optr, obuff[DEBUG_HEXDUMP_BYTES * 3];
> 	int osize;
> 
> 	while (isize > 0) {
> 		optr = obuff;
> 		for (osize = 0; osize < DEBUG_HEXDUMP_BYTES; osize++) {
> 			if (((osize & 3) == 0) && (osize != 0))
> 				*optr++ = ' ';
> 			*optr++ = hex[(*iptr) >> 4];
> 			*optr++ = hex[(*iptr++) & 15];
> 			if (--isize <= 0)
> 				break;
> 		}
> 		*optr = '\0';
> 		DBGPRINT("%s %04x %s\n", func, (unsigned int)offset, obuff);
> 		offset += DEBUG_HEXDUMP_BYTES;
> 	}
> }
> 
> static inline void debug_hexdump(void *ibuff, size_t isize, const char *func)
> {
> 	size_t iline = isize / DEBUG_HEXDUMP_BYTES;
> 	size_t irem = isize % DEBUG_HEXDUMP_BYTES;
> 	size_t offset = isize;
> 
> 	if (iline < 6) {
> 		debug_hexdump_line(ibuff, 0, isize, func);
> 		return;
> 	}
> 	debug_hexdump_line(ibuff, 0, (3 * DEBUG_HEXDUMP_BYTES), func);
> 	isize = (irem == 0) ? (3 * DEBUG_HEXDUMP_BYTES)
> 	    : ((2 * DEBUG_HEXDUMP_BYTES) + irem);
> 	offset -= isize;
> 	debug_hexdump_line(ibuff, offset, isize, func);
> }
> #else
> static inline void debug_hexdump(void *ibuff, size_t isize, const char *func)
> {
> }
> #endif
> 
> /*
>  * Generic Netlink socket read function that handles communication from the
>  * userland for downloading the page table.
>  */
> static int get_page_tbl(struct sk_buff *skb_2, struct genl_info *info)
> {
> 	uint32_t rc, pte_mask, pte_fields, ptbl_bytes, offset, size;
> 	uint32_t status = 0;
> 	unsigned long flags;
> 	char *mydata;
> 	void *msg_head;
> 	struct nlattr *na;
> 	struct sk_buff *skb;
> 	struct switch_ctx *pctx, *next;
> 	struct switch_ptbl *ptbl, *pnew;
> 	struct IpcPgTable *pgp;
> 	struct IpcResponse resp;
> 	dev_t dev;
> 	static const char *invmsg = "Invalid Page Table message";
> 
> 	/*
> 	 * For each attribute there is an index in info->attrs which points to
> 	 * a nlattr structure in this structure the data is given
> 	 */
> 	if (info == NULL) {
> 		printk(KERN_WARNING "%s missing genl_info parameter\n",
> 		       __func__);
> 		return 0;
> 	}
> 	na = info->attrs[NETLINK_ATTR_MSG];
> 	if (na == NULL) {
> 		printk(KERN_WARNING "%s no info->attrs %i\n", __func__,
> 		       NETLINK_ATTR_MSG);
> 		return 0;
> 	}
> 	mydata = (char *)nla_data(na);
> 	if (mydata == NULL) {
> 		printk(KERN_WARNING "%s error while receiving data\n",
> 		       __func__);
> 		return 0;
> 	}
> 	DBGPRINTV("%s seq=%d, pid=%d, type=%d, flags=0x%x, data=0x%p "
> 		  "(0x%x, %d)\n",
> 		  __func__, info->snd_seq, info->snd_pid,
> 		  info->nlhdr->nlmsg_type, info->nlhdr->nlmsg_flags,
> 		  mydata, na->nla_len, na->nla_len);
> 	debug_hexdump(mydata,
> 		      ((offsetof(struct IpcPgTable, ptbl_buff)<na->nla_len)
> 		       ? offsetof(struct IpcPgTable, ptbl_buff)
> 		       : na->nla_len), __func__);
> 	/*
> 	 * Format the reply message.  Return positve error codes to userland.
> 	 */
> 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> 	if (skb == NULL) {
> 		printk(KERN_WARNING "%s cannot allocate reply message\n",
> 		       __func__);
> 		return 0;
> 	}
> 	msg_head = genlmsg_put(skb, 0, info->snd_seq, &__g_family, 0,
> 			       NETLINK_CMD_GET_PAGE_TBL);
> 	if (skb == NULL) {
> 		printk(KERN_WARNING "%s cannot format reply message header\n",
> 		       __func__);
> 		return 0;
> 	}
> 	pgp = (struct IpcPgTable *)mydata;
> 	if (na->nla_len < sizeof(struct IpcPgTable)) {
> 		snprintf(resp.err_str, sizeof(resp.err_str),
> 			 "%s: too short (%d)", invmsg, na->nla_len);
> 		status = EINVAL;
> 		goto failed_respond;
> 	}
> 	if ((pgp->page_offset + pgp->page_count) > pgp->page_total) {
> 		snprintf(resp.err_str, sizeof(resp.err_str),
> 			 "%s: too many page table entries (%d > %d)",
> 			 invmsg, (pgp->page_offset + pgp->page_count),
> 			 pgp->page_total);
> 		status = EINVAL;
> 		goto failed_respond;
> 	}
> 	pte_mask = (1 << pgp->pte_bits) - 1;
> 	if (((pgp->dev_count - 1) & (~pte_mask)) != 0) {
> 		snprintf(resp.err_str, sizeof(resp.err_str),
> 			 "%s: invalid mask 0x%x for %d devices",
> 			 invmsg, pte_mask, pgp->dev_count);
> 		status = EINVAL;
> 		goto failed_respond;
> 	}
> 	pte_fields = 32 / pgp->pte_bits;
> 	size = ((pgp->page_count + pte_fields - 1) / pte_fields) *
> 	    sizeof(uint32_t);
> 	if ((sizeof(*pgp) - 1 + size) > na->nla_len) {
> 		snprintf(resp.err_str, sizeof(resp.err_str),
> 			 "Invalid Page Table message: incomplete messsage");
> 		status = EINVAL;
> 		goto failed_respond;
> 	}
> 	debug_hexdump(&pgp->ptbl_buff, size, __func__);
> 
> 	/*
> 	 * Look for the corresponding switch context block to create or update
> 	 * the page table.
> 	 */
> 	rc = 0;
> 	dev = MKDEV(pgp->dev_major, pgp->dev_minor);
> 	spin_lock_irqsave(&__g_spinlock, flags);
> 	list_for_each_entry_safe(pctx, next, &__g_context_list, list) {
> 		if (dev == pctx->dev_this) {
> 			rc = 1;
> 			break;
> 		}
> 	}
> 	if (rc == 0) {
> 		snprintf(resp.err_str, sizeof(resp.err_str),
> 			 "%s: invalid target device %d:%d",
> 			 invmsg, pgp->dev_major, pgp->dev_minor);
> 		status = EINVAL;
> 		goto failed_unlock;
> 	}
> 	DBGPRINTV("%s ctx=0x%p (%d:%d)\n", __func__, pctx, pgp->dev_major,
> 		  pgp->dev_minor);
> 
> 	ptbl = pctx->ptbl;
> 	if (((ptbl != NULL) && (pgp->page_offset > (ptbl->ptbl_num + 1))) ||
> 	    ((ptbl == NULL) && (pgp->page_offset != 0))) {
> 		snprintf(resp.err_str, sizeof(resp.err_str),
> 			 "%s: missing entries", invmsg);
> 		status = EINVAL;
> 		goto failed_unlock;
> 	}
> 	/*
> 	 * Don't allow userland to change context parameters unless the page
> 	 * table is being rebuilt.
> 	 */
> 	if (pgp->page_offset != 0) {
> 		if ((pgp->dev_count) != pctx->dev_count) {
> 			snprintf(resp.err_str, sizeof(resp.err_str),
> 				 "%s: invalid device count %d",
> 				 invmsg, pgp->dev_count);
> 			status = EINVAL;
> 			goto failed_respond;
> 		}
> 		if (ptbl != NULL) {
> 			if (pgp->pte_bits != ptbl->pte_bits) {
> 				snprintf(resp.err_str, sizeof(resp.err_str),
> 					 "%s: number of bits changed", invmsg);
> 				status = EINVAL;
> 				goto failed_unlock;
> 			}
> 			if (pgp->page_total != ptbl->ptbl_max) {
> 				snprintf(resp.err_str, sizeof(resp.err_str),
> 					 "%s: total number of entries changed",
> 					 invmsg);
> 				status = EINVAL;
> 				goto failed_unlock;
> 			}
> 		}
> 	}
> 
> 	/*
> 	 * Create a Page Table if needed.  Most of the time, the size of the
> 	 * table doesn't change.  In that case, re-use the existing table.
> 	 */
> 	ptbl_bytes = ((pgp->page_total + pte_fields - 1) / pte_fields) *
> 	    sizeof(uint32_t);
> 	if ((ptbl != NULL) && (ptbl_bytes == ptbl->ptbl_bytes)) {
> 		pnew = ptbl;
> 	} else {
> 		pnew = kmalloc((sizeof(*pnew) + ptbl_bytes), GFP_KERNEL);
> 		if (pnew == NULL) {
> 			snprintf(resp.err_str, sizeof(resp.err_str),
> 				 "Cannot allocate Page Table");
> 			status = EINVAL;
> 			goto failed_unlock;
> 		}
> 		pnew->ptbl_bytes = ptbl_bytes;
> 		DBGPRINT("%s ctx=0x%p (%d:%d) pnew=0x%p, buff=0x%p (%d), OK\n",
> 			 __func__, pctx, MAJOR(pctx->dev_this),
> 			 MINOR(pctx->dev_this), pnew, pnew->ptbl_buff,
> 			 ptbl_bytes);
> 	}
> 	pnew->pte_bits = pgp->pte_bits;
> 	pnew->pte_mask = pte_mask;
> 	pnew->pte_fields = pte_fields;
> 	pnew->ptbl_max = pgp->page_total;
> 	pnew->ptbl_num = pgp->page_offset + pgp->page_count;
> 	DBGPRINT("%s ctx=0x%p (%d:%d): bits=%d, mask=0x%x, num=%d, max=%d\n",
> 		 __func__, pctx, MAJOR(pctx->dev_this),
> 		 MINOR(pctx->dev_this), pnew->pte_bits, pnew->pte_mask,
> 		 pnew->ptbl_num, pnew->ptbl_max);
> 	offset = (pgp->page_offset + pte_fields - 1) / pte_fields;
> 	memcpy(&pnew->ptbl_buff[offset], pgp->ptbl_buff, size);
> 	pctx->userland[0] = pgp->userland[0];
> 	pctx->userland[1] = pgp->userland[1];
> 
> 	if (pnew != ptbl) {
> 		rcu_assign_pointer(pctx->ptbl, pnew);
> 		kfree(ptbl);
> 	}
> 
> failed_unlock:
> 	spin_unlock_irqrestore(&__g_spinlock, flags);
> 
> failed_respond:
> 	if (status)
> 		printk(KERN_WARNING "%s WARNING: %s\n", __func__, resp.err_str);
> 	else
> 		resp.err_str[0] = '\0';
> 
> 	/* Format the response message */
> 	resp.total_len = sizeof(struct IpcResponse);
> 	resp.opcode = OPCODE_PAGE_TABLE_UPLOAD;
> 	resp.userland[0] = pgp->userland[0];
> 	resp.userland[1] = pgp->userland[1];
> 	resp.dev_major = pgp->dev_major;
> 	resp.dev_minor = pgp->dev_minor;
> 	resp.status = status;
> 	rc = nla_put(skb, NLA_BINARY, sizeof(struct IpcResponse), &resp);
> 	if (rc != 0) {
> 		printk(KERN_WARNING
> 		       "%s WARNING: Cannot format reply message\n", __func__);
> 		return 0;
> 	}
> 	genlmsg_end(skb, msg_head);
> 	rc = genlmsg_unicast(&init_net, skb, info->snd_pid);
> 	if (rc != 0)
> 		printk(KERN_WARNING "%s WARNING: Cannot send reply message\n",
> 		       __func__);
> 	return 0;
> }
> 
> /* Operation for getting the page table */
> static struct genl_ops __g_op_get_page_tbl = {
> 	.cmd = NETLINK_CMD_GET_PAGE_TBL,
> 	.flags = 0,
> 	.policy = __g_attr_policy,
> 	.doit = get_page_tbl,
> 	.dumpit = NULL,
> };
> 
> /*
>  * Use the sysfs interface to inform the userland process of the family id to
>  * be used by the Generic Netlink socket.
>  */
> static ssize_t sysfs_familyid_show(struct kobject *kobj,
> 				   struct attribute *attr, char *buff)
> {
> 	return snprintf(buff, PAGE_SIZE, "%d", __g_family.id);
> }
> 
> static ssize_t sysfs_familyid_store(struct kobject *kobj,
> 				    struct attribute *attr, const char *buff,
> 				    size_t size)
> {
> 	return size;
> }
> 
> struct _sysfs_attr_ops {
> 	const struct attribute attr;
> 	const struct sysfs_ops ops;
> };
> static const struct _sysfs_attr_ops __g_sysfs_familyid = {
> 	.attr = {"familyid", 0644},
> 	.ops = {&sysfs_familyid_show, &sysfs_familyid_store}
> };
> 
> int __init dm_switch_init(void)
> {
> 	int r;
> 
> 	DBGPRINTV("%s\n", __func__);
> 	spin_lock_init(&__g_spinlock);
> 	r = dm_register_target(&__g_switch_target);
> 	if (r) {
> 		DMERR("dm_register_target() failed %d", r);
> 		return r;
> 	}
> 
> 	/* Initialize Generic Netlink communications */
> 	r = genl_register_family(&__g_family);
> 	if (r) {
> 		DMERR("genl_register_family() failed");
> 		goto failed;
> 	}
> 	r = genl_register_ops(&__g_family, &__g_op_get_page_tbl);
> 	if (r) {
> 		DMERR("genl_register_ops(get_page_tbl) failed %d", r);
> 		goto failed;
> 	}
> 	DBGPRINTV("%s Registered Generic Netlink group %d\n", __func__,
> 		  __g_family.id);
> 	r = sysfs_create_file(&__g_switch_target.module->mkobj.kobj,
> 			      &__g_sysfs_familyid.attr);
> 	if (r) {
> 		DMERR("/sys/module/familyid create failed %d", r);
> 		goto failed;
> 	}
> 	return 0;
> 
> failed:
> 	dm_unregister_target(&__g_switch_target);
> 	return r;
> }
> 
> void dm_switch_exit(void)
> {
> 	int r;
> 
> 	DBGPRINTV("%s\n", __func__);
> 	dm_unregister_target(&__g_switch_target);
> 	r = genl_unregister_family(&__g_family);
> 	if (r)
> 		DMWARN("genl_unregister_family() failed %d", r);
> 	return;
> }
> 
> module_init(dm_switch_init);
> module_exit(dm_switch_exit);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
