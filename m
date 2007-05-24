From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [RFC] dm-raid1-cluster_logging.patch
Date: Thu, 24 May 2007 15:31:10 -0500
Message-ID: <1180038670.25041.29.camel@hydrogen.msp.redhat.com>
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

This patch is still pretty raw.  Outside of general clean-up, the main
area that needs work is the communications piece (dm-clog-tfr.c).  For
some log requests, we need only know that the request was received.  It
would be nice if I could use the ACK field in cn_msg and not have to
wait for a full reply.  There's lots of other work to be done in that
area too.  (Is linux-net the appropriate list for asking questions about
connector?)

Comments welcome,
 brassow

Index: linux-2.6.22-rc1-mm1/drivers/md/dm-clog-tfr.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-clog-tfr.c
@@ -0,0 +1,197 @@
+/*
+ * Copyright (C) 2006 Red Hat, Inc.
+ *
+ * This file is released under the LGPL.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <net/sock.h>
+#include <linux/workqueue.h>
+#include <linux/dm-clog-tfr.h>
+#include <linux/connector.h>
+#include "dm.h"
+#define DM_MSG_PREFIX "mirror cluster log"
+
+#define RQ_TYPE(x) \
+	((x) == DM_CLOG_CTR) ? "DM_CLOG_CTR" : \
+	((x) == DM_CLOG_DTR) ? "DM_CLOG_DTR" : \
+	((x) == DM_CLOG_PRESUSPEND) ? "DM_CLOG_PRESUSPEND" : \
+	((x) == DM_CLOG_POSTSUSPEND) ? "DM_CLOG_POSTSUSPEND" : \
+	((x) == DM_CLOG_RESUME) ? "DM_CLOG_RESUME" : \
+	((x) == DM_CLOG_GET_REGION_SIZE) ? "DM_CLOG_GET_REGION_SIZE" : \
+	((x) == DM_CLOG_IS_CLEAN) ? "DM_CLOG_IS_CLEAN" : \
+	((x) == DM_CLOG_IN_SYNC) ? "DM_CLOG_IN_SYNC" : \
+	((x) == DM_CLOG_FLUSH) ? "DM_CLOG_FLUSH" : \
+	((x) == DM_CLOG_MARK_REGION) ? "DM_CLOG_MARK_REGION" : \
+	((x) == DM_CLOG_CLEAR_REGION) ? "DM_CLOG_CLEAR_REGION" : \
+	((x) == DM_CLOG_GET_RESYNC_WORK) ? "DM_CLOG_GET_RESYNC_WORK" : \
+	((x) == DM_CLOG_SET_REGION_SYNC) ? "DM_CLOG_SET_REGION_SYNC" : \
+	((x) == DM_CLOG_GET_SYNC_COUNT) ? "DM_CLOG_GET_SYNC_COUNT" : \
+	((x) == DM_CLOG_STATUS_INFO) ? "DM_CLOG_STATUS_INFO" : \
+	((x) == DM_CLOG_STATUS_TABLE) ? "DM_CLOG_STATUS_TABLE" : \
+	NULL
+
+/*
+ * Pre-allocated space for speed
+ */
+#define DM_CLOG_PREALLOCED_SIZE 512
+static struct cn_msg *prealloced_cn_msg = NULL;
+static struct clog_tfr *prealloced_clog_tfr = NULL;
+
+static struct cb_id cn_clog_id = { 0x4, 0x1 };
+static DEFINE_MUTEX(_lock);
+static DECLARE_COMPLETION(recv_complete);
+
+struct in_pkg {
+	int data_size;
+	char data[1024];
+};
+
+struct in_pkg recieving;
+
+static int dm_clog_sendto_server(struct clog_tfr *tfr)
+{
+	int r;
+	int size;
+	struct cn_msg *msg = prealloced_cn_msg;
+
+	if (tfr != prealloced_clog_tfr) {
+		size = sizeof(*msg) + sizeof(struct clog_tfr) + tfr->data_size;
+		msg = kmalloc(size, GFP_NOIO);
+		if (!msg)
+			return -ENOMEM;
+		memcpy((msg + 1), tfr, sizeof(struct clog_tfr) + tfr->data_size);
+	}
+
+	memset(msg, 0, sizeof(*msg));
+
+	msg->id.idx = cn_clog_id.idx;
+	msg->id.val = cn_clog_id.val;
+	msg->ack = 0;
+	msg->seq = 0;
+	msg->len = sizeof(struct clog_tfr) + tfr->data_size;
+
+	r = cn_netlink_send(msg, 0, gfp_any());
+	if (msg != prealloced_cn_msg)
+		kfree(msg);
+
+	return r;
+}
+
+static void cn_clog_callback(void *data)
+{
+	struct cn_msg *msg = (struct cn_msg *)data;
+
+	memcpy(recieving.data, msg->data, msg->len);
+	recieving.data_size = msg->len;
+	complete(&recv_complete);
+}
+
+static int dm_clog_recvfrom_server(char *rdata, int *rdata_size)
+{
+	int r;
+	struct clog_tfr *tfr;
+
+	r = wait_for_completion_timeout(&recv_complete, 20*HZ);
+	if (!r)
+		return -ETIMEDOUT;
+
+	tfr = (struct clog_tfr *)recieving.data;
+	if (tfr->error) {
+		DMERR("  tfr->request_type = %s", RQ_TYPE(tfr->request_type));
+		DMERR("  tfr->data_size    = %d", tfr->data_size);
+		DMERR("  tfr->error        = %d", tfr->error);
+	} else if (rdata) {
+		if (*rdata_size < tfr->data_size)
+			return -ENOSPC;
+		memcpy(rdata, tfr->data, tfr->data_size);
+		*rdata_size = tfr->data_size;
+	}
+
+	return tfr->error;
+}
+
+/*
+ * dm_clog_consult_server
+ * @uuid: log's uuid (must be DM_UUID_LEN in size)
+ * @request_type:
+ * @data: data to tx to the server
+ * @data_size: size of data in bytes
+ * @rdata: place to put return data from server
+ * @rdata_size: value-result (amount of space given/amount of space used)
+ *
+ * Only one process at a time can communicate with the server.
+ * rdata_size is undefined on failure.
+ *
+ * Returns: 0 on success, -EXXX on failure
+ */
+int dm_clog_consult_server(const char *uuid, int request_type,
+			   char *data, int data_size,
+			   char *rdata, int *rdata_size)
+{
+	int r = 0;
+	int overhead_size = sizeof(struct clog_tfr *) + sizeof(struct cn_msg);
+	struct clog_tfr *tfr = prealloced_clog_tfr;
+
+	if (data_size > (DM_CLOG_PREALLOCED_SIZE - overhead_size)) {
+		DMINFO("Size of tfr exceeds preallocated size");
+		/* FIXME: is kmalloc sufficient if we need this much space? */
+		tfr = kmalloc(data_size + sizeof(*tfr), GFP_NOIO);
+	}
+
+	if (!tfr)
+		return -ENOMEM;
+
+	mutex_lock(&_lock);
+
+	memset(tfr, 0, data_size + sizeof(*tfr));
+	memcpy(tfr->uuid, uuid, DM_UUID_LEN);
+	tfr->request_type = request_type;
+	tfr->data_size = data_size;
+	if (data && data_size)
+		memcpy(tfr->data, data, data_size);
+
+	r = dm_clog_sendto_server(tfr);
+	if (r)
+		DMERR("Unable to send cluster log request to server: %d", r);
+	else
+		r = dm_clog_recvfrom_server(rdata, rdata_size);
+
+	if (tfr != (struct clog_tfr *)prealloced_clog_tfr)
+		kfree(tfr);
+
+	mutex_unlock(&_lock);
+
+	if (r)
+		DMERR("dm_clog_consult_server failed: %d", r);
+
+	return r;
+}
+
+int dm_clog_tfr_init(void)
+{
+	int r;
+	void *prealloced;
+
+	prealloced = kmalloc(DM_CLOG_PREALLOCED_SIZE, GFP_KERNEL);
+	if (!prealloced)
+		return -ENOMEM;
+
+	prealloced_cn_msg = prealloced;
+	prealloced_clog_tfr = prealloced + sizeof(struct cn_msg);
+
+	r = cn_add_callback(&cn_clog_id, "clulog", cn_clog_callback);
+	if (r) {
+		cn_del_callback(&cn_clog_id);
+		return r;
+	}
+
+	return 0;
+}
+
+void dm_clog_tfr_exit(void)
+{
+	cn_del_callback(&cn_clog_id);
+	kfree(prealloced_cn_msg);
+}
Index: linux-2.6.22-rc1-mm1/drivers/md/dm-clog.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-clog.c
@@ -0,0 +1,658 @@
+/*
+ * Copyright (C) 2006 Red Hat, Inc.
+ *
+ * This file is released under the LGPL.
+ */
+
+#include "dm.h"
+#include "dm-log.h"
+#include <linux/dm-clog-tfr.h>
+
+#define DM_MSG_PREFIX "mirror cluster log"
+
+struct flush_entry {
+	int type;
+	region_t region;
+	struct list_head list;
+};
+
+struct log_c {
+	struct dm_target *ti;
+	uint32_t region_size;
+	region_t region_count;
+	char uuid[DM_UUID_LEN];
+
+	spinlock_t flush_lock;
+	struct list_head flush_list;  /* only for clear and mark requests */
+};
+
+static mempool_t *flush_entry_pool = NULL;
+
+static void *flush_entry_alloc(gfp_t gfp_mask, void *pool_data)
+{
+	return kmalloc(sizeof(struct flush_entry), gfp_mask);
+}
+
+static void flush_entry_free(void *element, void *pool_data)
+{
+	kfree(element);
+}
+
+static int cluster_ctr(struct dirty_log *log, struct dm_target *ti,
+		       unsigned int argc, char **argv, int disk_log)
+{
+	int i;
+	int r = 0;
+	int str_size;
+	char *ctr_str = NULL;
+	struct log_c *lc = NULL;
+	uint32_t region_size;
+	region_t region_count;
+
+	/* Already checked argument count */
+	if (disk_log != 0 && disk_log != 1)
+		return -EINVAL;
+
+	if (sscanf(argv[disk_log], "%u", &region_size) != 1) {
+		DMWARN("Invalid region size string");
+		return -EINVAL;
+	}
+
+	region_count = dm_sector_div_up(ti->len, region_size);
+
+	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
+	if (!lc) {
+		DMWARN("Unable to allocate cluster log context.");
+		return -ENOMEM;
+	}
+
+	lc->ti = ti;
+	lc->region_size = region_size;
+	lc->region_count = region_count;
+
+	/* FIXME: Need to check size of uuid arg */
+	memcpy(lc->uuid, argv[1 + disk_log], DM_UUID_LEN);
+	spin_lock_init(&lc->flush_lock);
+	INIT_LIST_HEAD(&lc->flush_list);
+
+	for (i = 0, str_size = 0; i < argc; i++)
+		str_size = strlen(argv[i]) + 1; /* +1 for space between args */
+
+	str_size += 20; /* Max number of chars in a printed u64 number */
+
+	ctr_str = kmalloc(str_size, GFP_KERNEL);
+	if (!ctr_str) {
+		DMWARN("Unable to allocate memory for constructor string");
+		kfree(lc);
+		return -ENOMEM;
+	}
+
+	for (i = 0, str_size = 0; i < argc; i++)
+		str_size += sprintf(ctr_str + str_size, "%s ", argv[i]);
+	str_size += sprintf(ctr_str + str_size, "%llu", ti->len);
+
+	/* Send table string */
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_CTR,
+				   ctr_str, str_size, NULL, NULL);
+
+	if (r == -ESRCH)
+		DMERR(" Userspace cluster log server not found");
+
+	log->context = lc;
+
+	if (r && lc)
+		kfree(lc);
+	if (ctr_str)
+		kfree(ctr_str);
+
+	return r;
+}
+
+/*
+ * cluster_core_ctr
+ * @log
+ * @ti
+ * @argc
+ * @argv
+ *
+ * argv contains:
+ *   <region_size> <uuid> [[no]sync]
+ *
+ * Returns: 0 on success, -XXX on failure
+ */
+static int cluster_core_ctr(struct dirty_log *log, struct dm_target *ti,
+			    unsigned int argc, char **argv)
+{
+	int i, r;
+	if ((argc < 2) || (argc > 3)) {
+		DMERR("Too %s arguments to clustered_core mirror log type.",
+		      (argc < 2) ? "few" : "many");
+		DMERR("  %d arguments supplied:", argc);
+		for (i = 0; i < argc; i++)
+			DMERR("    %s", argv[i]);
+		return -EINVAL;
+	}
+
+	r = cluster_ctr(log, ti, argc, argv, 0);
+
+	return r;
+}
+
+
+/*
+ * cluster_core_ctr
+ * @log
+ * @ti
+ * @argc
+ * @argv
+ *
+ * argv contains:
+ *   <disk> <region_size> <uuid> [[no]sync]
+ *
+ * Returns: 0 on success, -XXX on failure
+ */
+static int cluster_disk_ctr(struct dirty_log *log, struct dm_target *ti,
+			    unsigned int argc, char **argv)
+{
+	int i;
+	if ((argc < 3) || (argc > 4)) {
+		DMERR("Too %s arguments to clustered_disk mirror log type.",
+		      (argc < 3) ? "few" : "many");
+		DMERR("  %d arguments supplied:", argc);
+		for (i = 0; i < argc; i++)
+			DMERR("    %s", argv[i]);
+		return -EINVAL;
+	}
+
+	return cluster_ctr(log, ti, argc, argv, 1);
+}
+
+/*
+ * cluster_dtr
+ * @log
+ */
+static void cluster_dtr(struct dirty_log *log)
+{
+	int r;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_DTR,
+				   NULL, 0,
+				   NULL, NULL);
+
+	/* FIXME: What do we do on failure? */
+
+	kfree(lc);
+
+	return;
+}
+
+/*
+ * cluster_presuspend
+ * @log
+ */
+static int cluster_presuspend(struct dirty_log *log)
+{
+	int r;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_PRESUSPEND,
+				   NULL, 0,
+				   NULL, NULL);
+
+	return r;
+}
+
+/*
+ * cluster_postsuspend
+ * @log
+ */
+static int cluster_postsuspend(struct dirty_log *log)
+{
+	int r;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_POSTSUSPEND,
+				   NULL, 0,
+				   NULL, NULL);
+
+	return r;
+}
+
+/*
+ * cluster_resume
+ * @log
+ */
+static int cluster_resume(struct dirty_log *log)
+{
+	int r;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_RESUME,
+				   NULL, 0,
+				   NULL, NULL);
+
+	return r;
+}
+
+/*
+ * cluster_get_region_size
+ * @log
+ *
+ * Only called during mirror construction, ok to block.
+ *
+ * Returns: region size (doesn't fail)
+ */
+static uint32_t cluster_get_region_size(struct dirty_log *log)
+{
+	struct log_c *lc = (struct log_c *)log->context;
+
+	return lc->region_size;
+}
+
+/*
+ * cluster_is_clean
+ * @log
+ * @region
+ *
+ * Check whether a region is clean.  If there is any sort of
+ * failure when consulting the server, we return not clean.
+ *
+ * Returns: 1 if clean, 0 otherwise
+ */
+static int cluster_is_clean(struct dirty_log *log, region_t region)
+{
+	int r;
+	int is_clean;
+	int rdata_size;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	rdata_size = sizeof(is_clean);
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_IS_CLEAN,
+				   (char *)&region, sizeof(region),
+				   (char *)&is_clean, &rdata_size);
+
+	return (r) ? 0 : is_clean;
+}
+
+/*
+ * cluster_in_sync
+ * @log
+ * @region
+ * @can_block: if set, return immediately
+ *
+ * Check if the region is in-sync.  If there is any sort
+ * of failure when consulting the server, we assume that
+ * the region is not in sync.
+ *
+ * Returns: 1 if in-sync, 0 if not-in-sync, -EWOULDBLOCK
+ */
+static int cluster_in_sync(struct dirty_log *log, region_t region, int can_block)
+{
+	int r;
+	int in_sync;
+	int rdata_size;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	if (!can_block)
+		return -EWOULDBLOCK;
+
+	rdata_size = sizeof(in_sync);
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_IN_SYNC,
+				   (char *)&region, sizeof(region),
+				   (char *)&in_sync, &rdata_size);
+	return (r) ? 0 : in_sync;
+}
+
+/*
+ * cluster_flush
+ * @log
+ *
+ * This function is ok to block.
+ * The flush happens in two stages.  First, it sends all
+ * clear/mark requests that are on the list.  Then it
+ * tells the server to commit them.  This gives the
+ * server a chance to optimise the commit to the cluster
+ * and/or disk, instead of doing it for every request.
+ *
+ * Additionally, we could implement another thread that
+ * sends the requests up to the server - reducing the
+ * load on flush.  Then the flush would have less in
+ * the list and be responsible for the finishing commit.
+ *
+ * Returns: 0 on success, < 0 on failure
+ */
+static int cluster_flush(struct dirty_log *log)
+{
+	int r = 0;
+	int flags;
+	struct log_c *lc = (struct log_c *)log->context;
+	LIST_HEAD(flush_list);
+	struct flush_entry *fe, *tmp_fe;
+
+	spin_lock_irqsave(&lc->flush_lock, flags);
+	list_splice_init(&lc->flush_list, &flush_list);
+	spin_unlock_irqrestore(&lc->flush_lock, flags);
+
+	if (list_empty(&flush_list))
+		return 0;
+
+	/*
+	 * FIXME: Count up requests, group request types,
+	 * allocate memory to stick all requests in and
+	 * send to server in one go.  Failing the allocation,
+	 * do it one by one.
+	 */
+
+	list_for_each_entry(fe, &flush_list, list) {
+		r = dm_clog_consult_server(lc->uuid, fe->type,
+					   (char *)&fe->region,
+					   sizeof(fe->region),
+					   NULL, NULL);
+		if (r)
+			goto fail;
+	}
+
+	do {
+		r = dm_clog_consult_server(lc->uuid, DM_CLOG_FLUSH,
+					   NULL, 0, NULL, NULL);
+		if (r != -EAGAIN)
+			break;
+
+		DMINFO("Flush conflicts with recovery [delaying]");
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ/4);
+	} while (1);
+
+fail:
+	/*
+	 * We can safely remove these entries, even if failure.
+	 * Calling code will recieve an error and will know that
+	 * the log facility has failed.
+	 */
+	list_for_each_entry_safe(fe, tmp_fe, &flush_list, list) {
+		list_del(&fe->list);
+		mempool_free(fe, flush_entry_pool);
+	}
+
+	return r;
+}
+
+/*
+ * cluster_mark_region
+ * @log
+ * @region
+ *
+ * This function should avoid blocking unless absolutely required.
+ * (Memory allocation is valid for blocking.)
+ */
+static void cluster_mark_region(struct dirty_log *log, region_t region)
+{
+	int flags;
+	struct log_c *lc = (struct log_c *)log->context;
+	struct flush_entry *fe;
+
+	/* Wait for an allocation, but _never_ fail */
+	fe = mempool_alloc(flush_entry_pool, GFP_NOIO);
+	BUG_ON(!fe);
+
+	spin_lock_irqsave(&lc->flush_lock, flags);
+	fe->type = DM_CLOG_MARK_REGION;
+	fe->region = region;
+	list_add(&fe->list, &lc->flush_list);
+	spin_unlock_irqrestore(&lc->flush_lock, flags);
+
+	return;
+}
+
+/*
+ * cluster_clear_region
+ * @log
+ * @region
+ *
+ * This function must not block.
+ * So, the alloc can't block.  In the worst case, it is ok to
+ * fail.  It would simply mean we can't clear the region.
+ * Does nothing to current sync context, but does mean
+ * the region will be re-sync'ed on a reload of the mirror
+ * even though it is in-sync.
+ */
+static void cluster_clear_region(struct dirty_log *log, region_t region)
+{
+	int flags;
+	struct log_c *lc = (struct log_c *)log->context;
+	struct flush_entry *fe;
+
+	/*
+	 * If we fail to allocate, we skip the clearing of
+	 * the region.  This doesn't hurt us in any way, except
+	 * to cause the region to be resync'ed when the
+	 * device is activated next time.
+	 */
+	fe = mempool_alloc(flush_entry_pool, GFP_ATOMIC);
+	if (!fe) {
+		DMERR("Failed to allocate memory to clear region.");
+		return;
+	}
+
+	spin_lock_irqsave(&lc->flush_lock, flags);
+	fe->type = DM_CLOG_CLEAR_REGION;
+	fe->region = region;
+	list_add(&fe->list, &lc->flush_list);
+	spin_unlock_irqrestore(&lc->flush_lock, flags);
+
+	return;
+}
+
+/*
+ * cluster_get_resync_work
+ * @log
+ * @region
+ *
+ * Get a region that needs recovery.  It is valid to return
+ * an error for this function.
+ *
+ * Returns: 1 if region filled, 0 if no work, <0 on error
+ */
+static int cluster_get_resync_work(struct dirty_log *log, region_t *region)
+{
+	int r;
+	int rdata_size;
+	struct log_c *lc = (struct log_c *)log->context;
+	struct { int i; region_t r; } pkg;
+
+	rdata_size = sizeof(pkg);
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_GET_RESYNC_WORK,
+				   NULL, 0,
+				   (char *)&pkg, &rdata_size);
+
+	*region = pkg.r;
+	return (r) ? r : pkg.i;
+}
+
+/*
+ * cluster_set_region_sync
+ * @log
+ * @region
+ * @in_sync
+ *
+ * Set the sync status of a given region.  This function
+ * must not fail.
+ */
+static void cluster_set_region_sync(struct dirty_log *log,
+				    region_t region, int in_sync)
+{
+	int r;
+	struct log_c *lc = (struct log_c *)log->context;
+	struct { region_t r; int i; } pkg;
+
+	pkg.r = region;
+	pkg.i = in_sync;
+
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_SET_REGION_SYNC,
+				   (char *)&pkg, sizeof(pkg),
+				   NULL, NULL);
+
+	/* FIXME: It would be nice to be able to report failures */
+	return;
+}
+
+/*
+ * cluster_get_sync_count
+ * @log
+ *
+ * If there is any sort of failure when consulting the server,
+ * we assume that the sync count is zero.
+ *
+ * Returns: sync count on success, 0 on failure
+ */
+static region_t cluster_get_sync_count(struct dirty_log *log)
+{
+	int r;
+	int rdata_size;
+	region_t sync_count;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	rdata_size = sizeof(sync_count);
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_GET_SYNC_COUNT,
+				   NULL, 0,
+				   (char *)&sync_count, &rdata_size);
+
+	return (r) ? 0 : sync_count;
+}
+
+/*
+ * cluster_status
+ * @log
+ * @status_type
+ * @result
+ * @maxlen
+ *
+ * Returns: amount of space consumed
+ */
+static int cluster_status(struct dirty_log *log, status_type_t status_type,
+			  char *result, unsigned int maxlen)
+{
+	int r = 0;
+	unsigned int sz = maxlen;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	switch(status_type) {
+	case STATUSTYPE_INFO:
+		r = dm_clog_consult_server(lc->uuid, DM_CLOG_STATUS_INFO,
+					   NULL, 0,
+					   result, &sz);
+		/*
+		 * FIXME: If we fail to contact server, we should still
+		 * populate this with parsible results
+		 */
+		break;
+	case STATUSTYPE_TABLE:
+		/*
+		 * FIXME: We probably have enough info to
+		 * forgo contact with the server
+		 */
+		r = dm_clog_consult_server(lc->uuid, DM_CLOG_STATUS_TABLE,
+					   NULL, 0,
+					   result, &sz);
+		break;
+	}
+	return (r) ? 0: sz;
+}
+
+static struct dirty_log_type _clustered_core_type = {
+	.name = "clustered_core",
+	.module = THIS_MODULE,
+	.ctr = cluster_core_ctr,
+	.dtr = cluster_dtr,
+	.presuspend = cluster_presuspend,
+	.postsuspend = cluster_postsuspend,
+	.resume = cluster_resume,
+	.get_region_size = cluster_get_region_size,
+	.is_clean = cluster_is_clean,
+	.in_sync = cluster_in_sync,
+	.flush = cluster_flush,
+	.mark_region = cluster_mark_region,
+	.clear_region = cluster_clear_region,
+	.get_resync_work = cluster_get_resync_work,
+	.set_region_sync = cluster_set_region_sync,
+	.get_sync_count = cluster_get_sync_count,
+	.status = cluster_status,
+};
+
+static struct dirty_log_type _clustered_disk_type = {
+	.name = "clustered_disk",
+	.module = THIS_MODULE,
+	.ctr = cluster_disk_ctr,
+	.dtr = cluster_dtr,
+	.presuspend = cluster_presuspend,
+	.postsuspend = cluster_postsuspend,
+	.resume = cluster_resume,
+	.get_region_size = cluster_get_region_size,
+	.is_clean = cluster_is_clean,
+	.in_sync = cluster_in_sync,
+	.flush = cluster_flush,
+	.mark_region = cluster_mark_region,
+	.clear_region = cluster_clear_region,
+	.get_resync_work = cluster_get_resync_work,
+	.set_region_sync = cluster_set_region_sync,
+	.get_sync_count = cluster_get_sync_count,
+	.status = cluster_status,
+};
+
+static int __init cluster_dirty_log_init(void)
+{
+	int r = 0;
+
+	flush_entry_pool = mempool_create(100, flush_entry_alloc,
+					  flush_entry_free, NULL);
+
+	if (!flush_entry_pool) {
+		DMWARN("Unable to create flush_entry_pool:  No memory.");
+		return -ENOMEM;
+	}
+
+	r = dm_clog_tfr_init();
+	if (r) {
+		DMWARN("Unable to initialize cluster log communications");
+		mempool_destroy(flush_entry_pool);
+		return r;
+	}
+
+	r = dm_register_dirty_log_type(&_clustered_core_type);
+	if (r) {
+		DMWARN("Couldn't register clustered_core dirty log type");
+		dm_clog_tfr_exit();
+		mempool_destroy(flush_entry_pool);
+		return r;
+	}
+
+	r = dm_register_dirty_log_type(&_clustered_disk_type);
+	if (r) {
+		DMWARN("Couldn't register clustered_disk dirty log type");
+		dm_unregister_dirty_log_type(&_clustered_core_type);
+		dm_clog_tfr_exit();
+		mempool_destroy(flush_entry_pool);
+		return r;
+	}
+
+	DMINFO("dm-clulog (built %s %s) installed", __DATE__, __TIME__);
+	return 0;
+}
+
+static void __exit cluster_dirty_log_exit(void)
+{
+	dm_unregister_dirty_log_type(&_clustered_disk_type);
+	dm_unregister_dirty_log_type(&_clustered_core_type);
+	dm_clog_tfr_exit();
+	mempool_destroy(flush_entry_pool);
+	DMINFO("dm-clulog (built %s %s) removed", __DATE__, __TIME__);
+	return;
+}
+
+module_init(cluster_dirty_log_init);
+module_exit(cluster_dirty_log_exit);
+
+MODULE_DESCRIPTION(DM_NAME " mirror cluster-aware log");
+MODULE_AUTHOR("Jonathan Brassow");
+MODULE_LICENSE("GPL");
Index: linux-2.6.22-rc1-mm1/drivers/md/Kconfig
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/Kconfig
+++ linux-2.6.22-rc1-mm1/drivers/md/Kconfig
@@ -241,6 +241,15 @@ config DM_MIRROR
          Allow volume managers to mirror logical volumes, also
          needed for live data migration tools such as 'pvmove'.
 
