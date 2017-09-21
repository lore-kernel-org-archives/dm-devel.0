From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH V2 4/4] multipath-tools: calculate standard
	deviation on a logarithmic scale for prioritizer path_latency
Date: Thu, 21 Sep 2017 21:23:19 +0800
Message-ID: <1506000199-9644-5-git-send-email-guanjunxiong@huawei.com>
References: <1506000199-9644-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1506000199-9644-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com, hare@suse.de
Cc: xose.vazquez@gmail.com, guanjunxiong@huawei.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, niuhaoxin@huawei.com, mwilck@suse.com
List-Id: dm-devel.ids

There is a wrong calculation for standard deviation for prioritizers
path_latency. Because the scale is logarithmic, we need to calculate
the standard deviation on a log scale. However, if we first compute
every logarithmic value of each sample of path latency, the standard
deviation calculating is simple as before because the logarithm of
logarithmic normal distribution is normal distribution.

Besides, this patch discards the path_interval calculating because
it is unreasonable to compare two different dimension of datas.
Instead, this patch uses another condition which comparable.

In addition, the minimum base_num is large so that standard deviation
is too small to meet the new condition given that the base_num is set
to the smallest value i.e 2. This patch lets base_num range from 1.01
to 100.

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/prioritizers/path_latency.c | 169 +++++++++++++++++--------------
 1 file changed, 92 insertions(+), 77 deletions(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index 69c9bd65..9d5397ec 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -38,10 +38,12 @@
 #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
 
 #define MAX_IO_NUM		200
-#define MIN_IO_NUM		2
+#define MIN_IO_NUM		20
+#define DEF_IO_NUM		100
 
 #define MAX_BASE_NUM		10
-#define MIN_BASE_NUM		2
+#define MIN_BASE_NUM		1.01
+#define DEF_BASE_NUM		1.5
 
 #define MAX_AVG_LATENCY		100000000.	/* Unit: us */
 #define MIN_AVG_LATENCY		1.		/* Unit: us */
@@ -53,7 +55,7 @@
 
 #define DEF_BLK_SIZE		4096
 
-static long long path_latency[MAX_IO_NUM];
+static double lg_path_latency[MAX_IO_NUM];
 
 static inline long long timeval_to_us(const struct timespec *tv)
 {
@@ -129,7 +131,7 @@ static int do_directio_read(int fd, unsigned int timeout, char *buf, int sz)
 	return 0;
 }
 
-int check_args_valid(int io_num, int base_num)
+int check_args_valid(int io_num, double base_num)
 {
 	if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM)) {
 		pp_pl_log(0, "args io_num is outside the valid range");
@@ -149,7 +151,7 @@ int check_args_valid(int io_num, int base_num)
  * "io_num=20 base_num=10", this function can get io_num value 20 and
  * base_num value 10.
  */
-static int get_ionum_and_basenum(char *args, int *ionum, int *basenum)
+static int get_ionum_and_basenum(char *args, int *ionum, double *basenum)
 {
 	char split_char[] = " \t";
 	char *arg, *temp;
@@ -177,7 +179,7 @@ static int get_ionum_and_basenum(char *args, int *ionum, int *basenum)
 			flag_io = 1;
 		}
 		else if (!strncmp(str, "base_num=", 9) && strlen(str) > 9) {
-			*basenum = (int)strtol(str + 9, &str_inval, 10);
+			*basenum = strtod(str + 9, &str_inval);
 			if (str == str_inval)
 				goto out;
 			flag_base = 1;
@@ -196,56 +198,36 @@ out:
 	return 0;
 }
 
-long long calc_standard_deviation(long long *path_latency, int size,
-				  long long avglatency)
+double calc_standard_deviation(double *lg_path_latency, int size,
+				  double lg_avglatency)
 {
 	int index;
-	long long total = 0;
+	double sum = 0;
 
 	for (index = 0; index < size; index++) {
-		total +=
-		    (path_latency[index] - avglatency) * (path_latency[index] -
-							  avglatency);
+		sum += (lg_path_latency[index] - lg_avglatency) *
+			(lg_path_latency[index] - lg_avglatency);
 	}
 
-	total /= (size - 1);
+	sum /= (size - 1);
 
-	return (long long)sqrt((double)total);
+	return sqrt(sum);
 }
 
-int calcPrio(double avglatency, double max_avglatency, double min_avglatency,
-	     double base_num)
+/*
+ * Do not scale the prioriy in a certain range such as [0, 1024]
+ * because scaling will eliminate the effect of base_num.
+ */
+int calcPrio(double lg_avglatency, double lg_maxavglatency,
+		double lg_minavglatency)
 {
-	double lavglatency = log(avglatency) / log(base_num);
-	double lmax_avglatency = log(max_avglatency) / log(base_num);
-	double lmin_avglatency = log(min_avglatency) / log(base_num);
+	if (lg_avglatency <= lg_minavglatency)
+		return lg_maxavglatency - lg_minavglatency;
 
-	if (lavglatency <= lmin_avglatency)
-		return (int)(lmax_avglatency + 1.);
-
-	if (lavglatency > lmax_avglatency)
+	if (lg_avglatency >= lg_maxavglatency)
 		return 0;
 
-	return (int)(lmax_avglatency - lavglatency + 1.);
-}
-
-/* Calc the latency interval corresponding to the average latency */
-long long calc_latency_interval(double avglatency, double max_avglatency,
-				double min_avglatency, double base_num)
-{
-	double lavglatency = log(avglatency) / log(base_num);
-	double lmax_avglatency = log(max_avglatency) / log(base_num);
-	double lmin_avglatency = log(min_avglatency) / log(base_num);
-
-	if ((lavglatency <= lmin_avglatency)
-	    || (lavglatency > lmax_avglatency))
-		return 0;	/* Invalid value */
-
-	if ((double)((int)lavglatency) == lavglatency)
-		return (long long)(avglatency - (avglatency / base_num));
-	else
-		return (long long)(pow(base_num, (double)((int)lavglatency + 1))
-				   - pow(base_num, (double)((int)lavglatency)));
+	return lg_maxavglatency - lg_avglatency;
 }
 
 int getprio(struct path *pp, char *args, unsigned int timeout)
@@ -253,26 +235,34 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 	int rc, temp;
 	int index = 0;
 	int io_num = 0;
-	int base_num = 0;
-	long long avglatency;
-	long long latency_interval;
-	long long standard_deviation;
-	long long toldelay = 0;
+	double base_num = 0;
+	double lg_avglatency, lg_maxavglatency, lg_minavglatency;
+	double standard_deviation;
+	double lg_toldelay = 0;
 	long long before, after;
 	struct timespec tv;
 	int blksize;
 	char *buf;
 	int restore_flags = 0;
+	double lg_base;
+	long long sum_latency = 0;
+	long long arith_mean_lat;
 
 	if (pp->fd < 0)
 		return -1;
 
 	if (get_ionum_and_basenum(args, &io_num, &base_num) == 0) {
-		pp_pl_log(0, "%s: get path_latency args fail", pp->dev);
-		return DEFAULT_PRIORITY;
+		io_num = DEF_IO_NUM;
+		base_num = DEF_BASE_NUM;
+		pp_pl_log(0, "%s: fails to get path_latency args, set default:"
+				"io_num=%d base_num=%.3lf",
+				pp->dev, io_num, base_num);
 	}
 
-	memset(path_latency, 0, sizeof(path_latency));
+	memset(lg_path_latency, 0, sizeof(lg_path_latency));
+	lg_base = log(base_num);
+	lg_maxavglatency = log(MAX_AVG_LATENCY) / lg_base;
+	lg_minavglatency = log(MIN_AVG_LATENCY) / lg_base;
 
 	prepare_directio_read(pp->fd, &blksize, &buf, &restore_flags);
 
@@ -289,43 +279,68 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 
 		(void)clock_gettime(CLOCK_MONOTONIC, &tv);
 		after = timeval_to_us(&tv);
-
-		path_latency[index] = after - before;
-		toldelay += path_latency[index++];
+		/*
+		 * We assume that the latency complies with Log-normal
+		 * distribution. The logarithm of latency is in normal
+		 * distribution.
+		 */
+		lg_path_latency[index] = log(after - before) / lg_base;
+		lg_toldelay += lg_path_latency[index++];
+		sum_latency += after - before;
 	}
 
 	cleanup_directio_read(pp->fd, buf, restore_flags);
 
