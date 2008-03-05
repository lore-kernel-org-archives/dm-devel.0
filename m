From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 04/13] dm headers: adjust for new structure
	names
Date: Wed,  5 Mar 2008 19:55:55 +0100
Message-ID: <1204743364-3248-5-git-send-email-hjm@redhat.com>
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
 drivers/md/dm-io.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-io.c linux-2.6.25-rc4/drivers/md/dm-io.c
index b8e342f..4569a18 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-io.c
+++ linux-2.6.25-rc4/drivers/md/dm-io.c
@@ -1,12 +1,15 @@
 /*
  * Copyright (C) 2003 Sistina Software
- * Copyright (C) 2006 Red Hat GmbH
+ * Copyright (C) 2004-2008 Red Hat GmbH
+ *
+ * Device-Mapper low-level I/O routines.
  *
  * This file is released under the GPL.
  */
 
-#include "dm-io.h"
+#include "dm.h"
 
+#include <linux/dm-io.h>
 #include <linux/bio.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
@@ -271,7 +274,7 @@ static void km_dp_init(struct dpages *dp, void *data)
 /*-----------------------------------------------------------------
  * IO routines that accept a list of pages.
  *---------------------------------------------------------------*/
-static void do_region(int rw, unsigned int region, struct io_region *where,
+static void do_region(int rw, unsigned int region, struct dm_io_region *where,
 		      struct dpages *dp, struct io *io)
 {
 	struct bio *bio;
@@ -320,7 +323,7 @@ static void do_region(int rw, unsigned int region, struct io_region *where,
 }
 
 static void dispatch_io(int rw, unsigned int num_regions,
-			struct io_region *where, struct dpages *dp,
+			struct dm_io_region *where, struct dpages *dp,
 			struct io *io, int sync)
 {
 	int i;
@@ -347,7 +350,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
 }
 
 static int sync_io(struct dm_io_client *client, unsigned int num_regions,
-		   struct io_region *where, int rw, struct dpages *dp,
+		   struct dm_io_region *where, int rw, struct dpages *dp,
 		   unsigned long *error_bits)
 {
 	struct io io;
@@ -384,7 +387,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 }
 
 static int async_io(struct dm_io_client *client, unsigned int num_regions,
-		    struct io_region *where, int rw, struct dpages *dp,
+		    struct dm_io_region *where, int rw, struct dpages *dp,
 		    io_notify_fn fn, void *context)
 {
 	struct io *io;
@@ -438,7 +441,7 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp)
  * New collapsed (a)synchronous interface
  */
 int dm_io(struct dm_io_request *io_req, unsigned num_regions,
-	  struct io_region *where, unsigned long *sync_error_bits)
+	  struct dm_io_region *where, unsigned long *sync_error_bits)
 {
 	int r;
 	struct dpages dp;
-- 
1.5.4.1
