From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 2/2] dm-netlink events netlink calls (update)
Date: Thu, 9 Feb 2006 07:43:20 -0800
Message-ID: <20060209154320.GC29591@us.ibm.com>
References: <20060209154009.GA29591@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060209154009.GA29591@us.ibm.com>
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

 This patch adds netlink support to dm-netlink. It also adds support for
 using netlink attributes for the event messages.

 Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/md/dm-mpath.c      |   17 +++
 drivers/md/dm-netlink.c    |  207 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-netlink.h    |   32 ++++++
 drivers/md/dm-table.c      |   13 ++
 drivers/md/dm.c            |   32 ++++++
 drivers/md/dm.h            |    5 +
 include/linux/dm-netlink.h |   48 ++++++++++
 7 files changed, 350 insertions(+), 4 deletions(-)

Index: sas-2.6-patched/drivers/md/dm-netlink.c
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm-netlink.c	2006-02-09 02:23:17.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm-netlink.c	2006-02-09 03:13:38.000000000 -0800
@@ -27,7 +27,9 @@
 #include <linux/security.h>
 #include <net/sock.h>
 #include <net/netlink.h>
+#include "dm.h"
 #include "dm-netlink.h"
+#include <linux/dm-netlink.h>
 
 #define MIN_EVT_SKBS	16
 #define HIWAT_EVT_SKBS	32
@@ -135,14 +137,208 @@ static struct dm_evt* mp_zone_get_dm_evt
 	return evt;
 }
 
