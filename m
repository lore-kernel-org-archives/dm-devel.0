From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 1/4] dm-netlink: Add dm-netlink skeleton
Date: Tue, 9 Jan 2007 01:31:31 -0800
Message-ID: <20070109093131.GB11649@us.ibm.com>
References: <20070109093006.GA11649@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070109093006.GA11649@us.ibm.com>
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

From: Mike Anderson <andmike@us.ibm.com>

This patch adds a dm-netlink skeleton support to the Makefile, and the dm
directory.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 drivers/md/Kconfig      |    5 ++
 drivers/md/Makefile     |    4 ++
 drivers/md/dm-netlink.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-netlink.h |   42 +++++++++++++++++++++
 drivers/md/dm.c         |    2 +
 drivers/md/dm.h         |    1 
 include/linux/netlink.h |    2 -
 7 files changed, 151 insertions(+), 1 deletion(-)

Index: linux-2.6-patched/drivers/md/dm-netlink.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-patched/drivers/md/dm-netlink.c	2007-01-09 01:11:57.000000000 -0800
@@ -0,0 +1,96 @@
+/*
+ * Device Mapper Netlink Support (dm-netlink)
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
+ * Copyright IBM Corporation, 2005, 2006
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
+ */
+#include <linux/module.h>
+#include <linux/mempool.h>
+#include <linux/time.h>
+#include <linux/jiffies.h>
+#include <linux/security.h>
+#include <net/sock.h>
+#include <net/netlink.h>
+#include "dm.h"
+
+#define EVENT_SKB_SIZE	NLMSG_GOODSIZE
+
+struct dm_event_cache {
+	struct kmem_cache *cache;
+	unsigned skb_size;
+};
+
+static struct dm_event_cache dme_cache;
+
+static int dme_cache_init(struct dm_event_cache *dc, unsigned skb_size)
+{
+	dc->skb_size = skb_size;
+
+	dc->cache = kmem_cache_create("dm_events",
+			   sizeof(struct dm_event), 0, 0, NULL, NULL);
+
+	if (!dc->cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void dme_cache_destroy(struct dm_event_cache *dc)
+{
+	kmem_cache_destroy(dc->cache);
+}
+
+static void dme_cache_event_put(struct dm_event *evt)
+{
+	struct dm_event_cache *dc = evt->cdata;
+	kmem_cache_free(dc->cache, evt);
+}
+
+static struct dm_event* dme_cache_event_get(struct dm_event_cache *dc)
+{
+	struct dm_event *evt;
+
+	evt = kmem_cache_alloc(dc->cache, GFP_ATOMIC);
+	if (evt) {
+		evt->cdata = dc;
+		evt->skb = alloc_skb(dc->skb_size, GFP_ATOMIC);
+		if (!evt->skb)
+			goto cache_out;
+	}
+
+	return evt;
+
+cache_out:
+	dme_cache_event_put(evt);
+	return NULL;
+}
+
+int __init dm_netlink_init(void)
+{
+	int err;
+
+	err = dme_cache_init(&dme_cache, EVENT_SKB_SIZE);
+	if (!err)
+		printk(KERN_DEBUG "dm-netlink version 0.0.6 loaded\n");
+
+	return err;
+}
+
+void dm_netlink_exit(void)
+{
+	dme_cache_destroy(&dme_cache);
+}
Index: linux-2.6-patched/include/linux/netlink.h
===================================================================
--- linux-2.6-patched.orig/include/linux/netlink.h	2007-01-09 01:11:44.000000000 -0800
+++ linux-2.6-patched/include/linux/netlink.h	2007-01-09 01:11:57.000000000 -0800
@@ -21,7 +21,7 @@
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_GENERIC		16
-/* leave room for NETLINK_DM (DM Events) */
+#define NETLINK_DM		17	/* Device Mapper */
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
 
 #define MAX_LINKS 32		
Index: linux-2.6-patched/drivers/md/Makefile
===================================================================
--- linux-2.6-patched.orig/drivers/md/Makefile	2007-01-09 01:11:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/Makefile	2007-01-09 01:11:57.000000000 -0800
@@ -45,6 +45,10 @@
 altivec_flags := -maltivec -mabi=altivec
 endif
 
+ifeq ($(CONFIG_DM_NETLINK_EVENT),y)
+dm-mod-objs			+= dm-netlink.o
+endif
+
 targets += raid6int1.c
 $(obj)/raid6int1.c:   UNROLL := 1
 $(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
Index: linux-2.6-patched/drivers/md/Kconfig
===================================================================
--- linux-2.6-patched.orig/drivers/md/Kconfig	2007-01-09 01:11:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/Kconfig	2007-01-09 01:11:57.000000000 -0800
@@ -262,6 +262,11 @@
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
 
+config DM_NETLINK_EVENT
+	bool "DM netlink events (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	Generate netlink events for DM events.
 endmenu
 
 endif
Index: linux-2.6-patched/drivers/md/dm-netlink.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-patched/drivers/md/dm-netlink.h	2007-01-09 01:11:57.000000000 -0800
@@ -0,0 +1,42 @@
+/*
+ * Device Mapper Netlink Support
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
+ * Copyright IBM Corporation, 2005, 2006
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
+ */
+#ifndef DM_NETLINK_H
+#define DM_NETLINK_H
+
+struct dm_event {
+	void *cdata;
+	struct sk_buff *skb;
+	struct list_head elist;
+};
+
+#ifdef CONFIG_DM_NETLINK_EVENT
+int dm_netlink_init(void);
+void dm_netlink_exit(void);
+#else
+static inline int __init dm_netlink_init(void)
+{
+	return 0;
+}
+static inline void dm_netlink_exit(void)
+{ }
+#endif
+
+#endif /* DM_NETLINK_H */
Index: linux-2.6-patched/drivers/md/dm.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm.c	2007-01-09 01:11:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm.c	2007-01-09 01:11:57.000000000 -0800
@@ -178,6 +178,7 @@
 	dm_linear_init,
 	dm_stripe_init,
 	dm_interface_init,
+	dm_netlink_init,
 };
 
 void (*_exits[])(void) = {
@@ -186,6 +187,7 @@
 	dm_linear_exit,
 	dm_stripe_exit,
 	dm_interface_exit,
+	dm_netlink_exit,
 };
 
 static int __init dm_init(void)
Index: linux-2.6-patched/drivers/md/dm.h
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm.h	2007-01-09 01:11:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm.h	2007-01-09 01:11:57.000000000 -0800
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include "dm-netlink.h"
 
 #define DM_NAME "device-mapper"
 
