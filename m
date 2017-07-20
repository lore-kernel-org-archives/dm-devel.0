From: Yang Feng <philip.yang@huawei.com>
Subject: [PATCH 2/2] multipath-tools/libmultipath: Add args
	min_avg_latency for path_latency.
Date: Thu, 20 Jul 2017 11:36:07 +0800
Message-ID: <1500521767-15884-3-git-send-email-philip.yang@huawei.com>
References: <1500521767-15884-1-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500521767-15884-1-git-send-email-philip.yang@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, mwilck@suse.com, xose.vazquez@gmail.com
Cc: philip.yang@huawei.com, zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

  Add args min_avg_latency of logarithmic scale, for prioritizers/path_latency.c.
Min average latency is not constant 1us, and is set by user. Certainly, max average
latency value is still 100s. It make support better for more scenes, because it can
deal better with the normal standard deviation of path latency. For example, when the
standard deviation value is 200us and the average latency of the normal paths is 1ms,
args base_num can be set to 5 and args min_avg_latency can be set to 2ms, so the paths
will be grouped in priority groups with path latency <=2ms, (2ms, 10ms], (10ms, 50ms],
etc.

Signed-off-by: Yang Feng <philip.yang@huawei.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/prioritizers/path_latency.c | 61 ++++++++++++++++++++++----------
 multipath/multipath.conf.5               | 14 +++++---
 2 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index 34b734b..a71faff 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -66,7 +66,7 @@ static int do_readsector0(int fd, unsigned int timeout)
 	return ret;
 }
 
-int check_args_valid(int io_num, int base_num)
+int check_args_valid(int io_num, int base_num, int min_avg_latency)
 {
     if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM))
     {
@@ -80,24 +80,33 @@ int check_args_valid(int io_num, int base_num)
         return 0;
     }
 
+    if ((min_avg_latency < MIN_AVG_LATENCY) || (min_avg_latency > MAX_AVG_LATENCY))
+    {
+        pp_pl_log(0, "args min_avg_latency is outside the valid range");
+        return 0;
+    }
+
     return 1;
 }
 
-/* In multipath.conf, args form: io_num|base_num. For example,
-*  args is "20|10", this function can get io_num value 20, and
-   base_num value 10.
+/* In multipath.conf, args form: io_num|base_num|min_avg_latency.
+*  For example, args is "20|10|1", this function can get io_num
+*  value 20, base_num value 10, min_avg_latency value 1 (us).
 */
