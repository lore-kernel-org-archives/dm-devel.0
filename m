From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 14 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:07:03 -0600
Message-ID: <1162915623.17899.61.camel@hydrogen.msp.redhat.com>
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
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

This patch is not yet finish and should not be pushed upstream in its
current form.  I provide it here so people can look at it and give me
feedback.

 brassow

Index: linux-2.6.18.1/drivers/md/dm-clog-tfr.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.18.1/drivers/md/dm-clog-tfr.c	2006-11-06 17:20:30.000000000 -0600
@@ -0,0 +1,216 @@
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
+#include "dm.h"
+
+/*
+ * Pre-allocated nominal request area for speed
+ */
+#define DM_CLOG_NOMINAL_REQUEST_SIZE 512
+static char nominal_request[DM_CLOG_NOMINAL_REQUEST_SIZE];
+
+static struct sock *nl_sk = NULL;
+static DEFINE_MUTEX(_lock);
+static int users = 0;
+//static int server_pid = 0;
+
+static void nl_data_ready (struct sock *sk, int len)
+{
+        wake_up_interruptible(sk->sk_sleep);
+}
+
+static int find_server_process(void)
+{
+	int r = -ENOSYS;
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh = NULL;
+
+	BUG_ON(!nl_sk);
+
+	skb = alloc_skb(NLMSG_SPACE(0), GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	nlh = (struct nlmsghdr *)skb->data;
+	nlh->nlmsg_len = NLMSG_SPACE(0);
+	nlh->nlmsg_pid = 0;
+	nlh->nlmsg_flags = 0;
+
+/* Not in newer kernels
+	NETLINK_CB(skb).groups = 1;
+	NETLINK_CB(skb).dst_groups = 1;
+*/
+	NETLINK_CB(skb).pid = 0;
+	NETLINK_CB(skb).dst_pid = 0;
+	NETLINK_CB(skb).dst_group = 1;
+
+	netlink_broadcast(nl_sk, skb, 0, 1, GFP_KERNEL);
+
+	/* Get reply to find out server pid */
+	return r;
+}
+
+static int dm_clog_sendto_server(struct clog_tfr *tfr)
+{
+	BUG_ON(!nl_sk);
+	return -ENOSYS;
+}
+
+static int dm_clog_recvfrom_server(char *rdata, int *rdata_size)
+{
+        struct sk_buff *skb = NULL;
+	struct clog_tfr *tfr = NULL;
+	int r;
+
+	BUG_ON(!nl_sk);
+	skb = skb_recv_datagram(nl_sk, 0, 0, &r);
+	if (r)
+		return r;
+
+	tfr = NLMSG_DATA((struct nlmsghdr *)skb->data);
+
+	if (tfr->error) {
+		r = tfr->error;
+	} else if (tfr->data_size > *rdata_size) {
+		r = -ENOSPC;
+	} else {
+		*rdata_size = tfr->data_size;
+		memcpy(rdata, tfr->data, tfr->data_size);
+	}
+
+	return r;
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
+	struct clog_tfr *tfr = (struct clog_tfr *)nominal_request;
+
+	if (data_size > (DM_CLOG_NOMINAL_REQUEST_SIZE - sizeof(*tfr)))
+		/* FIXME: is kmalloc sufficient if we need this much space? */
+		tfr = kmalloc(data_size + sizeof(*tfr), GFP_KERNEL);
+
+	if (!tfr)
+		return -ENOMEM;
+
+	mutex_lock(&_lock);
+
+	memcpy(tfr->uuid, uuid, DM_UUID_LEN);
+	tfr->request_type = request_type;
+	tfr->data_size = data_size;
+
+	r = dm_clog_sendto_server(tfr);
+	if (r < 0) {
+//		DMERR("Unable to send cluster log request to server: %d", r);
+		goto fail;
+	}
+
+	if (rdata) {
+		r = dm_clog_recvfrom_server(rdata, rdata_size);
+
+		if (r < 0)
+			goto fail;
+	} else {
+		/*
+		 * FIXME: If we are using netlink, we may want an
+		 * ack from the server to know that it got the
+		 * request.  (Ack is implicit if we are receiving
+		 * data.)
+		 */
+		r = -ENOSYS;
+	}
+
+fail:
+	if (tfr && (tfr != (struct clog_tfr *)nominal_request))
+		kfree(tfr);
+
+	mutex_unlock(&_lock);
+	return r;
+}
+
+/*
+ * dm_clog_tfr_get
+ *
+ * Set-up or increment reference count on the
+ * netlink used to communicate with the user-space
+ * server.
+ *
+ * Returns: 0 on success, -EXXX on failure
+ */
+int dm_clog_tfr_get(void)
+{
+	int r = 0;
+
+	mutex_lock(&_lock);
+	if (!users) {
+
+		BUG_ON(nl_sk); /* no socket should be present */
+
+		nl_sk = netlink_kernel_create(NETLINK_DMCLOG, 1,
+					      nl_data_ready, THIS_MODULE);
+
+		if (!nl_sk) {
+			r = -ENOMEM;
+			goto fail;
+		}
+
+		r = find_server_process();
+		if (r)
+			goto fail;
+	}
+	users++;
+fail:
+	if (r && nl_sk) {
+		sock_release(nl_sk->sk_socket);
+		nl_sk = NULL;
+	}
+	mutex_unlock(&_lock);
+
+	return r;
+}
+
+/*
+ * dm_clog_tfr_put
+ *
+ * Decrement reference count on the netlink used to
+ * communicate with the user-space server - releasing
+ * the socket if no references remain.
+ *
+ * Returns: 0 on success, -EXXX on failure
+ */
+int dm_clog_tfr_put(void)
+{
+	mutex_lock(&_lock);
+	if (!--users) {
+		sock_release(nl_sk->sk_socket);
+
+		nl_sk = NULL;
+	}
+	mutex_unlock(&_lock);
+
+	return 0;
+}
Index: linux-2.6.18.1/drivers/md/dm-clog.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.18.1/drivers/md/dm-clog.c	2006-11-06 17:20:30.000000000 -0600
@@ -0,0 +1,596 @@
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
+	int r = 0;
+	struct log_c *lc = NULL;
+	uint32_t region_size;
+	region_t region_count;
+
+	/* Already checked argument count */
+
+	/* Check for block_on_error.  It must be present. */
+	if (sscanf(argv[0], "%u", &region_size) != 1) {
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
+	lc->ti = ti;
+	lc->region_size = region_size;
+	lc->region_count = region_count;
+
+	r = dm_clog_tfr_get();
+	if (r)
+		goto fail;
+
+	/* Send table string */
+
+fail:
+	if (lc)
+		kfree(lc);
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
+	int i;
+	if ((argc < 2) || (argc > 3)) {
+		DMERR("Too %s arguments to clustered_core mirror log type.",
+		      (argc < 3) ? "few" : "many");
+		DMERR("  %d arguments supplied:", argc);
+		for (i = 0; i < argc; i++)
+			DMERR("    %s", argv[i]);
+		return -EINVAL;
+	}
+
+	return cluster_ctr(log, ti, argc, argv, 0);
+}
+
+/*
+ * cluster_disk_ctr
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
+		      (argc < 4) ? "few" : "many");
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
+	r = dm_clog_tfr_put();
+
+	kfree(lc);
+
+	return;
+}
+
+/*
+ * cluster_suspend
+ * @log
+ */
+static int cluster_suspend(struct dirty_log *log)
+{
+	int r;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_SUSPEND,
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
+ * cluster_is_remote_recovering
+ * @log
+ * @region
+ *
+ * Check whether a region is being resync'ed on a remote node.
+ * If there is any sort of failure when consulting the server,
+ * we assume that the region is being remotely recovered.
+ *
+ * Returns: 1 if remote recovering, 0 otherwise
+ */
+static int cluster_is_remote_recovering(struct dirty_log *log, region_t region)
+{
+	int r;
+	int is_recovering;
+	int rdata_size;
+	struct log_c *lc = (struct log_c *)log->context;
+
+	rdata_size = sizeof(is_recovering);
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_IS_REMOTE_RECOVERING,
+				   (char *)&region, sizeof(region),
+				   (char *)&is_recovering, &rdata_size);
+
+	return (r) ? 1 : is_recovering;
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
+
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
+	struct list_head flush_list;
+	struct flush_entry *fe, *tmp_fe;
+
+	spin_lock_irqsave(&lc->flush_lock, flags);
+	flush_list = lc->flush_list;
+	spin_unlock_irqrestore(&lc->flush_lock, flags);
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
+	r = dm_clog_consult_server(lc->uuid, DM_CLOG_FLUSH,
+				   NULL, 0, NULL, NULL);
+
+fail:
+	/* FIXME: Can we safely remove these entries if failure? */
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
+	fe = mempool_alloc(flush_entry_pool, GFP_KERNEL);
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
+	fe = mempool_alloc(flush_entry_pool, GFP_ATOMIC);
+	if (!fe) {
+		DMERR("Failed to allocate memory to clear region.");
+		return;
+	}
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
+
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
+		break;
+	case STATUSTYPE_TABLE:
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
+	.suspend = cluster_suspend,
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
+	.is_remote_recovering = cluster_is_remote_recovering,
+};
+
+static struct dirty_log_type _clustered_disk_type = {
+	.name = "clustered_disk",
+	.module = THIS_MODULE,
+	.ctr = cluster_disk_ctr,
+	.dtr = cluster_dtr,
+	.suspend = cluster_suspend,
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
+	.is_remote_recovering = cluster_is_remote_recovering,
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
+	r = dm_register_dirty_log_type(&_clustered_core_type);
+	if (r) {
+		DMWARN("Couldn't register clustered_core dirty log type");
+		mempool_destroy(flush_entry_pool);
+		return r;
+	}
+
+	r = dm_register_dirty_log_type(&_clustered_disk_type);
+	if (r) {
+		DMWARN("Couldn't register clustered_disk dirty log type");
+		dm_unregister_dirty_log_type(&_clustered_core_type);
+		mempool_destroy(flush_entry_pool);
+		return r;
+	}
+
+	return 0;
+}
+
+static void __exit cluster_dirty_log_exit(void)
+{
+	dm_unregister_dirty_log_type(&_clustered_disk_type);
+	dm_unregister_dirty_log_type(&_clustered_core_type);
+	return;
+}
+
+module_init(cluster_dirty_log_init);
+module_exit(cluster_dirty_log_exit);
+
+MODULE_DESCRIPTION(DM_NAME " mirror cluster-aware log");
+MODULE_AUTHOR("Jonathan Brassow");
+MODULE_LICENSE("GPL");
Index: linux-2.6.18.1/drivers/md/Kconfig
===================================================================
--- linux-2.6.18.1.orig/drivers/md/Kconfig	2006-11-06 17:00:23.000000000 -0600
+++ linux-2.6.18.1/drivers/md/Kconfig	2006-11-06 17:20:30.000000000 -0600
@@ -230,6 +230,15 @@ config DM_MIRROR
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
Index: linux-2.6.18.1/drivers/md/Makefile
===================================================================
--- linux-2.6.18.1.orig/drivers/md/Makefile	2006-11-06 17:00:23.000000000 -0600
+++ linux-2.6.18.1/drivers/md/Makefile	2006-11-06 17:20:30.000000000 -0600
@@ -7,6 +7,7 @@ dm-mod-objs	:= dm.o dm-table.o dm-target
 dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-log.o dm-raid1.o
+dm-clulog-objs  := dm-clog.o dm-clog-tfr.o
 md-mod-objs     := md.o bitmap.o
 raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
 		   raid6int1.o raid6int2.o raid6int4.o \
@@ -35,6 +36,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipa
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
+obj-$(CONFIG_DM_CLOG)		+= dm-clulog.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
 quiet_cmd_unroll = UNROLL  $@
Index: linux-2.6.18.1/include/linux/dm-clog-tfr.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.18.1/include/linux/dm-clog-tfr.h	2006-11-06 17:20:30.000000000 -0600
@@ -0,0 +1,50 @@
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
+#define NETLINK_DMCLOG 33
+#endif
+
+#define DM_CLOG_CTR                    1
+#define DM_CLOG_DTR                    2
+#define DM_CLOG_SUSPEND                3
+#define DM_CLOG_RESUME                 4
+#define DM_CLOG_GET_REGION_SIZE        5
+#define DM_CLOG_IS_CLEAN               6
+#define DM_CLOG_IN_SYNC                7
+#define DM_CLOG_FLUSH                  8
+#define DM_CLOG_MARK_REGION            9
+#define DM_CLOG_CLEAR_REGION          10
+#define DM_CLOG_GET_RESYNC_WORK       11
+#define DM_CLOG_SET_REGION_SYNC       12
+#define DM_CLOG_GET_SYNC_COUNT        13
+#define DM_CLOG_STATUS_INFO           14
+#define DM_CLOG_STATUS_TABLE          15
+#define DM_CLOG_IS_REMOTE_RECOVERING  16
+
+#define SIZEOF_CLOG_TFR 1024
+struct clog_tfr {
+	char uuid[DM_UUID_LEN]; /* Ties a request to a specific mirror log */
+	int error;              /* Used by server to inform of errors */
+	int request_type;       /* DM_CLOG_* */
+	int data_size;          /* How much data (not including this struct) */
+	char data[0];
+};
+
+#ifdef __KERNEL__
+int dm_clog_tfr_get(void);
+int dm_clog_tfr_put(void);
+int dm_clog_consult_server(const char *uuid, int request_type,
+			   char *data, int data_size,
+			   char *rdata, int *rdata_size);
+#endif
+
+#endif /* __DM_CLOG_TFR_H__ */
