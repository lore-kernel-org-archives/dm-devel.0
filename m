From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] DM Exception Store:  clusterized type
Date: Fri, 27 Mar 2009 16:38:33 -0500
Message-ID: <200903272138.n2RLcX7w017994@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-exception-store-clusterized-type.patch

This patch provides an exception store implementation that is
capable of "wrapping" other exception store implementations and
making them cluster-aware.  It is not a stand-alone implementation.
It merely uses distributed locking to protect exception store
metadata as the single-machine "core" exception stores perform
their actions independently.  This is why the module uses the
term "clusterized" instead of "clustered".  This is just a toy
right now.  I'm not sure how it will perform - I have more
optimizations to do yet.

Preliminary test shows the concept works to provide cluster-aware
snapshots.  Testing is somewhat difficult... and there is quite
a bit to do yet.  I have a script that will convert single machine
snapshots to cluster-aware snapshots that I am willing to share to
those who wish to test cluster-aware snapshots.

Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -244,10 +244,10 @@ config DM_CRYPT
 	  If unsure, say N.
 
 config DM_SNAPSHOT
-       tristate "Snapshot target"
-       depends on BLK_DEV_DM
-       ---help---
-         Allow volume managers to take writable snapshots of a device.
+	tristate "Snapshot target"
+	depends on BLK_DEV_DM
+	---help---
+	  Allow volume managers to take writable snapshots of a device.
 
 config DM_EXSTORE_SHARED
 	tristate "Shared exception store (EXPERIMENTAL)"
@@ -257,6 +257,19 @@ config DM_EXSTORE_SHARED
 	  yields space and performance gains when more than one
 	  snapshot is taken of a device.
 
+config DM_EXSTORE_CLUSTERIZED
+	tristate "Cluster-aware exception store wrapper (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && DM_SNAPSHOT
+	select DLM
+	---help---
+	  An exception store is a module that is used by snapshots to
+	  record COW areas.  This module is capable of wrapping certain
+	  exception stores so that they appear to be cluster-aware.  This
+	  has the affect of making device-mapper snapshots cluster-aware.
+	  Not every exception store type can be wrapped.  Check the end
+	  of drivers/md/dm-ex-store-clusterized.c to find out what stores
+	  are supported.
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -8,6 +8,7 @@ dm-multipath-objs := dm-path-selector.o 
 dm-snapshot-objs := dm-snap.o dm-exception.o dm-exception-store.o \
 		    dm-snap-persistent.o dm-snap-transient.o
 dm-exstore-shared-objs := dm-ex-store-shared.o
+dm-exstore-clusterized-objs := dm-ex-store-clusterized.o
 dm-mirror-objs	:= dm-raid1.o
 md-mod-objs     := md.o bitmap.o
 raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
