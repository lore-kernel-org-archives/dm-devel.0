From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 5/5] multipathd: decrease log level of uevent
	messages
Date: Fri, 14 Sep 2018 14:51:03 +0200
Message-ID: <20180914125103.1154-5-mwilck@suse.com>
References: <20180914125103.1154-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180914125103.1154-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The messages "multipathd: add path (uevent)" etc. are displayed
frequently, and often for devices that don't matter for multipathd.
If real action needs to be taken, such as adding or removing paths
or maps from the internal structures, multipathd emits other log
messages at level 2 later on.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index cc493c18..bc95c65f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -743,7 +743,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 	int minor;
 	struct multipath *mpp;
 
-	condlog(2, "%s: remove map (uevent)", uev->kernel);
+	condlog(3, "%s: remove map (uevent)", uev->kernel);
 	alias = uevent_get_dm_name(uev);
 	if (!alias) {
 		condlog(3, "%s: No DM_NAME in uevent, ignoring", uev->kernel);
@@ -803,7 +803,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	int ret = 0, i;
 	struct config *conf;
 
-	condlog(2, "%s: add path (uevent)", uev->kernel);
+	condlog(3, "%s: add path (uevent)", uev->kernel);
 	if (strstr(uev->kernel, "..") != NULL) {
 		/*
 		 * Don't allow relative device names in the pathvec
@@ -911,7 +911,8 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT &&
 	      mpp->ghost_delay_tick <= 0))) {
 		/* if wait_for_udev is set and valid paths exist */
-		condlog(2, "%s: delaying path addition until %s is fully initialized", pp->dev, mpp->alias);
+		condlog(3, "%s: delaying path addition until %s is fully initialized",
+			pp->dev, mpp->alias);
 		mpp->wait_for_udev = 2;
 		orphan_path(pp, "waiting for create to complete");
 		return 0;
@@ -1038,7 +1039,7 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	struct path *pp;
 	int ret;
 
-	condlog(2, "%s: remove path (uevent)", uev->kernel);
+	condlog(3, "%s: remove path (uevent)", uev->kernel);
 	delete_foreign(uev->udev);
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-- 
2.18.0
