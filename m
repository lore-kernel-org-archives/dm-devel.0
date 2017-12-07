From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 08/12] libmultipath: __setup_multipath param
	cleanup
Date: Thu,  7 Dec 2017 12:49:02 -0600
Message-ID: <1512672546-12785-9-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

setup multipath is only called by the daemon, so there is no point in
the is_daemon parameter.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 6 +++---
 libmultipath/structs_vec.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 70fb005..814a4b9 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -336,7 +336,7 @@ void set_no_path_retry(struct config *conf, struct multipath *mpp)
 }
 
 int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
-		      int reset, int is_daemon)
+		      int reset)
 {
 	struct config *conf;
 
@@ -352,7 +352,7 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 		goto out;
 	}
 
-	if (update_multipath_strings(mpp, vecs->pathvec, is_daemon)) {
+	if (update_multipath_strings(mpp, vecs->pathvec, 1)) {
 		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
 	}
@@ -594,7 +594,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 		return 2;
 	}
 
-	if (__setup_multipath(vecs, mpp, reset, 1))
+	if (__setup_multipath(vecs, mpp, reset))
 		return 1; /* mpp freed in setup_multipath */
 
 	/*
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 54865d7..04fa0dd 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -20,8 +20,8 @@ void orphan_path (struct path * pp, const char *reason);
 int verify_paths(struct multipath * mpp, struct vectors * vecs);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
-		       int reset, int is_daemon);
-#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1, 1)
+		       int reset);
+#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
 int update_multipath_strings (struct multipath *mpp, vector pathvec,
 			      int is_daemon);
 void extract_hwe_from_path(struct multipath * mpp);
-- 
2.7.4
