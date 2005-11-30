From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH RFC 2/4] dm-netlink netlink support
Date: Wed, 30 Nov 2005 00:26:25 -0800
Message-ID: <20051130082625.GB18284@us.ibm.com>
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

This patch adds netlink support to dm-netlink. It also adds support for
using netlink attributes for the event messages.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/md/dm-netlink.c    |  188 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-netlink.h    |   40 +++++++++
 include/linux/dm-netlink.h |   46 +++++++++++
 3 files changed, 272 insertions(+), 2 deletions(-)

Index: linux-2.6.15-rc1-patched/drivers/md/dm-netlink.c
===================================================================
--- linux-2.6.15-rc1-patched.orig/drivers/md/dm-netlink.c	2005-11-29 23:13:59.000000000 -0800
+++ linux-2.6.15-rc1-patched/drivers/md/dm-netlink.c	2005-11-29 23:28:06.000000000 -0800
@@ -27,6 +27,7 @@
 #include <linux/security.h>
 #include <net/sock.h>
 #include <net/netlink.h>
+#include <linux/dm-netlink.h>
 
 #define MIN_EVT_SKBS	16
 #define HIWAT_EVT_SKBS	32
@@ -125,20 +126,203 @@ static struct sk_buff* mempool_zone_get_
 	return skb;
 }
 
+static struct sock *dm_nl_sock;
+static int dm_nl_daemon_pid;
+
+static u64 dm_evt_seqnum;
+static DEFINE_SPINLOCK(sequence_lock);
+
+static struct sk_buff *dm_nl_build_path_msg(char* dm_name, int type,
+					     int blk_err)
+{
+	struct sk_buff	*skb;
+	struct nlmsghdr	*nlh;
+	struct dm_nl_msghdr *dm_nlh;
+	u64 seq;
+	struct timeval tv;
+	int err = -ENOBUFS;
+
+	skb = mempool_zone_get_skb(&z_dm_evt);
+	if (!skb) {
+		printk(KERN_ERR "%s: mempool_zone_get_skb %d\n",
+		       __FUNCTION__, err);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	nlh = nlmsg_put(skb, dm_nl_daemon_pid, 0, DM_EVT,
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
+	NLA_PUT_U64(skb, DM_E_ATTR_SEQNUM, seq);
+	NLA_PUT_U64(skb, DM_E_ATTR_TSSEC, tv.tv_sec);
+	NLA_PUT_U64(skb, DM_E_ATTR_TSUSEC, tv.tv_usec);
+	NLA_PUT_STRING(skb, DM_E_ATTR_DMNAME, dm_name);
+
+	if (blk_err)
+		NLA_PUT_U32(skb, DM_E_ATTR_BLKERR, blk_err);
+
+	nlmsg_end(skb, nlh);
+
+	return skb;
+
+nla_put_failure:
+	printk(KERN_ERR "%s: nla_put_failure\n",
+	       __FUNCTION__);
+	/* reduce skb users so zone_complete can free */
+	kfree_skb(skb);
+	mempool_zone_complete(&z_dm_evt, 0);
+out:
+	return ERR_PTR(err);
+
+}
+
+static inline void dm_nl_unicast(struct sk_buff *skb)
+{
+	int err;
+
+	if (!dm_nl_sock || !dm_nl_daemon_pid)
+		return;
+
+	err = nlmsg_unicast(dm_nl_sock, skb, dm_nl_daemon_pid);
+	if (err < 0)
+		printk(KERN_ERR "%s: nlmsg_unicast %d\n", __FUNCTION__,
+		       err);
+}
+
+void dm_nl_path_fail(char* dm_name, int blk_err)
+{
+	struct sk_buff *msg;
+	msg = dm_nl_build_path_msg(dm_name, DM_EVT_FAIL_PATH, blk_err);
+
+	if (!IS_ERR(msg))
+		dm_nl_unicast(msg);
+}
+
+EXPORT_SYMBOL(dm_nl_path_fail);
+
+void dm_nl_path_reinstate(char* dm_name)
+{
+	struct sk_buff *msg;
+	msg = dm_nl_build_path_msg(dm_name, DM_EVT_REINSTATE_PATH, 0);
+
+	if (!IS_ERR(msg))
+		dm_nl_unicast(msg);
+}
+
+EXPORT_SYMBOL(dm_nl_path_reinstate);
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
+		mempool_zone_complete(&z_dm_evt, 1);
+	}
+
+	return NOTIFY_DONE;
+}
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
+					    dm_nl_rcv, THIS_MODULE);
+	if (!dm_nl_sock) {
+		err = -ENOBUFS;
+		goto unregister_notifier;
+	}
+
 	err = mempool_zone_init(&z_dm_evt, EVT_SKB_SIZE,
 				MIN_EVT_SKBS, HIWAT_EVT_SKBS);
-	if (!err)
-		printk(KERN_DEBUG "dm-netlink version 0.0.1 loaded\n");
+	if (err)
+		goto release_socket;
+
+	printk(KERN_DEBUG "dm-netlink version 0.0.1 loaded\n");
 
 	return err;
 
+release_socket:
+	sock_release(dm_nl_sock->sk_socket);
+unregister_notifier:
+	netlink_unregister_notifier(&dm_nl_nl_notifier);
+	printk(KERN_ERR "%s: failed %d\n", __FUNCTION__, err);
+	return err;
 }
 
 void dm_nl_exit(void)
 {
 	mempool_destroy(z_dm_evt.pool);
+	sock_release(dm_nl_sock->sk_socket);
+	netlink_unregister_notifier(&dm_nl_nl_notifier);
 }
Index: linux-2.6.15-rc1-patched/include/linux/dm-netlink.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.15-rc1-patched/include/linux/dm-netlink.h	2005-11-29 23:22:07.000000000 -0800
@@ -0,0 +1,46 @@
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
Index: linux-2.6.15-rc1-patched/drivers/md/dm-netlink.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.15-rc1-patched/drivers/md/dm-netlink.h	2005-11-29 23:22:07.000000000 -0800
@@ -0,0 +1,40 @@
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
+#ifndef DM_NETLINK_H
+#define DM_NETLINK_H
+
+#ifdef CONFIG_DM_NL_SUPPORT
+void dm_nl_path_fail(char*, int);
+void dm_nl_path_reinstate(char*);
+#else
+static inline void dm_nl_path_fail(char* dm_name, int blk_err)
+{
+	return;
+}
+
+static inline void dm_nl_path_reinstate(char* dm_name)
+{
+	return;
+}
+#endif
+
+#endif /* DM_NETLINK_H */
