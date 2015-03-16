From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 41/78] Add paths with a size of '0' as 'ghost'
	paths
Date: Mon, 16 Mar 2015 13:36:28 +0100
Message-ID: <1426509425-15978-42-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

SPC-3 does not require that a port in 'standby' has to support
the 'READ CAPACITY' command. As such we should not reject those
paths, but rather add them as 'ghost' paths.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c   |  5 +++++
 libmultipath/structs_vec.c |  2 +-
 multipathd/main.c          | 26 +++++---------------------
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7d3ff49..6ba14ac 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1215,6 +1215,11 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 				goto blank;
 			if (pp->state == PATH_TIMEOUT)
 				pp->state = PATH_DOWN;
+			if (pp->state == PATH_UP && !pp->size) {
+				condlog(3, "%s: device size is 0, "
+					"path unuseable", pp->dev);
+				pp->state = PATH_GHOST;
+			}
 		} else {
 			condlog(3, "%s: path inaccessible", pp->dev);
 			pp->chkrstate = pp->state = path_state;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 79f31b1..6be8c51 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -558,7 +558,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 
 			if (pp->state != PATH_DOWN) {
 				int oldstate = pp->state;
-				condlog(2, "%s: mark as failed", pp->dev_t);
+				condlog(2, "%s: mark as failed", pp->dev);
 				mpp->stat_path_failures++;
 				pp->state = PATH_DOWN;
 				if (oldstate == PATH_UP ||
diff --git a/multipathd/main.c b/multipathd/main.c
index ac1e1a2..6a3fd5e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -479,15 +479,10 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 	mpp = pp->mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 rescan:
 	if (mpp) {
-		if ((!pp->size) || (mpp->size != pp->size)) {
-			if (!pp->size)
-				condlog(0, "%s: failed to add new path %s, "
-					"device size is 0",
-					mpp->alias, pp->dev);
-			else
-				condlog(0, "%s: failed to add new path %s, "
-					"device size mismatch",
-					mpp->alias, pp->dev);
+		if (mpp->size != pp->size) {
+			condlog(0, "%s: failed to add new path %s, "
+				"device size mismatch",
+				mpp->alias, pp->dev);
 			int i = find_slot(vecs->pathvec, (void *)pp);
 			if (i != -1)
 				vector_del_slot(vecs->pathvec, i);
@@ -503,18 +498,7 @@ rescan:
 		verify_paths(mpp, vecs, NULL);
 		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
-	}
-	else {
-		if (!pp->size) {
-			condlog(0, "%s: failed to create new map,"
-				" device size is 0 ", pp->dev);
-			int i = find_slot(vecs->pathvec, (void *)pp);
-			if (i != -1)
-				vector_del_slot(vecs->pathvec, i);
-			free_path(pp);
-			return 1;
-		}
-
+	} else {
 		if (conf->find_multipaths &&
 		    !should_multipath(pp, vecs->pathvec)) {
 			orphan_path(pp, "only one path");
-- 
1.8.4.5
