From: tang.junhui@zte.com.cn
Subject: [PATCH] multipath-tools: improve processing efficiency
	for addition and deletion of multipath devices
Date: Wed, 18 Jan 2017 15:38:33 +0800
Message-ID: <1484725113-5400-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

Change-Id: I3f81a55fff389f991f915927000b281d7e263cc5
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>

This patch used to improve processing efficiency for addition and deletion
of multipath devices.

This patch is tested pass by ZTE multipath automatic testing system.
The modification reduces the system consumption(such as CPU) and shortens
the processing time obviously in scene of massive multipath devices
addition or deletion.

The main processing flow of code is:
1) add uid_attrs configuration in the defaults section:
   It is configured udev attribute which providing a unique path identifier
   for corresponding type of path devices. If this field is configured and
   matched with type of device, it would override any other methods providing
   for device unique identifier in config file, and it would activate merging
   uevents according to the identifier to promote effiecncy in processing
   uevents. Tt has no default value, so defaultly only uevents filtering
   works, and uevents merging does not works, if users want to identify path
   by udev attribute and to activate merging uevents for SCSI and DAS device,
   they can set it's value as:
   "sd:ID_SERIAL dasd:ID_UID"
2) uevents accumulation in uevents burst scene:
   wait one seconds for more uevents in uevent_listen() in uevents burst
   situations
3) uevents preparing, filtering and merging:
   discard unuse uevents and fetch path idendifier from uevents;
   filter uevents;
   merge uevents.
4) uevents proccessing:
   proccess the merged uevents in uev->merge_node list without calling
   domap();
   proccess the last uevents uev with calling domap().

Any comment will be welcome, and it would be appreciated if these
patches would be considered for inclusion in the upstream
multipath-tools.

Thank you all,
Tang Junhui
---
 libmultipath/config.c      |   3 +
 libmultipath/config.h      |   1 +
 libmultipath/dict.c        |   3 +
 libmultipath/discovery.c   |   5 +-
 libmultipath/discovery.h   |   2 +-
 libmultipath/list.h        |  41 ++++++
 libmultipath/propsel.c     |   7 +
 libmultipath/uevent.c      | 319 +++++++++++++++++++++++++++++++++++++++++++--
 libmultipath/uevent.h      |   2 +
 libmultipath/util.c        |  40 ++++++
 libmultipath/util.h        |   1 +
 multipath/multipath.conf.5 |  18 +++
 multipathd/cli_handlers.c  |   4 +-
 multipathd/main.c          |  93 +++++--------
 multipathd/main.h          |   4 +-
 15 files changed, 468 insertions(+), 75 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 15ddbd8..765e91d 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -488,6 +488,9 @@ free_config (struct config * conf)
 	if (conf->uid_attribute)
 		FREE(conf->uid_attribute);
 
+	if (conf->uid_attrs)
+		FREE(conf->uid_attrs);
+
 	if (conf->getuid)
 		FREE(conf->getuid);
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 9670020..ab85930 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -153,6 +153,7 @@ struct config {
 
 	char * multipath_dir;
 	char * selector;
+	char * uid_attrs;
 	char * uid_attribute;
 	char * getuid;
 	char * features;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index dc21846..0a531d1 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -249,6 +249,8 @@ declare_ovr_snprint(selector, print_str)
 declare_mp_handler(selector, set_str)
 declare_mp_snprint(selector, print_str)
 
+declare_def_handler(uid_attrs, set_str)
+declare_def_snprint(uid_attrs, print_str)
 declare_def_handler(uid_attribute, set_str)
 declare_def_snprint_defstr(uid_attribute, print_str, DEFAULT_UID_ATTRIBUTE)
 declare_ovr_handler(uid_attribute, set_str)
@@ -1367,6 +1369,7 @@ init_keywords(vector keywords)
 	install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_def_multipath_dir);
 	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_pgpolicy);
+	install_keyword("uid_attrs", &def_uid_attrs_handler, &snprint_def_uid_attrs);
 	install_keyword("uid_attribute", &def_uid_attribute_handler, &snprint_def_uid_attribute);
 	install_keyword("getuid_callout", &def_getuid_handler, &snprint_def_getuid);
 	install_keyword("prio", &def_prio_name_handler, &snprint_def_prio_name);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d1aec31..14904f2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -33,7 +33,7 @@
 
 int
 alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			  int flag, struct path **pp_ptr)
