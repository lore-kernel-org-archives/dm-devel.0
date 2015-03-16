From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/78] Use poll() when receiving uevents
Date: Mon, 16 Mar 2015 13:36:23 +0100
Message-ID: <1426509425-15978-37-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Currently uevent_listen() will be adding each event individually
to the internal queue. This leads to a lock contention on high
load, as uevent_listen() has to grab the shared lock before
doing so.
This patch batches the uevent reception so that uevents will
only ever be added to the internal queue if there are no more
events pending.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/list.h   | 47 +++++++++++++++++++++++++-------
 libmultipath/uevent.c | 74 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 95 insertions(+), 26 deletions(-)

diff --git a/libmultipath/list.h b/libmultipath/list.h
index 8626630..7a3cf16 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -161,18 +161,18 @@ static inline int list_empty(struct list_head *head)
 	return head->next == head;
 }
 
-static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
+static inline void __list_splice(const struct list_head *list,
+				 struct list_head *prev,
+				 struct list_head *next)
 {
 	struct list_head *first = list->next;
 	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
 
-	first->prev = head;
-	head->next = first;
+	first->prev = prev;
+	prev->next = first;
 
-	last->next = at;
-	at->prev = last;
+	last->next = next;
+	next->prev = last;
 }
 
 /**
@@ -183,7 +183,19 @@ static inline void __list_splice(struct list_head *list,
 static inline void list_splice(struct list_head *list, struct list_head *head)
 {
 	if (!list_empty(list))
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
+}
+
+/**
+ * list_splice_tail - join two lists, each list being a queue
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice_tail(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head->prev, head);
 }
 
 /**
@@ -197,7 +209,24 @@ static inline void list_splice_init(struct list_head *list,
 				    struct list_head *head)
 {
 	if (!list_empty(list)) {
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
+ * list_splice_tail_init - join two lists and reinitialise the emptied list
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * Each of the lists is a queue.
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head->prev, head);
 		INIT_LIST_HEAD(list);
 	}
 }
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 7e41c6f..478c6ce 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -34,9 +34,11 @@
 #include <sys/socket.h>
 #include <sys/user.h>
 #include <sys/un.h>
+#include <sys/poll.h>
 #include <linux/types.h>
 #include <linux/netlink.h>
 #include <pthread.h>
+#include <signal.h>
 #include <limits.h>
 #include <sys/mman.h>
 #include <libudev.h>
@@ -470,10 +472,14 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 
 int uevent_listen(struct udev *udev)
 {
-	int err;
+	int err = 2;
 	struct udev_monitor *monitor = NULL;
-	int fd, socket_flags;
+	int fd, fd_ep = -1, socket_flags, events;
 	int need_failback = 1;
+	int timeout = 30;
+	sigset_t mask;
+	LIST_HEAD(uevlisten_tmp);
+
 	/*
 	 * Queue uevents for service by dedicated thread so that the uevent
 	 * listening thread does not block on multipathd locks (vecs->lock)
@@ -490,7 +496,6 @@ int uevent_listen(struct udev *udev)
 	monitor = udev_monitor_new_from_netlink(udev, "udev");
 	if (!monitor) {
 		condlog(2, "failed to create udev monitor");
-		err = 2;
 		goto out;
 	}
 #ifdef LIBUDEV_API_RECVBUF
@@ -522,28 +527,63 @@ int uevent_listen(struct udev *udev)
 		condlog(2, "failed to enable receiving : %s", strerror(-err));
 		goto out;
 	}
+
+	pthread_sigmask(SIG_SETMASK, NULL, &mask);
+	sigdelset(&mask, SIGHUP);
+	sigdelset(&mask, SIGUSR1);
+	events = 0;
 	while (1) {
 		struct uevent *uev;
 		struct udev_device *dev;
-
-		dev = udev_monitor_receive_device(monitor);
-		if (!dev) {
-			condlog(0, "failed getting udev device");
+		struct pollfd ev_poll;
+		struct timespec poll_timeout;
+		int fdcount;
+
+		memset(&ev_poll, 0, sizeof(struct pollfd));
+		ev_poll.fd = fd;
+		ev_poll.events = POLLIN;
+		memset(&poll_timeout, 0, sizeof(struct timespec));
+		poll_timeout.tv_sec = timeout;
+		errno = 0;
+		fdcount = ppoll(&ev_poll, 1, &poll_timeout, &mask);
+		if (fdcount && ev_poll.revents & POLLIN) {
+			timeout = 0;
+			dev = udev_monitor_receive_device(monitor);
+			if (!dev) {
+				condlog(0, "failed getting udev device");
+				continue;
+			}
+			uev = uevent_from_udev_device(dev);
+			if (!uev)
+				continue;
+			list_add_tail(&uev->node, &uevlisten_tmp);
+			events++;
 			continue;
 		}
-		uev = uevent_from_udev_device(dev);
-		if (!uev)
-			continue;
-		/*
-		 * Queue uevent and poke service pthread.
-		 */
-		pthread_mutex_lock(uevq_lockp);
-		list_add_tail(&uev->node, &uevq);
-		pthread_cond_signal(uev_condp);
-		pthread_mutex_unlock(uevq_lockp);
+		if (fdcount < 0) {
+			if (errno != EINTR)
+				condlog(0, "error receiving "
+					"uevent message: %m");
+			err = -errno;
+			break;
+		}
+		if (!list_empty(&uevlisten_tmp)) {
+			/*
+			 * Queue uevents and poke service pthread.
+			 */
+			condlog(3, "Forwarding %d uevents", events);
+			pthread_mutex_lock(uevq_lockp);
+			list_splice_tail_init(&uevlisten_tmp, &uevq);
+			pthread_cond_signal(uev_condp);
+			pthread_mutex_unlock(uevq_lockp);
+			events = 0;
+		}
+		timeout = 30;
 	}
 	need_failback = 0;
 out:
+	if (fd_ep >= 0)
+		close(fd_ep);
 	if (monitor)
 		udev_monitor_unref(monitor);
 	if (need_failback)
-- 
1.8.4.5
