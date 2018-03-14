From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 04/12] multipathd: log thread cleanup
Date: Wed, 14 Mar 2018 12:46:37 -0500
Message-ID: <1521049605-22050-5-git-send-email-bmarzins@redhat.com>
References: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

The function log_thread_flush() is an exact copy of flush_lgoqueue(), so
both clearly don't need to exist. Also, There is no reason to make all
of the log thread variables global.  The only time any of them were
being used outside of log_thread.c, was to reset the log.  This code
should never be run if the log_thread isn't running, so it makes more
sense to live inside of log_thread.c

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/log_pthread.c | 34 +++++++++++++++-------------------
 libmultipath/log_pthread.h | 10 +---------
 multipathd/main.c          |  5 ++---
 3 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 035ae5d..f491386 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -14,13 +14,13 @@
 #include "log.h"
 #include "lock.h"
 
-pthread_t log_thr;
+static pthread_t log_thr;
 
-pthread_mutex_t logq_lock;
-pthread_mutex_t logev_lock;
-pthread_cond_t logev_cond;
+static pthread_mutex_t logq_lock;
+static pthread_mutex_t logev_lock;
+static pthread_cond_t logev_cond;
 
-int logq_running;
+static int logq_running;
 
 void log_safe (int prio, const char * fmt, va_list ap)
 {
@@ -38,19 +38,6 @@ void log_safe (int prio, const char * fmt, va_list ap)
 	pthread_mutex_unlock(&logev_lock);
 }
 
-void log_thread_flush (void)
-{
-	int empty;
-
-	do {
-		pthread_mutex_lock(&logq_lock);
-		empty = log_dequeue(la->buff);
-		pthread_mutex_unlock(&logq_lock);
-		if (!empty)
-			log_syslog(la->buff);
-	} while (empty == 0);
-}
-
 static void flush_logqueue (void)
 {
 	int empty;
@@ -82,7 +69,7 @@ static void * log_thread (void * et)
 		pthread_mutex_unlock(&logev_lock);
 		if (!running)
 			break;
-		log_thread_flush();
+		flush_logqueue();
 	}
 	return NULL;
 }
@@ -107,6 +94,15 @@ void log_thread_start (pthread_attr_t *attr)
 	return;
 }
 
+void log_thread_reset (void)
+{
+	logdbg(stderr,"resetting log\n");
+
+	pthread_mutex_lock(&logq_lock);
+	log_reset("multipathd");
+	pthread_mutex_unlock(&logq_lock);
+}
+
 void log_thread_stop (void)
 {
 	logdbg(stderr,"enter log_thread_stop\n");
diff --git a/libmultipath/log_pthread.h b/libmultipath/log_pthread.h
index e5c6499..7e138a0 100644
--- a/libmultipath/log_pthread.h
+++ b/libmultipath/log_pthread.h
@@ -3,17 +3,9 @@
 
 #include <pthread.h>
 
-extern pthread_t log_thr;
-
-extern pthread_mutex_t logq_lock;
-extern pthread_mutex_t logev_lock;
-extern pthread_cond_t logev_cond;
-
-extern int logq_running;
-
 void log_safe(int prio, const char * fmt, va_list ap);
 void log_thread_start(pthread_attr_t *attr);
+void log_thread_reset (void);
 void log_thread_stop(void);
-void log_thread_flush(void);
 
 #endif /* _LOG_PTHREAD_H */
diff --git a/multipathd/main.c b/multipathd/main.c
index a03ba20..6ba6131 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2219,9 +2219,8 @@ handle_signals(bool nonfatal)
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
-		pthread_mutex_lock(&logq_lock);
-		log_reset("multipathd");
-		pthread_mutex_unlock(&logq_lock);
+		if (logsink == 1)
+			log_thread_reset();
 	}
 	reconfig_sig = 0;
 	log_reset_sig = 0;
-- 
2.7.4
