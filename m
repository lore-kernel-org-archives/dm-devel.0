From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/30] libmultipath: inline set_default()
Date: Mon, 24 Jun 2019 11:27:34 +0200
Message-ID: <20190624092756.7769-10-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This is nothing but a reimplementation of strdup(), and it causes gcc 9
warnings. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/debug.c    |  1 +
 libmultipath/defaults.c | 17 -----------------
 libmultipath/defaults.h |  9 ++++++++-
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index cbf1e570..4128cb90 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
+#include <string.h>
 
 #include "log_pthread.h"
 #include <sys/types.h>
diff --git a/libmultipath/defaults.c b/libmultipath/defaults.c
index c20bb0d2..082640d3 100644
--- a/libmultipath/defaults.c
+++ b/libmultipath/defaults.c
@@ -7,20 +7,3 @@
 #include "memory.h"
 
 const char * const default_partition_delim = DEFAULT_PARTITION_DELIM;
-
-char *
-set_default (char * str)
-{
-	int len;
-	char * p;
-
-	len = strlen(str);
-	p = MALLOC(len + 1);
-
-	if (!p)
-		return NULL;
-
-	strncat(p, str, len);
-
-	return p;
-}
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 65769398..83f89f37 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,3 +1,5 @@
+#ifndef _DEFAULTS_H
+#define _DEFAULTS_H
 /*
  * If you add or modify a value also update multipath/multipath.conf.5
  * and the TEMPLATE in libmultipath/hwtable.c
@@ -60,5 +62,10 @@
 #define DEFAULT_CONFIG_DIR	"/etc/multipath/conf.d"
 #define MULTIPATH_SHM_BASE	"/dev/shm/multipath/"
 
-char * set_default (char * str);
+
+static inline char *set_default(char *str)
+{
+	return strdup(str);
+}
 extern const char *const default_partition_delim;
+#endif /* _DEFAULTS_H */
-- 
2.21.0
