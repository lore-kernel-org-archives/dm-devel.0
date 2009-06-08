From: Kiyoshi Ueda via agk <k-ueda@ct.jp.nec.com>
Subject: rqdm-dlb-04-service-time-dlb-naming-change.patch
Date: Mon, 8 Jun 2009 23:05:03 +0100
Message-ID: <20090608220503.GD647@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Changed the name of the member 'perf' in the path_info structure
to 'relative_throughput' for readability.

Also, updated the related parts of comments and documents.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 Documentation/device-mapper/dm-service-time.txt |   43 ++++++------
 drivers/md/dm-service-time.c                    |   84 +++++++++++++-----------
 2 files changed, 69 insertions(+), 58 deletions(-)

Index: 2.6.30-rc5/Documentation/device-mapper/dm-service-time.txt
===================================================================
--- 2.6.30-rc5.orig/Documentation/device-mapper/dm-service-time.txt
+++ 2.6.30-rc5/Documentation/device-mapper/dm-service-time.txt
@@ -12,24 +12,25 @@ in a path-group, and it can be specified
 
 The path selector name is 'service-time'.
 
-Table parameters for each path: [<repeat_count> [<performance>]]
+Table parameters for each path: [<repeat_count> [<relative_throughput>]]
 	<repeat_count>: The number of I/Os to dispatch using the selected
 			path before switching to the next path.
 			If not given, internal default is used.  To check
 			the default value, see the activated table.
-	<performance>: The relative throughput value of the path
-		       among all paths in the path-group.
-		       The valid range is 0-100.
-		       If not given, minimum value '1' is used.
-		       If '0' is given, the path isn't selected while
-		       other paths having a positive value are available.
+	<relative_throughput>: The relative throughput value of the path
+			among all paths in the path-group.
+			The valid range is 0-100.
+			If not given, minimum value '1' is used.
+			If '0' is given, the path isn't selected while
+			other paths having a positive value are available.
 
-Status for each path: <status> <fail-count> <in-flight-size> <performance>
+Status for each path: <status> <fail-count> <in-flight-size> \
+		      <relative_throughput>
 	<status>: 'A' if the path is active, 'F' if the path is failed.
 	<fail-count>: The number of path failures.
 	<in-flight-size>: The size of in-flight I/Os on the path.
-	<performance>: The relative throughput value of the path
-		       among all paths in the path-group.
+	<relative_throughput>: The relative throughput value of the path
+			among all paths in the path-group.
 
 
 Algorithm
@@ -40,31 +41,33 @@ dispatched and substracts when completed
 Basically, dm-service-time selects a path having minimum service time
 which is calculated by:
 
-	('in-flight-size' + 'size-of-incoming-io') / 'performance'
+	('in-flight-size' + 'size-of-incoming-io') / 'relative_throughput'
 
 However, some optimizations below are used to reduce the calculation
 as much as possible.
 
-	1. If the paths have the same 'performance', skip the division
-	   and just compare the 'in-flight-size'.
+	1. If the paths have the same 'relative_throughput', skip
+	   the division and just compare the 'in-flight-size'.
 
 	2. If the paths have the same 'in-flight-size', skip the division
-	   and just compare the 'performance'.
+	   and just compare the 'relative_throughput'.
 
-	3. If some paths have non-zero 'performance' and others have zero
-	   'performance', ignore those paths with zero 'performance'.
+	3. If some paths have non-zero 'relative_throughput' and others
+	   have zero 'relative_throughput', ignore those paths with zero
+	   'relative_throughput'.
 
 If such optimizations can't be applied, calculate service time, and
 compare service time.
-If calculated service time is equal, the path having maximum 'performance'
-may be better.  So compare 'performance' then.
+If calculated service time is equal, the path having maximum
+'relative_throughput' may be better.  So compare 'relative_throughput'
+then.
 
 
 Examples
 ========
 In case that 2 paths (sda and sdb) are used with repeat_count == 128
-and sda has an average throughput 1GB/s and sdb has 4GB/s, 'performance'
-value may be '1' for sda and '4' for sdb.
+and sda has an average throughput 1GB/s and sdb has 4GB/s,
+'relative_throughput' value may be '1' for sda and '4' for sdb.
 
 # echo "0 10 multipath 0 0 1 1 service-time 0 2 2 8:0 128 1 8:16 128 4" \
   dmsetup create test
