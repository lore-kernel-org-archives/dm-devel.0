From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/19] setup_map: wait for pending path checkers
	to finish
Date: Wed, 19 Dec 2018 00:19:19 +0100
Message-ID: <20181218231931.10762-8-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The timeout for synchronous checks is only 1ms when async path
checking is used, which may easily be missed on busy systems.
That's not a problem for the path checker, because it simply
repeats the check one tick later. However, when maps are
set up (e.g. when new paths are detected), it's desirable
to get the number of active paths right. Therefore, wait a bit
longer if path checkers are found pending in setup_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 65 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5af4a189..39d2a956 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -44,6 +44,10 @@
 #include "sysfs.h"
 #include "io_err_stat.h"
 
+/* Time in ms to wait for pending checkers in setup_map() */
+#define WAIT_CHECKERS_PENDING_MS 10
+#define WAIT_ALL_CHECKERS_PENDING_MS 90
+
 /* group paths in pg by host adapter
  */
 int group_by_host_adapter(struct pathgroup *pgp, vector adapters)
@@ -257,12 +261,43 @@ int rr_optimize_path_order(struct pathgroup *pgp)
 	return 0;
 }
 
+static int wait_for_pending_paths(struct multipath *mpp,
+				  struct config *conf,
+				  int n_pending, int goal, int wait_ms)
+{
+	static const struct timespec millisec =
+		{ .tv_sec = 0, .tv_nsec = 1000*1000 };
+	int i, j;
+	struct path *pp;
+	struct pathgroup *pgp;
+	struct timespec ts;
+
+	do {
+		vector_foreach_slot(mpp->pg, pgp, i) {
+			vector_foreach_slot(pgp->paths, pp, j) {
+				if (pp->state != PATH_PENDING)
+					continue;
+				pp->state = get_state(pp, conf,
+						      0, PATH_PENDING);
+				if (pp->state != PATH_PENDING &&
+				    --n_pending <= goal)
+					return 0;
+			}
+		}
+		ts = millisec;
+		while (nanosleep(&ts, &ts) != 0 && errno == EINTR)
+			/* nothing */;
+	} while (--wait_ms > 0);
+
+	return n_pending;
+}
+
 int setup_map(struct multipath *mpp, char *params, int params_size,
 	      struct vectors *vecs)
 {
 	struct pathgroup * pgp;
 	struct config *conf;
-	int i;
+	int i, n_paths;
 
 	/*
 	 * don't bother if devmap size is unknown
@@ -339,7 +374,9 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 		condlog(0, "%s: unexpected behavior may occur!",
 			mpp->alias);
 	}
-	/*
+
+	n_paths = VECTOR_SIZE(mpp->paths);
+        /*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
 	 */
@@ -353,6 +390,30 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	if (mpp->pgpolicyfn && mpp->pgpolicyfn(mpp))
 		return 1;
 
+	/*
+	 * If async state detection is used, see if pending state checks
+	 * have finished, to get nr_active right. We can't wait until the
+	 * checkers time out, as that may take 30s or more, and we are
+	 * holding the vecs lock.
+	 */
+	if (conf->force_sync == 0 && n_paths > 0) {
+		int n_pending = pathcount(mpp, PATH_PENDING);
+
+		if (n_pending > 0)
+			n_pending = wait_for_pending_paths(
+				mpp, conf, n_pending, 0,
+				WAIT_CHECKERS_PENDING_MS);
+		/* ALL paths pending - wait some more, but be satisfied
+		   with only some paths finished */
+		if (n_pending == n_paths)
+			n_pending = wait_for_pending_paths(
+				mpp, conf, n_pending,
+				n_paths >= 4 ? 2 : 1,
+				WAIT_ALL_CHECKERS_PENDING_MS);
+		if (n_pending > 0)
+			condlog(2, "%s: setting up map with %d/%d path checkers pending",
+				mpp->alias, n_pending, n_paths);
+	}
 	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
 
 	/*
-- 
2.19.2
