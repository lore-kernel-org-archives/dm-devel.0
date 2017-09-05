From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH 3/3] multipath-tools: use user-friendly prio_args
	for path-latency
Date: Tue, 5 Sep 2017 21:45:05 +0800
Message-ID: <1504619105-14788-4-git-send-email-guanjunxiong@huawei.com>
References: <1504619105-14788-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1504619105-14788-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: guanjunxiong@huawei.com, philip.yang@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com, chengjike.cheng@huawei.com
List-Id: dm-devel.ids

The original prio_args for prioritizer is like this: 20|10 which
is somewhat unconvenient for user. This patch drops it and use
a syntax that similar to other prioritizers, for example :
"base_num=5 io_num=10".

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/prioritizers/path_latency.c | 71 +++++++++++++++++---------------
 multipath/multipath.conf.5               |  2 +-
 2 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index c75ae03f..69c9bd65 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -15,6 +15,7 @@
  *    scale, the priority "rc" of each path can be provided.
  *
  * Author(s): Yang Feng <philip.yang@huawei.com>
+ * Revised:   Guan Junxiong <guanjunxiong@huawei.com>
  *
  * This file is released under the GPL version 2, or any later version.
  */
@@ -32,6 +33,7 @@
 #include "debug.h"
 #include "prio.h"
 #include "structs.h"
+#include "util.h"
 
 #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
 
@@ -46,8 +48,6 @@
 
 #define DEFAULT_PRIORITY	0
 
-#define MAX_CHAR_SIZE		30
-
 #define USEC_PER_SEC		1000000LL
 #define NSEC_PER_USEC		1000LL
 
@@ -145,52 +145,55 @@ int check_args_valid(int io_num, int base_num)
 }
 
 /*
- * In multipath.conf, args form: io_num|base_num. For example,
- * args is "20|10", this function can get io_num value 20, and
+ * In multipath.conf, args form: io_num=n base_num=m. For example, args are
+ * "io_num=20 base_num=10", this function can get io_num value 20 and
  * base_num value 10.
  */
 static int get_ionum_and_basenum(char *args, int *ionum, int *basenum)
 {
-	char source[MAX_CHAR_SIZE];
-	char vertica = '|';
-	char *endstrbefore = NULL;
-	char *endstrafter = NULL;
-	unsigned int size = strlen(args);
+	char split_char[] = " \t";
+	char *arg, *temp;
+	char *str, *str_inval;
+	int i;
+	int flag_io = 0, flag_base = 0;
 
 	if ((args == NULL) || (ionum == NULL) || (basenum == NULL)) {
 		pp_pl_log(0, "args string is NULL");
 		return 0;
 	}
 
-	if ((size < 1) || (size > MAX_CHAR_SIZE - 1)) {
-		pp_pl_log(0, "args string's size is too long");
-		return 0;
-	}
-
-	memcpy(source, args, size + 1);
-
-	if (!isdigit(source[0])) {
-		pp_pl_log(0, "invalid prio_args format: %s", source);
+	arg = temp = STRDUP(args);
+	if (!arg)
 		return 0;
-	}
 
-	*ionum = (int)strtoul(source, &endstrbefore, 10);
-	if (endstrbefore[0] != vertica) {
-		pp_pl_log(0, "invalid prio_args format: %s", source);
-		return 0;
-	}
-
-	if (!isdigit(endstrbefore[1])) {
-		pp_pl_log(0, "invalid prio_args format: %s", source);
-		return 0;
+	for (i = 0; i < 2; i++) {
+		str = get_next_string(&temp, split_char);
+		if (!str)
+			goto out;
+		if (!strncmp(str, "io_num=", 7) && strlen(str) > 7) {
+			*ionum = (int)strtoul(str + 7, &str_inval, 10);
+			if (str == str_inval)
+				goto out;
+			flag_io = 1;
+		}
+		else if (!strncmp(str, "base_num=", 9) && strlen(str) > 9) {
+			*basenum = (int)strtol(str + 9, &str_inval, 10);
+			if (str == str_inval)
+				goto out;
+			flag_base = 1;
+		}
 	}
 
-	*basenum = (long long)strtol(&endstrbefore[1], &endstrafter, 10);
-	if (check_args_valid(*ionum, *basenum) == 0) {
-		return 0;
-	}
+	if (!flag_io || !flag_base)
+		goto out;
+	if (check_args_valid(*ionum, *basenum) == 0)
+		goto out;
 
+	FREE(arg);
 	return 1;
+out:
+	FREE(arg);
+	return 0;
 }
 
 long long calc_standard_deviation(long long *path_latency, int size,
@@ -249,8 +252,8 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 {
 	int rc, temp;
 	int index = 0;
-	int io_num;
-	int base_num;
+	int io_num = 0;
+	int base_num = 0;
 	long long avglatency;
 	long long latency_interval;
 	long long standard_deviation;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index d9ac279f..1f97dd8c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -346,7 +346,7 @@ these values can be looked up through sysfs or by running \fImultipathd show pat
 .TP 12
 .I path_latency
 Needs a value of the form
-\fI"<io_num>|<base_num>"\fR
+"io_num=\fI<20>\fR base_num=\fI<10>\fR"
 .RS
 .TP 8
 .I io_num
-- 
2.11.1
