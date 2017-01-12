From: tang.junhui@zte.com.cn
Subject: [PATCH 09/11] multipathd: merge uevents before
	proccessing
Date: Thu, 12 Jan 2017 13:52:25 +0800
Message-ID: <1484200347-11188-10-git-send-email-tang.junhui@zte.com.cn>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
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

From: tang.junhui <tang.junhui@zte.com.cn>

These uevents are going to be merged:
1) uevents come from paths and
2) uevents type is same and
3) uevents type is addition or deletion and
4) uevents merge_id is same.

Change-Id: I05ee057391c092aa0c5f989b7a4f9cb550bb4d98
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 117 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 105 insertions(+), 12 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index f231dad..7282a51 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -89,6 +89,20 @@ struct uevent * alloc_uevent (void)
 	return uev;
 }
 
+void
+uevq_cleanup(struct list_head *tmpq)
+{
+	struct uevent *uev, *tmp;
+
+	list_for_each_entry_safe(uev, tmp, tmpq, node) {
+		list_del_init(&uev->node);
+
+		if (uev->udev)
+			udev_device_unref(uev->udev);
+		FREE(uev);
+	}
+}
+
 bool
 uevent_can_discard(struct uevent *uev)
 {
@@ -129,6 +143,62 @@ uevent_can_discard(struct uevent *uev)
 	return false;
 }
 
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
+	 * we can not make a jugement without merge_id,
+	 * so it is sensible to stop merging
+	 */
+	if (!earlier->merge_id || !later->merge_id)
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
+	 * with the same merge_id and different action
+	 * it would be better to stop merging.
+	 */
+	if (!strcmp(earlier->merge_id, later->merge_id) &&
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
+	 * whose merge_ids exsit and are same
+	 * and actions are same,
+	 * and actions are addition or deletion
+	 */
+	if (earlier->merge_id && later->merge_id &&
+	    !strcmp(earlier->merge_id, later->merge_id) &&
+	    !strcmp(earlier->action, later->action) &&
+	    strncmp(earlier->action, "change", 6) &&
+	    strncmp(earlier->kernel, "dm-", 3)) {
+		return true;
+	}
+
+	return false;
+}
+
 void
 uevent_discard(struct list_head *tmpq)
 {
@@ -145,6 +215,38 @@ uevent_discard(struct list_head *tmpq)
 }
 
 void
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
+			condlog(3, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",
+				earlier->action, earlier->kernel, earlier->merge_id,
+				later->action, later->kernel, later->merge_id);
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
+	uevent_discard(tmpq);
+	list_for_each_entry_reverse(later, tmpq, node) {
+		uevent_merge(later, tmpq);
+	}
+}
+
+void
 service_uevq(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
@@ -155,6 +257,8 @@ service_uevq(struct list_head *tmpq)
 		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
 			condlog(0, "uevent trigger error");
 
+		uevq_cleanup(&uev->merge_node);
+
 		if (uev->udev)
 			udev_device_unref(uev->udev);
 		FREE(uev);
@@ -169,17 +273,6 @@ static void uevent_cleanup(void *arg)
 	udev_unref(udev);
 }
 
-void
-uevq_cleanup(struct list_head *tmpq)
-{
-	struct uevent *uev, *tmp;
-
-	list_for_each_entry_safe(uev, tmp, tmpq, node) {
-		list_del_init(&uev->node);
-		FREE(uev);
-	}
-}
-
 /*
  * Service the uevent queue.
  */
@@ -208,7 +301,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 		pthread_mutex_unlock(uevq_lockp);
 		if (!my_uev_trigger)
 			break;
-		uevent_discard(&uevq_tmp);
+		merge_uevq(&uevq_tmp);
 		service_uevq(&uevq_tmp);
 	}
 	condlog(3, "Terminating uev service queue");
-- 
2.8.1.windows.1
