From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 22/24] domap(): use symbolic return value
Date: Mon,  3 Dec 2018 20:36:22 +0100
Message-ID: <20181203193624.21870-5-mwilck@suse.com>
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

Use an enum for the already-symbolic return value of domap(), and
avoid the use of "<= 0" for the return value, which is against the
spirit of symbolic values. A return value less or equal than 0 means
DOMAP_FAIL or DOMAP_RETRY. Use the fact that DOMAP_RETRY is only
returned in the ACT_CREATE case for simplification of the logic
in those cases where ACT_CREATE is not used.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c  |  9 ---------
 libmultipath/configure.h  | 13 +++++++++++++
 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         |  6 +++---
 4 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5daf0c13..84ae5f56 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -788,15 +788,6 @@ fail:
 	return 1;
 }
 
-/*
- * Return value:
- */
-#define DOMAP_RETRY	-1
-#define DOMAP_FAIL	0
-#define DOMAP_OK	1
-#define DOMAP_EXIST	2
-#define DOMAP_DRY	3
-
 int domap(struct multipath *mpp, char *params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 64520c57..1b73bf42 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -23,6 +23,19 @@ enum actions {
 	ACT_IMPOSSIBLE,
 };
 
+/*
+ * Return value of domap()
+ * DAEMON_RETRY is only used in non-daemon case (multipath),
+ * and only for ACT_CREATE (see domap()).
+ */
+enum {
+	DOMAP_RETRY	= -1,
+	DOMAP_FAIL	= 0,
+	DOMAP_OK	= 1,
+	DOMAP_EXIST	= 2,
+	DOMAP_DRY	= 3
+};
+
 /*
  * Return value of coalesce_paths()
  * CP_RETRY is only used in non-daemon case (multipath).
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4fbd8841..14aec17b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -893,7 +893,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	}
 	mpp->action = ACT_RESIZE;
 	mpp->force_udev_reload = 1;
-	if (domap(mpp, params, 1) <= 0) {
+	if (domap(mpp, params, 1) == DOMAP_FAIL) {
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
 		mpp->size = orig_size;
diff --git a/multipathd/main.c b/multipathd/main.c
index 2ea954ae..d0e7107c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -498,7 +498,7 @@ retry:
 		retries = -1;
 		goto fail;
 	}
-	if (domap(mpp, params, 1) <= 0 && retries-- > 0) {
+	if (domap(mpp, params, 1) == DOMAP_FAIL && retries-- > 0) {
 		condlog(0, "%s: map_udate sleep", mpp->alias);
 		sleep(1);
 		goto retry;
@@ -1000,7 +1000,7 @@ rescan:
 	 */
 retry:
 	ret = domap(mpp, params, 1);
-	if (ret <= 0) {
+	if (ret == DOMAP_FAIL || ret == DOMAP_RETRY) {
 		if (ret < 0 && retries-- > 0) {
 			condlog(0, "%s: retry domap for addition of new "
 				"path %s", mpp->alias, pp->dev);
@@ -1157,7 +1157,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		 * reload the map
 		 */
 		mpp->action = ACT_RELOAD;
-		if (domap(mpp, params, 1) <= 0) {
+		if (domap(mpp, params, 1) == DOMAP_FAIL) {
 			condlog(0, "%s: failed in domap for "
 				"removal of path %s",
 				mpp->alias, pp->dev);
-- 
2.19.1
