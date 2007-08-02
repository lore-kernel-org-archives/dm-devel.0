From: dwysocha@redhat.com
Subject: [patch 2/3] Add MP_RETRY flag for hw handlers to tell
	dm-mpath to retry pg_init.
Date: Thu, 02 Aug 2007 12:15:03 -0400
Message-ID: <20070802161537.911641727@redhat.com>
References: <20070802161501.113656160@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-mpath-add-retry-pg-init.patch
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
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: dm-devel.ids

This patch adds a MP_RETRY flag and "pg_init_retries" feature to dm-multipath
core.  The flag is a generic one, but in this instance we use it to flag
cases where we must retry a pg_init command.  The patch is useful for cases
where a hw handler sends a path initialization command to the storage and
it sees the command complete with an error code indicating the command
should be retried.  In this case, the hardware handler should call 
dm_pg_init_complete() with MP_RETRY set in the err_flags, and this suggests
to the dm-mpath core to retry the pg_init.  However, it is not a guarantee
that the dm-mpath core will actually retry the pg_init.  The number of actual
retries is governed by the multipath feature argument "pg_init_retries".  
Once the dm-mpath core has retried the command "pg_init_retries" times
without success, a subsequent dm_pg_init_complete() with MP_RETRY will
cause the path to be failed via fail_path().  To specify a value of
pg_init_retries, add a line similar to the following in the 'device' section
of your /etc/multipath.conf file:
features                "2 pg_init_retries 7"

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
Index: linux-2.6.23-rc1/drivers/md/dm-hw-handler.h
===================================================================
--- linux-2.6.23-rc1.orig/drivers/md/dm-hw-handler.h
+++ linux-2.6.23-rc1/drivers/md/dm-hw-handler.h
@@ -58,5 +58,6 @@ unsigned dm_scsi_err_handler(struct hw_h
 #define MP_FAIL_PATH 1
 #define MP_BYPASS_PG 2
 #define MP_ERROR_IO  4	/* Don't retry this I/O */
+#define MP_RETRY 8
 
 #endif
Index: linux-2.6.23-rc1/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/md/dm-mpath.c
+++ linux-2.6.23-rc1/drivers/md/dm-mpath.c
@@ -75,6 +75,8 @@ struct multipath {
 	unsigned queue_io;		/* Must we queue all I/O? */
 	unsigned queue_if_no_path;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path;/* Saved state during suspension */
+	unsigned pg_init_retries;	/* Number of times to retry pg_init */
+	unsigned pg_init_count;		/* Number of times pg_init called */
 
 	struct work_struct process_queued_ios;
 	struct bio_list queued_ios;
@@ -221,6 +223,7 @@ static void __switch_pg(struct multipath
 	if (hwh->type && hwh->type->pg_init) {
 		m->pg_init_required = 1;
 		m->queue_io = 1;
+		m->pg_init_count = 0;
 	} else {
 		m->pg_init_required = 0;
 		m->queue_io = 0;
@@ -424,6 +427,7 @@ static void process_queued_ios(struct wo
 		must_queue = 0;
 
 	if (m->pg_init_required && !m->pg_init_in_progress) {
+		m->pg_init_count++;
 		m->pg_init_required = 0;
 		m->pg_init_in_progress = 1;
 		init_required = 1;
@@ -689,9 +693,11 @@ static int parse_features(struct arg_set
 	int r;
 	unsigned argc;
 	struct dm_target *ti = m->ti;
+	char *name;
 
 	static struct param _params[] = {
-		{0, 1, "invalid number of feature args"},
+		{0, 3, "invalid number of feature args"},
+		{0, 50, "invalid number of pg_init retries"},
 	};
 
 	r = read_param(_params, shift(as), &argc, &ti->error);
@@ -701,12 +707,23 @@ static int parse_features(struct arg_set
 	if (!argc)
 		return 0;
 
-	if (!strnicmp(shift(as), MESG_STR("queue_if_no_path")))
-		return queue_if_no_path(m, 1, 0);
-	else {
-		ti->error = "Unrecognised multipath feature request";
-		return -EINVAL;
+	while (argc && !r) {
+		name = shift(as);
+		argc--;
+		if (!strnicmp(name, MESG_STR("queue_if_no_path")))
+			r = queue_if_no_path(m, 1, 0);
+		else if (!strnicmp(name, MESG_STR("pg_init_retries")) &&
+			 (argc >= 1)) {
+			r = read_param(_params + 1, shift(as),
+				       &m->pg_init_retries, &ti->error);
+			argc--;
+		} else {
+			ti->error = "Unrecognised multipath feature request";
+			return -EINVAL;
+		}
 	}
+
+	return r;
 }
 
 static int multipath_ctr(struct dm_target *ti, unsigned int argc,
@@ -976,6 +993,23 @@ static int bypass_pg_num(struct multipat
 }
 
 /*
+ * Retry pg_init on the same path group and path
+ */
+static void retry_pg(struct multipath *m, struct pgpath *pgpath)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+	if (m->pg_init_count <= m->pg_init_retries) {
+		m->pg_init_required = 1;
+		spin_unlock_irqrestore(&m->lock, flags);
+	} else {
+		spin_unlock_irqrestore(&m->lock, flags);
+		fail_path(pgpath);
+	}
+}
+
+/*
  * pg_init must call this when it has completed its initialisation
  */
 void dm_pg_init_complete(struct dm_path *path, unsigned err_flags)
@@ -995,8 +1029,11 @@ void dm_pg_init_complete(struct dm_path 
 	if (err_flags & MP_BYPASS_PG)
 		bypass_pg(m, pg, 1);
 
+	if (err_flags & MP_RETRY)
+		retry_pg(m, pgpath);
+
 	spin_lock_irqsave(&m->lock, flags);
-	if (err_flags) {
+	if (err_flags & ~MP_RETRY) {
 		m->current_pgpath = NULL;
 		m->current_pg = NULL;
 	} else if (!m->pg_init_required)
@@ -1149,8 +1186,13 @@ static int multipath_status(struct dm_ta
 	/* Features */
 	if (type == STATUSTYPE_INFO)
 		DMEMIT("1 %u ", m->queue_size);
-	else if (m->queue_if_no_path)
+	else if (m->queue_if_no_path && !m->pg_init_retries)
 		DMEMIT("1 queue_if_no_path ");
+	else if (!m->queue_if_no_path && m->pg_init_retries)
+		DMEMIT("2 pg_init_retries %u ", m->pg_init_retries);
+	else if (m->queue_if_no_path && m->pg_init_retries)
+		DMEMIT("3 queue_if_no_path pg_init_retries %u ",
+			m->pg_init_retries);
 	else
 		DMEMIT("0 ");
 

-- 
