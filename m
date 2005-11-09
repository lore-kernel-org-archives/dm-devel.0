From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH RFC 1/2] dm-mp dm_evt hardware handler
Date: Tue, 8 Nov 2005 23:55:48 -0800
Message-ID: <20051109075548.GB11492@us.ibm.com>
References: <20051109075423.GA11492@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051109075423.GA11492@us.ibm.com>
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

This patch adds a dm-mp hardware handler the sends events over netlink
when its error function is called.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

---
 drivers/md/Kconfig      |    5 
 drivers/md/Makefile     |    1 
 drivers/md/dm-evt.c     |  330 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-mpath.c   |   18 --
 drivers/md/dm-mpath.h   |   19 ++
 include/linux/dm-evt.h  |   46 ++++++
 include/linux/netlink.h |    1 
 7 files changed, 402 insertions(+), 18 deletions(-)

Index: sas-2.6-patched/drivers/md/dm-evt.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ sas-2.6-patched/drivers/md/dm-evt.c	2005-11-08 23:14:36.000000000 -0800
@@ -0,0 +1,330 @@
+/*
+ * Device Mapper Event Handler (dm-evt)
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * Copyright (C) 2005 Mike Anderson <andmike@us.ibm.com>
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
+ * skb mempool derived from drivers/scsi/scsi_transport_iscsi.c
+ *
+ */
+#include <linux/module.h>
+#include <linux/mempool.h>
+#include <net/tcp.h>
+#include <linux/dm-evt.h>
+#include <linux/time.h>
+#include "dm.h"
+#include "dm-hw-handler.h"
+
+#define MIN_NR_EVT_SKBS	16
+#define HIWAT_EVT_SKBS 32
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
+static struct sock *dm_evt_sock;
+static int dm_evt_daemon_pid;
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
+	zp->pool = mempool_create(min_nr, mempool_zone_alloc_skb,
+				  mempool_zone_free_skb, zp);
+	if (!zp->pool)
+		return -ENOMEM;
+
+	zp->size = size;
+	zp->hiwat = hiwat;
+	zp->allocated = 0;
+	INIT_LIST_HEAD(&zp->freequeue);
+	spin_lock_init(&zp->freelock);
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
+static int dm_evt_create(struct hw_handler *hwh, unsigned argc, char **argv)
+{
+	return 0;
+}
+
+static void dm_evt_destroy(struct hw_handler *hwh)
+{
+	return;
+}
+
+#ifndef BLKERR_IO
+#define BLKERR_IO 0x5A5A5A5A
+#endif
+
+static int dm_evt_send_nl_evt(struct path *path, struct bio *bio)
+{
+	struct sk_buff	*skb;
+	struct nlmsghdr	*nlh;
+	struct dm_evt_msg *dm_evt;
+	struct timeval tv;
+	int err = -ENOMEM;
+	unsigned int blk_err = BLKERR_IO;
+
+	if (!dm_evt_sock || !dm_evt_daemon_pid)
+		return 0;
+
+	skb = mempool_zone_get_skb(&z_dm_evt);
+	if (!skb)
+		goto out;
+
+	nlh = NLMSG_PUT(skb, dm_evt_daemon_pid, 0, DM_EVENT_PATH_ERR,
+			sizeof(*dm_evt));
+	dm_evt = NLMSG_DATA(nlh);
+	strncpy(dm_evt->dm_name, path->dev->name, sizeof(dm_evt->dm_name));
+	do_gettimeofday(&tv);
+	dm_evt->tv_sec = tv.tv_sec;
+	dm_evt->tv_usec = tv.tv_usec;
+	dm_evt->u.patherr.blk_err = blk_err;
+
+	nlh = (struct nlmsghdr *) skb->data;
+
+	err = netlink_unicast(dm_evt_sock, skb, dm_evt_daemon_pid,
+			      MSG_DONTWAIT);
+	if (err < 0)
+		goto unicast_failure;
+	return err;
+
+unicast_failure:
+nlmsg_failure:
+	kfree_skb(skb);
+	mempool_zone_complete(&z_dm_evt, 0);
+out:
+	DMERR("%s: failed %d", __FUNCTION__, err);
+	return err;
+
+}
+
+
+static unsigned dm_evt_error(struct hw_handler *hwh, struct bio *bio)
+{
+	int err;
+	union map_info *info;
+	struct mpath_io *mpio;
+	struct path *path;
+
+	info = dm_get_mapinfo(bio);
+	mpio = info->ptr;
+	path = &mpio->pgpath->path;
+
+	if (path->is_active) {
+		err = dm_evt_send_nl_evt(path, bio);
+	}
+
+	return MP_FAIL_PATH;
+}
+
+#define RCV_SKB_FAIL(err) do { netlink_ack(skb, nlh, (err)); return; } while (0)
+
+static void dm_evt_rcv_msg(struct sk_buff *skb)
+{
+	int pid, flags;
+	struct nlmsghdr *nlh = (struct nlmsghdr *) skb->data;
+
+	if (skb->len >= NLMSG_SPACE(0)) {
+
+		if (nlh->nlmsg_len < sizeof(*nlh) ||
+			skb->len < nlh->nlmsg_len) {
+			return;
+		}
+		pid = nlh->nlmsg_pid;
+		flags = nlh->nlmsg_flags;
+
+		if (security_netlink_recv(skb))
+			RCV_SKB_FAIL(-EPERM);
+
+		if (dm_evt_daemon_pid) {
+			if (dm_evt_daemon_pid != pid) {
+				RCV_SKB_FAIL(-EBUSY);
+			}
+		} else {
+			dm_evt_daemon_pid = pid;
+		}
+
+		if (flags & NLM_F_ACK)
+			netlink_ack(skb, nlh, 0);
+	}
+}
+
+static void dm_evt_rcv(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+	unsigned int qlen;
+
+	for (qlen = skb_queue_len(&sk->sk_receive_queue); qlen; qlen--) {
+		skb = skb_dequeue(&sk->sk_receive_queue);
+		dm_evt_rcv_msg(skb);
+		kfree_skb(skb);
+	}
+}
+
+static int dm_evt_rcv_nl_event(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	struct netlink_notify *n = ptr;
+
+	if (event == NETLINK_URELEASE &&
+	    n->protocol == NETLINK_DM_EVENT && n->pid) {
+		if ( n->pid == dm_evt_daemon_pid  ) {
+			dm_evt_daemon_pid = 0;
+		}
+		mempool_zone_complete(&z_dm_evt, 1);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct hw_handler_type dm_evt_hwh = {
+	.name = "dm-evt",
+	.module = THIS_MODULE,
+	.create = dm_evt_create,
+	.destroy = dm_evt_destroy,
+	.error = dm_evt_error,
+};
+
+static struct notifier_block dm_evt_nl_notifier = {
+	.notifier_call  = dm_evt_rcv_nl_event,
+};
+
+static int __init dm_evt_init(void)
+{
+	int err;
+
+	err = netlink_register_notifier(&dm_evt_nl_notifier);
+	if (err)
+		return err;
+
+	dm_evt_sock = netlink_kernel_create(NETLINK_DM_EVENT, 0,
+					    dm_evt_rcv, THIS_MODULE);
+	if (!dm_evt_sock) {
+		err = -ENOBUFS;
+		goto unregister_notifier;
+	}
+
+	err = mempool_zone_init(&z_dm_evt, NLMSG_SPACE(sizeof(struct
+							      dm_evt_msg)),
+				MIN_NR_EVT_SKBS, HIWAT_EVT_SKBS);
+	if (err)
+		goto release_socket;
+
+	err = dm_register_hw_handler(&dm_evt_hwh);
+	if (err)
+		goto release_zone;
+
+	DMINFO("dm-evt version 0.0.2 loaded");
+
+	return err;
+
+release_zone:
+	mempool_destroy(z_dm_evt.pool);
+release_socket:
+	sock_release(dm_evt_sock->sk_socket);
+unregister_notifier:
+	netlink_unregister_notifier(&dm_evt_nl_notifier);
+	DMERR("%s: failed %d", __FUNCTION__, err);
+	return err;
+}
+
+static void __exit dm_evt_exit(void)
+{
+	dm_unregister_hw_handler(&dm_evt_hwh);
+	mempool_destroy(z_dm_evt.pool);
+	sock_release(dm_evt_sock->sk_socket);
+	netlink_unregister_notifier(&dm_evt_nl_notifier);
+}
+
+module_init(dm_evt_init);
+module_exit(dm_evt_exit);
+
+MODULE_DESCRIPTION(DM_NAME "dm-evt multipath hwh");
+MODULE_AUTHOR("Mike Anderson <andmike@us.ibm.com>");
+MODULE_LICENSE("GPL");
Index: sas-2.6-patched/drivers/md/Makefile
===================================================================
--- sas-2.6-patched.orig/drivers/md/Makefile	2005-11-02 13:59:04.000000000 -0800
+++ sas-2.6-patched/drivers/md/Makefile	2005-11-02 13:59:31.000000000 -0800
@@ -34,6 +34,7 @@ obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
+obj-$(CONFIG_DM_MULTIPATH_EVT)	+= dm-evt.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
Index: sas-2.6-patched/include/linux/netlink.h
===================================================================
--- sas-2.6-patched.orig/include/linux/netlink.h	2005-11-02 13:59:04.000000000 -0800
+++ sas-2.6-patched/include/linux/netlink.h	2005-11-02 13:59:31.000000000 -0800
@@ -21,6 +21,7 @@
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_GENERIC		16
+#define NETLINK_DM_EVENT	17	/* DM Event */
 
 #define MAX_LINKS 32		
 
Index: sas-2.6-patched/include/linux/dm-evt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ sas-2.6-patched/include/linux/dm-evt.h	2005-11-07 11:28:35.000000000 -0800
@@ -0,0 +1,46 @@
+/*
+ * Device Mapper Event Handler
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * Copyright (C) 2005 Mike Anderson <andmike@us.ibm.com>
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
+#ifndef DM_EVENT_H
+#define DM_EVENT_H
+#include <linux/types.h>
+
+#define EVT_DM_NAME_LEN 16
+
+#define DM_EVENT_BASE	10
+enum dm_evt_e {
+	DM_EVENT_UNKOWN		= 0,
+	DM_EVENT_PATH_ERR	= DM_EVENT_BASE + 1,
+};
+
+struct dm_evt_msg {
+	uint8_t dm_name[EVT_DM_NAME_LEN];
+	uint64_t tv_sec;
+	uint64_t tv_usec;
+
+	union {
+		struct msg_path_err {
+			uint32_t blk_err; /* BLKERR Values */
+		} patherr;
+	} u;
+} __attribute__((aligned(sizeof(uint64_t))));
+
+#endif
Index: sas-2.6-patched/drivers/md/Kconfig
===================================================================
--- sas-2.6-patched.orig/drivers/md/Kconfig	2005-11-02 13:59:04.000000000 -0800
+++ sas-2.6-patched/drivers/md/Kconfig	2005-11-02 13:59:31.000000000 -0800
@@ -235,6 +235,11 @@ config DM_MULTIPATH_EMC
 	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
