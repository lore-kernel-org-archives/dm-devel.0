From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 48/78] multipathd: reload map if reinstate failed
Date: Mon, 16 Mar 2015 13:36:35 +0100
Message-ID: <1426509425-15978-49-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The kernel might fail the 'reinstate' device-mapper message
if the path is disabled. In these cases we need to reload the
map to give device-mapper a chance to add the correct devices
to the table.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e197d59..2eade36 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -965,19 +965,23 @@ fail_path (struct path * pp, int del_active)
 /*
  * caller must have locked the path list before calling that function
  */
-static void
+static int
 reinstate_path (struct path * pp, int add_active)
 {
+	int ret = 0;
+
 	if (!pp->mpp)
-		return;
+		return 0;
 
-	if (dm_reinstate_path(pp->mpp->alias, pp->dev_t))
+	if (dm_reinstate_path(pp->mpp->alias, pp->dev_t)) {
 		condlog(0, "%s: reinstate failed", pp->dev_t);
-	else {
+		ret = 1;
+	} else {
 		condlog(2, "%s: reinstated", pp->dev_t);
 		if (add_active)
 			update_queue_mode_add_path(pp->mpp);
 	}
+	return ret;
 }
 
 static void
@@ -1132,6 +1136,7 @@ check_path (struct vectors * vecs, struct path * pp)
 	int newstate;
 	int new_path_up = 0;
 	int chkr_new_path_up = 0;
+	int add_active;
 	int oldchkrstate = pp->chkrstate;
 
 	if (pp->initialized && !pp->mpp)
@@ -1259,11 +1264,17 @@ check_path (struct vectors * vecs, struct path * pp)
 		    oldstate != PATH_GHOST) {
 			if (pp->mpp->delay_watch_checks > 0)
 				pp->watch_checks = pp->mpp->delay_watch_checks;
-			reinstate_path(pp, 1);
+			add_active = 1;
 		} else {
 			if (pp->watch_checks > 0)
 				pp->watch_checks--;
-			reinstate_path(pp, 0);
+			add_active = 0;
+		}
+		if (reinstate_path(pp, add_active)) {
+			condlog(3, "%s: reload map", pp->dev);
+			ev_add_path(pp, vecs);
+			pp->tick = 1;
+			return 0;
 		}
 		new_path_up = 1;
 
@@ -1281,7 +1292,12 @@ check_path (struct vectors * vecs, struct path * pp)
 		if (pp->dmstate == PSTATE_FAILED ||
 		    pp->dmstate == PSTATE_UNDEF) {
 			/* Clear IO errors */
-			reinstate_path(pp, 0);
+			if (reinstate_path(pp, 0)) {
+				condlog(3, "%s: reload map", pp->dev);
+				ev_add_path(pp, vecs);
+				pp->tick = 1;
+				return 0;
+			}
 		} else {
 			LOG_MSG(4, checker_message(&pp->checker));
 			if (pp->checkint != conf->max_checkint) {
-- 
1.8.4.5