@@ -37,6 +38,7 @@ obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_EXSTORE_SHARED) += dm-exstore-shared.o
+obj-$(CONFIG_DM_EXSTORE_CLUSTERIZED) += dm-exstore-clusterized.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
Index: linux-2.6/drivers/md/dm-ex-store-clusterized.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-ex-store-clusterized.c
@@ -0,0 +1,573 @@
+/*
+ * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
+ *
+ * Device-mapper exception structure and associated functions.
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/device-mapper.h>
+#include <linux/dlm.h>
+#include "dm-exception-store.h"
+
+#define DM_MSG_PREFIX "clusterized exception store"
+
+struct clusterized_c {
+	struct dm_exception_store *core_store;
+
+	struct rw_semaphore lock;
+
+	int current_dl_mode;
+	unsigned dl_holders;
+	struct completion dlm_completion;
+	dlm_lockspace_t *lockspace;
+	struct dlm_lksb lksb;
+
+	uint64_t metadata_counter;
+	uint64_t cluster_metadata_counter;
+
+	char uuid[0]; /* must be last */
+};
+
+#define mode2str(__mode) \
+	(__mode == DLM_LOCK_NL) ? "DLM_LOCK_NL" : \
+	(__mode == DLM_LOCK_CR) ? "DLM_LOCK_CR" : \
+	(__mode == DLM_LOCK_EX) ? "DLM_LOCK_EX" : "UNKNOWN"
+
+static void lock_obtained(void *context)
+{
+	struct clusterized_c *cc = context;
+
+	complete(&cc->dlm_completion);
+}
+
+static int __cluster_lock(struct clusterized_c *cc, int mode)
+{
+	int r;
+	uint32_t flags = DLM_LKF_VALBLK;
+
+	/*
+	 * Does the curernt lock mode meet or exceed our needs?
+	 */
+	if (mode <= cc->current_dl_mode) {
+		cc->dl_holders++;
+		return 0;
+	}
+
+	/*
+	 * If the current lock mode is DLM_LOCK_NL, we can immediately
+	 * proceed to converting it.
+	 */
+	if (cc->current_dl_mode == DLM_LOCK_NL) {
+		BUG_ON(cc->dl_holders);
+
+		flags |= DLM_LKF_CONVERT;
+
+		r = dlm_lock(cc->lockspace, mode, &cc->lksb,
+			     flags, cc->uuid, strlen(cc->uuid), 0,
+			     lock_obtained, cc, NULL);
+		if (r) {
+			DMERR("cluster_lock immediate failure: %d", r);
+			return r;
+		}
+
+		wait_for_completion(&cc->dlm_completion);
+
+		if (cc->lksb.sb_status) {
+			DMERR("cluster_lock async failure: %d",
+			      cc->lksb.sb_status);
+			return cc->lksb.sb_status;
+		}
+
+		cc->current_dl_mode = mode;
+		cc->dl_holders = 1;
+		return 0;
+	}
+
+	DMERR("DLM up-conversion required... waiting for unlock");
+	return -EAGAIN;
+}
+
+static int __cluster_unlock(struct clusterized_c *cc)
+{
+	int r;
+	uint32_t flags = DLM_LKF_VALBLK | DLM_LKF_CONVERT;
+
+	if (--cc->dl_holders)
+		return 0;
+
+	r = dlm_lock(cc->lockspace, DLM_LOCK_NL, &cc->lksb,
+		     flags, cc->uuid, strlen(cc->uuid), 0,
+		     lock_obtained, cc, NULL);
+
+	if (!r) {
+		wait_for_completion(&cc->dlm_completion);
+		r = cc->lksb.sb_status;
+	}
+
+	if (r)
+		DMERR("Failure to convert to NL lock: %d", r);
+	else
+		cc->current_dl_mode = DLM_LOCK_NL;
+
+	return r;
+}
+
+static int cluster_lock_init(struct clusterized_c *cc)
+{
+	int r;
+	uint32_t flags = DLM_LKF_VALBLK | DLM_LKF_EXPEDITE;
+
+	r = dlm_lock(cc->lockspace, DLM_LOCK_NL, &cc->lksb,
+		     flags, cc->uuid, strlen(cc->uuid), 0,
+		     lock_obtained, cc, NULL);
+	if (!r) {
+		wait_for_completion(&cc->dlm_completion);
+		r = cc->lksb.sb_status;
+	}
+
+	if (r)
+		DMERR("Failed to acquire initial DLM lock: %d", r);
+
+	return r;
+}
+
+static void cluster_lock_exit(struct clusterized_c *cc)
+{
+	BUG_ON(cc->current_dl_mode);
+	dlm_unlock(cc->lockspace, cc->lksb.sb_lkid,
+		   DLM_LKF_FORCEUNLOCK, &cc->lksb, cc);
+}
+
+static int cluster_lock(struct clusterized_c *cc, int mode)
+{
+	int r = -EAGAIN;
+
+	while (r == -EAGAIN) {
+		down_write(&cc->lock);
+		r = __cluster_lock(cc, mode);
+		up_write(&cc->lock);
+	}
+
+	return r;
+}
+
+/*
+ * cluster_unlock
+ * @cc
+ *
+ * Doesn't completely unlock, but rather puts the lock back into
+ * the DLM_LOCK_NL mode.  This preserves the LVB.
+ *
+ */
+static int cluster_unlock(struct clusterized_c *cc)
+{
+	int r;
+
+	down_write(&cc->lock);
+	r = __cluster_unlock(cc);
+	up_write(&cc->lock);
+
+	return r;
+}
+
+/*
+ * clusterized_ctr
+ * @store
+ * @argc
+ * @argv
+ *
+ * The mapping table will be the same as the exception
+ * store it is covering, but will also include the
+ * argument:
+ *	<non-clustered args> cluster_uuid:<UUID>
+ *
+ * Returns: 0 on success, -EXXX on failure
+ */
+static int clusterized_ctr(struct dm_exception_store *store,
+			   unsigned argc, char **argv)
+{
+	int r;
+	unsigned i, j, len;
+	unsigned my_argc = argc + 1;
+	char *my_argv[my_argc];
+	char chunk_size_str[32];
+	char *core_name;
+	struct clusterized_c *cc = NULL;
+
+	/*
+	 * First, in order to pass down to non-clustered
+	 * core, we must add back the COW and chunk size
+	 * arguments
+	 */
+	my_argv[0] = store->cow->name;
+	sprintf(chunk_size_str, "%llu", (unsigned long long)store->chunk_size);
+	my_argv[1] = chunk_size_str;
+
+	/* Now we strip off the cluster_uuid argument */
+	argc--;
+	if (strncmp("cluster_uuid:", argv[argc], 13)) {
+		DMERR("No 'cluster_uuid:' argument provided.");
+		return -EINVAL;
+	}
+	for (i = 0, j = 2; i < argc; i++, j++)
+		my_argv[j] = argv[i];
+
+	/*
+	 * We just want to count the actual UUID, plus 1
+	 * for the trailing NULL.  (With MAX size being
+	 * what is able to fit in the LVB of a DLM lock.)
+	 */
+	len = strlen(argv[argc] + 13) + 1;
+	len = (len > DLM_RESNAME_MAXLEN) ? DLM_RESNAME_MAXLEN : len;
+	cc = kzalloc(sizeof(*cc) + len, GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+	strncpy(cc->uuid, argv[argc] + 13, len);
+	cc->lksb.sb_lvbptr = (char *)&cc->cluster_metadata_counter;
+
+	init_rwsem(&cc->lock);
+	init_completion(&cc->dlm_completion);
+
+	/* Create (or join) the lock space */
+	r = dlm_new_lockspace(store->type->name, strlen(store->type->name),
+			      &cc->lockspace, 0, sizeof(uint64_t));
+
+	if (r) {
+		DMERR("Unable to create DLM lockspace for %s",
+		      store->type->name);
+		kfree(cc);
+		return r;
+	}
+	cluster_lock_init(cc);
+
+	/*
+	 * Now we find the non-clustered exception store name.
+	 * It will be whatever is left when we strip 'clusterized_' off.
+	 */
+	core_name = strstr(store->type->name, "-");
+	BUG_ON(!core_name);
+	core_name++;
+
+	r = dm_exception_store_create(core_name, store->ti, my_argc, my_argv,
+				      &cc->core_store);
+
+	if (r) {
+		DMERR("Failed to create foundational exception store, %s",
+		      core_name);
+		dlm_release_lockspace(cc->lockspace, 1);
+		kfree(cc);
+		return r;
+	}
+
+	/* If the core store is shared, we are shared */
+	store->shared_uuid = cc->core_store->shared_uuid;
+
+	store->context = cc;
+
+	return 0;
+}
+
+static void clusterized_dtr(struct dm_exception_store *store)
+{
+	struct clusterized_c *cc = store->context;
+
+	dm_exception_store_destroy(cc->core_store);
+
+	cluster_lock_exit(cc);
+	dlm_release_lockspace(cc->lockspace, 1);
+
+	kfree(cc);
+}
+
+static int clusterized_resume(struct dm_exception_store *store)
+{
+	int r;
+	struct clusterized_c *cc = store->context;
+
+	cluster_lock(cc, DLM_LOCK_CR);
+
+	r = cc->core_store->type->resume(cc->core_store);
+	cc->metadata_counter = cc->cluster_metadata_counter;
+
+	cluster_unlock(cc);
+
+	return r;
+}
+
+static void clusterized_presuspend(struct dm_exception_store *store)
+{
+	struct clusterized_c *cc = store->context;
+
+	if (cc->core_store->type->presuspend)
+		cc->core_store->type->presuspend(store);
+}
+
+static void clusterized_postsuspend(struct dm_exception_store *store)
+{
+	struct clusterized_c *cc = store->context;
+
+	if (cc->core_store->type->postsuspend)
+		cc->core_store->type->postsuspend(store);
+}
+
+static int clusterized_prepare_exception(struct dm_exception_store *store,
+					 struct dm_exception *e, int group)
+{
+	int r;
+	struct clusterized_c *cc = store->context;
+
+	cluster_lock(cc, DLM_LOCK_EX);
+
+	r = cc->core_store->type->prepare_exception(cc->core_store, e, group);
+
+	if (r) {
+		DMERR("Core store failed to prepare_exception");
+		cluster_unlock(cc);
+	}
+
+	return r;
+}
+
+/* cbc - callback context */
+struct cbc {
+	struct clusterized_c *cc;
+
+	void (*callback) (void *, int success);
+	void *callback_data;
+};
+
+void commit_callback(void *data, int success)
+{
+	struct cbc *context = data;
+
+	context->cc->metadata_counter++;
+	context->cc->cluster_metadata_counter = context->cc->metadata_counter;
+
+	context->callback(context->callback_data, success);
+	cluster_unlock(context->cc);
+
+	kfree(context);
+}
+
+static void clusterized_commit_exception(struct dm_exception_store *store,
+					 struct dm_exception *e,
+					 void (*callback) (void *, int success),
+					 void *callback_context)
+{
+	struct clusterized_c *cc = store->context;
+	struct cbc *cbc;
+
+	cbc = kmalloc(sizeof(*cbc), GFP_NOIO);
+	if (!cbc) {
+		callback(callback_context, 0);
+		return;
+	}
+
+	cbc->cc = cc;
+	cbc->callback = callback;
+	cbc->callback_data = callback_context;
+
+	cc->core_store->type->commit_exception(cc->core_store, e,
+					       commit_callback, cbc);
+}
+
+/*
+ * clusterized_lookup_exception
+ * @store
+ * @old
+ * @new: NULL if they don't want data back
+ * @group
+ * @can_block
+ *
+ * A "shared" exception store can alter the metadata
+ * outside the scope of our cluster-wide LVB counter.
+ * We have no way of knowing whether we need to re-read/resume
+ * the metadata if a "shared" exception store is in use.
+ *
+ * We could re-read the metadata regardless, but that seems
+ * like an aweful waste... just don't allow "shared"
+ * exception stores right now (enforced in the ctr).
+ *
+ * Returns: 0 if found, -ENOENT if not found, -Exxx otherwise
+ */
+static int clusterized_lookup_exception(struct dm_exception_store *store,
+					chunk_t old, chunk_t *new,
+					int group, int can_block)
+{
+	int r;
+	struct clusterized_c *cc = store->context;
+
+	/*
+	 * Even if the metadata counters don't match, we don't
+	 * need to re-read the metadata if we can find the
+	 * exception right now.  In fact, we don't even need to
+	 * take out the cluster lock if we are just looking in our
+	 * local cache.
+	 */
+	r = cc->core_store->type->lookup_exception(cc->core_store, old,
+						   new, group, can_block);
+
+	/* If we found the exception or there was an error, we can return */
+	if (r != -ENOENT)
+		return r;
+
+	/* We block when we aquire the DLM lock - respect !can_block */
+	if (!can_block)
+		return -EWOULDBLOCK;
+
+	cluster_lock(cc, DLM_LOCK_CR);
+
+	/*
+	 * If a "shared" core exception store is used, then the
+	 * metadata_counter is incapable of keeping track of all
+	 * changes that occur, so we must re-read the metadata
+	 * (i.e. resume).
+	 */
+	if (!store->shared_uuid &&
+	    (cc->cluster_metadata_counter == cc->metadata_counter)) {
+		/*
+		 * Exception was not found, and the metadata was not
+		 * changed by other node.
+		 */
+		cluster_unlock(cc);
+		return -ENOENT;
+	}
+
+	/*
+	 * The core exception store's resume method must be capable of
+	 * re-reading its metadata and updating its cache.  IOW, it must
+	 * be able to resume multiple times before a suspend is issued.
+	 */
+	cc->core_store->type->resume(cc->core_store);
+
+	cc->metadata_counter = cc->cluster_metadata_counter;
+	cluster_unlock(cc);
+
+	/* Now, try to find the exception again. */
+	r = cc->core_store->type->lookup_exception(cc->core_store, old,
+						   new, group, can_block);
+	return r;
+}
+
+static void clusterized_fraction_full(struct dm_exception_store *store,
+				      sector_t *numerator, sector_t *denominator)
+{
+	struct clusterized_c *cc = store->context;
+
+	/*
+	 * FIXME: If we want more exact numbers, then we should
+	 * check the LVB for changes and potentially force the
+	 * core store to re-read metadata.
+	 */
+	cc->core_store->type->fraction_full(cc->core_store, numerator,
+					    denominator);
+}
+
+static unsigned clusterized_status(struct dm_exception_store *store,
+				   status_type_t status, char *result,
+				   unsigned int maxlen)
+{
+	int sz = 0;
+	char *tmp_result;
+	struct clusterized_c *cc = store->context;
+
+	switch (status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT(" clusterized");
+		tmp_result = result + sz;
+		sz += cc->core_store->type->status(cc->core_store, status,
+						   result+sz, maxlen-sz);
+		tmp_result[0] = '-'; /* s/ /-/ */
+
+		tmp_result = strstr(tmp_result, " ");
+		if (tmp_result) {
+			tmp_result++;
+			tmp_result[0]++; /* Inc numeric char */
+		}
+
+		DMEMIT(" cluster_uuid:%s", cc->uuid);
+	}
+
+	return sz;
+}
+
+static int clusterized_message(struct dm_exception_store *store,
+			       unsigned argc, char **argv)
+{
+	int r;
+	struct clusterized_c *cc = store->context;
+
+	cluster_lock(cc, DLM_LOCK_EX);
+
+	r = cc->core_store->type->message(cc->core_store, argc, argv);
+
+	cc->metadata_counter++;
+	cc->cluster_metadata_counter = cc->metadata_counter;
+	cluster_unlock(cc);
+
+	return r;
+}
+
+/*
+ * Here is where we define what core exception store types are
+ * valid for this module to clusterize.  The necessary qualities
+ * of the core exception store are:
+ *	1) Must be able to resume multiple times (i.e. re-read
+ *	   its metadata).  This is because other nodes are allowed
+ *	   to add/alter the metadata underneath you.  Ideally, only
+ *	   the delta's will be picked up when the metadata is
+ *	   re-read - as is the case with the "persistent" store.
+ *	*2) Must not be a "shared" exception store.  IOW, the alteration
+ *	   of one exception store cannot affect another.  Currently, this
+ *	   situation is not adequately handled (but could be handled if
+ *	   people really want it).
+ *
+ * If the above conditions are met, then you can simply add an addtional
+ * 'dm_exception_store_type' below.  In fact, you could copy the block of
+ * code that is there and replace 'persistent' with the name of the
+ * exception store type that is being covered.
+ */
+static struct dm_exception_store_type _clusterized_persistent = {
+	.name = "clusterized-persistent",
+	.module = THIS_MODULE,
+	.ctr = clusterized_ctr,
+	.dtr = clusterized_dtr,
+	.resume = clusterized_resume,
+	.presuspend = clusterized_presuspend,
+	.postsuspend = clusterized_postsuspend,
+	.prepare_exception = clusterized_prepare_exception,
+	.commit_exception = clusterized_commit_exception,
+	.lookup_exception = clusterized_lookup_exception,
+	.fraction_full = clusterized_fraction_full,
+	.status = clusterized_status,
+	.message = clusterized_message,
+};
+
+static int __init dm_clusterized_exception_store_init(void)
+{
+	int r;
+
+	r = dm_exception_store_type_register(&_clusterized_persistent);
+	if (r)
+		DMERR("Unable to register clusterized-persistent"
+		      " exception store type: %d", r);
+	else
+		DMINFO("(built %s %s) installed", __DATE__, __TIME__);
+
+	return r;
+}
+
+static void __exit dm_clusterized_exception_store_exit(void)
+{
+	dm_exception_store_type_unregister(&_clusterized_persistent);
+	DMINFO("(built %s %s) removed", __DATE__, __TIME__);
+}
+
+module_init(dm_clusterized_exception_store_init);
+module_exit(dm_clusterized_exception_store_exit);
+
+MODULE_DESCRIPTION(DM_MSG_PREFIX);
+MODULE_AUTHOR("Jonathan Brassow <jbrassow@redhat.com>");
+MODULE_LICENSE("GPL");
