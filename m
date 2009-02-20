From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 17 of 17]
	dm-exception-store-clusterized-type.patch
Date: Fri, 20 Feb 2009 17:37:35 -0600
Message-ID: <1235173055.24593.54.camel@hydrogen.msp.redhat.com>
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

This patch provides an exception store implementation that is
capable of "wrapping" other exception store implementations and
making them cluster-aware.  It is not a stand-alone implementation.
It merely uses distributed locking to protect exception store
metadata as the single-machine "core" exception stores perform
their actions independently.  This is why the module uses the
term "clusterized" instead of "clustered".  This is just a toy
right now.  I'm not sure how it will perform - I have more
optimizations to do yet.  I'm mostly providing it as a POC and
to show the cool things you can do with the new exception store
API.

Not-yet-for-inclusion-consideration: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -244,10 +244,23 @@ config DM_CRYPT
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
+
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
 
 config DM_MIRROR
        tristate "Mirror target"
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -7,6 +7,7 @@ dm-mod-objs	:= dm.o dm-table.o dm-target
 dm-multipath-objs := dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception.o dm-exception-store.o \
 		    dm-snap-persistent.o dm-snap-transient.o
+dm-exstore-clusterized-objs := dm-ex-store-clusterized.o
 dm-mirror-objs	:= dm-raid1.o
 dm-log-clustered-objs := dm-log-cluster.o dm-log-cluster-transfer.o
 md-mod-objs     := md.o bitmap.o