+			  char *wwid, int flag, struct path **pp_ptr)
 {
 	int err = PATHINFO_FAILED;
 	struct path * pp;
@@ -51,6 +51,9 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 	if (!pp)
 		return PATHINFO_FAILED;
 
+	if(wwid)
+		strncpy(pp->wwid, wwid, sizeof(pp->wwid));
+
 	if (safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
 	} else {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 3039268..d16a69a 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -37,7 +37,7 @@ int path_offline (struct path *);
 int get_state (struct path * pp, struct config * conf, int daemon);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			      int flag, struct path **pp_ptr);
+			      char *wwid, int flag, struct path **pp_ptr);
 int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
diff --git a/libmultipath/list.h b/libmultipath/list.h
index ceaa381..2b1dcf3 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -317,4 +317,45 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
+/**
+ * list_for_each_entry_reverse_safe - iterate backwards over list of given type safe against removal of list entry
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_reverse_safe(pos, n, head, member)          \
+	for (pos = list_entry((head)->prev, typeof(*pos), member),      \
+		 n = list_entry(pos->member.prev, typeof(*pos), member);\
+	     &pos->member != (head);                                    \
+	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+
+/**
+ * list_for_some_entry_safe - iterate list from the given begin node to the given end node safe against removal of list entry
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @from:	the begin node of the iteration.
+ * @to:		the end node of the iteration.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_some_entry_safe(pos, n, from, to, member)              \
+	for (pos = list_entry((from)->next, typeof(*pos), member),      \
+	     n = list_entry(pos->member.next, typeof(*pos), member);    \
+	     &pos->member != (to);                                      \
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+/**
+ * list_for_some_entry_reverse_safe - iterate backwards list from the given begin node to the given end node safe against removal of list entry
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @from:	the begin node of the iteration.
+ * @to:		the end node of the iteration.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_some_entry_reverse_safe(pos, n, from, to, member)      \
+	for (pos = list_entry((from)->prev, typeof(*pos), member),      \
+	     n = list_entry(pos->member.prev, typeof(*pos), member);    \
+	     &pos->member != (to);                                      \
+	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+
 #endif /* _LIST_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index c0bc616..5a58dc0 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -18,6 +18,7 @@
 #include "prio.h"
 #include "discovery.h"
 #include "dict.h"
+#include "util.h"
 #include "prioritizers/alua_rtpg.h"
 #include <inttypes.h>
 
@@ -339,6 +340,12 @@ int select_getuid(struct config *conf, struct path *pp)
 {
 	char *origin;
 
+	pp->uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, pp->dev);
+	if (pp->uid_attribute) {
+		origin = "(config file default)";
+		goto out;
+	}
+
 	pp_set_ovr(getuid);
 	pp_set_ovr(uid_attribute);
 	pp_set_hwe(getuid);
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 7edcce1..7e4ac04 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -24,6 +24,7 @@
 
 #include <unistd.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <errno.h>
 #include <stdlib.h>
 #include <stddef.h>
@@ -38,6 +39,7 @@
 #include <linux/netlink.h>
 #include <pthread.h>
 #include <sys/mman.h>
+#include <sys/time.h>
 #include <libudev.h>
 #include <errno.h>
 
@@ -46,6 +48,14 @@
 #include "list.h"
 #include "uevent.h"
 #include "vector.h"
+#include "structs.h"
+#include "util.h"
+#include "config.h"
+#include "blacklist.h"
+
+#define MAX_ACCUMULATION_COUNT 2048
+#define MAX_ACCUMULATION_TIME 30*1000
+#define MIN_BURST_SPEED 10
 
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
@@ -72,48 +82,300 @@ struct uevent * alloc_uevent (void)
 {
 	struct uevent *uev = MALLOC(sizeof(struct uevent));
 
-	if (uev)
+	if (uev) {
 		INIT_LIST_HEAD(&uev->node);
+		INIT_LIST_HEAD(&uev->merge_node);
+	}
 
 	return uev;
 }
 
 void
-service_uevq(struct list_head *tmpq)
+uevq_cleanup(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
 
 	list_for_each_entry_safe(uev, tmp, tmpq, node) {
 		list_del_init(&uev->node);
 
-		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
-			condlog(0, "uevent trigger error");
-
 		if (uev->udev)
 			udev_device_unref(uev->udev);
 		FREE(uev);
 	}
 }
 
-static void uevent_cleanup(void *arg)
+void
+uevent_get_wwid(struct uevent *uev)
 {
-	struct udev *udev = arg;
+	int i;
+	char *uid_attribute;
+	struct config * conf;
+	
+	conf = get_multipath_config();
+	uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, uev->kernel);
+	put_multipath_config(conf);	
+	
+	if (!uid_attribute)
+		return;
+	
+	for (i = 0; uev->envp[i] != NULL; i++) {
+		if (!strncmp(uev->envp[i], uid_attribute, strlen(uid_attribute)) &&
+		    strlen(uev->envp[i]) > strlen(uid_attribute)) {
+			uev->wwid = uev->envp[i] + strlen(uid_attribute) + 1;
+			break;
+		}
+	}
+	free(uid_attribute);
+}
 
-	condlog(3, "Releasing uevent_listen() resources");
-	udev_unref(udev);
+bool
+uevent_need_merge(void)
+{
+	struct config * conf;
+	bool need_merge = false;
+
+	conf = get_multipath_config();
+	if (conf->uid_attrs)
+		need_merge = true;
+	put_multipath_config(conf);	
+
+	return need_merge;
+}
+
+bool
+uevent_can_discard(struct uevent *uev)
+{
+	char *tmp;
+	char a[11], b[11];
+	struct config * conf;
+
+	/*
+	 * keep only block devices, discard partitions
+	 */
+	tmp = strstr(uev->devpath, "/block/");
+	if (tmp == NULL){
+		condlog(4, "no /block/ in '%s'", uev->devpath);
+		return true;
+	}
+	if (sscanf(tmp, "/block/%10s", a) != 1 ||
+	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
+		condlog(4, "discard event on %s", uev->devpath);
+		return true;
+	}
+
+	/* 
+	 * do not filter dm devices by devnode
+	 */
+	if (!strncmp(uev->kernel, "dm-", 3))
+		return false;
+	/* 
+	 * filter paths devices by devnode
+	 */
+	conf = get_multipath_config();
+	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
+			   uev->kernel) > 0) {
+		put_multipath_config(conf);
+		return true;
+	}
+	put_multipath_config(conf);
+
+	return false;
+}
+
+bool
+uevent_can_filter(struct uevent *earlier, struct uevent *later)
+{
+
+	/*
+	 * filter earlier uvents if path has removed later. Eg:
+	 * "add path1 |chang path1 |add path2 |remove path1"
+	 * can filter as:
+	 * "add path2 |remove path1"
+	 * uevents "add path1" and "chang path1" are filtered out
+	 */
+	if (!strcmp(earlier->kernel, later->kernel) &&
+		!strcmp(later->action, "remove") &&
+		strncmp(later->kernel, "dm-", 3)) {
+		return true;
+	}
+
+	/*
+	 * filter change uvents if add uevents exist. Eg:
+	 * "change path1| add path1 |add path2"
+	 * can filter as:
+	 * "add path1 |add path2"
+	 * uevent "chang path1" is filtered out
+	 */
+	if (!strcmp(earlier->kernel, later->kernel) &&
+		!strcmp(earlier->action, "change") &&
+		!strcmp(later->action, "add") &&
+		strncmp(later->kernel, "dm-", 3)) {
+		return true;
+	}
+
+	return false;
+}
+
+bool
+merge_need_stop(struct uevent *earlier, struct uevent *later)
+{
+	/*
+	 * dm uevent do not try to merge with left uevents
+	 */
+	if (!strncmp(later->kernel, "dm-", 3))
+		return true;
+
+	/*
+	 * we can not make a jugement without wwid,
+	 * so it is sensible to stop merging
+	 */
+	if (!earlier->wwid || !later->wwid)
+		return true;
+	/*
+	 * uevents merging stoped
+	 * when we meet an opposite action uevent from the same LUN to AVOID
+	 * "add path1 |remove path1 |add path2 |remove path2 |add path3"
+	 * to merge as "remove path1, path2" and "add path1, path2, path3"
+	 * OR
+	 * "remove path1 |add path1 |remove path2 |add path2 |remove path3"
+	 * to merge as "add path1, path2" and "remove path1, path2, path3"
+	 * SO
+	 * when we meet a non-change uevent from the same LUN
+	 * with the same wwid and different action
+	 * it would be better to stop merging.
+	 */
+	if (!strcmp(earlier->wwid, later->wwid) &&
+	    strcmp(earlier->action, later->action) &&
+	    strcmp(earlier->action, "change") &&
+	    strcmp(later->action, "change"))
+		return true;
+
+	return false;
+}
+
+bool
+uevent_can_merge(struct uevent *earlier, struct uevent *later)
+{
+	/* merge paths uevents
+	 * whose wwids exsit and are same
+	 * and actions are same,
+	 * and actions are addition or deletion
+	 */
+	if (earlier->wwid && later->wwid &&
+	    !strcmp(earlier->wwid, later->wwid) &&
+	    !strcmp(earlier->action, later->action) &&
+	    strncmp(earlier->action, "change", 6) &&
+	    strncmp(earlier->kernel, "dm-", 3)) {
+		return true;
+	}
+
+	return false;
 }
 
 void