+static struct sock *dm_nl_sock;
+static int dm_nl_daemon_pid;
+
+static u64 dm_evt_seqnum;
+static DEFINE_SPINLOCK(sequence_lock);
+
+static struct dm_evt *dm_nl_build_path_msg(char* dm_name, int type, int
+					   nr_valid_paths, int blk_err)
+{
+	struct dm_evt *evt;
+	struct nlmsghdr	*nlh;
+	struct dm_nl_msghdr *dm_nlh;
+	u64 seq;
+	struct timeval tv;
+	int err = -ENOBUFS;
+
+	evt = mp_zone_get_dm_evt(&z_dm_evt);
+	if (!evt) {
+		printk(KERN_ERR "%s: mp_zone_get_dm_evt %d\n",
+		       __FUNCTION__, err);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	nlh = nlmsg_put(evt->skb, dm_nl_daemon_pid, 0, DM_EVT,
+			NLMSG_ALIGN(sizeof(*dm_nlh)), 0);
+	if (!nlh)
+		goto nla_put_failure;
+
+	dm_nlh = nlmsg_data(nlh);
+	dm_nlh->type = type;
+	dm_nlh->version = DM_E_ATTR_MAX;
+
+	spin_lock(&sequence_lock);
+	seq = ++dm_evt_seqnum;
+	spin_unlock(&sequence_lock);
+	do_gettimeofday(&tv);
+
+	NLA_PUT_U64(evt->skb, DM_E_ATTR_SEQNUM, seq);
+	NLA_PUT_U64(evt->skb, DM_E_ATTR_TSSEC, tv.tv_sec);
+	NLA_PUT_U64(evt->skb, DM_E_ATTR_TSUSEC, tv.tv_usec);
+	NLA_PUT_STRING(evt->skb, DM_E_ATTR_DMNAME, dm_name);
+	NLA_PUT_U32(evt->skb, DM_E_ATTR_VLDPTHS, nr_valid_paths);
+
+	if (blk_err)
+		NLA_PUT_U32(evt->skb, DM_E_ATTR_BLKERR, blk_err);
+
+	return evt;
+
+nla_put_failure:
+	printk(KERN_ERR "%s: nla_put_failure\n", __FUNCTION__);
+	/* Set skb users so zone_complete can free */
+	atomic_set(&evt->skb->users, 1);
+	mp_zone_complete(&z_dm_evt, 0);
+out:
+	return ERR_PTR(err);
+
+}
+
+void dm_send_evt(char *md_name, struct dm_evt *evt)
+{
+	struct nlmsghdr *nlh = (struct nlmsghdr *) evt->skb->data;
+	int err;
+
+	if (!dm_nl_sock || !dm_nl_daemon_pid)
+		return;
+
+	NLA_PUT_STRING(evt->skb, DM_E_ATTR_MDNAME, md_name);
+	nlmsg_end(evt->skb, nlh);
+
+	err = nlmsg_unicast(dm_nl_sock, evt->skb, dm_nl_daemon_pid);
+
+	if (err < 0) {
+		printk(KERN_ERR "%s: nlmsg_unicast failed %d\n",
+		       __FUNCTION__, err);
+		goto unicast_err;
+	}
+
+	return;
+
+nla_put_failure:
+	printk(KERN_ERR "%s: nla_put_failure\n", __FUNCTION__);
+unicast_err:
+	/* Set skb users so zone_complete can free */
+	atomic_set(&evt->skb->users, 1);
+	mp_zone_complete(&z_dm_evt, 0);
+}
+EXPORT_SYMBOL(dm_send_evt);
+
+void dm_path_fail_evt(struct mapped_device *md, char* dm_name, int
+		      nr_valid_paths, int blk_err)
+{
+	struct dm_evt *evt;
+	evt = dm_nl_build_path_msg(dm_name, DM_EVT_FAIL_PATH,
+				   nr_valid_paths, blk_err);
+
+	if (evt)
+		dm_add_evt(md, evt);
+	return;
+}
+
+EXPORT_SYMBOL(dm_path_fail_evt);
+
+void dm_path_reinstate_evt(struct mapped_device *md, char* dm_name, int
+			   nr_valid_paths)
+{
+	struct dm_evt *evt;
+	evt = dm_nl_build_path_msg(dm_name, DM_EVT_REINSTATE_PATH,
+				   nr_valid_paths, 0);
+
+	if (evt)
+		dm_add_evt(md, evt);
+	return;
+}
+
+EXPORT_SYMBOL(dm_path_reinstate_evt);
+
+#define RCV_SKB_FAIL(err) do { netlink_ack(skb, nlh, (err)); return; } while (0)
+
+static void dm_nl_rcv_msg(struct sk_buff *skb)
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
+		if (dm_nl_daemon_pid) {
+			if (dm_nl_daemon_pid != pid) {
+				RCV_SKB_FAIL(-EBUSY);
+			}
+		} else {
+			dm_nl_daemon_pid = pid;
+		}
+
+		if (flags & NLM_F_ACK)
+			netlink_ack(skb, nlh, 0);
+	}
+}
+
+static void dm_nl_rcv(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+	unsigned int qlen;
+
+	for (qlen = skb_queue_len(&sk->sk_receive_queue); qlen; qlen--) {
+		skb = skb_dequeue(&sk->sk_receive_queue);
+		dm_nl_rcv_msg(skb);
+		kfree_skb(skb);
+	}
+}
+
+static int dm_nl_rcv_nl_event(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	struct netlink_notify *n = ptr;
+
+	if (event == NETLINK_URELEASE &&
+	    n->protocol == NETLINK_DM && n->pid) {
+		if ( n->pid == dm_nl_daemon_pid  ) {
+			dm_nl_daemon_pid = 0;
+		}
+		mp_zone_complete(&z_dm_evt, 1);
+	}
+
+	return NOTIFY_DONE;
+ }
+
+static struct notifier_block dm_nl_nl_notifier = {
+	.notifier_call  = dm_nl_rcv_nl_event,
+};
+
+static struct sock *dm_nl_sock;
+static int dm_nl_daemon_pid;
+
 int __init dm_nl_init(void)
 {
 	int err;
 
+	err = netlink_register_notifier(&dm_nl_nl_notifier);
+	if (err)
+		return err;
+
+	dm_nl_sock = netlink_kernel_create(NETLINK_DM, 0,
+					   dm_nl_rcv, THIS_MODULE);
+	if (!dm_nl_sock) {
+		err = -ENOBUFS;
+		goto notifier_out;
+	}
+
 	z_dm_evt.cache = kmem_cache_create("dm_events",
 			   sizeof(struct dm_evt), 0, 0, NULL, NULL);
 	if (!z_dm_evt.cache)
-			goto out;
+			goto socket_out;
 
 	err = mp_zone_init(&z_dm_evt, EVT_SKB_SIZE,
 				MIN_EVT_SKBS, HIWAT_EVT_SKBS);
@@ -152,9 +348,14 @@ int __init dm_nl_init(void)
 	printk(KERN_DEBUG "dm-netlink version 0.0.3 loaded\n");
 
 	return err;
+
 cache_out:
 	kmem_cache_destroy(z_dm_evt.cache);
-out:
+socket_out:
+	sock_release(dm_nl_sock->sk_socket);
+notifier_out:
+	netlink_unregister_notifier(&dm_nl_nl_notifier);
+	printk(KERN_ERR "%s: failed %d\n", __FUNCTION__, err);
 	return err;
 }
 
@@ -162,4 +363,6 @@ void dm_nl_exit(void)
 {
 	mempool_destroy(z_dm_evt.pool);
 	kmem_cache_destroy(z_dm_evt.cache);
+	sock_release(dm_nl_sock->sk_socket);
+	netlink_unregister_notifier(&dm_nl_nl_notifier);
 }
Index: sas-2.6-patched/drivers/md/dm-netlink.h
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm-netlink.h	2006-02-09 02:10:08.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm-netlink.h	2006-02-09 03:07:46.000000000 -0800
@@ -28,4 +28,36 @@ struct dm_evt {
 	struct sk_buff *skb;
 };
 
