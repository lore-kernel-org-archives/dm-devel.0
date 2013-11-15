From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/13] Improve logging for orphan_path()
Date: Fri, 15 Nov 2013 11:29:32 +0100
Message-ID: <1384511384-27642-2-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

orphan_path() is called from various sections, so add a
description to the call to aid debugging.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c   | 4 ++--
 libmultipath/structs_vec.c | 6 +++---
 libmultipath/structs_vec.h | 2 +-
 multipathd/main.c          | 5 +++--
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7f5e065..aad3c9f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -518,7 +518,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		/* 1. if path has no unique id or wwid blacklisted */
 		if (memcmp(empty_buff, pp1->wwid, WWID_SIZE) == 0 ||
 		    filter_path(conf, pp1) > 0) {
-			orphan_path(pp1);
+			orphan_path(pp1, "wwid blacklisted");
 			continue;
 		}
 
@@ -528,7 +528,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 
 		/* 3. if path has disappeared */
 		if (!pp1->size) {
-			orphan_path(pp1);
+			orphan_path(pp1, "invalid size");
 			continue;
 		}
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 993d3e0..14ea1c7 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -77,8 +77,9 @@ adopt_paths (vector pathvec, struct multipath * mpp, int get_info)
 }
 
 extern void
-orphan_path (struct path * pp)
+orphan_path (struct path * pp, const char *reason)
 {
+	condlog(3, "%s: orphan path, %s", pp->dev, reason);
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
@@ -98,8 +99,7 @@ orphan_paths (vector pathvec, struct multipath * mpp)
 
 	vector_foreach_slot (pathvec, pp, i) {
 		if (pp->mpp == mpp) {
-			condlog(4, "%s: orphaned", pp->dev);
-			orphan_path(pp);
+			orphan_path(pp, "map flushed");
 		}
 	}
 }
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index a907e85..c6278ac 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -17,7 +17,7 @@ void set_no_path_retry(struct multipath *mpp);
 
 int adopt_paths (vector pathvec, struct multipath * mpp, int get_info);
 void orphan_paths (vector pathvec, struct multipath * mpp);
-void orphan_path (struct path * pp);
+void orphan_path (struct path * pp, const char *reason);
 
 int verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
diff --git a/multipathd/main.c b/multipathd/main.c
index 8681aa2..91d7bfc 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -139,6 +139,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 	int j;
 
 	vector_foreach_slot (ompv, ompp, i) {
+		condlog(3, "%s: coalesce map", ompp->alias);
 		if (!find_mp_by_wwid(nmpv, ompp->wwid)) {
 			/*
 			 * remove all current maps not allowed by the
@@ -229,7 +230,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs)
 	}
 	else {
 		dm_lib_release();
-		condlog(2, "%s: devmap removed", mpp->alias);
+		condlog(2, "%s: map flushed", mpp->alias);
 	}
 
 	orphan_paths(vecs->pathvec, mpp);
@@ -561,7 +562,7 @@ rescan:
 fail_map:
 	remove_map(mpp, vecs, 1);
 fail:
-	orphan_path(pp);
+	orphan_path(pp, "failed to add path");
 	return 1;
 }
 
-- 
1.8.1.4