-uevq_cleanup(struct list_head *tmpq)
+uevent_prepare(struct list_head *tmpq)
+{
+	struct uevent *uev, *tmp;
+
+	list_for_each_entry_reverse_safe(uev, tmp, tmpq, node) {
+		if (uevent_can_discard(uev)) {
+			list_del_init(&uev->node);
+			if (uev->udev)
+				udev_device_unref(uev->udev);
+			FREE(uev);
+			continue;
+		}
+
+		if (strncmp(uev->kernel, "dm-", 3) &&
+		    uevent_need_merge())
+			uevent_get_wwid(uev);
+	}
+}
+
+void
+uevent_filter(struct uevent *later, struct list_head *tmpq)
+{
+	struct uevent *earlier, *tmp;
+
+	list_for_some_entry_reverse_safe(earlier, tmp, &later->node, tmpq, node) {
+		/*
+		 * filter unnessary earlier uevents 
+		 * by the later uevent
+		 */
+		if (uevent_can_filter(earlier, later)) {
+			condlog(2, "uevent: %s-%s has filtered by uevent: %s-%s",
+				earlier->kernel, earlier->action, 
+				later->kernel, later->action);
+
+			list_del_init(&earlier->node);
+			if (earlier->udev)
+				udev_device_unref(earlier->udev);
+			FREE(earlier);
+		}
+	}
+}
+
+void
+uevent_merge(struct uevent *later, struct list_head *tmpq)
+{
+	struct uevent *earlier, *tmp;
+
+	list_for_some_entry_reverse_safe(earlier, tmp, &later->node, tmpq, node) {
+		if (merge_need_stop(earlier, later))
+			break;
+		/*
+		 * merge earlier uevents to the later uevent
+		 */
+		if (uevent_can_merge(earlier, later)) {
+			condlog(2, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
+				earlier->action, earlier->kernel, earlier->wwid,
+				later->action, later->kernel, later->wwid);
+
+			list_move(&earlier->node, &later->merge_node);
+		}
+	}
+}
+
+void
+merge_uevq(struct list_head *tmpq)
+{
+	struct uevent *later;
+
+	uevent_prepare(tmpq);
+	list_for_each_entry_reverse(later, tmpq, node) {
+		uevent_filter(later, tmpq);
+		if(uevent_need_merge())
+			uevent_merge(later, tmpq);
+	}
+}
+
+void
+service_uevq(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
 
 	list_for_each_entry_safe(uev, tmp, tmpq, node) {
 		list_del_init(&uev->node);
+
+		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
+			condlog(0, "uevent trigger error");
+
+		uevq_cleanup(&uev->merge_node);
+
+		if (uev->udev)
+			udev_device_unref(uev->udev);
 		FREE(uev);
 	}
 }
 
