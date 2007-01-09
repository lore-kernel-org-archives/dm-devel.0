From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 4/4] dm-netlink: Add mempool support to dm-netlink
Date: Tue, 9 Jan 2007 01:34:49 -0800
Message-ID: <20070109093449.GE11649@us.ibm.com>
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

This patch adds mempool support to dm-netlink.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---
The mempool support was originally derived from:
drivers/scsi/scsi_transport_iscsi.c.

 drivers/md/dm-netlink.c |  152 ++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/dm-netlink.h |    1 
 2 files changed, 134 insertions(+), 19 deletions(-)

Index: linux-2.6-patched/drivers/md/dm-netlink.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-netlink.c	2007-01-09 01:12:02.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-netlink.c	2007-01-09 01:12:12.000000000 -0800
@@ -17,6 +17,8 @@
  *
  * Copyright IBM Corporation, 2005, 2006
  * 	Author: Mike Anderson <andmike@us.ibm.com>
+ *
+ * skb mempool derived from drivers/scsi/scsi_transport_iscsi.c
  */
 #include <linux/module.h>
 #include <linux/mempool.h>
@@ -27,56 +29,164 @@
 #include <net/netlink.h>
 #include "dm.h"
 
-#define EVENT_SKB_SIZE	NLMSG_GOODSIZE
+#define EVENT_SKB_SIZE		NLMSG_SPACE(128)
+#define MIN_EVENT_SKBS		16
+#define HIWAT_EVENT_SKBS	32
 
 struct dm_event_cache {
 	struct kmem_cache *cache;
 	unsigned skb_size;
+	unsigned hiwat;
+	mempool_t *pool;
+	spinlock_t used_list_lock;
+	struct list_head used_list;
 };
 
 static struct dm_event_cache dme_cache;
 
-static int dme_cache_init(struct dm_event_cache *dc, unsigned skb_size)
+static void* mp_alloc_dm_event(gfp_t gfp_mask, void *pool_data)
+{
+	struct dm_event *evt;
+	struct dm_event_cache *dc = pool_data;
+
+	evt = kmem_cache_alloc(dc->cache, gfp_mask);
+	if (!evt)
+		goto out;
+
+	evt->skb = alloc_skb(dc->skb_size, gfp_mask);
+	if (!evt->skb)
+		goto cache_out;
+	return evt;
+
+cache_out:
+	kmem_cache_free(dc->cache, evt);
+out:
+	return NULL;
+}
+
+static void mp_free_dm_event(void *element, void *pool_data)
+{
+	struct dm_event *evt = element;
+	struct dm_event_cache *dc = pool_data;
+
+	kfree_skb(evt->skb);
+	kmem_cache_free(dc->cache, evt);
+}
+
+static int dme_cache_init(struct dm_event_cache *dc, unsigned skb_size,
+			unsigned min_nr, unsigned hiwat)
 {
 	dc->skb_size = skb_size;
+	dc->hiwat = hiwat;
+	spin_lock_init(&dc->used_list_lock);
+	INIT_LIST_HEAD(&dc->used_list);
 
 	dc->cache = kmem_cache_create("dm_events",
 			   sizeof(struct dm_event), 0, 0, NULL, NULL);
 
 	if (!dc->cache)
-		return -ENOMEM;
+		goto cache_err_out;
+
+	dc->pool = mempool_create(min_nr, mp_alloc_dm_event,
+				   mp_free_dm_event, dc);
+	if (!dc->pool)
+		goto mempool_err_out;
 
 	return 0;
+
+mempool_err_out:
+	kmem_cache_destroy(dc->cache);
+cache_err_out:
+	return -ENOMEM;
 }
 
 static void dme_cache_destroy(struct dm_event_cache *dc)
 {
+	mempool_destroy(dc->pool);
 	kmem_cache_destroy(dc->cache);
 }
 
