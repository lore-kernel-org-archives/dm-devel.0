From: tang.junhui@zte.com.cn
Subject: [PATCH] mpathpersist: memset length is wrong
Date: Wed, 21 Sep 2016 16:44:46 +0800
Message-ID: <1474447486-8892-1-git-send-email-tang.junhui@zte.com.cn>
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
To: christophe varoqui <christophe.varoqui@free.fr>, Chauhan@redhat.com, Vijay <Vijay.Chauhan@netapp.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

variable transportids is cleared by memset() with wrong length MPATH_MX_TIDS,
the length should be MPATH_MX_TIDS*sizeof(struct transportid).

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 mpathpersist/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index a55865f..8e8cc35 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -105,7 +105,7 @@ int main (int argc, char * argv[])
 
 	udev = udev_new();
 	conf = mpath_lib_init(udev);
-	memset(transportids,0,MPATH_MX_TIDS);
+	memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct transportid));
 	multipath_conf = conf;
 
 	while (1)
-- 
2.8.1.windows.1