+static void uevent_cleanup(void *arg)
+{
+	struct udev *udev = arg;
+
+	condlog(3, "Releasing uevent_listen() resources");
+	udev_unref(udev);
+}
+
 /*
  * Service the uevent queue.
  */
@@ -142,6 +404,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 		pthread_mutex_unlock(uevq_lockp);
 		if (!my_uev_trigger)
 			break;
+		merge_uevq(&uevq_tmp);
 		service_uevq(&uevq_tmp);
 	}
 	condlog(3, "Terminating uev service queue");
@@ -442,11 +705,43 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 	return uev;
 }
 
+bool uevent_burst(struct timeval *start_time, int events)
+{
+	struct timeval diff_time, end_time;
+	unsigned long speed;
+	unsigned long eclipse_ms;
+
+	if(events > MAX_ACCUMULATION_COUNT) {
+		condlog(2, "burst got %u uevents, too much uevents, stopped", events);
+		return false;
+	}
+
+	gettimeofday(&end_time, NULL);
+	timersub(&end_time, start_time, &diff_time);
+
+	eclipse_ms = diff_time.tv_sec * 1000 + diff_time.tv_usec / 1000;
+
+	if (eclipse_ms == 0)
+		return true;
+
+	if (eclipse_ms > MAX_ACCUMULATION_TIME) {
+		condlog(2, "burst continued %lu ms, too long time, stopped", eclipse_ms);
+		return false;
+	}
+
+	speed = (events * 1000) / eclipse_ms;
+	if (speed > MIN_BURST_SPEED)
+		return true;
+
+	return false;
+}
+
 int uevent_listen(struct udev *udev)
 {
 	int err = 2;
 	struct udev_monitor *monitor = NULL;
 	int fd, socket_flags, events;
+	struct timeval start_time;
 	int need_failback = 1;
 	int timeout = 30;
 	LIST_HEAD(uevlisten_tmp);
@@ -500,6 +795,7 @@ int uevent_listen(struct udev *udev)
 	}
 
 	events = 0;
