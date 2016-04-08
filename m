From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] dm service time: measure service time rather
	than approximate it
Date: Fri,  8 Apr 2016 14:58:39 -0400
Message-ID: <1460141919-12177-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: j-nomura@ce.jp.nec.com, tgill@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The DM multipath service-time path-selector has historically tracked the
amount of outstanding IO per path and used that to approximate the
service-time of each path.  In practice this has shown itself to work
fairly well but we can do better by measuring the actual service-time
during IO completion and using it as the basis for path selection.

Measuring the actual service-time is still prone to inaccuracies given
that service-times vary with IO size.  But to counter any potential for
drawing incorrect conclusions about the service-times of a given path
the measured service-times are reset periodically.

This approach has provided a 10% increase in the selection of a path
that was forcibly made to be less loaded than the alternative path.

Reported-by: Todd Gill <tgill@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c         |   6 ++-
 drivers/md/dm-path-selector.h |   5 ++-
 drivers/md/dm-queue-length.c  |   4 +-
 drivers/md/dm-service-time.c  | 101 +++++++++++-------------------------------
 4 files changed, 35 insertions(+), 81 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 52baf8a..fb37dff 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -105,6 +105,7 @@ struct multipath {
 struct dm_mpath_io {
 	struct pgpath *pgpath;
 	size_t nr_bytes;
+	ktime_t io_start_time;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -507,7 +508,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
-					      nr_bytes);
+					      nr_bytes, &mpio->io_start_time);
 	return DM_MAPIO_REMAPPED;
 }
 
@@ -1374,7 +1375,8 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
+					 &mpio->io_start_time);
 	}
 	clear_request_fn_mpio(m, map_context);
 
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index b6eb536..c09d2bb 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -13,6 +13,7 @@
 #define	DM_PATH_SELECTOR_H
 
 #include <linux/device-mapper.h>
+#include <linux/ktime.h>
 
 #include "dm-mpath.h"
 
@@ -72,9 +73,9 @@ struct path_selector_type {
 		       status_type_t type, char *result, unsigned int maxlen);
 
 	int (*start_io) (struct path_selector *ps, struct dm_path *path,
-			 size_t nr_bytes);
+			 size_t nr_bytes, ktime_t *io_start_time);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes);
+		       size_t nr_bytes, ktime_t *io_start_time);
 };
 
 /* Register a path selector */
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 23f1786..4affb39 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -217,7 +217,7 @@ out:
 }
 
 static int ql_start_io(struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes)
