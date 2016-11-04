From: peng.liang5@zte.com.cn
Subject: [PATCH] libmultipath/checkers/rbd: fix free in
	libcheck_init
Date: Fri, 4 Nov 2016 15:54:29 +0800
Message-ID: <1478246069-3448-1-git-send-email-peng.liang5@zte.com.cn>
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

There is an incorrect free maybe causing memory leak.

Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
---
 libmultipath/checkers/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 481d860..9ea0572 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -174,7 +174,7 @@ int libcheck_init(struct checker * c)
 
 	ct->image = strdup(image);
 	if (!ct->image)
-		goto free_info;
+		goto free_username;
 
 	pool = udev_device_get_sysattr_value(bus_dev, "pool");
 	if (!pool)
-- 
2.8.1.windows.1
