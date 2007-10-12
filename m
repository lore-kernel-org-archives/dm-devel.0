From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 21/25] dm mpath: add retry pg init
Date: Fri, 12 Oct 2007 18:22:08 +0100
Message-ID: <20071012172208.GG24157@agk.fab.redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Dave Wysochanski <dwysocha@redhat.com>

This patch allows a failed path group initialisation command to be retried.

It adds a generic MP_RETRY flag and a "pg_init_retries" feature to
device-mapper multipath which limits the number of retries.

1. A hw handler sends a path initialization command to the storage and
the command completes with an error code indicating the command
should be retried.  

2. The hardware handler calls dm_pg_init_complete() with MP_RETRY
set in err_flags to ask the dm multipath core to retry.

3. If the retry limit has not been exceeded, pg_init() is retried.
Otherwise fail_path() is called.


If you are using the userspace multipath-tools or device-mapper-multipath
package, you can set pg_init_retries in the 'device' section of your
/etc/multipath.conf file. For example:

features                "2 pg_init_retries 7"

The number of PG retries attempted is reported in the 'dmsetup status' output.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---

[AGK TODO: Perform a fresh review of the state machine changes related to dm_pg_init_complete.]

 drivers/md/dm-hw-handler.h |    1 
 drivers/md/dm-mpath.c      |   81 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 14 deletions(-)

Index: linux-2.6.23/drivers/md/dm-hw-handler.h
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-hw-handler.h	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-hw-handler.h	2007-10-12 15:03:28.000000000 +0100
@@ -58,5 +58,6 @@ unsigned dm_scsi_err_handler(struct hw_h
 #define MP_FAIL_PATH 1
 #define MP_BYPASS_PG 2
 #define MP_ERROR_IO  4	/* Don't retry this I/O */
+#define MP_RETRY 8
 
 #endif
Index: linux-2.6.23/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-mpath.c	2007-10-12 13:14:40.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-mpath.c	2007-10-12 15:03:28.000000000 +0100
@@ -75,6 +75,8 @@ struct multipath {
 	unsigned queue_io;		/* Must we queue all I/O? */
 	unsigned queue_if_no_path;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path;/* Saved state during suspension */
+	unsigned pg_init_retries;	/* Number of times to retry pg_init */
+	unsigned pg_init_count;		/* Number of times pg_init called */
 
 	struct work_struct process_queued_ios;
 	struct bio_list queued_ios;
@@ -225,6 +227,8 @@ static void __switch_pg(struct multipath
 		m->pg_init_required = 0;
 		m->queue_io = 0;
 	}
+
+	m->pg_init_count = 0;
 }
 
 static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg)
@@ -424,6 +428,7 @@ static void process_queued_ios(struct wo
 		must_queue = 0;
 
 	if (m->pg_init_required && !m->pg_init_in_progress) {
+		m->pg_init_count++;
 		m->pg_init_required = 0;
 		m->pg_init_in_progress = 1;
 		init_required = 1;
@@ -689,9 +694,11 @@ static int parse_features(struct arg_set
 	int r;
 	unsigned argc;
 	struct dm_target *ti = m->ti;
+	const char *param_name;
 
 	static struct param _params[] = {
-		{0, 1, "invalid number of feature args"},
+		{0, 3, "invalid number of feature args"},
+		{1, 50, "pg_init_retries must be between 1 and 50"},
 	};
 
 	r = read_param(_params, shift(as), &argc, &ti->error);
@@ -701,12 +708,28 @@ static int parse_features(struct arg_set
 	if (!argc)
 		return 0;
 
-	if (!strnicmp(shift(as), MESG_STR("queue_if_no_path")))
-		return queue_if_no_path(m, 1, 0);
-	else {
+	do {
+		param_name = shift(as);
+		argc--;
+
+		if (!strnicmp(param_name, MESG_STR("queue_if_no_path"))) {
+			r = queue_if_no_path(m, 1, 0);
+			continue;
+		}
+
+		if (!strnicmp(param_name, MESG_STR("pg_init_retries")) &&
+		    (argc >= 1)) {
+			r = read_param(_params + 1, shift(as),
+				       &m->pg_init_retries, &ti->error);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
-		return -EINVAL;
-	}
+		r = -EINVAL;
+	} while (argc && !r);
+
+	return r;
 }
 
 static int multipath_ctr(struct dm_target *ti, unsigned int argc,
@@ -976,6 +999,26 @@ static int bypass_pg_num(struct multipat
 }
 
 /*
+ * Should we retry pg_init immediately?
+ */
+static int pg_init_limit_reached(struct multipath *m, struct pgpath *pgpath)
+{
+	unsigned long flags;
+	int limit_reached = 0;
+
+	spin_lock_irqsave(&m->lock, flags);
+
+	if (m->pg_init_count <= m->pg_init_retries)
+		m->pg_init_required = 1;
+	else
+		limit_reached = 1;
+
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return limit_reached;
+}
+
+/*
  * pg_init must call this when it has completed its initialisation
  */
 void dm_pg_init_complete(struct dm_path *path, unsigned err_flags)
@@ -985,8 +1028,14 @@ void dm_pg_init_complete(struct dm_path 
 	struct multipath *m = pg->m;
 	unsigned long flags;
 
-	/* We insist on failing the path if the PG is already bypassed. */
-	if (err_flags && pg->bypassed)
+	/*
+	 * If requested, retry pg_init until maximum number of retries exceeded.
+	 * If retry not requested and PG already bypassed, always fail the path.
+	 */
+	if (err_flags & MP_RETRY) {
+		if (pg_init_limit_reached(m, pgpath))
+			err_flags |= MP_FAIL_PATH;
+	} else if (err_flags && pg->bypassed)
 		err_flags |= MP_FAIL_PATH;
 
 	if (err_flags & MP_FAIL_PATH)
@@ -996,7 +1045,7 @@ void dm_pg_init_complete(struct dm_path 
 		bypass_pg(m, pg, 1);
 
 	spin_lock_irqsave(&m->lock, flags);
-	if (err_flags) {
+	if (err_flags & ~MP_RETRY) {
 		m->current_pgpath = NULL;
 		m->current_pg = NULL;
 	} else if (!m->pg_init_required)
@@ -1148,11 +1197,15 @@ static int multipath_status(struct dm_ta
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
-		DMEMIT("1 %u ", m->queue_size);
-	else if (m->queue_if_no_path)
-		DMEMIT("1 queue_if_no_path ");
-	else
-		DMEMIT("0 ");
+		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
+	else {
+		DMEMIT("%u ", m->queue_if_no_path +
+			      (m->pg_init_retries > 0) * 2);
+		if (m->queue_if_no_path)
+			DMEMIT("queue_if_no_path ");
+		if (m->pg_init_retries)
+			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
+	}
 
 	if (hwh->type && hwh->type->status)
 		sz += hwh->type->status(hwh, type, result + sz, maxlen - sz);
