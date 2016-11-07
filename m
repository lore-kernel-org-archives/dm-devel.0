From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove Pure modifications
Date: Mon,  7 Nov 2016 15:40:32 +0100
Message-ID: <20161107144032.2068-1-xose.vazquez@gmail.com>
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

There is no reason to deviate from standard values.

Default:
 .fast_io_fail	= 5
 .dev_loss 	= 600

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 340035e..6ca9ea2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -899,8 +899,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "PURE",
 		.product       = "FlashArray",
 		.pgpolicy      = MULTIBUS,
-		.fast_io_fail  = 10,
-		.dev_loss      = 60,
 	},
 	/*
 	 * Huawei
-- 
2.10.2
