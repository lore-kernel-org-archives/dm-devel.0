From: "Jason Shamberger" <Jason_Shamberger@Dell.com>
Subject: RFC: dm-switch target
Date: Fri, 25 Mar 2011 16:25:22 -0400
Message-ID: <86A3089001A44141B76B882059E7E53B029D9A04@M31.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6999254887217651604=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
Cc: Parind Shah <Parind_Shah@Dell.com>, Kevin O'Kelley <Kevin_OKelley@Dell.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============6999254887217651604==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CBEB2A.C44E831C"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBEB2A.C44E831C
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

We propose a new DM target, dm-switch, which can be used to efficiently
implement a mapping of IOs to underlying block devices in scenarios =
where there
are: (1) a large number of address regions, (2) a fixed size of these =
address
regions, (3) no pattern than allows for a compact description with =
something
like the dm-stripe target.

Motivation:

Dell EqualLogic and some other iSCSI storage arrays use a distributed =
frameless
architecture.  In this architecture, the storage group consists of a =
number of
distinct storage arrays ("members"), each having independent =
controllers, disk
storage and network adapters.  When a LUN is created it is spread across
multiple members.  The details of the spreading are hidden from =
initiators
connected to this storage system.  The storage group exposes a single =
target
discovery portal, no matter how many members are being used.  When iSCSI
sessions are created, each session is connected to an eth port on a =
single
member.  Data to a LUN can be sent on any iSCSI session, and if the =
blocks being
accessed are stored on another member the IO will be forwarded as =
required.
This forwarding is invisible to the initiator.  The storage layout is =
also
dynamic, and the blocks stored on disk may be moved from member to =
member as
needed to balance the load.

This architecture simplifies the management and configuration of both =
the
storage group and initiators.  In a multipathing configuration, it is =
possible
to set up multiple iSCSI sessions to use multiple network interfaces on =
both the
host and target to take advantage of the increased network bandwidth.  =
An
initiator can use a simple round robin algorithm to send IO on all paths =
and let
the storage array members forward it as necessary.  However, there is a
performance advantage to sending data directly to the correct member.  =
The
Device Mapper table architecture supports designating different address =
regions
with different targets.  However, in our architecture the LUN is spread =
with a
chunk size on the order of 10s of MBs, which means the resulting DM =
table could
have more than a million entries, which consumes too much memory.

Solution:

Based on earlier discussion with the dm-devel contributors, we have =
solved this
problem by using Device Mapper to build a two-layer device hierarchy:

    Upper Tier =96 Determine which array member the IO should be sent =
to.
    Lower Tier =96 Load balance amongst paths to a particular member.

The lower tier consists of a single multipath device for each member.  =
Each of
these multipath devices contains the set of paths directly to the array =
member
in one priority group, and leverages existing path selectors to load =
balance
amongst these paths.  We also build a non-preferred priority group =
containing
paths to other array members for failover reasons.

The upper tier consists of a single switch device, using the new DM =
target
module proposed here.  This device uses a bitmap to look up the location =
of the
IO and choose the appropriate lower tier device to route the IO.  By =
using a
bitmap we are able to use 4 bits for each address range in a 16 member =
group
(which is very large for us).  This is a much denser representation than =
the DM
table B-tree can achieve.

Though we have developed this target for a specific storage device, we =
have made
an effort to keep it a general purpose as possible in hopes that others =
may
benefit.  We welcome any feedback on the design or implementation.

/*
 =
*************************************************************************=
*******
 *
 * Copyright (c) 2010 by Dell, Inc.
 *
 * All rights reserved.  This software may not be copied, disclosed,
 * transferred, or used except in accordance with a license granted
 * by Dell, Inc.  This software embodies proprietary information
 * and trade secrets of Dell, Inc.=20
 *
 * Description:
 *
 *     file:    dm-switch.h
 *     authors: Kevin_OKelley@dell.com and Narendran_Ganapathy@dell.com
 *
 * This file contains the definitions for the "switch" target - =
particularly
 * the netlink messages.
 *
 =
*************************************************************************=
*******
 */
/*
 * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
 * Copyright (C) 2004-2008 Red Hat Inc.  All rights reserved.
 *
 * This file is released under the GPL.
 */

#ifndef __DM_SWITCH_H
#define __DM_SWITCH_H

#define	MAX_IPC_MSG_LEN			65480			// dictated by netlink socket
#define MAX_ERR_STR_LEN			255				// maximum length of the error string

typedef enum Opcode_Enum=20
{
    OPCODE_PAGE_TABLE_UPLOAD =3D 1,
}
Opcode_t;

/*
 * IPC Page Table message
 */
typedef struct IpcPgTable_Struct=20
{
	uint32_t	total_len; 						// Total length of this IPC message
	Opcode_t	opcode;
	uint32_t	userland[2];					// Userland optional data (dmsetup status)
	uint32_t    dev_major;						// DM device major
	uint32_t    dev_minor;						// DM device minor
	uint32_t	page_total;						// Total pages in the volume
	uint32_t	page_offset;					// Starting page offset for this IPC
	uint32_t	page_count;						// Number of page table entries in this IPC
	uint32_t	page_size;						// Page size in 512B sectors
	uint16_t	dev_count;						// Number of devices
	uint8_t		pte_bits;						// Page Table Entry field size in bits
	uint8_t		reserved;						// Integer alignment=20
	uint8_t		ptbl_buff[1]; 					// Page table entries (variable length)
}
IpcPgTable_t;

/*
 * IPC Response message
 */
typedef struct IpcResponse_Struct=20
{
	uint32_t	total_len;				 		// total length of the IPC
	Opcode_t	opcode;
	uint32_t	userland[2];					// Userland optional data
	uint32_t    dev_major;						// DM device major
	uint32_t    dev_minor;						// DM device minor
	uint32_t	status;
	char		err_str[MAX_ERR_STR_LEN+1];
}
IpcResponse_t;

// Generic Netlink family attributes: used to define the family
enum=20
{
    NETLINK_ATTR_UNSPEC,
    NETLINK_ATTR_MSG,
    NETLINK_ATTR__MAX,
};
#define NETLINK_ATTR_MAX (NETLINK_ATTR__MAX - 1)

// Netlink commands (operations)
enum=20
{
    NETLINK_CMD_UNSPEC,
    NETLINK_CMD_GET_PAGE_TBL,
    NETLINK_CMD__MAX,
};
#define NETLINK_CMD_MAX (NETLINK_CMD__MAX - 1)

#endif  /* __DM_SWITCH_H */

/*
 =
*************************************************************************=
*******
 *
 * Copyright (c) 2010-2011 by Dell, Inc.
 *
 * All rights reserved.  This software may not be copied, disclosed,
 * transferred, or used except in accordance with a license granted
 * by Dell, Inc.  This software embodies proprietary information
 * and trade secrets of Dell, Inc.=20
 *
 * Description:
 *
 *     file:    dm-switch.c
 *     authors: Kevin_OKelley@dell.com and Narendran_Ganapathy@dell.com
 *
 * This file contains all the functions to create a "switch" target to=20
 * separate the MPIO to the preferred block mode devices.
 *
 =
*************************************************************************=
*******
 */
/*
 * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
 * Copyright (C) 2004-2008 Red Hat Inc.  All rights reserved.
 *
 * This file is released under the GPL.
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
#include <net/genetlink.h>
#include <asm/div64.h>

#include "dm-switch.h"

#define DM_MSG_PREFIX "switch"
MODULE_DESCRIPTION(DM_NAME " throughput-oriented path selector");
MODULE_AUTHOR("Kevin D. O'Kelley <Kevin_OKelley@dell.com>");
MODULE_LICENSE("GPL");

/*
 * Switch context block: A new one is created for each dm device.  =
Contains an array of devices
 * that we have taken references.
 */
struct switch_dev {
	struct dm_dev *dmdev;
	sector_t	start;
	atomic_t	error_count;
};

struct switch_ptbl {
	uint32_t	pte_bits;						// Page Table Entry field size in bits
	uint32_t	pte_mask;						// Page Table Entry field mask
	uint32_t	pte_fields;						// Number of Page Table Entries per uint32_t
	uint32_t	ptbl_bytes;						// Page table size in bytes
	uint32_t	ptbl_num;						// Page table size in entries
	uint32_t	ptbl_max;						// Page table maximum size in entries;
	uint32_t	ptbl_buff[0];					// Address of page table
};

