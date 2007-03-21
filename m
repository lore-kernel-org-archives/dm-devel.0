From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: dm-multipath based engenio-lsi hardware handler
Date: Wed, 21 Mar 2007 11:23:34 -0800
Message-ID: <1174505014.22545.8.camel@linuxchandra>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-K2dcRN4NDBj1tMv6PZw+"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, agk@redhat.com
List-Id: dm-devel.ids


--=-K2dcRN4NDBj1tMv6PZw+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi All,

I took a old version of code that was originally written by Mike
Christie and started testing it.

Found some issues, fixed them, added some additional logic for
completeness.

Here is the code in its current state. Please provide me with your
feedback.

Also, find the attached diagram to see the current behavior of the
hardware handler.

Thanks,

chandra
/*
 * Engenio/LSI RDAC DM HW handler
 *
 * Copyright (C) 2005 Mike Christie. All rights reserved.
 * Copyright (C) Chandra Seetharaman, IBM Corp. 2007
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, =
USA.
 *
 */
#include <scsi/scsi.h>
#include <scsi/scsi_cmnd.h>

#include "dm.h"
#include "dm-hw-handler.h"

#define RDAC_DM_HWH_NAME "rdac"
#define RDAC_DM_HWH_VER "0.4"

/*
 * LSI mode page stuff
 *
 * These struct definitions and the forming of the
 * mode page were taken from the LSI RDAC 2.4 GPL'd
 * driver, and then converted to Linux conventions.
 */
#define RDAC_QUIESCENCE_TIME 20;
/*
 * Page Codes
 */
#define RDAC_PAGE_CODE_REDUNDANT_CONTROLLER 0x2c

/*
 * Controller modes definitions
 */
#define RDAC_MODE_TRANSFER_ALL_LUNS		0x01
#define RDAC_MODE_TRANSFER_SPECIFIED_LUNS	0x02

/*
 * RDAC Options field
 */
#define RDAC_FORCED_QUIESENCE 0x02

/*
 * default value TODO - make configurable
 */
#define RDAC_FAILOVER_TIMEOUT (60 * HZ)

struct rdac_mode_6_hdr {
	u8	data_len;
	u8	medium_type;
	u8	device_params;
	u8	block_desc_len;
};

struct rdac_mode_10_hdr {
	u16	data_len;
	u8	medium_type;
	u8	device_params;
	u16	reserved;
	u16	block_desc_len;
};

struct rdac_mode_common {
	u8	controller_serial[16];
	u8	alt_controller_serial[16];
	u8	rdac_mode[2];
	u8	alt_rdac_mode[2];
	u8	quiescence_timeout;
	u8	rdac_options;
};

struct rdac_pg_legacy {
	struct rdac_mode_6_hdr hdr;
	u8	page_code;
	u8	page_len;
	struct rdac_mode_common common;
#define MODE6_MAX_LUN	32
	u8	lun_table[MODE6_MAX_LUN];
	u8	reserved2[32];
	u8	reserved3;
	u8	reserved4;
};

struct rdac_pg_expanded {
	struct rdac_mode_10_hdr hdr;
	u8	page_code;
	u8	subpage_code;
	u8	page_len[2];
	struct rdac_mode_common common;
	u8	lun_table[256];
	u8	reserved3;
	u8	reserved4;
};

struct c9_inquiry {
	u8	peripheral_info;
	u8	page_code;	/* 0xC9 */
	u8	reserved1;
	u8	page_len;
	u8	page_id[4];	/* "vace" */
	u8	avte_cvp;
	u8	path_prio;
	u8	reserved2[38];
};

#define SUBSYS_ID_LEN	16
#define SLOT_ID_LEN	2

struct c4_inquiry {
	u8	peripheral_info;
	u8	page_code;	/* 0xC4 */
	u8	reserved1;
	u8	page_len;
	u8	page_id[4];	/* "subs" */
	u8	subsys_id[SUBSYS_ID_LEN];
	u8	revision[4];
	u8	slot_id[SUBSYS_ID_LEN];
	u8	reserved[2];
};

struct rdac_handler {
	unsigned		use_10_ms;
	unsigned		timeout;
	struct rdac_controller	*ctlr;
#define UNINITIALIZED_LUN	(1 << 8)
#define UNSUPPORTED_LUN		(2 << 8)
	unsigned		lun;
	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
};

