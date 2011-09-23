From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RESEND][PATCH] multipath: add support for setting
	oom_score_adj
Date: Fri, 23 Sep 2011 09:35:59 -0500
Message-ID: <20110923143559.GR24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

The oom_adj procfs interface is deprecated. I've added support for using the
new oom_score_adj interface.  The code still falls back to using oom_adj
if oom_score_adj doesn't exist.

Resending, since I was obviously working far too late last night.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

Index: multipath-tools-110916/multipathd/main.c
===================================================================
--- multipath-tools-110916.orig/multipathd/main.c
+++ multipath-tools-110916/multipathd/main.c
@@ -15,6 +15,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <limits.h>
+#include <linux/oom.h>
 
 /*
  * libcheckers
@@ -1458,17 +1459,35 @@ setscheduler (void)
 }
 
 static void
-set_oom_adj (int val)
+set_oom_adj (void)
 {
+	int retry = 1;
+	char *file = "/proc/self/oom_score_adj";
+	int score = OOM_SCORE_ADJ_MIN;
 	FILE *fp;
+	struct stat st;
 
-	fp = fopen("/proc/self/oom_adj", "w");
-
-	if (!fp)
-		return;
-
-	fprintf(fp, "%i", val);
-	fclose(fp);
+	do {
+		if (stat(file, &st) == 0){
+			fp = fopen(file, "w");
+			if (!fp) {
+				condlog(0, "couldn't fopen %s : %s", file,
+					strerror(errno));
+				return;
+			}
+			fprintf(fp, "%i", score);
+			fclose(fp);
+			return;
+		}
+		if (errno != ENOENT) {
+			condlog(0, "couldn't stat %s : %s", file,
+				strerror(errno));
+			return;
+		}
+		file = "/proc/self/oom_adj";
+		score = OOM_ADJUST_MIN;
+	} while (retry--);
+	condlog(0, "couldn't adjust oom score");
 }
 
 static int
@@ -1547,7 +1566,7 @@ child (void * param)
 
 	signal_init();
 	setscheduler();
-	set_oom_adj(-16);
+	set_oom_adj();
 	vecs = gvecs = init_vecs();
 
 	if (!vecs)
