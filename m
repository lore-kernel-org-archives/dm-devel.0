From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2] Re: dm: wait until kobject is destroyed
Date: Mon, 13 Jan 2014 19:37:54 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401131932130.30362@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401092050190.31354@file01.intranet.prod.int.rdu2.redhat.com>
	<20140110210314.GA12660@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140110210314.GA12660@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 10 Jan 2014, Mike Snitzer wrote:

> On Thu, Jan 09 2014 at  8:53pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > Here I'm sending the updated kobject patch.
> > 
> > Changes:
> > 	The file was renamed to dm-builtin.c
> > 	A comment with explanation of the race condition added.
> > 
> > Mikulas
> > 
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > There may be other parts of the kernel taking reference to the dm kobject.
> > We must wait until they drop the references before deallocating the md
> > structure.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> 
> This header could use some work considering the previous patch is
> already staged in linux-dm.git's 'for-next' -- so this patch will build
> on that.  Would be nice to see some commentary about introducing a
> dm-builtin to avoid concerns about dm_kobject_release crash after dm-mod
> is unloaded.  Also, touch on the role/need of struct dm_kobject_holder?
> 
> Could you rename 'h' to 'kobj_holder'?
> 
> Also, this patch needs to be rebased ontop of linux-dm.git's 'for-next'
> branch.
> 
> Mike

Here I'm sending the updated patch. (it reverts the patch that is already 
in git and applies the new patch). The patch is untested, because I don't 
use that git branch, but the same code was tested on Linus' 3.13-rc7.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

dm-sysfs: fix a module unload race

The code that calls the completion must be placed in non-module file,
otherwise there is a module unload race (if the process is preempted and
module unloaded after the completion is triggered, but before the function
returns).

To fix this race, this patch moves the completion code to dm-builtin.c
that is always compiled directly to the kernel.

The patch introduces a new structure struct dm_kobject_holder, its purpose
is to keep the completion and the kobject at one place, so that it can be
accessed from non-module code without the need to export the layout of
struct mapped_device to that code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/Kconfig      |    4 ++++
 drivers/md/Makefile     |    1 +
 drivers/md/dm-builtin.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-sysfs.c   |    5 -----
 drivers/md/dm.c         |   20 +++++---------------
 drivers/md/dm.h         |   15 ++++++++++++++-
 6 files changed, 72 insertions(+), 21 deletions(-)

Index: linux-dm/drivers/md/dm-sysfs.c
===================================================================
--- linux-dm.orig/drivers/md/dm-sysfs.c	2014-01-14 01:24:49.000000000 +0100
+++ linux-dm/drivers/md/dm-sysfs.c	2014-01-14 01:25:13.000000000 +0100
@@ -79,11 +79,6 @@ static const struct sysfs_ops dm_sysfs_o
 	.show	= dm_attr_show,
 };
 
-static void dm_kobject_release(struct kobject *kobj)
-{
-	complete(dm_get_completion_from_kobject(kobj));
-}
-
 /*
  * dm kobject is embedded in mapped_device structure
  * no need to define release function here
Index: linux-dm/drivers/md/dm.c
===================================================================
--- linux-dm.orig/drivers/md/dm.c	2014-01-14 01:24:49.000000000 +0100
+++ linux-dm/drivers/md/dm.c	2014-01-14 01:25:13.000000000 +0100
@@ -200,11 +200,8 @@ struct mapped_device {
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
-	/* sysfs handle */
-	struct kobject kobj;
-
-	/* wait until the kobject is released */
-	struct completion kobj_completion;
+	/* kobject and completion */
+	struct dm_kobject_holder kobj_holder;
 
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
@@ -2044,7 +2041,7 @@ static struct mapped_device *alloc_dev(i
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
-	init_completion(&md->kobj_completion);
+	init_completion(&md->kobj_holder.completion);
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2906,14 +2903,14 @@ struct gendisk *dm_disk(struct mapped_de
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-	return &md->kobj;
+	return &md->kobj_holder.kobj;
 }
 
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
 {
 	struct mapped_device *md;
 
-	md = container_of(kobj, struct mapped_device, kobj);
+	md = container_of(kobj, struct mapped_device, kobj_holder.kobj);
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md))
@@ -2923,13 +2920,6 @@ struct mapped_device *dm_get_from_kobjec
 	return md;
 }
 
-struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
-{
-	struct mapped_device *md = container_of(kobj, struct mapped_device, kobj);
-
-	return &md->kobj_completion;
-}
-
 int dm_suspended_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
Index: linux-dm/drivers/md/dm.h
===================================================================
--- linux-dm.orig/drivers/md/dm.h	2014-01-14 01:24:49.000000000 +0100
+++ linux-dm/drivers/md/dm.h	2014-01-14 01:25:13.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/completion.h>
+#include <linux/kobject.h>
 
 #include "dm-stats.h"
 
@@ -149,11 +150,23 @@ void dm_interface_exit(void);
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
-struct completion *dm_get_completion_from_kobject(struct kobject *kobj);
+
+/*
+ * The kobject helper
+ */
+void dm_kobject_release(struct kobject *kobj);
 
 /*
  * Targets for linear and striped mappings
Index: linux-dm/drivers/md/Kconfig
===================================================================
--- linux-dm.orig/drivers/md/Kconfig	2014-01-14 01:24:48.000000000 +0100
+++ linux-dm/drivers/md/Kconfig	2014-01-14 01:25:13.000000000 +0100
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
Index: linux-dm/drivers/md/Makefile
===================================================================
--- linux-dm.orig/drivers/md/Makefile	2014-01-14 01:24:48.000000000 +0100
+++ linux-dm/drivers/md/Makefile	2014-01-14 01:25:13.000000000 +0100
@@ -32,6 +32,7 @@ obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BCACHE)		+= bcache/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
+obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
Index: linux-dm/drivers/md/dm-builtin.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-dm/drivers/md/dm-builtin.c	2014-01-14 01:25:13.000000000 +0100
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
