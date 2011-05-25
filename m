From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipathd: Do not attempt to rename a device
Date: Wed, 25 May 2011 14:40:31 +0200
Message-ID: <201105251240.p4PCeVIY017739@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


If a device-mapper device got renamed we should be notified
via the waiter thread; no need to do it in the main loop.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index e07b5fd..189f25b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -326,7 +326,6 @@ set_no_path_retry(struct multipath *mpp)
 extern int
 setup_multipath (struct vectors * vecs, struct multipath * mpp)
 {
-retry:
 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		/* Error accessing table */
 		condlog(3, "%s: cannot access table", mpp->alias);
@@ -344,24 +343,6 @@ retry:
 	condlog(3, "%s: discover", mpp->alias);
 
 	if (update_multipath_strings(mpp, vecs->pathvec)) {
-		char *new_alias;
-
-		/*
-		 * detect an external rename of the multipath device
-		 */
-		new_alias = dm_get_name(mpp->wwid);
-		if (new_alias) {
-			condlog(3, "%s multipath mapped device name has "
-				"changed from %s to %s", mpp->wwid,
-				mpp->alias, new_alias);
-			FREE(mpp->alias);
-			mpp->alias = new_alias;
-
-			if (mpp->waiter)
-				strncpy(((struct event_thread *)mpp->waiter)->mapname,
-					new_alias, WWID_SIZE);
-			goto retry;
-		}
 		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
 	}
