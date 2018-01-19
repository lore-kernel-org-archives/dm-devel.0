From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 03/16] libmultipath: add mpvec param to
	should_multipath()
Date: Fri, 19 Jan 2018 01:29:03 +0100
Message-ID: <20180119002916.10323-4-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This will be used in a follow-up patch.
---
 libmultipath/configure.c | 2 +-
 libmultipath/wwids.c     | 2 +-
 libmultipath/wwids.h     | 2 +-
 multipathd/main.c        | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 13e14cc25fff..325018a78b95 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -970,7 +970,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 			continue;
 
 		/* If find_multipaths was selected check if the path is valid */
-		if (!refwwid && !should_multipath(pp1, pathvec)) {
+		if (!refwwid && !should_multipath(pp1, pathvec, curmp)) {
 			orphan_path(pp1, "only one path");
 			continue;
 		}
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index bc70a27409d3..fcbf5281b491 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -271,7 +271,7 @@ out:
 }
 
 int
-should_multipath(struct path *pp1, vector pathvec)
+should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 {
 	int i, ignore_new_devs;
 	struct path *pp2;
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
index 255d1d860b2a..98ce16ee020b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -699,7 +699,7 @@ rescan:
 		mpp->action = ACT_RELOAD;
 		extract_hwe_from_path(mpp);
 	} else {
-		if (!should_multipath(pp, vecs->pathvec)) {
+		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
 			orphan_path(pp, "only one path");
 			return 0;
 		}
-- 
2.15.1