+config DM_MULTIPATH_EVT
+	tristate "Generate netlink events for multipath failures"
+	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Multipath support for EMC CX/AX series hardware.
 
 endmenu
 
Index: sas-2.6-patched/drivers/md/dm-mpath.c
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm-mpath.c	2005-11-02 13:59:04.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm-mpath.c	2005-11-02 13:59:31.000000000 -0800
@@ -23,16 +23,6 @@
 
 #define MESG_STR(x) x, sizeof(x)
 
-/* Path properties */
-struct pgpath {
-	struct list_head list;
-
-	struct priority_group *pg;	/* Owning PG */
-	unsigned fail_count;		/* Cumulative failure count */
-
-	struct path path;
-};
-
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
 
 /*
@@ -88,14 +78,6 @@ struct multipath {
 	mempool_t *mpio_pool;
 };
 
-/*
- * Context information attached to each bio we process.
- */
-struct mpath_io {
-	struct pgpath *pgpath;
-	struct dm_bio_details details;
-};
-
 typedef int (*action_fn) (struct pgpath *pgpath);
 
 #define MIN_IOS 256	/* Mempool size */
Index: sas-2.6-patched/drivers/md/dm-mpath.h
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm-mpath.h	2005-11-02 13:59:04.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm-mpath.h	2005-11-02 13:59:31.000000000 -0800
@@ -8,6 +8,7 @@
 
 #ifndef	DM_MPATH_H
 #define	DM_MPATH_H
+#include "dm-bio-record.h"
 
 struct dm_dev;
 
@@ -19,6 +20,24 @@ struct path {
 	void *hwhcontext;	/* For hw-handler use */
 };
 
+/* Path properties */
+struct pgpath {
+	struct list_head list;
+
+	struct priority_group *pg;	/* Owning PG */
+	unsigned fail_count;		/* Cumulative failure count */
+
+	struct path path;
+};
+
+/*
+ * Context information attached to each bio we process.
+ */
+struct mpath_io {
+	struct pgpath *pgpath;
+	struct dm_bio_details details;
+};
+
 /* Callback for hwh_pg_init_fn to use when complete */
 void dm_pg_init_complete(struct path *path, unsigned err_flags);
 
