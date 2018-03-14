From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 05/12] libmultipath: fix log_pthread processing
Date: Wed, 14 Mar 2018 12:46:38 -0500
Message-ID: <1521049605-22050-6-git-send-email-bmarzins@redhat.com>
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

log_pthread() was waiting for notification on logev_cond, without
checking if it had already happened.  This means it could end up
waiting, while there is work that it should be doing.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/log_pthread.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index f491386..bb35dfc 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -21,6 +21,7 @@ static pthread_mutex_t logev_lock;
 static pthread_cond_t logev_cond;
 
 static int logq_running;
+static int log_messages_pending;
 
 void log_safe (int prio, const char * fmt, va_list ap)
 {
@@ -34,6 +35,7 @@ void log_safe (int prio, const char * fmt, va_list ap)
 	pthread_mutex_unlock(&logq_lock);
 
 	pthread_mutex_lock(&logev_lock);
+	log_messages_pending = 1;
 	pthread_cond_signal(&logev_cond);
 	pthread_mutex_unlock(&logev_lock);
 }
@@ -64,7 +66,9 @@ static void * log_thread (void * et)
 
 	while (1) {
 		pthread_mutex_lock(&logev_lock);
-		pthread_cond_wait(&logev_cond, &logev_lock);
+		if (logq_running && !log_messages_pending)
+			pthread_cond_wait(&logev_cond, &logev_lock);
+		log_messages_pending = 0;
 		running = logq_running;
 		pthread_mutex_unlock(&logev_lock);
 		if (!running)
-- 
2.7.4
