From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 11/13] dm headers: adjust dm-exception-store
	identifiers to have "dm_" prefix
Date: Wed,  5 Mar 2008 19:56:02 +0100
Message-ID: <1204743364-3248-12-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/Makefile             |    4 ++--
 drivers/md/dm-exception-store.c |   13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/Makefile linux-2.6.25-rc4/drivers/md/Makefile
index be4b069..d9aa7ed 100644
--- linux-2.6.25-rc4.orig/drivers/md/Makefile
+++ linux-2.6.25-rc4/drivers/md/Makefile
@@ -6,7 +6,7 @@ dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o kcopyd.o
 dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
-dm-mirror-objs	:= dm-raid1.o
+dm-mirror-objs	:= dm-log.o dm-raid1.o
 dm-rdac-objs	:= dm-mpath-rdac.o
 dm-hp-sw-objs	:= dm-mpath-hp-sw.o
 md-mod-objs     := md.o bitmap.o
@@ -39,7 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_MULTIPATH_HP)	+= dm-hp-sw.o
 obj-$(CONFIG_DM_MULTIPATH_RDAC)	+= dm-rdac.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
-obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o
+obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
 quiet_cmd_unroll = UNROLL  $@
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c linux-2.6.25-rc4/drivers/md/dm-exception-store.c
index 5bbce29..d211519 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c
+++ linux-2.6.25-rc4/drivers/md/dm-exception-store.c
@@ -1,17 +1,16 @@
 /*
  * dm-exception-store.c
  *
- * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
- * Copyright (C) 2006 Red Hat GmbH
+ * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2004-2008 Red Hat GmbH
  *
  * This file is released under the GPL.
  */
 
 #include "dm.h"
 #include "dm-snap.h"
-#include "dm-io.h"
-#include "kcopyd.h"
 
+#include <linux/dm-io.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
@@ -98,7 +97,7 @@ struct pstore {
 	uint32_t exceptions_per_area;
 
 	/*
-	 * Now that we have an asynchronous kcopyd there is no
+	 * Now that we have an asynchronous dm_io there is no
 	 * need for large chunk sizes, so it wont hurt to have a
 	 * whole chunks worth of metadata in memory at once.
 	 */
@@ -159,7 +158,7 @@ static void free_area(struct pstore *ps)
 }
 
 struct mdata_req {
-	struct io_region *where;
+	struct dm_io_region *where;
 	struct dm_io_request *io_req;
 	struct work_struct work;
 	int result;
@@ -177,7 +176,7 @@ static void do_metadata(struct work_struct *work)
  */
 static int chunk_io(struct pstore *ps, uint32_t chunk, int rw, int metadata)
 {
-	struct io_region where = {
+	struct dm_io_region where = {
 		.bdev = ps->snap->cow->bdev,
 		.sector = ps->snap->chunk_size * chunk,
 		.count = ps->snap->chunk_size,
-- 
1.5.4.1
