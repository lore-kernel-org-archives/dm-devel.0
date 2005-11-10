From: "goggin, edward" <egoggin@emc.com>
Subject: patch to dm.c to delay add_disk call for new mapped
	device till a fter device's map is loaded
Date: Thu, 10 Nov 2005 13:53:53 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADD9@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Patch to dm.c to delay the add_disk call for a newly created mapped device
until after the mapped device's map is loaded for the first time in dev_load
so that an a hotplug/uevent handler will not fail to acquire information
about
the mapped device's map.

--- ../base/linux-2.6.14-rc4/drivers/md/dm.c	2005-10-10
20:19:19.000000000 -0500
+++ drivers/md/dm.c	2005-11-09 03:22:05.000000000 -0600
@@ -55,6 +55,7 @@ union map_info *dm_get_mapinfo(struct bi
  */
 #define DMF_BLOCK_IO 0
 #define DMF_SUSPENDED 1
+#define DMF_ADDED 2
 
 struct mapped_device {
 	struct rw_semaphore io_lock;
@@ -790,7 +791,6 @@ static struct mapped_device *alloc_dev(u
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
-	add_disk(md->disk);
 
 	atomic_set(&md->pending, 0);
 	init_waitqueue_head(&md->wait);
@@ -810,12 +810,31 @@ static struct mapped_device *alloc_dev(u
 	return NULL;
 }
 
+/*
+ * Intended to be called only after the mapped device's map/table
+ * has been loaded for the first time so that hotplug/uevent handlers
+ * handlers do not fail.
+ */
+void dm_add_disk(struct mapped_device *md)
+{
+	if (test_bit(DMF_ADDED, &md->flags) == 0) {
+		set_bit(DMF_ADDED, &md->flags);
+		add_disk(md->disk);
+	}
+}
+
 static void free_dev(struct mapped_device *md)
 {
 	free_minor(md->disk->first_minor);
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
-	del_gendisk(md->disk);
+
+	/*
+	 * add_disk is now conditional -- dev without a map is not added
+	 */
+	if (test_bit(DMF_ADDED, &md->flags))
+		del_gendisk(md->disk);
+
