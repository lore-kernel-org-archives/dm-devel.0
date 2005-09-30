From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFT/RFC 4/4] add dm-hp-sw hw handler
Date: Fri, 30 Sep 2005 14:42:22 -0500
Message-ID: <1128109342.24395.26.camel@max>
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

This the basic handler but cleaned up. HP pointed me
to some qlogic code I can use to get more info so I
hope to integrate some of that code when I get a chance.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff -Naurp linux-2.6.14-rc2/drivers/md/dm-hp-sw.c linux-2.6.14-rc2.work/drivers/md/dm-hp-sw.c
--- linux-2.6.14-rc2/drivers/md/dm-hp-sw.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc2.work/drivers/md/dm-hp-sw.c	2005-09-30 14:12:58.000000000 -0500
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Basic, very basic, support for HP StorageWorks and FSC FibreCat
+ */
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
+
+#include "dm.h"
+#include "dm-hw-handler.h"
+
+static unsigned emc_rq_error(struct path *path, int result,
+			     struct scsi_sense_hdr *sense)
+{
+	DMINFO("hp_sw: hp_sw_endio 0x%x", result);
+	/*
+	 * TODO: get info from qlogic failover driver and
+	 * eval sense/ASC/ASCQ
+	 */
+	/*
+	 * just return true and send down the IO to see
+	 * if it worked for now
+	 */
+	if (scsi_sense_valid(sense))
+		scsi_print_sense_hdr("dm-hp-sw", sense);
+	return 0;
+}
+
+static void hp_sw_pg_init(struct hw_handler *hwh, unsigned bypassed,
+			   struct path *path)
+{
+	unsigned char cmd[MAX_COMMAND_SIZE];
+
+	memset(cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = START_STOP;
+	/* Start spin cycle */
+	cmd[4] = 1;
+
+	DMINFO("hp_sw: queueing START_STOP command on %s",
+		path->dev->name);
+
+	if (dm_scsi_execute_rq(hwh, path, cmd, DMA_NONE, NULL, 0, 60 * HZ,
+			       __GFP_WAIT))
+		dm_pg_init_complete(path, MP_FAIL_PATH);
+}
+
+/*
+ * Placeholders for coming code
+ */
+static int hp_sw_create(struct hw_handler *hwh, unsigned argc, char **argv)
+{
+	int err;
+
+	err = dm_scsi_init_context_pool(hwh);
+	if (err) {
+		DMERR("hp_sw: could not setup context pool");
+		return err;
+	}
+	return 0;
+}
+
+static void hp_sw_destroy(struct hw_handler *hwh)
+{
+	dm_scsi_destroy_context_pool(hwh);
+}
+
+static struct hw_handler_type hp_sw_hwh = {
+	.name = "hp_sw",
+	.module = THIS_MODULE,
+	.create = hp_sw_create,
+	.destroy = hp_sw_destroy,
+	.pg_init = hp_sw_pg_init,
+	.rq_error = emc_rq_error,
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
+	DMINFO("hp_sw version 0.4 loaded");
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
diff -Naurp linux-2.6.14-rc2/drivers/md/Kconfig linux-2.6.14-rc2.work/drivers/md/Kconfig
--- linux-2.6.14-rc2/drivers/md/Kconfig	2005-09-19 22:00:41.000000000 -0500
+++ linux-2.6.14-rc2.work/drivers/md/Kconfig	2005-09-30 00:05:37.000000000 -0500
@@ -236,5 +236,10 @@ config DM_MULTIPATH_EMC
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
 
+config DM_MULTIPATH_HP_SW
+	tristate "HP StorageWorks and FSC FibreCat support"
+	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  HP StorageWorks and FSC FibreCat support for dm-multipath.
 endmenu
 
diff -Naurp linux-2.6.14-rc2/drivers/md/Makefile linux-2.6.14-rc2.work/drivers/md/Makefile
--- linux-2.6.14-rc2/drivers/md/Makefile	2005-09-19 22:00:41.000000000 -0500
+++ linux-2.6.14-rc2.work/drivers/md/Makefile	2005-09-30 00:05:37.000000000 -0500
@@ -34,6 +34,7 @@ obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
+obj-$(CONFIG_DM_MULTIPATH_HP_SW) += dm-hp-sw.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