+static void __dme_cache_event_put(struct dm_event *evt)
+{
+	struct dm_event_cache *dc = evt->cdata;
+	struct sk_buff *skb = evt->skb;
+
+	if (!skb_shared(skb)) {
+		list_del(&evt->used_list);
+		skb_orphan(skb);
+
+		/* Init in case sent to pool */
+		skb->len = 0;
+		skb->tail = skb->head;
+
+		mempool_free(evt, dc->pool);
+	}
+}
+
 static void dme_cache_event_put(struct dm_event *evt)
 {
 	struct dm_event_cache *dc = evt->cdata;
-	kmem_cache_free(dc->cache, evt);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dc->used_list_lock, flags);
+	__dme_cache_event_put(evt);
+	spin_unlock_irqrestore(&dc->used_list_lock, flags);
+}
+
+static void mp_cleanup_evt_pid(int pid, struct dm_event *evt)
+{
+	struct sk_buff *skb = evt->skb;
+	struct nlmsghdr *nlh;
+
+	if (skb->sk) {
+		nlh = (struct nlmsghdr *)skb->data;
+		if (nlh->nlmsg_pid == pid) {
+			if (skb->next && skb->sk)
+				skb_unlink(skb, &skb->sk->sk_receive_queue);
+			atomic_set(&skb->users, 1);
+			__dme_cache_event_put(evt);
+		}
+	}
+}
+
+static void mp_complete(struct dm_event_cache *dc, int release_pid)
+{
+	unsigned long flags;
+	struct dm_event *evt, *n;
+
+	spin_lock_irqsave(&dc->used_list_lock, flags);
+	if (!list_empty(&dc->used_list)) {
+		list_for_each_entry_safe(evt, n, &dc->used_list, used_list) {
+			if (release_pid) {
+				mp_cleanup_evt_pid(release_pid, evt);
+			} else {
+				__dme_cache_event_put(evt);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&dc->used_list_lock, flags);
 }
 
 static struct dm_event* dme_cache_event_get(struct dm_event_cache *dc)
 {
+	unsigned long flags;
 	struct dm_event *evt;
 
-	evt = kmem_cache_alloc(dc->cache, GFP_ATOMIC);
-	if (evt) {
-		evt->cdata = dc;
-		evt->skb = alloc_skb(dc->skb_size, GFP_ATOMIC);
-		if (!evt->skb)
-			goto cache_out;
-	}
+	/* Check for ones we can complete before we alloc */
+	mp_complete(dc, 0);
 
-	return evt;
+	evt = mempool_alloc(dc->pool, GFP_ATOMIC);
+	if (!evt)
+		return NULL;
+
+	evt->cdata = dc;
+	skb_get(evt->skb);
+	INIT_LIST_HEAD(&evt->used_list);
+	spin_lock_irqsave(&dc->used_list_lock, flags);
+	list_add(&evt->used_list, &dc->used_list);
+	spin_unlock_irqrestore(&dc->used_list_lock, flags);
 
-cache_out:
-	dme_cache_event_put(evt);
-	return NULL;
+	return evt;
 }
 
 static struct sock *dm_netlink_sock;
@@ -128,7 +238,8 @@
 
 nla_put_failure:
 	printk(KERN_ERR "%s: nla_put_failure\n", __FUNCTION__);
-	nlmsg_free(evt->skb);
+	/* Set skb users so mp_complete can free */
+	atomic_set(&evt->skb->users, 1);
 	dme_cache_event_put(evt);
 out:
 	return ERR_PTR(err);
@@ -167,9 +278,10 @@
 nla_put_failure:
 	printk(KERN_ERR "%s: nla_put_failure\n", __FUNCTION__);
 no_pid:
-	nlmsg_free(evt->skb);
-out:
+	/* Set skb users so mp_complete can free */
+	atomic_set(&evt->skb->users, 1);
 	dme_cache_event_put(evt);
+out:
 	return;
 }
 EXPORT_SYMBOL(dm_send_event);
@@ -246,6 +358,7 @@
 	if (event == NETLINK_URELEASE &&
 	    n->protocol == NETLINK_DM && n->pid) {
 		if ( n->pid == dm_netlink_daemon_pid  ) {
+			mp_complete(&dme_cache, dm_netlink_daemon_pid);
 			dm_netlink_daemon_pid = 0;
 		}
 	}
@@ -273,7 +386,8 @@
 		err = -ENOBUFS;
 		goto notifier_out;
 	}
-	err = dme_cache_init(&dme_cache, EVENT_SKB_SIZE);
+	err = dme_cache_init(&dme_cache, EVENT_SKB_SIZE, MIN_EVENT_SKBS,
+				HIWAT_EVENT_SKBS);
 	if (err)
 		goto socket_out;
 
Index: linux-2.6-patched/drivers/md/dm-netlink.h
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-netlink.h	2007-01-09 01:12:02.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-netlink.h	2007-01-09 01:12:12.000000000 -0800
@@ -27,6 +27,7 @@
 	void *cdata;
 	struct sk_buff *skb;
 	struct list_head elist;
+	struct list_head used_list;
 };
 
 #ifdef CONFIG_DM_NETLINK_EVENT
