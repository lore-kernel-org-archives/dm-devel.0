From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 1 Sep 2010 18:29:19 -0000
Message-ID: <20100901182919.24882.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2010-09-01 18:29:19

Modified files:
	multipathd     : main.c 

Log message:
	Fix for bz #566685. Multipathd now will reload the device if it notices that
	the priorities have changed during the checkerloop.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.28&r2=1.69.2.29

--- multipath-tools/multipathd/main.c	2010/08/09 16:16:10	1.69.2.28
+++ multipath-tools/multipathd/main.c	2010/09/01 18:29:18	1.69.2.29
@@ -52,6 +52,7 @@
 #include <switchgroup.h>
 #include <print.h>
 #include <configure.h>
+#include <pgpolicies.h>
 
 #include "main.h"
 #include "pidfile.h"
@@ -933,6 +934,29 @@
 	return 0;
 }
 
+int update_path_groups(struct multipath *mpp, struct vectors *vecs)
+{
+	int i;
+	struct path * pp;
+
+	update_mpp_paths(mpp, vecs->pathvec);
+	vector_foreach_slot (mpp->paths, pp, i)
+		pathinfo(pp, conf->hwtable, DI_PRIO);
+	setup_map(mpp);
+	mpp->action = ACT_RELOAD;
+	if (domap(mpp) <= 0) {
+		condlog(0, "%s: failed to update map : %s", mpp->alias,
+				strerror(errno));
+		return 1;
+	}
+	dm_lib_release();
+	setup_multipath(vecs, mpp);
+	sync_map_state(mpp);
+
+	return 0;
+}
+
+
 static void *
 checkerloop (void *ap)
 {
@@ -942,6 +966,7 @@
 	int newstate;
 	unsigned int i;
 	sigset_t old;
+	int oldpriority;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
@@ -1095,9 +1120,13 @@
 			 * path prio refreshing
 			 */
 			condlog(4, "path prio refresh");
+			oldpriority = pp->priority;
 			pathinfo(pp, conf->hwtable, DI_PRIO);
 
-			if (need_switch_pathgroup(pp->mpp, 0)) {
+			if (pp->priority != oldpriority &&
+			    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio)
+				update_path_groups(pp->mpp, vecs);
+			else if (need_switch_pathgroup(pp->mpp, 0)) {
 				if (pp->mpp->pgfailback > 0 &&
 				    pp->mpp->failback_tick <= 0)
 					pp->mpp->failback_tick =
