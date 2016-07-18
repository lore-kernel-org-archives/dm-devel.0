From: tang.junhui@zte.com.cn
Subject: [PATCH] multipathd: fix memory leak in reconfigure()
Date: Mon, 18 Jul 2016 20:14:31 +0800
Message-ID: <1468844071-5484-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

Problem:
Memory leak exists in reconfigure() when multipathd command reconfigure is executed.

Reasons:
 * The following judgment condition is not satisfied when there is no path,
   free_pathvec() is not called to free the vector of vecs->pathvec:
       if (VECTOR_SIZE(vecs->pathvec))
           free_pathvec(vecs->pathvec, FREE_PATHS);
 * Then the vecs->pathvec is set to NULL, so the vector memory which
   vecs->pathvec pointed to is leaked:
       vecs->pathvec = NULL;

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 multipathd/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c129298..d9731cd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1997,9 +1997,7 @@ reconfigure (struct vectors * vecs)
 	if (VECTOR_SIZE(vecs->mpvec))
 		remove_maps_and_stop_waiters(vecs);
 
-	if (VECTOR_SIZE(vecs->pathvec))
-		free_pathvec(vecs->pathvec, FREE_PATHS);
-
+	free_pathvec(vecs->pathvec, FREE_PATHS);
 	vecs->pathvec = NULL;
 
 	/* Re-read any timezone changes */
-- 
2.8.1.windows.1

--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.
