From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] dm log userspace,
	add 'luid' to distinguish between log instances
Date: Tue, 28 Jul 2009 10:51:50 -0500
Message-ID: <1248796310.25220.9.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Device-mapper userspace logs (like the clustered log) are
identified by a universally unique identifier (UUID).  This
identifier is used to associate requests from the kernel to
a specific log in userspace.  The UUID must be unique everywhere,
since multiple machines may use this identifier when communicating
about a particular log, as is the case for cluster logs.

Sometimes, device-mapper/LVM may re-use a UUID.  This is the
case during 'pvmove's, when moving from one segment of an LV
to another, or when resizing a mirror, etc.  In these cases,
a new log is created with the same UUID and loaded in the
"inactive" slot.  When a device-mapper "resume" is issued,
the "live" table is deactivated and the new "inactive" table
becomes "live".  (The "inactive" table can also be removed
via a device-mapper 'clear' command.)

The above two issues where colliding.  More than one log was being
created with the same UUID, and there was no way to distinguish
between them.  So, sometimes the wrong log would be swapped
out during the exchange.

The solution is to create a locally unique identifier,
'luid', to go along with the UUID.  This new identifier is used
to determine exactly which log is being referenced by the kernel
when the log exchange is made.  The identifier is not
universally safe, but it does not need to be, since
create/destroy/suspend/resume operations are bound to a specific
machine; and these are the operations that make up the exchange.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -21,6 +21,7 @@ struct log_c {
 	struct dm_target *ti;
 	uint32_t region_size;
 	region_t region_count;
+	uint64_t luid;
 	char uuid[DM_UUID_LEN];
 
 	char *usr_argv_str;
@@ -63,7 +64,7 @@ static int userspace_do_request(struct l
 	 * restored.
 	 */
 retry:
-	r = dm_consult_userspace(uuid, request_type, data,
+	r = dm_consult_userspace(uuid, lc->luid, request_type, data,
 				 data_size, rdata, rdata_size);
 
 	if (r != -ESRCH)
@@ -74,14 +75,15 @@ retry:
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(2*HZ);
 		DMWARN("Attempting to contact userspace log server...");
-		r = dm_consult_userspace(uuid, DM_ULOG_CTR, lc->usr_argv_str,
+		r = dm_consult_userspace(uuid, lc->luid, DM_ULOG_CTR,
+					 lc->usr_argv_str,
 					 strlen(lc->usr_argv_str) + 1,
 					 NULL, NULL);
 		if (!r)
 			break;
 	}
 	DMINFO("Reconnected to userspace log server... DM_ULOG_CTR complete");
-	r = dm_consult_userspace(uuid, DM_ULOG_RESUME, NULL,
+	r = dm_consult_userspace(uuid, lc->luid, DM_ULOG_RESUME, NULL,
 				 0, NULL, NULL);
 	if (!r)
 		goto retry;
@@ -154,6 +156,9 @@ static int userspace_ctr(struct dm_dirty
 		return -ENOMEM;
 	}
 
+	/* The ptr value is sufficient for local unique id */
+	lc->luid = (uint64_t)lc;
+
 	lc->ti = ti;
 
 	if (strlen(argv[0]) > (DM_UUID_LEN - 1)) {
@@ -173,7 +178,7 @@ static int userspace_ctr(struct dm_dirty
 	}
 
 	/* Send table string */
-	r = dm_consult_userspace(lc->uuid, DM_ULOG_CTR,
+	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_CTR,
 				 ctr_str, str_size, NULL, NULL);
 
 	if (r == -ESRCH) {
@@ -183,7 +188,7 @@ static int userspace_ctr(struct dm_dirty
 
 	/* Since the region size does not change, get it now */
 	rdata_size = sizeof(rdata);
-	r = dm_consult_userspace(lc->uuid, DM_ULOG_GET_REGION_SIZE,
+	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_GET_REGION_SIZE,
 				 NULL, 0, (char *)&rdata, &rdata_size);
 
 	if (r) {
@@ -212,7 +217,7 @@ static void userspace_dtr(struct dm_dirt
 	int r;
 	struct log_c *lc = log->context;
 
-	r = dm_consult_userspace(lc->uuid, DM_ULOG_DTR,
+	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_DTR,
 				 NULL, 0,
 				 NULL, NULL);
 
@@ -227,7 +232,7 @@ static int userspace_presuspend(struct d
 	int r;
 	struct log_c *lc = log->context;
 
-	r = dm_consult_userspace(lc->uuid, DM_ULOG_PRESUSPEND,
+	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_PRESUSPEND,
 				 NULL, 0,
 				 NULL, NULL);
 
@@ -239,7 +244,7 @@ static int userspace_postsuspend(struct 
 	int r;
 	struct log_c *lc = log->context;
 
-	r = dm_consult_userspace(lc->uuid, DM_ULOG_POSTSUSPEND,
+	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_POSTSUSPEND,
 				 NULL, 0,
 				 NULL, NULL);
 
@@ -252,7 +257,7 @@ static int userspace_resume(struct dm_di
 	struct log_c *lc = log->context;
 
 	lc->in_sync_hint = 0;
-	r = dm_consult_userspace(lc->uuid, DM_ULOG_RESUME,
+	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_RESUME,
 				 NULL, 0,
 				 NULL, NULL);
 
Index: linux-2.6/drivers/md/dm-log-userspace-transfer.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-transfer.c
+++ linux-2.6/drivers/md/dm-log-userspace-transfer.c
@@ -147,7 +147,8 @@ static void cn_ulog_callback(void *data)
 
 /**
  * dm_consult_userspace
- * @uuid: log's uuid (must be DM_UUID_LEN in size)
+ * @uuid: log's universal unique identifier (must be DM_UUID_LEN in size)
+ * @luid: log's local unique identifier
  * @request_type:  found in include/linux/dm-log-userspace.h
  * @data: data to tx to the server
  * @data_size: size of data in bytes
@@ -163,7 +164,7 @@ static void cn_ulog_callback(void *data)
  *
  * Returns: 0 on success, -EXXX on failure
  **/
-int dm_consult_userspace(const char *uuid, int request_type,
+int dm_consult_userspace(const char *uuid, uint64_t luid, int request_type,
 			 char *data, size_t data_size,
 			 char *rdata, size_t *rdata_size)
 {
@@ -190,6 +191,7 @@ resend:
 
 	memset(tfr, 0, DM_ULOG_PREALLOCED_SIZE - overhead_size);
 	memcpy(tfr->uuid, uuid, DM_UUID_LEN);
+	tfr->luid = luid;
 	tfr->seq = dm_ulog_seq++;
 
 	/*
Index: linux-2.6/drivers/md/dm-log-userspace-transfer.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-transfer.h
+++ linux-2.6/drivers/md/dm-log-userspace-transfer.h
@@ -11,7 +11,7 @@
 
 int dm_ulog_tfr_init(void);
 void dm_ulog_tfr_exit(void);
-int dm_consult_userspace(const char *uuid, int request_type,
+int dm_consult_userspace(const char *uuid, uint64_t luid, int request_type,
 			 char *data, size_t data_size,
 			 char *rdata, size_t *rdata_size);
 
Index: linux-2.6/include/linux/dm-log-userspace.h
===================================================================
--- linux-2.6.orig/include/linux/dm-log-userspace.h
+++ linux-2.6/include/linux/dm-log-userspace.h
@@ -371,7 +371,18 @@
 	(DM_ULOG_REQUEST_MASK & (request_type))
 
 struct dm_ulog_request {
-	char uuid[DM_UUID_LEN]; /* Ties a request to a specific mirror log */
+	/*
+	 * The local unique identifier (luid) and the universally unique
+	 * identifier (uuid) are used to tie a request to a specific
+	 * mirror log.  A single machine log could probably make due with
+	 * just the 'luid', but a cluster-aware log must use the 'uuid' and
+	 * the 'luid'.  The uuid is what is required for node to node
+	 * communication concerning a particular log, but the 'luid' helps
+	 * differentiate between logs that are being swapped and have the
+	 * same 'uuid'.  (Think "live" and "inactive" device-mapper tables.)
+	 */
+	uint64_t luid;
+	char uuid[DM_UUID_LEN];
 	char padding[7];        /* Padding because DM_UUID_LEN = 129 */
 
 	int32_t error;          /* Used to report back processing errors */
