From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH 5/6] vector: add lower boundary check in
 vector_foreach_slot_after
Date: Sun, 16 Aug 2020 09:45:49 +0800
Message-ID: <df68c7c3-2b86-ce72-62e9-c43ef80a2bc8@huawei.com>
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
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


In vector_foreach_slot_after macro, i is the input var, which
may have a illegal value (i < 0). So we should add lower boundary
check in vector_foreach_slot_after macro.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/vector.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 2862dc2..45dbfc1 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -38,11 +38,11 @@ typedef struct _vector *vector;
 #define VECTOR_LAST_SLOT(V)   (((V) && VECTOR_SIZE(V) > 0) ? (V)->slot[(VECTOR_SIZE(V) - 1)] : NULL)

 #define vector_foreach_slot(v,p,i) \
-	for (i = 0; (v) && (int)i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
+	for ((i) = 0; (v) && (int)(i) < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); (i)++)
 #define vector_foreach_slot_after(v,p,i) \
-	for (; (v) && (int)i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
+	for (; (v) && (int)(i) < VECTOR_SIZE(v) && (int)(i) >= 0 && ((p) = (v)->slot[i]); (i)++)
 #define vector_foreach_slot_backwards(v,p,i) \
-	for (i = VECTOR_SIZE(v) - 1; (int)i >= 0 && ((p) = (v)->slot[i]); i--)
+	for ((i) = VECTOR_SIZE(v) - 1; (int)(i) >= 0 && ((p) = (v)->slot[i]); (i)--)

 #define identity(x) (x)
 /*
-- 
1.8.3.1
