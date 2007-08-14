From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC 1/3] dm: add dm uevent base
Date: Tue, 14 Aug 2007 13:05:45 -0700
Message-ID: <41682.3599524379$1187122030@news.gmane.org>
References: <20070814200544.963756967@us.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-uevent.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

This patch adds dm-uevent base support to the Makefile, and the dm
directory.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 drivers/md/Kconfig     |    6 +++
 drivers/md/Makefile    |    4 ++
 drivers/md/dm-uevent.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-uevent.h |   41 ++++++++++++++++++++++++++
 drivers/md/dm.c        |   10 ++++++
 5 files changed, 137 insertions(+)

Index: b/drivers/md/Kconfig
===================================================================
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -276,4 +276,10 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_UEVENT
+	bool "DM uevents (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	Generate udev events for DM events.
+
 endif # MD
Index: b/drivers/md/Makefile
===================================================================
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -48,6 +48,10 @@ ifeq ($(CONFIG_ALTIVEC),y)
 altivec_flags := -maltivec -mabi=altivec
 endif
 
+ifeq ($(CONFIG_DM_UEVENT),y)
+dm-mod-objs			+= dm-uevent.o
+endif
+
 targets += raid6int1.c
 $(obj)/raid6int1.c:   UNROLL := 1
 $(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
Index: b/drivers/md/dm-uevent.c
===================================================================
--- /dev/null
+++ b/drivers/md/dm-uevent.c
@@ -0,0 +1,76 @@
+/*
+ * Device Mapper Uevent Support (dm-uevent)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2007
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
+ */
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/kobject.h>
+
+#include "dm.h"
+#include "dm-uevent.h"
+
+#define DM_MSG_PREFIX "uevent"
+
+#define DM_UE_BUF_SIZE 2048
+#define DM_NUM_ENVP 10
+
+static struct kmem_cache *_dme_cache;
+
+struct dm_uevent {
+	struct mapped_device *md;
+	enum kobject_action action;
+	char buffer[DM_UE_BUF_SIZE];
+	char *envp[DM_NUM_ENVP];
+	struct list_head elist;
+};
+
+static void dm_uevent_free(struct dm_uevent *evt)
+{
+	kmem_cache_free(_dme_cache, evt);
+}
+
+static struct dm_uevent *dm_uevent_alloc(struct mapped_device *md)
+{
+	struct dm_uevent *evt;
+
+	evt = kmem_cache_zalloc(_dme_cache, GFP_ATOMIC);
+	if (!evt)
+		return NULL;
+
+	INIT_LIST_HEAD(&evt->elist);
+	evt->md = md;
+
+	return evt;
+}
+
+int dm_uevent_init(void)
+{
+	_dme_cache = KMEM_CACHE(dm_uevent, 0);
+	if (!_dme_cache)
+		return -ENOMEM;
+
+	DMINFO("version 1.0.0 inited");
+
+	return 0;
+}
+
+void dm_uevent_exit(void)
+{
+	kmem_cache_destroy(_dme_cache);
+}
Index: b/drivers/md/dm-uevent.h
===================================================================
--- /dev/null
+++ b/drivers/md/dm-uevent.h
@@ -0,0 +1,41 @@
+/*
+ * Device Mapper Uevent Support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2007
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
+ */
+#ifndef DM_UEVENT_H
+#define DM_UEVENT_H
+
+#ifdef CONFIG_DM_UEVENT
+
+extern int dm_uevent_init(void);
+extern void dm_uevent_exit(void);
+
+#else
+
+static inline int dm_uevent_init(void)
+{
+	return 0;
+}
+static inline void dm_uevent_exit(void)
+{
+}
+
+#endif	/* CONFIG_DM_UEVENT */
+
+#endif	/* DM_UEVENT_H */
Index: b/drivers/md/dm.c
===================================================================
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -7,6 +7,7 @@
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-uevent.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -151,6 +152,14 @@ static int __init local_init(void)
 		return r;
 	}
 
+	r = dm_uevent_init();
+	if (r < 0) {
+		kmem_cache_destroy(_tio_cache);
+		kmem_cache_destroy(_io_cache);
+		unregister_blkdev(_major, _name);
+		return r;
+	}
+
 	if (!_major)
 		_major = r;
 
@@ -159,6 +168,7 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
+	dm_uevent_exit();
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);

-- 
