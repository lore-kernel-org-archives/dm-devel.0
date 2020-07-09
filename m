From: mwilck@suse.com
Subject: [PATCH 27/35] libmultipath: improve libdm logging
Date: Thu,  9 Jul 2020 12:16:12 +0200
Message-ID: <20200709101620.6786-28-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Currently no libdm messages are logged at verbosity 3 and lower,
not even fatal ones. That seems wrong. Rather, we should map
our log levels (2 ~ WARN, 3 ~ NOTICE) to those of libdm
(_LOG_WARN = 4, _LOG_NOTICE = 5). Tests show that the results
are quite satisfactory for different verbosity levels.

dm_log_init_verbose() doesn't need to be called, as it only
sets the log level for libdm's internal logging function which
we don't use.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f597ff8..4096e9d 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -12,6 +12,7 @@
 #include <ctype.h>
 #include <unistd.h>
 #include <errno.h>
+#include <syslog.h>
 #include <sys/sysmacros.h>
 #include <linux/dm-ioctl.h>
 
@@ -65,13 +66,15 @@ __attribute__((format(printf, 4, 5))) static void
 dm_write_log (int level, const char *file, int line, const char *f, ...)
 {
 	va_list ap;
-	int thres;
 
-	if (level > 6)
-		level = 6;
+	/*
+	 * libdm uses the same log levels as syslog,
+	 * except that EMERG/ALERT are not used
+	 */
+	if (level > LOG_DEBUG)
+		level = LOG_DEBUG;
 
-	thres = dm_conf_verbosity;
-	if (thres <= 3 || level > thres)
+	if (level > dm_conf_verbosity)
 		return;
 
 	va_start(ap, f);
@@ -90,8 +93,9 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 		vfprintf(stderr, f, ap);
 		fprintf(stderr, "\n");
 	} else {
-		condlog(level, "libdevmapper: %s(%i): ", file, line);
-		log_safe(level + 3, f, ap);
+		condlog(level >= LOG_ERR ? level - LOG_ERR : 0,
+			"libdevmapper: %s(%i): ", file, line);
+		log_safe(level, f, ap);
 	}
 	va_end(ap);
 
@@ -100,9 +104,12 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 
 void dm_init(int v)
 {
-	dm_conf_verbosity = v;
+	/*
+	 * This maps libdm's standard loglevel _LOG_WARN (= 4), which is rather
+	 * quiet in practice, to multipathd's default verbosity 2
+	 */
+	dm_conf_verbosity = v + 2;
 	dm_log_init(&dm_write_log);
-	dm_log_init_verbose(v + 3);
 }
 
 static int
-- 
2.26.2
