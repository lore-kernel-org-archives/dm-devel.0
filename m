From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 13/18] dm: netlink
Date: Wed, 11 Jul 2007 22:01:37 +0100
Message-ID: <20070711210137.GE24114@agk.fab.redhat.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Anderson <andmike@us.ibm.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Anderson <andmike@us.ibm.com>

This patch adds a dm-netlink skeleton support to the Makefile, and the dm
directory.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/Kconfig      |    5 ++
 drivers/md/Makefile     |    4 +
 drivers/md/dm-netlink.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-netlink.h |   50 +++++++++++++++++++++++
 drivers/md/dm.c         |    3 +
 include/linux/netlink.h |    2 
 6 files changed, 166 insertions(+), 1 deletion(-)

Index: linux/drivers/md/Kconfig
===================================================================
--- linux.orig/drivers/md/Kconfig	2007-07-11 21:37:31.000000000 +0100
+++ linux/drivers/md/Kconfig	2007-07-11 21:37:50.000000000 +0100
@@ -271,6 +271,11 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_NETLINK
+	bool "DM netlink events (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	Generate netlink events for DM events.
 endmenu
 
 endif
Index: linux/drivers/md/Makefile
===================================================================
--- linux.orig/drivers/md/Makefile	2007-07-11 21:37:31.000000000 +0100
+++ linux/drivers/md/Makefile	2007-07-11 21:37:50.000000000 +0100
@@ -46,6 +46,10 @@ ifeq ($(CONFIG_ALTIVEC),y)
 altivec_flags := -maltivec -mabi=altivec
 endif
 
+ifeq ($(CONFIG_DM_NETLINK),y)
+dm-mod-objs			+= dm-netlink.o
+endif
+
 targets += raid6int1.c
 $(obj)/raid6int1.c:   UNROLL := 1
 $(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
Index: linux/drivers/md/dm-netlink.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/md/dm-netlink.c	2007-07-11 21:37:50.000000000 +0100
@@ -0,0 +1,103 @@
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
+
+#include "dm.h"
+#include "dm-netlink.h"
+
+#define DM_MSG_PREFIX "netlink"
+
+#define DM_EVENT_SKB_SIZE NLMSG_GOODSIZE
+
+struct dm_event_cache {
+	struct kmem_cache *cache;
+	unsigned skb_size;
+};
+
+static struct dm_event_cache _dme_cache;
+
+static int dme_cache_init(struct dm_event_cache *dc, unsigned skb_size)
+{
+	dc->skb_size = skb_size;
+
+	dc->cache = KMEM_CACHE(dm_event, 0);
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
+
+	kmem_cache_free(dc->cache, evt);
+}
+
+static struct dm_event *dme_cache_event_get(struct dm_event_cache *dc,
+					    struct mapped_device *md)
+{
+	struct dm_event *evt;
+
+	evt = kmem_cache_alloc(dc->cache, GFP_ATOMIC);
+	if (!evt)
+		return NULL;
+
+	INIT_LIST_HEAD(&evt->elist);
+	evt->cdata = dc;
+	evt->md = md;
+	evt->skb = alloc_skb(dc->skb_size, GFP_ATOMIC);
+	if (!evt->skb)
+		goto cache_err;
+
+	return evt;
+
+cache_err:
+	dme_cache_event_put(evt);
+	return NULL;
+}
+
+int __init dm_netlink_init(void)
+{
+	int r;
+
+	r = dme_cache_init(&_dme_cache, DM_EVENT_SKB_SIZE);
+	if (!r)
+		DMINFO("version 1.0.0 loaded");
+
+	return r;
+}
+
+void dm_netlink_exit(void)
+{
+	dme_cache_destroy(&_dme_cache);
+}
Index: linux/drivers/md/dm-netlink.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/md/dm-netlink.h	2007-07-11 21:37:50.000000000 +0100
@@ -0,0 +1,50 @@
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
+struct dm_event_cache;
+struct mapped_device;
+struct dm_event {
+	struct dm_event_cache *cdata;
+	struct mapped_device *md;
+	struct sk_buff *skb;
+	struct list_head elist;
+};
+
+#ifdef CONFIG_DM_NETLINK
+
+int dm_netlink_init(void);
+void dm_netlink_exit(void);
+
+#else	/* CONFIG_DM_NETLINK */
+
+static inline int __init dm_netlink_init(void)
+{
+	return 0;
+}
+static inline void dm_netlink_exit(void)
+{
+}
+
+#endif	/* CONFIG_DM_NETLINK */
+
+#endif	/* DM_NETLINK_H */
Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c	2007-07-11 21:37:47.000000000 +0100
+++ linux/drivers/md/dm.c	2007-07-11 21:37:50.000000000 +0100
@@ -7,6 +7,7 @@
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-netlink.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -176,6 +177,7 @@ int (*_inits[])(void) __initdata = {
 	dm_linear_init,
 	dm_stripe_init,
 	dm_interface_init,
+	dm_netlink_init,
 };
 
 void (*_exits[])(void) = {
@@ -184,6 +186,7 @@ void (*_exits[])(void) = {
 	dm_linear_exit,
 	dm_stripe_exit,
 	dm_interface_exit,
+	dm_netlink_exit,
 };
 
 static int __init dm_init(void)
Index: linux/include/linux/netlink.h
===================================================================
--- linux.orig/include/linux/netlink.h	2007-07-11 21:37:31.000000000 +0100
+++ linux/include/linux/netlink.h	2007-07-11 21:37:50.000000000 +0100
@@ -21,7 +21,7 @@
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_GENERIC		16
-/* leave room for NETLINK_DM (DM Events) */
+#define NETLINK_DM		17	/* Device Mapper */
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
 #define NETLINK_ECRYPTFS	19
 
