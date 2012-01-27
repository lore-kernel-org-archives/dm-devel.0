From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: Update multipath device on show
	topology
Date: Fri, 27 Jan 2012 14:41:49 -0600
Message-ID: <20120127204149.GV1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

when multipathd's show_map_topology or show_maps_topology commands are
called, multipathd doesn't update its device state from the kernel.  So,
if you do something like call disablequeueing first, show_map_topology won't
register the change. This patche makes multipathd update the device before
printing the topology. This also requires a change to setup_multipath, to
allow it to just read the kernel state, and not update anything.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c |   18 ++++++++++--------
 libmultipath/structs_vec.h |    6 ++++--
 libmultipath/waiter.c      |    2 +-
 multipathd/cli_handlers.c  |   14 +++++++++++---
 4 files changed, 26 insertions(+), 14 deletions(-)

Index: multipath-tools-120123/multipathd/cli_handlers.c
===================================================================
--- multipath-tools-120123.orig/multipathd/cli_handlers.c
+++ multipath-tools-120123/multipathd/cli_handlers.c
@@ -68,13 +68,16 @@ show_paths (char ** r, int * len, struct
 }
 
 int
-show_map_topology (char ** r, int * len, struct multipath * mpp)
+show_map_topology (char ** r, int * len, struct multipath * mpp,
+		   struct vectors * vecs)
 {
 	char * c;
 	char * reply;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
 
+	if (update_multipath(vecs, mpp->alias, 0))
+		return 1;
 	reply = MALLOC(maxlen);
 
 	while (again) {
@@ -112,9 +115,14 @@ show_maps_topology (char ** r, int * len
 
 		c = reply;
 
-		vector_foreach_slot(vecs->mpvec, mpp, i)
+		vector_foreach_slot(vecs->mpvec, mpp, i) {
+			if (update_multipath(vecs, mpp->alias, 0)) {
+				i--;
+				continue;
+			}
 			c += snprint_multipath_topology(c, reply + maxlen - c,
 							mpp, 2);
+		}
 
 		again = ((c - reply) == (maxlen - 1));
 
@@ -232,7 +240,7 @@ cli_list_map_topology (void * v, char **
 
 	condlog(3, "list multipath %s (operator)", param);
 
-	return show_map_topology(reply, len, mpp);
+	return show_map_topology(reply, len, mpp, vecs);
 }
 
 int
Index: multipath-tools-120123/libmultipath/structs_vec.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/structs_vec.c
+++ multipath-tools-120123/libmultipath/structs_vec.c
@@ -324,7 +324,7 @@ set_no_path_retry(struct multipath *mpp)
 }
 
 extern int
-setup_multipath (struct vectors * vecs, struct multipath * mpp)
+__setup_multipath (struct vectors * vecs, struct multipath * mpp, int reset)
 {
 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		/* Error accessing table */
@@ -353,11 +353,13 @@ setup_multipath (struct vectors * vecs,
 		condlog(3, "%s: no hardware entry found, using defaults",
 			mpp->alias);
 	}
-	select_rr_weight(mpp);
-	select_pgfailback(mpp);
-	set_no_path_retry(mpp);
-	select_pg_timeout(mpp);
-	select_flush_on_last_del(mpp);
+	if (reset) {
+		select_rr_weight(mpp);
+		select_pgfailback(mpp);
+		set_no_path_retry(mpp);
+		select_pg_timeout(mpp);
+		select_flush_on_last_del(mpp);
+	}
 
 	return 0;
 out:
@@ -479,7 +481,7 @@ verify_paths(struct multipath * mpp, str
 	return count;
 }
 
-int update_multipath (struct vectors *vecs, char *mapname)
+int update_multipath (struct vectors *vecs, char *mapname, int reset)
 {
 	struct multipath *mpp;
 	struct pathgroup  *pgp;
@@ -496,7 +498,7 @@ int update_multipath (struct vectors *ve
 	free_pgvec(mpp->pg, KEEP_PATHS);
 	mpp->pg = NULL;
 
-	if (setup_multipath(vecs, mpp))
+	if (__setup_multipath(vecs, mpp, reset))
 		return 1; /* mpp freed in setup_multipath */
 
 	adopt_paths(vecs->pathvec, mpp, 0);
Index: multipath-tools-120123/libmultipath/structs_vec.h
===================================================================
--- multipath-tools-120123.orig/libmultipath/structs_vec.h
+++ multipath-tools-120123/libmultipath/structs_vec.h
@@ -21,7 +21,9 @@ void orphan_path (struct path * pp);
 
 int verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
-int setup_multipath (struct vectors * vecs, struct multipath * mpp);
+int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
+		       int reset);
+#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
 int update_multipath_strings (struct multipath *mpp, vector pathvec);
 	
 void remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec);
@@ -32,7 +34,7 @@ void remove_maps_and_stop_waiters (struc
 struct multipath * add_map_without_path (struct vectors * vecs, char * alias);
 struct multipath * add_map_with_path (struct vectors * vecs,
 				struct path * pp, int add_vec);
-int update_multipath (struct vectors *vecs, char *mapname);
+int update_multipath (struct vectors *vecs, char *mapname, int reset);
 void update_queue_mode_del_path(struct multipath *mpp);
 void update_queue_mode_add_path(struct multipath *mpp);
 
Index: multipath-tools-120123/libmultipath/waiter.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/waiter.c
+++ multipath-tools-120123/libmultipath/waiter.c
@@ -157,7 +157,7 @@ int waiteventloop (struct event_thread *
 		 */
 		pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
 		lock(waiter->vecs->lock);
-		r = update_multipath(waiter->vecs, waiter->mapname);
+		r = update_multipath(waiter->vecs, waiter->mapname, 1);
 		lock_cleanup_pop(waiter->vecs->lock);
 
 		if (r) {
