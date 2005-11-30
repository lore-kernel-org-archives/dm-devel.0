From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH RFC 3/4] dm-mpath calls to dm-netlink
Date: Wed, 30 Nov 2005 00:28:12 -0800
Message-ID: <20051130082812.GC18284@us.ibm.com>
References: <20051130082311.GA18453@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051130082311.GA18453@us.ibm.com>
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

This patch adds a call to init dm_nl during dm init, and calls to dm_nl
functions for path failure / reinstate events.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/md/dm-mpath.c |    9 ++++++---
 drivers/md/dm.c       |    2 ++
 drivers/md/dm.h       |    3 +++
 3 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6.15-rc1-patched/drivers/md/dm.h
===================================================================
--- linux-2.6.15-rc1-patched.orig/drivers/md/dm.h	2005-06-17 17:21:30.000000000 -0700
+++ linux-2.6.15-rc1-patched/drivers/md/dm.h	2005-11-29 23:32:32.000000000 -0800
@@ -192,4 +192,7 @@ void dm_stripe_exit(void);
 void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 union map_info *dm_get_mapinfo(struct bio *bio);
 
+int dm_nl_init(void);
+void dm_nl_exit(void);
+
 #endif
Index: linux-2.6.15-rc1-patched/drivers/md/dm.c
===================================================================
--- linux-2.6.15-rc1-patched.orig/drivers/md/dm.c	2005-10-27 18:52:10.000000000 -0700
+++ linux-2.6.15-rc1-patched/drivers/md/dm.c	2005-11-29 23:32:32.000000000 -0800
@@ -163,6 +163,7 @@ int (*_inits[])(void) __initdata = {
 	dm_linear_init,
 	dm_stripe_init,
 	dm_interface_init,
+	dm_nl_init,
 };
 
 void (*_exits[])(void) = {
@@ -171,6 +172,7 @@ void (*_exits[])(void) = {
 	dm_linear_exit,
 	dm_stripe_exit,
 	dm_interface_exit,
+	dm_nl_exit,
 };
 
 static int __init dm_init(void)
Index: linux-2.6.15-rc1-patched/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.15-rc1-patched.orig/drivers/md/dm-mpath.c	2005-10-27 18:52:10.000000000 -0700
+++ linux-2.6.15-rc1-patched/drivers/md/dm-mpath.c	2005-11-29 23:32:32.000000000 -0800
@@ -10,6 +10,7 @@
 #include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
+#include "dm-netlink.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -798,7 +799,7 @@ static int multipath_map(struct dm_targe
 /*
  * Take a path out of use.
  */
-static int fail_path(struct pgpath *pgpath)
+static int fail_path(struct pgpath *pgpath, struct bio *bio)
 {
 	unsigned long flags;
 	struct multipath *m = pgpath->pg->m;
@@ -819,6 +820,7 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	dm_nl_path_fail(pgpath->path.dev->name, 0x5A5A5A5A);
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -858,6 +860,7 @@ static int reinstate_path(struct pgpath 
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_nl_path_reinstate(pgpath->path.dev->name);
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -975,7 +978,7 @@ void dm_pg_init_complete(struct path *pa
 		err_flags |= MP_FAIL_PATH;
 
 	if (err_flags & MP_FAIL_PATH)
-		fail_path(pgpath);
+		fail_path(pgpath, NULL);
 
 	if (err_flags & MP_BYPASS_PG)
 		bypass_pg(m, pg, 1);
@@ -1027,7 +1030,7 @@ static int do_end_io(struct multipath *m
 
 	if (mpio->pgpath) {
 		if (err_flags & MP_FAIL_PATH)
-			fail_path(mpio->pgpath);
+			fail_path(mpio->pgpath, bio);
 
 		if (err_flags & MP_BYPASS_PG)
 			bypass_pg(m, mpio->pgpath->pg, 1);
