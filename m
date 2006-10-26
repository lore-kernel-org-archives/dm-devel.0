From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Ideas for generalizing the path selector so mirroring
	can use it for read balancing
Date: Thu, 26 Oct 2006 17:02:51 -0500
Message-ID: <1161900171.20907.8.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yFdgkAyTVRIvg2215eWt"
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
To: dm-devel@redhat.com, heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


--=-yFdgkAyTVRIvg2215eWt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I've attached three patches.  Descriptions are in the headers, but I'll
put them here for convenience too.

1) generalize_path_selection.patch
###################################
Generalize the path selector functions/interface so that it doesn't
rely on the caller having to use 'struct path's.  The path is now
a 'void *', which can be 'struct path' in the case of multipath, or
'struct mirror' in the case of mirrors.

Path selector modules (like round-robin) can no longer use fields
that were available in 'struct path'.  In some functions, this
requires iterating over the paths to find the corresponding
path_info structure, where the 'path' void pointer acts as the
key.  However, the affected functions are rarely
used (initialization, path failures, path restorations, and status),
and this shouldn't hurt performance.  (But it does make things
much easier for the user of the interface.)

2) auto_path_selection.patch
############################
I've added a 'auto_select_path' which doesn't require the caller
to keep any path selection information (like repeat_count).  It
simply switches paths when it is time to switch paths.

A better interface might be:
'force_select_path'
'select_path'
with the first acting as the current 'select_path' does.  However,
I didn't want to change what people expect.

I think, for various path selection techniques, that the
repeat_count makes no sense - so why force people to track something
that is specific to only certain path selection modules.  I think
it should be internalized - hence the new function.

I just want the path selection routines to give me the right path
based on the algorithm they implement.  Why should I have to do
additional work on my end for path selection?

3) mirror_read_balance.patch
############################
This is an incomplete patch.

Because we do not yet know the layout of the mirror mapping table, I
can not parse it - so I've skipped the setup of the path selector.

However, there should be enough here to envision how mirroring would
use the path selector if it was there.

 brassow



--=-yFdgkAyTVRIvg2215eWt
Content-Disposition: attachment; filename=auto_path_selection.patch
Content-Type: text/x-patch; name=auto_path_selection.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

I've added a 'auto_select_path' which doesn't require the caller
to keep any path selection information (like repeat_count).  It
simply switches paths when it is time to switch paths.

A better interface might be:
force_select_path
select_path
with the first acting as the current 'select_path' does.  However,
I didn't want to change what people expect.

I think, for various path selection techniques, that the
repeat_count makes no sense - so why force people to track something
that is specific to only certain path selection modules.  I think
it should be internalized - hence the new function.

I just want the path selection routines to give me the right path
based on the algorithm they implement.  Why should I have to do
additional work on my end for path selection?

