From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 9/9] multipathd: measure path check time
Date: Tue, 26 Nov 2013 12:41:30 +0100
Message-ID: <1385466090-24290-10-git-send-email-hare@suse.de>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1385466090-24290-1-git-send-email-hare@suse.de>
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

Instrument code to measure path check time.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index b57fa5d..67feb61 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1104,7 +1104,7 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 	return 0;
 }
 
-void
+int
 check_path (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
@@ -1113,10 +1113,10 @@ check_path (struct vectors * vecs, struct path * pp)
 	int oldchkrstate = pp->chkrstate;
 
 	if (!pp->mpp)
-		return;
+		return 0;
 
 	if (pp->tick && --pp->tick)
-		return; /* don't check this path yet */
+		return 0; /* don't check this path yet */
 
 	/*
 	 * provision a next check soonest,
@@ -1131,7 +1131,7 @@ check_path (struct vectors * vecs, struct path * pp)
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
 		pathinfo(pp, conf->hwtable, 0);
-		return;
+		return 1;
 	}
 	/*
 	 * Async IO in flight. Keep the previous path state
@@ -1139,7 +1139,7 @@ check_path (struct vectors * vecs, struct path * pp)
 	 */
 	if (newstate == PATH_PENDING) {
 		pp->tick = 1;
-		return;
+		return 0;
 	}
 	/*
 	 * Synchronize with kernel state
@@ -1177,7 +1177,7 @@ check_path (struct vectors * vecs, struct path * pp)
 			pp->mpp->failback_tick = 0;
 
 			pp->mpp->stat_path_failures++;
-			return;
+			return 1;
 		}
 
 		if(newstate == PATH_UP || newstate == PATH_GHOST){
@@ -1262,6 +1262,7 @@ check_path (struct vectors * vecs, struct path * pp)
 			 (chkr_new_path_up && followover_should_failback(pp)))
 			switch_pathgroup(pp->mpp);
 	}
+	return 1;
 }
 
 static void *
@@ -1284,6 +1285,11 @@ checkerloop (void *ap)
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
@@ -1292,7 +1298,7 @@ checkerloop (void *ap)
 
 		if (vecs->pathvec) {
 			vector_foreach_slot (vecs->pathvec, pp, i) {
-				check_path(vecs, pp);
+				num_paths += check_path(vecs, pp);
 			}
 		}
 		if (vecs->mpvec) {
@@ -1308,6 +1314,14 @@ checkerloop (void *ap)
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
