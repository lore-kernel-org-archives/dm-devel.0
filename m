From: peng.liang5@zte.com.cn
Subject: [PATCH] libmultipath: safe limit max_fds
Date: Thu, 27 Oct 2016 17:22:52 +0800
Message-ID: <1477560172-8256-1-git-send-email-peng.liang5@zte.com.cn>
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

If user config the max_fds too small to less than actual open files of multipath,
it will occur the error like "/lib/superpath/libchecktur.so: cannot open shared
object file: Too many open files".
So set a safe limit to 4096 when user config max_fds less than 4096.

Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
---
 libmultipath/dict.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7c21e72..7291e0e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -733,6 +733,9 @@ max_fds_handler(struct config *conf, vector strvec)
 	if (conf->max_fds > max_fds)
 		conf->max_fds = max_fds;
 
+	if (conf->max_fds < 4096)
+		conf->max_fds = 4096;
+
 	FREE(buff);
 
 	return r;
-- 
2.8.1.windows.1