+config DM_CLOG
+	tristate "Mirror cluster logging (EXPERIMENTAL)"
+	depends on DM_MIRROR && EXPERIMENTAL
+	---help---
+	Cluster logging allows mirroring to become cluster-aware.
+	Mirror devices can be used by multiple machines at the
+	same time.  Note: this will not make your applications
+	cluster-aware.
+
 config DM_ZERO
 	tristate "Zero target (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
Index: linux-2.6.22-rc1-mm1/drivers/md/Makefile
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/Makefile
+++ linux-2.6.22-rc1-mm1/drivers/md/Makefile
@@ -7,6 +7,7 @@ dm-mod-objs	:= dm.o dm-table.o dm-target
 dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-log.o dm-raid1.o
+dm-clulog-objs  := dm-clog.o dm-clog-tfr.o
 md-mod-objs     := md.o bitmap.o
 raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
 		   raid6int1.o raid6int2.o raid6int4.o \
@@ -36,6 +37,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipa
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
+obj-$(CONFIG_DM_CLOG)		+= dm-clulog.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
 quiet_cmd_unroll = UNROLL  $@
Index: linux-2.6.22-rc1-mm1/include/linux/dm-clog-tfr.h
===================================================================
--- /dev/null
+++ linux-2.6.22-rc1-mm1/include/linux/dm-clog-tfr.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2006 Red Hat, Inc.
+ *
+ * This file is released under the LGPL.
+ */
+
+#ifndef __DM_CLOG_TFR_H__
+#define __DM_CLOG_TFR_H__
+
+#include <linux/dm-ioctl.h> /* For DM_UUID_LEN */
+
+#ifndef NETLINK_DMCLOG
+#define NETLINK_DMCLOG 30
+#endif
+
+#define DM_CLOG_TFR_SIZE 1024
+
+#define DM_CLOG_CTR                    1
+#define DM_CLOG_DTR                    2
+#define DM_CLOG_PRESUSPEND             3
+#define DM_CLOG_POSTSUSPEND            4
+#define DM_CLOG_RESUME                 5
+#define DM_CLOG_GET_REGION_SIZE        6
+#define DM_CLOG_IS_CLEAN               7
+#define DM_CLOG_IN_SYNC                8
+#define DM_CLOG_FLUSH                  9
+#define DM_CLOG_MARK_REGION           10
+#define DM_CLOG_CLEAR_REGION          11
+#define DM_CLOG_GET_RESYNC_WORK       12
+#define DM_CLOG_SET_REGION_SYNC       13
+#define DM_CLOG_GET_SYNC_COUNT        14
+#define DM_CLOG_STATUS_INFO           15
+#define DM_CLOG_STATUS_TABLE          16
+
+struct clog_tfr {
+	uint64_t private[2];
+	char uuid[DM_UUID_LEN]; /* Ties a request to a specific mirror log */
+
+	int error;              /* Used by server to inform of errors */
+	uint32_t originator;    /* Cluster ID of this machine */
+
+	uint32_t request_type;  /* DM_CLOG_* */
+	uint32_t data_size;     /* How much data (not including this struct) */
+	char data[0];
+};
+
+#ifdef __KERNEL__
+int dm_clog_tfr_init(void);
+void dm_clog_tfr_exit(void);
+int dm_clog_consult_server(const char *uuid, int request_type,
+			   char *data, int data_size,
+			   char *rdata, int *rdata_size);
+#endif
+
+#endif /* __DM_CLOG_TFR_H__ */
