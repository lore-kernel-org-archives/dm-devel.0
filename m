From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [dm- devel][PATCH] vector: fix upper boundary check of
 vector size in vector_del_slot
Date: Mon, 3 Aug 2020 10:39:29 +0800
Message-ID: <94c8222f-a941-dee3-54eb-f243fd28b85a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, christophe.varoqui@opensvc.com, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids


In vector_del_slot func, legal value of input slot is in range of
[0, VECTOR_SIZE(v)), it means slot value should be less then VECTOR_SIZE(v).


Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 libmultipath/vector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index 501cf4c5..5b047e40 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -109,7 +109,7 @@ vector_del_slot(vector v, int slot)
 {
 	int i;

-	if (!v || !v->allocated || slot < 0 || slot > VECTOR_SIZE(v))
+	if (!v || !v->allocated || slot < 0 || slot >= VECTOR_SIZE(v))
 		return;

 	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
-- 
2.24.0.windows.2