struct rdac_private {
	struct rdac_handler	*h;
	struct path		*path;
	struct list_head	entry; /* list of all controllers */
};

struct rdac_controller {
	u8			subsys_id[SUBSYS_ID_LEN];
	u8			slot_id[SLOT_ID_LEN];
	struct kref		kref;
	struct list_head	node; /* list of all controllers */
	spinlock_t		lock;
	int			submitted;
	struct list_head	cmd_list; /* list of commands to be submitted */
};

struct c8_inquiry {
	u8	peripheral_info;
	u8	page_code; /* 0xC8 */
	u8	reserved1;
	u8	page_len;
	u8	page_id[4]; /* "edid" */
	u8	reserved2[3];
	u8	vol_uniq_id_len;
	u8	vol_uniq_id[16];
	u8	vol_user_label_len;
	u8	vol_user_label[60];
	u8	array_uniq_id_len;
	u8	array_unique_id[16];
	u8	array_user_label_len;
	u8	array_user_label[60];
	u8	lun[8];
};

static LIST_HEAD(ctlr_list);
static spinlock_t list_lock =3D SPIN_LOCK_UNLOCKED;

static inline void free_bio(struct bio *bio)
{
	__free_page(bio->bi_io_vec[0].bv_page);
	bio_put(bio);
}

static void submit_inquiry(struct rdac_handler *, struct path *, int,
		unsigned int, bio_end_io_t);
static int c9_inquiry_endio(struct bio *, unsigned int, int);
#define submit_c9_inquiry(h, path) \
	submit_inquiry(h, path, 0xC9, sizeof(struct c9_inquiry), \
				c9_inquiry_endio)
#define submit_c4_inquiry(h, path) \
	submit_inquiry(h, path, 0xC4, sizeof(struct c4_inquiry), \
				c4_inquiry_endio)

#define submit_c8_inquiry(h, path) \
	submit_inquiry(h, path, 0xC8, sizeof(struct c8_inquiry), \
				c8_inquiry_endio)

static void rdac_resubmit_all(struct rdac_handler *h)
{
	struct rdac_private *tmp, *p;
	struct rdac_controller *ctlr =3D h->ctlr;

	spin_lock(&ctlr->lock);
	list_for_each_entry_safe(p, tmp, &ctlr->cmd_list, entry) {
		submit_c9_inquiry(p->h, p->path);
		list_del(&p->entry);
		kfree(p);
	}
	ctlr->submitted =3D 0;
	spin_unlock(&ctlr->lock);
}

static int mode_select_endio(struct bio *bio, unsigned int done, int erro=
r)
{
	struct rdac_private *p =3D bio->bi_private;
	struct rdac_handler *h =3D p->h;
	struct path *path =3D p->path;
	int sense =3D bio_sense_value(bio);

	kfree(p);
	if (bio->bi_size)
		return 1;

	/* If it is retryable failure, submit the c9 inquiry again */
	if (sense =3D=3D 0x59136 || sense =3D=3D 0x68b02 || sense =3D=3D 0xb8b02=
) {
		/* 0x59136    - Command lock contention
		 * 0x[6b]8b02 - Quiesense in progress or achieved
		 */
		submit_c9_inquiry(h, path);
		goto done;
	}

	if (sense)
		DMINFO("dm-rdac: MODE_SELECT failed on %s with sense 0x%x",
			path->dev->name, sense);
	if (error || sense)
		dm_pg_init_complete(path, MP_FAIL_PATH);
	else
		dm_pg_init_complete(path, 0);

done:
	rdac_resubmit_all(h);
	/* request is freed in block layer */
	free_bio(bio);

	return 0;
}

