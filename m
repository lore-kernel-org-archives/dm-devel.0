From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH 1/6] checker: remove useless name check in
	checker_get func
Date: Sun, 16 Aug 2020 09:42:05 +0800
Message-ID: <2d9db95b-bb88-0d22-1c2d-df459415ee3d@huawei.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmarzins@redhat.com, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids


In checker_get func, input name will be checked before
calling checker_class_lookup func, in which name will
also be checked.

Here, we just remove useless input name check in checker_get func.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/checkers.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index f7ddd53..ac41d64 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -361,11 +361,10 @@ void checker_get(const char *multipath_dir, struct checker *dst,
 	if (!dst)
 		return;

-	if (name && strlen(name)) {
-		src = checker_class_lookup(name);
-		if (!src)
-			src = add_checker_class(multipath_dir, name);
-	}
+	src = checker_class_lookup(name);
+	if (!src)
+		src = add_checker_class(multipath_dir, name);
+
 	dst->cls = src;
 	if (!src)
 		return;
-- 
1.8.3.1