Index: 2.6.30-rc5/drivers/md/dm-service-time.c
===================================================================
--- 2.6.30-rc5.orig/drivers/md/dm-service-time.c
+++ 2.6.30-rc5/drivers/md/dm-service-time.c
@@ -13,9 +13,9 @@
 
 #define DM_MSG_PREFIX	"multipath service-time"
 #define ST_MIN_IO	1
-#define ST_MAX_PERF	100
-#define ST_MAX_PERF_SHIFT	7
-#define ST_MAX_INFLIGHT_SIZE	((size_t)-1 >> ST_MAX_PERF_SHIFT)
+#define ST_MAX_RELATIVE_THROUGHPUT	100
+#define ST_MAX_RELATIVE_THROUGHPUT_SHIFT	7
+#define ST_MAX_INFLIGHT_SIZE	((size_t)-1 >> ST_MAX_RELATIVE_THROUGHPUT_SHIFT)
 #define ST_VERSION	"0.2.0"
 
 struct selector {
@@ -27,7 +27,7 @@ struct path_info {
 	struct list_head list;
 	struct dm_path *path;
 	unsigned repeat_count;
-	unsigned perf;
+	unsigned relative_throughput;
 	atomic_t in_flight_size;	/* Total size of in-flight I/Os */
 };
 
@@ -88,10 +88,11 @@ static int st_status(struct path_selecto
 		switch (type) {
 		case STATUSTYPE_INFO:
 			DMEMIT("%d %u ", atomic_read(&pi->in_flight_size),
-			       pi->perf);
+			       pi->relative_throughput);
 			break;
 		case STATUSTYPE_TABLE:
-			DMEMIT("%u %u ", pi->repeat_count, pi->perf);
+			DMEMIT("%u %u ", pi->repeat_count,
+			       pi->relative_throughput);
 			break;
 		}
 	}
