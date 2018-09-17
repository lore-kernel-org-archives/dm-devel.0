From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] dm-mpath: Fix setup_scsi_dh()
Date: Sun, 16 Sep 2018 20:33:54 -0700
Message-ID: <20180917033354.30745-1-bvanassche@acm.org>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org, dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

This patch fixes two bugs that got introduced recently in setup_scsi_dh():
- Avoid that a memory leak occurs if attached_handler_name is not assigned
  to m->hw_handler_name.
- Avoid that m->hw_handler_name becomes a dangling pointer if the
  RETAIN_ATTACHED_HW_HANDLER flag is set and scsi_dh_attach() returns
  -EBUSY.

Fixes: e8f74a0f0011 ("dm mpath: eliminate need to use scsi_device_from_queue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-mpath.c      | 14 +++++++++-----
 include/scsi/scsi_device.h |  9 +++++++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d94ba6f72ff5..0ba58a537182 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -22,6 +22,7 @@
 #include <linux/time.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_dh.h>
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>
@@ -806,13 +807,15 @@ static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 }
 
 static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
-			 const char *attached_handler_name, char **error)
+			 char **error)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
+	const char *attached_handler_name;
 	int r;
 
 	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
 retain:
+		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
 			/*
 			 * Clear any hw_handler_params associated with a
@@ -867,7 +870,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	struct pgpath *p;
 	struct multipath *m = ti->private;
 	struct request_queue *q;
-	const char *attached_handler_name;
+	struct scsi_device *sdev;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -887,10 +890,11 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	}
 
 	q = bdev_get_queue(p->path.dev->bdev);
-	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
-	if (attached_handler_name || m->hw_handler_name) {
+	sdev = scsi_device_from_queue(q);
+	if (sdev) {
+		put_device(&sdev->sdev_gendev);
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
-		r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
+		r = setup_scsi_dh(p->path.dev->bdev, m, &ti->error);
 		if (r) {
 			dm_put_device(ti, p->path.dev);
 			goto bad;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 202f4d6a4342..1c839089c711 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -2,6 +2,7 @@
 #ifndef _SCSI_SCSI_DEVICE_H
 #define _SCSI_SCSI_DEVICE_H
 
+#include <linux/kconfig.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -335,7 +336,15 @@ extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 
+#if IS_ENABLED(CONFIG_SCSI)
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
+#else
+static inline struct scsi_device *
+scsi_device_from_queue(struct request_queue *q)
+{
+	return NULL;
+}
+#endif
 extern int __must_check scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-- 
2.18.0
