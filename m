From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH] multipath-tools: check null path before handle
	path-failed event
Date: Mon, 4 Dec 2017 21:15:50 +0800
Message-ID: <1512393350-2956-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: guanjunxiong@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

In the hot-plug storage OS, if we tear down the target storage,
there is a race between the path removing from the path list and
handling the path-failed udev event. Therefore, we need to check
null path before handle path-failed event.

Signed-off-by: Guan Junxiong <guanjunxiong@huawei.com>
---
 multipathd/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 31ce923..84bb2c5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1073,7 +1073,7 @@ uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
 {
 	char *action = NULL, *devt = NULL;
 	struct path *pp;
-	int r;
+	int r = 1;
 
 	action = uevent_get_dm_action(uev);
 	if (!action)
@@ -1090,15 +1090,17 @@ uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
 	lock(&vecs->lock);
 	pthread_testcancel();
 	pp = find_path_by_devt(vecs->pathvec, devt);
+    if (!pp)
+        goto out_lock;
 	r = io_err_stat_handle_pathfail(pp);
-	lock_cleanup_pop(vecs->lock);
-
 	if (r)
 		condlog(3, "io_err_stat: %s: cannot handle pathfail uevent",
 				pp->dev);
+out_lock:
+	lock_cleanup_pop(vecs->lock);
 	FREE(devt);
 	FREE(action);
-	return 0;
+	return r;
 out:
 	FREE(action);
 	return 1;
-- 
2.6.4.windows.1
