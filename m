From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/6] multipathd: remove unneeded function
	parameter
Date: Thu, 29 Mar 2018 22:37:01 -0500
Message-ID: <1522381023-15262-5-git-send-email-bmarzins@redhat.com>
References: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

remove_map_and_stop_waiter was always called with purge_vecs = 1, so
it can simply be removed, as suggested by Martin Wilck

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9a4f671..841d3e9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -311,14 +311,13 @@ wait_for_events(struct multipath *mpp, struct vectors *vecs)
 }
 
 static void
-remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs,
-			   int purge_vec)
+remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs)
 {
 	/* devices are automatically removed by the dmevent polling code,
 	 * so they don't need to be manually removed here */
 	if (!poll_dmevents)
 		stop_waiter_thread(mpp, vecs);
-	remove_map(mpp, vecs, purge_vec);
+	remove_map(mpp, vecs, PURGE_VEC);
 }
 
 static void
@@ -400,7 +399,7 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 
 	return 0;
 out:
-	remove_map_and_stop_waiter(mpp, vecs, PURGE_VEC);
+	remove_map_and_stop_waiter(mpp, vecs);
 	return 1;
 }
 
@@ -637,7 +636,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 	}
 
 	orphan_paths(vecs->pathvec, mpp);
-	remove_map_and_stop_waiter(mpp, vecs, 1);
+	remove_map_and_stop_waiter(mpp, vecs);
 
 	return 0;
 }
@@ -769,7 +768,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 	}
 
 	orphan_paths(vecs->pathvec, mpp);
-	remove_map_and_stop_waiter(mpp, vecs, 1);
+	remove_map_and_stop_waiter(mpp, vecs);
 out:
 	lock_cleanup_pop(vecs->lock);
 	FREE(alias);
@@ -1154,7 +1153,7 @@ out:
 	return retval;
 
 fail:
-	remove_map_and_stop_waiter(mpp, vecs, 1);
+	remove_map_and_stop_waiter(mpp, vecs);
 	return 1;
 }
 
@@ -1612,7 +1611,7 @@ mpvec_garbage_collector (struct vectors * vecs)
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
 		if (mpp && mpp->alias && !dm_map_present(mpp->alias)) {
 			condlog(2, "%s: remove dead map", mpp->alias);
-			remove_map_and_stop_waiter(mpp, vecs, 1);
+			remove_map_and_stop_waiter(mpp, vecs);
 			i--;
 		}
 	}
-- 
2.7.4
