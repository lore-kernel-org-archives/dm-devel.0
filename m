From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove -FAILBACK_IMMEDIATE from
	NEXENTA/COMSTAR
Date: Mon,  1 Aug 2016 18:44:37 +0200
Message-ID: <1470069877-9423-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Because there is no prio.

Cc: Yacine Kheddache <yacine@alyseo.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e95db96..127275d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -586,7 +586,7 @@ static struct hwentry default_hw[] = {
 		.product       = "COMSTAR",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_SERIAL,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 30,
 		.minio         = 128,
 	},
-- 
2.7.4