-static int get_ionum_and_basenum(char *args,
-                                 int *ionum,
-                                 int *basenum)
+static int get_prio_args(char *args,
+                    int *ionum,
+                    int *basenum,
+                    int *minavglatency)
 {
     char source[MAX_CHAR_SIZE];
     char vertica = '|';
-    char *endstrbefore = NULL;
-    char *endstrafter = NULL;
+    char *endstr1 = NULL;
+    char *endstr2 = NULL;
+    char *endstr3 = NULL;
     unsigned int size = strlen(args);
 
-    if ((args == NULL) || (ionum == NULL) || (basenum == NULL))
+    if ((args == NULL) || (ionum == NULL)
+        || (basenum == NULL) || (minavglatency == NULL))
     {
         pp_pl_log(0, "args string is NULL");
         return 0;
@@ -117,21 +126,34 @@ static int get_ionum_and_basenum(char *args,
         return 0;
     }
 
-    *ionum = (int)strtoul(source, &endstrbefore, 10);
-    if (endstrbefore[0] != vertica)
+    *ionum = (int)strtoul(source, &endstr1, 10);
+    if (endstr1[0] != vertica)
+    {
+        pp_pl_log(0, "invalid prio_args format: %s", source);
+        return 0;
+    }
+
+    if (!isdigit(endstr1[1]))
+    {
+        pp_pl_log(0, "invalid prio_args format: %s", source);
+        return 0;
+    }
+
+    *basenum = (long long)strtol(&endstr1[1], &endstr2, 10);
+    if (endstr2[0] != vertica)
     {
         pp_pl_log(0, "invalid prio_args format: %s", source);
         return 0;
     }
 
-    if (!isdigit(endstrbefore[1]))
+    if (!isdigit(endstr2[1]))
     {
         pp_pl_log(0, "invalid prio_args format: %s", source);
         return 0;
     }
 
-    *basenum = (long long)strtol(&endstrbefore[1], &endstrafter, 10);
-    if (check_args_valid(*ionum, *basenum) == 0)
+    *minavglatency = (long long)strtol(&endstr2[1], &endstr3, 10);
+    if (check_args_valid(*ionum, *basenum, *minavglatency) == 0)
     {
         return 0;
     }
@@ -194,6 +216,7 @@ int getprio (struct path *pp, char *args, unsigned int timeout)
     int index = 0;
     int io_num;
     int base_num;
+    int min_avg_latency;
     long long avglatency;
     long long latency_interval;
     long long standard_deviation;
@@ -204,7 +227,7 @@ int getprio (struct path *pp, char *args, unsigned int timeout)
     if (pp->fd < 0)
         return -1;
 
-    if (get_ionum_and_basenum(args, &io_num, &base_num) == 0)
+    if (get_prio_args(args, &io_num, &base_num, &min_avg_latency) == 0)
     {
         pp_pl_log(0, "%s: get path_latency args fail", pp->dev);
         return DEFAULT_PRIORITY;
@@ -245,13 +268,13 @@ int getprio (struct path *pp, char *args, unsigned int timeout)
     set can change latency_interval value corresponding to avglatency and is not constant.
     Warn the user if latency_interval is smaller than (2 * standard_deviation), or equal */
     standard_deviation = calc_standard_deviation(path_latency, index, avglatency);
-    latency_interval = calc_latency_interval(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
-    if ((latency_interval!= 0)
+    latency_interval = calc_latency_interval(avglatency, MAX_AVG_LATENCY, min_avg_latency, base_num);
+    if ((latency_interval != 0)
         && (latency_interval <= (2 * standard_deviation)))
         pp_pl_log(3, "%s: latency interval (%lld) according to average latency (%lld us) is smaller than "
             "2 * standard deviation (%lld us), or equal, args base_num (%d) needs to be set bigger value",
             pp->dev, latency_interval, avglatency, standard_deviation, base_num);
 
-    rc = calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
+    rc = calcPrio(avglatency, MAX_AVG_LATENCY, min_avg_latency, base_num);
     return rc;
 }
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0049cba..e68e681 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -341,7 +341,7 @@ these values can be looked up through sysfs or by running \fImultipathd show pat
 .TP 12
 .I path_latency
 Needs a value of the form
-\fI"<io_num>|<base_num>"\fR
+\fI"<io_num>|<base_num>|<min_avg_latency>"\fR
 .RS
 .TP 8
 .I io_num
@@ -350,9 +350,15 @@ Valid Values: Integer, [2, 200].
 .TP
 .I base_num
 The base number value of logarithmic scale, used to partition different priority ranks. Valid Values: Integer,
-[2, 10]. And Max average latency value is 100s, min average latency value is 1us.
-For example: If base_num=10, the paths will be grouped in priority groups with path latency <=1us, (1us, 10us],
-(10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s.
+[2, 10]. And Max average latency value is constant 100s.
+For example: If base_num=10 and min_avg_latency=1, the paths will be grouped in priority groups with path latency <=1us,
+(1us, 10us], (10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s.
+.TP
+.I min_avg_latency
+The min average latency value of logarithmic scale, used to partition different priority ranks. Valid Values:
+Integer, [1, 10000000] (us). And  Max average latency value is constant 100s.
+For example: If base_num=10 and min_avg_latency=1000, the paths will be grouped in priority groups with path latency <=1ms,
+(1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s.
 .RE
 .TP 12
 .I alua
-- 
2.6.4.windows.1
