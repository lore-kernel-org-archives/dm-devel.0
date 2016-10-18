From: tang.junhui@zte.com.cn
Subject: [PATCH 2/3] access vecs memory outside of locking range
	in check_path()
Date: Tue, 18 Oct 2016 10:51:08 +0800
Message-ID: <1476759069-9832-2-git-send-email-tang.junhui@zte.com.cn>
References: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
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
Cc: zhang.kai16@zte.com.cn, "tang.junhui" <tang.junhui@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

there are vecs->mpvec memory accesses outside of locking range in
check_path(), the judgments is not necessary since the they has
existed in vector_foreach_slot(), so delete them.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 multipathd/main.c | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index b6eb696..e369a79 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1804,30 +1804,29 @@ checkerloop (void *ap)
 			condlog(4, "timeout waiting for DAEMON_IDLE");
 			continue;
 		}
-		if (vecs->pathvec) {
-			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(&vecs->lock);
-			pthread_testcancel();
-			vector_foreach_slot (vecs->pathvec, pp, i) {
-				rc = check_path(vecs, pp, ticks);
-				if (rc < 0) {
-					vector_del_slot(vecs->pathvec, i);
-					free_path(pp);
-					i--;
-				} else
-					num_paths += rc;
-			}
-			lock_cleanup_pop(vecs->lock);
-		}
-		if (vecs->mpvec) {
-			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(&vecs->lock);
-			pthread_testcancel();
-			defered_failback_tick(vecs->mpvec);
-			retry_count_tick(vecs->mpvec);
-			missing_uev_wait_tick(vecs);
-			lock_cleanup_pop(vecs->lock);
+
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
+		lock(&vecs->lock);
+		pthread_testcancel();
+		vector_foreach_slot (vecs->pathvec, pp, i) {
+			rc = check_path(vecs, pp, ticks);
+			if (rc < 0) {
+				vector_del_slot(vecs->pathvec, i);
+				free_path(pp);
+				i--;
+			} else
+				num_paths += rc;
 		}
+		lock_cleanup_pop(vecs->lock);
+
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
+		lock(&vecs->lock);
+		pthread_testcancel();
+		defered_failback_tick(vecs->mpvec);
+		retry_count_tick(vecs->mpvec);
+		missing_uev_wait_tick(vecs);
+		lock_cleanup_pop(vecs->lock);
+
 		if (count)
 			count--;
 		else {
-- 
2.8.1.windows.1
