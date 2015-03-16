From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 42/78] Remove last argument from verify_paths()
Date: Mon, 16 Mar 2015 13:36:29 +0100
Message-ID: <1426509425-15978-43-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Argument is always NULL, so remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c   |  2 +-
 libmultipath/structs_vec.c | 14 +++++---------
 libmultipath/structs_vec.h |  2 +-
 multipathd/main.c          |  2 +-
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a30ca59..2465563 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -820,7 +820,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			if (pp2->priority == PRIO_UNDEF)
 				mpp->action = ACT_REJECT;
 		}
-		verify_paths(mpp, vecs, NULL);
+		verify_paths(mpp, vecs);
 
 		params[0] = '\0';
 		if (setup_map(mpp, params, PARAMS_SIZE)) {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6be8c51..6d2d45e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -489,7 +489,7 @@ out:
 }
 
 extern int
-verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec)
+verify_paths(struct multipath * mpp, struct vectors * vecs)
 {
 	struct path * pp;
 	int count = 0;
@@ -515,14 +515,10 @@ verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec)
 			vector_del_slot(mpp->paths, i);
 			i--;
 
-			if (rpvec)
-				store_path(rpvec, pp);
-			else {
-				if ((j = find_slot(vecs->pathvec,
-						   (void *)pp)) != -1)
-					vector_del_slot(vecs->pathvec, j);
-				free_path(pp);
-			}
+			if ((j = find_slot(vecs->pathvec,
+					   (void *)pp)) != -1)
+				vector_del_slot(vecs->pathvec, j);
+			free_path(pp);
 		} else {
 			condlog(4, "%s: verified path %s dev_t %s",
 				mpp->alias, pp->dev, pp->dev_t);
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index c6278ac..eb8e672 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -19,7 +19,7 @@ int adopt_paths (vector pathvec, struct multipath * mpp, int get_info);
 void orphan_paths (vector pathvec, struct multipath * mpp);
 void orphan_path (struct path * pp, const char *reason);
 
-int verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec);
+int verify_paths(struct multipath * mpp, struct vectors * vecs);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 		       int reset);
diff --git a/multipathd/main.c b/multipathd/main.c
index 6a3fd5e..ffe4326 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -495,7 +495,7 @@ rescan:
 		if (adopt_paths(vecs->pathvec, mpp, 1))
 			goto fail; /* leave path added to pathvec */
 
-		verify_paths(mpp, vecs, NULL);
+		verify_paths(mpp, vecs);
 		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 	} else {
-- 
1.8.4.5
