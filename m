From: huang.wei56@zte.com.cn
Subject: [PATCH] add_feature: coredump
Date: Fri, 14 Oct 2016 10:08:00 +0800
Message-ID: <1476410880-7156-1-git-send-email-huang.wei56@zte.com.cn>
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
when we configure device like vendor is COMPELNT in multipath.conf, multipathd will be coredump.

Reasons:
some vonders are not configured features in default_hw. In add_feature, strstr's first parameter *f maybe null.

Signed-off-by: wei.huang <huang.wei56@zte.com.cn>
---
 libmultipath/structs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index fee58e5..41e142f 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -520,6 +520,20 @@ add_feature (char **f, char *n)
 	if (!n || *n == '0')
 		return 0;
 
+	/* default feature is null */
+	if(!*f)
+	{
+		l = strlen("1 ") + strlen(n) + 1;
+		t = MALLOC(l);
+		if (!t)
+			return 1;
+
+		snprintf(t, l, "1 %s", n);
+		*f = t;
+	
+		return 0;
+	}
+
 	/* Check if feature is already present */
 	if (strstr(*f, n))
 		return 0;
-- 
2.8.1.windows.1
