From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/57] multipathd: Do not update the paths vec
	when removing paths
Date: Wed, 27 Apr 2016 13:10:21 +0200
Message-ID: <1461755458-29225-21-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When we remove a path it's totally pointless to add it to
the path list first; it'll be removed on the next step anyway.
And we should be cleaning up the comments while we're at it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 59f0c68..61b82f6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -695,14 +695,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 	 */
 	if ((mpp = pp->mpp)) {
 		/*
-		 * transform the mp->pg vector of vectors of paths
-		 * into a mp->params string to feed the device-mapper
+		 * Remove path from paths list
 		 */
-		if (update_mpp_paths(mpp, vecs->pathvec)) {
-			condlog(0, "%s: failed to update paths",
-				mpp->alias);
-			goto fail;
-		}
 		if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
 			vector_del_slot(mpp->paths, i);
 
@@ -735,6 +729,10 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 			 */
 		}
 
+		/*
+		 * transform the mp->pg vector of vectors of paths
+		 * into a mp->params string to feed the device-mapper
+		 */
 		if (setup_map(mpp, params, PARAMS_SIZE)) {
 			condlog(0, "%s: failed to setup map for"
 				" removal of path %s", mpp->alias, pp->dev);
@@ -1016,6 +1014,7 @@ uxlsnrloop (void * ap)
 
 	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
+	condlog(1, "terminate uxsock listener");
 
 	return NULL;
 }
-- 
2.6.6