+	gettimeofday(&start_time, NULL);
 	while (1) {
 		struct uevent *uev;
 		struct udev_device *dev;
@@ -514,7 +810,7 @@ int uevent_listen(struct udev *udev)
 		errno = 0;
 		fdcount = poll(&ev_poll, 1, poll_timeout);
 		if (fdcount && ev_poll.revents & POLLIN) {
-			timeout = 0;
+			timeout = uevent_burst(&start_time, events + 1) ? 1 : 0;
 			dev = udev_monitor_receive_device(monitor);
 			if (!dev) {
 				condlog(0, "failed getting udev device");
@@ -547,6 +843,7 @@ int uevent_listen(struct udev *udev)
 			pthread_mutex_unlock(uevq_lockp);
 			events = 0;
 		}
+		gettimeofday(&start_time, NULL);
 		timeout = 30;
 	}
 	need_failback = 0;
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 9d22dcd..61a4207 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -17,11 +17,13 @@ struct udev;
 
 struct uevent {
 	struct list_head node;
+	struct list_head merge_node;
 	struct udev_device *udev;
 	char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];
 	char *devpath;
 	char *action;
 	char *kernel;
+	char *wwid;
 	unsigned long seqnum;
 	char *envp[HOTPLUG_NUM_ENVP];
 };
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 03a5738..e5a4a28 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -261,6 +261,46 @@ dev_t parse_devt(const char *dev_t)
 	return makedev(maj, min);
 }
 
+char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev)
+{
+	char *uid_attribute;
+	char *uid_attr_record;
+	char *dev;
+	char *attr;
+	char *tmp;
+	int  count;
+
+	if(!uid_attrs || !path_dev)
+		return NULL;
+
+	count = get_word(uid_attrs, &uid_attr_record);
+	while (uid_attr_record) {
+		tmp = strrchr(uid_attr_record, ':');
+		if (!tmp) {
+			free(uid_attr_record);
+			if (!count)
+				break;
+			count = get_word(uid_attrs + count, &uid_attr_record);
+			continue;
+		}
+		dev = uid_attr_record;
+		attr = tmp + 1;
+		*tmp = '\0';
+
+		if(!strncmp(path_dev, dev, strlen(dev))) {
+			uid_attribute = STRDUP(attr);
+			free(uid_attr_record);
+			return uid_attribute;
+		}
+
+		free(uid_attr_record);
+		if (!count)
+			break;
+		count = get_word(uid_attrs + count, &uid_attr_record);
+	}
+	return NULL;
+}
+
 void
 setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 {
diff --git a/libmultipath/util.h b/libmultipath/util.h
index f3b37ee..793f2b7 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -12,6 +12,7 @@ size_t strlcat(char *dst, const char *src, size_t size);
 int devt2devname (char *, int, char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
+char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 
 #define safe_sprintf(var, format, args...)	\
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 36589f5..63c63c2 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -209,6 +209,24 @@ The default is: \fBfailover\fR
 .
 .
 .TP
+.B uid_attrs
+The udev attribute providing a unique path identifier for corresponding 
+type of path devices. If this field is configured and matched with type
+of device, it would override any other methods providing for device
+unique identifier in config file, and it would activate merging uevents
+according to the identifier to promote effiecncy in processing uevents.
+Tt has no default value, if you want to identify path by udev attribute
+and to activate merging uevents for SCSI and DAS device, you can set
+it's value as:
+.RS
+.TP
+\fBuid_attrs "sd:ID_SERIAL dasd:ID_UID"\fR
+.TP
+The default is: \fB<unset>\fR
+.RE
+.
+.
+.TP
 .B uid_attribute
 The udev attribute providing a unique path identifier.
 .RS
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b0eeca6..12f85de 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -670,7 +670,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		pp->checkint = conf->checkint;
 	}
 	put_multipath_config(conf);
-	return ev_add_path(pp, vecs);
+	return ev_add_path(pp, vecs, 1);
 blacklisted:
 	*reply = strdup("blacklisted\n");
 	*len = strlen(*reply) + 1;
@@ -692,7 +692,7 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 		condlog(0, "%s: path already removed", param);
 		return 1;
 	}