+		       size_t nr_bytes, ktime_t *io_start_time)
 {
 	struct path_info *pi = path->pscontext;
 
@@ -227,7 +227,7 @@ static int ql_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int ql_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, ktime_t *io_start_time)
 {
 	struct path_info *pi = path->pscontext;
 
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index 7b86420..1b3e45a 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -19,7 +19,7 @@
 #define ST_MAX_RELATIVE_THROUGHPUT	100
 #define ST_MAX_RELATIVE_THROUGHPUT_SHIFT	7
 #define ST_MAX_INFLIGHT_SIZE	((size_t)-1 >> ST_MAX_RELATIVE_THROUGHPUT_SHIFT)
-#define ST_VERSION	"0.3.0"
+#define ST_VERSION	"0.4.0"
 
 struct selector {
 	struct list_head valid_paths;
@@ -32,7 +32,8 @@ struct path_info {
 	struct dm_path *path;
 	unsigned repeat_count;
 	unsigned relative_throughput;
-	atomic_t in_flight_size;	/* Total size of in-flight I/Os */
+	s64 service_time_usecs;
+	unsigned select_count;
 };
 
 static struct selector *alloc_selector(void)
@@ -92,7 +93,7 @@ static int st_status(struct path_selector *ps, struct dm_path *path,
 
 		switch (type) {
 		case STATUSTYPE_INFO:
-			DMEMIT("%d %u ", atomic_read(&pi->in_flight_size),
+			DMEMIT("%u %u ", (unsigned)pi->service_time_usecs,
 			       pi->relative_throughput);
 			break;
 		case STATUSTYPE_TABLE:
@@ -159,7 +160,8 @@ static int st_add_path(struct path_selector *ps, struct dm_path *path,
 	pi->path = path;
 	pi->repeat_count = repeat_count;
 	pi->relative_throughput = relative_throughput;
-	atomic_set(&pi->in_flight_size, 0);
+	pi->service_time_usecs = 0;
+	pi->select_count = 0;
 
 	path->pscontext = pi;
 
@@ -195,80 +197,21 @@ static int st_reinstate_path(struct path_selector *ps, struct dm_path *path)
 }
 
 /*
- * Compare the estimated service time of 2 paths, pi1 and pi2,
+ * Compare the most recent service time of 2 paths, pi1 and pi2,
  * for the incoming I/O.
  *
  * Returns:
  * < 0 : pi1 is better
  * 0   : no difference between pi1 and pi2
  * > 0 : pi2 is better
- *
- * Description:
- * Basically, the service time is estimated by:
- *     ('pi->in-flight-size' + 'incoming') / 'pi->relative_throughput'
- * To reduce the calculation, some optimizations are made.
- * (See comments inline)
  */
-static int st_compare_load(struct path_info *pi1, struct path_info *pi2,
-			   size_t incoming)
+static s64 st_compare(struct path_info *pi1, struct path_info *pi2)
 {
-	size_t sz1, sz2, st1, st2;
-
-	sz1 = atomic_read(&pi1->in_flight_size);
-	sz2 = atomic_read(&pi2->in_flight_size);
-
-	/*
-	 * Case 1: Both have same throughput value. Choose less loaded path.
-	 */
-	if (pi1->relative_throughput == pi2->relative_throughput)
-		return sz1 - sz2;
-
-	/*
-	 * Case 2a: Both have same load. Choose higher throughput path.
-	 * Case 2b: One path has no throughput value. Choose the other one.
-	 */
-	if (sz1 == sz2 ||
-	    !pi1->relative_throughput || !pi2->relative_throughput)
+	if (pi1->relative_throughput != pi2->relative_throughput)
 		return pi2->relative_throughput - pi1->relative_throughput;
 
-	/*
-	 * Case 3: Calculate service time. Choose faster path.
-	 *         Service time using pi1:
-	 *             st1 = (sz1 + incoming) / pi1->relative_throughput
-	 *         Service time using pi2:
-	 *             st2 = (sz2 + incoming) / pi2->relative_throughput
-	 *
-	 *         To avoid the division, transform the expression to use
-	 *         multiplication.
-	 *         Because ->relative_throughput > 0 here, if st1 < st2,
-	 *         the expressions below are the same meaning:
-	 *             (sz1 + incoming) / pi1->relative_throughput <
-	 *                 (sz2 + incoming) / pi2->relative_throughput
-	 *             (sz1 + incoming) * pi2->relative_throughput <
-	 *                 (sz2 + incoming) * pi1->relative_throughput
-	 *         So use the later one.
-	 */
-	sz1 += incoming;
-	sz2 += incoming;
-	if (unlikely(sz1 >= ST_MAX_INFLIGHT_SIZE ||
-		     sz2 >= ST_MAX_INFLIGHT_SIZE)) {
-		/*
-		 * Size may be too big for multiplying pi->relative_throughput
-		 * and overflow.
-		 * To avoid the overflow and mis-selection, shift down both.
-		 */
-		sz1 >>= ST_MAX_RELATIVE_THROUGHPUT_SHIFT;
-		sz2 >>= ST_MAX_RELATIVE_THROUGHPUT_SHIFT;
-	}
-	st1 = sz1 * pi2->relative_throughput;
-	st2 = sz2 * pi1->relative_throughput;
-	if (st1 != st2)
-		return st1 - st2;
-
-	/*
-	 * Case 4: Service time is equal. Choose higher throughput path.
-	 */
-	return pi2->relative_throughput - pi1->relative_throughput;
+	/* select path with faster service time */
+	return pi1->service_time_usecs - pi2->service_time_usecs;
 }
 
 static struct dm_path *st_select_path(struct path_selector *ps, size_t nr_bytes)
@@ -286,34 +229,42 @@ static struct dm_path *st_select_path(struct path_selector *ps, size_t nr_bytes)
 	list_move_tail(s->valid_paths.next, &s->valid_paths);
 
 	list_for_each_entry(pi, &s->valid_paths, list)
-		if (!best || (st_compare_load(pi, best, nr_bytes) < 0))
+		if (!best || (st_compare(pi, best) < 0))
 			best = pi;
 
 	if (!best)
 		goto out;
 
 	ret = best->path;
+
+	/*
+	 * Reset the observed service-times periodically (sooner rather than later);
+	 * to avoid a momentary observed low service-time from starving the selection of
+	 * other paths that might have lower service times now.  The bursty nature of IO
+	 * submission forces the need for this.
+	 */
+	if ((best->select_count++ & 15) == 0)
+		list_for_each_entry(pi, &s->valid_paths, list)
+			pi->service_time_usecs = 0;
 out:
 	spin_unlock_irqrestore(&s->lock, flags);
 	return ret;
 }
 
 static int st_start_io(struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes)
+		       size_t nr_bytes, ktime_t *io_start_time)
 {
-	struct path_info *pi = path->pscontext;
-
-	atomic_add(nr_bytes, &pi->in_flight_size);
+	*io_start_time = ktime_get();
 
 	return 0;
 }
 
 static int st_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, ktime_t *io_start_time)
 {
 	struct path_info *pi = path->pscontext;
 
-	atomic_sub(nr_bytes, &pi->in_flight_size);
+	pi->service_time_usecs = ktime_us_delta(ktime_get(), *io_start_time);
 
 	return 0;
 }
-- 
2.6.4 (Apple Git-63)