struct switch_ctx {
	struct list_head list;
	dev_t		dev_this;						// Device serviced by this target
	uint32_t	dev_count;						// Number of devices
	uint32_t	page_size;						// Page size in 512B sectors
	uint32_t	userland[2];					// Userland optional data (dmsetup status)
	uint64_t	ios_remapped, ios_unmapped;		// I/Os remapped, I/Os not =
remapped=20
	spinlock_t	spinlock;						// Control access to counters

	struct switch_ptbl *ptbl;					// Page table (if loaded)
	struct switch_dev dev_list[0];				// Array of dm devices to switch =
between
};

/*
 * Global variables
 */
LIST_HEAD(__g_context_list);					// Linked list of context blocks
static spinlock_t __g_spinlock;                 // Control access to =
list of context blocks

static int switch_ctr_limits(struct dm_target *ti, struct dm_dev *dm)
{
	struct block_device *sd =3D dm->bdev;
	struct hd_struct *hd =3D sd->bd_part;

	if (hd !=3D NULL) {
		if (ti->len <=3D hd->nr_sects)
			return true;
		ti->error =3D "Device too small for target";
		return false;
	}

	ti->error =3D "Missing device limits";
	printk("%s %s\n", __FUNCTION__, ti->error);
	return true;
}

/*
 * Constructor: Called each time a dmsetup command creates a dm device.  =
The target parameter will already
 * have the table, type, begin and len fields filled in.  Arguments are =
in pairs: <dev_path> <offset>.
 * Therefore, we get multiple constructor calls, but we will need to =
build a list of switch_ctx blocks so
 * that the page table information gets matched to the correct device.
 */
static int switch_ctr(struct dm_target *ti, unsigned int argc, char =
**argv)
{
	int n;
	unsigned int dev_count;
	unsigned long flags, major, minor;
	unsigned long long start;
	struct switch_ctx *pctx;
	struct mapped_device *md =3D NULL;
	struct dm_dev *dm;
	char *chp;

	if (argc < 4) {
		ti->error =3D "Insufficient arguments";
		return -EINVAL;
	}
	dev_count =3D simple_strtoul(argv[0], &chp, 10);
	if (*chp) {
		ti->error =3D "Invalid device count";
		return -EINVAL;
	}
	if (dev_count !=3D (argc - 2) / 2) {
		ti->error =3D "Invalid argument count";
		return -EINVAL;
	}
	pctx =3D kmalloc(sizeof(*pctx) + (dev_count * sizeof(struct =
switch_dev)), GFP_KERNEL);
	if (pctx =3D=3D NULL) {
		ti->error =3D "Cannot allocate redirect context";
		return -ENOMEM;
	}
	pctx->dev_count =3D dev_count;
	pctx->page_size =3D simple_strtoul(argv[1], &chp, 10);
	if ((*chp) || (pctx->page_size =3D=3D 0)) {
		ti->error =3D "Invalid page size";
		goto failed_kfree;
	}
	pctx->ptbl =3D NULL;
	pctx->userland[0] =3D pctx->userland[1] =3D 0;
	pctx->ios_remapped =3D pctx->ios_unmapped =3D0;
	spin_lock_init(&pctx->spinlock);

	/*
	 * Find the device major and minor for the device that is being served =
by this target.
	 */
	md =3D dm_table_get_md(ti->table);
	if (md =3D=3D NULL) {
		ti->error =3D "Cannot locate dm device";
		goto failed_kfree;
	}
	chp =3D (char *) dm_device_name(md);
	if (chp =3D=3D NULL) {
		ti->error =3D "Cannot acquire dm device name";
		goto failed_kfree;
	}
	major =3D simple_strtoul(chp, &chp, 10);
	if (*chp++ !=3D ':') {
		ti->error =3D "Invalid dm device name (major)";
		goto failed_kfree;
	}
	minor =3D simple_strtoul(chp, &chp, 10);
	if (*chp) {
		ti->error =3D "Invalid dm device name (minor)";
		goto failed_kfree;
	}
	pctx->dev_this =3D MKDEV(major, minor);
=20
	/*
	 * Check each device beneath the target to ensure that the limits are =
consistent.
	 */
	for (n =3D 0, argc =3D 2; n < pctx->dev_count; n++, argc +=3D 2) {
		if (sscanf(argv[argc + 1], "%llu", &start) !=3D 1) {
			ti->error =3D "Invalid device starting offset";
			goto failed_dev_list_prev;
		}
		if (dm_get_device(ti, argv[argc], dm_table_get_mode(ti->table), &dm)) =
{
			ti->error =3D "Device lookup failed";
			goto failed_dev_list_prev;
		}
		pctx->dev_list[n].dmdev =3D dm;
		pctx->dev_list[n].start =3D start;
		atomic_set(&(pctx->dev_list[n].error_count), 0);
		if (!switch_ctr_limits(ti, dm))
			goto failed_dev_list_all;
	}

	spin_lock_irqsave(&__g_spinlock, flags);
	list_add_tail(&pctx->list, &__g_context_list);=20
	spin_unlock_irqrestore(&__g_spinlock, flags);
	ti->private =3D pctx;
	return 0;

failed_dev_list_prev:							// De-reference previous devices
	n--;										//   (i.e. don't include this one)
failed_dev_list_all:							// De-reference all devices=20
	printk("%s device=3D%s, start=3D%s\n", __FUNCTION__, argv[argc], =
argv[argc + 1]);
	for (; n >=3D 0; n--) {
		dm_put_device(ti, pctx->dev_list[n].dmdev);
	}

failed_kfree:
	printk(KERN_WARNING "%s %s\n", __FUNCTION__, ti->error);
	kfree(pctx);
	return -EINVAL;
}

/*
 * Destructor: Don't free the dm_target, just the ti->private data (if =
any).
 */
static void switch_dtr(struct dm_target *ti)
{
	int n;
	unsigned long flags;
	struct switch_ctx *pctx =3D (struct switch_ctx *) ti->private;
	void *ptbl;

	spin_lock_irqsave(&__g_spinlock, flags);
	ptbl =3D pctx->ptbl;
	rcu_assign_pointer(pctx->ptbl, NULL);
	list_del(&pctx->list);
	spin_unlock_irqrestore(&__g_spinlock, flags);
	for (n =3D 0; n < pctx->dev_count; n++) {
		dm_put_device(ti, pctx->dev_list[n].dmdev);
	}
	synchronize_rcu();
	if (ptbl)
		kfree(ptbl);
	kfree(pctx);
}

/*
 * NOTE: If CONFIG_LBD is disabled, sector_t types are uint32_t.  =
Therefore, in this routine, we
 * convert the offset into a uint64_t instead of a sector_t so that all =
of the remaining arithmatic
 * is correct, including the do_div() calls.=20
 */
static int switch_map(struct dm_target *ti, struct bio *bio,
		union map_info *map_context)
{
	struct switch_ctx *pctx =3D (struct switch_ctx *) ti->private;
	struct switch_ptbl *ptbl;
	unsigned long flags;
	uint64_t itbl, offset =3D bio->bi_sector - ti->begin;
	uint32_t idev =3D 0, irem;
	uint64_t *pinc =3D &pctx->ios_unmapped;

	rcu_read_lock();
	ptbl =3D rcu_dereference(pctx->ptbl);
	if (ptbl !=3D NULL)
	{
		itbl =3D offset;
		do_div(itbl, pctx->page_size);
		if (itbl < ptbl->ptbl_num) {
			irem =3D do_div(itbl, ptbl->pte_fields);
			idev =3D (ptbl->ptbl_buff[itbl] >> (irem * ptbl->pte_bits))=20
				& ptbl->pte_mask;
			if (idev <=3D pctx->dev_count) {
				pinc =3D &pctx->ios_remapped;
			}
			else {
				printk(KERN_WARNING "%s dev=3D%d, offset=3D%lld\n", __FUNCTION__, =
idev, offset);
				idev =3D 0;
			}
		}
		else {
			printk(KERN_WARNING "%s Page Table Entry %lld >=3D %d\n", =
__FUNCTION__,=20
					itbl, ptbl->ptbl_num);
		}
	}
	rcu_read_unlock();
	spin_lock_irqsave(&pctx->spinlock, flags);
	(*pinc)++;
	spin_unlock_irqrestore(&pctx->spinlock, flags);
	bio->bi_bdev =3D pctx->dev_list[idev].dmdev->bdev;
	bio->bi_sector =3D pctx->dev_list[idev].start + offset;
	return DM_MAPIO_REMAPPED;
}

