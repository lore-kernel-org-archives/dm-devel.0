From: peng.liang5@zte.com.cn
Subject: [PATCH] libmultipath: remove redundant code in
	store_pathinfo
Date: Wed, 17 Aug 2016 10:05:39 +0800
Message-ID: <1471399539-7420-1-git-send-email-peng.liang5@zte.com.cn>
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
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, peng liang <peng.liang5@zte.com.cn>
List-Id: dm-devel.ids

From: peng liang <peng.liang5@zte.com.cn>

Signed-off-by: peng liang <peng.liang5@zte.com.cn>
---
 libmultipath/discovery.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bb3116d..0017d18 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -95,8 +95,6 @@ store_pathinfo (vector pathvec, struct config *conf,
 		goto out;
 
 	err = store_path(pathvec, pp);
-	if (err)
-		goto out;
 
 out:
 	if (err)
-- 
2.8.1.windows.1