@@ -105,19 +106,19 @@ static int st_add_path(struct path_selec
 	struct selector *s = ps->context;
 	struct path_info *pi;
 	unsigned repeat_count = ST_MIN_IO;
-	unsigned perf = 1;
+	unsigned relative_throughput = 1;
 
 	/*
-	 * Arguments: [<repeat_count> [<performance>]]
+	 * Arguments: [<repeat_count> [<relative_throughput>]]
 	 * 	<repeat_count>: The number of I/Os before switching path.
 	 * 			If not given, default (ST_MIN_IO) is used.
-	 * 	<performance>: The relative throughput value of the path
-	 *		       among all paths in the path-group.
-	 * 		       The valid range: 0-<ST_MAX_PERF>
-	 *		       If not given, minimum value '1' is used.
-	 *		       If '0' is given, the path isn't selected while
-	 * 		       other paths having a positive value are
-	 * 		       available.
+	 * 	<relative_throughput>: The relative throughput value of
+	 *			the path among all paths in the path-group.
+	 * 			The valid range: 0-<ST_MAX_RELATIVE_THROUGHPUT>
+	 *			If not given, minimum value '1' is used.
+	 *			If '0' is given, the path isn't selected while
+	 * 			other paths having a positive value are
+	 * 			available.
 	 */
 	if (argc > 2) {
 		*error = "service-time ps: incorrect number of arguments";
@@ -130,8 +131,9 @@ static int st_add_path(struct path_selec
 	}
 
 	if ((argc == 2) &&
-	    (sscanf(argv[1], "%u", &perf) != 1 || perf > ST_MAX_PERF)) {
-		*error = "service-time ps: invalid performance value";
+	    (sscanf(argv[1], "%u", &relative_throughput) != 1 ||
+	     relative_throughput > ST_MAX_RELATIVE_THROUGHPUT)) {
+		*error = "service-time ps: invalid relative_throughput value";
 		return -EINVAL;
 	}
 
@@ -144,7 +146,7 @@ static int st_add_path(struct path_selec
 
 	pi->path = path;
 	pi->repeat_count = repeat_count;
-	pi->perf = perf;
+	pi->relative_throughput = relative_throughput;
 	atomic_set(&pi->in_flight_size, 0);
 
 	path->pscontext = pi;
@@ -183,7 +185,7 @@ static int st_reinstate_path(struct path
  *
  * Description:
  * Basically, the service time is estimated by:
- *     ('pi->in-flight-size' + 'incoming') / 'pi->perf'
+ *     ('pi->in-flight-size' + 'incoming') / 'pi->relative_throughput'
  * To reduce the calculation, some optimizations are made.
  * (See comments inline)
  */
@@ -196,29 +198,34 @@ static int st_compare_load(struct path_i
 	sz2 = atomic_read(&pi2->in_flight_size);
 
 	/*
-	 * Case 1: Both have same performance value. Choose less loaded path.
+	 * Case 1: Both have same throughput value. Choose less loaded path.
 	 */
-	if (pi1->perf == pi2->perf)
+	if (pi1->relative_throughput == pi2->relative_throughput)
 		return sz1 - sz2;
 
 	/*
-	 * Case 2a: Both have same load. Choose higher performance path.
-	 * Case 2b: One path has no performance value. Choose the other one.
+	 * Case 2a: Both have same load. Choose higher throughput path.
+	 * Case 2b: One path has no throughput value. Choose the other one.
 	 */
-	if (sz1 == sz2 || !pi1->perf || !pi2->perf)
-		return pi2->perf - pi1->perf;
+	if (sz1 == sz2 ||
+	    !pi1->relative_throughput || !pi2->relative_throughput)
+		return pi2->relative_throughput - pi1->relative_throughput;
 
 	/*
 	 * Case 3: Calculate service time. Choose faster path.
-	 *         Service time using pi1: st1 = (sz1 + incoming) / pi1->perf
-	 *         Service time using pi2: st2 = (sz2 + incoming) / pi2->perf
+	 *         Service time using pi1:
+	 *             st1 = (sz1 + incoming) / pi1->relative_throughput
+	 *         Service time using pi2:
+	 *             st2 = (sz2 + incoming) / pi2->relative_throughput
 	 *
 	 *         To avoid the division, transform the expression to use
 	 *         multiplication.
-	 *         Because ->perf > 0 here, if st1 < st2, the expressions
-	 *         below are the same meaning:
-	 *         (sz1 + incoming) / pi1->perf < (sz2 + incoming) / pi2->perf
-	 *         (sz1 + incoming) * pi2->perf < (sz2 + incoming) * pi1->perf
+	 *         Because ->relative_throughput > 0 here, if st1 < st2,
+	 *         the expressions below are the same meaning:
+	 *             (sz1 + incoming) / pi1->relative_throughput <
+	 *                 (sz2 + incoming) / pi2->relative_throughput
+	 *             (sz1 + incoming) * pi2->relative_throughput <
+	 *                 (sz2 + incoming) * pi1->relative_throughput
 	 *         So use the later one.
 	 */
 	sz1 += incoming;
@@ -226,21 +233,22 @@ static int st_compare_load(struct path_i
 	if (unlikely(sz1 >= ST_MAX_INFLIGHT_SIZE ||
 		     sz2 >= ST_MAX_INFLIGHT_SIZE)) {
 		/*
-		 * Size may be too big for multiplying pi->perf and overflow.
+		 * Size may be too big for multiplying pi->relative_throughput
+		 * and overflow.
 		 * To avoid the overflow and mis-selection, shift down both.
 		 */
-		sz1 >>= ST_MAX_PERF_SHIFT;
-		sz2 >>= ST_MAX_PERF_SHIFT;
+		sz1 >>= ST_MAX_RELATIVE_THROUGHPUT_SHIFT;
+		sz2 >>= ST_MAX_RELATIVE_THROUGHPUT_SHIFT;
 	}
-	st1 = sz1 * pi2->perf;
-	st2 = sz2 * pi1->perf;
+	st1 = sz1 * pi2->relative_throughput;
+	st2 = sz2 * pi1->relative_throughput;
 	if (st1 != st2)
 		return st1 - st2;
 
 	/*
-	 * Case 4: Service time is equal. Choose higher performance path.
+	 * Case 4: Service time is equal. Choose higher throughput path.
 	 */
-	return pi2->perf - pi1->perf;
+	return pi2->relative_throughput - pi1->relative_throughput;
 }
 
 static struct dm_path *st_select_path(struct path_selector *ps,