Index: linux-2.6.18.1/drivers/md/dm-path-selector.h
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-path-selector.h	2006-10-26 15:38:01.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-path-selector.h	2006-10-26 15:44:03.000000000 -0500
@@ -56,6 +56,17 @@ struct path_selector_type {
 	void *(*select_path) (struct path_selector *ps,
 			      unsigned *repeat_count);
 
+
+	/*
+	 * Chooses a path for this io, if no paths are available then
+	 * NULL will be returned.
+	 *
+	 * Different from 'select_path' because it tracks repeat_count
+	 * itself, only returning a new path when the particular
+	 * algorithm requires.
+	 */
+	void *(*auto_select_path) (struct path_selector *ps);
+
 	/*
 	 * Notify the selector that a path has failed.
 	 */
Index: linux-2.6.18.1/drivers/md/dm-round-robin.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-round-robin.c	2006-10-26 15:38:01.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-round-robin.c	2006-10-26 15:49:05.000000000 -0500
@@ -22,6 +22,7 @@
 struct path_info {
 	struct list_head list;
 	void *path;
+	unsigned current_count;
 	unsigned repeat_count;
 };
 
@@ -158,6 +159,7 @@ static int rr_add_path(struct path_selec
 
 	pi->path = path;
 	pi->repeat_count = repeat_count;
+	pi->current_count = 0;
 
 	list_add(&pi->list, &s->valid_paths);
 
@@ -211,6 +213,22 @@ static void *rr_select_path(struct path_
 	return pi ? pi->path : NULL;
 }
 
+static void *rr_auto_select_path(struct path_selector *ps)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi = NULL;
+
+	if (!list_empty(&s->valid_paths)) {
+		pi = list_entry(s->valid_paths.next, struct path_info, list);
+		if (++(pi->current_count) == pi->repeat_count) {
+			pi->current_count = 0;
+			list_move_tail(&pi->list, &s->valid_paths);
+		}
+	}
+
+	return pi ? pi->path : NULL;
+}
+
 static struct path_selector_type rr_ps = {
 	.name = "round-robin",
 	.module = THIS_MODULE,
@@ -223,6 +241,7 @@ static struct path_selector_type rr_ps =
 	.fail_path = rr_fail_path,
 	.reinstate_path = rr_reinstate_path,
 	.select_path = rr_select_path,
+	.auto_select_path = rr_auto_select_path,
 };
 
 static int __init dm_rr_init(void)

--=-yFdgkAyTVRIvg2215eWt
Content-Disposition: attachment; filename=generalize_path_selection.patch
Content-Type: text/x-patch; name=generalize_path_selection.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Generalize the path selector functions/interface so that it doesn't
rely on the caller having to use 'struct path's.  The path is now
a 'void *', which can be 'struct path' in the case of multipath, or
'struct mirror' in the case of mirrors.

Path selector modules (like round-robin) can no longer use fields
that were available in 'struct path'.  In some functions, this
requires iterating over the paths to find the corresponding 
path_info structure, where the 'path' void pointer acts as the
key.  However, the affected functions are rarely
used (initialization, path failures, path restorations, and status),
and this shouldn't hurt performance.  (But it does make things
much easier from the user of the interface's perspective.)

Index: linux-2.6.18.1/drivers/md/dm-mpath.h
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-mpath.h	2006-09-19 22:42:06.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-mpath.h	2006-10-26 14:59:52.000000000 -0500
@@ -15,7 +15,6 @@ struct path {
 	struct dm_dev *dev;	/* Read-only */
 	unsigned is_active;	/* Read-only */
 
-	void *pscontext;	/* For path-selector use */
 	void *hwhcontext;	/* For hw-handler use */
 };
 
Index: linux-2.6.18.1/drivers/md/dm-path-selector.h
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-path-selector.h	2006-09-19 22:42:06.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-path-selector.h	2006-10-26 15:04:19.000000000 -0500
@@ -14,8 +14,6 @@
 
 #include <linux/device-mapper.h>
 
-#include "dm-mpath.h"
-
 /*
  * We provide an abstraction for the code that chooses which path
  * to send some io down.
@@ -44,7 +42,7 @@ struct path_selector_type {
 	 * Add an opaque path object, along with some selector specific
 	 * path args (eg, path priority).
 	 */
-	int (*add_path) (struct path_selector *ps, struct path *path,
+	int (*add_path) (struct path_selector *ps, void *path,
 			 int argc, char **argv, char **error);
 
 	/*
@@ -55,27 +53,27 @@ struct path_selector_type {
 	 * calling the function again.  0 means don't call it again unless
 	 * the path fails.
 	 */
-	struct path *(*select_path) (struct path_selector *ps,
-				     unsigned *repeat_count);
+	void *(*select_path) (struct path_selector *ps,
+			      unsigned *repeat_count);
 
 	/*
 	 * Notify the selector that a path has failed.
 	 */
-	void (*fail_path) (struct path_selector *ps, struct path *p);
+	void (*fail_path) (struct path_selector *ps, void *path);
 
 	/*
 	 * Ask selector to reinstate a path.
 	 */
-	int (*reinstate_path) (struct path_selector *ps, struct path *p);
+	int (*reinstate_path) (struct path_selector *ps, void *path);
 
 	/*
 	 * Table content based on parameters added in ps_add_path_fn
 	 * or path selector status
 	 */
-	int (*status) (struct path_selector *ps, struct path *path,
+	int (*status) (struct path_selector *ps, void *path,
 		       status_type_t type, char *result, unsigned int maxlen);
 
-	int (*end_io) (struct path_selector *ps, struct path *path);
+	int (*end_io) (struct path_selector *ps, void *path, struct dm_dev *dev);
 };
 
 /* Register a path selector */
Index: linux-2.6.18.1/drivers/md/dm-round-robin.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-round-robin.c	2006-09-19 22:42:06.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-round-robin.c	2006-10-26 14:58:11.000000000 -0500
@@ -21,7 +21,7 @@
  *---------------------------------------------------------------*/
 struct path_info {
 	struct list_head list;
-	struct path *path;
+	void *path;
 	unsigned repeat_count;
 };
 
@@ -80,20 +80,33 @@ static void rr_destroy(struct path_selec
 	ps->context = NULL;
 }
 
-static int rr_status(struct path_selector *ps, struct path *path,
+static int rr_status(struct path_selector *ps, void *path,
 		     status_type_t type, char *result, unsigned int maxlen)
 {
-	struct path_info *pi;
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *tmp, *pi = NULL;
 	int sz = 0;
 
-	if (!path)
+	list_for_each_entry(tmp, &s->valid_paths, list)
+		if (tmp->path == path) {
+			pi = tmp;
+			break;
+		}
+
+	if (!pi)
+		list_for_each_entry(tmp, &s->invalid_paths, list)
+			if (tmp->path == path) {
+				pi = tmp;
+				break;
+			}
+
+	if (!pi)
 		DMEMIT("0 ");
 	else {
 		switch(type) {
 		case STATUSTYPE_INFO:
 			break;
 		case STATUSTYPE_TABLE:
-			pi = path->pscontext;
 			DMEMIT("%u ", pi->repeat_count);
 			break;
 		}
@@ -106,7 +119,7 @@ static int rr_status(struct path_selecto
  * Called during initialisation to register each path with an
  * optional repeat_count.
  */
-static int rr_add_path(struct path_selector *ps, struct path *path,
+static int rr_add_path(struct path_selector *ps, void *path,
 		       int argc, char **argv, char **error)
 {
 	struct selector *s = (struct selector *) ps->context;
@@ -124,6 +137,18 @@ static int rr_add_path(struct path_selec
 		return -EINVAL;
 	}
 
+	list_for_each_entry(pi, &s->valid_paths, list)
+		if (pi->path == path) {
+			*error = "round-robin ps: path already specified";
+			return -EINVAL;
+		}
+
+	list_for_each_entry(pi, &s->invalid_paths, list)
+		if (pi->path == path) {
+			*error = "round-robin ps: path already specified";
+			return -EINVAL;
+		}
+
 	/* allocate the path */
 	pi = kmalloc(sizeof(*pi), GFP_KERNEL);
 	if (!pi) {
@@ -134,33 +159,45 @@ static int rr_add_path(struct path_selec
 	pi->path = path;
 	pi->repeat_count = repeat_count;
 
-	path->pscontext = pi;
-
 	list_add(&pi->list, &s->valid_paths);
 
 	return 0;
 }
 
-static void rr_fail_path(struct path_selector *ps, struct path *p)
+static void rr_fail_path(struct path_selector *ps, void *path)
 {
 	struct selector *s = (struct selector *) ps->context;
-	struct path_info *pi = p->pscontext;
+	struct path_info *tmp, *pi = NULL;
+
+	list_for_each_entry(tmp, &s->valid_paths, list)
+		if (tmp->path == path)
+			pi = tmp;
 
-	list_move(&pi->list, &s->invalid_paths);
+	if (pi)
+		list_move(&pi->list, &s->invalid_paths);
+	else
+		DMWARN("Unable to fail path that is not in valid paths list");
 }
 
-static int rr_reinstate_path(struct path_selector *ps, struct path *p)
+static int rr_reinstate_path(struct path_selector *ps, void *path)
 {
 	struct selector *s = (struct selector *) ps->context;
-	struct path_info *pi = p->pscontext;
+	struct path_info *tmp, *pi = NULL;
 
-	list_move(&pi->list, &s->valid_paths);
+	list_for_each_entry(tmp, &s->valid_paths, list)
+		if (tmp->path == path)
+			pi = tmp;
+
+	if (pi)
+		list_move(&pi->list, &s->valid_paths);
+	else
+		DMWARN("Unable to reinstate path that is not in invalid paths list");
 
 	return 0;
 }
 
-static struct path *rr_select_path(struct path_selector *ps,
-				   unsigned *repeat_count)
+static void *rr_select_path(struct path_selector *ps,
+			    unsigned *repeat_count)
 {
 	struct selector *s = (struct selector *) ps->context;
 	struct path_info *pi = NULL;
Index: linux-2.6.18.1/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-mpath.c	2006-09-19 22:42:06.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-mpath.c	2006-10-26 15:18:29.000000000 -0500
@@ -1063,7 +1063,7 @@ static int multipath_end_io(struct dm_ta
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path);
+			ps->type->end_io(ps, &pgpath->path, pgpath->path.dev);
 	}
 	if (r <= 0)
 		mempool_free(mpio, m->mpio_pool);

--=-yFdgkAyTVRIvg2215eWt
Content-Disposition: attachment; filename=mirror_read_balance.patch
Content-Type: text/x-patch; name=mirror_read_balance.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

This is an imcomplete patch.

Because we do not yet know the layout of the mirror mapping table, I
can not parse it - so I've skipped the setup of the path selector.

However, there should be enough here to envision how mirroring would
use the path selector if it was there.

Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-10-26 15:40:02.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-10-26 16:42:08.000000000 -0500
@@ -9,6 +9,7 @@
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
+#include "dm-path-selector.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -134,6 +135,7 @@ struct mirror_set {
 	region_t nr_regions;
 	int in_sync;
 
+	struct path_selector *ps;
 	struct mirror *default_mirror;	/* Default mirror */
 
 	unsigned int nr_mirrors;
@@ -708,10 +710,41 @@ static void do_recovery(struct mirror_se
 /*-----------------------------------------------------------------
  * Reads
  *---------------------------------------------------------------*/
+static struct mirror *read_balance(struct path_selector *ps)
+{
+	struct mirror *m;
+
+	if (!ps || !ps->type || !ps->type->auto_select_path)
+		return NULL;
+
+	m = ps->type->auto_select_path(ps);
+	while (m && atomic_read(&m->error_count)) {
+		ps->type->fail_path(ps, m);
+		m = ps->type->auto_select_path(ps);
+	}
+	return m;
+}
+
 static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
 {
-	/* FIXME: add read balancing */
-	return ms->default_mirror;
+	struct mirror *m = NULL;
+
+	if (ms->ps)
+		m = read_balance(ms->ps);
+
+	if (m)
+		return m;
+
+	m = ms->default_mirror;
+	do {
+		if (likely(!atomic_read(&m->error_count)))
+			return m;
+
+		if (m-- == ms->mirror)
+			m += ms->nr_mirrors;
+	} while (m != ms->default_mirror);
+
+	return NULL;
 }
 
 /*

--=-yFdgkAyTVRIvg2215eWt
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-yFdgkAyTVRIvg2215eWt--
