From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Updated cluster log patch (take 8)
Date: Fri, 19 Jun 2009 13:29:36 -0500
Message-ID: <1245436176.2314.5.camel@hydrogen.msp.redhat.com>
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
Cc: randy.dunlap@oracle.com, agk@redhat.com
List-Id: dm-devel.ids

Thanks to Randy Dunlap for spotting a potential problem in Kconfig.
https://www.redhat.com/archives/dm-devel/2009-June/msg00203.html

agk, I don't know if you just want to pull Randy's patch on top, or take
this one where I've rolled it in.

 brassow

From: Jonthan Brassow <jbrassow@redhat.com>

This patch contains a device-mapper mirror log module that forwards
requests to userspace for processing.

The structures used for communication between kernel and userspace are
located in include/linux/dm-log-userspace.h.  Due to the frequency,
diversity, and 2-way communication nature of the exchanges between
kernel and userspace, 'connector' was chosen as the interface for
communication.  

The first log implementations written in userspace - "clustered-disk"
and "clustered-core" - support clustered shared storage.   A userspace
daemon (in the LVM2 source code repository) uses openAIS/corosync to
process requests in an ordered fashion with the rest of the nodes in the
cluster so as to prevent log state corruption.  Other implementations 
with no association to LVM or openAIS/corosync, are certainly possible.

