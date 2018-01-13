From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 19/20] libmultipath: path latency: simplify
	getprio()
Date: Sat, 13 Jan 2018 22:19:37 +0100
Message-ID: <20180113211938.31552-20-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The log standard deviation can be calculated much more simply
by realizing

   sum_n (x_i - avg(x))^2 == sum_n x_i^2 - n * avg(x)^2

Also, use timespecsub rather than the custom timeval_to_usec,
and avoid taking log(0).
---
 libmultipath/prioritizers/path_latency.c | 71 ++++++++++++++------------------
 1 file changed, 30 insertions(+), 41 deletions(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index ce5c95dd7075..e764f1dd8a21 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -34,6 +34,7 @@
 #include "prio.h"
 #include "structs.h"
 #include "util.h"
+#include "time-util.h"
 
 #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
 
@@ -56,14 +57,6 @@
 
 #define DEF_BLK_SIZE		4096
 
-static double lg_path_latency[MAX_IO_NUM];
-
-static inline long long timeval_to_us(const struct timespec *tv)
-{
-	return ((long long)tv->tv_sec * USEC_PER_SEC) +
-	    (tv->tv_nsec / NSEC_PER_USEC);
-}
-
 static int prepare_directio_read(int fd, int *blksz, char **pbuf,
 		int *restore_flags)
 {
@@ -199,22 +192,6 @@ out:
 	return 0;
 }
 
-double calc_standard_deviation(double *lg_path_latency, int size,
-				  double lg_avglatency)
-{
-	int index;
-	double sum = 0;
-
-	for (index = 0; index < size; index++) {
-		sum += (lg_path_latency[index] - lg_avglatency) *
-			(lg_path_latency[index] - lg_avglatency);
-	}
-
-	sum /= (size - 1);
-
-	return sqrt(sum);
-}
-
 /*
  * Do not scale the prioriy in a certain range such as [0, 1024]
  * because scaling will eliminate the effect of base_num.
@@ -234,20 +211,16 @@ int calcPrio(double lg_avglatency, double lg_maxavglatency,
 int getprio(struct path *pp, char *args, unsigned int timeout)
 {
 	int rc, temp;
-	int index = 0;
 	int io_num = 0;
 	double base_num = 0;
 	double lg_avglatency, lg_maxavglatency, lg_minavglatency;
 	double standard_deviation;
 	double lg_toldelay = 0;
-	long long before, after;
-	struct timespec tv;
 	int blksize;
 	char *buf;
 	int restore_flags = 0;
 	double lg_base;
-	long long sum_latency = 0;
-	long long arith_mean_lat;
+	double sum_squares = 0;
 
 	if (pp->fd < 0)
 		return -1;
@@ -260,7 +233,6 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 				pp->dev, io_num, base_num);
 	}
 
-	memset(lg_path_latency, 0, sizeof(lg_path_latency));
 	lg_base = log(base_num);
 	lg_maxavglatency = log(MAX_AVG_LATENCY) / lg_base;
 	lg_minavglatency = log(MIN_AVG_LATENCY) / lg_base;
@@ -269,8 +241,10 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 
 	temp = io_num;
 	while (temp-- > 0) {
-		(void)clock_gettime(CLOCK_MONOTONIC, &tv);
-		before = timeval_to_us(&tv);
+		struct timespec tv_before, tv_after, tv_diff;
+		double diff, reldiff;
+
+		(void)clock_gettime(CLOCK_MONOTONIC, &tv_before);
 
 		if (do_directio_read(pp->fd, timeout, buf, blksize)) {
 			pp_pl_log(0, "%s: path down", pp->dev);
@@ -278,25 +252,34 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 			return -1;
 		}
 
-		(void)clock_gettime(CLOCK_MONOTONIC, &tv);
-		after = timeval_to_us(&tv);
+		(void)clock_gettime(CLOCK_MONOTONIC, &tv_after);
+
+		timespecsub(&tv_after, &tv_before, &tv_diff);
+		diff = tv_diff.tv_sec * 1000 * 1000 + tv_diff.tv_nsec / 1000;
+
+		if (diff == 0)
+			/*
+			 * Avoid taking log(0).
+			 * This unlikely case is treated as minimum -
+			 * the sums don't increase
+			 */
+			continue;
+
+		/* we scale by lg_base here */
+		reldiff = log(diff) / lg_base;
+
 		/*
 		 * We assume that the latency complies with Log-normal
 		 * distribution. The logarithm of latency is in normal
 		 * distribution.
 		 */
-		lg_path_latency[index] = log(after - before) / lg_base;
-		lg_toldelay += lg_path_latency[index++];
-		sum_latency += after - before;
+		lg_toldelay += reldiff;
+		sum_squares += reldiff * reldiff;
 	}
 
 	cleanup_directio_read(pp->fd, buf, restore_flags);
 
 	lg_avglatency = lg_toldelay / (long long)io_num;
-	arith_mean_lat = sum_latency / (long long)io_num;
-	pp_pl_log(4, "%s: arithmetic mean latency is (%lld us), geometric mean latency is (%lld us)",
-			pp->dev, arith_mean_lat,
-			(long long)pow(base_num, lg_avglatency));
 
 	if (lg_avglatency > lg_maxavglatency) {
 		pp_pl_log(2,
@@ -340,8 +323,14 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 			  ".It is recommend to be set larger",
 			  pp->dev, base_num);
 
+	standard_deviation = sqrt((sum_squares - lg_toldelay * lg_avglatency)
+				  / (io_num - 1));
 
 	rc = calcPrio(lg_avglatency, lg_maxavglatency, lg_minavglatency);
 
+	pp_pl_log(3, "%s: latency avg=%.2e uncertainty=%.1f prio=%d\n",
+		  pp->dev, exp(lg_avglatency * lg_base),
+		  exp(standard_deviation * lg_base), rc);
+
 	return rc;
 }
-- 
2.15.1
