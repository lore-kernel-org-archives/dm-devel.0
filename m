From: tang.junhui@zte.com.cn
Subject: [PATCH 10/12] libmultipath: filter uevents before
	proccessing
Date: Tue, 27 Dec 2016 16:03:27 +0800
Message-ID: <1482825809-9528-11-git-send-email-tang.junhui@zte.com.cn>
References: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, hare@suse.de, bmarzins@redhat.com, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

Before merging uevents, these uevents are going to be filtered:
Change or addition uevent of a removed path (it indicate by an
deletion uevent occurred later).

Change-Id: If00c2c2e23ea466c1d4643c541ed2d8f9a0c8dea
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 114068c..424f272 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -140,6 +140,28 @@ uevent_can_discard(char *devpath, char *kernel)
 }
 
 bool
+uevent_can_filter(struct uevent *earlier, struct uevent *later)
+{
+
+	/*
+	 * filter earlier uvents if path has removed later, eg:
+	 * "add path3 |chang path3 |add path2 |remove path3"
+	 * can filter as:
+	 * "add path2 |remove path3"
+	 * uevent "add path3" and "chang path3" are filtered out
+	 */
+	if (earlier->wwid && later->wwid &&
+		!strcmp(earlier->wwid, later->wwid) &&
+		strncmp(later->kernel, "dm-", 3) &&
+		!strcmp(later->action, "remove") &&
+		!strcmp(earlier->kernel, later->kernel)) {
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
@@ -196,6 +218,38 @@ uevent_can_merge(struct uevent *earlier, struct uevent *later)
 }
 
 void
+uevent_filter(struct uevent *later, struct list_head *tmpq)
+{
+	struct uevent *earlier, *temp;
+	/*
+	 * compare the uevent with earlier uevents
+	 */
+	list_for_some_entry_reverse(earlier, &later->node, tmpq, node) {
+next_earlier_node:
+		/*
+		 * filter unnessary earlier uevents by the later uevent
+		 */
+		if (uevent_can_filter(earlier, later)) {
+			condlog(2, "uevent: %s-%s-%s has removed by uevent: %s-%s-%s, filtered",
+				earlier->action, earlier->kernel, earlier->wwid,
+				later->action, later->kernel, later->wwid);
+
+			temp = earlier;
+			earlier = list_entry(earlier->node.prev, typeof(struct uevent), node);
+			list_del_init(&temp->node);
+			if (temp->udev)
+				udev_device_unref(temp->udev);
+			FREE(temp);
+
+			if (earlier ==  list_entry(tmpq, typeof(struct uevent), node))
+				break;
+			else
+				goto next_earlier_node;
+		}
+	}
+}
+
+void
 uevent_merge(struct uevent *later, struct list_head *tmpq)
 {
 	struct uevent *earlier, *temp;
@@ -232,6 +286,7 @@ merge_uevq(struct list_head *tmpq)
 	struct uevent *later;
 
 	list_for_each_entry_reverse(later, tmpq, node) {
+		uevent_filter(later, tmpq);
 		uevent_merge(later, tmpq);
 	}
 }
-- 
2.8.1.windows.1
