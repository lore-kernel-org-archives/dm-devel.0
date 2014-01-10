From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: wait until kobject is destroyed
Date: Thu, 9 Jan 2014 20:53:18 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401092050190.31354@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending the updated kobject patch.

Changes:
	The file was renamed to dm-builtin.c
	A comment with explanation of the race condition added.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

There may be other parts of the kernel taking reference to the dm kobject.
We must wait until they drop the references before deallocating the md
structure.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/Kconfig      |    4 ++++
 drivers/md/Makefile     |    1 +
 drivers/md/dm-builtin.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-sysfs.c   |    5 ++++-
 drivers/md/dm.c         |    9 +++++----
 drivers/md/dm.h         |   15 +++++++++++++++
 6 files changed, 77 insertions(+), 5 deletions(-)

Index: linux-3.13-rc7/drivers/md/dm-sysfs.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-sysfs.c	2014-01-09 20:50:18.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-sysfs.c	2014-01-09 20:50:38.000000000 +0100
@@ -86,6 +86,7 @@ static const struct sysfs_ops dm_sysfs_o
 static struct kobj_type dm_ktype = {
 	.sysfs_ops	= &dm_sysfs_ops,
 	.default_attrs	= dm_attrs,
+	.release	= dm_kobject_release,
 };
 
 /*
@@ -104,5 +105,7 @@ int dm_sysfs_init(struct mapped_device *
  */
 void dm_sysfs_exit(struct mapped_device *md)
 {
-	kobject_put(dm_kobject(md));
+	struct kobject *kobj = dm_kobject(md);
+	kobject_put(kobj);
+	wait_for_completion(dm_get_completion_from_kobject(kobj));
 }
Index: linux-3.13-rc7/drivers/md/dm.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm.c	2014-01-09 20:50:18.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm.c	2014-01-09 20:50:38.000000000 +0100
@@ -200,8 +200,8 @@ struct mapped_device {
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
-	/* sysfs handle */
-	struct kobject kobj;
+	/* kobject and completion */
+	struct dm_kobject_holder h;
 
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
@@ -2049,6 +2049,7 @@ static struct mapped_device *alloc_dev(i
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
+	init_completion(&md->h.completion);
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2910,7 +2911,7 @@ struct gendisk *dm_disk(struct mapped_de
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-	return &md->kobj;
+	return &md->h.kobj;
 }
 
 /*
@@ -2921,7 +2922,7 @@ struct mapped_device *dm_get_from_kobjec
 {
 	struct mapped_device *md;
 
-	md = container_of(kobj, struct mapped_device, kobj);
+	md = container_of(kobj, struct mapped_device, h.kobj);
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md))
Index: linux-3.13-rc7/drivers/md/dm.h
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm.h	2014-01-09 20:50:18.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm.h	2014-01-09 20:50:38.000000000 +0100
@@ -15,6 +15,8 @@
 #include <linux/list.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/completion.h>
+#include <linux/kobject.h>
 
 #include "dm-stats.h"
 
@@ -148,12 +150,25 @@ void dm_interface_exit(void);
 /*
  * sysfs interface
  */
+struct dm_kobject_holder {
+	struct kobject kobj;
+	struct completion completion;
+};
+static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
+{
+	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
+}
 int dm_sysfs_init(struct mapped_device *md);
 void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
 
 /*
+ * The kobject helper
+ */
+void dm_kobject_release(struct kobject *kobj);
+
+/*
  * Targets for linear and striped mappings
  */
 int dm_linear_init(void);
Index: linux-3.13-rc7/drivers/md/Kconfig
===================================================================
--- linux-3.13-rc7.orig/drivers/md/Kconfig	2014-01-09 20:50:18.000000000 +0100
+++ linux-3.13-rc7/drivers/md/Kconfig	2014-01-09 22:49:28.000000000 +0100
@@ -176,8 +176,12 @@ config MD_FAULTY
 
 source "drivers/md/bcache/Kconfig"
 
+config BLK_DEV_DM_BUILTIN
+	boolean
+
 config BLK_DEV_DM
 	tristate "Device mapper support"
+	select BLK_DEV_DM_BUILTIN
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
Index: linux-3.13-rc7/drivers/md/Makefile
===================================================================
--- linux-3.13-rc7.orig/drivers/md/Makefile	2014-01-09 20:50:18.000000000 +0100
+++ linux-3.13-rc7/drivers/md/Makefile	2014-01-09 22:49:37.000000000 +0100
@@ -32,6 +32,7 @@ obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BCACHE)		+= bcache/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
+obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
Index: linux-3.13-rc7/drivers/md/dm-builtin.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.13-rc7/drivers/md/dm-builtin.c	2014-01-09 22:56:17.000000000 +0100
@@ -0,0 +1,48 @@
+#include "dm.h"
+
+/*
+ * The kobject release method must not be placed in the module itself,
+ * otherwise we are subject to module unload races.
+ *
+ * The release method is called when the last reference to the kobject is
+ * dropped. It may be called by any other kernel code that drops the last
+ * reference.
+ *
+ * The release method suffers from module unload race. We may prevent the
+ * module from being unloaded at the start of the release method (using
+ * increased module reference count or synchronizing against the release
+ * method), however there is no way to prevent the module from being
+ * unloaded at the end of the release method.
+ *
+ * If this code were placed in the dm module, the following race may
+ * happen:
+ *  1. Some other process takes a reference to dm kobject
+ *  2. The user issues ioctl function to unload the dm device
+ *  3. dm_sysfs_exit calls kobject_put, however the object is not released
+ *     because of the other reference taken at step 1
+ *  4. dm_sysfs_exit waits on the completion
+ *  5. The other process that took the reference in step 1 drops it,
+ *     dm_kobject_release is called from this process
+ *  6. dm_kobject_release calls complete()
+ *  7. a reschedule happens before dm_kobject_release returns
+ *  8. dm_sysfs_exit continues, the dm device is unloaded, module reference
+ *     count is decremented
+ *  9. The user unloads the dm module
+ * 10. The other process that was rescheduled in step 7 continues to run,
+ *     it is now executing code in unloaded module, so it crashes
+ *
+ * Note that if the process that takes the foreign reference to dm kobject
+ * has a low priority and the system is sufficiently loaded with
+ * higher-priority processes that prevent the low-priority process from
+ * being scheduled long enough, this bug may really happen.
+ *
+ * In order to fix this module unload race, we place the release method
+ * into a helper code that is compiled directly into the kernel.
+ */
+
+void dm_kobject_release(struct kobject *kobj)
+{
+	complete(dm_get_completion_from_kobject(kobj));
+}
+
+EXPORT_SYMBOL(dm_kobject_release);
