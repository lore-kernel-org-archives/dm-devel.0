From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] devmapper: remove useless using of memset in
 dm_get_info func
Date: Thu, 30 Jul 2020 22:06:35 +0800
Message-ID: <0cbfeea7-5f30-a148-555b-19af2429c32c@huawei.com>
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
To: bmarzins@redhat.com, christophe.varoqui@opensvc.com, Martin Wilck <mwilck@suse.com>
Cc: linfeilong <linfeilong@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


In dm_get_info func, if do_get_info fails, we donot need to
call memset to assign 0 to *dmi which will be freed.

Here, we remove the useless using of memset in dm_get_info func.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 libmultipath/devmapper.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f597ff8b..00ee0dfc 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1464,7 +1464,6 @@ dm_get_info (const char * mapname, struct dm_info ** dmi)
 		return 1;

 	if (do_get_info(mapname, *dmi) != 0) {
-		memset(*dmi, 0, sizeof(struct dm_info));
 		FREE(*dmi);
 		*dmi = NULL;
 		return 1;
-- 
2.24.0.windows.2
