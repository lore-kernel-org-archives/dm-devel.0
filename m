From: peng.liang5@zte.com.cn
Subject: [PATCH] libmultipath: remove unnecessary condition in
	checker_repair
Date: Mon, 7 Nov 2016 16:57:35 +0800
Message-ID: <1478509055-7648-1-git-send-email-peng.liang5@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, PengLiang <peng.liang5@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: PengLiang <peng.liang5@zte.com.cn>

The checker's validity is an unnecessary checking. It will be checked in checker_selected.

Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
---
 libmultipath/checkers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index fd999b0..05e024f 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -213,7 +213,7 @@ void checker_put (struct checker * dst)
 
 void checker_repair (struct checker * c)
 {
-	if (!c || !checker_selected(c))
+	if (!checker_selected(c))
 		return;
 
 	c->message[0] = '\0';
-- 
2.8.1.windows.1
