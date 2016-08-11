From: tang.wenjun3@zte.com.cn
Subject: [PATCH] multipathd: extend the scope of vecs lock in
	uev_add_path
Date: Thu, 11 Aug 2016 11:40:13 +0800
Message-ID: <1470886813-9220-1-git-send-email-tang.wenjun3@zte.com.cn>
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
Cc: dm-devel@redhat.com, 10144149 <tang.wenjun3@zte.com.cn>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

From: 10144149 <tang.wenjun3@zte.com.cn>

when multipathd is processing add path1 uevent, just then do reconfigure,
There may be two path1 in pathvec.

Signed-off-by: 10144149 <tang.wenjun3@zte.com.cn>
---
 multipathd/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f5e9a01..126ca2b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -650,9 +650,8 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 			}
 		}
 	}
-	lock_cleanup_pop(vecs->lock);
 	if (pp)
-		return ret;
+		goto out;
 
 	/*
 	 * get path vital state
@@ -662,14 +661,14 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 				       DI_ALL, &pp);
 	put_multipath_config(conf);
 	if (!pp) {
-		if (ret == PATHINFO_SKIPPED)
-			return 0;
+		if (ret == PATHINFO_SKIPPED){
+			ret = 0;
+			goto out;
+		}
 		condlog(3, "%s: failed to get path info", uev->kernel);
-		return 1;
+		ret = 1;
+		goto out;
 	}
-	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
-	pthread_testcancel();
 	ret = store_path(vecs->pathvec, pp);
 	if (!ret) {
 		conf = get_multipath_config();
@@ -683,6 +682,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		free_path(pp);
 		ret = 1;
 	}
+out:
 	lock_cleanup_pop(vecs->lock);
 	return ret;
 }
-- 
2.8.1.windows.1