@@ -36,6 +37,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
+obj-$(CONFIG_DM_EXSTORE_CLUSTERIZED) += dm-exstore-clusterized.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_CLUSTERED)	+= dm-log-clustered.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
Index: linux-2.6/drivers/md/dm-ex-store-clusterized.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-ex-store-clusterized.c
@@ -0,0 +1,441 @@
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
+	struct completion completion;
+
+	int current_lock_mode;
+	dlm_lockspace_t *lockspace;
+	struct dlm_lksb lksb;
+
+	uint64_t metadata_counter;
+	uint64_t cluster_metadata_counter;
+
+	char uuid[0]; /* must be last */
+};
+
+static void lock_obtained(void *context)
+{
+	struct clusterized_c *cc = context;
+
+	complete(&cc->completion);
+}
+
+static int cluster_lock(struct clusterized_c *cc, int mode)
+{
+	int r;
+	uint32_t flags = DLM_LKF_VALBLK;
+
+	if (mode == DLM_LOCK_NL)
+		flags |= DLM_LKF_EXPEDITE;
+	else
+		flags |= DLM_LKF_CONVERT;
+
+	r = dlm_lock(cc->lockspace, mode, &cc->lksb,
+		     flags, cc->uuid, strlen(cc->uuid), 0,
+		     lock_obtained, cc, NULL);
+
+	if (r)
+		return r;
+
+	wait_for_completion(&cc->completion);
+
+	if (cc->lksb.sb_status)
+		return -EAGAIN; /* not entirely true for unlock ops */
+
+	cc->current_lock_mode = mode;
+	return 0;
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
+	uint32_t flags = DLM_LKF_VALBLK;
+
+	if (cc->current_lock_mode == DLM_LOCK_NL) {
+		dlm_unlock(cc->lockspace, cc->lksb.sb_lkid,
+			   DLM_LKF_FORCEUNLOCK, &cc->lksb, cc);
+		/* FIXME: do I need wait_for_completion? */
+		return 0;
+	}
+
+	flags |= DLM_LKF_EXPEDITE;
+	flags |= DLM_LKF_CONVERT;
+
+	if (cc->current_lock_mode == DLM_LOCK_EX) {
+		/* FIXME: endian issues? */
+		if (cc->metadata_counter != cc->cluster_metadata_counter)
+			cc->cluster_metadata_counter = cc->metadata_counter;
+	}
+
+	r = dlm_lock(cc->lockspace, DLM_LOCK_NL, &cc->lksb,
+		     flags, cc->uuid, strlen(cc->uuid), 0,
+		     lock_obtained, cc, NULL);
+
+	if (r)
+		return r;
+
+	wait_for_completion(&cc->completion);
+
+	if (cc->lksb.sb_status)
+		return -EAGAIN; /* not entirely true for unlock ops */
+
+	return 0;
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
+	init_completion(&cc->completion);
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
+
+	r = cluster_lock(cc, DLM_LOCK_NL);
+
+	/*
+	 * Now we find the non-clustered exception store name.
+	 * It will be whatever is left when we strip 'clusterized_' off.
+	 */
+	core_name = strstr(store->type->name, "_");
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
+	store->context = cc;
+
+	return 0;
+}
+
+static void clusterized_dtr(struct dm_exception_store *store)
+{
+	struct clusterized_c *cc = store->context;
+
+	cc->core_store->type->dtr(cc->core_store);
+	cluster_unlock(cc);
+	dlm_release_lockspace(cc->lockspace, 1);
+	kfree(cc);
+}
+
+static int clusterized_resume(struct dm_exception_store *store)
+{
+	int r;
+	struct clusterized_c *cc = store->context;
+
+	cluster_lock(cc, DLM_LOCK_CR);
+	r = cc->core_store->type->resume(cc->core_store);
+	cc->metadata_counter = cc->cluster_metadata_counter;
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
+					 struct dm_exception *e)
+{
+	int r;
+	struct clusterized_c *cc = store->context;
+
+	cluster_lock(cc, DLM_LOCK_EX);
+	r = cc->core_store->type->prepare_exception(cc->core_store, e);
+	if (r)
+		cluster_unlock(cc);
+
+	return r;
+}
+
+static void clusterized_commit_exception(struct dm_exception_store *store,
+					 struct dm_exception *e,
+					 void (*callback) (void *, int success),
+					 void *callback_context)
+{
+	struct clusterized_c *cc = store->context;
+
+	cc->core_store->type->commit_exception(cc->core_store, e, callback,
+					       callback_context);
+
+	cc->metadata_counter++;
+	cluster_unlock(cc);
+}
+
+/*
+ * clusterized_lookup_exception
+ * @store
+ * @chunk
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
+ * Returns: (dm_exception *) if found, otherwise NULL
+ */
+static int clusterized_lookup_exception(struct dm_exception_store *store,
+					struct dm_exception **e,
+					chunk_t chunk, int can_block)
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
+	r = cc->core_store->type->lookup_exception(cc->core_store, e,
+						   chunk, can_block);
+
+	/* If we found the exception or there was an error, we can return */
+	if (r || *e)
+		return r;
+
+	/* We block when we aquire the DLM lock - respect !can_block */
+	if (!can_block)
+		return -EWOULDBLOCK;
+
+	cluster_lock(cc, DLM_LOCK_CR);
+
+	/* If "shared" exception store is used, we would skip this test */
+	if (cc->cluster_metadata_counter == cc->metadata_counter) {
+		/*
+		 * Exception was not found, and the metadata was not
+		 * changed by other node.
+		 */
+		cluster_unlock(cc);
+		return 0;
+	}
+
+	/*
+	 * The core exception store's resume method must be capable of
+	 * re-reading its metadata and updating its cache.  IOW, it must
+	 * be able to resume multiple times before a suspend is issued.
+	 */
+	cc->core_store->type->resume(cc->core_store);
+
+	cluster_unlock(cc);
+
+	/* Now, try to find the exception again. */
+	r = cc->core_store->type->lookup_exception(cc->core_store, e,
+						   chunk, can_block);
+	return r;
+}
+
+static int clusterized_modify_exception_store(struct dm_exception_store *store,
+					      uint64_t action)
+{
+	int r;
+	struct clusterized_c *cc = store->context;
+
+	cluster_lock(cc, DLM_LOCK_EX);
+
+	r = cc->core_store->type->modify_exception_store(cc->core_store, action);
+
+	cc->metadata_counter++;
+	cluster_unlock(cc);
+
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
+static int clusterized_status(struct dm_exception_store *store,
+			      status_type_t status, char *result,
+			      unsigned int maxlen)
+{
+	int sz = 0;
+	struct clusterized_c *cc = store->context;
+
+	switch(status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		sz = cc->core_store->type->status(cc->core_store, status,
+						  result, maxlen);
+		DMEMIT(" cluster_uuid:%s", cc->uuid);
+	}
+
+	return sz;
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
+        .name = "clusterized_persistent",
+        .module = THIS_MODULE,
+        .ctr = clusterized_ctr,
+        .dtr = clusterized_dtr,
+        .resume = clusterized_resume,
+	.presuspend = clusterized_presuspend,
+	.postsuspend = clusterized_postsuspend,
+        .prepare_exception = clusterized_prepare_exception,
+        .commit_exception = clusterized_commit_exception,
+	.lookup_exception = clusterized_lookup_exception,
+        .modify_exception_store = clusterized_modify_exception_store,
+        .fraction_full = clusterized_fraction_full,
+        .status = clusterized_status,
+};
+
+static int __init dm_clusterized_exception_store_init(void)
+{
+	int r;
+
+	r = dm_exception_store_type_register(&_clusterized_persistent);
+	if (!r)
+		DMERR("Unable to register clusterized_persistent"
+		      " exception store type");
+
+	return r;
+}
+
+static void __exit dm_clusterized_exception_store_exit(void)
+{
+	dm_exception_store_type_unregister(&_clusterized_persistent);
+}
+
+module_init(dm_clusterized_exception_store_init);
+module_exit(dm_clusterized_exception_store_exit);
+
+MODULE_DESCRIPTION(DM_MSG_PREFIX);
+MODULE_AUTHOR("Jonathan Brassow <jbrassow@redhat.com>");
+MODULE_LICENSE("GPL");