-	return ev_remove_path(pp, vecs);
+	return ev_remove_path(pp, vecs, 1);
 }
 
 int
diff --git a/multipathd/main.c b/multipathd/main.c
index adc3258..e513f7d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -608,7 +608,7 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 }
 
 static int
-uev_add_path (struct uevent *uev, struct vectors * vecs)
+uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
 	struct path *pp;
 	int ret = 0, i;
@@ -641,7 +641,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 				     DI_ALL | DI_BLACKLIST);
 			put_multipath_config(conf);
 			if (r == PATHINFO_OK)
-				ret = ev_add_path(pp, vecs);
+				ret = ev_add_path(pp, vecs, need_do_map);
 			else if (r == PATHINFO_SKIPPED) {
 				condlog(3, "%s: remove blacklisted path",
 					uev->kernel);
@@ -665,7 +665,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	 */
 	conf = get_multipath_config();
 	ret = alloc_path_with_pathinfo(conf, uev->udev,
-				       DI_ALL, &pp);
+				       uev->wwid, DI_ALL, &pp);
 	put_multipath_config(conf);
 	if (!pp) {
 		if (ret == PATHINFO_SKIPPED)
@@ -681,7 +681,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		conf = get_multipath_config();
 		pp->checkint = conf->checkint;
 		put_multipath_config(conf);
-		ret = ev_add_path(pp, vecs);
+		ret = ev_add_path(pp, vecs, need_do_map);
 	} else {
 		condlog(0, "%s: failed to store path info, "
 			"dropping event",
@@ -699,7 +699,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
  * 1: error
  */
 int
-ev_add_path (struct path * pp, struct vectors * vecs)
+ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
 	char params[PARAMS_SIZE] = {0};
@@ -767,6 +767,13 @@ rescan:
 	/* persistent reservation check*/
 	mpath_pr_event_handle(pp);
 
+	if (!need_do_map)
+		return 0;
+
+	if (!dm_map_present(mpp->alias)) {
+		mpp->action = ACT_CREATE;
+		start_waiter = 1;
+	}
 	/*
 	 * push the map to the device-mapper
 	 */
@@ -833,7 +840,7 @@ fail:
 }
 
 static int
-uev_remove_path (struct uevent *uev, struct vectors * vecs)
+uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
 	struct path *pp;
 	int ret;
@@ -844,7 +851,7 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs)
 	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp)
-		ret = ev_remove_path(pp, vecs);
+		ret = ev_remove_path(pp, vecs, need_do_map);
 	lock_cleanup_pop(vecs->lock);
 	if (!pp) {
 		/* Not an error; path might have been purged earlier */
@@ -855,7 +862,7 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs)
 }
 
 int
-ev_remove_path (struct path *pp, struct vectors * vecs)
+ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
 	int i, retval = 0;
@@ -918,6 +925,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 			goto out;
 		}
 
+		if (!need_do_map)
+			goto out;
 		/*
 		 * reload the map
 		 */
@@ -995,7 +1004,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		}
 
 		if (pp->initialized == INIT_REQUESTED_UDEV)
-			retval = uev_add_path(uev, vecs);
+			retval = uev_add_path(uev, vecs, 1);
 		else if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
