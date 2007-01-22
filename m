From: Mike Anderson <andmike@us.ibm.com>
Subject: [patch 2/3] dm-netlink: Add support for event functions
Date: Mon, 22 Jan 2007 10:17:20 -0800
Message-ID: <35762.2800082483$1169489818@news.gmane.org>
References: <20070122181718.377495483@us.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-netlink-add-netlink.patch
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


This patch adds support for the dm_path_event dm_send_event funtions which
create and send netlink attribute events.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 drivers/md/dm-netlink.c    |  198 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-netlink.h    |    9 ++
 drivers/md/dm.c            |   26 +++++
 drivers/md/dm.h            |    2 
 include/linux/dm-netlink.h |   50 +++++++++++
 5 files changed, 283 insertions(+), 2 deletions(-)

Index: linux-2.6-patched/drivers/md/dm-netlink.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-netlink.c	2007-01-19 11:01:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-netlink.c	2007-01-19 11:16:59.000000000 -0800
@@ -80,13 +80,207 @@ cache_out:
 	return NULL;
 }
 
+static struct sock *dm_netlink_sock;
+static u32 dm_netlink_daemon_pid;
+static DEFINE_SPINLOCK(pid_lock);
+
+static u64 dm_event_seqnum;
+static DEFINE_SPINLOCK(sequence_lock);
+
+static struct dm_event *dm_netlink_build_path_msg(char* dm_name, int type, int
+					   nr_valid_paths)
+{
+	struct dm_event *evt;
+	struct nlmsghdr	*nlh;
+	struct dm_netlink_msghdr *dm_nlh;
+	u64 seq;
+	struct timeval tv;
+	int err = -ENOBUFS;
+
+	evt = dme_cache_event_get(&dme_cache);
+	if (!evt) {
+		printk(KERN_ERR "%s: dme_cache_event_get %d\n",
+		       __FUNCTION__, err);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	nlh = nlmsg_put(evt->skb, 0, 0, DM_EVENT,
+			NLMSG_ALIGN(sizeof(*dm_nlh)), 0);
+	if (!nlh)
+		goto nla_put_failure;
+
+	dm_nlh = nlmsg_data(nlh);
+	dm_nlh->type = type;
+	dm_nlh->version = DM_E_ATTR_MAX;
+
+	spin_lock(&sequence_lock);
+	seq = ++dm_event_seqnum;
+	spin_unlock(&sequence_lock);
+	do_gettimeofday(&tv);
+
+	NLA_PUT_U64(evt->skb, DM_E_ATTR_SEQNUM, seq);
+	NLA_PUT_U64(evt->skb, DM_E_ATTR_TSSEC, tv.tv_sec);
+	NLA_PUT_U64(evt->skb, DM_E_ATTR_TSUSEC, tv.tv_usec);
+	NLA_PUT_STRING(evt->skb, DM_E_ATTR_DMNAME, dm_name);
+	NLA_PUT_U32(evt->skb, DM_E_ATTR_VLDPTHS, nr_valid_paths);
+
+	return evt;
+
+nla_put_failure:
+	printk(KERN_ERR "%s: nla_put_failure\n", __FUNCTION__);
+	nlmsg_free(evt->skb);
+	dme_cache_event_put(evt);
+out:
+	return ERR_PTR(err);
+
+}
+
+/**
+ * dm_send_event - called to send a completed event message
+ *
+ * @md_name:	string containing md device name
+ * @evt:	pointer of event to send
+ *
+ **/
+void dm_send_event(char *md_name, struct dm_event *evt)
+{
+	struct nlmsghdr *nlh = (struct nlmsghdr *) evt->skb->data;
+	int err;
+
+	NLA_PUT_STRING(evt->skb, DM_E_ATTR_MDNAME, md_name);
+	nlmsg_end(evt->skb, nlh);
+
+	spin_lock(&pid_lock);
+	nlh->nlmsg_pid = dm_netlink_daemon_pid;
+	spin_unlock(&pid_lock);
+
+	if (!nlh->nlmsg_pid)
+		goto no_pid;
+
+	err = nlmsg_unicast(dm_netlink_sock, evt->skb, nlh->nlmsg_pid);
+
+	if (err && (err != -ESRCH))
+		printk(KERN_ERR "%s: nlmsg_unicast failed %d\n",
+		       __FUNCTION__, err);
+	goto out;
+
+nla_put_failure:
+	printk(KERN_ERR "%s: nla_put_failure\n", __FUNCTION__);
+no_pid:
+	nlmsg_free(evt->skb);
+out:
+	dme_cache_event_put(evt);
+	return;
+}
+EXPORT_SYMBOL_GPL(dm_send_event);
+
+/**
+ * dm_path_event - called to create a new path event and queue it
+ *
+ * @evt_type:		enum of path event type
+ * @t:			pointer to a dm_table
+ * @dm_name:		dm name string
+ * @nr_valid_paths:	number of valid paths remaining
+ *
+ **/
+void dm_path_event(enum dm_event_type evt_type, struct dm_table *t,
+			char* dm_name, int nr_valid_paths)
+{
+	struct dm_event *evt;
+	evt = dm_netlink_build_path_msg(dm_name, evt_type, nr_valid_paths);
+
+	if (!IS_ERR(evt)) {
+		struct mapped_device *md = dm_table_get_md(t);
+		dm_add_event(md, evt);
+		dm_put(md);
+	}
+
+	return;
+}
+
+EXPORT_SYMBOL_GPL(dm_path_event);
+
+static int dm_netlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       int *errp)
+{
+	*errp = 0;
+
+	if (security_netlink_recv(skb, CAP_SYS_ADMIN)) {
+		*errp = -EPERM;
+		goto out;
+	}
+
+	spin_lock(&pid_lock);
+	if (dm_netlink_daemon_pid) {
+		if (dm_netlink_daemon_pid != nlh->nlmsg_pid) {
+			*errp = -EBUSY;
+		}
+	} else
+		dm_netlink_daemon_pid = nlh->nlmsg_pid;
+	spin_unlock(&pid_lock);
+
+out:
+	return *errp;
+}
+
+static void dm_netlink_rcv(struct sock *sk, int len)
+{
+	unsigned qlen = 0;
+
+	do {
+		netlink_run_queue(sk, &qlen, &dm_netlink_rcv_msg);
+	} while (qlen);
+
+}
+
+static int dm_netlink_rcv_event(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct netlink_notify *n = ptr;
+
+	spin_lock(&pid_lock);
+	if (event == NETLINK_URELEASE &&
+	    n->protocol == NETLINK_DM && n->pid &&
+	    n->pid == dm_netlink_daemon_pid)
+		dm_netlink_daemon_pid = 0;
+	spin_unlock(&pid_lock);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block dm_netlink_notifier = {
+	.notifier_call  = dm_netlink_rcv_event,
+};
+
+
 int __init dm_netlink_init(void)
 {
 	int err;
 
+	err = netlink_register_notifier(&dm_netlink_notifier);
+	if (err)
+		return err;
+
+	dm_netlink_sock = netlink_kernel_create(NETLINK_DM, 0,
+					   dm_netlink_rcv, THIS_MODULE);
+	if (!dm_netlink_sock) {
+		err = -ENOBUFS;
+		goto notifier_out;
+	}
 	err = dme_cache_init(&dme_cache, EVENT_SKB_SIZE);
-	if (!err)
-		printk(KERN_DEBUG "dm-netlink version 0.0.6 loaded\n");
+	if (err)
+		goto socket_out;
+
+	printk(KERN_DEBUG "dm-netlink version 0.0.7 loaded\n");
+
+	return err;
+
+socket_out:
+	sock_release(dm_netlink_sock->sk_socket);
+notifier_out:
+	netlink_unregister_notifier(&dm_netlink_notifier);
+	printk(KERN_ERR "%s: failed %d\n", __FUNCTION__, err);
 
 	return err;
 }
Index: linux-2.6-patched/drivers/md/dm-netlink.h
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-netlink.h	2007-01-19 11:01:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-netlink.h	2007-01-19 11:02:09.000000000 -0800
@@ -21,6 +21,8 @@
 #ifndef DM_NETLINK_H
 #define DM_NETLINK_H
 
+#include <linux/dm-netlink.h>
+
 struct dm_event {
 	void *cdata;
 	struct sk_buff *skb;
@@ -28,9 +30,16 @@ struct dm_event {
 };
 
 #ifdef CONFIG_DM_NETLINK_EVENT
+void dm_send_event(char *, struct dm_event *);
+void dm_path_event(enum dm_event_type, struct dm_table *, char *, int);
 int dm_netlink_init(void);
 void dm_netlink_exit(void);
 #else
+static inline void dm_send_event(char *, struct dm_event *)
+{ }
+static inline void dm_path_event(enum dm_event_type, struct dm_table *, char *,
+				 int)
+{ }
 static inline int __init dm_netlink_init(void)
 {
 	return 0;
Index: linux-2.6-patched/include/linux/dm-netlink.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-patched/include/linux/dm-netlink.h	2007-01-19 11:02:09.000000000 -0800
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
+#ifndef LINUX_DM_NETLINK_H
+#define LINUX_DM_NETLINK_H
+
+#define DM_EVENT NLMSG_MIN_TYPE + 0x1
+
+enum dm_event_type {
+	DM_EVENT_FAIL_PATH = 1,
+	DM_EVENT_REINSTATE_PATH = 2,
+	DM_EVENT_MAX,
+};
+
+enum dm_event_attr {
+	DM_E_ATTR_SEQNUM	= 1,
+	DM_E_ATTR_TSSEC		= 2,
+	DM_E_ATTR_TSUSEC	= 3,
+	DM_E_ATTR_DMNAME	= 4,
+	DM_E_ATTR_BLKERR        = 5,
+	DM_E_ATTR_VLDPTHS	= 6,
+	DM_E_ATTR_MDNAME	= 7,
+	DM_E_ATTR_MAX,
+};
+
+struct dm_netlink_msghdr {
+	uint16_t type;
+	uint16_t version;
+	uint16_t reserved1;
+	uint16_t reserved2;
+} __attribute__((aligned(sizeof(uint64_t))));
+
+#endif /* LINUX_DM_NETLINK_H */
Index: linux-2.6-patched/drivers/md/dm.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm.c	2007-01-19 11:01:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm.c	2007-01-19 11:02:09.000000000 -0800
@@ -112,6 +112,8 @@ struct mapped_device {
 	 */
 	atomic_t event_nr;
 	wait_queue_head_t eventq;
+	struct list_head event_list;
+	spinlock_t event_lock;
 
 	/*
 	 * freeze/thaw support require holding onto a super block
@@ -993,6 +995,8 @@ static struct mapped_device *alloc_dev(i
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
 	atomic_set(&md->event_nr, 0);
+	INIT_LIST_HEAD(&md->event_list);
+	spin_lock_init(&md->event_lock);
 
 	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
@@ -1091,6 +1095,18 @@ static void free_dev(struct mapped_devic
 static void event_callback(void *context)
 {
 	struct mapped_device *md = (struct mapped_device *) context;
+	unsigned long flags;
+	struct dm_event *evt, *next;
+	LIST_HEAD(events);
+
+	spin_lock_irqsave(&md->event_lock, flags);
+	list_splice_init(&md->event_list, &events);
+	spin_unlock_irqrestore(&md->event_lock, flags);
+
+	list_for_each_entry_safe(evt, next, &events, elist) {
+		list_del_init(&evt->elist);
+		dm_send_event(md->name, evt);
+	}
 
 	atomic_inc(&md->event_nr);
 	wake_up(&md->eventq);
@@ -1507,6 +1523,16 @@ int dm_wait_event(struct mapped_device *
 			(event_nr != atomic_read(&md->event_nr)));
 }
 
+void dm_add_event(struct mapped_device *md, struct dm_event *evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&md->event_lock, flags);
+	list_add(&evt->elist, &md->event_list);
+	spin_unlock_irqrestore(&md->event_lock, flags);
+
+}
+
 /*
  * The gendisk is only valid as long as you have a reference
  * count on 'md'.
Index: linux-2.6-patched/drivers/md/dm.h
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm.h	2007-01-19 11:01:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm.h	2007-01-19 11:02:09.000000000 -0800
@@ -152,4 +152,6 @@ union map_info *dm_get_mapinfo(struct bi
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
+void dm_add_event(struct mapped_device *md, struct dm_event *evt);
+
 #endif

-- 
