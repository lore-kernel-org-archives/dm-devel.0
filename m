From: Yang Feng <philip.yang@huawei.com>
Subject: [PATCH v6 1/1] multipath-tools: Prioritizer based on a
	latency algorithm
Date: Wed, 21 Jun 2017 17:40:34 +0800
Message-ID: <1498038034-18276-2-git-send-email-philip.yang@huawei.com>
References: <1498038034-18276-1-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498038034-18276-1-git-send-email-philip.yang@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mwilck@suse.com, christophe.varoqui@opensvc.com, xose.vazquez@gmail.com, bmarzins@redhat.com, hare@suse.de, dm-devel@redhat.com, shenhong09@huawei.com, hege09@huawei.com, tristan.ye@suse.com
Cc: philip.yang@huawei.com
List-Id: dm-devel.ids

libmultipath/prioritizers: Prioritizer for device mapper multipath,
where the corresponding priority values of specific paths are provided
by a latency algorithm on the logarithmic scale. And the latency algorithm
is dependent on the following arguments(io_num and base_num).
The principle of the algorithm is illustrated as follows:
1. By sending a certain number "io_num" of read IOs to the current
path continuously, the IOs' average latency can be calculated.
2. Max average latency value is 100s, and min value is 1us. According
to the average latency of each path and the "base_number" of logarithmic
scale, the priority "rc" of each path can be provided.