-	avglatency = toldelay / (long long)io_num;
-	pp_pl_log(4, "%s: average latency is (%lld us)", pp->dev, avglatency);
+	lg_avglatency = lg_toldelay / (long long)io_num;
+	arith_mean_lat = sum_latency / (long long)io_num;
+	pp_pl_log(4, "%s: arithmetic mean latency is (%lld us), geometric mean latency is (%lld us)",
+			pp->dev, arith_mean_lat,
+			(long long)pow(base_num, lg_avglatency));
 
-	if (avglatency > MAX_AVG_LATENCY) {
+	if (lg_avglatency > lg_maxavglatency) {
 		pp_pl_log(0,
 			  "%s: average latency (%lld us) is outside the thresold (%lld us)",
-			  pp->dev, avglatency, (long long)MAX_AVG_LATENCY);
+			  pp->dev, (long long)pow(base_num, lg_avglatency),
+			  (long long)MAX_AVG_LATENCY);
 		return DEFAULT_PRIORITY;
 	}
 
+	standard_deviation = calc_standard_deviation(lg_path_latency,
+			index, lg_avglatency);
+	/*
+	 * In calPrio(), we let prio y = f(x) = log(max, base) - log (x, base);
+	 * So if we want to let the priority of the latency outside 2 standard
+	 * deviations can be distinguished from the latency inside 2 standard
+	 * deviation, in others words at most 95% are the same and at least 5%
+	 * are different according interval estimation of normal distribution,
+	 * we should warn the user to set the base_num to be smaller if the
+	 * log(x_threshold, base) is small than 2 standard deviation.
+	 * x_threshold is derived from:
+	 * y + 1 = f(x) + 1 = f(x) + log(base, base), so x_threadshold =
+	 * base_num; Note that we only can compare the logarithm of x_threshold
+	 * with the standard deviation because the standard deviation is derived
+	 * from logarithm of latency.
+	 *
+	 * therefore , we recommend the base_num to meet the condition :
+	 * 1 <= 2 * standard_deviation
+	 */
+	pp_pl_log(5, "%s: standard deviation for logarithm of latency = %.6f",
+			pp->dev, standard_deviation);
+	if (standard_deviation <= 0.5)
+		pp_pl_log(3, "%s: the base_num(%.3lf) is too big to distinguish different priority "
+			  "of two far-away latency. It is recommend to be set smaller",
+			  pp->dev, base_num);
 	/*
-	 * Min average latency and max average latency are constant, the args
-	 * base_num set can change latency_interval value corresponding to
-	 * avglatency and is not constant.
-	 * Warn the user if latency_interval is smaller than (2 * standard_deviation),
-	 * or equal.
+	 * If the standard deviation is too large , we should also warn the user
 	 */
-	standard_deviation =
-	    calc_standard_deviation(path_latency, index, avglatency);
-	latency_interval =
-	    calc_latency_interval(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY,
-				  base_num);
-	if ((latency_interval != 0)
-	    && (latency_interval <= (2 * standard_deviation)))
-		pp_pl_log(3,
-			  "%s: latency interval (%lld) according to average latency (%lld us) is smaller than "
-			  "2 * standard deviation (%lld us), or equal, args base_num (%d) needs to be set bigger value",
-			  pp->dev, latency_interval, avglatency,
-			  standard_deviation, base_num);
-
-	rc = calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
+
+	if (standard_deviation > 4)
+		pp_pl_log(3, "%s: the base_num(%.3lf) is too small to avoid noise disturbance "
+			  ".It is recommend to be set larger",
+			  pp->dev, base_num);
+
+
+	rc = calcPrio(lg_avglatency, lg_maxavglatency, lg_minavglatency);
+
 	return rc;
 }
-- 
2.11.1
