From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/6] libmultipath: Inline mutex in struct
	mutex_lock
Date: Mon, 15 Aug 2016 08:27:01 -0700
Message-ID: <ff7c0919-1c20-62e5-8121-31847eb55f0b@sandisk.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This simplifies the struct mutex_lock allocation and deallocation
code.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/lock.h |  6 +++---
 multipathd/cli.c    |  2 +-
 multipathd/main.c   | 18 ++----------------
 3 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 461b095..dc83336 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -8,20 +8,20 @@
  * track of how many there are out-standing threads blocking
  * on a mutex. */
 struct mutex_lock {
-	pthread_mutex_t *mutex;
+	pthread_mutex_t mutex;
 	int depth;
 };
 
 static inline void lock(struct mutex_lock *a)
 {
 	a->depth++;
-	pthread_mutex_lock(a->mutex);
+	pthread_mutex_lock(&a->mutex);
 }
 
 static inline void unlock(struct mutex_lock *a)
 {
 	a->depth--;
-	pthread_mutex_unlock(a->mutex);
+	pthread_mutex_unlock(&a->mutex);
 }
 
 #define lock_cleanup_pop(a) pthread_cleanup_pop(1)
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 01b5ac8..9597736 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -488,7 +488,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		if (tmo.tv_sec) {
 			vecs->lock.depth++;
-			r = pthread_mutex_timedlock(vecs->lock.mutex, &tmo);
+			r = pthread_mutex_timedlock(&vecs->lock.mutex, &tmo);
 		} else {
 			lock(&vecs->lock);
 			r = 0;
diff --git a/multipathd/main.c b/multipathd/main.c
index e0dc045..fff482c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2045,21 +2045,10 @@ init_vecs (void)
 	if (!vecs)
 		return NULL;
 
-	vecs->lock.mutex =
-		(pthread_mutex_t *)MALLOC(sizeof(pthread_mutex_t));
-
-	if (!vecs->lock.mutex)
-		goto out;
-
-	pthread_mutex_init(vecs->lock.mutex, NULL);
+	pthread_mutex_init(&vecs->lock.mutex, NULL);
 	vecs->lock.depth = 0;
 
 	return vecs;
-
-out:
-	FREE(vecs);
-	condlog(0, "failed to init paths");
-	return NULL;
 }
 
 static void *
@@ -2415,10 +2404,7 @@ child (void * param)
 		condlog(3, "Have %d wait event checkers threads to de-alloc,"
 			" waiting...", vecs->lock.depth);
 	}
-	pthread_mutex_destroy(vecs->lock.mutex);
-	FREE(vecs->lock.mutex);
-	vecs->lock.depth = 0;
-	vecs->lock.mutex = NULL;
+	pthread_mutex_destroy(&vecs->lock.mutex);
 	FREE(vecs);
 	vecs = NULL;
 
-- 
2.9.2
