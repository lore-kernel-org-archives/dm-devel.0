From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 13/14] multipathd: use marginal_pathgroups
Date: Fri, 23 Aug 2019 12:48:57 -0500
Message-ID: <1566582538-5979-14-git-send-email-bmarzins@redhat.com>
References: <1566582538-5979-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1566582538-5979-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Muneendra Kumar <mkumar@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This commit makes the marginal_pathgroups option work with the
existing methods for determining marginal paths.  It also merges the
code for the marginal_path and sand_path_err methods. This has the
side effect of making the marginal_path code set a marginal path's state
to "delayed" instead of "shaky" like it previously did.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 53 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index dca2214c..04b2b56a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1960,6 +1960,18 @@ reinstate_path:
 	return 0;
 }
 
+static int
+should_skip_path(struct path *pp){
+	if (marginal_path_check_enabled(pp->mpp)) {
+		if (pp->io_err_disable_reinstate && need_io_err_check(pp))
+			return 1;
+	} else if (san_path_check_enabled(pp->mpp)) {
+		if (check_path_reinstate_state(pp))
+			return 1;
+	}
+	return 0;
+}
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1975,6 +1987,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	int oldchkrstate = pp->chkrstate;
 	int retrigger_tries, checkint, max_checkint, verbosity;
 	struct config *conf;
+	int marginal_pathgroups, marginal_changed = 0;
 	int ret;
 
 	if ((pp->initialized == INIT_OK ||
@@ -1991,6 +2004,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	checkint = conf->checkint;
 	max_checkint = conf->max_checkint;
 	verbosity = conf->verbosity;
+	marginal_pathgroups = conf->marginal_pathgroups;
 	put_multipath_config(conf);
 
 	if (pp->checkint == CHECKINT_UNDEF) {
@@ -2106,20 +2120,27 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	set_no_path_retry(pp->mpp);
 
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
-			check_path_reinstate_state(pp)) {
-		pp->state = PATH_DELAYED;
-		return 1;
-	}
-
-	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
-	    pp->io_err_disable_reinstate && need_io_err_check(pp)) {
-		pp->state = PATH_SHAKY;
-		/*
-		 * to reschedule as soon as possible,so that this path can
-		 * be recoverd in time
-		 */
-		pp->tick = 1;
-		return 1;
+	    (san_path_check_enabled(pp->mpp) ||
+	     marginal_path_check_enabled(pp->mpp))) {
+		int was_marginal = pp->marginal;
+		if (should_skip_path(pp)) {
+			if (!marginal_pathgroups) {
+				if (marginal_path_check_enabled(pp->mpp))
+					/* to reschedule as soon as possible,
+					 * so that this path can be recovered
+					 * in time */
+					pp->tick = 1;
+				pp->state = PATH_DELAYED;
+				return 1;
+			}
+			if (!was_marginal) {
+				pp->marginal = 1;
+				marginal_changed = 1;
+			}
+		} else if (marginal_pathgroups && was_marginal) {
+			pp->marginal = 0;
+			marginal_changed = 1;
+		}
 	}
 
 	/*
@@ -2258,7 +2279,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	 */
 	condlog(4, "path prio refresh");
 
-	if (update_prio(pp, new_path_up) &&
+	if (marginal_changed)
+		update_path_groups(pp->mpp, vecs, 1);
+	else if (update_prio(pp, new_path_up) &&
 	    (pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio) &&
 	     pp->mpp->pgfailback == -FAILBACK_IMMEDIATE)
 		update_path_groups(pp->mpp, vecs, !new_path_up);
-- 
2.17.2
