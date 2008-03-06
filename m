From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 5/6] dm headers(2nd): adjust Copyright
	notices and add MODULE_* macros
Date: Thu,  6 Mar 2008 14:11:44 +0100
Message-ID: <1204809105-22360-6-git-send-email-hjm@redhat.com>
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

---
 drivers/md/dm-exception-store.c |    2 +-
 drivers/md/dm-io.c              |    6 +++++-
 drivers/md/dm-kcopyd.c          |    8 ++++++--
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-raid1.c           |    3 ++-
 drivers/md/dm-snap.c            |    5 +++--
 drivers/md/dm-snap.h            |    3 ++-
 7 files changed, 20 insertions(+), 9 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c linux-2.6.25-rc4/drivers/md/dm-exception-store.c
index 17b0f8f..c68a90e 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c
+++ linux-2.6.25-rc4/drivers/md/dm-exception-store.c
@@ -2,7 +2,7 @@
  * dm-exception-store.c
  *
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
- * Copyright (C) 2006 Red Hat GmbH
+ * Copyright (C) 2004-2008 Red Hat, Inc. All Rights Reserved.
  *
  * This file is released under the GPL.
  */
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-io.c linux-2.6.25-rc4/drivers/md/dm-io.c
index fcf4322..ec1fe19 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-io.c
+++ linux-2.6.25-rc4/drivers/md/dm-io.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2003 Sistina Software
- * Copyright (C) 2006 Red Hat GmbH
+ * Copyright (C) 2004-2008 Red Hat, Inc. All Rights Reserved.
  *
  * This file is released under the GPL.
  */
@@ -456,3 +456,7 @@ int dm_io(struct dm_io_request *io_req, unsigned num_regions,
 			&dp, io_req->notify.fn, io_req->notify.context);
 }
 EXPORT_SYMBOL(dm_io);
+
+MODULE_DESCRIPTION(DM_NAME " low-level I/O");
+MODULE_AUTHOR("Joe Thornber, Heinz Mauelshagen <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-kcopyd.c linux-2.6.25-rc4/drivers/md/dm-kcopyd.c
index 530929c..1a6cbab 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-kcopyd.c
+++ linux-2.6.25-rc4/drivers/md/dm-kcopyd.c
@@ -1,6 +1,6 @@
 /*
- * Copyright (C) 2002 Sistina Software (UK) Limited.
- * Copyright (C) 2006 Red Hat GmbH
+ * Copyright (C) 2002-2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All Rights Reserved.
  *
  * This file is released under the GPL.
  *
@@ -708,3 +708,7 @@ void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
 EXPORT_SYMBOL(dm_kcopyd_client_create);
 EXPORT_SYMBOL(dm_kcopyd_client_destroy);
 EXPORT_SYMBOL(dm_kcopyd_copy);
+
+MODULE_DESCRIPTION(DM_NAME " kernel copy daemon");
+MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.c linux-2.6.25-rc4/drivers/md/dm-log.c
index f52b840..6cc12c3 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.25-rc4/drivers/md/dm-log.c
@@ -793,5 +793,5 @@ module_init(dm_dirty_log_init);
 module_exit(dm_dirty_log_exit);
 
 MODULE_DESCRIPTION(DM_NAME " dirty region log");
-MODULE_AUTHOR("Heinz Mauelshagen <hjm@redhat.com>");
+MODULE_AUTHOR("Joe Thornber, Heinz Mauelshagen <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c linux-2.6.25-rc4/drivers/md/dm-raid1.c
index aec42ea..67b671a 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.25-rc4/drivers/md/dm-raid1.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2003 Sistina Software Limited.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All Rights Reserved.
  *
  * This file is released under the GPL.
  */
@@ -1885,5 +1886,5 @@ module_init(dm_mirror_init);
 module_exit(dm_mirror_exit);
 
 MODULE_DESCRIPTION(DM_NAME " mirror target");
-MODULE_AUTHOR("Joe Thornber");
+MODULE_AUTHOR("Joe Thornber, Heinz Mauelshagen <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.c linux-2.6.25-rc4/drivers/md/dm-snap.c
index c9c0c41..ca26cfa 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.c
+++ linux-2.6.25-rc4/drivers/md/dm-snap.c
@@ -1,7 +1,8 @@
 /*
  * dm-snapshot.c
  *
- * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All Rights Reserved.
  *
  * This file is released under the GPL.
  */
@@ -1362,5 +1363,5 @@ module_init(dm_snapshot_init);
 module_exit(dm_snapshot_exit);
 
 MODULE_DESCRIPTION(DM_NAME " snapshot target");
-MODULE_AUTHOR("Joe Thornber");
+MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.h linux-2.6.25-rc4/drivers/md/dm-snap.h
index 214548e..47070a2 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.h
+++ linux-2.6.25-rc4/drivers/md/dm-snap.h
@@ -1,7 +1,8 @@
 /*
  * dm-snapshot.c
  *
- * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All Rights Reserved.
  *
  * This file is released under the GPL.
  */
-- 
1.5.4.1
