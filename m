From: tang.junhui@zte.com.cn
Subject: [PATCH 10/11] libmultipath: filter uevents before
	proccessing
Date: Thu, 12 Jan 2017 13:52:26 +0800
Message-ID: <1484200347-11188-11-git-send-email-tang.junhui@zte.com.cn>
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

Before merging uevents, these uevents are going to be filtered:
1) Change or addition uevent of a removed path (it indicate by an
deletion uevent occurred later), and
2) Change uevent if addition uevent of a path has not ever been
proccessed.

Change-Id: If00c2c2e23ea466c1d4643c541ed2d8f9a0c8dea
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 7282a51..838f128 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -144,6 +144,40 @@ uevent_can_discard(struct uevent *uev)
 }
 
 bool
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
 merge_need_stop(struct uevent *earlier, struct uevent *later)
 {
 	/*
@@ -215,6 +249,29 @@ uevent_discard(struct list_head *tmpq)
 }
 
 void
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
 uevent_merge(struct uevent *later, struct list_head *tmpq)
 {
 	struct uevent *earlier, *tmp;
@@ -242,6 +299,7 @@ merge_uevq(struct list_head *tmpq)
 
 	uevent_discard(tmpq);
 	list_for_each_entry_reverse(later, tmpq, node) {
+		uevent_filter(later, tmpq);
 		uevent_merge(later, tmpq);
 	}
 }
-- 
2.8.1.windows.1
