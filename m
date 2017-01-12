From: tang.junhui@zte.com.cn
Subject: [PATCH 07/11] multipathd: move calling filter_devnode()
	from uev_trigger() to uevent_can_discard()
Date: Thu, 12 Jan 2017 13:52:23 +0800
Message-ID: <1484200347-11188-8-git-send-email-tang.junhui@zte.com.cn>
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

Move calling filter_devnode() from uev_trigger() to uevent_can_discard()
since they do the similar work.

Change-Id: I0322443fa551b21aa3211bf1ce3fad7d37aeeab4
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 20 ++++++++++++++++++++
 multipathd/main.c     |  9 ---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index d6c02a6..b560a50 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -47,6 +47,9 @@
 #include "list.h"
 #include "uevent.h"
 #include "vector.h"
+#include "structs.h"
+#include "config.h"
+#include "blacklist.h"
 
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
@@ -86,6 +89,7 @@ uevent_can_discard(struct uevent *uev)
 {
 	char *tmp;
 	char a[11], b[11];
+	struct config * conf;
 
 	/*
 	 * keep only block devices, discard partitions
@@ -101,6 +105,22 @@ uevent_can_discard(struct uevent *uev)
 		return true;
 	}
 
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
 	return false;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 66d5c3d..24116e3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1120,7 +1120,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 {
 	int r = 0;
 	struct vectors * vecs;
-	struct config *conf;
 
 	vecs = (struct vectors *)trigger_data;
 
@@ -1154,14 +1153,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	/*
 	 * path add/remove event
 	 */
-	conf = get_multipath_config();
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0) {
-		put_multipath_config(conf);
-		goto out;
-	}
-	put_multipath_config(conf);
-
 	if (!strncmp(uev->action, "add", 3)) {
 		r = uev_add_path(uev, vecs, 1);
 		goto out;
-- 
2.8.1.windows.1
