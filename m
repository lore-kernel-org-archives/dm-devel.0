From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] multipath: implement controller framework
	for hardware handlers
Date: Fri, 16 Nov 2007 11:56:50 +0100
Message-ID: <20071116122901.602247336E@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

Some hardware handler have a need to identify the controller
handling the paths, as the controller might only be able to
process one path-switching command in a row.
This patch implements a framework for selecting controllers
and allows for throttling (single-threading) commands to
this controller.
The RDAC hardware handler is converted to use this new
framework.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-hw-handler.c |  182 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-hw-handler.h |   32 ++++++++
 drivers/md/dm-mpath-rdac.c |  172 +++++++++++++++++------------------------
 3 files changed, 281 insertions(+), 105 deletions(-)

diff --git a/drivers/md/dm-hw-handler.c b/drivers/md/dm-hw-handler.c
index 1d02c6a..eff3adb 100644
--- a/drivers/md/dm-hw-handler.c
+++ b/drivers/md/dm-hw-handler.c
@@ -27,6 +27,9 @@ struct hwh_internal {
 static LIST_HEAD(_hw_handlers);
 static DECLARE_RWSEM(_hwh_lock);
 
+static LIST_HEAD(_ctlr_list);
+static DEFINE_SPINLOCK(_ctlr_lock);
+
 static struct hwh_internal *__find_hw_handler_type(const char *name)
 {
 	struct hwh_internal *hwhi;
@@ -177,15 +180,165 @@ int dm_unregister_hw_handler(struct hw_handler_type *hwht)
 	return 0;
 }
 
+/*
+ * Controller framework for hardware handler
+ *
+ * Each hardware handler may define a controller.
+ * A controller is defined to be the entity on the
+ * storage server handling the accessed path
+ * (target port).
+ * Several paths may use the same controller.
+ * Command submission to a controller might be
+ * throttled so that only one request at a time is
+ * submitted to the controller; this will circumvent
+ * command contention when switch-over commands
+ * are being issued simultaneously via different
+ * paths.
+ */
+
+static void _release_hw_controller(struct kref *kref)
+{
+	struct hw_controller *ctlr = container_of(kref, struct hw_controller, kref);
+
+	spin_lock(&_ctlr_lock);
+	list_del(&ctlr->node);
+	spin_unlock(&_ctlr_lock);
+	if (ctlr->type && ctlr->type->destroy)
+		ctlr->type->destroy(ctlr);
+
+	kfree(ctlr);
+}
+
+/*
+ * dm_select_hw_controller
+ *
+ * Select a controller entity by type and ID.
+ * A new controller entity is created if no
+ * matching entity is found. The reference
+ * to the old controller is dropped.
+ */
+int dm_select_hw_controller(struct hw_handler *hwh,
+			    struct hw_controller_type *ctlr_type,
+			    const char *ctlr_id)
+{
+	int retval = 0, ctlr_id_len = strlen(ctlr_id);
+	struct hw_controller *ctlr = NULL, *old_ctlr = NULL;
+
+	spin_lock(&_ctlr_lock);
+
+	list_for_each_entry(ctlr, &_ctlr_list, node) {
+		if ((ctlr_type && ctlr->type == ctlr_type) &&
+		    !strcmp(ctlr->ctlr_id, ctlr_id)) {
+			kref_get(&ctlr->kref);
+			goto done;
+		}
+	}
+	ctlr = kzalloc(sizeof(*ctlr), GFP_NOIO);
+	if (!ctlr) {
+		ctlr = hwh->ctlr;
+		retval = -ENOMEM;
+		goto done;
+	}
+
+	if (ctlr_type && ctlr_type->create) {
+		retval = ctlr_type->create(ctlr);
+		if (retval) {
+			ctlr = hwh->ctlr;
+			goto done;
+		}
+	}
+
+	/* Save old controller instance */
+	old_ctlr = hwh->ctlr;
+
+	strncpy(ctlr->ctlr_id, ctlr_id, ctlr_id_len);
+	ctlr->ctlr_id[ctlr_id_len] = '\0';
+	kref_init(&ctlr->kref);
+	spin_lock_init(&ctlr->lock);
+	ctlr->submitted = 0;
+	ctlr->type = ctlr_type;
+	INIT_LIST_HEAD(&ctlr->cmd_list);
+	list_add(&ctlr->node, &_ctlr_list);
+
+ done:
+	hwh->ctlr = ctlr;
+	spin_unlock(&_ctlr_lock);
+
+	/* Release old controller; might take _ctlr_lock */
+	if (old_ctlr)
+		kref_put(&old_ctlr->kref, _release_hw_controller);
+
+	return retval;
+}
+
+/*
+ * dm_throttle_hw_controller
+ *
+ * Throttle command submission to the controller so
+ * that only once command is active at a time.
+ */
+void dm_throttle_hw_controller(struct hw_handler *hwh)
+{
+	if (hwh->ctlr) {
+		spin_lock(&hwh->ctlr->lock);
+		hwh->ctlr->submitted = 1;
+		spin_unlock(&hwh->ctlr->lock);
+	}
+}
+
+/*
+ * dm_flush_hw_controller
+ *
+ * Unset throttling for the controller and
+ * flush all queued commands.
+ */
+void dm_flush_hw_controller(struct hw_handler *hwh)
+{
+	struct hw_handler_type *hwht = hwh->type;
+	struct hwh_internal *hwhi = container_of(hwht, struct hwh_internal, hwht);
+	struct hw_handler *tmp_hwh;
+	struct hw_controller *ctlr = hwh->ctlr;
+
+	if (ctlr && ctlr->submitted) {
+		spin_lock(&ctlr->lock);
+
+		/* Stop throttling */
+		ctlr->submitted = 0;
+
+		/* Get additional reference to prevent the controller
+		 * from vanishing underneath us */
+		kref_get(&hwh->ctlr->kref);
+
+		list_for_each_entry_safe(hwh, tmp_hwh, &ctlr->cmd_list, entry) {
+			/* Resubmit all queued requests */
+			list_del_init(&hwh->entry);
+			queue_work(hwhi->workq, &hwh->work);
+			/* Drop controller reference */
+			kref_put(&ctlr->kref, _release_hw_controller);
+		}
+		spin_unlock(&ctlr->lock);
+
+		/* Drop additional reference */
+		kref_put(&ctlr->kref, _release_hw_controller);
+	}
+}
+
+/*
+ * Workqueue handling
+ *
+ * Each hardware handler has its own workqueue, which
+ * is used to submit control commands to the target.
+ * When throttling is enabled on a controller, all
+ * requests are being queued internally and issued
+ * one-by-one to the controller.
+ */
 static void dm_service_hw_workq(struct work_struct *work)
 {
 	struct hw_handler *hwh = container_of(work, struct hw_handler, work);
 	struct hw_handler_type *hwht = hwh->type;
-	struct hwh_internal *hwhi = container_of(hwht, struct hwh_internal, hwht);
 
 	if (hwht->workq_fn)
 		hwht->workq_fn(hwh);
-
 }
 
 int dm_create_hw_handler(struct hw_handler *hwh, unsigned int argc,
@@ -200,6 +353,9 @@ int dm_create_hw_handler(struct hw_handler *hwh, unsigned int argc,
 
 	if (hwht->workq_fn) {
 		INIT_WORK(&hwh->work, dm_service_hw_workq);
+		/* Create dummy controller */
+		hwh->ctlr = NULL;
+		dm_select_hw_controller(hwh, NULL, hwht->name);
 	}
 
 	return 0;
@@ -209,6 +365,9 @@ void dm_destroy_hw_handler(struct hw_handler *hwh)
 {
 	struct hw_handler_type *hwht = hwh->type;
 
+	if (hwh->ctlr)
+		kref_put(&hwh->ctlr->kref, _release_hw_controller);
+
 	hwht->destroy(hwh);
 }
 
@@ -221,8 +380,20 @@ void dm_enqueue_hw_workq(struct hw_handler *hwh)
 	if (!hwhi->workq)
 		goto out;
 
-	DMWARN("submit %s request", hwh->type->name);
-	queue_work(hwhi->workq, &hwh->work);
+	if (!hwh->ctlr) {
+		DMWARN("%s: no controller link", hwh->type->name);
+		queue_work(hwhi->workq, &hwh->work);
+		goto out;
+	}
+
+	spin_lock(&hwh->ctlr->lock);
+	kref_get(&hwh->ctlr->kref);
+	if (hwh->ctlr->submitted)
+		list_add(&hwh->entry, &hwh->ctlr->cmd_list);
+	else
+		queue_work(hwhi->workq, &hwh->work);
+
+	spin_unlock(&hwh->ctlr->lock);
 
  out:
 	up_read(&_hwh_lock);
@@ -294,4 +465,7 @@ unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio)
 EXPORT_SYMBOL_GPL(dm_register_hw_handler);
 EXPORT_SYMBOL_GPL(dm_unregister_hw_handler);
 EXPORT_SYMBOL_GPL(dm_enqueue_hw_workq);
+EXPORT_SYMBOL_GPL(dm_select_hw_controller);
+EXPORT_SYMBOL_GPL(dm_throttle_hw_controller);
+EXPORT_SYMBOL_GPL(dm_flush_hw_controller);
 EXPORT_SYMBOL_GPL(dm_scsi_err_handler);
diff --git a/drivers/md/dm-hw-handler.h b/drivers/md/dm-hw-handler.h
index 9216682..6f91b55 100644
--- a/drivers/md/dm-hw-handler.h
+++ b/drivers/md/dm-hw-handler.h
@@ -15,10 +15,31 @@
 
 struct hw_handler_type;
 
+#define CTLR_ID_LEN 256
+
+struct hw_controller {
+	struct list_head node;
+	struct hw_controller_type *type;
+	unsigned char ctlr_id[CTLR_ID_LEN];
+	struct kref kref;
+	spinlock_t lock;
+	struct list_head cmd_list;
+	int submitted;
+	void *context;
+};
+
+struct hw_controller_type {
+	char *name;
+
+	int (*create) (struct hw_controller *ctlr);
+	void (*destroy) (struct hw_controller *ctlr);
+};
+
 struct hw_handler {
 	struct list_head entry;
 	struct hw_handler_type *type;
 	struct mapped_device *md;
+	struct hw_controller *ctlr;
 	struct work_struct work;
 	void *context;
 };
@@ -62,6 +83,17 @@ int dm_create_hw_handler(struct hw_handler *handler, unsigned int argc,
 /* Destroys a hardware handler */
 void dm_destroy_hw_handler(struct hw_handler *handler);
 
+/* Selects a controller instance */
+int dm_select_hw_controller(struct hw_handler *hwh,
+			    struct hw_controller_type *ctlr_type,
+			    const char *ctrl_id);
+
+/* Throttle command submission to the controller */
+void dm_throttle_hw_controller(struct hw_handler *hwh);
+
+/* Flush queued commands to the controller */
+void dm_flush_hw_controller(struct hw_handler *hwh);
+
 /* Enqueue an element to the workqueue */
 void dm_enqueue_hw_workq(struct hw_handler *hwh);
 
diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
index 99f755c..66a5392 100644
--- a/drivers/md/dm-mpath-rdac.c
+++ b/drivers/md/dm-mpath-rdac.c
@@ -131,14 +131,7 @@ struct c4_inquiry {
 };
 
 struct rdac_controller {
-	u8			subsys_id[SUBSYS_ID_LEN];
-	u8			slot_id[SLOT_ID_LEN];
 	int			use_10_ms;
-	struct kref		kref;
-	struct list_head	node; /* list of all controllers */
-	spinlock_t		lock;
-	int			submitted;
-	struct list_head	cmd_list; /* list of commands to be submitted */
 	union			{
 		struct rdac_pg_legacy legacy;
 		struct rdac_pg_expanded expanded;
@@ -177,7 +170,6 @@ struct c2_inquiry {
 
 struct rdac_handler {
 	unsigned		timeout;
-	struct rdac_controller	*ctlr;
 #define UNINITIALIZED_LUN	(1 << 8)
 	unsigned		lun;
 	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
@@ -196,31 +188,41 @@ struct rdac_handler {
 	} inq;
 };
 
-static LIST_HEAD(ctlr_list);
-static DEFINE_SPINLOCK(list_lock);
-
 static inline int had_failures(struct request *req, int error)
 {
 	return (error || host_byte(req->errors) != DID_OK ||
 			msg_byte(req->errors) != COMMAND_COMPLETE);
 }
 
-static void rdac_resubmit_all(struct rdac_controller *ctlr)
+static int rdac_controller_create(struct hw_controller *ctlr)
 {
-	struct rdac_handler *h;
-	struct hw_handler *tmp, *h1;
-
-	spin_lock(&ctlr->lock);
-	list_for_each_entry_safe(h1, tmp, &ctlr->cmd_list, entry) {
-		h = h1->context;
-		h->cmd_to_send = SEND_C9_INQUIRY;
-		dm_enqueue_hw_workq(h1);
-		list_del(&h1->entry);
-	}
-	ctlr->submitted = 0;
-	spin_unlock(&ctlr->lock);
+	struct rdac_controller *rdac_ctlr;
+
+	rdac_ctlr = kzalloc(sizeof(struct rdac_controller),
+				GFP_KERNEL);
+
+	if (!rdac_ctlr)
+		return -ENOMEM;
+
+	rdac_ctlr->use_10_ms = -1;
+	ctlr->context = rdac_ctlr;
+
+	return 0;
+}
+
+static void rdac_controller_destroy(struct hw_controller *ctlr)
+{
+	if (ctlr->context)
+		kfree(ctlr->context);
+	ctlr->context = NULL;
 }
 
+static struct hw_controller_type rdac_controller = {
+	.name = "rdac",
+	.create = rdac_controller_create,
+	.destroy = rdac_controller_destroy,
+};
+
 static void mode_select_endio(struct request *req, int error)
 {
 	struct hw_handler *hwh = req->end_io_data;
@@ -260,7 +262,7 @@ failed:
 		dm_pg_init_complete(h->path, 0);
 
 done:
-	rdac_resubmit_all(h->ctlr);
+	dm_flush_hw_controller(hwh);
 	__blk_put_request(req->q, req);
 }
 
@@ -299,15 +301,16 @@ static struct request *get_rdac_req(struct hw_handler *hwh,
 static struct request *rdac_failover_get(struct hw_handler *hwh)
 {
 	struct rdac_handler *h = hwh->context;
+	struct rdac_controller *ctlr = hwh->ctlr->context;
 	struct request *rq;
 	struct rdac_mode_common *common;
 	unsigned data_size;
 
-	if (h->ctlr->use_10_ms) {
+	if (ctlr->use_10_ms) {
 		struct rdac_pg_expanded *rdac_pg;
 
 		data_size = sizeof(struct rdac_pg_expanded);
-		rdac_pg = &h->ctlr->mode_select.expanded;
+		rdac_pg = &ctlr->mode_select.expanded;
 		memset(rdac_pg, 0, data_size);
 		common = &rdac_pg->common;
 		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER + 0x40;
@@ -319,7 +322,7 @@ static struct request *rdac_failover_get(struct hw_handler *hwh)
 		struct rdac_pg_legacy *rdac_pg;
 
 		data_size = sizeof(struct rdac_pg_legacy);
-		rdac_pg = &h->ctlr->mode_select.legacy;
+		rdac_pg = &ctlr->mode_select.legacy;
 		memset(rdac_pg, 0, data_size);
 		common = &rdac_pg->common;
 		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
@@ -331,14 +334,14 @@ static struct request *rdac_failover_get(struct hw_handler *hwh)
 	common->rdac_options = RDAC_FORCED_QUIESENCE;
 
 	/* get request for block layer packet command */
-	rq = get_rdac_req(hwh, &h->ctlr->mode_select, data_size, WRITE);
+	rq = get_rdac_req(hwh, &ctlr->mode_select, data_size, WRITE);
 	if (!rq) {
 		DMERR("rdac_failover_get: no rq");
 		return NULL;
 	}
 
 	/* Prepare the command. */
-	if (h->ctlr->use_10_ms) {
+	if (ctlr->use_10_ms) {
 		rq->cmd[0] = MODE_SELECT_10;
 		rq->cmd[7] = data_size >> 8;
 		rq->cmd[8] = data_size & 0xff;
@@ -351,19 +354,12 @@ static struct request *rdac_failover_get(struct hw_handler *hwh)
 	return rq;
 }
 
-/* Acquires h->ctlr->lock */
 static void submit_mode_select(struct hw_handler *hwh)
 {
 	struct rdac_handler *h = hwh->context;
 	struct request *rq;
 	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
 
-	spin_lock(&h->ctlr->lock);
-	if (h->ctlr->submitted) {
-		list_add(&hwh->entry, &h->ctlr->cmd_list);
-		goto drop_lock;
-	}
-
 	if (!q) {
 		DMINFO("submit_mode_select: no queue");
 		goto fail_path;
@@ -378,55 +374,10 @@ static void submit_mode_select(struct hw_handler *hwh)
 	DMINFO("submit MODE_SELECT command on %s", h->path->dev->name);
 
 	blk_execute_rq_nowait(q, NULL, rq, 1, mode_select_endio);
-	h->ctlr->submitted = 1;
-	goto drop_lock;
+	dm_throttle_hw_controller(hwh);
+	return;
 fail_path:
 	dm_pg_init_complete(h->path, MP_FAIL_PATH);
-drop_lock:
-	spin_unlock(&h->ctlr->lock);
-}
-
-static void release_ctlr(struct kref *kref)
-{
-	struct rdac_controller *ctlr;
-	ctlr = container_of(kref, struct rdac_controller, kref);
-
-	spin_lock(&list_lock);
-	list_del(&ctlr->node);
-	spin_unlock(&list_lock);
-	kfree(ctlr);
-}
-
-static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id)
-{
-	struct rdac_controller *ctlr, *tmp;
-
-	spin_lock(&list_lock);
-
-	list_for_each_entry(tmp, &ctlr_list, node) {
-		if ((memcmp(tmp->subsys_id, subsys_id, SUBSYS_ID_LEN) == 0) &&
-			  (memcmp(tmp->slot_id, slot_id, SLOT_ID_LEN) == 0)) {
-			kref_get(&tmp->kref);
-			spin_unlock(&list_lock);
-			return tmp;
-		}
-	}
-	ctlr = kmalloc(sizeof(*ctlr), GFP_ATOMIC);
-	if (!ctlr)
-		goto done;
-
-	/* initialize fields of controller */
-	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
-	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
-	kref_init(&ctlr->kref);
-	spin_lock_init(&ctlr->lock);
-	ctlr->submitted = 0;
-	ctlr->use_10_ms = -1;
-	INIT_LIST_HEAD(&ctlr->cmd_list);
-	list_add(&ctlr->node, &ctlr_list);
-done:
-	spin_unlock(&list_lock);
-	return ctlr;
 }
 
 static void c4_endio(struct request *req, int error)
@@ -434,6 +385,7 @@ static void c4_endio(struct request *req, int error)
 	struct hw_handler *hwh = req->end_io_data;
 	struct rdac_handler *h = hwh->context;
 	struct c4_inquiry *sp;
+	char ctlr_id[CTLR_ID_LEN];
 
 	if (had_failures(req, error)) {
 		dm_pg_init_complete(h->path, MP_FAIL_PATH);
@@ -441,14 +393,32 @@ static void c4_endio(struct request *req, int error)
 	}
 
 	sp = &h->inq.c4;
+	memset(ctlr_id, ' ', CTLR_ID_LEN);
+	if (!memcmp(sp->subsys_id, ctlr_id, SUBSYS_ID_LEN)) {
+		strncpy(sp->subsys_id, sp->revision, 4);
+		sp->subsys_id[4] = '\0';
+	}
 
-	h->ctlr = get_controller(sp->subsys_id, sp->slot_id);
-
-	if (h->ctlr) {
-		h->cmd_to_send = SEND_C9_INQUIRY;
-		dm_enqueue_hw_workq(hwh);
-	} else
+	/* If the subsystem ID is empty use the revision */
+	memset(ctlr_id, ' ', CTLR_ID_LEN);
+	if (!memcmp(sp->subsys_id, ctlr_id, SUBSYS_ID_LEN)) {
+		strncpy(sp->subsys_id, sp->revision, 4);
+		sp->subsys_id[4] = '\0';
+	}
+	memset(ctlr_id, 0, CTLR_ID_LEN);
+	strncpy(ctlr_id, sp->subsys_id, SUBSYS_ID_LEN);
+	strcat(ctlr_id,":");
+	strncat(ctlr_id, sp->slot_id, 4);
+
+	if (dm_select_hw_controller(hwh, &rdac_controller, ctlr_id)) {
+		DMINFO("could not select controller on %s",
+		       h->path->dev->name);
 		dm_pg_init_complete(h->path, MP_FAIL_PATH);
+		goto done;
+	}
+	h->cmd_to_send = SEND_C9_INQUIRY;
+	dm_enqueue_hw_workq(hwh);
+
 done:
 	__blk_put_request(req->q, req);
 }
@@ -457,6 +427,7 @@ static void c2_endio(struct request *req, int error)
 {
 	struct hw_handler *hwh = req->end_io_data;
 	struct rdac_handler *h = hwh->context;
+	struct rdac_controller *ctlr = hwh->ctlr->context;
 	struct c2_inquiry *sp;
 
 	if (had_failures(req, error)) {
@@ -468,9 +439,9 @@ static void c2_endio(struct request *req, int error)
 
 	/* If more than MODE6_MAX_LUN luns are supported, use mode select 10 */
 	if (sp->max_lun_supported >= MODE6_MAX_LUN)
-		h->ctlr->use_10_ms = 1;
+		ctlr->use_10_ms = 1;
 	else
-		h->ctlr->use_10_ms = 0;
+		ctlr->use_10_ms = 0;
 
 	h->cmd_to_send = SEND_MODE_SELECT;
 	dm_enqueue_hw_workq(hwh);
@@ -482,6 +453,7 @@ static void c9_endio(struct request *req, int error)
 {
 	struct hw_handler *hwh = req->end_io_data;
 	struct rdac_handler *h = hwh->context;
+	struct rdac_controller *ctlr = hwh->ctlr?hwh->ctlr->context:NULL;
 	struct c9_inquiry *sp;
 
 	if (had_failures(req, error)) {
@@ -502,14 +474,14 @@ static void c9_endio(struct request *req, int error)
 		goto done;
 	}
 
-	/* If the controller on this path owns the LUN, return success */
-	if (sp->avte_cvp & 0x1) {
-		dm_pg_init_complete(h->path, 0);
-		goto done;
-	}
+	if (ctlr) {
+		/* If the controller on this path owns the LUN, return success */
+		if (sp->avte_cvp & 0x1) {
+			dm_pg_init_complete(h->path, 0);
+			goto done;
+		}
 
-	if (h->ctlr) {
-		if (h->ctlr->use_10_ms == -1)
+		if (ctlr->use_10_ms == -1)
 			h->cmd_to_send = SEND_C2_INQUIRY;
 		else
 			h->cmd_to_send = SEND_MODE_SELECT;
@@ -632,8 +604,6 @@ static void rdac_destroy(struct hw_handler *hwh)
 {
 	struct rdac_handler *h = hwh->context;
 
-	if (h->ctlr)
-		kref_put(&h->ctlr->kref, release_ctlr);
 	kfree(h);
 	hwh->context = NULL;
 }
-- 
1.5.3.2


--------------050809070408080500030906--
