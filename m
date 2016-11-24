From: tang.junhui@zte.com.cn
Subject: [PATCH 2/2] dm-mpath: Remove useless
	retain_attached_hw_handler parameter
Date: Thu, 24 Nov 2016 15:11:49 +0800
Message-ID: <1479971509-6320-2-git-send-email-tang.junhui@zte.com.cn>
References: <1479971509-6320-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1479971509-6320-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

Hardware handle would be retained no matter parameter
retain_attached_hw_handler is set or not in the logic
of current code. So remove this useless parameter.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/dm-mpath.c | 34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index b1aba63..fe6a529 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -129,10 +129,9 @@ static void process_queued_bios(struct work_struct *work);
 #define MPATHF_QUEUE_IO 0			/* Must we queue all I/O? */
 #define MPATHF_QUEUE_IF_NO_PATH 1		/* Queue I/O if last path fails? */
 #define MPATHF_SAVED_QUEUE_IF_NO_PATH 2		/* Saved state during suspension */
-#define MPATHF_RETAIN_ATTACHED_HW_HANDLER 3	/* If there's already a hw_handler present, don't change it. */
-#define MPATHF_PG_INIT_DISABLED 4		/* pg_init is not currently allowed */
-#define MPATHF_PG_INIT_REQUIRED 5		/* pg_init needs calling? */
-#define MPATHF_PG_INIT_DELAY_RETRY 6		/* Delay pg_init retry? */
+#define MPATHF_PG_INIT_DISABLED 3		/* pg_init is not currently allowed */
+#define MPATHF_PG_INIT_REQUIRED 4		/* pg_init needs calling? */
+#define MPATHF_PG_INIT_DELAY_RETRY 5		/* Delay pg_init retry? */
 
 /*-----------------------------------------------
  * Allocation routines
@@ -240,11 +239,6 @@ static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 	}
 	else if (m->queue_mode == DM_TYPE_BIO_BASED) {
 		INIT_WORK(&m->process_queued_bios, process_queued_bios);
-		/*
-		 * bio-based doesn't support any direct scsi_dh management;
-		 * it just discovers if a scsi_dh is attached.
-		 */
-		set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
 	}
 
 	dm_table_set_type(ti->table, m->queue_mode);
@@ -842,11 +836,8 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
-	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags) || m->hw_handler_name)
+	if (m->hw_handler_name) {
 		q = bdev_get_queue(p->path.dev->bdev);
-
-	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
-retain:
 		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
 			/* clear any hw_handler_params associated with
@@ -871,13 +862,6 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	if (m->hw_handler_name) {
 		r = scsi_dh_attach(q, m->hw_handler_name);
-		if (r == -EBUSY) {
-			char b[BDEVNAME_SIZE];
-
-			printk(KERN_INFO "dm-mpath: retaining handler on device %s\n",
-				bdevname(p->path.dev->bdev, b));
-			goto retain;
-		}
 		if (r < 0) {
 			ti->error = "error attaching hardware handler";
 			dm_put_device(ti, p->path.dev);
@@ -1040,7 +1024,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 8, "invalid number of feature args"},
+		{0, 7, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
 	};
@@ -1061,11 +1045,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
-		if (!strcasecmp(arg_name, "retain_attached_hw_handler")) {
-			set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
-			continue;
-		}
-
 		if (!strcasecmp(arg_name, "pg_init_retries") &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, as, &m->pg_init_retries, &ti->error);
@@ -1745,7 +1724,6 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%u ", test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
-			      test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags) +
 			      (m->queue_mode != DM_TYPE_REQUEST_BASED) * 2);
 
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
@@ -1754,8 +1732,6 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
-		if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags))
-			DMEMIT("retain_attached_hw_handler ");
 		if (m->queue_mode != DM_TYPE_REQUEST_BASED) {
 			switch(m->queue_mode) {
 			case DM_TYPE_BIO_BASED:
-- 
2.8.1.windows.1
