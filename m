From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 02/04] dm: add uevent to core
Date: Wed, 17 Oct 2007 13:54:23 +0100
Message-ID: <20071017125423.GN24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch adds a uevent skeleton to device-mapper.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/Kconfig     |    6 ++++
 drivers/md/Makefile    |    4 ++
 drivers/md/dm-uevent.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-uevent.h |   41 +++++++++++++++++++++++++++
 drivers/md/dm.c        |   10 ++++++
 5 files changed, 133 insertions(+)

Index: linux-2.6.23/drivers/md/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/md/Kconfig	2007-10-17 11:43:05.000000000 +0100
+++ linux-2.6.23/drivers/md/Kconfig	2007-10-17 11:43:06.000000000 +0100
@@ -282,4 +282,10 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_UEVENT
+	bool "DM uevents (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	Generate udev events for DM events.
+
 endif # MD
Index: linux-2.6.23/drivers/md/Makefile
===================================================================
--- linux-2.6.23.orig/drivers/md/Makefile	2007-10-17 11:43:05.000000000 +0100
+++ linux-2.6.23/drivers/md/Makefile	2007-10-17 11:43:06.000000000 +0100
@@ -50,6 +50,10 @@ ifeq ($(CONFIG_ALTIVEC),y)
 altivec_flags := -maltivec -mabi=altivec
 endif
 
+ifeq ($(CONFIG_DM_UEVENT),y)
+dm-mod-objs			+= dm-uevent.o
+endif
+
 targets += raid6int1.c
 $(obj)/raid6int1.c:   UNROLL := 1
 $(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
Index: linux-2.6.23/drivers/md/dm-uevent.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23/drivers/md/dm-uevent.c	2007-10-17 11:43:06.000000000 +0100
@@ -0,0 +1,72 @@
+/*
+ * Device Mapper Uevent Support (dm-uevent)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2007
+ * 	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
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
+static struct kmem_cache *_dm_event_cache;
+
+struct dm_uevent {
+	struct mapped_device *md;
+	enum kobject_action action;
+	struct kobj_uevent_env ku_env;
+	struct list_head elist;
+};
+
+static void dm_uevent_free(struct dm_uevent *event)
+{
+	kmem_cache_free(_dm_event_cache, event);
+}
+
+static struct dm_uevent *dm_uevent_alloc(struct mapped_device *md)
+{
+	struct dm_uevent *event;
+
+	event = kmem_cache_zalloc(_dm_event_cache, GFP_ATOMIC);
+	if (!event)
+		return NULL;
+
+	INIT_LIST_HEAD(&event->elist);
+	event->md = md;
+
+	return event;
+}
+
+int dm_uevent_init(void)
+{
+	_dm_event_cache = KMEM_CACHE(dm_uevent, 0);
+	if (!_dm_event_cache)
+		return -ENOMEM;
+
+	DMINFO("version 1.0.3");
+
+	return 0;
+}
+
+void dm_uevent_exit(void)
+{
+	kmem_cache_destroy(_dm_event_cache);
+}
Index: linux-2.6.23/drivers/md/dm-uevent.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23/drivers/md/dm-uevent.h	2007-10-17 11:43:06.000000000 +0100
@@ -0,0 +1,41 @@
+/*
+ * Device Mapper Uevent Support
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2007
+ * 	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
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
Index: linux-2.6.23/drivers/md/dm.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm.c	2007-10-17 11:43:05.000000000 +0100
+++ linux-2.6.23/drivers/md/dm.c	2007-10-17 11:53:30.000000000 +0100
@@ -7,6 +7,7 @@
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-uevent.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -143,11 +144,19 @@ static int __init local_init(void)
 		return -ENOMEM;
 	}
 
+	r = dm_uevent_init();
+	if (r) {
+		kmem_cache_destroy(_tio_cache);
+		kmem_cache_destroy(_io_cache);
+		return r;
+	}
+
 	_major = major;
 	r = register_blkdev(_major, _name);
 	if (r < 0) {
 		kmem_cache_destroy(_tio_cache);
 		kmem_cache_destroy(_io_cache);
+		dm_uevent_exit();
 		return r;
 	}
 
@@ -162,6 +171,7 @@ static void local_exit(void)
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
+	dm_uevent_exit();
 
 	_major = 0;
 