/*
 * Switch status:
 *
 * INFO: #dev_count device [device] 5 'A'['A' ...] userland[0] =
userland[1] #remapped #unmapped
 * where:
 *   "'A'['A']" is a single word with an 'A' (active) or 'D' for each =
device
 *   The userland values are set by the last userland message to load =
the page table
 *   "#remapped" is the number of remapped I/Os=20
 *   "#unmapped" is the number of I/Os that could not be remapped=20
 *
 * TABLE: #page_size #dev_count device start [device start ...]
 */
static int switch_status(struct dm_target *ti, status_type_t type, char =
*result,=20
		unsigned int maxlen)
{
	struct switch_ctx *pctx =3D (struct switch_ctx *) ti->private;
	char buffer[pctx->dev_count + 1];
	unsigned int sz =3D 0;
	int n;
	uint64_t remapped, unmapped;
	unsigned long flags;

	result[0] =3D '\0';
	switch (type) {
		case STATUSTYPE_INFO:
			DMEMIT("%d", pctx->dev_count);
			for (n =3D 0; n < pctx->dev_count; n++)  {
				DMEMIT(" %s", pctx->dev_list[n].dmdev->name);
				buffer[n] =3D 'A';
			}
			buffer[n] =3D '\0';
			spin_lock_irqsave(&pctx->spinlock, flags);
			remapped =3D pctx->ios_remapped;
			unmapped =3D pctx->ios_unmapped;
			spin_unlock_irqrestore(&pctx->spinlock, flags);
			DMEMIT(" 5 %s %08x %08x %lld %lld", buffer, pctx->userland[0], =
pctx->userland[1],
					remapped, unmapped);
			break;

		case STATUSTYPE_TABLE:
			DMEMIT("%d %d", pctx->dev_count, pctx->page_size);
			for (n =3D 0; n < pctx->dev_count; n++)  {
				DMEMIT(" %s %llu", pctx->dev_list[n].dmdev->name,
						(unsigned long long) pctx->dev_list[n].start);
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
	struct switch_ctx *pctx =3D (struct switch_ctx *) ti->private;
	struct block_device *bdev;
	fmode_t mode =3D 0;
=09
	/* Sanity check */
	if (unlikely(!pctx || !pctx->dev_list[0].dmdev ||
			!pctx->dev_list[0].dmdev->bdev))
		return -EIO;

	bdev =3D pctx->dev_list[0].dmdev->bdev;
	mode =3D pctx->dev_list[0].dmdev->mode;
	return __blkdev_driver_ioctl(bdev, mode, cmd, arg);
}

static struct target_type __g_switch_target =3D {
	.name   =3D "switch",
	.version=3D {1, 0, 0},
	.module =3D THIS_MODULE,
	.ctr    =3D switch_ctr,
	.dtr    =3D switch_dtr,
	.map    =3D switch_map,
	.status =3D switch_status,
	.ioctl  =3D switch_ioctl,
};

// Generic Netlink attribute policy (single attribute, NETLINK_ATTR_MSG)
static struct nla_policy __g_attr_policy[NETLINK_ATTR_MAX + 1] =3D=20
{=20
	[NETLINK_ATTR_MSG] =3D { .type =3D NLA_BINARY, .len =3D MAX_IPC_MSG_LEN =
},
};

// Define the Generic Netlink family
static struct genl_family __g_family =3D=20
{=20
	.id 		=3D GENL_ID_GENERATE,				// Assign channel when family is =
registered
	.hdrsize 	=3D 0,
	.name		=3D "DM_SWITCH",
	.version 	=3D 1,
	.maxattr 	=3D NETLINK_ATTR_MAX,
};

/*=20
 * Generic Netlink socket read function that handles communication from =
the userland=20
 * for downloading the page table.
 */
static int get_page_tbl(struct sk_buff *skb_2, struct genl_info *info)
{
	uint32_t			rc, pte_mask, pte_fields, ptbl_bytes, offset, size;
	uint32_t			status =3D 0;
	unsigned long		flags;
	char 				*mydata;
	void				*msg_head;
	struct nlattr		*na;
	struct sk_buff		*skb;
	struct switch_ctx	*pctx, *next;
	struct switch_ptbl	*ptbl, *pnew;
	IpcPgTable_t		*pgp;
	IpcResponse_t		resp;
	dev_t				dev;
	static const char	*invmsg =3D "Invalid Page Table message";

	/*
	 * For each attribute there is an index in info->attrs which points to =
a nlattr structure
	 * in this structure the data is given
	 */
	if (info =3D=3D NULL) {
		printk(KERN_ERR "%s missing genl_info parameter\n", __FUNCTION__);
		return 0;
	}=09
	na =3D info->attrs[NETLINK_ATTR_MSG];
	if (na =3D=3D NULL) {
		printk(KERN_ERR "%s no info->attrs %i\n", __FUNCTION__, =
NETLINK_ATTR_MSG);
		return 0;
	}
	mydata =3D (char *) nla_data(na);
	if (mydata =3D=3D NULL) {
		printk(KERN_ERR "%s error while receiving data\n", __FUNCTION__);
		return 0;
	}

	/*
	 * Format the reply message.  Return positve error codes to userland.
	 */
	skb =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
	if (skb =3D=3D NULL) {
		printk(KERN_ERR "%s cannot allocate reply message\n", __FUNCTION__);
		return 0;
	}
	msg_head =3D genlmsg_put(skb, 0, info->snd_seq, &__g_family, 0, =
NETLINK_CMD_GET_PAGE_TBL);
	if (skb =3D=3D NULL) {
		printk(KERN_ERR "%s cannot format reply message header\n", =
__FUNCTION__);
		return 0;
	}
	pgp =3D (IpcPgTable_t *) mydata;
	if (na->nla_len < sizeof(IpcPgTable_t)) {
		snprintf(resp.err_str, sizeof(resp.err_str), "%s: too short (%d)", =
invmsg, na->nla_len);
		status =3D EINVAL;
		goto failed_respond;
	}
	if ((pgp->page_offset + pgp->page_count) > pgp->page_total) {
		snprintf(resp.err_str, sizeof(resp.err_str), "%s: too many page table =
entries (%d > %d)",=20
				invmsg, (pgp->page_offset + pgp->page_count), pgp->page_total);
		status =3D EINVAL;
		goto failed_respond;
	}
	pte_mask =3D (1 << pgp->pte_bits) - 1;
	if (((pgp->dev_count - 1) & (~pte_mask)) !=3D 0) {
		snprintf(resp.err_str, sizeof(resp.err_str), "%s: invalid mask 0x%x =
for %d devices",=20
				invmsg, pte_mask, pgp->dev_count);
		status =3D EINVAL;
		goto failed_respond;
	}
	pte_fields =3D 32 / pgp->pte_bits;
	size =3D ((pgp->page_count + pte_fields - 1) / pte_fields) * =
sizeof(uint32_t);
	if ((sizeof(*pgp) - 1 + size) > na->nla_len) {=20
		snprintf(resp.err_str, sizeof(resp.err_str), "Invalid Page Table =
message: incomplete messsage");
		status =3D EINVAL;
		goto failed_respond;
	}

	// Look for the corresponding switch context block to create or update =
the page table.
	rc =3D 0;
	dev =3D MKDEV(pgp->dev_major, pgp->dev_minor);
	spin_lock_irqsave(&__g_spinlock, flags);
	list_for_each_entry_safe(pctx, next, &__g_context_list, list) {
		if (dev =3D=3D pctx->dev_this) {
			rc =3D 1;
			break;
		}
	}
	if (rc =3D=3D 0) {
		snprintf(resp.err_str, sizeof(resp.err_str), "%s: invalid target =
device %d:%d",
				invmsg, pgp->dev_major, pgp->dev_minor);
		status =3D EINVAL;
		goto failed_unlock;
	}

	ptbl =3D pctx->ptbl;
	if (  ( (ptbl !=3D NULL) && (pgp->page_offset > (ptbl->ptbl_num + 1)) ) =
||=20
	      ( (ptbl =3D=3D NULL) && (pgp->page_offset !=3D 0) )  ) {
		snprintf(resp.err_str, sizeof(resp.err_str), "%s: missing entries", =
invmsg);
		status =3D EINVAL;
		goto failed_unlock;
	}
	//  Don't allow userland to change context parameters unless the page =
table is being rebuilt.
	if (pgp->page_offset !=3D 0) {
		if ((pgp->dev_count) !=3D pctx->dev_count) {
			snprintf(resp.err_str, sizeof(resp.err_str), "%s: invalid device =
count %d",=20
					invmsg, pgp->dev_count);
			status =3D EINVAL;
			goto failed_respond;
		}
		if (ptbl !=3D NULL) {
			if (pgp->pte_bits !=3D ptbl->pte_bits) {=20
				snprintf(resp.err_str, sizeof(resp.err_str), "%s: number of bits =
changed", invmsg);
				status =3D EINVAL;
				goto failed_unlock;
			}
			if (pgp->page_total !=3D ptbl->ptbl_max) {=20
				snprintf(resp.err_str, sizeof(resp.err_str), "%s: total number of =
entries changed", invmsg);
				status =3D EINVAL;
				goto failed_unlock;
			}
		}
	}

	// Create a Page Table if needed.  Most of the time, the size of the =
table
	// doesn't change.  In that case, re-use the existing table.
	ptbl_bytes =3D ((pgp->page_total + pte_fields - 1) / pte_fields) * =
sizeof(uint32_t);
	if ((ptbl !=3D NULL) && (ptbl_bytes =3D=3D ptbl->ptbl_bytes)) {
		pnew =3D ptbl;
	}
	else {
		pnew =3D kmalloc((sizeof(*pnew) + ptbl_bytes), GFP_KERNEL);
		if (pnew =3D=3D NULL) {
			snprintf(resp.err_str, sizeof(resp.err_str), "Cannot allocate Page =
Table");
			status =3D EINVAL;
			goto failed_unlock;
		}
		pnew->ptbl_bytes =3D ptbl_bytes;
	}
	pnew->pte_bits =3D pgp->pte_bits;
	pnew->pte_mask =3D pte_mask;
	pnew->pte_fields =3D pte_fields;
	pnew->ptbl_max =3D pgp->page_total;
	pnew->ptbl_num =3D pgp->page_offset + pgp->page_count;
	offset =3D (pgp->page_offset + pte_fields - 1) / pte_fields;
	memcpy(&pnew->ptbl_buff[offset], pgp->ptbl_buff, size);
	pctx->userland[0] =3D pgp->userland[0];
	pctx->userland[1] =3D pgp->userland[1];

	if (pnew !=3D ptbl) {
		rcu_assign_pointer(pctx->ptbl, pnew);
		if (ptbl !=3D NULL)
			kfree(ptbl);
	}

failed_unlock:
	spin_unlock_irqrestore(&__g_spinlock, flags);

failed_respond:
	if (status !=3D 0)
		printk("%s WARNING: %s\n", __FUNCTION__, resp.err_str);

	// Format the response message
	resp.total_len =3D sizeof(IpcResponse_t);
	resp.opcode =3D OPCODE_PAGE_TABLE_UPLOAD;
	resp.userland[0] =3D pgp->userland[0];
	resp.userland[1] =3D pgp->userland[1];
	resp.dev_major =3D pgp->dev_major;
	resp.dev_minor =3D pgp->dev_minor;
	resp.status =3D status;
	rc =3D nla_put(skb, NLA_BINARY, sizeof(IpcResponse_t), &resp);
	if( rc !=3D 0 ) {
		printk("%s WARNING: Cannot format reply message\n", __FUNCTION__);
		return 0;
	}
	genlmsg_end(skb, msg_head);
	rc =3D genlmsg_unicast(&init_net, skb, info->snd_pid);=09
	if( rc !=3D 0 ) {
		printk("%s WARNING: Cannot send reply message\n", __FUNCTION__);
		return 0;
	}
	return 0;
}

// Operation for getting the page table
static struct genl_ops __g_op_get_page_tbl =3D=20
{
	.cmd 	=3D NETLINK_CMD_GET_PAGE_TBL,
	.flags 	=3D 0,
	.policy =3D __g_attr_policy,
	.doit 	=3D get_page_tbl,
	.dumpit =3D NULL,
};

/*
 * Use the sysfs interface to inform the userland process of the family =
id to be used=20
 * by the Generic Netlink socket.
 */
static ssize_t sysfs_familyid_show(struct kobject *kobj, struct =
attribute *attr, char *buff)
{
	return snprintf(buff, PAGE_SIZE, "%d", __g_family.id);
}

static ssize_t sysfs_familyid_store(struct kobject *kobj, struct =
attribute *attr,=20
		const char *buff, size_t size)
{
	return size;
}

static struct {
	struct attribute attr;
	struct sysfs_ops ops;
}
__g_sysfs_familyid =3D {
	{ "familyid", 0644 },
	{ &sysfs_familyid_show, &sysfs_familyid_store },=20
};

int __init dm_switch_init(void)
{
	int r;

	spin_lock_init(&__g_spinlock);
	r =3D dm_register_target(&__g_switch_target);
	if (r) {
		DMERR("dm_register_target() failed %d", r);
		return r;
	}

	// Initialize Generic Netlink communications
	r =3D genl_register_family(&__g_family);
	if (r) {
		DMERR("genl_register_family() failed");
		goto failed;
	}
	r =3D genl_register_ops(&__g_family, &__g_op_get_page_tbl);
	if (r) {
		DMERR("genl_register_ops(get_page_tbl) failed %d", r);
		goto failed;
	}
	r =3D sysfs_create_file(&__g_switch_target.module->mkobj.kobj, =
&__g_sysfs_familyid.attr);
	if (r) {
		DMERR("/sys/module/familyid create failed %d", r);
		goto failed;
	}
	return 0;
=09
failed:
	dm_unregister_target(&__g_switch_target);
	return r;
}

void dm_switch_exit(void)
{
	int r;

	dm_unregister_target(&__g_switch_target);
	r =3D genl_unregister_family(&__g_family);
	if (r)
		DMWARN("genl_unregister_family() failed %d", r);
	return;
}

module_init(dm_switch_init);
module_exit(dm_switch_exit);

------_=_NextPart_001_01CBEB2A.C44E831C
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7654.12">
<TITLE>RFC: dm-switch target</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>We propose a new DM target, dm-switch, which can be =
used to efficiently<BR>
implement a mapping of IOs to underlying block devices in scenarios =
where there<BR>
are: (1) a large number of address regions, (2) a fixed size of these =
address<BR>
regions, (3) no pattern than allows for a compact description with =
something<BR>
like the dm-stripe target.<BR>
<BR>
Motivation:<BR>
<BR>
Dell EqualLogic and some other iSCSI storage arrays use a distributed =
frameless<BR>
architecture.&nbsp; In this architecture, the storage group consists of =
a number of<BR>
distinct storage arrays (&quot;members&quot;), each having independent =
controllers, disk<BR>
storage and network adapters.&nbsp; When a LUN is created it is spread =
across<BR>
multiple members.&nbsp; The details of the spreading are hidden from =
initiators<BR>
connected to this storage system.&nbsp; The storage group exposes a =
single target<BR>
discovery portal, no matter how many members are being used.&nbsp; When =
iSCSI<BR>
sessions are created, each session is connected to an eth port on a =
single<BR>
member.&nbsp; Data to a LUN can be sent on any iSCSI session, and if the =
blocks being<BR>
accessed are stored on another member the IO will be forwarded as =
required.<BR>
This forwarding is invisible to the initiator.&nbsp; The storage layout =
is also<BR>
dynamic, and the blocks stored on disk may be moved from member to =
member as<BR>
needed to balance the load.<BR>
<BR>
This architecture simplifies the management and configuration of both =
the<BR>
storage group and initiators.&nbsp; In a multipathing configuration, it =
is possible<BR>
to set up multiple iSCSI sessions to use multiple network interfaces on =
both the<BR>
host and target to take advantage of the increased network =
bandwidth.&nbsp; An<BR>
initiator can use a simple round robin algorithm to send IO on all paths =
and let<BR>
the storage array members forward it as necessary.&nbsp; However, there =
is a<BR>
performance advantage to sending data directly to the correct =
member.&nbsp; The<BR>
Device Mapper table architecture supports designating different address =
regions<BR>
with different targets.&nbsp; However, in our architecture the LUN is =
spread with a<BR>
chunk size on the order of 10s of MBs, which means the resulting DM =
table could<BR>
have more than a million entries, which consumes too much memory.<BR>
<BR>
Solution:<BR>
<BR>
Based on earlier discussion with the dm-devel contributors, we have =
solved this<BR>
problem by using Device Mapper to build a two-layer device =
hierarchy:<BR>
<BR>
&nbsp;&nbsp;&nbsp; Upper Tier &#150; Determine which array member the IO =
should be sent to.<BR>
&nbsp;&nbsp;&nbsp; Lower Tier &#150; Load balance amongst paths to a =
particular member.<BR>
<BR>
The lower tier consists of a single multipath device for each =
member.&nbsp; Each of<BR>
these multipath devices contains the set of paths directly to the array =
member<BR>
in one priority group, and leverages existing path selectors to load =
balance<BR>
amongst these paths.&nbsp; We also build a non-preferred priority group =
containing<BR>
paths to other array members for failover reasons.<BR>
<BR>
The upper tier consists of a single switch device, using the new DM =
target<BR>
module proposed here.&nbsp; This device uses a bitmap to look up the =
location of the<BR>
IO and choose the appropriate lower tier device to route the IO.&nbsp; =
By using a<BR>
bitmap we are able to use 4 bits for each address range in a 16 member =
group<BR>
(which is very large for us).&nbsp; This is a much denser representation =
than the DM<BR>
table B-tree can achieve.<BR>
<BR>
Though we have developed this target for a specific storage device, we =
have made<BR>
an effort to keep it a general purpose as possible in hopes that others =
may<BR>
benefit.&nbsp; We welcome any feedback on the design or =
implementation.<BR>
<BR>
/*<BR>
&nbsp;*******************************************************************=
*************<BR>
&nbsp;*<BR>
&nbsp;* Copyright (c) 2010 by Dell, Inc.<BR>
&nbsp;*<BR>
&nbsp;* All rights reserved.&nbsp; This software may not be copied, =
disclosed,<BR>
&nbsp;* transferred, or used except in accordance with a license =
granted<BR>
&nbsp;* by Dell, Inc.&nbsp; This software embodies proprietary =
information<BR>
&nbsp;* and trade secrets of Dell, Inc.<BR>
&nbsp;*<BR>
&nbsp;* Description:<BR>
&nbsp;*<BR>
&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp; file:&nbsp;&nbsp;&nbsp; dm-switch.h<BR>
&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp; authors: Kevin_OKelley@dell.com and =
Narendran_Ganapathy@dell.com<BR>
&nbsp;*<BR>
&nbsp;* This file contains the definitions for the &quot;switch&quot; =
target - particularly<BR>
&nbsp;* the netlink messages.<BR>
&nbsp;*<BR>
&nbsp;*******************************************************************=
*************<BR>
&nbsp;*/<BR>
/*<BR>
&nbsp;* Copyright (C) 2001-2003 Sistina Software (UK) Limited.<BR>
&nbsp;* Copyright (C) 2004-2008 Red Hat Inc.&nbsp; All rights =
reserved.<BR>
&nbsp;*<BR>
&nbsp;* This file is released under the GPL.<BR>
&nbsp;*/<BR>
<BR>
#ifndef __DM_SWITCH_H<BR>
#define __DM_SWITCH_H<BR>
<BR>
#define MAX_IPC_MSG_LEN &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 65480&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // dictated by netlink =
socket<BR>
#define MAX_ERR_STR_LEN &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // maximum length of the =
error string<BR>
<BR>
typedef enum Opcode_Enum<BR>
{<BR>
&nbsp;&nbsp;&nbsp; OPCODE_PAGE_TABLE_UPLOAD =3D 1,<BR>
}<BR>
Opcode_t;<BR>
<BR>
/*<BR>
&nbsp;* IPC Page Table message<BR>
&nbsp;*/<BR>
typedef struct IpcPgTable_Struct<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; total_len; =
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Total length of this IPC =
message<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Opcode_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; opcode;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
userland[2];&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Userland optional data =
(dmsetup status)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t&nbsp;&nbsp;&nbsp; =
dev_major;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // DM device major<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t&nbsp;&nbsp;&nbsp; =
dev_minor;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // DM device minor<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
page_total;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Total pages in the =
volume<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
page_offset;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Starting page offset for =
this IPC<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
page_count;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Number of page table =
entries in this IPC<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
page_size;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page size in 512B =
sectors<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint16_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
dev_count;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Number of devices<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint8_t =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pte_bits;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page Table Entry field =
size in bits<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint8_t =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
reserved;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Integer alignment<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint8_t =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ptbl_buff[1]; &nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page table entries =
(variable length)<BR>
}<BR>
IpcPgTable_t;<BR>
<BR>
/*<BR>
&nbsp;* IPC Response message<BR>
&nbsp;*/<BR>
typedef struct IpcResponse_Struct<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
total_len;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // total length of the =
IPC<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Opcode_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; opcode;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
userland[2];&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Userland optional data<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t&nbsp;&nbsp;&nbsp; =
dev_major;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // DM device major<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t&nbsp;&nbsp;&nbsp; =
dev_minor;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // DM device minor<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
err_str[MAX_ERR_STR_LEN+1];<BR>
}<BR>
IpcResponse_t;<BR>
<BR>
// Generic Netlink family attributes: used to define the family<BR>
enum<BR>
{<BR>
&nbsp;&nbsp;&nbsp; NETLINK_ATTR_UNSPEC,<BR>
&nbsp;&nbsp;&nbsp; NETLINK_ATTR_MSG,<BR>
&nbsp;&nbsp;&nbsp; NETLINK_ATTR__MAX,<BR>
};<BR>
#define NETLINK_ATTR_MAX (NETLINK_ATTR__MAX - 1)<BR>
<BR>
// Netlink commands (operations)<BR>
enum<BR>
{<BR>
&nbsp;&nbsp;&nbsp; NETLINK_CMD_UNSPEC,<BR>
&nbsp;&nbsp;&nbsp; NETLINK_CMD_GET_PAGE_TBL,<BR>
&nbsp;&nbsp;&nbsp; NETLINK_CMD__MAX,<BR>
};<BR>
#define NETLINK_CMD_MAX (NETLINK_CMD__MAX - 1)<BR>
<BR>
#endif&nbsp; /* __DM_SWITCH_H */<BR>
<BR>
/*<BR>
&nbsp;*******************************************************************=
*************<BR>
&nbsp;*<BR>
&nbsp;* Copyright (c) 2010-2011 by Dell, Inc.<BR>
&nbsp;*<BR>
&nbsp;* All rights reserved.&nbsp; This software may not be copied, =
disclosed,<BR>
&nbsp;* transferred, or used except in accordance with a license =
granted<BR>
&nbsp;* by Dell, Inc.&nbsp; This software embodies proprietary =
information<BR>
&nbsp;* and trade secrets of Dell, Inc.<BR>
&nbsp;*<BR>
&nbsp;* Description:<BR>
&nbsp;*<BR>
&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp; file:&nbsp;&nbsp;&nbsp; dm-switch.c<BR>
&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp; authors: Kevin_OKelley@dell.com and =
Narendran_Ganapathy@dell.com<BR>
&nbsp;*<BR>
&nbsp;* This file contains all the functions to create a =
&quot;switch&quot; target to<BR>
&nbsp;* separate the MPIO to the preferred block mode devices.<BR>
&nbsp;*<BR>
&nbsp;*******************************************************************=
*************<BR>
&nbsp;*/<BR>
/*<BR>
&nbsp;* Copyright (C) 2001-2003 Sistina Software (UK) Limited.<BR>
&nbsp;* Copyright (C) 2004-2008 Red Hat Inc.&nbsp; All rights =
reserved.<BR>
&nbsp;*<BR>
&nbsp;* This file is released under the GPL.<BR>
&nbsp;*/<BR>
<BR>
#include &lt;linux/module.h&gt;<BR>
#include &lt;linux/init.h&gt;<BR>
#include &lt;linux/blkdev.h&gt;<BR>
#include &lt;linux/bio.h&gt;<BR>
#include &lt;linux/slab.h&gt;<BR>
#include &lt;linux/device.h&gt;<BR>
#include &lt;linux/version.h&gt;<BR>
#include &lt;linux/dm-ioctl.h&gt;<BR>
#include &lt;linux/device-mapper.h&gt;<BR>
#include &lt;net/genetlink.h&gt;<BR>
#include &lt;asm/div64.h&gt;<BR>
<BR>
#include &quot;dm-switch.h&quot;<BR>
<BR>
#define DM_MSG_PREFIX &quot;switch&quot;<BR>
MODULE_DESCRIPTION(DM_NAME &quot; throughput-oriented path =
selector&quot;);<BR>
MODULE_AUTHOR(&quot;Kevin D. O'Kelley =
&lt;Kevin_OKelley@dell.com&gt;&quot;);<BR>
MODULE_LICENSE(&quot;GPL&quot;);<BR>
<BR>
/*<BR>
&nbsp;* Switch context block: A new one is created for each dm =
device.&nbsp; Contains an array of devices<BR>
&nbsp;* that we have taken references.<BR>
&nbsp;*/<BR>
struct switch_dev {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct dm_dev *dmdev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
sector_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; start;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
atomic_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; error_count;<BR>
};<BR>
<BR>
struct switch_ptbl {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pte_bits;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page Table Entry field =
size in bits<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pte_mask;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page Table Entry field =
mask<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pte_fields;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Number of Page Table =
Entries per uint32_t<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
ptbl_bytes;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page table size in =
bytes<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
ptbl_num;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page table size in =
entries<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
ptbl_max;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page table maximum size in =
entries;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
ptbl_buff[0];&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Address of page table<BR>
};<BR>
<BR>
struct switch_ctx {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct list_head list;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev_t&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
dev_this;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Device serviced by this =
target<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
dev_count;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Number of devices<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
page_size;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page size in 512B =
sectors<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
userland[2];&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Userland optional data =
(dmsetup status)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint64_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ios_remapped, =
ios_unmapped;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // I/Os remapped, I/Os not =
remapped<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spinlock_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spinlock;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Control access to =
counters<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_ptbl =
*ptbl;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Page table (if loaded)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_dev =
dev_list[0];&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Array of dm devices to =
switch between<BR>
};<BR>
<BR>
/*<BR>
&nbsp;* Global variables<BR>
&nbsp;*/<BR>
LIST_HEAD(__g_context_list);&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Linked list of context =
blocks<BR>
static spinlock_t =
__g_spinlock;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Control access to list of =
context blocks<BR>
<BR>
static int switch_ctr_limits(struct dm_target *ti, struct dm_dev =
*dm)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct block_device *sd =3D =
dm-&gt;bdev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct hd_struct *hd =3D =
sd-&gt;bd_part;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (hd !=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ti-&gt;len &lt;=3D =
hd-&gt;nr_sects)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return true;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D &quot;Device =
too small for target&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return false;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Missing device limits&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(&quot;%s %s\n&quot;, =
__FUNCTION__, ti-&gt;error);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return true;<BR>
}<BR>
<BR>
/*<BR>
&nbsp;* Constructor: Called each time a dmsetup command creates a dm =
device.&nbsp; The target parameter will already<BR>
&nbsp;* have the table, type, begin and len fields filled in.&nbsp; =
Arguments are in pairs: &lt;dev_path&gt; &lt;offset&gt;.<BR>
&nbsp;* Therefore, we get multiple constructor calls, but we will need =
to build a list of switch_ctx blocks so<BR>
&nbsp;* that the page table information gets matched to the correct =
device.<BR>
&nbsp;*/<BR>
static int switch_ctr(struct dm_target *ti, unsigned int argc, char =
**argv)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int n;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int dev_count;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long flags, major, =
minor;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long long start;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_ctx *pctx;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct mapped_device *md =3D =
NULL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct dm_dev *dm;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char *chp;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (argc &lt; 4) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Insufficient arguments&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev_count =3D =
simple_strtoul(argv[0], &amp;chp, 10);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (*chp) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Invalid device count&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (dev_count !=3D (argc - 2) =
/ 2) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Invalid argument count&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx =3D =
kmalloc(sizeof(*pctx) + (dev_count * sizeof(struct switch_dev)), =
GFP_KERNEL);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pctx =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D &quot;Cannot =
allocate redirect context&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -ENOMEM;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;dev_count =3D =
dev_count;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;page_size =3D =
simple_strtoul(argv[1], &amp;chp, 10);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((*chp) || =
(pctx-&gt;page_size =3D=3D 0)) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Invalid page size&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_kfree;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;ptbl =3D NULL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;userland[0] =3D =
pctx-&gt;userland[1] =3D 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;ios_remapped =3D =
pctx-&gt;ios_unmapped =3D0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_init(&amp;pctx-&gt;spinlock);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Find the device major =
and minor for the device that is being served by this target.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; md =3D =
dm_table_get_md(ti-&gt;table);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (md =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D &quot;Cannot =
locate dm device&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_kfree;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chp =3D (char *) =
dm_device_name(md);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (chp =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D &quot;Cannot =
acquire dm device name&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_kfree;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; major =3D simple_strtoul(chp, =
&amp;chp, 10);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (*chp++ !=3D ':') {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Invalid dm device name (major)&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_kfree;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; minor =3D simple_strtoul(chp, =
&amp;chp, 10);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (*chp) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Invalid dm device name (minor)&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_kfree;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;dev_this =3D =
MKDEV(major, minor);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Check each device =
beneath the target to ensure that the limits are consistent.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (n =3D 0, argc =3D 2; n =
&lt; pctx-&gt;dev_count; n++, argc +=3D 2) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (sscanf(argv[argc + 1], =
&quot;%llu&quot;, &amp;start) !=3D 1) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D =
&quot;Invalid device starting offset&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto =
failed_dev_list_prev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (dm_get_device(ti, =
argv[argc], dm_table_get_mode(ti-&gt;table), &amp;dm)) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error =3D &quot;Device =
lookup failed&quot;;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto =
failed_dev_list_prev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;dev_list[n].dmdev =
=3D dm;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;dev_list[n].start =
=3D start;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
atomic_set(&amp;(pctx-&gt;dev_list[n].error_count), 0);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!switch_ctr_limits(ti, =
dm))<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_dev_list_all;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_irqsave(&amp;__g_spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
list_add_tail(&amp;pctx-&gt;list, &amp;__g_context_list);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_unlock_irqrestore(&amp;__g_spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;private =3D pctx;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
<BR>
failed_dev_list_prev:&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // De-reference previous =
devices<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; n--;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //&nbsp;&nbsp; (i.e. don't =
include this one)<BR>
failed_dev_list_all:&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // De-reference all =
devices<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(&quot;%s device=3D%s, =
start=3D%s\n&quot;, __FUNCTION__, argv[argc], argv[argc + 1]);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (; n &gt;=3D 0; n--) =
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dm_put_device(ti, =
pctx-&gt;dev_list[n].dmdev);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
failed_kfree:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_WARNING &quot;%s =
%s\n&quot;, __FUNCTION__, ti-&gt;error);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kfree(pctx);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -EINVAL;<BR>
}<BR>
<BR>
/*<BR>
&nbsp;* Destructor: Don't free the dm_target, just the ti-&gt;private =
data (if any).<BR>
&nbsp;*/<BR>
static void switch_dtr(struct dm_target *ti)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int n;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long flags;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_ctx *pctx =3D =
(struct switch_ctx *) ti-&gt;private;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; void *ptbl;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_irqsave(&amp;__g_spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ptbl =3D pctx-&gt;ptbl;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
rcu_assign_pointer(pctx-&gt;ptbl, NULL);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
list_del(&amp;pctx-&gt;list);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_unlock_irqrestore(&amp;__g_spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (n =3D 0; n &lt; =
pctx-&gt;dev_count; n++) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dm_put_device(ti, =
pctx-&gt;dev_list[n].dmdev);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; synchronize_rcu();<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ptbl)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kfree(ptbl);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kfree(pctx);<BR>
}<BR>
<BR>
/*<BR>
&nbsp;* NOTE: If CONFIG_LBD is disabled, sector_t types are =
uint32_t.&nbsp; Therefore, in this routine, we<BR>
&nbsp;* convert the offset into a uint64_t instead of a sector_t so that =
all of the remaining arithmatic<BR>
&nbsp;* is correct, including the do_div() calls.<BR>
&nbsp;*/<BR>
static int switch_map(struct dm_target *ti, struct bio *bio,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; union map_info =
*map_context)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_ctx *pctx =3D =
(struct switch_ctx *) ti-&gt;private;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_ptbl *ptbl;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long flags;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint64_t itbl, offset =3D =
bio-&gt;bi_sector - ti-&gt;begin;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t idev =3D 0, =
irem;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint64_t *pinc =3D =
&amp;pctx-&gt;ios_unmapped;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rcu_read_lock();<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ptbl =3D =
rcu_dereference(pctx-&gt;ptbl);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ptbl !=3D NULL)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; itbl =3D offset;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; do_div(itbl, =
pctx-&gt;page_size);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (itbl &lt; =
ptbl-&gt;ptbl_num) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; irem =3D do_div(itbl, =
ptbl-&gt;pte_fields);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; idev =3D =
(ptbl-&gt;ptbl_buff[itbl] &gt;&gt; (irem * ptbl-&gt;pte_bits))<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp; ptbl-&gt;pte_mask;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (idev &lt;=3D =
pctx-&gt;dev_count) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pinc =3D =
&amp;pctx-&gt;ios_remapped;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_WARNING &quot;%s =
dev=3D%d, offset=3D%lld\n&quot;, __FUNCTION__, idev, offset);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; idev =3D 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_WARNING &quot;%s =
Page Table Entry %lld &gt;=3D %d\n&quot;, __FUNCTION__,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; itbl, ptbl-&gt;ptbl_num);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rcu_read_unlock();<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_irqsave(&amp;pctx-&gt;spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (*pinc)++;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_unlock_irqrestore(&amp;pctx-&gt;spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bio-&gt;bi_bdev =3D =
pctx-&gt;dev_list[idev].dmdev-&gt;bdev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bio-&gt;bi_sector =3D =
pctx-&gt;dev_list[idev].start + offset;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return DM_MAPIO_REMAPPED;<BR>
}<BR>
<BR>
/*<BR>
&nbsp;* Switch status:<BR>
&nbsp;*<BR>
&nbsp;* INFO: #dev_count device [device] 5 'A'['A' ...] userland[0] =
userland[1] #remapped #unmapped<BR>
&nbsp;* where:<BR>
&nbsp;*&nbsp;&nbsp; &quot;'A'['A']&quot; is a single word with an 'A' =
(active) or 'D' for each device<BR>
&nbsp;*&nbsp;&nbsp; The userland values are set by the last userland =
message to load the page table<BR>
&nbsp;*&nbsp;&nbsp; &quot;#remapped&quot; is the number of remapped =
I/Os<BR>
&nbsp;*&nbsp;&nbsp; &quot;#unmapped&quot; is the number of I/Os that =
could not be remapped<BR>
&nbsp;*<BR>
&nbsp;* TABLE: #page_size #dev_count device start [device start ...]<BR>
&nbsp;*/<BR>
static int switch_status(struct dm_target *ti, status_type_t type, char =
*result,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int maxlen)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_ctx *pctx =3D =
(struct switch_ctx *) ti-&gt;private;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char =
buffer[pctx-&gt;dev_count + 1];<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int sz =3D 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int n;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint64_t remapped, =
unmapped;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long flags;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; result[0] =3D '\0';<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; switch (type) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case STATUSTYPE_INFO:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DMEMIT(&quot;%d&quot;, =
pctx-&gt;dev_count);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (n =3D 0; n &lt; =
pctx-&gt;dev_count; n++)&nbsp; {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DMEMIT(&quot; %s&quot;, =
pctx-&gt;dev_list[n].dmdev-&gt;name);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; buffer[n] =3D 'A';<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; buffer[n] =3D '\0';<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_irqsave(&amp;pctx-&gt;spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; remapped =3D =
pctx-&gt;ios_remapped;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unmapped =3D =
pctx-&gt;ios_unmapped;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_unlock_irqrestore(&amp;pctx-&gt;spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DMEMIT(&quot; 5 %s %08x %08x =
%lld %lld&quot;, buffer, pctx-&gt;userland[0], pctx-&gt;userland[1],<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; remapped, unmapped);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case STATUSTYPE_TABLE:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DMEMIT(&quot;%d %d&quot;, =
pctx-&gt;dev_count, pctx-&gt;page_size);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (n =3D 0; n &lt; =
pctx-&gt;dev_count; n++)&nbsp; {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DMEMIT(&quot; %s %llu&quot;, =
pctx-&gt;dev_list[n].dmdev-&gt;name,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (unsigned long long) =
pctx-&gt;dev_list[n].start);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; default:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
}<BR>
<BR>
/*<BR>
&nbsp;* Switch ioctl:<BR>
&nbsp;*<BR>
&nbsp;* Passthrough all ioctls to the first path.<BR>
&nbsp;*/<BR>
static int switch_ioctl(struct dm_target *ti, unsigned int cmd,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long arg)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct switch_ctx *pctx =3D =
(struct switch_ctx *) ti-&gt;private;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct block_device =
*bdev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fmode_t mode =3D 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Sanity check */<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (unlikely(!pctx || =
!pctx-&gt;dev_list[0].dmdev ||<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
!pctx-&gt;dev_list[0].dmdev-&gt;bdev))<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -EIO;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bdev =3D =
pctx-&gt;dev_list[0].dmdev-&gt;bdev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mode =3D =
pctx-&gt;dev_list[0].dmdev-&gt;mode;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
__blkdev_driver_ioctl(bdev, mode, cmd, arg);<BR>
}<BR>
<BR>
static struct target_type __g_switch_target =3D {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .name&nbsp;&nbsp; =3D =
&quot;switch&quot;,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .version=3D {1, 0, 0},<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .module =3D THIS_MODULE,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .ctr&nbsp;&nbsp;&nbsp; =3D =
switch_ctr,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .dtr&nbsp;&nbsp;&nbsp; =3D =
switch_dtr,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .map&nbsp;&nbsp;&nbsp; =3D =
switch_map,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .status =3D =
switch_status,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .ioctl&nbsp; =3D =
switch_ioctl,<BR>
};<BR>
<BR>
// Generic Netlink attribute policy (single attribute, =
NETLINK_ATTR_MSG)<BR>
static struct nla_policy __g_attr_policy[NETLINK_ATTR_MAX + 1] =3D<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [NETLINK_ATTR_MSG] =3D { =
.type =3D NLA_BINARY, .len =3D MAX_IPC_MSG_LEN },<BR>
};<BR>
<BR>
// Define the Generic Netlink family<BR>
static struct genl_family __g_family =3D<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .id &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
GENL_ID_GENERATE,&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Assign channel when family =
is registered<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .hdrsize =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D 0,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .name&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
&quot;DM_SWITCH&quot;,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .version =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D 1,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .maxattr =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D NETLINK_ATTR_MAX,<BR>
};<BR>
<BR>
/*<BR>
&nbsp;* Generic Netlink socket read function that handles communication =
from the userland<BR>
&nbsp;* for downloading the page table.<BR>
&nbsp;*/<BR>
static int get_page_tbl(struct sk_buff *skb_2, struct genl_info =
*info)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc, pte_mask, pte_fields, =
ptbl_bytes, offset, size;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
uint32_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; flags;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char &nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *mydata;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; void&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *msg_head;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct nlattr&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *na;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct sk_buff&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *skb;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct =
switch_ctx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *pctx, *next;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct =
switch_ptbl&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ptbl, *pnew;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
IpcPgTable_t&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *pgp;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IpcResponse_t&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev_t&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; static const =
char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *invmsg =3D &quot;Invalid Page =
Table message&quot;;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * For each attribute =
there is an index in info-&gt;attrs which points to a nlattr =
structure<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * in this structure the =
data is given<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (info =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_ERR &quot;%s =
missing genl_info parameter\n&quot;, __FUNCTION__);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; na =3D =
info-&gt;attrs[NETLINK_ATTR_MSG];<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (na =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_ERR &quot;%s no =
info-&gt;attrs %i\n&quot;, __FUNCTION__, NETLINK_ATTR_MSG);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mydata =3D (char *) =
nla_data(na);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (mydata =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_ERR &quot;%s =
error while receiving data\n&quot;, __FUNCTION__);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Format the reply =
message.&nbsp; Return positve error codes to userland.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; skb =3D =
nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (skb =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_ERR &quot;%s =
cannot allocate reply message\n&quot;, __FUNCTION__);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; msg_head =3D genlmsg_put(skb, =
0, info-&gt;snd_seq, &amp;__g_family, 0, NETLINK_CMD_GET_PAGE_TBL);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (skb =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(KERN_ERR &quot;%s =
cannot format reply message header\n&quot;, __FUNCTION__);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pgp =3D (IpcPgTable_t *) =
mydata;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (na-&gt;nla_len &lt; =
sizeof(IpcPgTable_t)) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: too short (%d)&quot;, invmsg, =
na-&gt;nla_len);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_respond;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((pgp-&gt;page_offset + =
pgp-&gt;page_count) &gt; pgp-&gt;page_total) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: too many page table entries (%d &gt; =
%d)&quot;,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; invmsg, (pgp-&gt;page_offset =
+ pgp-&gt;page_count), pgp-&gt;page_total);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_respond;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_mask =3D (1 &lt;&lt; =
pgp-&gt;pte_bits) - 1;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (((pgp-&gt;dev_count - 1) =
&amp; (~pte_mask)) !=3D 0) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: invalid mask 0x%x for %d =
devices&quot;,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; invmsg, pte_mask, =
pgp-&gt;dev_count);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_respond;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_fields =3D 32 / =
pgp-&gt;pte_bits;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size =3D ((pgp-&gt;page_count =
+ pte_fields - 1) / pte_fields) * sizeof(uint32_t);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((sizeof(*pgp) - 1 + size) =
&gt; na-&gt;nla_len) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;Invalid Page Table message: incomplete =
messsage&quot;);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_respond;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Look for the corresponding =
switch context block to create or update the page table.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc =3D 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev =3D =
MKDEV(pgp-&gt;dev_major, pgp-&gt;dev_minor);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_irqsave(&amp;__g_spinlock, flags);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
list_for_each_entry_safe(pctx, next, &amp;__g_context_list, list) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (dev =3D=3D =
pctx-&gt;dev_this) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc =3D 1;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (rc =3D=3D 0) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: invalid target device %d:%d&quot;,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; invmsg, pgp-&gt;dev_major, =
pgp-&gt;dev_minor);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_unlock;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ptbl =3D pctx-&gt;ptbl;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (&nbsp; ( (ptbl !=3D NULL) =
&amp;&amp; (pgp-&gt;page_offset &gt; (ptbl-&gt;ptbl_num + 1)) ) ||<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ( (ptbl =3D=3D NULL) &amp;&amp; =
(pgp-&gt;page_offset !=3D 0) )&nbsp; ) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: missing entries&quot;, invmsg);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_unlock;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //&nbsp; Don't allow userland =
to change context parameters unless the page table is being rebuilt.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pgp-&gt;page_offset !=3D =
0) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((pgp-&gt;dev_count) !=3D =
pctx-&gt;dev_count) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: invalid device count %d&quot;,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; invmsg, =
pgp-&gt;dev_count);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_respond;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ptbl !=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pgp-&gt;pte_bits !=3D =
ptbl-&gt;pte_bits) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: number of bits changed&quot;, =
invmsg);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_unlock;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pgp-&gt;page_total !=3D =
ptbl-&gt;ptbl_max) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;%s: total number of entries changed&quot;, =
invmsg);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_unlock;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Create a Page Table if =
needed.&nbsp; Most of the time, the size of the table<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // doesn't change.&nbsp; In =
that case, re-use the existing table.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ptbl_bytes =3D =
((pgp-&gt;page_total + pte_fields - 1) / pte_fields) * =
sizeof(uint32_t);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((ptbl !=3D NULL) =
&amp;&amp; (ptbl_bytes =3D=3D ptbl-&gt;ptbl_bytes)) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew =3D ptbl;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew =3D =
kmalloc((sizeof(*pnew) + ptbl_bytes), GFP_KERNEL);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pnew =3D=3D NULL) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; snprintf(resp.err_str, =
sizeof(resp.err_str), &quot;Cannot allocate Page Table&quot;);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; status =3D EINVAL;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed_unlock;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew-&gt;ptbl_bytes =3D =
ptbl_bytes;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew-&gt;pte_bits =3D =
pgp-&gt;pte_bits;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew-&gt;pte_mask =3D =
pte_mask;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew-&gt;pte_fields =3D =
pte_fields;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew-&gt;ptbl_max =3D =
pgp-&gt;page_total;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pnew-&gt;ptbl_num =3D =
pgp-&gt;page_offset + pgp-&gt;page_count;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; offset =3D =
(pgp-&gt;page_offset + pte_fields - 1) / pte_fields;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
memcpy(&amp;pnew-&gt;ptbl_buff[offset], pgp-&gt;ptbl_buff, size);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;userland[0] =3D =
pgp-&gt;userland[0];<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pctx-&gt;userland[1] =3D =
pgp-&gt;userland[1];<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (pnew !=3D ptbl) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
rcu_assign_pointer(pctx-&gt;ptbl, pnew);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ptbl !=3D NULL)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; kfree(ptbl);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
failed_unlock:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_unlock_irqrestore(&amp;__g_spinlock, flags);<BR>
<BR>
failed_respond:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (status !=3D 0)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(&quot;%s WARNING: =
%s\n&quot;, __FUNCTION__, resp.err_str);<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Format the response =
message<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp.total_len =3D =
sizeof(IpcResponse_t);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp.opcode =3D =
OPCODE_PAGE_TABLE_UPLOAD;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp.userland[0] =3D =
pgp-&gt;userland[0];<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp.userland[1] =3D =
pgp-&gt;userland[1];<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp.dev_major =3D =
pgp-&gt;dev_major;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp.dev_minor =3D =
pgp-&gt;dev_minor;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resp.status =3D status;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc =3D nla_put(skb, =
NLA_BINARY, sizeof(IpcResponse_t), &amp;resp);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if( rc !=3D 0 ) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(&quot;%s WARNING: =
Cannot format reply message\n&quot;, __FUNCTION__);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; genlmsg_end(skb, =
msg_head);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rc =3D =
genlmsg_unicast(&amp;init_net, skb, =
info-&gt;snd_pid);&nbsp;&nbsp;&nbsp;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if( rc !=3D 0 ) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(&quot;%s WARNING: =
Cannot send reply message\n&quot;, __FUNCTION__);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
}<BR>
<BR>
// Operation for getting the page table<BR>
static struct genl_ops __g_op_get_page_tbl =3D<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .cmd &nbsp;&nbsp; =3D =
NETLINK_CMD_GET_PAGE_TBL,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .flags&nbsp; =3D 0,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .policy =3D =
__g_attr_policy,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .doit &nbsp; =3D =
get_page_tbl,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .dumpit =3D NULL,<BR>
};<BR>
<BR>
/*<BR>
&nbsp;* Use the sysfs interface to inform the userland process of the =
family id to be used<BR>
&nbsp;* by the Generic Netlink socket.<BR>
&nbsp;*/<BR>
static ssize_t sysfs_familyid_show(struct kobject *kobj, struct =
attribute *attr, char *buff)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return snprintf(buff, =
PAGE_SIZE, &quot;%d&quot;, __g_family.id);<BR>
}<BR>
<BR>
static ssize_t sysfs_familyid_store(struct kobject *kobj, struct =
attribute *attr,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; const char *buff, size_t =
size)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return size;<BR>
}<BR>
<BR>
static struct {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct attribute attr;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct sysfs_ops ops;<BR>
}<BR>
__g_sysfs_familyid =3D {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { &quot;familyid&quot;, 0644 =
},<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { &amp;sysfs_familyid_show, =
&amp;sysfs_familyid_store },<BR>
};<BR>
<BR>
int __init dm_switch_init(void)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int r;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
spin_lock_init(&amp;__g_spinlock);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
dm_register_target(&amp;__g_switch_target);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
DMERR(&quot;dm_register_target() failed %d&quot;, r);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return r;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Initialize Generic Netlink =
communications<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
genl_register_family(&amp;__g_family);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
DMERR(&quot;genl_register_family() failed&quot;);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
genl_register_ops(&amp;__g_family, &amp;__g_op_get_page_tbl);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
DMERR(&quot;genl_register_ops(get_page_tbl) failed %d&quot;, r);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
sysfs_create_file(&amp;__g_switch_target.module-&gt;mkobj.kobj, =
&amp;__g_sysfs_familyid.attr);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r) {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
DMERR(&quot;/sys/module/familyid create failed %d&quot;, r);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto failed;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR>
failed:<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
dm_unregister_target(&amp;__g_switch_target);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return r;<BR>
}<BR>
<BR>
void dm_switch_exit(void)<BR>
{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int r;<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
dm_unregister_target(&amp;__g_switch_target);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
genl_unregister_family(&amp;__g_family);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (r)<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
DMWARN(&quot;genl_unregister_family() failed %d&quot;, r);<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;<BR>
}<BR>
<BR>
module_init(dm_switch_init);<BR>
module_exit(dm_switch_exit);<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01CBEB2A.C44E831C--


--===============6999254887217651604==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6999254887217651604==--