(Imagine if two machines are writing to the same region of a mirror.
They would both mark the region dirty, but you need a cluster-aware
entity that can handle properly marking the region clean when they are
done.  Otherwise, you might clear the region when the first machine is
done, not the second.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

Index: linux-2.6/Documentation/device-mapper/dm-log.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/device-mapper/dm-log.txt
@@ -0,0 +1,54 @@
+Device-Mapper Logging
+=====================
+The device-mapper logging code is used by some of the device-mapper
+RAID targets to track regions of the disk that are not consistent.
+A region (or portion of the address space) of the disk may be
+inconsistent because a RAID stripe is currently being operated on or
+a machine died while the region was being altered.  In the case of
+mirrors, a region would be considered dirty/inconsistent while you
+are writing to it because the writes need to be replicated for all
+the legs of the mirror and may not reach the legs at the same time.
+Once all writes are complete, the region is considered clean again.
+
+There is a generic logging interface that the device-mapper RAID
+implementations use to perform logging operations (see
+dm_dirty_log_type in include/linux/dm-dirty-log.h).  Various different
+logging implementations are available and provide different
+capabilities.  The list includes:
+
+Type		Files
+====		=====
+disk		drivers/md/dm-log.c
+core		drivers/md/dm-log.c
+userspace	drivers/md/dm-log-userspace* include/linux/dm-log-userspace.h
+
+The "disk" log type
+-------------------
+This log implementation commits the log state to disk.  This way, the
+logging state survives reboots/crashes.
+
+The "core" log type
+-------------------
+This log implementation keeps the log state in memory.  The log state
+will not survive a reboot or crash, but there may be a small boost in
+performance.  This method can also be used if no storage device is
+available for storing log state.
+
+The "userspace" log type
+------------------------
+This log type simply provides a way to export the log API to userspace,
+so log implementations can be done there.  This is done by forwarding most
+logging requests to userspace, where a daemon receives and processes the
+request.
+
+The structure used for communication between kernel and userspace are
+located in include/linux/dm-log-userspace.h.  Due to the frequency,
+diversity, and 2-way communication nature of the exchanges between
+kernel and userspace, 'connector' is used as the interface for
+communication.
+
+There are currently two userspace log implementations that leverage this
+framework - "clustered_disk" and "clustered_core".  These implementations
+provide a cluster-coherent log for shared-storage.  Device-mapper mirroring
+can be used in a shared-storage environment when the cluster log implementations
+are employed.
Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -231,6 +231,17 @@ config DM_MIRROR
          Allow volume managers to mirror logical volumes, also
          needed for live data migration tools such as 'pvmove'.
 
+config DM_LOG_USERSPACE
+	tristate "Mirror userspace logging (EXPERIMENTAL)"
+	depends on DM_MIRROR && EXPERIMENTAL && NET
+	select CONNECTOR
+	---help---
+	  The userspace logging module provides a mechanism for
+	  relaying the dm-dirty-log API to userspace.  Log designs
+	  which are more suited to userspace implementation (e.g.
+	  shared storage logs) or experimental logs can be implemented
+	  by leveraging this framework.
+
 config DM_ZERO
 	tristate "Zero target"
 	depends on BLK_DEV_DM
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -8,6 +8,8 @@ dm-multipath-y	+= dm-path-selector.o dm-
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
 dm-mirror-y	+= dm-raid1.o
+dm-log-userspace-y \
+		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
 raid6_pq-y	+= raid6algos.o raid6recov.o raid6tables.o \
@@ -38,6 +40,7 @@ obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
+obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
 quiet_cmd_unroll = UNROLL  $@
Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -0,0 +1,696 @@
+/*
+ * Copyright (C) 2006-2009 Red Hat, Inc.
+ *
+ * This file is released under the LGPL.
+ */
+
+#include <linux/bio.h>
+#include <linux/dm-dirty-log.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-log-userspace.h>
+
+#include "dm-log-userspace-transfer.h"
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
+	char *usr_argv_str;
+	uint32_t usr_argc;
+
+	/*
+	 * in_sync_hint gets set when doing is_remote_recovering.  It
+	 * represents the first region that needs recovery.  IOW, the
+	 * first zero bit of sync_bits.  This can be useful for to limit
+	 * traffic for calls like is_remote_recovering and get_resync_work,
+	 * but be take care in its use for anything else.
+	 */
+	uint64_t in_sync_hint;
+
+	spinlock_t flush_lock;
+	struct list_head flush_list;  /* only for clear and mark requests */
+};
+
+static mempool_t *flush_entry_pool;
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
+static int userspace_do_request(struct log_c *lc, const char *uuid,
+				int request_type, char *data, size_t data_size,
+				char *rdata, size_t *rdata_size)
+{
+	int r;
+
+	/*
+	 * If the server isn't there, -ESRCH is returned,
+	 * and we must keep trying until the server is
+	 * restored.
+	 */
+retry:
+	r = dm_consult_userspace(uuid, request_type, data,
+				 data_size, rdata, rdata_size);
+
+	if (r != -ESRCH)
+		return r;
+
+	DMERR(" Userspace log server not found.");
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(2*HZ);
+		DMWARN("Attempting to contact userspace log server...");
+		r = dm_consult_userspace(uuid, DM_ULOG_CTR, lc->usr_argv_str,
+					 strlen(lc->usr_argv_str) + 1,
+					 NULL, NULL);
+		if (!r)
+			break;
+	}
+	DMINFO("Reconnected to userspace log server... DM_ULOG_CTR complete");
+	r = dm_consult_userspace(uuid, DM_ULOG_RESUME, NULL,
+				 0, NULL, NULL);
+	if (!r)
+		goto retry;
+
+	DMERR("Error trying to resume userspace log: %d", r);
+
+	return -ESRCH;
+}
+
+static int build_constructor_string(struct dm_target *ti,
+				    unsigned argc, char **argv,
+				    char **ctr_str)
+{
+	int i, str_size;
+	char *str = NULL;
+
+	*ctr_str = NULL;
+
+	for (i = 0, str_size = 0; i < argc; i++)
+		str_size += strlen(argv[i]) + 1; /* +1 for space between args */
+
+	str_size += 20; /* Max number of chars in a printed u64 number */
+
+	str = kzalloc(str_size, GFP_KERNEL);
+	if (!str) {
+		DMWARN("Unable to allocate memory for constructor string");
+		return -ENOMEM;
+	}
+
+	for (i = 0, str_size = 0; i < argc; i++)
+		str_size += sprintf(str + str_size, "%s ", argv[i]);
+	str_size += sprintf(str + str_size, "%llu",
+			    (unsigned long long)ti->len);
+
+	*ctr_str = str;
+	return str_size;
+}
+
+/*
+ * userspace_ctr
+ *
+ * argv contains:
+ *	<UUID> <other args>
+ * Where 'other args' is the userspace implementation specific log
+ * arguments.  An example might be:
+ *	<UUID> clustered_disk <arg count> <log dev> <region_size> [[no]sync]
+ *
+ * So, this module will strip off the <UUID> for identification purposes
+ * when communicating with userspace about a log; but will pass on everything
+ * else.
+ */
+static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
+			 unsigned argc, char **argv)
+{
+	int r = 0;
+	int str_size;
+	char *ctr_str = NULL;
+	struct log_c *lc = NULL;
+	uint64_t rdata;
+	size_t rdata_size = sizeof(rdata);
+
+	if (argc < 3) {
+		DMWARN("Too few arguments to userspace dirty log");
+		return -EINVAL;
+	}
+
+	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
+	if (!lc) {
+		DMWARN("Unable to allocate userspace log context.");
+		return -ENOMEM;
+	}
+
+	lc->ti = ti;
+
+	if (strlen(argv[0]) > (DM_UUID_LEN - 1)) {
+		DMWARN("UUID argument too long.");
+		kfree(lc);
+		return -EINVAL;
+	}
+
+	strncpy(lc->uuid, argv[0], DM_UUID_LEN);
+	spin_lock_init(&lc->flush_lock);
+	INIT_LIST_HEAD(&lc->flush_list);
+
+	str_size = build_constructor_string(ti, argc - 1, argv + 1, &ctr_str);
+	if (str_size < 0) {
+		kfree(lc);
+		return str_size;
+	}
+
+	/* Send table string */
+	r = dm_consult_userspace(lc->uuid, DM_ULOG_CTR,
+				 ctr_str, str_size, NULL, NULL);
+
+	if (r == -ESRCH) {
+		DMERR("Userspace log server not found");
+		goto out;
+	}
+
+	/* Since the region size does not change, get it now */
+	rdata_size = sizeof(rdata);
+	r = dm_consult_userspace(lc->uuid, DM_ULOG_GET_REGION_SIZE,
+				 NULL, 0, (char *)&rdata, &rdata_size);
+
+	if (r) {
+		DMERR("Failed to get region size of dirty log");
+		goto out;
+	}
+
+	lc->region_size = (uint32_t)rdata;
+	lc->region_count = dm_sector_div_up(ti->len, lc->region_size);
+
+out:
+	if (r) {
+		kfree(lc);
+		kfree(ctr_str);
+	} else {
+		lc->usr_argv_str = ctr_str;
+		lc->usr_argc = argc;
+		log->context = lc;
+	}
+
+	return r;
+}
+
+static void userspace_dtr(struct dm_dirty_log *log)
+{
+	int r;
+	struct log_c *lc = log->context;
+
+	r = dm_consult_userspace(lc->uuid, DM_ULOG_DTR,
+				 NULL, 0,
+				 NULL, NULL);
+
+	kfree(lc->usr_argv_str);
+	kfree(lc);
+
+	return;
+}
+
+static int userspace_presuspend(struct dm_dirty_log *log)
+{
+	int r;
+	struct log_c *lc = log->context;
+
+	r = dm_consult_userspace(lc->uuid, DM_ULOG_PRESUSPEND,
+				 NULL, 0,
+				 NULL, NULL);
+
+	return r;
+}
+
+static int userspace_postsuspend(struct dm_dirty_log *log)
+{
+	int r;
+	struct log_c *lc = log->context;
+
+	r = dm_consult_userspace(lc->uuid, DM_ULOG_POSTSUSPEND,
+				 NULL, 0,
+				 NULL, NULL);
+
+	return r;
+}
+
+static int userspace_resume(struct dm_dirty_log *log)
+{
+	int r;
+	struct log_c *lc = log->context;
+
+	lc->in_sync_hint = 0;
+	r = dm_consult_userspace(lc->uuid, DM_ULOG_RESUME,
+				 NULL, 0,
+				 NULL, NULL);
+
+	return r;
+}
+
+static uint32_t userspace_get_region_size(struct dm_dirty_log *log)
+{
+	struct log_c *lc = log->context;
+
+	return lc->region_size;
+}
+
+/*
+ * userspace_is_clean
+ *
+ * Check whether a region is clean.  If there is any sort of
+ * failure when consulting the server, we return not clean.
+ *
+ * Returns: 1 if clean, 0 otherwise
+ */
+static int userspace_is_clean(struct dm_dirty_log *log, region_t region)
+{
+	int r;
+	uint64_t region64 = (uint64_t)region;
+	int64_t is_clean;
+	size_t rdata_size;
+	struct log_c *lc = log->context;
+
+	rdata_size = sizeof(is_clean);
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_IS_CLEAN,
+				 (char *)&region64, sizeof(region64),
+				 (char *)&is_clean, &rdata_size);
+
+	return (r) ? 0 : (int)is_clean;
+}
+
+/*
+ * userspace_in_sync
+ *
+ * Check if the region is in-sync.  If there is any sort
+ * of failure when consulting the server, we assume that
+ * the region is not in sync.
+ *
+ * If 'can_block' is set, return immediately
+ *
+ * Returns: 1 if in-sync, 0 if not-in-sync, -EWOULDBLOCK
+ */
+static int userspace_in_sync(struct dm_dirty_log *log, region_t region,
+			     int can_block)
+{
+	int r;
+	uint64_t region64 = region;
+	int64_t in_sync;
+	size_t rdata_size;
+	struct log_c *lc = log->context;
+
+	/*
+	 * We can never respond directly - even if in_sync_hint is
+	 * set.  This is because another machine could see a device
+	 * failure and mark the region out-of-sync.  If we don't go
+	 * to userspace to ask, we might think the region is in-sync
+	 * and allow a read to pick up data that is stale.  (This is
+	 * very unlikely if a device actually fails; but it is very
+	 * likely if a connection to one device from one machine fails.)
+	 *
+	 * There still might be a problem if the mirror caches the region
+	 * state as in-sync... but then this call would not be made.  So,
+	 * that is a mirror problem.
+	 */
+	if (!can_block)
+		return -EWOULDBLOCK;
+
+	rdata_size = sizeof(in_sync);
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_IN_SYNC,
+				 (char *)&region64, sizeof(region64),
+				 (char *)&in_sync, &rdata_size);
+	return (r) ? 0 : (int)in_sync;
+}
+
+/*
+ * userspace_flush
+ *
+ * This function is ok to block.
+ * The flush happens in two stages.  First, it sends all
+ * clear/mark requests that are on the list.  Then it
+ * tells the server to commit them.  This gives the
+ * server a chance to optimise the commit, instead of
+ * doing it for every request.
+ *
+ * Additionally, we could implement another thread that
+ * sends the requests up to the server - reducing the
+ * load on flush.  Then the flush would have less in
+ * the list and be responsible for the finishing commit.
+ *
+ * Returns: 0 on success, < 0 on failure
+ */
+static int userspace_flush(struct dm_dirty_log *log)
+{
+	int r = 0;
+	unsigned long flags;
+	struct log_c *lc = log->context;
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
+		r = userspace_do_request(lc, lc->uuid, fe->type,
+					 (char *)&fe->region,
+					 sizeof(fe->region),
+					 NULL, NULL);
+		if (r)
+			goto fail;
+	}
+
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
+				 NULL, 0, NULL, NULL);
+
+fail:
+	/*
+	 * We can safely remove these entries, even if failure.
+	 * Calling code will receive an error and will know that
+	 * the log facility has failed.
+	 */
+	list_for_each_entry_safe(fe, tmp_fe, &flush_list, list) {
+		list_del(&fe->list);
+		mempool_free(fe, flush_entry_pool);
+	}
+
+	if (r)
+		dm_table_event(lc->ti->table);
+
+	return r;
+}
+
+/*
+ * userspace_mark_region
+ *
+ * This function should avoid blocking unless absolutely required.
+ * (Memory allocation is valid for blocking.)
+ */
+static void userspace_mark_region(struct dm_dirty_log *log, region_t region)
+{
+	unsigned long flags;
+	struct log_c *lc = log->context;
+	struct flush_entry *fe;
+
+	/* Wait for an allocation, but _never_ fail */
+	fe = mempool_alloc(flush_entry_pool, GFP_NOIO);
+	BUG_ON(!fe);
+
+	spin_lock_irqsave(&lc->flush_lock, flags);
+	fe->type = DM_ULOG_MARK_REGION;
+	fe->region = region;
+	list_add(&fe->list, &lc->flush_list);
+	spin_unlock_irqrestore(&lc->flush_lock, flags);
+
+	return;
+}
+
+/*
+ * userspace_clear_region
+ *
+ * This function must not block.
+ * So, the alloc can't block.  In the worst case, it is ok to
+ * fail.  It would simply mean we can't clear the region.
+ * Does nothing to current sync context, but does mean
+ * the region will be re-sync'ed on a reload of the mirror
+ * even though it is in-sync.
+ */
+static void userspace_clear_region(struct dm_dirty_log *log, region_t region)
+{
+	unsigned long flags;
+	struct log_c *lc = log->context;
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
+	fe->type = DM_ULOG_CLEAR_REGION;
+	fe->region = region;
+	list_add(&fe->list, &lc->flush_list);
+	spin_unlock_irqrestore(&lc->flush_lock, flags);
+
+	return;
+}
+
+/*
+ * userspace_get_resync_work
+ *
+ * Get a region that needs recovery.  It is valid to return
+ * an error for this function.
+ *
+ * Returns: 1 if region filled, 0 if no work, <0 on error
+ */
+static int userspace_get_resync_work(struct dm_dirty_log *log, region_t *region)
+{
+	int r;
+	size_t rdata_size;
+	struct log_c *lc = log->context;
+	struct {
+		int64_t i; /* 64-bit for mix arch compatibility */
+		region_t r;
+	} pkg;
+
+	if (lc->in_sync_hint >= lc->region_count)
+		return 0;
+
+	rdata_size = sizeof(pkg);
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_GET_RESYNC_WORK,
+				 NULL, 0,
+				 (char *)&pkg, &rdata_size);
+
+	*region = pkg.r;
+	return (r) ? r : (int)pkg.i;
+}
+
+/*
+ * userspace_set_region_sync
+ *
+ * Set the sync status of a given region.  This function
+ * must not fail.
+ */
+static void userspace_set_region_sync(struct dm_dirty_log *log,
+				      region_t region, int in_sync)
+{
+	int r;
+	struct log_c *lc = log->context;
+	struct {
+		region_t r;
+		int64_t i;
+	} pkg;
+
+	pkg.r = region;
+	pkg.i = (int64_t)in_sync;
+
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_SET_REGION_SYNC,
+				 (char *)&pkg, sizeof(pkg),
+				 NULL, NULL);
+
+	/*
+	 * It would be nice to be able to report failures.
+	 * However, it is easy emough to detect and resolve.
+	 */
+	return;
+}
+
+/*
+ * userspace_get_sync_count
+ *
+ * If there is any sort of failure when consulting the server,
+ * we assume that the sync count is zero.
+ *
+ * Returns: sync count on success, 0 on failure
+ */
+static region_t userspace_get_sync_count(struct dm_dirty_log *log)
+{
+	int r;
+	size_t rdata_size;
+	uint64_t sync_count;
+	struct log_c *lc = log->context;
+
+	rdata_size = sizeof(sync_count);
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_GET_SYNC_COUNT,
+				 NULL, 0,
+				 (char *)&sync_count, &rdata_size);
+
+	if (r)
+		return 0;
+
+	if (sync_count >= lc->region_count)
+		lc->in_sync_hint = lc->region_count;
+
+	return (region_t)sync_count;
+}
+
+/*
+ * userspace_status
+ *
+ * Returns: amount of space consumed
+ */
+static int userspace_status(struct dm_dirty_log *log, status_type_t status_type,
+			    char *result, unsigned maxlen)
+{
+	int r = 0;
+	size_t sz = (size_t)maxlen;
+	struct log_c *lc = log->context;
+
+	switch (status_type) {
+	case STATUSTYPE_INFO:
+		r = userspace_do_request(lc, lc->uuid, DM_ULOG_STATUS_INFO,
+					 NULL, 0,
+					 result, &sz);
+
+		if (r) {
+			sz = 0;
+			DMEMIT("%s 1 COM_FAILURE", log->type->name);
+		}
+		break;
+	case STATUSTYPE_TABLE:
+		sz = 0;
+		DMEMIT("%s %u %s %s", log->type->name, lc->usr_argc + 1,
+		       lc->uuid, lc->usr_argv_str);
+		break;
+	}
+	return (r) ? 0 : (int)sz;
+}
+
+/*
+ * userspace_is_remote_recovering
+ *
+ * Returns: 1 if region recovering, 0 otherwise
+ */
+static int userspace_is_remote_recovering(struct dm_dirty_log *log,
+					  region_t region)
+{
+	int r;
+	uint64_t region64 = region;
+	struct log_c *lc = log->context;
+	static unsigned long long limit;
+	struct {
+		int64_t is_recovering;
+		uint64_t in_sync_hint;
+	} pkg;
+	size_t rdata_size = sizeof(pkg);
+
+	/*
+	 * Once the mirror has been reported to be in-sync,
+	 * it will never again ask for recovery work.  So,
+	 * we can safely say there is not a remote machine
+	 * recovering if the device is in-sync.  (in_sync_hint
+	 * must be reset at resume time.)
+	 */
+	if (region < lc->in_sync_hint)
+		return 0;
+	else if (jiffies < limit)
+		return 1;
+
+	limit = jiffies + (HZ / 4);
+	r = userspace_do_request(lc, lc->uuid, DM_ULOG_IS_REMOTE_RECOVERING,
+				 (char *)&region64, sizeof(region64),
+				 (char *)&pkg, &rdata_size);
+	if (r)
+		return 1;
+
+	lc->in_sync_hint = pkg.in_sync_hint;
+
+	return (int)pkg.is_recovering;
+}
+
+static struct dm_dirty_log_type _userspace_type = {
+	.name = "userspace",
+	.module = THIS_MODULE,
+	.ctr = userspace_ctr,
+	.dtr = userspace_dtr,
+	.presuspend = userspace_presuspend,
+	.postsuspend = userspace_postsuspend,
+	.resume = userspace_resume,
+	.get_region_size = userspace_get_region_size,
+	.is_clean = userspace_is_clean,
+	.in_sync = userspace_in_sync,
+	.flush = userspace_flush,
+	.mark_region = userspace_mark_region,
+	.clear_region = userspace_clear_region,
+	.get_resync_work = userspace_get_resync_work,
+	.set_region_sync = userspace_set_region_sync,
+	.get_sync_count = userspace_get_sync_count,
+	.status = userspace_status,
+	.is_remote_recovering = userspace_is_remote_recovering,
+};
+
+static int __init userspace_dirty_log_init(void)
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
+	r = dm_ulog_tfr_init();
+	if (r) {
+		DMWARN("Unable to initialize userspace log communications");
+		mempool_destroy(flush_entry_pool);
+		return r;
+	}
+
+	r = dm_dirty_log_type_register(&_userspace_type);
+	if (r) {
+		DMWARN("Couldn't register userspace dirty log type");
+		dm_ulog_tfr_exit();
+		mempool_destroy(flush_entry_pool);
+		return r;
+	}
+
+	DMINFO("version 1.0.0 loaded");
+	return 0;
+}
+
+static void __exit userspace_dirty_log_exit(void)
+{
+	dm_dirty_log_type_unregister(&_userspace_type);
+	dm_ulog_tfr_exit();
+	mempool_destroy(flush_entry_pool);
+
+	DMINFO("version 1.0.0 unloaded");
+	return;
+}
+
+module_init(userspace_dirty_log_init);
+module_exit(userspace_dirty_log_exit);
+
+MODULE_DESCRIPTION(DM_NAME " userspace dirty log link");
+MODULE_AUTHOR("Jonathan Brassow <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
Index: linux-2.6/drivers/md/dm-log-userspace-transfer.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-log-userspace-transfer.c
@@ -0,0 +1,276 @@
+/*
+ * Copyright (C) 2006-2009 Red Hat, Inc.
+ *
+ * This file is released under the LGPL.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <net/sock.h>
+#include <linux/workqueue.h>
+#include <linux/connector.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-log-userspace.h>
+
+#include "dm-log-userspace-transfer.h"
+
+static uint32_t dm_ulog_seq;
+
+/*
+ * Netlink/Connector is an unreliable protocol.  How long should
+ * we wait for a response before assuming it was lost and retrying?
+ * (If we do receive a response after this time, it will be discarded
+ * and the response to the resent request will be waited for.
+ */
+#define DM_ULOG_RETRY_TIMEOUT (15 * HZ)
+
+/*
+ * Pre-allocated space for speed
+ */
+#define DM_ULOG_PREALLOCED_SIZE 512
+static struct cn_msg *prealloced_cn_msg;
+static struct dm_ulog_request *prealloced_ulog_tfr;
+
+static struct cb_id ulog_cn_id = {
+	.idx = CN_IDX_DM,
+	.val = CN_VAL_DM_USERSPACE_LOG
+};
+
+static DEFINE_MUTEX(dm_ulog_lock);
+
+struct receiving_pkg {
+	struct list_head list;
+	struct completion complete;
+
+	uint32_t seq;
+
+	int error;
+	size_t *data_size;
+	char *data;
+};
+
+static DEFINE_SPINLOCK(receiving_list_lock);
+static struct list_head receiving_list;
+
+static int dm_ulog_sendto_server(struct dm_ulog_request *tfr)
+{
+	int r;
+	struct cn_msg *msg = prealloced_cn_msg;
+
+	memset(msg, 0, sizeof(struct cn_msg));
+
+	msg->id.idx = ulog_cn_id.idx;
+	msg->id.val = ulog_cn_id.val;
+	msg->ack = 0;
+	msg->seq = tfr->seq;
+	msg->len = sizeof(struct dm_ulog_request) + tfr->data_size;
+
+	r = cn_netlink_send(msg, 0, gfp_any());
+
+	return r;
+}
+
+/*
+ * Parameters for this function can be either msg or tfr, but not
+ * both.  This function fills in the reply for a waiting request.
+ * If just msg is given, then the reply is simply an ACK from userspace
+ * that the request was received.
+ *
+ * Returns: 0 on success, -ENOENT on failure
+ */
+static int fill_pkg(struct cn_msg *msg, struct dm_ulog_request *tfr)
+{
+	uint32_t rtn_seq = (msg) ? msg->seq : (tfr) ? tfr->seq : 0;
+	struct receiving_pkg *pkg;
+
+	/*
+	 * The 'receiving_pkg' entries in this list are statically
+	 * allocated on the stack in 'dm_consult_userspace'.
+	 * Each process that is waiting for a reply from the user
+	 * space server will have an entry in this list.
+	 *
+	 * We are safe to do it this way because the stack space
+	 * is unique to each process, but still addressable by
+	 * other processes.
+	 */
+	list_for_each_entry(pkg, &receiving_list, list) {
+		if (rtn_seq != pkg->seq)
+			continue;
+
+		if (msg) {
+			pkg->error = -msg->ack;
+			/*
+			 * If we are trying again, we will need to know our
+			 * storage capacity.  Otherwise, along with the
+			 * error code, we make explicit that we have no data.
+			 */
+			if (pkg->error != -EAGAIN)
+				*(pkg->data_size) = 0;
+		} else if (tfr->data_size > *(pkg->data_size)) {
+			DMERR("Insufficient space to receive package [%u] "
+			      "(%u vs %lu)", tfr->request_type,
+			      tfr->data_size, *(pkg->data_size));
+
+			*(pkg->data_size) = 0;
+			pkg->error = -ENOSPC;
+		} else {
+			pkg->error = tfr->error;
+			memcpy(pkg->data, tfr->data, tfr->data_size);
+			*(pkg->data_size) = tfr->data_size;
+		}
+		complete(&pkg->complete);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+/*
+ * This is the connector callback that delivers data
+ * that was sent from userspace.
+ */
+static void cn_ulog_callback(void *data)
+{
+	struct cn_msg *msg = (struct cn_msg *)data;
+	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
+
+	spin_lock(&receiving_list_lock);
+	if (msg->len == 0)
+		fill_pkg(msg, NULL);
+	else if (msg->len < sizeof(*tfr))
+		DMERR("Incomplete message received (expected %u, got %u): [%u]",
+		      (unsigned)sizeof(*tfr), msg->len, msg->seq);
+	else
+		fill_pkg(NULL, tfr);
+	spin_unlock(&receiving_list_lock);
+}
+
+/**
+ * dm_consult_userspace
+ * @uuid: log's uuid (must be DM_UUID_LEN in size)
+ * @request_type:  found in include/linux/dm-log-userspace.h
+ * @data: data to tx to the server
+ * @data_size: size of data in bytes
+ * @rdata: place to put return data from server
+ * @rdata_size: value-result (amount of space given/amount of space used)
+ *
+ * rdata_size is undefined on failure.
+ *
+ * Memory used to communicate with userspace is zero'ed
+ * before populating to ensure that no unwanted bits leak
+ * from kernel space to user-space.  All userspace log communications
+ * between kernel and user space go through this function.
+ *
+ * Returns: 0 on success, -EXXX on failure
+ **/
+int dm_consult_userspace(const char *uuid, int request_type,
+			 char *data, size_t data_size,
+			 char *rdata, size_t *rdata_size)
+{
+	int r = 0;
+	size_t dummy = 0;
+	int overhead_size =
+		sizeof(struct dm_ulog_request *) + sizeof(struct cn_msg);
+	struct dm_ulog_request *tfr = prealloced_ulog_tfr;
+	struct receiving_pkg pkg;
+
+	if (data_size > (DM_ULOG_PREALLOCED_SIZE - overhead_size)) {
+		DMINFO("Size of tfr exceeds preallocated size");
+		return -EINVAL;
+	}
+
+	if (!rdata_size)
+		rdata_size = &dummy;
+resend:
+	/*
+	 * We serialize the sending of requests so we can
+	 * use the preallocated space.
+	 */
+	mutex_lock(&dm_ulog_lock);
+
+	memset(tfr, 0, DM_ULOG_PREALLOCED_SIZE - overhead_size);
+	memcpy(tfr->uuid, uuid, DM_UUID_LEN);
+	tfr->seq = dm_ulog_seq++;
+
+	/*
+	 * Must be valid request type (all other bits set to
+	 * zero).  This reserves other bits for possible future
+	 * use.
+	 */
+	tfr->request_type = request_type & DM_ULOG_REQUEST_MASK;
+
+	tfr->data_size = data_size;
+	if (data && data_size)
+		memcpy(tfr->data, data, data_size);
+
+	memset(&pkg, 0, sizeof(pkg));
+	init_completion(&pkg.complete);
+	pkg.seq = tfr->seq;
+	pkg.data_size = rdata_size;
+	pkg.data = rdata;
+	spin_lock(&receiving_list_lock);
+	list_add(&(pkg.list), &receiving_list);
+	spin_unlock(&receiving_list_lock);
+
+	r = dm_ulog_sendto_server(tfr);
+
+	mutex_unlock(&dm_ulog_lock);
+
+	if (r) {
+		DMERR("Unable to send log request [%u] to userspace: %d",
+		      request_type, r);
+		spin_lock(&receiving_list_lock);
+		list_del_init(&(pkg.list));
+		spin_unlock(&receiving_list_lock);
+
+		goto out;
+	}
+
+	r = wait_for_completion_timeout(&(pkg.complete), DM_ULOG_RETRY_TIMEOUT);
+	spin_lock(&receiving_list_lock);
+	list_del_init(&(pkg.list));
+	spin_unlock(&receiving_list_lock);
+	if (!r) {
+		DMWARN("[%s] Request timed out: [%u/%u] - retrying",
+		       (strlen(uuid) > 8) ?
+		       (uuid + (strlen(uuid) - 8)) : (uuid),
+		       request_type, pkg.seq);
+		goto resend;
+	}
+
+	r = pkg.error;
+	if (r == -EAGAIN)
+		goto resend;
+
+out:
+	return r;
+}
+
+int dm_ulog_tfr_init(void)
+{
+	int r;
+	void *prealloced;
+
+	INIT_LIST_HEAD(&receiving_list);
+
+	prealloced = kmalloc(DM_ULOG_PREALLOCED_SIZE, GFP_KERNEL);
+	if (!prealloced)
+		return -ENOMEM;
+
+	prealloced_cn_msg = prealloced;
+	prealloced_ulog_tfr = prealloced + sizeof(struct cn_msg);
+
+	r = cn_add_callback(&ulog_cn_id, "dmlogusr", cn_ulog_callback);
+	if (r) {
+		cn_del_callback(&ulog_cn_id);
+		return r;
+	}
+
+	return 0;
+}
+
+void dm_ulog_tfr_exit(void)
+{
+	cn_del_callback(&ulog_cn_id);
+	kfree(prealloced_cn_msg);
+}
Index: linux-2.6/drivers/md/dm-log-userspace-transfer.h
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-log-userspace-transfer.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2006-2009 Red Hat, Inc.
+ *
+ * This file is released under the LGPL.
+ */
+
+#ifndef __DM_LOG_USERSPACE_TRANSFER_H__
+#define __DM_LOG_USERSPACE_TRANSFER_H__
+
+#define DM_MSG_PREFIX "dm-log-userspace"
+
+int dm_ulog_tfr_init(void);
+void dm_ulog_tfr_exit(void);
+int dm_consult_userspace(const char *uuid, int request_type,
+			 char *data, size_t data_size,
+			 char *rdata, size_t *rdata_size);
+
+#endif /* __DM_LOG_USERSPACE_TRANSFER_H__ */
Index: linux-2.6/include/linux/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/Kbuild
+++ linux-2.6/include/linux/Kbuild
@@ -57,6 +57,7 @@ header-y += dlmconstants.h
 header-y += dlm_device.h
 header-y += dlm_netlink.h
 header-y += dm-ioctl.h
+header-y += dm-log-userspace.h
 header-y += dn.h
 header-y += dqblk_xfs.h
 header-y += efs_fs_sb.h
Index: linux-2.6/include/linux/connector.h
===================================================================
--- linux-2.6.orig/include/linux/connector.h
+++ linux-2.6/include/linux/connector.h
@@ -41,8 +41,10 @@
 #define CN_IDX_BB			0x5	/* BlackBoard, from the TSP GPL sampling framework */
 #define CN_DST_IDX			0x6
 #define CN_DST_VAL			0x1
+#define CN_IDX_DM			0x7	/* Device Mapper */
+#define CN_VAL_DM_USERSPACE_LOG		0x1
 
-#define CN_NETLINK_USERS		7
+#define CN_NETLINK_USERS		8
 
 /*
  * Maximum connector's message size.
Index: linux-2.6/include/linux/dm-log-userspace.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/dm-log-userspace.h
@@ -0,0 +1,386 @@
+/*
+ * Copyright (C) 2006-2009 Red Hat, Inc.
+ *
+ * This file is released under the LGPL.
+ */
+
+#ifndef __DM_LOG_USERSPACE_H__
+#define __DM_LOG_USERSPACE_H__
+
+#include <linux/dm-ioctl.h> /* For DM_UUID_LEN */
+
+/*
+ * The device-mapper userspace log module consists of a kernel component and
+ * a user-space component.  The kernel component implements the API defined
+ * in dm-dirty-log.h.  Its purpose is simply to pass the parameters and
+ * return values of those API functions between kernel and user-space.
+ *
+ * Below are defined the 'request_types' - DM_ULOG_CTR, DM_ULOG_DTR, etc.
+ * These request types represent the different functions in the device-mapper
+ * dirty log API.  Each of these is described in more detail below.
+ *
+ * The user-space program must listen for requests from the kernel (representing
+ * the various API functions) and process them.
+ *
+ * User-space begins by setting up the communication link (error checking
+ * removed for clarity):
+ *	fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
+ *	addr.nl_family = AF_NETLINK;
+ *	addr.nl_groups = CN_IDX_DM;
+ *	addr.nl_pid = 0;
+ *	r = bind(fd, (struct sockaddr *) &addr, sizeof(addr));
+ *	opt = addr.nl_groups;
+ *	setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &opt, sizeof(opt));
+ *
+ * User-space will then wait to receive requests form the kernel, which it
+ * will process as described below.  The requests are received in the form,
+ * ((struct dm_ulog_request) + (additional data)).  Depending on the request
+ * type, there may or may not be 'additional data'.  In the descriptions below,
+ * you will see 'Payload-to-userspace' and 'Payload-to-kernel'.  The
+ * 'Payload-to-userspace' is what the kernel sends in 'additional data' as
+ * necessary parameters to complete the request.  The 'Payload-to-kernel' is
+ * the 'additional data' returned to the kernel that contains the necessary
+ * results of the request.  The 'data_size' field in the dm_ulog_request
+ * structure denotes the availability and amount of payload data.
+ */
+
+/*
+ * DM_ULOG_CTR corresponds to (found in dm-dirty-log.h):
+ * int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
+ *	      unsigned argc, char **argv);
+ *
+ * Payload-to-userspace:
+ *	A single string containing all the argv arguments separated by ' 's
+ * Payload-to-kernel:
+ *	None.  ('data_size' in the dm_ulog_request struct should be 0.)
+ *
+ * The UUID contained in the dm_ulog_request structure is the reference that
+ * will be used by all request types to a specific log.  The constructor must
+ * record this assotiation with instance created.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_CTR                    1
+
+/*
+ * DM_ULOG_DTR corresponds to (found in dm-dirty-log.h):
+ * void (*dtr)(struct dm_dirty_log *log);
+ *
+ * Payload-to-userspace:
+ *	A single string containing all the argv arguments separated by ' 's
+ * Payload-to-kernel:
+ *	None.  ('data_size' in the dm_ulog_request struct should be 0.)
+ *
+ * The UUID contained in the dm_ulog_request structure is all that is
+ * necessary to identify the log instance being destroyed.  There is no
+ * payload data.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and clearing
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_DTR                    2
+
+/*
+ * DM_ULOG_PRESUSPEND corresponds to (found in dm-dirty-log.h):
+ * int (*presuspend)(struct dm_dirty_log *log);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	None.
+ *
+ * The UUID contained in the dm_ulog_request structure is all that is
+ * necessary to identify the log instance being presuspended.  There is no
+ * payload data.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_PRESUSPEND             3
+
+/*
+ * DM_ULOG_POSTSUSPEND corresponds to (found in dm-dirty-log.h):
+ * int (*postsuspend)(struct dm_dirty_log *log);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	None.
+ *
+ * The UUID contained in the dm_ulog_request structure is all that is
+ * necessary to identify the log instance being postsuspended.  There is no
+ * payload data.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_POSTSUSPEND            4
+
+/*
+ * DM_ULOG_RESUME corresponds to (found in dm-dirty-log.h):
+ * int (*resume)(struct dm_dirty_log *log);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	None.
+ *
+ * The UUID contained in the dm_ulog_request structure is all that is
+ * necessary to identify the log instance being resumed.  There is no
+ * payload data.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_RESUME                 5
+
+/*
+ * DM_ULOG_GET_REGION_SIZE corresponds to (found in dm-dirty-log.h):
+ * uint32_t (*get_region_size)(struct dm_dirty_log *log);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	uint64_t - contains the region size
+ *
+ * The region size is something that was determined at constructor time.
+ * It is returned in the payload area and 'data_size' is set to
+ * reflect this.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field appropriately.
+ */
+#define DM_ULOG_GET_REGION_SIZE        6
+
+/*
+ * DM_ULOG_IS_CLEAN corresponds to (found in dm-dirty-log.h):
+ * int (*is_clean)(struct dm_dirty_log *log, region_t region);
+ *
+ * Payload-to-userspace:
+ *	uint64_t - the region to get clean status on
+ * Payload-to-kernel:
+ *	int64_t  - 1 if clean, 0 otherwise
+ *
+ * Payload is sizeof(uint64_t) and contains the region for which the clean
+ * status is being made.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - filling the payload with 0 (not clean) or
+ * 1 (clean), setting 'data_size' and 'error' appropriately.
+ */
+#define DM_ULOG_IS_CLEAN               7
+
+/*
+ * DM_ULOG_IN_SYNC corresponds to (found in dm-dirty-log.h):
+ * int (*in_sync)(struct dm_dirty_log *log, region_t region,
+ *		  int can_block);
+ *
+ * Payload-to-userspace:
+ *	uint64_t - the region to get sync status on
+ * Payload-to-kernel:
+ *	int64_t - 1 if in-sync, 0 otherwise
+ *
+ * Exactly the same as 'is_clean' above, except this time asking "has the
+ * region been recovered?" vs. "is the region not being modified?"
+ */
+#define DM_ULOG_IN_SYNC                8
+
+/*
+ * DM_ULOG_FLUSH corresponds to (found in dm-dirty-log.h):
+ * int (*flush)(struct dm_dirty_log *log);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	None.
+ *
+ * No incoming or outgoing payload.  Simply flush log state to disk.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and clearing
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_FLUSH                  9
+
+/*
+ * DM_ULOG_MARK_REGION corresponds to (found in dm-dirty-log.h):
+ * void (*mark_region)(struct dm_dirty_log *log, region_t region);
+ *
+ * Payload-to-userspace:
+ *	uint64_t [] - region(s) to mark
+ * Payload-to-kernel:
+ *	None.
+ *
+ * Incoming payload contains the one or more regions to mark dirty.
+ * The number of regions contained in the payload can be determined from
+ * 'data_size/sizeof(uint64_t)'.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and clearing
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_MARK_REGION           10
+
+/*
+ * DM_ULOG_CLEAR_REGION corresponds to (found in dm-dirty-log.h):
+ * void (*clear_region)(struct dm_dirty_log *log, region_t region);
+ *
+ * Payload-to-userspace:
+ *	uint64_t [] - region(s) to clear
+ * Payload-to-kernel:
+ *	None.
+ *
+ * Incoming payload contains the one or more regions to mark clean.
+ * The number of regions contained in the payload can be determined from
+ * 'data_size/sizeof(uint64_t)'.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and clearing
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_CLEAR_REGION          11
+
+/*
+ * DM_ULOG_GET_RESYNC_WORK corresponds to (found in dm-dirty-log.h):
+ * int (*get_resync_work)(struct dm_dirty_log *log, region_t *region);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	{
+ *		int64_t i; -- 1 if recovery necessary, 0 otherwise
+ *		uint64_t r; -- The region to recover if i=1
+ *	}
+ * 'data_size' should be set appropriately.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field appropriately.
+ */
+#define DM_ULOG_GET_RESYNC_WORK       12
+
+/*
+ * DM_ULOG_SET_REGION_SYNC corresponds to (found in dm-dirty-log.h):
+ * void (*set_region_sync)(struct dm_dirty_log *log,
+ *			   region_t region, int in_sync);
+ *
+ * Payload-to-userspace:
+ *	{
+ *		uint64_t - region to set sync state on
+ *		int64_t  - 0 if not-in-sync, 1 if in-sync
+ *	}
+ * Payload-to-kernel:
+ *	None.
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and clearing
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_SET_REGION_SYNC       13
+
+/*
+ * DM_ULOG_GET_SYNC_COUNT corresponds to (found in dm-dirty-log.h):
+ * region_t (*get_sync_count)(struct dm_dirty_log *log);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	uint64_t - the number of in-sync regions
+ *
+ * No incoming payload.  Kernel-bound payload contains the number of
+ * regions that are in-sync (in a size_t).
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_GET_SYNC_COUNT        14
+
+/*
+ * DM_ULOG_STATUS_INFO corresponds to (found in dm-dirty-log.h):
+ * int (*status)(struct dm_dirty_log *log, STATUSTYPE_INFO,
+ *		 char *result, unsigned maxlen);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	Character string containing STATUSTYPE_INFO
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_STATUS_INFO           15
+
+/*
+ * DM_ULOG_STATUS_TABLE corresponds to (found in dm-dirty-log.h):
+ * int (*status)(struct dm_dirty_log *log, STATUSTYPE_TABLE,
+ *		 char *result, unsigned maxlen);
+ *
+ * Payload-to-userspace:
+ *	None.
+ * Payload-to-kernel:
+ *	Character string containing STATUSTYPE_TABLE
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_STATUS_TABLE          16
+
+/*
+ * DM_ULOG_IS_REMOTE_RECOVERING corresponds to (found in dm-dirty-log.h):
+ * int (*is_remote_recovering)(struct dm_dirty_log *log, region_t region);
+ *
+ * Payload-to-userspace:
+ *	uint64_t - region to determine recovery status on
+ * Payload-to-kernel:
+ *	{
+ *		int64_t is_recovering;  -- 0 if no, 1 if yes
+ *		uint64_t in_sync_hint;  -- lowest region still needing resync
+ *	}
+ *
+ * When the request has been processed, user-space must return the
+ * dm_ulog_request to the kernel - setting the 'error' field and
+ * 'data_size' appropriately.
+ */
+#define DM_ULOG_IS_REMOTE_RECOVERING  17
+
+/*
+ * (DM_ULOG_REQUEST_MASK & request_type) to get the request type
+ *
+ * Payload-to-userspace:
+ *	A single string containing all the argv arguments separated by ' 's
+ * Payload-to-kernel:
+ *	None.  ('data_size' in the dm_ulog_request struct should be 0.)
+ *
+ * We are reserving 8 bits of the 32-bit 'request_type' field for the
+ * various request types above.  The remaining 24-bits are currently
+ * set to zero and are reserved for future use and compatibility concerns.
+ *
+ * User-space should always use DM_ULOG_REQUEST_TYPE to aquire the
+ * request type from the 'request_type' field to maintain forward compatibility.
+ */
+#define DM_ULOG_REQUEST_MASK 0xFF
+#define DM_ULOG_REQUEST_TYPE(request_type) \
+	(DM_ULOG_REQUEST_MASK & (request_type))
+
+struct dm_ulog_request {
+	char uuid[DM_UUID_LEN]; /* Ties a request to a specific mirror log */
+	char padding[7];        /* Padding because DM_UUID_LEN = 129 */
+
+	int32_t error;          /* Used to report back processing errors */
+
+	uint32_t seq;           /* Sequence number for request */
+	uint32_t request_type;  /* DM_ULOG_* defined above */
+	uint32_t data_size;     /* How much data (not including this struct) */
+
+	char data[0];
+};
+
+#endif /* __DM_LOG_USERSPACE_H__ */
