From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 17/19] multipathd: fix memory leak on error in
	configure
Date: Tue,  9 Oct 2018 18:03:14 -0500
Message-ID: <1539126196-28926-18-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

If configure fails after allocing mpvec, it must free it. Found by
coverity.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 463b1b8..04dce04 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2278,7 +2278,7 @@ configure (struct vectors * vecs)
 	ret = path_discovery(vecs->pathvec, DI_ALL);
 	if (ret < 0) {
 		condlog(0, "configure failed at path discovery");
-		return 1;
+		goto fail;
 	}
 
 	vector_foreach_slot (vecs->pathvec, pp, i){
@@ -2295,7 +2295,7 @@ configure (struct vectors * vecs)
 	}
 	if (map_discovery(vecs)) {
 		condlog(0, "configure failed at map discovery");
-		return 1;
+		goto fail;
 	}
 
 	/*
@@ -2309,7 +2309,7 @@ configure (struct vectors * vecs)
 		force_reload = FORCE_RELOAD_YES;
 	if (ret) {
 		condlog(0, "configure failed while coalescing paths");
-		return 1;
+		goto fail;
 	}
 
 	/*
@@ -2318,7 +2318,7 @@ configure (struct vectors * vecs)
 	 */
 	if (coalesce_maps(vecs, mpvec)) {
 		condlog(0, "configure failed while coalescing maps");
-		return 1;
+		goto fail;
 	}
 
 	dm_lib_release();
@@ -2354,6 +2354,10 @@ configure (struct vectors * vecs)
 			i--;
 	}
 	return 0;
+
+fail:
+	vector_free(mpvec);
+	return 1;
 }
 
 int
-- 
2.7.4
