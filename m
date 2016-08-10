From: tang.junhui@zte.com.cn
Subject: [PATCH] multipathd: fail path when path check timeout
Date: Wed, 10 Aug 2016 16:10:38 +0800
Message-ID: <1470816638-6404-1-git-send-email-tang.junhui@zte.com.cn>
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

path should be failed when path status is PATH_TIMEOUT after check,
otherwise, the valid number of paths in the map would be increased when
the path status is PATH_UP after the next turn check, which would cause
the valid number of paths exceeding the total number of paths in the map.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f5e9a01..01f1e58 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1585,7 +1585,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		pp->checkint = conf->checkint;
 		put_multipath_config(conf);
 
-		if (newstate == PATH_DOWN || newstate == PATH_SHAKY) {
+		if (newstate == PATH_DOWN || newstate == PATH_SHAKY || newstate == PATH_TIMEOUT) {
 			/*
 			 * proactively fail path in the DM
 			 */
-- 
2.8.1.windows.1
