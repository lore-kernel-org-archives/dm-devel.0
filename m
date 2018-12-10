From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 19/24] libmultipath: improve logging from
	orphan_paths
Date: Mon, 10 Dec 2018 10:49:54 +0100
Message-ID: <20181210094959.11338-20-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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

It's a big difference if a map is flushed from DM (changing kernel
state) or just removed from internal multipathd tables. Convey
this information in log messages.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 6 +++---
 libmultipath/structs_vec.h | 3 ++-
 multipathd/main.c          | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 5305bd31..03e2b978 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -102,14 +102,14 @@ void orphan_path(struct path *pp, const char *reason)
 	pp->fd = -1;
 }
 
-void orphan_paths(vector pathvec, struct multipath *mpp)
+void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 {
 	int i;
 	struct path * pp;
 
 	vector_foreach_slot (pathvec, pp, i) {
 		if (pp->mpp == mpp) {
-			orphan_path(pp, "map flushed");
+			orphan_path(pp, reason);
 		}
 	}
 }
@@ -122,7 +122,7 @@ remove_map(struct multipath * mpp, struct vectors * vecs, int purge_vec)
 	/*
 	 * clear references to this map
 	 */
-	orphan_paths(vecs->pathvec, mpp);
+	orphan_paths(vecs->pathvec, mpp, "map removed internally");
 
 	if (purge_vec &&
 	    (i = find_slot(vecs->mpvec, (void *)mpp)) != -1)
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index f7777aaf..f8b9f63e 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -14,7 +14,8 @@ struct vectors {
 void enter_recovery_mode(struct multipath *mpp);
 
 int adopt_paths (vector pathvec, struct multipath * mpp);
-void orphan_paths (vector pathvec, struct multipath * mpp);
+void orphan_paths(vector pathvec, struct multipath *mpp,
+		  const char *reason);
 void orphan_path (struct path * pp, const char *reason);
 
 int verify_paths(struct multipath * mpp, struct vectors * vecs);
diff --git a/multipathd/main.c b/multipathd/main.c
index 5e6c35d4..04f02d99 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -654,7 +654,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 		condlog(2, "%s: map flushed", mpp->alias);
 	}
 
-	orphan_paths(vecs->pathvec, mpp);
+	orphan_paths(vecs->pathvec, mpp, "map flushed");
 	remove_map_and_stop_waiter(mpp, vecs);
 
 	return 0;
-- 
2.19.2
