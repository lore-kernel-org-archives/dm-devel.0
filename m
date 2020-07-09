From: mwilck@suse.com
Subject: [PATCH 40/42] libmultipath: refuse creating map with
	duplicate alias
Date: Thu,  9 Jul 2020 12:35:11 +0200
Message-ID: <20200709103513.8142-2-mwilck@suse.com>
References: <20200709103513.8142-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103513.8142-1-mwilck@suse.com>
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

If for some reason (e.g. user configuration error) the same alias
is used for different WWIDs, multipathd starts behaving very weirdly.
Sooner or later it "fixes" pp->wwid of some paths to match those of
the other WWID, and may eventually coalesce paths with different WWIDs
into one map, causing data corruption.

Fix this by refusing to add a map with an already existing alias.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   |  5 +++++
 libmultipath/structs_vec.c | 13 +++++++++++++
 libmultipath/structs_vec.h |  1 +
 multipathd/main.c          |  6 +++++-
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 315eb6a..c62807e 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1187,6 +1187,11 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		}
 		verify_paths(mpp, vecs);
 
+		if (does_alias_exist(newmp, mpp)) {
+			remove_map(mpp, vecs, PURGE_VEC);
+			continue;
+		}
+
 		params[0] = '\0';
 		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 			remove_map(mpp, vecs, 0);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8137ea2..c7dffb7 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -424,6 +424,19 @@ find_existing_alias (struct multipath * mpp,
 		}
 }
 
+bool does_alias_exist(const struct _vector *mpvec, const struct multipath *mpp)
+{
+	const struct multipath *other;
+
+	other = find_mp_by_alias(mpvec, mpp->alias);
+	if (other == NULL || !strcmp(other->wwid, mpp->wwid))
+		return false;
+	condlog(0, "%s: alias \"%s\" already present with WWID %s, skipping",
+		mpp->wwid, mpp->alias, other->wwid);
+	condlog(0, "please check alias settings in config and bindings file");
+	return true;
+}
+
 struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 				    int add_vec)
 {
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 2a5e3d6..4b3b8b7 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -33,6 +33,7 @@ void remove_map_by_alias(const char *alias, struct vectors * vecs,
 void remove_maps (struct vectors * vecs);
 
 void sync_map_state (struct multipath *);
+bool does_alias_exist(const struct _vector *mpvec, const struct multipath *mpp);
 struct multipath * add_map_with_path (struct vectors * vecs,
 				struct path * pp, int add_vec);
 void update_queue_mode_del_path(struct multipath *mpp);
diff --git a/multipathd/main.c b/multipathd/main.c
index 40c050b..cd0e29b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -966,8 +966,12 @@ rescan:
 			orphan_path(pp, "only one path");
 			return 0;
 		}
-		condlog(4,"%s: creating new map", pp->dev);
 		if ((mpp = add_map_with_path(vecs, pp, 1))) {
+			if (does_alias_exist(vecs->mpvec, mpp)) {
+				remove_map(mpp, vecs, PURGE_VEC);
+				return 0;
+			}
+			condlog(4,"%s: creating new map", pp->dev);
 			mpp->action = ACT_CREATE;
 			/*
 			 * We don't depend on ACT_CREATE, as domap will
-- 
2.26.2