For example: If base_num=10, the paths will be grouped in priority groups
with path latency <=1us, (1us, 10us], (10us, 100us], (100us, 1ms], (1ms, 10ms],
(10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s. As follows:

       <=1us            (1us, 10us]      (10us, 100us]               >100s
|------------------|------------------|------------------|...|------------------|
|  priority rank 9 |  priority rank 8 |  priority rank 7 |...|  priority rank 0 |
|------------------|------------------|------------------|...|------------------|
	   		   Priority Rank Partitioning

Signed-off-by: Yang Feng <philip.yang@huawei.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/prio.h                      |   1 +
 libmultipath/prioritizers/Makefile       |   4 +
 libmultipath/prioritizers/path_latency.c | 257 +++++++++++++++++++++++++++++++
 multipath/multipath.conf.5               |  20 +++
 4 files changed, 282 insertions(+)
 create mode 100644 libmultipath/prioritizers/path_latency.c

diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 0193c52..c97fe39 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -29,6 +29,7 @@ struct path;
 #define PRIO_RDAC		"rdac"
 #define PRIO_WEIGHTED_PATH	"weightedpath"
 #define PRIO_SYSFS		"sysfs"
+#define PRIO_PATH_LATENCY	"path_latency"
 
 /*
  * Value used to mark the fact prio was not defined
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 36b42e4..ca47cdf 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -18,6 +18,7 @@ LIBS = \
 	libpriorandom.so \
 	libpriordac.so \
 	libprioweightedpath.so \
+	libpriopath_latency.so \
 	libpriosysfs.so
 
 all: $(LIBS)
@@ -25,6 +26,9 @@ all: $(LIBS)
 libprioalua.so: alua.o alua_rtpg.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
+libpriopath_latency.so: path_latency.o  ../checkers/libsg.o
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm
+
 libprio%.so: %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
new file mode 100644
index 0000000..046e13b
--- /dev/null
+++ b/libmultipath/prioritizers/path_latency.c
@@ -0,0 +1,257 @@
+/*
+ * (C) Copyright HUAWEI Technology Corp. 2017, All Rights Reserved.
+ *
+ * path_latency.c
+ *
+ * Prioritizer for device mapper multipath, where the corresponding priority
+ * values of specific paths are provided by a latency algorithm. And the
+ * latency algorithm is dependent on arguments("io_num" and "base_num").
+ *
+ * The principle of the algorithm as follows:
+ * 1. By sending a certain number "io_num" of read IOs to the current path
+ *    continuously, the IOs' average latency can be calculated.
+ * 2. Max value and min value of average latency are constant. According to
+ *    the average latency of each path and the "base_num" of logarithmic
+ *    scale, the priority "rc" of each path can be provided.
+ *
+ * Author(s): Yang Feng <philip.yang@huawei.com>
+ *
+ * This file is released under the GPL version 2, or any later version.
+ *
+ */
+#include <stdio.h>
+#include <math.h>
+#include <ctype.h>
+#include <time.h>
+
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
+#include "../checkers/libsg.h"
+
+#define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
+
+#define MAX_IO_NUM              200
+#define MIN_IO_NUM              2
+
+#define MAX_BASE_NUM            10
+#define MIN_BASE_NUM            2
+
+#define MAX_AVG_LATENCY         100000000.  /*Unit: us*/
+#define MIN_AVG_LATENCY         1.          /*Unit: us*/
+
+#define DEFAULT_PRIORITY        0
+
+#define MAX_CHAR_SIZE           30
+
+#define USEC_PER_SEC            1000000LL
+#define NSEC_PER_USEC           1000LL
+
+static long long path_latency[MAX_IO_NUM];
+
+static inline long long timeval_to_us(const struct timespec *tv)
+{
+	return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec / NSEC_PER_USEC);
+}
+
+static int do_readsector0(int fd, unsigned int timeout)
+{
+	unsigned char buf[4096];
+	unsigned char sbuf[SENSE_BUFF_LEN];
+	int ret;
+
+	ret = sg_read(fd, &buf[0], 4096, &sbuf[0],
+		      SENSE_BUFF_LEN, timeout);
+
+	return ret;
+}
+
+int check_args_valid(int io_num, int base_num)
+{
+    if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM))
+    {
+        pp_pl_log(0, "args io_num is outside the valid range");
+        return 0;
+    }
+
+    if ((base_num < MIN_BASE_NUM) || (base_num > MAX_BASE_NUM))
+    {
+        pp_pl_log(0, "args base_num is outside the valid range");
+        return 0;
+    }
+
+    return 1;
+}
+
+/* In multipath.conf, args form: io_num|base_num. For example,
+*  args is "20|10", this function can get io_num value 20, and
+   base_num value 10.
+*/
+static int get_ionum_and_basenum(char *args,
+                                 int *ionum,
+                                 int *basenum)
+{
+    char source[MAX_CHAR_SIZE];
+    char vertica = '|';
+    char *endstrbefore = NULL;
+    char *endstrafter = NULL;
+    unsigned int size = strlen(args);
+
+    if ((args == NULL) || (ionum == NULL) || (basenum == NULL))
+    {
+        pp_pl_log(0, "args string is NULL");
+        return 0;
+    }
+
+    if ((size < 1) || (size > MAX_CHAR_SIZE-1))
+    {
+        pp_pl_log(0, "args string's size is too long");
+        return 0;
+    }
+
+    memcpy(source, args, size+1);
+
+    if (!isdigit(source[0]))
+    {
+        pp_pl_log(0, "invalid prio_args format: %s", source);
+        return 0;
+    }
+
+    *ionum = (int)strtoul(source, &endstrbefore, 10);
+    if (endstrbefore[0] != vertica)
+    {
+        pp_pl_log(0, "invalid prio_args format: %s", source);
+        return 0;
+    }
+
+    if (!isdigit(endstrbefore[1]))
+    {
+        pp_pl_log(0, "invalid prio_args format: %s", source);
+        return 0;
+    }
+
+    *basenum = (long long)strtol(&endstrbefore[1], &endstrafter, 10);
+    if (check_args_valid(*ionum, *basenum) == 0)
+    {
+        return 0;
+    }
+
+    return 1;
+}
+
+long long calc_standard_deviation(long long *path_latency, int size, long long avglatency)
+{
+    int index;
+    long long total = 0;
+
+    for (index = 0; index < size; index++)
+    {
+        total += (path_latency[index] - avglatency) * (path_latency[index] - avglatency);
+    }
+
+    total /= (size-1);
+
+    return (long long)sqrt((double)total);
+}
+
+int calcPrio(double avglatency, double max_avglatency, double min_avglatency, double base_num)
+{
+    double lavglatency = log(avglatency)/log(base_num);
+    double lmax_avglatency = log(max_avglatency)/log(base_num);
+    double lmin_avglatency = log(min_avglatency)/log(base_num);
+
+    if (lavglatency <= lmin_avglatency)
+        return (int)(lmax_avglatency + 1.);
+
+    if (lavglatency > lmax_avglatency)
+        return 0;
+
+    return (int)(lmax_avglatency - lavglatency + 1.);
+}
+
+/* Calc the latency interval corresponding to the average latency */
+long long calc_latency_interval(double avglatency, double max_avglatency,
+                                double min_avglatency, double base_num)
+{
+    double lavglatency = log(avglatency)/log(base_num);
+    double lmax_avglatency = log(max_avglatency)/log(base_num);
+    double lmin_avglatency = log(min_avglatency)/log(base_num);
+
+    if ((lavglatency <= lmin_avglatency)
+        || (lavglatency > lmax_avglatency))
+        return 0;/* Invalid value */
+
+    if ((double)((int)lavglatency) == lavglatency)
+        return (long long)(avglatency - (avglatency / base_num));
+    else
+        return (long long)(pow(base_num, (double)((int)lavglatency + 1))
+            - pow(base_num, (double)((int)lavglatency)));
+}
+
+int getprio (struct path *pp, char *args, unsigned int timeout)
+{
+    int rc, temp;
+    int index = 0;
+    int io_num;
+    int base_num;
+    long long avglatency;
+    long long latency_interval;
+    long long standard_deviation;
+    long long toldelay = 0;
+    long long before, after;
+    struct timespec tv;
+
+    if (pp->fd < 0)
+        return -1;
+
+    if (get_ionum_and_basenum(args, &io_num, &base_num) == 0)
+    {
+        pp_pl_log(0, "%s: get path_latency args fail", pp->dev);
+        return DEFAULT_PRIORITY;
+    }
+
+    memset(path_latency, 0, sizeof(path_latency));
+
+    temp = io_num;
+    while (temp-- > 0)
+    {
+        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
+        before = timeval_to_us(&tv);
+
+        if (do_readsector0(pp->fd, timeout) == 2)
+        {
+            pp_pl_log(0, "%s: path down", pp->dev);
+            return -1;
+        }
+
+        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
+        after = timeval_to_us(&tv);
+
+        path_latency[index] = after - before;
+        toldelay += path_latency[index++];
+    }
+
+    avglatency = toldelay/(long long)io_num;
+    pp_pl_log(4, "%s: average latency is (%lld us)", pp->dev, avglatency);
+
+    if (avglatency > MAX_AVG_LATENCY)
+    {
+        pp_pl_log(0, "%s: average latency (%lld us) is outside the thresold (%lld us)",
+            pp->dev, avglatency, (long long)MAX_AVG_LATENCY);
+        return DEFAULT_PRIORITY;
+    }
+
+    /* Min average latency and max average latency are constant, the args base_num
+    set can change latency_interval value corresponding to avglatency and is not constant.
+    Warn the user if latency_interval is smaller than (2 * standard_deviation), or equal */
+    standard_deviation = calc_standard_deviation(path_latency, index, avglatency);
+    latency_interval = calc_latency_interval(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
+    if ((latency_interval!= 0)
+        && (latency_interval <= (2 * standard_deviation)))
+        pp_pl_log(3, "%s: latency interval (%lld) according to average latency (%lld us) is smaller than "
+            "2 * standard deviation (%lld us), or equal, args base_num (%d) needs to be set bigger value",
+            pp->dev, latency_interval, avglatency, standard_deviation, base_num);
+
+    rc = calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
+    return rc;
+}
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 5939688..8dffac0 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -293,6 +293,10 @@ Generate a random priority between 1 and 10.
 Generate the path priority based on the regular expression and the
 priority provided as argument. Requires prio_args keyword.
 .TP
+.I path_latency
+Generate the path priority based on a latency algorithm.
+Requires prio_args keyword.
+.TP
 .I datacore
 .\" XXX
 ???. Requires prio_args keyword.
@@ -333,6 +337,22 @@ these values can be looked up through sysfs or by running \fImultipathd show pat
 "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
 .RE
 .TP 12
+.I path_latency
+Needs a value of the form
+\fI"<io_num>|<base_num>"\fR
+.RS
+.TP 8
+.I io_num
+The number of read IOs sent to the current path continuously, used to calculate the average path latency.
+Valid Values: Integer, [2, 200].
+.TP
+.I base_num
+The base number value of logarithmic scale, used to partition different priority ranks. Valid Values: Integer,
+[2, 10]. And Max average latency value is 100s, min average latency value is 1us.
+For example: If base_num=10, the paths will be grouped in priority groups with path latency <=1us, (1us, 10us],
+(10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s.
+.RE
+.TP 12
 .I alua
 If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
 set will always be in their own path group.
-- 
2.6.4.windows.1
