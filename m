From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm: Implement simple read-only sysfs entry for
 device-mapper block device.
Date: Wed, 17 Dec 2008 13:02:34 +0100
Message-ID: <4948EA5A.9070301@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Implement simple read-only sysfs entry for device-mapper block device.

Sometime is using dm-ioctl too complicated, for example for checking
UUID and mapped device name.

This patch adds simple sysfs directory named "dm" under block device
properties and implements
	- name attribute (string containing mapped device name)
	- uuid attribute (string containing UUID, or emty string if not set)

The kobject is embedded in mapped_device struct, so no additional
memory allocation is needed for initializing sysfs entry.

During the processing of sysfs attribute we need to lock mapped device,
it is done by new function dm_get_from_kobj, which returns md
associated with kobject and increase use count.

Every show attribute procedure is the responsible for locking
of any thing it need.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/Makefile   |    2 +-
 drivers/md/dm-sysfs.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |   29 ++++++++++++++-
 drivers/md/dm.h       |    8 ++++
 4 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index c815592..72880b7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -3,7 +3,7 @@
 #
 
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o dm-kcopyd.o
+		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o
 dm-multipath-objs := dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
new file mode 100644
index 0000000..7e5acd7
--- /dev/null
+++ b/drivers/md/dm-sysfs.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2008 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/sysfs.h>
+#include <linux/dm-ioctl.h>
+#include "dm.h"
+
+struct dm_sysfs_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct mapped_device *, char *);
+	ssize_t (*store)(struct mapped_device *, char *);
+};
+
+#define DM_ATTR_RO(_name) \
+struct dm_sysfs_attr dm_attr_##_name = \
+	__ATTR(_name, S_IRUGO, dm_attr_##_name##_show, NULL)
+
+static ssize_t dm_attr_show(struct kobject *kobj, struct attribute *attr,
+			    char *page)
+{
+	struct dm_sysfs_attr *dm_attr;
+	struct mapped_device *md;
+	ssize_t ret;
+
+	dm_attr = container_of(attr, struct dm_sysfs_attr, attr);
+	if (!dm_attr->show)
+		return -EIO;
+
+	md = dm_get_from_kobject(kobj);
+	if (!md)
+		return -EINVAL;
+
+	ret = dm_attr->show(md, page);
+	dm_put(md);
+
+	return ret;
+}
+
+static ssize_t dm_attr_name_show(struct mapped_device *md, char *buf)
+{
+	if (dm_copy_name_and_uuid(md, buf, NULL))
+		return -EIO;
+
+	strncat(buf, "\n", DM_NAME_LEN);
+	return strnlen(buf, DM_NAME_LEN);
+}
+
+static ssize_t dm_attr_uuid_show(struct mapped_device *md, char *buf)
+{
+	if (dm_copy_name_and_uuid(md, NULL, buf))
+		return -EIO;
+
+	strncat(buf, "\n", DM_UUID_LEN);
+	return strnlen(buf, DM_UUID_LEN);
+}
+
+static DM_ATTR_RO(name);
+static DM_ATTR_RO(uuid);
+
+static struct attribute *dm_attrs[] = {
+	&dm_attr_name.attr,
+	&dm_attr_uuid.attr,
+	NULL,
+};
+
+static struct sysfs_ops dm_sysfs_ops = {
+	.show	= dm_attr_show,
+};
+
+/*
+ * dm kobject is embedded in mapped_device structure
+ * no need to define release function here
+ */
+static struct kobj_type dm_ktype = {
+	.sysfs_ops	= &dm_sysfs_ops,
+	.default_attrs	= dm_attrs,
+};
+
+/*
+ * Initialize kobj
+ * because nobody using md yet, no need to call explicit dm_get/put
+ */
+int dm_sysfs_init(struct mapped_device *md)
+{
+	return kobject_init_and_add(dm_kobject(md), &dm_ktype,
+				    &disk_to_dev(dm_disk(md))->kobj,
+				    "%s", "dm");
+}
+
+/*
+ * Remove kobj, called after all references removed
+ */
+void dm_sysfs_exit(struct mapped_device *md)
+{
+	kobject_put(dm_kobject(md));
+}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e23d6db..db2b723 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001, 2002 Sistina Software (UK) Limited.
- * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -164,6 +164,9 @@ struct mapped_device {
 
 	/* forced geometry settings */
 	struct hd_geometry geometry;
+
+	/* sysfs handle */
+	struct kobject kobj;
 };
 
 #define MIN_IOS 256
@@ -1298,6 +1301,8 @@ int dm_create(int minor, struct mapped_device **result)
 	if (!md)
 		return -ENXIO;
 
+	dm_sysfs_init(md);
+
 	*result = md;
 	return 0;
 }
@@ -1373,6 +1378,7 @@ void dm_put(struct mapped_device *md)
 			dm_table_presuspend_targets(map);
 			dm_table_postsuspend_targets(map);
 		}
+		dm_sysfs_exit(md);
 		dm_table_put(map);
 		__unbind(md);
 		free_dev(md);
@@ -1712,6 +1718,27 @@ struct gendisk *dm_disk(struct mapped_device *md)
 	return md->disk;
 }
 
+struct kobject *dm_kobject(struct mapped_device *md)
+{
+	return &md->kobj;
+}
+
+/*
+ * struct mapped_device should not be exported outside of dm.c
+ * so use this check to verify that kobj is part of md structure
+ */
+struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
+{
+	struct mapped_device *md;
+
+	md = container_of(kobj, struct mapped_device, kobj);
+	if (&md->kobj != kobj)
+		return NULL;
+
+	dm_get(md);
+	return md;
+}
+
 int dm_suspended(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bbbe911..20194e0 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -74,6 +74,14 @@ int dm_interface_init(void);
 void dm_interface_exit(void);
 
 /*
+ * sysfs interface
+ */
+int dm_sysfs_init(struct mapped_device *md);
+void dm_sysfs_exit(struct mapped_device *md);
+struct kobject *dm_kobject(struct mapped_device *md);
+struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
+
+/*
  * Targets for linear and striped mappings
  */
 int dm_linear_init(void);
