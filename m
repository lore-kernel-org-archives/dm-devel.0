From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 73/78] multipathd: push down lock in checkerloop()
Date: Mon, 16 Mar 2015 13:37:00 +0100
Message-ID: <1426509425-15978-74-git-send-email-hare@suse.de>
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

Instead of grabbing the lock at the start of the checkerloop
and releasing it at the end we should be holding it only
during the time when we actually need it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f876258..9e7bf4f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1399,32 +1399,40 @@ checkerloop (void *ap)
 
 		if (gettimeofday(&start_time, NULL) != 0)
 			start_time.tv_sec = 0;
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(vecs->lock);
-		pthread_testcancel();
 		condlog(4, "tick");
 #ifdef USE_SYSTEMD
 		if (use_watchdog)
 			sd_notify(0, "WATCHDOG=1");
 #endif
 		if (vecs->pathvec) {
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(vecs->lock);
+			pthread_testcancel();
 			vector_foreach_slot (vecs->pathvec, pp, i) {
 				num_paths += check_path(vecs, pp);
 			}
+			lock_cleanup_pop(vecs->lock);
 		}
 		if (vecs->mpvec) {
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(vecs->lock);
+			pthread_testcancel();
 			defered_failback_tick(vecs->mpvec);
 			retry_count_tick(vecs->mpvec);
+			lock_cleanup_pop(vecs->lock);
 		}
 		if (count)
 			count--;
 		else {
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(vecs->lock);
+			pthread_testcancel();
 			condlog(4, "map garbage collection");
 			mpvec_garbage_collector(vecs);
 			count = MAPGCINT;
+			lock_cleanup_pop(vecs->lock);
 		}
 
-		lock_cleanup_pop(vecs->lock);
 		if (start_time.tv_sec &&
 		    gettimeofday(&end_time, NULL) == 0 &&
 		    num_paths) {
-- 
1.8.4.5
