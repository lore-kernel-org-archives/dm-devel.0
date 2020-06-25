From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 2/7] multipathd: fix check_path errors with
	removed map
Date: Thu, 25 Jun 2020 15:42:16 -0500
Message-ID: <1593117741-28750-3-git-send-email-bmarzins@redhat.com>
References: <1593117741-28750-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593117741-28750-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If a multipath device is removed during, or immediately before the call
to check_path(), multipathd can behave incorrectly. A missing multpath
device will cause update_multipath_strings() to fail, setting
pp->dmstate to PSTATE_UNDEF.  If the path is up, this state will cause
reinstate_path() to be called, which will also fail.  This will trigger
a reload, restoring the recently removed device.

If update_multipath_strings() fails because there is no multipath
device, check_path should just quit, since the remove dmevent and uevent
are likely already queued up. Also, I don't see any reason to reload the
multipath device if reinstate fails. This code was added by
fac68d7a99ef17d496079538a5c6836acd7911ab, which clamined that reinstate
could fail if the path was disabled.  Looking through the current kernel
code, I can't see any reason why a reinstate would fail, where a reload
would help. If the path was missing from the multipath device,
update_multipath_strings() would already catch that, and quit
check_path() early, which make more sense to me than reloading does.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d73b1b9a..22bc4363 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1615,22 +1615,18 @@ fail_path (struct path * pp, int del_active)
 /*
  * caller must have locked the path list before calling that function
  */
-static int
+static void
 reinstate_path (struct path * pp)
 {
-	int ret = 0;
-
 	if (!pp->mpp)
-		return 0;
+		return;
 
-	if (dm_reinstate_path(pp->mpp->alias, pp->dev_t)) {
+	if (dm_reinstate_path(pp->mpp->alias, pp->dev_t))
 		condlog(0, "%s: reinstate failed", pp->dev_t);
-		ret = 1;
-	} else {
+	else {
 		condlog(2, "%s: reinstated", pp->dev_t);
 		update_queue_mode_add_path(pp->mpp);
 	}
-	return ret;
 }
 
 static void
@@ -2091,9 +2087,13 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	/*
 	 * Synchronize with kernel state
 	 */
-	if (update_multipath_strings(pp->mpp, vecs->pathvec, 1) != DMP_PASS) {
+	ret = update_multipath_strings(pp->mpp, vecs->pathvec, 1);
+	if (ret != DMP_PASS) {
 		condlog(1, "%s: Could not synchronize with kernel state",
 			pp->dev);
+		if (ret == DMP_FAIL)
+			/* multipath device missing. Likely removed */
+			return 0;
 		pp->dmstate = PSTATE_UNDEF;
 	}
 	/* if update_multipath_strings orphaned the path, quit early */
@@ -2183,12 +2183,8 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		/*
 		 * reinstate this path
 		 */
-		if (!disable_reinstate && reinstate_path(pp)) {
-			condlog(3, "%s: reload map", pp->dev);
-			ev_add_path(pp, vecs, 1);
-			pp->tick = 1;
-			return 0;
-		}
+		if (!disable_reinstate)
+			reinstate_path(pp);
 		new_path_up = 1;
 
 		if (oldchkrstate != PATH_UP && oldchkrstate != PATH_GHOST)
@@ -2204,15 +2200,10 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	else if (newstate == PATH_UP || newstate == PATH_GHOST) {
 		if ((pp->dmstate == PSTATE_FAILED ||
 		    pp->dmstate == PSTATE_UNDEF) &&
-		    !disable_reinstate) {
+		    !disable_reinstate)
 			/* Clear IO errors */
-			if (reinstate_path(pp)) {
-				condlog(3, "%s: reload map", pp->dev);
-				ev_add_path(pp, vecs, 1);
-				pp->tick = 1;
-				return 0;
-			}
-		} else {
+			reinstate_path(pp);
+		else {
 			LOG_MSG(4, verbosity, pp);
 			if (pp->checkint != max_checkint) {
 				/*
-- 
2.17.2