static struct bio *get_rdac_bio(struct path *path, unsigned data_size,
		bio_end_io_t endio, int rw, struct rdac_handler *h)
{
	struct bio *bio;
	struct page *page;
	struct rdac_private *p;

	bio =3D bio_alloc(GFP_ATOMIC, 1);
	if (!bio)
		return NULL;

	if (rw =3D=3D WRITE)
		bio->bi_rw |=3D (1 << BIO_RW);
	bio->bi_bdev =3D path->dev->bdev;
	bio->bi_sector =3D 0;
	bio->bi_end_io =3D endio;

	p =3D kmalloc(sizeof(*p), GFP_ATOMIC);
	if (!p)
		goto bio;

	p->path =3D path;
	p->h =3D h;
	bio->bi_private =3D p;
	page =3D alloc_page(GFP_ATOMIC);
	if (!page)
		goto free_private;

	if (bio_add_page(bio, page, data_size, 0) =3D=3D data_size)
		return bio;

	__free_page(page);
free_private:
	kfree(p);
bio:
	bio_put(bio);
	return NULL;
}

static struct request *get_rdac_req(struct rdac_handler *h,
		struct bio *bio, struct path *path, int rw)
{
	struct request *rq;
	struct block_device *bdev =3D bio->bi_bdev;
	struct request_queue *q =3D bdev_get_queue(bdev);

	rq =3D blk_get_request(q, rw, GFP_ATOMIC);
	if (!rq) {
		DMINFO("dm-rdac: get_failover_req: blk_get_request failed");
		return NULL;
	}

	rq->bio =3D rq->biotail =3D bio;
	blk_rq_bio_prep(q, rq, bio);

	rq->rq_disk =3D bdev->bd_contains->bd_disk;

	/* bio backed don't set data */
	rq->buffer =3D rq->data =3D NULL;
	/* rq data_len used for pc cmd's request_bufflen */
	rq->data_len =3D bio->bi_size;

	rq->sense =3D h->sense;
	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
	rq->sense_len =3D 0;

	memset(&rq->cmd, 0, BLK_MAX_CDB);

	rq->timeout =3D h->timeout;
	rq->flags |=3D (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);

	return rq;
}

static struct request *rdac_failover_get(struct rdac_handler *h,
					struct path *path)
{
	struct bio *bio;
	struct request *rq;
	struct rdac_mode_common *common;
	unsigned data_size =3D h->use_10_ms ? sizeof(struct rdac_pg_expanded) :
				sizeof(struct rdac_pg_legacy);

	/* get bio backing */
	if (data_size > PAGE_SIZE)
		/* this should never happen */
		return NULL;

	bio =3D get_rdac_bio(path, data_size, mode_select_endio, WRITE, h);
	if (!bio) {
		DMERR("dm-rdac: rdac_failover_get: no bio");
		return NULL;
	}

	if (h->use_10_ms) {
		struct rdac_pg_expanded *rdac_pg;

		rdac_pg =3D (struct rdac_pg_expanded *)bio_data(bio);
		memset(rdac_pg, 0, data_size);
		common =3D &rdac_pg->common;
		rdac_pg->page_code =3D RDAC_PAGE_CODE_REDUNDANT_CONTROLLER + 0x40;
		rdac_pg->subpage_code =3D 0x1;
		rdac_pg->page_len[0] =3D 0x01;
		rdac_pg->page_len[1] =3D 0x28;
		rdac_pg->lun_table[h->lun] =3D 0x81;
	} else {
		struct rdac_pg_legacy *rdac_pg;

		rdac_pg =3D (struct rdac_pg_legacy *)bio_data(bio);
		memset(rdac_pg, 0, data_size);
		common =3D &rdac_pg->common;
		rdac_pg->page_code =3D RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
		rdac_pg->page_len =3D 0x68;
		rdac_pg->lun_table[h->lun] =3D 0x81;
	}
	common->rdac_mode[1] =3D RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
	common->quiescence_timeout =3D RDAC_QUIESCENCE_TIME;
	common->rdac_options =3D RDAC_FORCED_QUIESENCE;

	/* get request for block layer packet command */
	rq =3D get_rdac_req(h, bio, path, WRITE);
	if (!rq) {
		DMERR("dm-rdac: rdac_failover_get: no rq");
		free_bio(bio);
		return NULL;
	}

	/* Prepare the command. */
	if (h->use_10_ms) {
		rq->cmd[0] =3D MODE_SELECT_10;
		rq->cmd[7] =3D data_size >> 8;
		rq->cmd[8] =3D data_size & 0xff;
	} else {
		rq->cmd[0] =3D MODE_SELECT;
		rq->cmd[4] =3D data_size;
	}
	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);

	return rq;
}

