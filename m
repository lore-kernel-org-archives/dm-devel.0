From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFT/RFC 3/4] convert dm emc
Date: Fri, 30 Sep 2005 14:42:20 -0500
Message-ID: <1128109340.24395.25.camel@max>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

dm emc does not have to do very much now :)
I am still trying to figure out the best way
to evaluate the sense but allow a hw handler to
overide the decision. dm-emc just fails
on all errors so I did not put much effort into
it for the moment.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/md/dm-emc.c b/drivers/md/dm-emc.c
--- a/drivers/md/dm-emc.c
+++ b/drivers/md/dm-emc.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2004 SUSE LINUX Products GmbH. All rights reserved.
  * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
  *
  * This file is released under the GPL.
  *
@@ -21,202 +22,85 @@ struct emc_handler {
 	/* Whether or not to honor SCSI reservations when initiating a
 	 * switch-over. Default: Don't. */
 	unsigned hr;
-
-	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
 #define TRESPASS_PAGE 0x22
 #define EMC_FAILOVER_TIMEOUT (60 * HZ)
 
-/* Code borrowed from dm-lsi-rdac by Mike Christie */
+static unsigned char emc_long_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x81,		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
 
-static inline void free_bio(struct bio *bio)
-{
-	__free_page(bio->bi_io_vec[0].bv_page);
-	bio_put(bio);
-}
+static unsigned char emc_long_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x01,		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
 
-static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
-{
-	struct path *path = bio->bi_private;
+static unsigned char emc_short_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x81,		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
 
-	if (bio->bi_size)
-		return 1;
+static unsigned char emc_short_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x01,		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
+
+/* Code borrowed from dm-lsi-rdac by Mike Christie */
 
+static unsigned emc_rq_error(struct path *path, int result,
+			     struct scsi_sense_hdr *sense)
+{
 	/* We also need to look at the sense keys here whether or not to
 	 * switch to the next PG etc.
 	 *
 	 * For now simple logic: either it works or it doesn't.
 	 */
-	if (error)
-		dm_pg_init_complete(path, MP_FAIL_PATH);
-	else
-		dm_pg_init_complete(path, 0);
-
-	/* request is freed in block layer */
-	free_bio(bio);
-
-	return 0;
-}
-
-static struct bio *get_failover_bio(struct path *path, unsigned data_size)
-{
-	struct bio *bio;
-	struct page *page;
-
-	bio = bio_alloc(GFP_ATOMIC, 1);
-	if (!bio) {
-		DMERR("dm-emc: get_failover_bio: bio_alloc() failed.");
-		return NULL;
-	}
-
-	bio->bi_rw |= (1 << BIO_RW);
-	bio->bi_bdev = path->dev->bdev;
-	bio->bi_sector = 0;
-	bio->bi_private = path;
-	bio->bi_end_io = emc_endio;
-
-	page = alloc_page(GFP_ATOMIC);
-	if (!page) {
-		DMERR("dm-emc: get_failover_bio: alloc_page() failed.");
-		bio_put(bio);
-		return NULL;
-	}
-
-	if (bio_add_page(bio, page, data_size, 0) != data_size) {
-		DMERR("dm-emc: get_failover_bio: alloc_page() failed.");
-		__free_page(page);
-		bio_put(bio);
-		return NULL;
-	}
-
-	return bio;
-}
-
-static struct request *get_failover_req(struct emc_handler *h,
-					struct bio *bio, struct path *path)
-{
-	struct request *rq;
-	struct block_device *bdev = bio->bi_bdev;
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	/* FIXME: Figure out why it fails with GFP_ATOMIC. */
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
-	if (!rq) {
-		DMERR("dm-emc: get_failover_req: blk_get_request failed");
-		return NULL;
-	}
-
-	rq->bio = rq->biotail = bio;
-	blk_rq_bio_prep(q, rq, bio);
-
-	rq->rq_disk = bdev->bd_contains->bd_disk;
-
-	/* bio backed don't set data */
-	rq->buffer = rq->data = NULL;
-	/* rq data_len used for pc cmd's request_bufflen */
-	rq->data_len = bio->bi_size;
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
-
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
-
-	rq->timeout = EMC_FAILOVER_TIMEOUT;
-	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);
-
-	return rq;
-}
-
-static struct request *emc_trespass_get(struct emc_handler *h,
-					struct path *path)
-{
-	struct bio *bio;
-	struct request *rq;
-	unsigned char *page22;
-	unsigned char long_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x09,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff, 0xff,           /* Trespass target */
-		0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
-		};
-	unsigned char short_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x02,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff,                 /* Trespass target */
-		};
-	unsigned data_size = h->short_trespass ? sizeof(short_trespass_pg) :
-				sizeof(long_trespass_pg);
-
-	/* get bio backing */
-	if (data_size > PAGE_SIZE)
-		/* this should never happen */
-		return NULL;
-
-	bio = get_failover_bio(path, data_size);
-	if (!bio) {
-		DMERR("dm-emc: emc_trespass_get: no bio");
-		return NULL;
-	}
-
-	page22 = (unsigned char *)bio_data(bio);
-	memset(page22, 0, data_size);
-
-	memcpy(page22, h->short_trespass ?
-		short_trespass_pg : long_trespass_pg, data_size);
-
-	/* get request for block layer packet command */
-	rq = get_failover_req(h, bio, path);
-	if (!rq) {
-		DMERR("dm-emc: emc_trespass_get: no rq");
-		free_bio(bio);
-		return NULL;
-	}
-
-	/* Prepare the command. */
-	rq->cmd[0] = MODE_SELECT;
-	rq->cmd[1] = 0x10;
-	rq->cmd[4] = data_size;
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
-
-	return rq;
+	return result ? MP_FAIL_PATH : 0;
 }
 
 static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
 			struct path *path)
 {
-	struct request *rq;
-	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+	struct emc_handler *h = hwh->context;
+	unsigned char *page22;
+	unsigned data_size;
+	unsigned char cmd[MAX_COMMAND_SIZE];
 
-	/*
-	 * We can either blindly init the pg (then look at the sense),
-	 * or we can send some commands to get the state here (then
-	 * possibly send the fo cmnd), or we can also have the
-	 * initial state passed into us and then get an update here.
-	 */
-	if (!q) {
-		DMINFO("dm-emc: emc_pg_init: no queue");
-		goto fail_path;
+	if (h->short_trespass) {
+		page22 = h->hr ? emc_short_trespass_hr : emc_short_trespass;
+		data_size = sizeof(emc_short_trespass);
+	} else {
+		page22 = h->hr ? emc_long_trespass_hr : emc_long_trespass;
+		data_size = sizeof(emc_long_trespass);
 	}
 
-	/* FIXME: The request should be pre-allocated. */
-	rq = emc_trespass_get(hwh->context, path);
-	if (!rq) {
-		DMERR("dm-emc: emc_pg_init: no rq");
-		goto fail_path;
-	}
+	/* Prepare the command. */
+	memset(cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = MODE_SELECT;
+	cmd[1] = 0x10;
+	cmd[4] = data_size;
 
 	DMINFO("dm-emc: emc_pg_init: sending switch-over command");
-	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
-	return;
 
-fail_path:
-	dm_pg_init_complete(path, MP_FAIL_PATH);
+	if (dm_scsi_execute_rq(hwh, path, cmd, DMA_TO_DEVICE, page22, data_size,
+			       EMC_FAILOVER_TIMEOUT, __GFP_WAIT))
+		dm_pg_init_complete(path, MP_FAIL_PATH);
 }
 
 static struct emc_handler *alloc_emc_handler(void)
@@ -263,6 +147,11 @@ static int emc_create(struct hw_handler 
 
 	hwh->context = h;
 
+	if (dm_scsi_init_context_pool(hwh)) {
+		kfree(h);
+		return -ENOMEM;
+	}
+
 	if ((h->short_trespass = short_trespass))
 		DMWARN("dm-emc: short trespass command will be send");
 	else
@@ -280,6 +169,7 @@ static void emc_destroy(struct hw_handle
 {
 	struct emc_handler *h = (struct emc_handler *) hwh->context;
 
+	dm_scsi_destroy_context_pool(hwh);
 	kfree(h);
 	hwh->context = NULL;
 }
@@ -329,6 +219,7 @@ static struct hw_handler_type emc_hwh = 
 	.destroy = emc_destroy,
 	.pg_init = emc_pg_init,
 	.error = emc_error,
+	.rq_error = emc_rq_error,
 };
 
 static int __init dm_emc_init(void)
