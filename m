From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/57] libmultipath: avoid double semicolon in
	lock.h
Date: Wed, 27 Apr 2016 13:10:22 +0200
Message-ID: <1461755458-29225-22-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The definitions for lock() already have a semicolon, resulting
in a double semicolon when using the definitions like a normal
statement.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/lock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 04ef78d..97af0f4 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -21,11 +21,11 @@ struct mutex_lock {
 	a.depth--; pthread_mutex_unlock(a.mutex)
 #define lock_cleanup_pop(a) \
 		fprintf(stderr, "%s:%s(%i) unlock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
-	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1)
 #else
 #define lock(a) a.depth++; pthread_mutex_lock(a.mutex)
 #define unlock(a) a.depth--; pthread_mutex_unlock(a.mutex)
-#define lock_cleanup_pop(a) pthread_cleanup_pop(1);
+#define lock_cleanup_pop(a) pthread_cleanup_pop(1)
 #endif
 
 void cleanup_lock (void * data);
-- 
2.6.6
