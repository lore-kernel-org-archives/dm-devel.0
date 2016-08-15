From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/6] libmultipath: Remove debugging code from
	lock.h
Date: Mon, 15 Aug 2016 08:26:15 -0700
Message-ID: <af3350fd-c6a1-6894-c3d8-7ec76c54acfc@sandisk.com>
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

There are better tools available to trace mutex lock and unlock
activity than the macros in this header file, e.g.
valgrind --tool=drd --trace-mutex=yes multipathd -d
Hence remove the debugging macros.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/lock.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index c569f01..71baf10 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -12,21 +12,9 @@ struct mutex_lock {
 	int depth;
 };
 
-#ifdef LCKDBG
-#define lock(a) \
-		fprintf(stderr, "%s:%s(%i) lock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
-		a.depth++; pthread_mutex_lock(a.mutex)
-#define unlock(a) \
-		fprintf(stderr, "%s:%s(%i) unlock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
-	a.depth--; pthread_mutex_unlock(a.mutex)
-#define lock_cleanup_pop(a) \
-		fprintf(stderr, "%s:%s(%i) unlock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
-	pthread_cleanup_pop(1)
-#else
 #define lock(a) a.depth++; pthread_mutex_lock(a.mutex)
 #define unlock(a) a.depth--; pthread_mutex_unlock(a.mutex)
 #define lock_cleanup_pop(a) pthread_cleanup_pop(1)
-#endif
 
 void cleanup_lock (void * data);
 
-- 
2.9.2
