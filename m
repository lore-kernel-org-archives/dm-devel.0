From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/3] remove deleted path from pathvec
Date: Thu, 12 Mar 2009 13:38:11 -0500
Message-ID: <1236883093-2989-2-git-send-email-bmarzins@redhat.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

When the last path in a multipath map was removed, the path wasn't getting
deleted from the pathvec before it was getting freed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 36aa93c..98153df 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -488,7 +488,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 		if (update_mpp_paths(mpp, vecs->pathvec)) {
 			condlog(0, "%s: failed to update paths",
 				mpp->alias);
-			goto out;
+			goto fail;
 		}
 		if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
 			vector_del_slot(mpp->paths, i);
@@ -507,8 +507,8 @@ ev_remove_path (char * devname, struct vectors * vecs)
 				condlog(2, "%s: removed map after"
 					" removing all paths",
 					alias);
-				free_path(pp);
-				return 0;
+				retval = 0;
+				goto out;
 			}
 			/*
 			 * Not an error, continue
@@ -519,7 +519,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 			condlog(0, "%s: failed to setup map for"
 				" removal of path %s", mpp->alias,
 				devname);
-			goto out;
+			goto fail;
 		}
 		/*
 		 * reload the map
@@ -535,7 +535,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 			 * update our state from kernel
 			 */
 			if (setup_multipath(vecs, mpp)) {
-				goto out;
+				goto fail;
 			}
 			sync_map_state(mpp);
 
@@ -544,6 +544,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 		}
 	}
 
+out:
 	if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
 		vector_del_slot(vecs->pathvec, i);
 
@@ -551,7 +552,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 
 	return retval;
 
-out:
+fail:
 	remove_map_and_stop_waiter(mpp, vecs, 1);
 	return 1;
 }
-- 
1.5.3.3
