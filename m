From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 8/8] multipathd: log reason for calling domap()
Date: Tue, 11 Aug 2020 16:58:43 -0500
Message-ID: <1597183123-15797-9-git-send-email-bmarzins@redhat.com>
References: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
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

When multipathd calls domap(), it should also print the reason on log
level 2, it already does this on every code path except when domap is
called by the path_checker.  Also, if __setup_multipath deletes the
device, it should log that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2b0e2734..ee44d0fe 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -414,7 +414,7 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 {
 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		/* Error accessing table */
-		condlog(3, "%s: cannot access table", mpp->alias);
+		condlog(2, "%s: cannot access table", mpp->alias);
 		goto out;
 	}
 
@@ -2252,13 +2252,18 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	 */
 	condlog(4, "path prio refresh");
 
-	if (marginal_changed)
+	if (marginal_changed) {
+		condlog(2, "%s: path is %s marginal", pp->dev,
+			(pp->marginal)? "now" : "no longer");
 		update_path_groups(pp->mpp, vecs, 1);
+	}
 	else if (update_prio(pp, new_path_up) &&
 	    (pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio) &&
-	     pp->mpp->pgfailback == -FAILBACK_IMMEDIATE)
+	     pp->mpp->pgfailback == -FAILBACK_IMMEDIATE) {
+		condlog(2, "%s: path priorities changed. reloading",
+			pp->mpp->alias);
 		update_path_groups(pp->mpp, vecs, !new_path_up);
-	else if (need_switch_pathgroup(pp->mpp, 0)) {
+	} else if (need_switch_pathgroup(pp->mpp, 0)) {
 		if (pp->mpp->pgfailback > 0 &&
 		    (new_path_up || pp->mpp->failback_tick <= 0))
 			pp->mpp->failback_tick =
-- 
2.17.2