static int submit_mode_select(struct rdac_handler *h,
				struct path *path)
{
	int ret =3D 1;
	struct request *rq;
	struct request_queue *q =3D bdev_get_queue(path->dev->bdev);

	if (!q) {
		DMINFO("dm-rdac: submit_mode_select: no queue");
		goto fail_path;
	}

	rq =3D rdac_failover_get(h, path);
	if (!rq) {
		DMERR("dm-rdac: submit_mode_select: no rq");
		goto fail_path;
	}

	DMINFO("dm-rdac: queueing MODE_SELECT command on %s", path->dev->name);

	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
	ret =3D 0;
fail_path:
	return ret;
}

static void release_ctlr(struct kref *kref)
{
	struct rdac_controller *ctlr;
	ctlr =3D container_of(kref, struct rdac_controller, kref);

	spin_lock(&list_lock);
	list_del(&ctlr->node);
	spin_unlock(&list_lock);
	kfree(ctlr);
}

static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id)
{
	struct rdac_controller *ctlr, *tmp;

	spin_lock(&list_lock);

	list_for_each_entry(tmp, &ctlr_list, node) {
		if ((memcmp(tmp->subsys_id, subsys_id, SUBSYS_ID_LEN) =3D=3D 0) &&
			  (memcmp(tmp->slot_id, slot_id, SLOT_ID_LEN) =3D=3D 0)) {
			kref_get(&tmp->kref);
			spin_unlock(&list_lock);
			return tmp;
		}
	}
	ctlr =3D kmalloc(sizeof(*ctlr), GFP_ATOMIC);
	if (!ctlr)
		goto done;

	/* initialize fields of controller */
	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
	kref_init(&ctlr->kref);
	spin_lock_init(&ctlr->lock);
	ctlr->submitted =3D 0;
	INIT_LIST_HEAD(&ctlr->cmd_list);
	list_add(&ctlr->node, &ctlr_list);
done:
	spin_unlock(&list_lock);
	return ctlr;
}

static int c4_inquiry_endio(struct bio *bio, unsigned int done, int error=
)
{
	struct rdac_private *p =3D bio->bi_private;
	struct rdac_handler *h =3D p->h;
	struct path *path =3D p->path;
	struct c4_inquiry *sp;

	kfree(p);
	if (error) {
		dm_pg_init_complete(path, MP_FAIL_PATH);
		goto done;
	}

	sp =3D (struct c4_inquiry *)bio_data(bio);
	h->ctlr =3D get_controller(sp->subsys_id, sp->slot_id);

	if (h->ctlr)
		submit_c9_inquiry(h, path);
	else
		dm_pg_init_complete(path, MP_FAIL_PATH);

done:
	/* request is freed in block layer */
	free_bio(bio);
	return 0;
}

static int c9_inquiry_endio(struct bio *bio, unsigned int done, int error=
)
{
	struct rdac_private *p =3D bio->bi_private;
	struct rdac_handler *h =3D p->h;
	struct path *path =3D p->path;
	struct c9_inquiry *sp;

	if (error) {
		dm_pg_init_complete(path, MP_FAIL_PATH);
		goto done;
	}

	/* We need to look at the sense keys here to take clear action.
	 * For now simple logic: if controller owns the lun, return
	 * dm_pg_init_complete(), otherwise submit MODE SELECT.
	 */
	sp =3D (struct c9_inquiry *)bio_data(bio);
	if (sp->avte_cvp & 0x1) {
		dm_pg_init_complete(path, 0);
		goto done;
	}

	if (h->ctlr) {
		spin_lock(&h->ctlr->lock);
		if (!h->ctlr->submitted) {
			if (submit_mode_select(h, path) !=3D 0)
				dm_pg_init_complete(path, MP_FAIL_PATH);
			else
				h->ctlr->submitted =3D 1;
		} else {
			list_add(&p->entry, &h->ctlr->cmd_list);
			p =3D NULL; /* Reuse p, do not free */
		}
		spin_unlock(&h->ctlr->lock);
	} else
		submit_c4_inquiry(h, path);

done:
	kfree(p);
	/* request is freed in block layer */
	free_bio(bio);
	return 0;
}

