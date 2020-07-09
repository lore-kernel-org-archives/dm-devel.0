From: mwilck@suse.com
Subject: [PATCH 80/80] libmultipath: select_action(): don't drop
	map if alias clashes
Date: Thu,  9 Jul 2020 13:03:30 +0200
Message-ID: <20200709110330.9917-7-mwilck@suse.com>
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

If for a given map, if we find that the requested alias is already
used by a map with different WWID, while the map's own WWID is
not used yet, give up the alias and use the WWID instead. This
is safer than trying to destroy the existing map, which is likely
to fail.

This allows us to make use const for the "curmp" parameter.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 13 +++++++------
 libmultipath/configure.h |  3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b77c2a8..7931045 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -688,7 +688,8 @@ select_reload_action(struct multipath *mpp, const struct multipath *cmpp,
 		reason);
 }
 
-void select_action (struct multipath *mpp, vector curmp, int force_reload)
+void select_action (struct multipath *mpp, const struct _vector *curmp,
+		    int force_reload)
 {
 	struct multipath * cmpp;
 	struct multipath * cmpp_by_name;
@@ -716,12 +717,12 @@ void select_action (struct multipath *mpp, vector curmp, int force_reload)
 	}
 
 	if (!cmpp) {
-		condlog(2, "%s: remove (wwid changed)", mpp->alias);
-		dm_flush_map(mpp->alias);
-		strlcpy(cmpp_by_name->wwid, mpp->wwid, WWID_SIZE);
-		drop_multipath(curmp, cmpp_by_name->wwid, KEEP_PATHS);
+		condlog(1, "%s: can't use alias \"%s\" used by %s, falling back to WWID",
+			mpp->wwid, mpp->alias, cmpp_by_name->wwid);
+		/* We can do this because wwid wasn't found */
+		strlcpy(mpp->alias, mpp->wwid, sizeof(mpp->alias));
 		mpp->action = ACT_CREATE;
-		condlog(3, "%s: set ACT_CREATE (map wwid change)",
+		condlog(3, "%s: set ACT_CREATE (map does not exist, name changed)",
 			mpp->alias);
 		return;
 	}
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 9907775..6b23ccb 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -49,7 +49,8 @@ struct vectors;
 
 int setup_map (struct multipath * mpp, char * params, int params_size,
 	       struct vectors *vecs );
-void select_action (struct multipath *mpp, vector curmp, int force_reload);
+void select_action (struct multipath *mpp, const struct _vector *curmp,
+		    int force_reload);
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
-- 
2.26.2
