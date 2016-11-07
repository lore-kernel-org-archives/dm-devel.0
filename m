From: zhou.guichun@zte.com.cn
Subject: [PATCH] libmultipath: fix missing dm_task_destroy() in
	dm_reassign()
Date: Mon, 7 Nov 2016 10:01:17 +0800
Message-ID: <1478484077-9740-1-git-send-email-zhou.guichun@zte.com.cn>
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
Cc: tang.junhui@zte.com.cn, "zhou.guichun" <zhou.guichun@zte.com.cn>, zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "zhou.guichun" <zhou.guichun@zte.com.cn>

dm_task should be destoryed before going out of dm_reassign()

Signed-off-by: zhou.guichun <zhou.guichun@zte.com.cn>
---
 libmultipath/devmapper.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5aea5b6..e9d13b6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1582,10 +1582,9 @@ int dm_reassign(const char *mapname)
 		sysfs_check_holders(dm_dep, dev_t);
 	}
 
-	dm_task_destroy (dmt);
-
 	r = 1;
 out:
+	dm_task_destroy (dmt);
 	return r;
 }
 
-- 
2.8.1.windows.1
