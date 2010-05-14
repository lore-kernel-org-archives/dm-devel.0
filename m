From: Will Drewry <wad@chromium.org>
Subject: [RFC PATCH] dm: allow a dm-fs-style device to be shared
 via dm-ioctl
Date: Thu, 13 May 2010 20:39:40 -0500
Message-ID: <20100514013940.GA3523@z600>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Following on the discussion of booting directly to a device-mapper
device, two things were made clear:
1. The ioctl interface's name and uuid are mandatory for udev to work
2. There is a functional gap between the dm(-fs) and dm-ioctl

This change adds one function which is used for binding a given mapped
device to a name+uuid in the dm-ioctl hash table.  In addition, it
ensures that public functions are available that allow mapped devices
and tables to be created and associated with shared code paths in
dm-ioctl:
- suspend flags and block integrity registration are now exposed
- dm_table_complete() now prepares a table for use completely
  (builds the btree; sets the type; allocates md pools)

Ideally, this lays the groundwork for any kernel code to create fully
functional mapped devices, but I'd appreciate feedback on if this
approach makes sense/is safe, preferred function names, and if it
integrates with the current direction.

(I can also pair this with the init code patch if it makes sense to show
consumer code.)

Signed-off-by: Will Drewry <wad@chromium.org>
---
 drivers/md/dm-ioctl.c         |   66 ++++++++++++++++++++++++-----------------
 drivers/md/dm-table.c         |   44 ++++++++++++++++++++++++++-
 include/linux/device-mapper.h |   17 ++++++++++
 3 files changed, 99 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..8dc5fd8 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1112,28 +1112,9 @@ static int populate_table(struct dm_table *table,
 		next = spec->next;
 	}
 
-	r = dm_table_set_type(table);
-	if (r) {
-		DMWARN("unable to set table type");
-		return r;
-	}
-
 	return dm_table_complete(table);
 }
 
-static int table_prealloc_integrity(struct dm_table *t,
-				    struct mapped_device *md)
-{
-	struct list_head *devices = dm_table_get_devices(t);
-	struct dm_dev_internal *dd;
-
-	list_for_each_entry(dd, devices, list)
-		if (bdev_get_integrity(dd->dm_dev.bdev))
-			return blk_integrity_register(dm_disk(md), NULL);
-
-	return 0;
-}
-
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
@@ -1155,7 +1136,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
-	r = table_prealloc_integrity(t, md);
+	r = dm_table_prealloc_integrity(t, md);
 	if (r) {
 		DMERR("%s: could not register integrity profile.",
 		      dm_device_name(md));
@@ -1163,13 +1144,6 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
-	r = dm_table_alloc_md_mempools(t);
-	if (r) {
-		DMWARN("unable to allocate mempools for this table");
-		dm_table_destroy(t);
-		goto out;
-	}
-
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
@@ -1637,6 +1611,44 @@ void dm_interface_exit(void)
 	dm_hash_exit();
 }
 
+
+/**
+ * dm_ioctl_export - Permanently export a mapped device via the ioctl interface
+ * @md: Pointer to mapped_device
+ * @name: Buffer (size DM_NAME_LEN) for name
+ * @uuid: Buffer (size DM_UUID_LEN) for uuid or NULL if not desired
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name, const char *uuid)
+{
+	int r = 0;
+	struct hash_cell *hc;
+
+	if (!md) {
+		r = -ENXIO;
+		goto out;
+	}
+
+	/* The name and uuid can only be set once. */
+	mutex_lock(&dm_hash_cells_mutex);
+	hc = dm_get_mdptr(md);
+	mutex_unlock(&dm_hash_cells_mutex);
+	if (hc) {
+		DMERR("%s: already exported", dm_device_name(md));
+		r = -ENXIO;
+		goto out;
+	}
+
+	r = dm_hash_insert(name, uuid, md);
+	if (r) {
+		DMERR("%s: could not export as '%s'", dm_device_name(md), name);
+		goto out;
+	}
+
+	/* Let udev know we've changed. */
+	dm_kobject_uevent(md, KOBJ_CHANGE, dm_get_event_nr(md));
+out:
+	return r;
+}
 /**
  * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
  * @md: Pointer to mapped_device
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..66726d1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -900,7 +900,7 @@ static int setup_indexes(struct dm_table *t)
 /*
  * Builds the btree to index the map.
  */
-int dm_table_complete(struct dm_table *t)
+int dm_table_build_index(struct dm_table *t)
 {
 	int r = 0;
 	unsigned int leaf_nodes;
@@ -919,6 +919,48 @@ int dm_table_complete(struct dm_table *t)
 	return r;
 }
 
+
+/*
+ * Prepares the table for use by building the indices,
+ * setting the type, and allocating mempools.
+ */
+int dm_table_complete(struct dm_table *t)
+{
+	int r = 0;
+	
+	r = dm_table_build_index(t);
+	if (r) {
+		DMWARN("unable to build btrees");
+		return r;
+	}
+	r = dm_table_set_type(t);
+	if (r) {
+		DMWARN("unable to set table type");
+		return r;
+	}
+	r = dm_table_alloc_md_mempools(t);
+	if (r)
+		DMWARN("unable to allocate mempools");
+
+	return r;
+}
+
+/*
+ * Register the mapped device for blk_integrity support if
+ * the underlying devices support it.
+ */
+int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device *md)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *dd;
+
+	list_for_each_entry(dd, devices, list)
+		if (bdev_get_integrity(dd->dm_dev.bdev))
+			return blk_integrity_register(dm_disk(md), NULL);
+
+	return 0;
+}
+
 static DEFINE_MUTEX(_event_lock);
 void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1381cd9..95fea4c 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
 void *dm_get_mdptr(struct mapped_device *md);
 
 /*
+ * Export the device via the ioctl interface
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name,
+		    const char *uuid);
+
+/*
+ * Suspend feature flags
+ */
+#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
+#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
+
+/*
  * A device can still be used while suspended, but I/O is deferred.
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
@@ -268,6 +280,11 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 int dm_table_complete(struct dm_table *t);
 
 /*
+ * Optionally add support for block integrity.
+ */
+int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device *md);
+
+/*
  * Unplug all devices in a table.
  */
 void dm_table_unplug_all(struct dm_table *t);
-- 
1.6.6.1
