From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/13] multipathd: measure path check time
Date: Fri, 15 Nov 2013 11:29:43 +0100
Message-ID: <1384511384-27642-13-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Instrument code to measure path check time.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e5b061b..d386e0a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1102,7 +1102,7 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 	return 0;
 }
 
-void
+int
 check_path (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
@@ -1111,10 +1111,10 @@ check_path (struct vectors * vecs, struct path * pp)
 	int oldchkrstate = pp->chkrstate;
 
 	if (!pp->mpp)
-		return;
+		return 0;
 
 	if (pp->tick && --pp->tick)
-		return; /* don't check this path yet */
+		return 0; /* don't check this path yet */
 
 	/*
 	 * provision a next check soonest,
@@ -1129,7 +1129,7 @@ check_path (struct vectors * vecs, struct path * pp)
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
 		pathinfo(pp, conf->hwtable, 0);
-		return;
+		return 1;
 	}
 	/*
 	 * Async IO in flight. Keep the previous path state
@@ -1137,7 +1137,7 @@ check_path (struct vectors * vecs, struct path * pp)
 	 */
 	if (newstate == PATH_PENDING) {
 		pp->tick = 1;
-		return;
+		return 0;
 	}
 	/*
 	 * Synchronize with kernel state
@@ -1175,7 +1175,7 @@ check_path (struct vectors * vecs, struct path * pp)
 			pp->mpp->failback_tick = 0;
 
 			pp->mpp->stat_path_failures++;
-			return;
+			return 1;
 		}
 
 		if(newstate == PATH_UP || newstate == PATH_GHOST){
@@ -1260,6 +1260,7 @@ check_path (struct vectors * vecs, struct path * pp)
 			 (chkr_new_path_up && followover_should_failback(pp)))
 			switch_pathgroup(pp->mpp);
 	}
+	return 1;
 }
 
 static void *
@@ -1282,6 +1283,11 @@ checkerloop (void *ap)
 	}
 
 	while (1) {
+		struct timeval diff_time, start_time, end_time;
+		int num_paths = 0;
+
+		if (gettimeofday(&start_time, NULL) != 0)
+			start_time.tv_sec = 0;
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(vecs->lock);
 		pthread_testcancel();
@@ -1290,7 +1296,7 @@ checkerloop (void *ap)
 
 		if (vecs->pathvec) {
 			vector_foreach_slot (vecs->pathvec, pp, i) {
-				check_path(vecs, pp);
+				num_paths += check_path(vecs, pp);
 			}
 		}
 		if (vecs->mpvec) {
@@ -1306,6 +1312,14 @@ checkerloop (void *ap)
 		}
 
 		lock_cleanup_pop(vecs->lock);
+		if (start_time.tv_sec &&
+		    gettimeofday(&end_time, NULL) == 0 &&
+		    num_paths) {
+			timersub(&end_time, &start_time, &diff_time);
+			condlog(3, "checked %d path%s in %lu.%06lu secs",
+				num_paths, num_paths > 1 ? "s" : "",
+				diff_time.tv_sec, diff_time.tv_usec);
+		}
 		sleep(1);
 	}
 	return NULL;
-- 
1.8.1.4
