From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 60/72] libmultipath: fix clang -Wformat-literal
	warnings
Date: Sat, 12 Oct 2019 21:28:52 +0000
Message-ID: <20191012212703.12989-61-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c   | 2 +-
 libmultipath/log.h         | 3 ++-
 libmultipath/log_pthread.h | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4bff37d0..acf576aa 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -59,7 +59,7 @@ void dm_udev_set_sync_support(int c)
 
 #endif
 
-static void
+__attribute__((format(printf, 4, 5))) static void
 dm_write_log (int level, const char *file, int line, const char *f, ...)
 {
 	va_list ap;
diff --git a/libmultipath/log.h b/libmultipath/log.h
index 6551b5cf..d2448f6a 100644
--- a/libmultipath/log.h
+++ b/libmultipath/log.h
@@ -34,7 +34,8 @@ extern struct logarea* la;
 int log_init (char * progname, int size);
 void log_close (void);
 void log_reset (char * progname);
-int log_enqueue (int prio, const char * fmt, va_list ap);
+int log_enqueue (int prio, const char * fmt, va_list ap)
+	__attribute__((format(printf, 2, 0)));
 int log_dequeue (void *);
 void log_syslog (void *);
 void dump_logmsg (void *);
diff --git a/libmultipath/log_pthread.h b/libmultipath/log_pthread.h
index 7e138a00..810ac920 100644
--- a/libmultipath/log_pthread.h
+++ b/libmultipath/log_pthread.h
@@ -3,7 +3,8 @@
 
 #include <pthread.h>
 
-void log_safe(int prio, const char * fmt, va_list ap);
+void log_safe(int prio, const char * fmt, va_list ap)
+	__attribute__((format(printf, 2, 0)));
 void log_thread_start(pthread_attr_t *attr);
 void log_thread_reset (void);
 void log_thread_stop(void);
-- 
2.23.0
