From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 10/13] dm headers: adjust dm-snap identifiers
	to have "dm_" prefix
Date: Wed,  5 Mar 2008 19:56:01 +0100
Message-ID: <1204743364-3248-11-git-send-email-hjm@redhat.com>
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
 drivers/md/dm-snap.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.c linux-2.6.25-rc4/drivers/md/dm-snap.c
index ae24eab..8d2c5bd 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.c
+++ linux-2.6.25-rc4/drivers/md/dm-snap.c
@@ -1,7 +1,8 @@
 /*
  * dm-snapshot.c
  *
- * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2004-2008 Red Hat GmbH
  *
  * This file is released under the GPL.
  */
@@ -9,6 +10,7 @@
 #include <linux/blkdev.h>
 #include <linux/ctype.h>
 #include <linux/device-mapper.h>
+#include <linux/dm-kcopyd.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kdev_t.h>
@@ -21,7 +23,6 @@
 
 #include "dm-snap.h"
 #include "dm-bio-list.h"
-#include "kcopyd.h"
 
 #define DM_MSG_PREFIX "snapshots"
 
@@ -31,7 +32,7 @@
 #define WAKE_UP_PERCENT 5
 
 /*
- * kcopyd priority of snapshot operations
+ * dm-kcopyd priority of snapshot operations
  */
 #define SNAPSHOT_COPY_PRIORITY 2
 
@@ -79,8 +80,7 @@ struct dm_snap_pending_exception {
 	struct dm_snapshot *snap;
 
 	/*
-	 * 1 indicates the exception has already been sent to
-	 * kcopyd.
+	 * 1 indicates the exception has already been sent to dm-kcopyd.
 	 */
 	int started;
 };
@@ -558,9 +558,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad4;
 	}
 
-	r = kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
+	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->dm_kcopyd_client);
 	if (r) {
-		ti->error = "Could not create kcopyd client";
+		ti->error = "Could not create dm-kcopyd client";
 		goto bad5;
 	}
 
@@ -591,7 +591,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 
  bad6:
-	kcopyd_client_destroy(s->kcopyd_client);
+	dm_kcopyd_client_destroy(s->dm_kcopyd_client);
 
  bad5:
 	s->store.destroy(&s->store);
@@ -613,8 +613,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 static void __free_exceptions(struct dm_snapshot *s)
 {
-	kcopyd_client_destroy(s->kcopyd_client);
-	s->kcopyd_client = NULL;
+	dm_kcopyd_client_destroy(s->dm_kcopyd_client);
+	s->dm_kcopyd_client = NULL;
 
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
@@ -629,7 +629,7 @@ static void snapshot_dtr(struct dm_target *ti)
 	flush_workqueue(ksnapd);
 
 	/* Prevent further origin writes from using this snapshot. */
-	/* After this returns there can be no new kcopyd jobs. */
+	/* After this returns there can be no new dm-kcopyd jobs. */
 	unregister_snapshot(s);
 
 	__free_exceptions(s);
@@ -801,7 +801,7 @@ static void commit_callback(void *context, int success)
 }
 
 /*
- * Called when the copy I/O has finished.  kcopyd actually runs
+ * Called when the copy I/O has finished.  dm-kcopyd actually runs
  * this code so don't block.
  */
 static void copy_callback(int read_err, unsigned int write_err, void *context)
@@ -819,12 +819,12 @@ static void copy_callback(int read_err, unsigned int write_err, void *context)
 }
 
 /*
- * Dispatches the copy operation to kcopyd.
+ * Dispatches the copy operation to dm-kcopyd.
  */
 static void start_copy(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snapshot *s = pe->snap;
-	struct io_region src, dest;
+	struct dm_io_region src, dest;
 	struct block_device *bdev = s->origin->bdev;
 	sector_t dev_size;
 
@@ -838,9 +838,9 @@ static void start_copy(struct dm_snap_pending_exception *pe)
 	dest.sector = chunk_to_sector(s, pe->e.new_chunk);
 	dest.count = src.count;
 
-	/* Hand over to kcopyd */
-	kcopyd_copy(s->kcopyd_client,
-		    &src, 1, &dest, 0, copy_callback, pe);
+	/* Hand over to dm-kcopyd */
+	dm_kcopyd_copy(s->dm_kcopyd_client,
+		       &src, 1, &dest, 0, copy_callback, pe);
 }
 
 /*
-- 
1.5.4.1