+struct mapped_device;
+
+#ifdef CONFIG_DM_NL_EVT
+void dm_send_evt(char*, struct dm_evt *);
+void dm_path_fail_evt(struct mapped_device*, char*, int, int);
+void dm_path_reinstate_evt(struct mapped_device*, char*, int);
+int dm_nl_init(void);
+void dm_nl_exit(void);
+#else
+static inline void dm_send_evt(char *md_name, struct dm_evt *evt)
+{
+}
+static inline void dm_path_fail_evt(struct mapped_device *md, char*
+				    dm_name, int nr_valid_paths, int
+				    blk_err)
+{
+	return NULL;
+}
+static inline void dm_path_reinstate_evt(struct mapped_device *md, char*
+					 dm_name, int nr_valid_paths)
+{
+	return NULL;
+}
+static inline int __init dm_nl_init(void)
+{
+	return 0;
+}
+static inline void dm_nl_exit(void)
+{
+}
+#endif
+
 #endif /* DM_NETLINK_H */
Index: sas-2.6-patched/include/linux/dm-netlink.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ sas-2.6-patched/include/linux/dm-netlink.h	2006-02-09 03:07:46.000000000 -0800
@@ -0,0 +1,48 @@
+/*
+ * Device Mapper Netlink Support
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
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
+#ifndef LINUX_DM_NETLINK_H
+#define LINUX_DM_NETLINK_H
+
+enum dm_evt_attr {
+	DM_E_ATTR_SEQNUM	= 1,
+	DM_E_ATTR_TSSEC		= 2,
+	DM_E_ATTR_TSUSEC	= 3,
+	DM_E_ATTR_DMNAME	= 4,
+	DM_E_ATTR_BLKERR	= 5,
+	DM_E_ATTR_VLDPTHS	= 6,
+	DM_E_ATTR_MDNAME	= 7,
+	DM_E_ATTR_MAX,
+};
+
+#define DM_EVT NLMSG_MIN_TYPE + 0x1
+
+#define DM_EVT_FAIL_PATH 0x1
+#define DM_EVT_REINSTATE_PATH 0x2
+
+struct dm_nl_msghdr {
+	uint16_t type;
+	uint16_t version;
+	uint16_t reserved1;
+	uint16_t reserved2;
+} __attribute__((aligned(sizeof(uint64_t))));
+
+#endif /* LINUX_DM_NETLINK_H */
Index: sas-2.6-patched/drivers/md/dm-mpath.c
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm-mpath.c	2006-02-09 03:03:34.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm-mpath.c	2006-02-09 03:07:46.000000000 -0800
@@ -10,6 +10,7 @@
 #include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
+#include "dm-netlink.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -798,7 +799,7 @@ static int multipath_map(struct dm_targe
 /*
  * Take a path out of use.
  */
-static int fail_path(struct pgpath *pgpath)
+static int __fail_path(struct pgpath *pgpath, struct bio *bio)
 {
 	unsigned long flags;
 	struct multipath *m = pgpath->pg->m;
@@ -819,6 +820,10 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	/* Get error data from bio when available */
+	dm_path_fail_evt(dm_table_get_md(m->ti->table),
+			 pgpath->path.dev->name, m->nr_valid_paths, 0);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -827,6 +832,11 @@ out:
 	return 0;
 }
 
+static int fail_path(struct pgpath *pgpath)
+{
+	return __fail_path(pgpath, NULL);
+}
+
 /*
  * Reinstate a previously-failed path
  */
