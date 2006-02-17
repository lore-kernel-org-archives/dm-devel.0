From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: dm-multipath: nr_active fix
Date: Thu, 16 Feb 2006 18:43:16 -0600
Message-ID: <20060217004316.GC15044@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="i0/AhcQY5QxfSsSZ"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There is some weirdness in the nr_active handling in multipathd, For instance,
whenever you change state to a PATH_DOWN or PATH_SHAKY state, you decrement
the number of active paths, even if you change from PATH_DOWN to PATH_SHAKY.

The attached patch attempts to fix the problem.  It slightly changes how some
of the states are handled.

-Ben

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="states.patch"

diff -urpN mp-devel-clean/libmultipath/structs_vec.c mp-devel-patched/libmultipath/structs_vec.c
--- mp-devel-clean/libmultipath/structs_vec.c	2006-02-13 11:53:36.000000000 -0600
+++ mp-devel-patched/libmultipath/structs_vec.c	2006-02-16 19:14:18.000000000 -0600
@@ -214,7 +214,7 @@ extern void
 set_no_path_retry(struct multipath *mpp)
 {
 	mpp->retry_tick = 0;
-	mpp->nr_active = pathcount(mpp, PATH_UP);
+	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
 	select_no_path_retry(mpp);
 
 	switch (mpp->no_path_retry) {
diff -urpN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel-clean/multipathd/main.c	2006-02-16 12:17:19.000000000 -0600
+++ mp-devel-patched/multipathd/main.c	2006-02-16 19:14:40.000000000 -0600
@@ -282,10 +282,13 @@ update_multipath (struct vectors *vecs, 
 				continue;
 
 			if (pp->state != PATH_DOWN) {
+				int oldstate = pp->state;
 				condlog(2, "%s: mark as failed", pp->dev_t);
 				mpp->stat_path_failures++;
 				pp->state = PATH_DOWN;
-				update_queue_mode_del_path(mpp);
+				if (oldstate == PATH_UP ||
+				    oldstate == PATH_GHOST)
+					update_queue_mode_del_path(mpp);
 
 				/*
 				 * if opportune,
@@ -1032,7 +1035,7 @@ exit_daemon (int status)
 }
 
 static void
-fail_path (struct path * pp)
+fail_path (struct path * pp, int del_active)
 {
 	if (!pp->mpp)
 		return;
@@ -1041,14 +1044,15 @@ fail_path (struct path * pp)
 		 pp->dev_t, pp->mpp->alias);
 
 	dm_fail_path(pp->mpp->alias, pp->dev_t);
-	update_queue_mode_del_path(pp->mpp);
+	if (del_active)
+		update_queue_mode_del_path(pp->mpp);
 }
 
 /*
  * caller must have locked the path list before calling that function
  */
 static void
-reinstate_path (struct path * pp)
+reinstate_path (struct path * pp, int add_active)
 {
 	if (!pp->mpp)
 		return;
@@ -1057,7 +1061,8 @@ reinstate_path (struct path * pp)
 		condlog(0, "%s: reinstate failed", pp->dev_t);
 	else {
 		condlog(2, "%s: reinstated", pp->dev_t);
-		update_queue_mode_add_path(pp->mpp);
+		if (add_active)
+			update_queue_mode_add_path(pp->mpp);
 	}
 }
 
@@ -1191,6 +1196,7 @@ checkerloop (void *ap)
 			}
 
 			if (newstate != pp->state) {
+				int oldstate = pp->state;
 				pp->state = newstate;
 				LOG_MSG(1, checker_message(&pp->checker));
 
@@ -1207,7 +1213,11 @@ checkerloop (void *ap)
 					/*
 					 * proactively fail path in the DM
 					 */
-					fail_path(pp);
+					if (oldstate == PATH_UP ||
+					    oldstate == PATH_GHOST)
+						fail_path(pp, 1);
+					else
+						fail_path(pp, 0);
 
 					/*
 					 * cancel scheduled failback
@@ -1221,7 +1231,11 @@ checkerloop (void *ap)
 				/*
 				 * reinstate this path
 				 */
-				reinstate_path(pp);
+				if (oldstate != PATH_UP &&
+				    oldstate != PATH_GHOST)
+					reinstate_path(pp, 1);
+				else
+					reinstate_path(pp, 0);
 
 				/*
 				 * schedule [defered] failback

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--i0/AhcQY5QxfSsSZ--
