From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add Nexsan NST and UNITY
	families to hwtable
Date: Sat, 26 Nov 2016 03:37:58 +0100
Message-ID: <20161126023758.13346-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c0bfa75..c6fc3d1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -992,6 +992,16 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 15,
 	},
+	{
+		/* NST / UNITY */
+		.vendor        = "Nexsan",
+		.product       = "(NestOS|NST5000)",
+		.hwhandler     = "1 alua",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Xiotech
 	 */
-- 
2.10.2
