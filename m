From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH RFC 1/4] dm-netlink skeleton support
Date: Wed, 30 Nov 2005 00:25:03 -0800
Message-ID: <20051130082503.GA18284@us.ibm.com>
References: <20051130082311.GA18453@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051130082311.GA18453@us.ibm.com>
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
List-Id: dm-devel.ids

This patch adds a dm-netlink skeleton support to the Makefile, Kconfig,
and the dm directory. This base dm-netlink file only contains the mempool
support.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/md/Kconfig      |    6 ++
 drivers/md/Makefile     |    3 +
 drivers/md/dm-netlink.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/netlink.h |    1 
 4 files changed, 154 insertions(+)

Index: linux-2.6.15-rc1-patched/drivers/md/dm-netlink.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.15-rc1-patched/drivers/md/dm-netlink.c	2005-11-29 23:50:01.000000000 -0800
@@ -0,0 +1,144 @@
+/*
+ * Device Mapper Netlink Support (dm-netlink)
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
+ * 	skb mempool derived from drivers/scsi/scsi_transport_iscsi.c
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
+ */
+#include <linux/module.h>
+#include <linux/mempool.h>
+#include <linux/time.h>
+#include <linux/jiffies.h>
+#include <linux/security.h>
+#include <net/sock.h>
+#include <net/netlink.h>
+
+#define MIN_EVT_SKBS	16
+#define HIWAT_EVT_SKBS	32
+#define EVT_SKB_SIZE	NLMSG_SPACE(128)
+
+struct mempool_zone {
+	mempool_t *pool;
+	int allocated;
+	int size;
+	int hiwat;
+	struct list_head freequeue;
+	spinlock_t freelock;
+};
+
+static struct mempool_zone z_dm_evt;
+
+static inline struct list_head *skb_to_lh(struct sk_buff *skb)
+{
+	return (struct list_head *)&skb->cb;
+}
+
+static void* mempool_zone_alloc_skb(unsigned int gfp_mask,
+				    void *pool_data)
+{
+	struct mempool_zone *zone = pool_data;
+
+	return alloc_skb(zone->size, gfp_mask);
+}
+
+static void mempool_zone_free_skb(void *element, void *pool_data)
+{
+	kfree_skb(element);
+}
+
+static void
+mempool_zone_complete(struct mempool_zone *zone, int release_all)
+{
+	unsigned long flags;
+	struct list_head *lh, *n;
+
+	spin_lock_irqsave(&zone->freelock, flags);
+	if (zone->allocated) {
+		list_for_each_safe(lh, n, &zone->freequeue) {
+			struct sk_buff *skb =
+				(struct sk_buff *)((char *)lh -
+				 offsetof(struct sk_buff, cb));
+			if (skb_shared(skb)) {
+				if (release_all)
+					kfree_skb(skb);
+				else
+					continue;
+			}
+
+			list_del(skb_to_lh(skb));
+			mempool_free(skb, zone->pool);
+			--zone->allocated;
+
+		}
+	}
+	spin_unlock_irqrestore(&zone->freelock, flags);
+}
+
+static int mempool_zone_init(struct mempool_zone *zp, unsigned size,
+			     int min_nr, unsigned hiwat)
+{
+	zp->size = size;
+	zp->hiwat = hiwat;
+	zp->allocated = 0;
+	INIT_LIST_HEAD(&zp->freequeue);
+	spin_lock_init(&zp->freelock);
+
+	zp->pool = mempool_create(min_nr, mempool_zone_alloc_skb,
+				  mempool_zone_free_skb, zp);
+	if (!zp->pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static struct sk_buff* mempool_zone_get_skb(struct mempool_zone *zone)
+{
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	/* Check for ones we can complete before we alloc */
+	mempool_zone_complete(zone, 0);
+
+	skb = mempool_alloc(zone->pool, GFP_ATOMIC);
+	if (skb) {
+		skb_get(skb);
+		spin_lock_irqsave(&z_dm_evt.freelock, flags);
+		list_add(skb_to_lh(skb), &z_dm_evt.freequeue);
+		++zone->allocated;
+		spin_unlock_irqrestore(&z_dm_evt.freelock, flags);
+	}
+	return skb;
+}
+
+int __init dm_nl_init(void)
+{
+	int err;
+
+	err = mempool_zone_init(&z_dm_evt, EVT_SKB_SIZE,
+				MIN_EVT_SKBS, HIWAT_EVT_SKBS);
+	if (!err)
+		printk(KERN_DEBUG "dm-netlink version 0.0.1 loaded\n");
+
+	return err;
+
+}
+
+void dm_nl_exit(void)
+{
+	mempool_destroy(z_dm_evt.pool);
+}
Index: linux-2.6.15-rc1-patched/include/linux/netlink.h
===================================================================
--- linux-2.6.15-rc1-patched.orig/include/linux/netlink.h	2005-11-11 18:51:47.000000000 -0800
+++ linux-2.6.15-rc1-patched/include/linux/netlink.h	2005-11-29 22:48:29.000000000 -0800
@@ -21,6 +21,7 @@
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_GENERIC		16
+#define NETLINK_DM			17	/* Device Mapper */
 
 #define MAX_LINKS 32		
 
Index: linux-2.6.15-rc1-patched/drivers/md/Makefile
===================================================================
--- linux-2.6.15-rc1-patched.orig/drivers/md/Makefile	2005-08-28 17:51:43.000000000 -0700
+++ linux-2.6.15-rc1-patched/drivers/md/Makefile	2005-11-29 22:48:29.000000000 -0800
@@ -37,6 +37,9 @@ obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+ifeq ($(CONFIG_DM_NL_SUPPORT),y)
+  dm-mod-objs += dm-netlink.o
+endif
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
Index: linux-2.6.15-rc1-patched/drivers/md/Kconfig
===================================================================
--- linux-2.6.15-rc1-patched.orig/drivers/md/Kconfig	2005-06-17 17:21:30.000000000 -0700
+++ linux-2.6.15-rc1-patched/drivers/md/Kconfig	2005-11-29 22:48:29.000000000 -0800
@@ -236,5 +236,11 @@ config DM_MULTIPATH_EMC
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
 
+config DM_NL_SUPPORT
+	bool "DM Netlink Support (EXPERIMENTAL)"
+	depends on  BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Netlink events for dm devices.
+
 endmenu
 
