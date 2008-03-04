From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 2/4] dm-log: make dm-log.c a standalone dirty
	region log module to be sharable
Date: Tue,  4 Mar 2008 15:28:29 +0100
Message-ID: <1204640911-28469-3-git-send-email-hjm@redhat.com>
References: <1204640911-28469-1-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1204640911-28469-1-git-send-email-hjm@redhat.com>
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


Change dm-log.c messages from "mirror log" to "dirty region log" and
allow for kernel module.


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-log.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git 2.6.25-rc3.orig/drivers/md/dm-log.c 2.6.25-rc3/drivers/md/dm-log.c
index 2a74b21..48bbc2f 100644
--- 2.6.25-rc3.orig/drivers/md/dm-log.c
+++ 2.6.25-rc3/drivers/md/dm-log.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2003 Sistina Software
+ * Copyright (C) 2007-2008 Red Hat Inc.
  *
  * This file is released under the LGPL.
  */
@@ -12,7 +13,7 @@
 #include "dm-log.h"
 #include "dm-io.h"
 
-#define DM_MSG_PREFIX "mirror log"
+#define DM_MSG_PREFIX "dirty region log"
 
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
@@ -315,7 +316,7 @@ static int create_log_context(struct dirty_log *log, struct dm_target *ti,
 	int r;
 
 	if (argc < 1 || argc > 2) {
-		DMWARN("wrong number of arguments to mirror log");
+		DMWARN("wrong number of arguments to dirty region log");
 		return -EINVAL;
 	}
 
@@ -325,7 +326,7 @@ static int create_log_context(struct dirty_log *log, struct dm_target *ti,
 		else if (!strcmp(argv[1], "nosync"))
 			sync = NOSYNC;
 		else {
-			DMWARN("unrecognised sync argument to mirror log: %s",
+			DMWARN("unrecognised sync argument to dirty region log: %s",
 			       argv[1]);
 			return -EINVAL;
 		}
@@ -467,7 +468,7 @@ static int disk_ctr(struct dirty_log *log, struct dm_target *ti,
 	struct dm_dev *dev;
 
 	if (argc < 2 || argc > 3) {
-		DMWARN("wrong number of arguments to disk mirror log");
+		DMWARN("wrong number of arguments to disk dirty region log");
 		return -EINVAL;
 	}
 
@@ -524,7 +525,7 @@ static int disk_resume(struct dirty_log *log)
 	/* read the disk header */
 	r = read_header(lc);
 	if (r) {
-		DMWARN("%s: Failed to read header on mirror log device",
+		DMWARN("%s: Failed to read header on dirty region log device",
 		       lc->log_dev->name);
 		fail_log_device(lc);
 		/*
@@ -562,7 +563,7 @@ static int disk_resume(struct dirty_log *log)
 	/* write the new header */
 	r = write_header(lc);
 	if (r) {
-		DMWARN("%s: Failed to write header on mirror log device",
+		DMWARN("%s: Failed to write header on dirty region log device",
 		       lc->log_dev->name);
 		fail_log_device(lc);
 	}
@@ -786,3 +787,11 @@ EXPORT_SYMBOL(dm_register_dirty_log_type);
 EXPORT_SYMBOL(dm_unregister_dirty_log_type);
 EXPORT_SYMBOL(dm_create_dirty_log);
 EXPORT_SYMBOL(dm_destroy_dirty_log);
+
+/* Module hooks. */
+module_init(dm_dirty_log_init);
+module_exit(dm_dirty_log_exit);
+
+MODULE_DESCRIPTION(DM_NAME " device-mapper dirty region log");
+MODULE_AUTHOR("Heinz Mauelshagen <hjm@redhat.de>");
+MODULE_LICENSE("GPL");
-- 
1.5.4.1