static int c8_inquiry_endio(struct bio *bio, unsigned int done, int error=
)
{
	struct rdac_private *p =3D bio->bi_private;
	struct rdac_handler *h =3D p->h;
	struct path *path =3D p->path;
	struct c8_inquiry *sp;

	kfree(p);
	if (error) {
		dm_pg_init_complete(path, MP_FAIL_PATH);
		goto done;
	}

	/* We need to look at the sense keys here to take clear action.
	 * For now simple logic: Get the lun from the inquiry page.
	 */
	sp =3D (struct c8_inquiry *)bio_data(bio);
	if (sp->lun[7] >=3D MODE6_MAX_LUN && !h->use_10_ms) {
		DMERR("dm-rdac: MODE_SELECT6 cannot support device(%s) with "
			"lun %d(>=3D%d)\n", path->dev->name, sp->lun[7],
			MODE6_MAX_LUN);
		h->lun =3D UNSUPPORTED_LUN;
		dm_pg_init_complete(path, MP_FAIL_PATH);
		goto done;
	}
	h->lun =3D sp->lun[7]; /* currently it uses only one byte */
	submit_c9_inquiry(h, path);

done:
	/* request is freed in block layer */
	free_bio(bio);
	return 0;
}

static struct request *rdac_inquiry_get(struct rdac_handler *h,
		struct path *path, int page_code,
		unsigned int len, bio_end_io_t endio)
{
	struct bio *bio;
	struct request *rq;

	bio =3D get_rdac_bio(path, len, endio, READ, h);
	if (!bio) {
		DMERR("dm-rdac: rdac_inquiry_get: no bio");
		return NULL;
	}
	memset(bio_data(bio), 0, len);

	/* get request for block layer packet command */
	rq =3D get_rdac_req(h, bio, path, READ);
	if (!rq) {
		DMERR("dm-rdac: rdac_inquiry_get: no rq");
		free_bio(bio);
		return NULL;
	}

	/* Prepare the command. */
	rq->cmd[0] =3D INQUIRY;
	rq->cmd[1] =3D 1;
	rq->cmd[2] =3D page_code;
	rq->cmd[4] =3D len;
	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);
	return rq;
}

/*
 * only support subpage2c until we confirm that this is just a matter of
 * of updating firmware or not, and RDAC (basic AVT works already) for no=
w
 * but we can add these in in when we get time and testers
 */
