From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/3] dm: Add support to poll for dm events
Date: Mon,  9 Jan 2017 10:20:39 -0800
Message-ID: <20170109182040.31337-3-agrover@redhat.com>
References: <20170109182040.31337-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170109182040.31337-1-agrover@redhat.com>
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
List-Id: dm-devel.ids

Instead of requiring a thread for each device to sleep in ioctl(DEV_WAIT)
to receive dm events, allow a single thread to:

1) Open /dev/mapper/control multiple times
2) Associate each of these open file descriptors with different DM devices
3) poll() on all of these
4) When an event occurs, use TABLE_STATUS ioctl to get device's state

This requires:

a) Implementing open, release, and poll file operations
b) Defining a per-file context struct called dm_file
c) Adding a new DEV_ASSOC ioctl to associate a file with a single dm device
d) Handle if fd w/association is closed or referenced device is destroyed

Associating a fd with a device for polling limits the use of other
ioctls besides VERSION, using that fd. There is no mechanism to query
associations, userspace must track this itself.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-core.h          | 10 +++++
 drivers/md/dm-ioctl.c         | 98 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.c               | 12 ++++++
 include/uapi/linux/dm-ioctl.h |  6 ++-
 4 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 40ceba1..8aeb292 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -24,6 +24,12 @@ struct dm_kobject_holder {
 	struct completion completion;
 };
 
+struct dm_file {
+	struct mapped_device *md;
+	uint32_t event_nr;
+	struct list_head assoc_files_node;
+};
+
 /*
  * DM core internal structure that used directly by dm.c and dm-rq.c
  * DM targets must _not_ deference a mapped_device to directly access its members!
@@ -80,6 +86,10 @@ struct mapped_device {
 	struct list_head uevent_list;
 	spinlock_t uevent_lock; /* Protect access to uevent_list */
 
+	/* Track the fds set to track this device */
+	struct mutex assoc_files_list_lock;
+	struct list_head assoc_files_list;
+
 	/* the number of internal suspends */
 	unsigned internal_suspend_count;
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 17c9bf9..c5fc53c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1207,6 +1207,45 @@ static int dev_wait(struct file *filp, struct dm_ioctl *param, size_t param_size
 	return r;
 }
 
+/*
+ * Associates a given open file with a specific mapped device.
+ * This lets the file be used to poll for events on the device.
+ */
+static int dev_assoc_set(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	struct dm_file *priv = filp->private_data;
+	struct mapped_device *md;
+
+	/* Can only associate once */
+	if (priv)
+		return -EINVAL;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&priv->assoc_files_node);
+
+	md = find_device(param);
+	if (!md) {
+		kfree(priv);
+		return -ENXIO;
+	}
+
+	priv->md = md;
+	priv->event_nr = dm_get_event_nr(priv->md);
+
+	mutex_lock(&md->assoc_files_list_lock);
+	list_add_tail(&priv->assoc_files_node, &md->assoc_files_list);
+	mutex_unlock(&md->assoc_files_list_lock);
+
+	filp->private_data = priv;
+
+	/* No dm_put(), we're keeping a reference to the mapped_device */
+
+	return 0;
+}
+
 static inline fmode_t get_mode(struct dm_ioctl *param)
 {
 	fmode_t mode = FMODE_READ | FMODE_WRITE;
@@ -1635,7 +1674,8 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 		{DM_LIST_VERSIONS_CMD, 0, list_versions},
 
 		{DM_TARGET_MSG_CMD, 0, target_message},
-		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry}
+		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry},
+		{DM_DEV_ASSOC_CMD, IOCTL_FLAGS_NO_PARAMS, dev_assoc_set},
 	};
 
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
@@ -1828,6 +1868,13 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	if (cmd == DM_VERSION_CMD)
 		return 0;
 
