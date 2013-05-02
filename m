From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 03/16] Fix print_multipath_topology for large
	outputs
Date: Thu,  2 May 2013 16:46:24 -0500
Message-ID: <1367531197-8987-4-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

print_multipath_topology had a hard size limit. With a large number
of LUNs and a large number of paths, it was possible to go over
this limit, and have some of the output cut off.
print_multipath_topology now checks for this, and resizes the
buffer if necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 0e2c680..274f5e7 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -8,6 +8,8 @@
 #include <sys/stat.h>
 #include <dirent.h>
 #include <unistd.h>
+#include <string.h>
+#include <errno.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -24,6 +26,7 @@
 #include "switchgroup.h"
 #include "devmapper.h"
 #include "uevent.h"
+#include "debug.h"
 
 #define MAX(x,y) (x > y) ? x : y
 #define TAIL     (line + len - 1 - c)
@@ -754,11 +757,30 @@ snprint_pathgroup (char * line, int len, char * format,
 extern void
 print_multipath_topology (struct multipath * mpp, int verbosity)
 {
-	char buff[MAX_LINE_LEN * MAX_LINES] = {};
+	int resize;
+	char *buff = NULL;
+	char *old = NULL;
+	int len, maxlen = MAX_LINE_LEN * MAX_LINES;
+
+	buff = MALLOC(maxlen);
+	do {
+		if (!buff) {
+			if (old)
+				FREE(old);
+			condlog(0, "couldn't allocate memory for list: %s\n",
+				strerror(errno));
+			return;
+		}
+
+		len = snprint_multipath_topology(buff, maxlen, mpp, verbosity);
+		resize = (len == maxlen - 1);
 
-	memset(&buff[0], 0, MAX_LINE_LEN * MAX_LINES);
-	snprint_multipath_topology(&buff[0], MAX_LINE_LEN * MAX_LINES,
-				   mpp, verbosity);
+		if (resize) {
+			maxlen *= 2;
+			old = buff;
+			buff = REALLOC(buff, maxlen);
+		}
+	} while (resize);
 	printf("%s", buff);
 }
 
-- 
1.8.2
