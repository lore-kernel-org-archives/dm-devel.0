From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/5] multipath-tools: delete no_path_retry
	attribute when it is equal to default value
Date: Sat, 23 Jul 2016 02:29:08 +0200
Message-ID: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Defaul value is already 0 (NO_PATH_RETRY_UNDEF)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a1fc3e8..8eec209 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -708,7 +708,6 @@ static struct hwentry default_hw[] = {
 		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.fast_io_fail  = 10,
-		.no_path_retry = 0,
 		.dev_loss      = 60,
 	},
 	{
-- 
2.7.4