static int rdac_create(struct hw_handler *hwh, unsigned argc, char **argv=
)
{
	struct rdac_handler *h;
	unsigned timeout, use_10_ms;

	if (argc =3D=3D 0) {
		/* No arguments: use defaults */
		timeout =3D RDAC_FAILOVER_TIMEOUT;
		use_10_ms =3D 1;
	} else if (argc !=3D 2) {
		DMWARN("dm-rdac: incorrect number of arguments");
		return -EINVAL;
	} else {
		if ((sscanf(argv[0], "%u", &use_10_ms) !=3D 1)
			|| (use_10_ms > 1)) {
			DMWARN("dm-rdac: invalid command mode selected");
			return -EINVAL;
		}

		if (sscanf(argv[1], "%u", &timeout) !=3D 1) {
			DMWARN("dm-rdac: invalid timeout value");
			return -EINVAL;
		}

	}

	h =3D kzalloc(sizeof(*h), GFP_KERNEL);
	if (!h)
		return -ENOMEM;

	hwh->context =3D h;
	h->timeout =3D timeout;
	h->use_10_ms =3D use_10_ms;
	h->lun =3D UNINITIALIZED_LUN;
	DMWARN("dm-rdac: using %s RDAC command with timeout %u", h->use_10_ms?"e=
xpanded":"legacy",h->timeout);

	return 0;
}

static void rdac_destroy(struct hw_handler *hwh)
{
	struct rdac_handler *h =3D (struct rdac_handler *) hwh->context;

	if (h->ctlr)
		kref_put(&h->ctlr->kref, release_ctlr);
	kfree(h);
	hwh->context =3D NULL;
}

static unsigned rdac_error(struct hw_handler *hwh, struct bio *bio)
{
	int sense;

	if (bio_sense_valid(bio)) {
		sense =3D bio_sense_value(bio); /* sense key / asc / ascq */

		if (sense =3D=3D 0x020481) {
			/* LUN Not Ready - Storage firmware incompatible
			 * Manual code synchonisation required.
			 *
			 * Nothing we can do here. Try to bypass the path.
			 */
			return MP_BYPASS_PG;
		} else if (sense =3D=3D 0x059401) {
			/* Invalid Request - Current Logical Unit Ownership.
			 * Controller is not the current owner of the LUN,
			 * Fail the path, so that the other path be used.
			 */
			return MP_FAIL_PATH;
		} else if (sense =3D=3D 0x0204A1) {
			/* LUN Not Ready - Quiescense in progress
			 *
			 * Just retry and wait.
			 */
			return 0;
		}
	}

	/* Try default handler */
	return dm_scsi_err_handler(hwh, bio);
}

static void submit_inquiry(struct rdac_handler *h,
		struct path *path, int page_code,
		unsigned int len, bio_end_io_t endio)
{
	struct request *rq;
	struct request_queue *q =3D bdev_get_queue(path->dev->bdev);

	if (!q)
		goto fail_path;

	rq =3D rdac_inquiry_get(h, path, page_code, len, endio);
	if (!rq)
		goto fail_path;

	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
	return;

fail_path:
	dm_pg_init_complete(path, MP_FAIL_PATH);
}

static void rdac_pg_init(struct hw_handler *hwh, unsigned bypassed,
			struct path *path)
{
	struct rdac_handler *h =3D hwh->context;

	switch (h->lun) {
	case UNINITIALIZED_LUN:
		submit_c8_inquiry(h, path);
		break;
	case UNSUPPORTED_LUN:
		dm_pg_init_complete(path, MP_FAIL_PATH);
		break;
	default:
		submit_c9_inquiry(h, path);
	}
}

static struct hw_handler_type rdac_handler =3D {
	.name =3D RDAC_DM_HWH_NAME,
	.module =3D THIS_MODULE,
	.create =3D rdac_create,
	.destroy =3D rdac_destroy,
	.pg_init =3D rdac_pg_init,
	.error =3D rdac_error,
};

static int __init rdac_init(void)
{
	int r =3D dm_register_hw_handler(&rdac_handler);

	if (r < 0)
		DMERR("%s: register failed %d", RDAC_DM_HWH_NAME, r);

	DMINFO("%s: version %s loaded", RDAC_DM_HWH_NAME, RDAC_DM_HWH_VER);

	return r;
}

static void __exit rdac_exit(void)
{
	int r =3D dm_unregister_hw_handler(&rdac_handler);

	if (r < 0)
		DMERR("%s: unregister failed %d", RDAC_DM_HWH_NAME, r);
}

module_init(rdac_init);
module_exit(rdac_exit);

MODULE_DESCRIPTION("DM Multipath LSI/Engenio RDAC support");
MODULE_AUTHOR("Mike Christie");
MODULE_LICENSE("GPL");
MODULE_VERSION(RDAC_DM_HWH_VER);

Pre=81

ph

=81
=81



i=81=81


=A0=0B


=81
=11

p=81
=A0=0B

=81
=A0=0B
=0B=11
=9C=0B
=0B=B1
h=81

=81

=81
=11
ph

=81
=A0=0B
p=81=81
=0B






>=0B


=81
=9F=0B
=0B
=11
aph
=81
=9F=0B=11
=D6=9F=0B=A9

=81

=CE=9F=0BA



=19
x?=81
=9F=0B

=81
=9F=0B


=11
=0B=11
=9E=9F=0B=11


=9F=0B=11



p=81

=8B=9F=0B=11
=81

=9F=0B
=81
=81
=11
=81

=9F=0B

aph
=81

=0B

raph



=81=81
p=81

=81
ap=81


ph
aph
=81
raph

=81

=81=81=81=81

=81=81


=81
=0B
=9E=0B=81


=81
=81

=81

=11
=0B
=81
=81
=81



=81
=11
=9E=0B
=11
=9E=0B

=0B=11

x=11
aph

=99=0B
=81
=9E=0B
=81
=0B=81
=9E=0B
=0B!
=81


=81


=0B(




=B8=9E=0B=99
;
y
$,=81
=0B


aph
8

=81


=AA=AAY
=81




=0B

=0B =81


=81
=0B=81=81
=9E=0BI

=81


=81=81
p=81



=11
=FF(=81

=9E=0B
8=81


=81
p=81


=81=81
=0B
=9E=0B
=11

=81
=81




=11
=0B
ph

Y
=81
=81=81=81=81
=11
=81
=81
=81

=81=81
h

=97=81
=0B
ph

Y
=81
=81=81
raph
8


=9D=0B
h

	=11
=81
H
=9D=0B
=0B=B1
h
=81
=9B=0B
=81


=20
=81
=9B=0B=81
=81
=0B
raph

=81
I



=81
ph

=81

=0B
ph
p=81


=81


=0B
=19

=81=81
=81

=81
=0B
raph
=11=81
aph
=0B=11


K=81
p=81
=81=81
=9D=0B
a=81
=9D=0B
=0B=B1
h

=0BA



=81

=11=81
=E8D=9D=0Bi

=19=81
=19=81


rap=81
=81
=0B=11
=19
x?=9D=0B)


=11
=81
a=81


=81=81

=0BY

!
=05=81
h
=0B
raph
(

ph=81



i=81
on.H

=0B
raph
h=81
aph

=19

ap=11=81
, o=81=81
p=81
=9C=0B
=11=81
=9C=0B
=0B=B1
h

=19
=81
=81


=81



e, oI
aph
=19
=11

=81
*=81=81
=0B
raph
=0B=81
aph
=0B=11

=81
=11
=0B
=81
=19=81
=19=81
=81=81
=9C=0B
)1

aph


=81
=81
=81




=81
=0B=81

=FF=81=81
y(=81
=81
o=81

=81a
raph
=11
=81
=0B

ph
=19


=0BI

=81
=81
=11
rs *=81


Y
=81
=81=81=81
=9C=0B


=81
=9C=0B
aph



ph=81
=81


=11=81
=9B=0B
=81
=9B=0B
raph
=0B=11
=9B=0B=11


=11
=81
=0B

=81

=0B
=81
A
=81
=81



=81
=0B)
=81

aph
=9B=0B

,=FFKKK=FF=81
=9B=0B
=81
aph=81
=0B

=11
=9B=0B=11


=11

=81=81
h

=11
=81

=11
=0B
ph


=81
;
y=81
=11


p=81


=81


=81

Y
=81
=81=81
=0B

=19
=81
=11
=81
I
=81


=11

/*=81
i

=81
=81
=20
=81
=9B=0BA


=81

=11
=81


=11
=81=81
=0B(
=0B
=81
=99=81


y
$,=FFK=81
ph
=81

=0B
@
=0B=81
=81

=0B
ph
ph


=81
raph

ph



=81
=11


=81


=0B

=81



=9A=0B




=81
=9A=0B
=11

=81


=19

ap=11

=81

h


ph=81
h
ph


=81


=0B

=81

1
=81

=81

=81
=0B
uq
y
$,=FFK=81
=0B
ph


=0B
=19=81
=19



P=81

=81

=9A=0B

=0B
=19

=81
=81
=9A=0B
aph
ph

=0B=A1
aph
=11
aph
\?=0B=81

i
307=81)

=0BY

!
=05=9A=0B=11
>=0B



=19
=11

bio=81=11

ph
=0B=11
=11

=81

=19

=99=0B
=0B
@
=0B

=0B =81
=99=0B
=0B=11
h



=AA=AAY
=81

=0B=19

!
o=81

=19
=81
=11
=0B
raph
i

=0B

=81

=11

/* =81

d=81

=81
=A9

=0B=11

=11
}=FF=11e}=FF=81
o=81

=19
ey
=99=0B
=81
=99=0B


=0B
=A1

=20
=81

K=FF=81=81
y(
=99=0B


=81
	DME=81

=81

=81
=AA=AA=AAY

=0B

=0B 8

1
ph

=97=0B
=81


ph

=11
=FF(
=0B




=81
=98=0B
ph
=D0=D0=FF=81
=98=0B

rs *=81
=81
;
y
$,=FFKKK=FF=81
=0B
!












=0B
ph=81
aph
ph


=19
=0B




=11
=81
aph
i

=0B

=11
ap=11



=0B
=0B
8
h
Pr=81
=811
<< 8)1
=11


=0B

I

=11
aph
=81
?=AB=AA=AA=AAY

=0B

0
aph
ph


=19


=0B

ph
aph

aph
ph


=19
=0B
ph
ph
=19



ph


=0B
ph
ph

=97=0B

NSE=11
aph
ph


=0B




Prepa=81


=0B

ph


ph

=0B
=19


aph

	DME=81

 r=81
=0B
Xy


=0B
  (me=11

d=81

et;
=81
=0B
uctA

aph
=0B
bio=81

=81
=81
n=81
=0B

=0B
;
free=11
rs *=81

h
=11


=0B

2
2 << 8)=81
=0B
1307=81
ht Q

 y
=0B


e, o=81

=0B
U=85?=AB=AA=AA=AAY

=0B

=0B=20
--=20

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


--=-K2dcRN4NDBj1tMv6PZw+
Content-Disposition: attachment; filename=dm-rdac.png
Content-Type: image/png; name=dm-rdac.png
Content-Transfer-Encoding: base64

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
OXJEQkLi4sWLnp6ev90Ug8HYsmXLtWvXOPP7VlVVeXh4yMjIKCkprVu3jvNn+Nu3by4uLnJycgwG
w97e/vv378T24ODgfv36UalUOTk5b2/vdr41wpw5cy5fviwpKXn8+HFnZ+fa2lq+NAt+FdQBAAAg
ciorK6dMmRIWFiYjI8NkMqdNm9bOBkeOHFldXf3lyxfiyxUrVnz48OHp06e3bt26cuXK4cOHEUI4
jtvY2JSWlr569SorKysvL2/RokUIoZKSkjlz5vj6+n758iUlJWX69OntDMNha2sbFxfXpUuXixcv
WlpaVlRU8KtlwDuoAwAQFD8/v+LiYrJTgI7n+/fv48aNi4uLU1FRuX///rhx49rfpry8PEKopqYG
IVRXVxccHLx//34dHR19ff1NmzadOXMGIZSSkpKSkrJjxw4NDQ1NTc1FixZFRUXV1dX9/PmzoaGh
a9eu3bp109XVNTY2bn8ejtGjR9+/f79r16537twZO3ZsUVERHxsHvIA6AIC2vX//3sHBQUVFhUKh
yMnJDR8+/OTJk22+atWqVb/3oZadnc3L0rGlpaWrVq3q27cvjUaTkpLS0dFxc3PjdK6WlZU5Ozsz
GAx1dfXg4OBmW8AwLDs7+zcStjM5aEVubq6JiUlaWpqmpmZycvKwYcP40mxJSQlCSFVVFSGUl5dX
XV2tp6dHPKWnp0f8GLx69Qoh5OzsPGDAgAEDBmzcuLG+vv779+8aGhqenp6jRo0yNDQ8dOgQUUzw
0ZAhQ5KTk7W0tIhZkj5+/Mjf9kHraGQHAEDUsdlsCwsLfX39qKgoeXn5r1+/pqSkCPREX1VVdd++
fcTjzZs3L168uFu3bo32KSkpMTY2VlRU9PX17devX1lZ2ZMnT27evMlisSQlJRFCXl5eCKGMjIy3
b9/Onj27f//+QpiFnjs5+A2vXr0yMzMrKCjQ09OLi4vr3r07v1p++PChtra2oqIiQqjRHQc4jhPV
G3E74vHjx7t27cp5ligd/vnnn7lz54aHh+/cuTMqKur27dv8Lfi0tbWTk5PNzc2fP39ubGx869Yt
TpkCBA4HosrV1RUhFBoaSnYQUff48WOEkL6+voDaf//+PUKosrLyV1+IEMrKymrn0VtqxMvLa8SI
ETU1Nc2+6ufPn3Q6PTc3l/jy5MmTbm5uAkoI+CU5OVlBQQEhNHLkyNLS0vY01eh/9ufPn8OHD9++
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


--=-K2dcRN4NDBj1tMv6PZw+
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-K2dcRN4NDBj1tMv6PZw+--
