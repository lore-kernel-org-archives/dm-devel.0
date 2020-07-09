From: mwilck@suse.com
Subject: [PATCH 79/80] multipathd: rename update_path_groups() ->
	reload_and_sync_map()
Date: Thu,  9 Jul 2020 13:03:29 +0200
Message-ID: <20200709110330.9917-6-mwilck@suse.com>
References: <20200709110330.9917-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709110330.9917-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

This function doesn't just update the path groups. It completely
rebuilds the multipath, reloads the kernel map, and syncs path
states. That should be reflected in the function name, which should
use the term "map", like all other functions that modify kernel state.

Todo: there's a large functional overlap between this function
and update_map(). Perhaps we should unify the two.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 8 ++++----
 multipathd/main.c         | 9 +++++----
 multipathd/main.h         | 4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 679fd57..d76fe90 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -941,7 +941,7 @@ cli_reload(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	return update_path_groups(mpp, vecs, 0);
+	return reload_and_sync_map(mpp, vecs, 0);
 }
 
 int resize_map(struct multipath *mpp, unsigned long long size,
@@ -1621,7 +1621,7 @@ int cli_set_marginal(void * v, char ** reply, int * len, void * data)
 	}
 	pp->marginal = 1;
 
-	return update_path_groups(pp->mpp, vecs, 0);
+	return reload_and_sync_map(pp->mpp, vecs, 0);
 }
 
 int cli_unset_marginal(void * v, char ** reply, int * len, void * data)
@@ -1648,7 +1648,7 @@ int cli_unset_marginal(void * v, char ** reply, int * len, void * data)
 	}
 	pp->marginal = 0;
 
-	return update_path_groups(pp->mpp, vecs, 0);
+	return reload_and_sync_map(pp->mpp, vecs, 0);
 }
 
 int cli_unset_all_marginal(void * v, char ** reply, int * len, void * data)
@@ -1685,5 +1685,5 @@ int cli_unset_all_marginal(void * v, char ** reply, int * len, void * data)
 		vector_foreach_slot (pgp->paths, pp, j)
 			pp->marginal = 0;
 
-	return update_path_groups(mpp, vecs, 0);
+	return reload_and_sync_map(mpp, vecs, 0);
 }
diff --git a/multipathd/main.c b/multipathd/main.c
index aa08807..e6d4652 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1327,7 +1327,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			else {
 				if (ro == 1)
 					pp->mpp->force_readonly = 1;
-				retval = update_path_groups(mpp, vecs, 0);
+				retval = reload_and_sync_map(mpp, vecs, 0);
 				if (retval == 2)
 					condlog(2, "%s: map removed during reload", pp->dev);
 				else {
@@ -1946,7 +1946,8 @@ static int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 	return 0;
 }
 
-int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
+int reload_and_sync_map(struct multipath *mpp,
+			struct vectors *vecs, int refresh)
 {
 	if (reload_map(vecs, mpp, refresh, 1))
 		return 1;
@@ -2379,11 +2380,11 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	condlog(4, "path prio refresh");
 
 	if (marginal_changed)
-		update_path_groups(pp->mpp, vecs, 1);
+		reload_and_sync_map(pp->mpp, vecs, 1);
 	else if (update_prio(pp, new_path_up) &&
 	    (pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio) &&
 	     pp->mpp->pgfailback == -FAILBACK_IMMEDIATE)
-		update_path_groups(pp->mpp, vecs, !new_path_up);
+		reload_and_sync_map(pp->mpp, vecs, !new_path_up);
 	else if (need_switch_pathgroup(pp->mpp, 0)) {
 		if (pp->mpp->pgfailback > 0 &&
 		    (new_path_up || pp->mpp->failback_tick <= 0))
diff --git a/multipathd/main.h b/multipathd/main.h
index 5dff17e..9aa2a0f 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -46,7 +46,7 @@ int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 		       int reset);
 #define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
 int update_multipath (struct vectors *vecs, char *mapname, int reset);
-int update_path_groups(struct multipath *mpp, struct vectors *vecs,
-		       int refresh);
+int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
+			int refresh);
 
 #endif /* MAIN_H */
-- 
2.26.2