@@ -1016,7 +1025,7 @@ out:
 			int flag = DI_SYSFS | DI_WWID;
 
 			conf = get_multipath_config();
-			retval = alloc_path_with_pathinfo(conf, uev->udev, flag, NULL);
+			retval = alloc_path_with_pathinfo(conf, uev->udev, uev->wwid, flag, NULL);
 			put_multipath_config(conf);
 
 			if (retval == PATHINFO_SKIPPED) {
@@ -1077,40 +1086,15 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	return r;
 }
 
-static int
-uev_discard(char * devpath)
-{
-	char *tmp;
-	char a[11], b[11];
-
-	/*
-	 * keep only block devices, discard partitions
-	 */
-	tmp = strstr(devpath, "/block/");
-	if (tmp == NULL){
-		condlog(4, "no /block/ in '%s'", devpath);
-		return 1;
-	}
-	if (sscanf(tmp, "/block/%10s", a) != 1 ||
-	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
-		condlog(4, "discard event on %s", devpath);
-		return 1;
-	}
-	return 0;
-}
-
 int
 uev_trigger (struct uevent * uev, void * trigger_data)
 {
 	int r = 0;
 	struct vectors * vecs;
-	struct config *conf;
+	struct uevent *merge_uev, *tmp;
 
 	vecs = (struct vectors *)trigger_data;
 
-	if (uev_discard(uev->devpath))
-		return 0;
-
 	pthread_cleanup_push(config_cleanup, NULL);
 	pthread_mutex_lock(&config_lock);
 	if (running_state != DAEMON_IDLE &&
@@ -1139,28 +1123,21 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	}
 
 	/*
-	 * path add/remove event
+	 * path add/remove/change event, add/remove maybe merged
 	 */
-	conf = get_multipath_config();
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0) {
-		put_multipath_config(conf);
-		goto out;
+	list_for_each_entry_safe(merge_uev, tmp, &uev->merge_node, node) {
+		if (!strncmp(merge_uev->action, "add", 3))
+			r += uev_add_path(merge_uev, vecs, 0);
+		if (!strncmp(merge_uev->action, "remove", 6))
+			r += uev_remove_path(merge_uev, vecs, 0);
 	}
-	put_multipath_config(conf);
 
-	if (!strncmp(uev->action, "add", 3)) {
-		r = uev_add_path(uev, vecs);
-		goto out;
-	}
-	if (!strncmp(uev->action, "remove", 6)) {
-		r = uev_remove_path(uev, vecs);
-		goto out;
-	}
-	if (!strncmp(uev->action, "change", 6)) {
-		r = uev_update_path(uev, vecs);
-		goto out;
-	}
+	if (!strncmp(uev->action, "add", 3))
+		r += uev_add_path(uev, vecs, 1);
+	if (!strncmp(uev->action, "remove", 6))
+		r += uev_remove_path(uev, vecs, 1);
+	if (!strncmp(uev->action, "change", 6))
+		r += uev_update_path(uev, vecs);
 
 out:
 	return r;
@@ -1570,7 +1547,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			conf = get_multipath_config();
 			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
 			if (ret == PATHINFO_OK) {
-				ev_add_path(pp, vecs);
+				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
 			} else if (ret == PATHINFO_SKIPPED) {
 				put_multipath_config(conf);
@@ -1686,7 +1663,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		}
 		if (!disable_reinstate && reinstate_path(pp, add_active)) {
 			condlog(3, "%s: reload map", pp->dev);
-			ev_add_path(pp, vecs);
+			ev_add_path(pp, vecs, 1);
 			pp->tick = 1;
 			return 0;
 		}
@@ -1709,7 +1686,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			/* Clear IO errors */
 			if (reinstate_path(pp, 0)) {
 				condlog(3, "%s: reload map", pp->dev);
-				ev_add_path(pp, vecs);
+				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
 				return 0;
 			}
diff --git a/multipathd/main.h b/multipathd/main.h
index f72580d..094b04f 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -22,8 +22,8 @@ void exit_daemon(void);
 const char * daemon_status(void);
 int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
-int ev_add_path (struct path *, struct vectors *);
-int ev_remove_path (struct path *, struct vectors *);
+int ev_add_path (struct path *, struct vectors *, int);
+int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 void sync_map_state (struct multipath *);
-- 
2.8.1.windows.1
