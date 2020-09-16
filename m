From: mwilck@suse.com
Subject: [PATCH 09/19] multipath-tools: don't call
	dm_lib_release() any more
Date: Wed, 16 Sep 2020 17:37:08 +0200
Message-ID: <20200916153718.582-10-mwilck@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The purpose of dm_lib_release() is to release stacked device node
operations in libdevmapper. This is functionality we don't need and
use any more, as we rely on udev to set up device nodes and symlinks.

We always set DM_UDEV_DISABLE_LIBRARY_FALLBACK when we run dm tasks.
In the standard CREATE and REMOVE cases, libdevmapper doesn't
stack any operations if this flag is set. The only exceptions are

 a) RESUME operations with DM_ADD_NODE_ON_RESUME set. This happens
implicity when we create new maps
 b) RENAME operations

In both cases, we call dm_udev_wait() after the libdm operation, which
calls update_devs() and thus has the same effect as dm_lib_release(),
cleaning out stacked operations.

OTOH, dm_lib_releases() accesses static variables in libdevmapper, so
calling it might be racy.

Drop the calls to dm_lib_release().

Cc: lixiaokeng@huawei.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c                 |  1 -
 libmpathpersist/mpath_persist.c |  1 -
 multipath/main.c                |  1 -
 multipathd/cli_handlers.c       |  2 --
 multipathd/main.c               | 15 ++-------------
 5 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 98f6176..8e5bc96 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -664,7 +664,6 @@ main(int argc, char **argv){
 	}
 
 end:
-	dm_lib_release();
 	dm_lib_exit();
 
 	return r;
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index e725604..729a8e4 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -56,7 +56,6 @@ mpath_lib_init (void)
 int
 mpath_lib_exit (struct config *conf)
 {
-	dm_lib_release();
 	dm_lib_exit();
 	cleanup_prio();
 	cleanup_checkers();
diff --git a/multipath/main.c b/multipath/main.c
index d227e0b..650977c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1066,7 +1066,6 @@ main (int argc, char *argv[])
 		condlog(3, "restart multipath configuration process");
 
 out:
-	dm_lib_release();
 	dm_lib_exit();
 
 	cleanup_foreign();
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8db3796..8f70593 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -860,7 +860,6 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 				    != CP_OK)
 					condlog(2, "%s: coalesce_paths failed",
 									param);
-				dm_lib_release();
 				FREE(refwwid);
 			}
 		} /*we attempt to create device only once*/
@@ -1032,7 +1031,6 @@ cli_resize(void *v, char **reply, int *len, void *data)
 	if (resize_map(mpp, size, vecs) != 0)
 		return 1;
 
-	dm_lib_release();
 	if (setup_multipath(vecs, mpp) != 0)
 		return 1;
 	sync_map_state(mpp);
diff --git a/multipathd/main.c b/multipathd/main.c
index 812d162..affe706 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -510,7 +510,6 @@ retry:
 		sleep(1);
 		goto retry;
 	}
-	dm_lib_release();
 
 fail:
 	if (new_map && (retries < 0 || wait_for_events(mpp, vecs))) {
@@ -611,10 +610,8 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 				vector_del_slot(ompv, i);
 				i--;
 			}
-			else {
-				dm_lib_release();
+			else
 				condlog(2, "%s devmap removed", ompp->alias);
-			}
 		} else if (reassign_maps) {
 			condlog(3, "%s: Reassign existing device-mapper"
 				" devices", ompp->alias);
@@ -660,10 +657,8 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 		}
 		return r;
 	}
-	else {
-		dm_lib_release();
+	else
 		condlog(2, "%s: map flushed", mpp->alias);
-	}
 
 	orphan_paths(vecs->pathvec, mpp, "map flushed");
 	remove_map_and_stop_waiter(mpp, vecs);
@@ -1080,7 +1075,6 @@ rescan:
 		else
 			goto fail_map;
 	}
-	dm_lib_release();
 
 	if ((mpp->action == ACT_CREATE ||
 	     (mpp->action == ACT_NOTHING && start_waiter && !mpp->waiter)) &&
@@ -1957,8 +1951,6 @@ int reload_and_sync_map(struct multipath *mpp,
 {
 	if (reload_map(vecs, mpp, refresh, 1))
 		return 1;
-
-	dm_lib_release();
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
 	sync_map_state(mpp);
@@ -2641,8 +2633,6 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
-	dm_lib_release();
-
 	if (should_exit())
 		goto fail;
 
@@ -3125,7 +3115,6 @@ child (__attribute__((unused)) void *param)
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
-	dm_lib_release();
 	dm_lib_exit();
 
 	/* We're done here */
-- 
2.28.0
