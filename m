From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 23/24] domap(): never return DOMAP_RETRY in
	daemon mode
Date: Mon,  3 Dec 2018 20:36:23 +0100
Message-ID: <20181203193624.21870-6-mwilck@suse.com>
References: <20181203193624.21870-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181203193624.21870-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

DOMAP_RETRY is only used by the multipath tool. multipathd always treats
it exactly like DOMAP_FAIL. Simplify logic by only returning
DOMAP_RETRY in non-daemon mode from domap().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 28 +++++++++++++---------------
 multipathd/main.c        |  9 +--------
 2 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 84ae5f56..1c549817 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -831,7 +831,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		if (lock_multipath(mpp, 1)) {
 			condlog(3, "%s: failed to create map (in use)",
 				mpp->alias);
-			return DOMAP_RETRY;
+			return is_daemon ? DOMAP_FAIL : DOMAP_RETRY;
 		}
 
 		sysfs_set_max_sectors_kb(mpp, 0);
@@ -1110,20 +1110,18 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 		r = domap(mpp, params, is_daemon);
 
-		if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
-			condlog(3, "%s: domap (%u) failure "
-				   "for create/reload map",
-				mpp->alias, r);
-			if (r == DOMAP_FAIL || is_daemon) {
-				condlog(2, "%s: %s map",
-					mpp->alias, (mpp->action == ACT_CREATE)?
-					"ignoring" : "removing");
-				remove_map(mpp, vecs, 0);
-				continue;
-			} else /* if (r == DOMAP_RETRY && !is_daemon) */ {
-				ret = CP_RETRY;
-				goto out;
-			}
+		if (r == DOMAP_RETRY) {
+			/* This happens in non-daemon case only */
+			ret = CP_RETRY;
+			goto out;
+		}
+
+		if (r == DOMAP_FAIL) {
+			condlog(2, "%s: domap failure, %s map",
+				mpp->alias, (mpp->action == ACT_CREATE) ?
+				"ignoring" : "removing");
+			remove_map(mpp, vecs, 0);
+			continue;
 		}
 		if (r == DOMAP_DRY)
 			continue;
diff --git a/multipathd/main.c b/multipathd/main.c
index d0e7107c..1bf3c481 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -998,15 +998,8 @@ rescan:
 	/*
 	 * reload the map for the multipath mapped device
 	 */
-retry:
 	ret = domap(mpp, params, 1);
-	if (ret == DOMAP_FAIL || ret == DOMAP_RETRY) {
-		if (ret < 0 && retries-- > 0) {
-			condlog(0, "%s: retry domap for addition of new "
-				"path %s", mpp->alias, pp->dev);
-			sleep(1);
-			goto retry;
-		}
+	if (ret == DOMAP_FAIL) {
 		condlog(0, "%s: failed in domap for addition of new "
 			"path %s", mpp->alias, pp->dev);
 		/*
-- 
2.19.1
