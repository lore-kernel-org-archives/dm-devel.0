From: dwysocha@redhat.com
Subject: [patch 1/3] Extremely basic hp hardware handler (no
	retries, no error handling, etc).
Date: Thu, 24 May 2007 01:17:48 -0400
Message-ID: <20070524051813.277264505@redhat.com>
References: <20070524051747.219219749@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-hp-sw-v0.0.2.patch
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
Cc: Mike Christie <michaelc@cs.wisc.edu>, Dave Wysochanski <dave.wysochanski@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dave Wysochanski <dave.wysochanski@redhat.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

--
Index: linux-2.6.22-rc1/drivers/md/Makefile
===================================================================
--- linux-2.6.22-rc1.orig/drivers/md/Makefile
+++ linux-2.6.22-rc1/drivers/md/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
+obj-$(CONFIG_DM_MULTIPATH_HP)	+= dm-hp-sw.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
Index: linux-2.6.22-rc1/drivers/md/dm-hp-sw.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc1/drivers/md/dm-hp-sw.c
@@ -0,0 +1,204 @@
+/*
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
+ * Copyright (C) 2007 Red Hat, Inc. All rights reserved.
+ * Authors: Mike Christie
+ *          Dave Wysochanski
+ *
+ * This file is released under the GPL.
+ *
+ * This module implements the specific path activation code for
+ * HP StorageWorks and FSC FibreCat Asymmetric (Active/Passive)
+ * storage arrays.
+ * These storage arrays have controller-based failover, not
+ * LUN-based failover.  However, LUN-based failover is the design
+ * of dm-multipath. Thus, this module is written for LUN-based failover.
+ */
+#include <linux/list.h>
+#include <linux/types.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+
+#include "dm.h"
+#include "dm-hw-handler.h"
+
+#define DM_MSG_PREFIX "multipath hp"
+
+struct hp_sw_context {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+};
+
+
+/**
+ * hp_sw_end_io - Completion handler for HP path activation.
+ * @req: failover request
+ * @error: scsi-ml error
+ *
+ *  Check sense data, free request structure, and notify dm that
+ *  pg initialization has completed.
+ *
+ * Context: scsi-ml softirq
+ *
+ * Possible optimizations
+ * 1. Actually check sense data for retryable error (e.g. NOT_READY)
+ */
+static void hp_sw_end_io(struct request *req, int error)
+{
+	struct dm_path *path = req->end_io_data;
+	unsigned err_flags;
+
+	if (!error) {
+		err_flags = 0;
+		DMDEBUG("hp_sw: path activation command on %s - success",
+		       	path->dev->name);
+	} else {
+		DMWARN("hp_sw: path activation command on %s - error=0x%x",
+		       path->dev->name, error);
+		err_flags = MP_FAIL_PATH;
+	}
+
+	req->end_io_data = NULL;
+	__blk_put_request(req->q, req);
+	dm_pg_init_complete(path, err_flags);
+}
+
+/**
+ * hp_sw_get_request - Allocate an HP specific path activation request
+ * @path: path on which request will be sent (needed for request queue)
+ *
+ * The START command is used for path activation request.
+ * These arrays are controller-based failover, not LUN based.
+ * One START command issued to a single path will fail over all
+ * LUNs for the same controller.
+ *
+ * Possible optimizations
+ * 1. Make timeout configurable
+ * 2. Preallocate request
+ */
+static struct request *hp_sw_get_request(struct dm_path *path)
+{
+	struct request *req=NULL;
+	struct block_device *bdev = path->dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct hp_sw_context *h = path->hwhcontext;
+
+	req = blk_get_request(q, WRITE, GFP_ATOMIC);
+	if (req == NULL)
+		goto exit;
+
+	req->timeout = 60*HZ;
+
+	req->errors = 0;
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
+	req->end_io = hp_sw_end_io;
+	req->end_io_data = path;
+	req->sense = h->sense;
+	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
+
+	memset(&req->cmd, 0, BLK_MAX_CDB);
+	req->cmd[0] = START_STOP;
+	req->cmd[4] = 1;
+	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
+exit:
+	return req;
+}
+
+/**
+ * hp_sw_pg_init - HP path activation implementation.
+ * @hwh: hardware handler specific data
+ * @bypassed: unused; is the path group bypassed? (see dm-mpath.c)
+ * @path: path to send initialization command
+ *
+ * Send an HP-specific path activation command on 'path'.
+ * Do not try to optimize in any way, just send the activation command.
+ * More than one path activation command may be sent to the same controller.
+ * This seems to work fine for basic failover support.
+ *
+ * Possible optimizations
+ * 1. Detect an in-progress activation request and avoid submitting another one
+ * 2. Model the controller and only send a single activation request at a time
+ * 3. Determine the state of a path before sending an activation request
+ *
+ * Context: kmpathd (see process_queued_ios() in dm-mpath.c)
+ */
+static void hp_sw_pg_init(struct hw_handler *hwh, unsigned bypassed,
+			  struct dm_path *path)
+{
+	struct request *req;
+	struct hp_sw_context *h;
+
+	path->hwhcontext = hwh->context;
+	h = (struct hp_sw_context *) hwh->context;
+
+	req = hp_sw_get_request(path);
+	if (!req) {
+		DMERR("hp_sw: path activation command allocation fail on %s ",
+		      path->dev->name);
+		goto fail;
+	}
+
+	DMDEBUG("hp_sw: path activation command sent on %s",
+		path->dev->name);
+
+	elv_add_request(req->q, req, ELEVATOR_INSERT_FRONT, 1);
+	return;
+
+ fail:
+	dm_pg_init_complete(path, MP_FAIL_PATH);
+}
+
+static int hp_sw_create(struct hw_handler *hwh, unsigned argc, char **argv)
+{
+	struct hp_sw_context *h;
+
+	h = kmalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+	hwh->context = h;
+	return 0;
+}
+
+static void hp_sw_destroy(struct hw_handler *hwh)
+{
+	struct hp_sw_context *h = hwh->context;
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
+	DMINFO("hp_sw version 0.0.2 loaded");
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
+MODULE_DESCRIPTION("HP StorageWorks and FSC FibreCat (A/P) support for dm-multipath");
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>");
+MODULE_LICENSE("GPL");
Index: linux-2.6.22-rc1/drivers/md/Kconfig
===================================================================
--- linux-2.6.22-rc1.orig/drivers/md/Kconfig
+++ linux-2.6.22-rc1/drivers/md/Kconfig
@@ -271,6 +271,12 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_MULTIPATH_HP
+        tristate "HP MSA multipath support (EXPERIMENTAL)"
+        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        ---help---
+          Multipath support for HP MSA (Active/Passive) series hardware.
+
 endmenu
 
 endif

-- 
