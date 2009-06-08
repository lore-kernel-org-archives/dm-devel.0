From: Kiyoshi Ueda via agk <k-ueda@ct.jp.nec.com>
Subject: rqdm-dlb-04-service-time-dlb-add-perf-limit.patch
Date: Mon, 8 Jun 2009 23:03:05 +0100
Message-ID: <20090608220305.GB647@agk-dp.fab.redhat.com>
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


o Limited the second table argument (relative throughput value)
  in 0-100.
  As a result, no need to use 'size_t' for ->perf.  Use 'unsigned'.
  Updated comments/documents.

o Converted the service time calculation method to multiplication
  from division.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 Documentation/device-mapper/dm-service-time.txt |    1 
 drivers/md/dm-service-time.c                    |   57 +++++++++++++++---------
 2 files changed, 37 insertions(+), 21 deletions(-)

Index: 2.6.30-rc5/drivers/md/dm-service-time.c
===================================================================
--- 2.6.30-rc5.orig/drivers/md/dm-service-time.c
+++ 2.6.30-rc5/drivers/md/dm-service-time.c
@@ -13,7 +13,10 @@
 
 #define DM_MSG_PREFIX	"multipath service-time"
 #define ST_MIN_IO	1
-#define ST_VERSION	"0.1.0"
+#define ST_MAX_PERF	100
+#define ST_MAX_PERF_SHIFT	7
+#define ST_MAX_INFLIGHT_SIZE	((size_t)-1 >> ST_MAX_PERF_SHIFT)
+#define ST_VERSION	"0.2.0"
 
 struct selector {
 	struct list_head valid_paths;
@@ -24,7 +27,7 @@ struct path_info {
 	struct list_head list;
 	struct dm_path *path;
 	unsigned repeat_count;
-	size_t perf;
+	unsigned perf;
 	atomic_t in_flight_size;	/* Total size of in-flight I/Os */
 };
 
@@ -84,12 +87,11 @@ static int st_status(struct path_selecto
 
 		switch (type) {
 		case STATUSTYPE_INFO:
-			DMEMIT("%d %llu ", atomic_read(&pi->in_flight_size),
-			       (unsigned long long)pi->perf);
+			DMEMIT("%d %u ", atomic_read(&pi->in_flight_size),
+			       pi->perf);
 			break;
 		case STATUSTYPE_TABLE:
-			DMEMIT("%u %llu ", pi->repeat_count,
-			       (unsigned long long)pi->perf);
+			DMEMIT("%u %u ", pi->repeat_count, pi->perf);
 			break;
 		}
 	}
@@ -103,7 +105,7 @@ static int st_add_path(struct path_selec
 	struct selector *s = ps->context;
 	struct path_info *pi;
 	unsigned repeat_count = ST_MIN_IO;
-	unsigned long long tmpll = 1;
+	unsigned perf = 1;
 
 	/*
 	 * Arguments: [<repeat_count> [<performance>]]
@@ -111,6 +113,7 @@ static int st_add_path(struct path_selec
 	 * 			If not given, default (ST_MIN_IO) is used.
 	 * 	<performance>: The relative throughput value of the path
 	 *		       among all paths in the path-group.
+	 * 		       The valid range: 0-<ST_MAX_PERF>
 	 *		       If not given, minimum value '1' is used.
 	 *		       If '0' is given, the path isn't selected while
 	 * 		       other paths having a positive value are
@@ -126,7 +129,8 @@ static int st_add_path(struct path_selec
 		return -EINVAL;
 	}
 
-	if ((argc == 2) && (sscanf(argv[1], "%llu", &tmpll) != 1)) {
+	if ((argc == 2) &&
+	    (sscanf(argv[1], "%u", &perf) != 1 || perf > ST_MAX_PERF)) {
 		*error = "service-time ps: invalid performance value";
 		return -EINVAL;
 	}
@@ -140,7 +144,7 @@ static int st_add_path(struct path_selec
 
 	pi->path = path;
 	pi->repeat_count = repeat_count;
-	pi->perf = tmpll;
+	pi->perf = perf;
 	atomic_set(&pi->in_flight_size, 0);
 
 	path->pscontext = pi;
@@ -186,7 +190,7 @@ static int st_reinstate_path(struct path
 static int st_compare_load(struct path_info *pi1, struct path_info *pi2,
 			   size_t incoming)
 {
-	size_t sz1, sz2;
+	size_t sz1, sz2, st1, st2;
 
 	sz1 = atomic_read(&pi1->in_flight_size);
 	sz2 = atomic_read(&pi2->in_flight_size);
@@ -206,21 +210,32 @@ static int st_compare_load(struct path_i
 
 	/*
 	 * Case 3: Calculate service time. Choose faster path.
-	 *         if ((sz1+incoming)/pi1->perf < (sz2+incoming)/pi2->perf) pi1
-	 *         if ((sz1+incoming)/pi1->perf > (sz2+incoming)/pi2->perf) pi2
+	 *         Service time using pi1: st1 = (sz1 + incoming) / pi1->perf
+	 *         Service time using pi2: st2 = (sz2 + incoming) / pi2->perf
+	 *
+	 *         To avoid the division, transform the expression to use
+	 *         multiplication.
+	 *         Because ->perf > 0 here, if st1 < st2, the expressions
+	 *         below are the same meaning:
+	 *         (sz1 + incoming) / pi1->perf < (sz2 + incoming) / pi2->perf
+	 *         (sz1 + incoming) * pi2->perf < (sz2 + incoming) * pi1->perf
+	 *         So use the later one.
 	 */
 	sz1 += incoming;
 	sz2 += incoming;
-	while (sz1 && sz2 && (sz1 < pi1->perf) && (sz2 < pi2->perf)) {
-		/* Size is not big enough to compare by division. Shift up */
-		sz1 <<= 2;
-		sz2 <<= 2;
+	if (unlikely(sz1 >= ST_MAX_INFLIGHT_SIZE ||
+		     sz2 >= ST_MAX_INFLIGHT_SIZE)) {
+		/*
+		 * Size may be too big for multiplying pi->perf and overflow.
+		 * To avoid the overflow and mis-selection, shift down both.
+		 */
+		sz1 >>= ST_MAX_PERF_SHIFT;
+		sz2 >>= ST_MAX_PERF_SHIFT;
 	}
-	do_div(sz1, pi1->perf);
-	do_div(sz2, pi2->perf);
-
-	if (sz1 != sz2)
-		return sz1 - sz2;
+	st1 = sz1 * pi2->perf;
+	st2 = sz2 * pi1->perf;
+	if (st1 != st2)
+		return st1 - st2;
 
 	/*
 	 * Case 4: Service time is equal. Choose higher performance path.
Index: 2.6.30-rc5/Documentation/device-mapper/dm-service-time.txt
===================================================================
--- 2.6.30-rc5.orig/Documentation/device-mapper/dm-service-time.txt
+++ 2.6.30-rc5/Documentation/device-mapper/dm-service-time.txt
@@ -19,6 +19,7 @@ Table parameters for each path: [<repeat
 			the default value, see the activated table.
 	<performance>: The relative throughput value of the path
 		       among all paths in the path-group.
+		       The valid range is 0-100.
 		       If not given, minimum value '1' is used.
 		       If '0' is given, the path isn't selected while
 		       other paths having a positive value are available.
