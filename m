From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 5/6] libmultipath: Introduce timedlock()
Date: Mon, 15 Aug 2016 08:27:19 -0700
Message-ID: <fa507cf5-f421-6bdb-6713-992aee0025ca@sandisk.com>
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

Introduce the function timedlock(). Ensure that the value of the
"depth" member value is incorrect if pthread_mutex_timedlock()
times out.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/lock.h | 11 +++++++++++
 multipathd/cli.c    |  3 +--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index dc83336..9808480 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -18,6 +18,17 @@ static inline void lock(struct mutex_lock *a)
 	pthread_mutex_lock(&a->mutex);
 }
 
+static inline int timedlock(struct mutex_lock *a, struct timespec *tmo)
+{
+	int r;
+
+	a->depth++;
+	r = pthread_mutex_timedlock(&a->mutex, tmo);
+	if (r)
+		a->depth--;
+	return r;
+}
+
 static inline void unlock(struct mutex_lock *a)
 {
 	a->depth--;
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 9597736..9a19728 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -487,8 +487,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		if (tmo.tv_sec) {
-			vecs->lock.depth++;
-			r = pthread_mutex_timedlock(&vecs->lock.mutex, &tmo);
+			r = timedlock(&vecs->lock, &tmo);
 		} else {
 			lock(&vecs->lock);
 			r = 0;
-- 
2.9.2
