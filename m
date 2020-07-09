From: mwilck@suse.com
Subject: [PATCH 56/74] multipath-tools: introduce INIT_REMOVED
	state
Date: Thu,  9 Jul 2020 12:51:27 +0200
Message-ID: <20200709105145.9211-4-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

Introduce a new state for pp->initialized, INIT_REMOVED. This state
means that the path is about to be removed, either by a remove uevent
or by the operator. It will normally be a very short-lived state, because
the path will be deleted from pathvec quickly after setting this state.
Only if the path is member of a multipath map, and reloading the map
fails, this state will persist until a later map reload or flush eventually
cancels the membership in the map.

Paths in INIT_REMOVED state are treated as if they didn't exist.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c   |  4 ++++
 libmultipath/structs.h     |  5 +++++
 libmultipath/structs_vec.c | 17 +++++++++++++++++
 libmultipath/structs_vec.h |  1 +
 multipathd/main.c          |  5 +++--
 5 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c202d58..efcef67 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2078,6 +2078,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	if (!pp || !conf)
 		return PATHINFO_FAILED;
 
+	/* Treat removed paths as if they didn't exist */
+	if (pp->initialized == INIT_REMOVED)
+		return PATHINFO_FAILED;
+
 	/*
 	 * For behavior backward-compatibility with multipathd,
 	 * the blacklisting by filter_property|devnode() is not
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 894099d..1f0a78a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -193,6 +193,11 @@ enum initialized_states {
 	INIT_MISSING_UDEV,
 	INIT_REQUESTED_UDEV,
 	INIT_OK,
+	/*
+	 * INIT_REMOVED: supposed to be removed from pathvec, but still
+	 * mapped by some multipath map because of map reload failure.
+	 */
+	INIT_REMOVED,
 };
 
 enum prkey_sources {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 05c8626..27d6547 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -113,6 +113,23 @@ void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 	}
 }
 
+void set_path_removed(struct path *pp)
+{
+	struct multipath *mpp = pp->mpp;
+
+	orphan_path(pp, "removed");
+	/*
+	 * Keep link to mpp. It will be removed when the path
+	 * is successfully removed from the map.
+	 */
+	if (!mpp) {
+		condlog(0, "%s: internal error: mpp == NULL", pp->dev);
+		return;
+	}
+	pp->mpp = mpp;
+	pp->initialized = INIT_REMOVED;
+}
+
 void
 remove_map(struct multipath * mpp, struct vectors * vecs, int purge_vec)
 {
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 4b3b8b7..cf7d569 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -18,6 +18,7 @@ int adopt_paths (vector pathvec, struct multipath * mpp);
 void orphan_paths(vector pathvec, struct multipath *mpp,
 		  const char *reason);
 void orphan_path (struct path * pp, const char *reason);
+void set_path_removed(struct path *pp);
 
 int verify_paths(struct multipath * mpp, struct vectors * vecs);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
diff --git a/multipathd/main.c b/multipathd/main.c
index cd0e29b..4a5aa17 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1962,8 +1962,9 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	int marginal_pathgroups, marginal_changed = 0;
 	int ret;
 
-	if ((pp->initialized == INIT_OK ||
-	     pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp)
+	if (((pp->initialized == INIT_OK ||
+	      pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp) ||
+	    pp->initialized == INIT_REMOVED)
 		return 0;
 
 	if (pp->tick)
-- 
2.26.2
