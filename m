From: tang.junhui@zte.com.cn
Subject: [PATCH 02/11] libmultipath: add merge_node for "struct
	uevent" to record nodes of merged uevents
Date: Thu, 12 Jan 2017 13:52:18 +0800
Message-ID: <1484200347-11188-3-git-send-email-tang.junhui@zte.com.cn>
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

Add merged nodes list to store nodes of merged uevents. By Adding
this member, after merging, the list of uevents would be linked like
this:
uevent
 ---------------------------
|struct list_head node      |----->list node of un-merged uevents
 ---------------------------
|struct list_head merge_node|----->list node of merged uevents, which
----------------------------       moved from the origin un-merged list
|...                        |
 ---------------------------

Change-Id: I5fbfc7656ede77e03ca35c855212e2d2d60706b2
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 4 +++-
 libmultipath/uevent.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 5bde864..9b6b1d1 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -72,8 +72,10 @@ struct uevent * alloc_uevent (void)
 {
 	struct uevent *uev = MALLOC(sizeof(struct uevent));
 
-	if (uev)
+	if (uev) {
 		INIT_LIST_HEAD(&uev->node);
+		INIT_LIST_HEAD(&uev->merge_node);
+	}
 
 	return uev;
 }
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 3f83bab..9f65327 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -17,6 +17,7 @@ struct udev;
 
 struct uevent {
 	struct list_head node;
+	struct list_head merge_node;
 	struct udev_device *udev;
 	char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];
 	char *devpath;
-- 
2.8.1.windows.1
