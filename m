From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/20] libmultipath: should_multipath: keep
	existing maps
Date: Mon, 19 Mar 2018 16:01:38 +0100
Message-ID: <20180319150155.5363-4-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

with find_multipaths "yes" and without the "-n" option to multipathd,
if a path is already multipathed, keep it. The same logic is applied by
"multipath -u -i".

To do this, we need to add a "mpvec" parameter to should_multipath().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c |  2 +-
 libmultipath/wwids.c     | 12 +++++++++++-
 libmultipath/wwids.h     |  2 +-
 multipathd/main.c        |  2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index fa6e21cb31af..16ce797c7d44 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -979,7 +979,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 			continue;
 
 		/* If find_multipaths was selected check if the path is valid */
-		if (!refwwid && !should_multipath(pp1, pathvec)) {
+		if (!refwwid && !should_multipath(pp1, pathvec, curmp)) {
 			orphan_path(pp1, "only one path");
 			continue;
 		}
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index bc70a27409d3..cb6ab52aaa5b 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -15,6 +15,7 @@
 #include "wwids.h"
 #include "defaults.h"
 #include "config.h"
+#include "devmapper.h"
 
 /*
  * Copyright (c) 2010 Benjamin Marzinski, Redhat
@@ -271,7 +272,7 @@ out:
 }
 
 int
-should_multipath(struct path *pp1, vector pathvec)
+should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 {
 	int i, ignore_new_devs;
 	struct path *pp2;
@@ -287,6 +288,15 @@ should_multipath(struct path *pp1, vector pathvec)
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
 	if (!ignore_new_devs) {
+		char tmp_wwid[WWID_SIZE];
+		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
+
+		if (mp != NULL && dm_get_uuid(mp->alias, tmp_wwid) == 0 &&
+		    !strncmp(tmp_wwid, pp1->wwid, WWID_SIZE)) {
+			condlog(3, "wwid %s is already multipathed, keeping it",
+				pp1->wwid);
+			return 1;
+		}
 		vector_foreach_slot(pathvec, pp2, i) {
 			if (pp1->dev == pp2->dev)
 				continue;
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index 95270129daa0..d9a78b38ccf8 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -12,7 +12,7 @@
 "#\n" \
 "# Valid WWIDs:\n"
 
-int should_multipath(struct path *pp, vector pathvec);
+int should_multipath(struct path *pp, vector pathvec, vector mpvec);
 int remember_wwid(char *wwid);
 int check_wwids_file(char *wwid, int write_wwid);
 int remove_wwid(char *wwid);
diff --git a/multipathd/main.c b/multipathd/main.c
index 0435133fadfb..707245c67231 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -933,7 +933,7 @@ rescan:
 		mpp->action = ACT_RELOAD;
 		extract_hwe_from_path(mpp);
 	} else {
-		if (!should_multipath(pp, vecs->pathvec)) {
+		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
 			orphan_path(pp, "only one path");
 			return 0;
 		}
-- 
2.16.1
