From: huang.wei56@zte.com.cn
Subject: [PATCH] hwe_regmatch: match error
Date: Fri, 14 Oct 2016 10:03:51 +0800
Message-ID: <1476410631-7840-1-git-send-email-huang.wei56@zte.com.cn>
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
Cc: tang.junhui@zte.com.cn, "wei.huang" <huang.wei56@zte.com.cn>, zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "wei.huang" <huang.wei56@zte.com.cn>

Problem:
when we configure a device like vendor, product, revision all null in multipath.conf, hwe_regmatch always return 0.

Reasons:
\!hwe2->vendor, \!hwe2->product and \!hwe2->revision are all true.

Signed-off-by: wei.huang <huang.wei56@zte.com.cn>
---
 libmultipath/config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a48b8af..d99cd75 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -80,7 +80,8 @@ hwe_regmatch (struct hwentry *hwe1, struct hwentry *hwe2)
 	    regcomp(&rre, hwe1->revision, REG_EXTENDED|REG_NOSUB))
 		goto out_pre;
 
-	if ((!hwe1->vendor || !hwe2->vendor ||
+	if ((hwe2->vendor || hwe2->product || hwe2->revision) &&
+	    (!hwe1->vendor || !hwe2->vendor ||
 	     !regexec(&vre, hwe2->vendor, 0, NULL, 0)) &&
 	    (!hwe1->product || !hwe2->product ||
 	     !regexec(&pre, hwe2->product, 0, NULL, 0)) &&
-- 
2.8.1.windows.1
