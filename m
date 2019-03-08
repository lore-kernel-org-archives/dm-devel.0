From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 03/12] multipathd: cleanup marginal paths
	checking timers
Date: Fri,  8 Mar 2019 17:11:56 -0600
Message-ID: <1552086725-18476-4-git-send-email-bmarzins@redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When a path gets recovered in hit_io_err_recheck_time(), it will
continue running in check_path(), so there is no reason to schedule
another path check as soon as possible (since one is currently
happening).

Also, there isn't much point in restarting the io err stat checking when
the path is down, so hit_io_err_recheck_time() should only be run when
the path is up. Downed marginal paths can be treated just like any other
downed path.

Finally, there is no reason to set reset pp->io_err_dis_reinstate_time
when we decide to enqueue a path. Either th enqueue will fail and the
path will get recovered, or it will succeed, and we won't check the
reinstate time again until poll_io_err_stat() marks the path as needing
a requeue.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/io_err_stat.c | 8 --------
 multipathd/main.c          | 3 ++-
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 1cb3ffe..416e13a 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -400,13 +400,6 @@ int hit_io_err_recheck_time(struct path *pp)
 		io_err_stat_log(4, "%s: reschedule checking after %d seconds",
 				pp->dev,
 				pp->mpp->marginal_path_err_recheck_gap_time);
-		/*
-		 * to reschedule io error checking again
-		 * if the path is good enough, we claim it is good
-		 * and can be reinsated as soon as possible in the
-		 * check_path routine.
-		 */
-		pp->io_err_dis_reinstate_time = curr_time.tv_sec;
 		r = enqueue_io_err_stat_by_path(pp);
 		/*
 		 * Enqueue fails because of internal error.
@@ -426,7 +419,6 @@ int hit_io_err_recheck_time(struct path *pp)
 recover:
 	pp->io_err_pathfail_cnt = 0;
 	pp->io_err_disable_reinstate = 0;
-	pp->tick = 1;
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index fb520b6..fe6d8ef 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2079,7 +2079,8 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		return 1;
 	}
 
-	if (pp->io_err_disable_reinstate && hit_io_err_recheck_time(pp)) {
+	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
+	    pp->io_err_disable_reinstate && hit_io_err_recheck_time(pp)) {
 		pp->state = PATH_SHAKY;
 		/*
 		 * to reschedule as soon as possible,so that this path can
-- 
2.17.2