@@ -858,6 +868,9 @@ static int reinstate_path(struct pgpath 
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_path_reinstate_evt(dm_table_get_md(m->ti->table),
+			      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -1028,7 +1041,7 @@ static int do_end_io(struct multipath *m
 
 	if (mpio->pgpath) {
 		if (err_flags & MP_FAIL_PATH)
-			fail_path(mpio->pgpath);
+			__fail_path(mpio->pgpath, bio);
 
 		if (err_flags & MP_BYPASS_PG)
 			bypass_pg(m, mpio->pgpath->pg, 1);
Index: sas-2.6-patched/drivers/md/dm.c
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm.c	2006-02-09 03:03:34.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm.c	2006-02-09 03:07:46.000000000 -0800
@@ -93,6 +93,8 @@ struct mapped_device {
 	 */
 	atomic_t event_nr;
 	wait_queue_head_t eventq;
+	struct list_head evt_list;
+	spinlock_t evt_lock;
 
 	/*
 	 * freeze/thaw support require holding onto a super block
@@ -164,6 +166,7 @@ int (*_inits[])(void) __initdata = {
 	dm_linear_init,
 	dm_stripe_init,
 	dm_interface_init,
+	dm_nl_init,
 };
 
 void (*_exits[])(void) = {
@@ -172,6 +175,7 @@ void (*_exits[])(void) = {
 	dm_linear_exit,
 	dm_stripe_exit,
 	dm_interface_exit,
+	dm_nl_exit,
 };
 
 static int __init dm_init(void)
@@ -759,6 +763,8 @@ static struct mapped_device *alloc_dev(u
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->event_nr, 0);
+	INIT_LIST_HEAD(&md->evt_list);
+	spin_lock_init(&md->evt_lock);
 
 	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
@@ -829,6 +835,21 @@ static void free_dev(struct mapped_devic
 static void event_callback(void *context)
 {
 	struct mapped_device *md = (struct mapped_device *) context;
+	unsigned long flags;
+	struct dm_evt *evt, *next;
+	LIST_HEAD(events);
+	char md_name[16];
+
+	spin_lock_irqsave(&md->evt_lock, flags);
+	list_splice_init(&md->evt_list, &events);
+	spin_unlock_irqrestore(&md->evt_lock, flags);
+
+	snprintf(md_name, 16, "%d:%d", md->disk->major,
+		 md->disk->first_minor);
+	list_for_each_entry_safe(evt, next, &events, elist) {
+		list_del_init(&evt->elist);
+		dm_send_evt(md_name, evt);
+	}
 
 	atomic_inc(&md->event_nr);
 	wake_up(&md->eventq);
@@ -855,6 +876,7 @@ static int __bind(struct mapped_device *
 
 	dm_table_get(t);
 	dm_table_event_callback(t, event_callback, md);
+	dm_table_set_md(t, md);
 
 	write_lock(&md->map_lock);
 	md->map = t;
@@ -1190,6 +1212,16 @@ int dm_wait_event(struct mapped_device *
 			(event_nr != atomic_read(&md->event_nr)));
 }
 
+void dm_add_evt(struct mapped_device *md, struct dm_evt *evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&md->evt_lock, flags);
+	list_add(&evt->elist, &md->evt_list);
+	spin_unlock_irqrestore(&md->evt_lock, flags);
+
+}
+
 /*
  * The gendisk is only valid as long as you have a reference
  * count on 'md'.
Index: sas-2.6-patched/drivers/md/dm.h
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm.h	2006-02-09 03:03:34.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm.h	2006-02-09 03:07:46.000000000 -0800
@@ -14,6 +14,7 @@
 #include <linux/device-mapper.h>
 #include <linux/list.h>
 #include <linux/blkdev.h>
+#include "dm-netlink.h"
 
 #define DM_NAME "device-mapper"
 #define DMWARN(f, x...) printk(KERN_WARNING DM_NAME ": " f "\n" , ## x)
@@ -123,6 +124,8 @@ void dm_table_resume_targets(struct dm_t
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 void dm_table_unplug_all(struct dm_table *t);
 int dm_table_flush_all(struct dm_table *t);
+void dm_table_set_md(struct dm_table *t, struct mapped_device *md);
+struct mapped_device *dm_table_get_md(struct dm_table *t);
 
 /*-----------------------------------------------------------------
  * A registry of target types.
@@ -193,4 +196,6 @@ void dm_stripe_exit(void);
 void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 union map_info *dm_get_mapinfo(struct bio *bio);
 
+void dm_add_evt(struct mapped_device *md, struct dm_evt *evt);
+
 #endif
Index: sas-2.6-patched/drivers/md/dm-table.c
===================================================================
--- sas-2.6-patched.orig/drivers/md/dm-table.c	2006-02-09 01:42:47.000000000 -0800
+++ sas-2.6-patched/drivers/md/dm-table.c	2006-02-09 03:07:46.000000000 -0800
@@ -33,6 +33,7 @@ struct dm_table {
 	unsigned int num_allocated;
 	sector_t *highs;
 	struct dm_target *targets;
+	struct mapped_device *md;
 
 	/*
 	 * Indicates the rw permissions for the new logical
@@ -945,6 +946,16 @@ int dm_table_flush_all(struct dm_table *
 	return ret;
 }
 
+void dm_table_set_md(struct dm_table *t, struct mapped_device *md)
+{
+	t->md = md;
+}
+
+struct mapped_device *dm_table_get_md(struct dm_table *t)
+{
+	return t->md;
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
@@ -955,3 +966,5 @@ EXPORT_SYMBOL(dm_table_put);
 EXPORT_SYMBOL(dm_table_get);
 EXPORT_SYMBOL(dm_table_unplug_all);
 EXPORT_SYMBOL(dm_table_flush_all);
+EXPORT_SYMBOL(dm_table_set_md);
+EXPORT_SYMBOL(dm_table_get_md);
