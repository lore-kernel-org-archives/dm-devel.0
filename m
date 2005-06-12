From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] HP SW support take 3
Date: Sun, 12 Jun 2005 15:13:00 -0700
Message-ID: <1118614380.5318.11.camel@mina>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Fix locking bug. Will have to send the block layer stuff to
Jens Axboe when we get hp-sw support finished. For now I included
everything in one patch (reminder - don't use things like rd,
dm, md, aoe, or anything without a real queue under dm-mpath
if you are using a hw_hanlder that injects a failover command).

This was only tested with scsi_debug.


diff -Naurp linux-2.6.12-rc5.orig/drivers/block/ll_rw_blk.c linux-2.6.12-rc5/drivers/block/ll_rw_blk.c
--- linux-2.6.12-rc5.orig/drivers/block/ll_rw_blk.c	2005-06-08 19:30:08.000000000 -0700
+++ linux-2.6.12-rc5/drivers/block/ll_rw_blk.c	2005-06-12 14:40:29.000000000 -0700
@@ -2369,7 +2369,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2398,6 +2398,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	/*
diff -Naurp linux-2.6.12-rc5.orig/drivers/md/dm-hp-sw.c linux-2.6.12-rc5/drivers/md/dm-hp-sw.c
--- linux-2.6.12-rc5.orig/drivers/md/dm-hp-sw.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.12-rc5/drivers/md/dm-hp-sw.c	2005-06-12 14:31:30.000000000 -0700
@@ -0,0 +1,160 @@
+/*
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Basic, very basic, support for HP StorageWorks and FSC FibreCat
+ */
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+
+#include "dm.h"
+#include "dm-hw-handler.h"
+
+struct hp_sw_handler {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+};
+
+static void hp_sw_endio(struct request *rq)
+{
+	struct path *path = rq->end_io_data;
+
+	/*
+	 * TODO: something.. we have the sense and scsi bytes
+	 */
+	if (rq->errors) {
+		DMINFO("hp_sw: START_STOP completed %d", rq->errors);
+		dm_pg_init_complete(path, MP_FAIL_PATH);
+	} else
+		dm_pg_init_complete(path, 0);
+
+	__blk_put_request(rq->q, rq);
+}
+
+static struct request *hp_sw_get_request(struct hp_sw_handler *h,
+					struct path *path)
+{
+	struct request *rq;
+	struct block_device *bdev = path->dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	rq = blk_get_request(q, READ, __GFP_WAIT);
+	if (!rq)
+		return NULL;
+
+	rq->end_io = hp_sw_endio;
+	rq->end_io_data = path;
+	rq->rq_disk = bdev->bd_contains->bd_disk;
+	rq->sense = h->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
+	/*
+	 * TODO: make me configurable
+	 */
+	rq->timeout = 30;
+	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);
+
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	rq->cmd[0] = START_STOP;
+	/* Start spin cycle */
+	rq->cmd[4] = 1;
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+
+	return rq;
+}
+
+static void hp_sw_pg_init(struct hw_handler *hwh, unsigned bypassed,
+			   struct path *path)
+{
+	struct request *rq;
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+
+	/*
+	 * We can either blindly init the pg (then look at the sense),
+	 * or we can send some commands to get the state here (then
+	 * possibly send the fo cmnd), or we can also have the
+	 * initial state passed into us and then get an update here.
+	 */
+	if (!q) {
+		DMERR("hp_sw: no queue!");
+		goto fail_path;
+	}
+
+	if (blk_get_queue(q))
+		goto fail_path;
+
+	rq = hp_sw_get_request(hwh->context, path);
+	if (!rq) {
+		DMERR("hp_sw: could not allocate request for START_STOP");
+		goto rel_queue;
+	}
+
+	DMINFO("hp_sw: queueing START_STOP command");
+	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
+	blk_put_queue(q);
+	return;
+
+rel_queue:
+	blk_put_queue(q);
+fail_path:
+	dm_pg_init_complete(path, MP_FAIL_PATH);
+}
+
+static int hp_sw_create(struct hw_handler *hwh, unsigned argc, char **argv)
+{
+	struct hp_sw_handler *h;
+
+	h = kmalloc(sizeof(*h), GFP_KERNEL);
+	if (!h) {
+		DMERR("hp_sw: could not allocate hw_handler");
+		return -ENOMEM;
+	}
+
+	hwh->context = h;
+	return 0;
+}
+
+static void hp_sw_destroy(struct hw_handler *hwh)
+{
+	struct hp_sw_handler *h = hwh->context;
+
+	kfree(h);
+	hwh->context = NULL;
+}
+
+static struct hw_handler_type hp_sw_hwh = {
+	.name = "hp_sw",
+	.module = THIS_MODULE,
+	.create = hp_sw_create,
+	.destroy = hp_sw_destroy,
+	.pg_init = hp_sw_pg_init,
+};
+
+static int __init hp_sw_init(void)
+{
+	int r;
+
+	r = dm_register_hw_handler(&hp_sw_hwh);
+	if (r < 0)
+		DMERR("hp_sw: register failed %d", r);
+
+	DMINFO("hp_sw version 0.3 loaded");
+
+	return r;
+}
+
+static void __exit hp_sw_exit(void)
+{
+	int r;
+
+	r = dm_unregister_hw_handler(&hp_sw_hwh);
+	if (r < 0)
+		DMERR("hp_sw: unregister failed %d", r);
+}
+
+module_init(hp_sw_init);
+module_exit(hp_sw_exit);
+
+MODULE_DESCRIPTION("HP StorageWorks and FSC FibreCat support for dm-multipath");
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>");
+MODULE_LICENSE("GPL");
diff -Naurp linux-2.6.12-rc5.orig/drivers/md/Kconfig linux-2.6.12-rc5/drivers/md/Kconfig
--- linux-2.6.12-rc5.orig/drivers/md/Kconfig	2005-06-08 19:30:05.000000000 -0700
+++ linux-2.6.12-rc5/drivers/md/Kconfig	2005-06-10 23:23:31.000000000 -0700
@@ -236,5 +236,14 @@ config DM_MULTIPATH_EMC
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
 
+config DM_MULTIPATH_HP_SW
+	tristate "HP StorageWorks and FSC FibreCat (EXPERIMENTAL)"
+	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Multipath support for HP StorageWorks and FSC FibreCat.
+          This was created with no knowledge of the HW other than
+          that it uses a START_STOP command for failover so it
+          is marked EXPERIMENTAL.
+
 endmenu
 
diff -Naurp linux-2.6.12-rc5.orig/drivers/md/Makefile linux-2.6.12-rc5/drivers/md/Makefile
--- linux-2.6.12-rc5.orig/drivers/md/Makefile	2005-06-08 19:30:05.000000000 -0700
+++ linux-2.6.12-rc5/drivers/md/Makefile	2005-06-10 23:23:31.000000000 -0700
@@ -33,6 +33,7 @@ obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
+obj-$(CONFIG_DM_MULTIPATH_HP_SW) += dm-hp-sw.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
diff -Naurp linux-2.6.12-rc5.orig/include/linux/blkdev.h linux-2.6.12-rc5/include/linux/blkdev.h
--- linux-2.6.12-rc5.orig/include/linux/blkdev.h	2005-06-08 19:28:52.000000000 -0700
+++ linux-2.6.12-rc5/include/linux/blkdev.h	2005-06-12 14:40:00.000000000 -0700
@@ -540,6 +540,7 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern void __blk_attempt_remerge(request_queue_t *, struct request *);
