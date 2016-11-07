From: tang.wenjun3@zte.com.cn
Subject: [PATCH] multipathd: fix uev_update_path dead lock
Date: Mon, 7 Nov 2016 16:12:18 +0800
Message-ID: <1478506338-9436-1-git-send-email-tang.wenjun3@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: 10144149 <tang.wenjun3@zte.com.cn>, tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

From: 10144149 <tang.wenjun3@zte.com.cn>

uev_update_path locked &vecs->lock, and it will get lock twice in uev_add_path;
and i think it better to retigger add path uevent directly in check_path.
---
 multipathd/main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d6f081f..3b1bea8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -994,9 +994,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				pp->wwid_changed = 0;
 		}
 
-		if (pp->initialized == INIT_REQUESTED_UDEV)
-			retval = uev_add_path(uev, vecs);
-		else if (mpp && ro >= 0) {
+		if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
 			if (mpp->wait_for_udev)
@@ -1504,12 +1502,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	put_multipath_config(conf);
 	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV &&
 	    pp->retriggers < retrigger_tries) {
-		condlog(2, "%s: triggering change event to reinitialize",
+		condlog(2, "%s: triggering add event to reinitialize",
 			pp->dev);
 		pp->initialized = INIT_REQUESTED_UDEV;
 		pp->retriggers++;
-		sysfs_attr_set_value(pp->udev, "uevent", "change",
-				     strlen("change"));
+		sysfs_attr_set_value(pp->udev, "uevent", "add",
+				     strlen("add"));
 		return 0;
 	}
 
-- 
2.8.1.windows.1