+	/*
+	 * Cannot use files that have been associated for most ioctls.
+	 * See dev_assoc_set().
+	 */
+	if (file->private_data)
+		return -EINVAL;
+
 	fn = lookup_ioctl(cmd, &ioctl_flags);
 	if (!fn) {
 		DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
@@ -1879,8 +1926,55 @@ static long dm_compat_ctl_ioctl(struct file *file, uint command, ulong u)
 #define dm_compat_ctl_ioctl NULL
 #endif
 
+int dm_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = NULL;
+	return nonseekable_open(inode, filp);
+}
+
+int dm_release(struct inode *inode, struct file *filp)
+{
+	struct dm_file *priv = filp->private_data;
+
+	if (priv->md) {
+		mutex_lock(&priv->md->assoc_files_list_lock);
+		list_del(&priv->assoc_files_node);
+		mutex_unlock(&priv->md->assoc_files_list_lock);
+
+		dm_put(priv->md);
+	}
+
+	kfree(priv);
+
+	return 0;
+}
+
+static unsigned int dm_poll(struct file *filp, poll_table *wait)
+{
+	struct dm_file *priv = filp->private_data;
+	unsigned int mask = 0;
+	uint32_t cur_event;
+
+	/* fd has not been associated with a device with DEV_EVENT_SET */
+	if (!priv->md)
+		return 0;
+
+	poll_wait(filp, &priv->md->eventq, wait);
+
+	cur_event = dm_get_event_nr(priv->md);
+
+	if (priv->event_nr < cur_event) {
+		priv->event_nr = cur_event;
+		mask |= POLLIN;
+	}
+
+	return mask;
+}
+
 static const struct file_operations _ctl_fops = {
-	.open = nonseekable_open,
+	.open    = dm_open,
+	.release = dm_release,
+	.poll    = dm_poll,
 	.unlocked_ioctl	 = dm_ctl_ioctl,
 	.compat_ioctl = dm_compat_ctl_ioctl,
 	.owner	 = THIS_MODULE,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5..e847094 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1489,6 +1489,8 @@ static struct mapped_device *alloc_dev(int minor)
 	INIT_LIST_HEAD(&md->uevent_list);
 	INIT_LIST_HEAD(&md->table_devices);
 	spin_lock_init(&md->uevent_lock);
+	mutex_init(&md->assoc_files_list_lock);
+	INIT_LIST_HEAD(&md->assoc_files_list);
 
 	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id);
 	if (!md->queue)
@@ -1878,6 +1880,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	struct request_queue *q = dm_get_md_queue(md);
 	struct dm_table *map;
 	int srcu_idx;
+	struct dm_file *dm_f, *tmp;
 
 	might_sleep();
 
@@ -1905,6 +1908,15 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	dm_put_live_table(md, srcu_idx);
 	mutex_unlock(&md->suspend_lock);
 
+	/* Disassociate event fds linked to this md */
+	mutex_lock(&md->assoc_files_list_lock);
+	list_for_each_entry_safe(dm_f, tmp, &md->assoc_files_list, assoc_files_node) {
+		dm_f->md = NULL;
+		dm_f->event_nr = 0;
+		list_del(&dm_f->assoc_files_node);
+	}
+	mutex_unlock(&md->assoc_files_list_lock);
+
 	/*
 	 * Rare, but there may be I/O requests still going to complete,
 	 * for example.  Wait for all references to disappear.
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 4bf9f1e..b3731b8 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -240,7 +240,8 @@ enum {
 	/* Added later */
 	DM_LIST_VERSIONS_CMD,
 	DM_TARGET_MSG_CMD,
-	DM_DEV_SET_GEOMETRY_CMD
+	DM_DEV_SET_GEOMETRY_CMD,
+	DM_DEV_ASSOC_CMD,
 };
 
 #define DM_IOCTL 0xfd
@@ -255,6 +256,7 @@ enum {
 #define DM_DEV_SUSPEND   _IOWR(DM_IOCTL, DM_DEV_SUSPEND_CMD, struct dm_ioctl)
 #define DM_DEV_STATUS    _IOWR(DM_IOCTL, DM_DEV_STATUS_CMD, struct dm_ioctl)
 #define DM_DEV_WAIT      _IOWR(DM_IOCTL, DM_DEV_WAIT_CMD, struct dm_ioctl)
+#define DM_DEV_ASSOC     _IOWR(DM_IOCTL, DM_DEV_ASSOC_CMD, struct dm_ioctl)
 
 #define DM_TABLE_LOAD    _IOWR(DM_IOCTL, DM_TABLE_LOAD_CMD, struct dm_ioctl)
 #define DM_TABLE_CLEAR   _IOWR(DM_IOCTL, DM_TABLE_CLEAR_CMD, struct dm_ioctl)
@@ -267,7 +269,7 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	35
+#define DM_VERSION_MINOR	36
 #define DM_VERSION_PATCHLEVEL	0
 #define DM_VERSION_EXTRA	"-ioctl (2016-06-23)"
 
-- 
2.9.3
